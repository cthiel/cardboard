@cardboard = (($)->
  appData = {}

  converter = new Attacklab.showdown.converter()

  initStates = ->
    appData =
      states     : {}
      statesOrder: []

    $.getJSON "/statuses.json", (statusData) ->

      for datum in statusData
        state = datum.status
        appData.states[state.id] = state.name
        appData.statesOrder.push state.id

      initStories()


  initStories = (stories) ->
    board = appData.board = {}

    $.getJSON "/stories.json", (storiesData) ->

      for datum in storiesData
        state = datum.story.status_id
        board[state] ?= []
        board[state].push datum.story

      createBoard appData


  watchMouse = ->
    $(document).mousemove ->
      resetPolling()


  startPolling = ->
    appData.poll = setInterval ->
      checkStatus() if !appData.dialog
      return
    , 5000


  stopPolling = ->
    clearInterval(appData.poll)
    return


  resetPolling = ->
    stopPolling()
    startPolling()
    return


  checkStatus = ->
    # jQuery doesn't have $.head(), but we can use $.ajax()
    _head = (state) ->
      $.ajax "/#{state.url}.json",
        type: "HEAD"
        complete: (xhr, status) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          # run the callback if data has been modified since last check
          state.func() if appData[state.obj]? and appData[state.obj] != mod
          # save the last modified date
          appData[state.obj] = mod

    # check both statuses & stories for updates
    _head {} = url: "statuses", obj: "statusMod", func: initStates
    _head {} = url: "stories",  obj: "storyMod",  func: initStories

    return


  clearStatus = ->
    appData.storyMod = appData.statusMod = undefined


  createList = (board, state) ->
    
    $list = $ "<ul class='state' id='status_#{state}'></ul>"

    if board[state]
      for story in board[state]
        tags = story.tag_list.sort().join(', ')
        story.markdown = converter.makeHtml(story.name)

        $storyElement = $ """
          <li>
            <div class='box box_#{state}' data-story-id='#{story.id}'>
              #{story.markdown}
              <br>#{tags}
            </div>
          </li>
          """

        $storyElement.data "story", story

        $list.append $storyElement

    $list


  showEditDialog = (story) ->
    createDialog
      title: "Editing story: #{story.name}"
      url:   "/stories/#{story.id}/edit"
      id:    "#edit-form"


  showNewDialog = (state) ->
    createDialog
      title: "Add a new story"
      url:   "/stories/new"
      id:    "#new-form"
      state: state


  # Create a dialog
  createDialog = (opt) ->
    $form = null
    appData.dialog = true

    _closeDialog = ->
      appData.dialog = false
      $dialog.remove()

    _submit = (e) ->
      # Handle the submit via ajax
      $.post($form.attr('action'), $form.serialize())
        .complete ->
          _closeDialog()
          initStories() # Refresh the stories!

      e.preventDefault() # Don't do the default HTML submit action

    # The actual dialog object, stored in a var for reference
    $dialog = $("<div><div class='loading'>Loading...</div></div>").dialog
      title: opt.title
      width: "50%"
      position: [$(window).width() / 4, $(window).height() / 5]
      modal: true

      buttons:
        "Cancel" : _closeDialog
        "Save"   : _submit # this text is replaced later

      close: _closeDialog

      create: ->
        $buttons = $('.ui-dialog-buttonpane', $dialog).hide()

        # Add content from the edit page
        $('.ui-dialog-content', $dialog)
          .load "#{opt.url} #{opt.id}", (data, foo) ->
            $form = $('form', $dialog)

            # Sync button with page's default submit button
            buttonText = $('input[type="submit"]:last',this).val()
            $('button:last', $buttons).text(buttonText) if buttonText

            # If the state is passed in (new story), select it
            if opt.state
              $("option", $form).map (i, el) ->
                el if el.text.match "^#{opt.state}$"
              .attr "selected", true

            $buttons.slideDown 200

            $(opt.id).hide().slideDown 200, ->
              # Preselect the name field
              $('input[type="text"]:first', $dialog).select()

              $form
                # Set the submit handler
                .submit(_submit)
                # Handle enter
                .delegate 'input', 'keydown', (e) ->
                  _submit(e) if e.keyCode == 13


  createColumn = (board, state, headline) ->
    queueClass = if /Q$/.test(state) then " queue_column" else ""

    $("<div class='column #{queueClass}'></div>")
      .append("<h2>#{headline}</h2>")
      .append(createList board, state)
      .data("state", state)
      .delegate 'li', 'dblclick', (e) ->
        showEditDialog $(this).data 'story'
      .delegate 'ul', 'dblclick', (e) ->
        # Delegation isn't working right for the UL, oddly, so check it
        showNewDialog headline if $(e.target).is('ul')



  createBoard = (appData) ->
    $table = $ "<div id='board'></div>"

    for state in appData.statesOrder
      stateColumn = createColumn(appData.board, state, appData.states[state])

      $table.append(stateColumn)

    $(".column>ul", $table).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "box-placeholder"
      stop: updateStoryStatus
      distance: 6
      opacity: 0.7

    $(".column", $table).disableSelection()

    displayBoard $table


  displayBoard = (boardTable) ->
    $("#output").html boardTable


  updateStoryStatus = (e, drag) ->
    $item = drag.item
    $box = $item.find '.box'
    storyId = $item.data("story").id
    statusId = $item.parent()[0].id.replace('status_','')

    $box.addClass "unsaved"

    $.ajax
      type: "PUT"
      url: "stories/#{storyId}"
      data: "story[status_id]=#{statusId}"
      complete: ->
        $box.removeClass "unsaved"
        clearStatus()


  ### Public functions ###

  init: ->
    initStates()
    watchMouse()
    startPolling()


)(jQuery)


jQuery ->
  cardboard.init()
