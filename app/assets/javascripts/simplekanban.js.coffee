@kanban = (($)->
  appData = {}


  initStates = ->
    $.getJSON "/statuses.json", (statusData) ->
      states = {}
      statesIds = {}
      statesOrder = []

      for datum in statusData
        state = datum.status
        states[state.code] = state.name
        statesIds[state.code] = state.id
        statesOrder.push state.code

      appData.states = states
      appData.statesIds = statesIds
      appData.statesOrder = statesOrder

      initStories()


  initStories = (stories) ->
    board = {}

    $.getJSON "/stories.json", (storiesData) ->

      for datum in storiesData
        story = datum.story
        state = story.status_code
        board[state] = [] unless board[state]
        board[state].push story

      appData.board = board

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
    _head = (state) ->
      $.ajax "/#{state.url}.json",
        type: "HEAD"
        complete: (xhr, status) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          state.func() if appData[state.obj]? and appData[state.obj] != mod
          appData[state.obj] = mod

    _head {} = url: "statuses", obj: "statusMod", func: initStates
    _head {} = url: "stories",  obj: "storyMod",  func: initStories

    return


  clearStatus = ->
    appData.storyMod = appData.statusMod = undefined


  createList = (board, state) ->
    $list = $ "<ul class='state' id='status#{appData.statesIds[state]}'></ul>"

    if board[state]
      for story in board[state]
        tags = story.tag_list.sort().join(', ')

        $storyElement = $ """
          <li>
            <div class='box box_#{state}' data-story-id='#{story.id}'>
              <b>#{story.name}</b>
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
      $.post $form.attr('action'), $form.serialize()
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
              options = $('option', $form).map -> $(this).text()
              $('select', $form).val $.inArray(opt.state, options) + 1

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

      $table
        .append(stateColumn)

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
    storyId = $item.data("story").id
    statusId = $item.parent()[0].id.replace('status','')

    $.ajax
      type: "PUT"
      url: "stories/#{storyId}"
      data: "story[status_id]=#{statusId}"
      complete: clearStatus


  ### Public functions ###

  init: ->
    initStates()
    watchMouse()
    startPolling()


)(jQuery)


jQuery ->
  kanban.init()
