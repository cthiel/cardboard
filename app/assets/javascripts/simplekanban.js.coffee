@kanban = (($)->
  app_data = {}


  init_states = ->
    $.getJSON "/statuses.json", (status_data) ->
      states = {}
      states_ids = {}
      states_order = []

      for datum in status_data
        state = datum.status
        states[state.code] = state.name
        states_ids[state.code] = state.id
        states_order.push state.code

      app_data.states = states
      app_data.states_ids = states_ids
      app_data.states_order = states_order

      init_stories()


  init_stories = (stories) ->
    board = {}

    $.getJSON "/stories.json", (stories_data) ->

      for datum in stories_data
        story = datum.story
        state = story.status_code
        board[state] = [] unless board[state]
        board[state].push story

      app_data.board = board

      create_board app_data


  watch_mouse = ->
    $(document).mousemove ->
      reset_polling()


  start_polling = ->
    app_data.poll = setInterval ->
      check_status() if !app_data.dialog
      return
    , 5000


  stop_polling = ->
    clearInterval(app_data.poll)
    return


  reset_polling = ->
    stop_polling()
    start_polling()
    return


  check_status = ->
    _head = (state) ->
      $.ajax "/#{state.url}.json",
        type: "HEAD"
        complete: (xhr, status) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          state.func() if app_data[state.obj]? and app_data[state.obj] != mod
          app_data[state.obj] = mod

    _head {} = url: "statuses", obj: "status_mod", func: init_states
    _head {} = url: "stories",  obj: "story_mod",  func: init_stories

    return


  clear_status = ->
    app_data.story_mod = app_data.status_mod = undefined


  create_list = (board, state) ->
    list = $("<ul class='state' id='status#{app_data.states_ids[state]}'></ul>")

    if board[state]
      for story in board[state]
        tags = story.tag_list.sort().join(', ')

        story_element = $("<li><div class='box box_#{state}' data-story_id='#{story.id}'><b>#{story.name}</b><br/>#{tags}</div></li>")

        story_element.data("story", story)

        list.append story_element

    list


  show_edit_dialog = (story) ->
    create_dialog
      title: "Editing story: #{story.name}"
      url:   "/stories/#{story.id}/edit"
      id:    "#edit-form"


  show_new_dialog = (state) ->
    create_dialog
      title: "Add a new story"
      url:   "/stories/new"
      id:    "#new-form"
      state: state


  # Create a dialog
  create_dialog = (opt) ->
    $form = null
    app_data.dialog = true

    _close_dialog = ->
      app_data.dialog = false
      $dialog.remove()

    _submit = (e) ->
      # Handle the submit via ajax
      $.post($form.attr('action'), $form.serialize())
        .complete ->
          _close_dialog()
          init_stories() # Refresh the stories!

      e.preventDefault() # Don't do the default HTML submit action

    # The actual dialog object, stored in a var for reference
    $dialog = $("<div><div class='loading'>Loading...</div></div>").dialog
      title: opt.title
      width: "50%"
      position: [$(window).width() / 4, $(window).height() / 5]
      modal: true

      buttons:
        "Cancel" : _close_dialog
        "Save"   : _submit # this text is replaced later

      close: _close_dialog

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


  create_column = (board, state, headline) ->
    queueClass = if /_Q$/.test(state) then " queue_column" else ""

    state_column = $("<div class='column #{queueClass}'></div>")
      .append("<h2>#{headline}</h2>")
      .append(create_list board, state)
      .data("state", state)
      .delegate 'li', 'dblclick', (e) ->
        show_edit_dialog $(this).data 'story'
      .delegate 'ul', 'dblclick', (e) ->
        # Delegation isn't working right for the UL, oddly, so check it
        show_new_dialog headline if $(e.target).is('ul')



  create_board = (app_data) ->
    table = $("<div id='board'></div>")

    for state in app_data.states_order
      state_column = create_column(app_data.board, state, app_data.states[state])

      table
        .append(state_column)

    $(".column>ul", table).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "box-placeholder"
      stop: update_story_status
      distance: 6
      opacity: 0.7

    $(".column", table).disableSelection()

    display_board table


  display_board = (board_table) ->
    $("#output").html board_table


  update_story_status = (e, drag) ->
    $item = drag.item
    story_id = $item.data("story").id
    status_id = $item.parent()[0].id.replace('status','')

    $.ajax
      type: "PUT"
      url: "stories/#{story_id}"
      data: "story[status_id]=#{status_id}"
      complete: clear_status


  init: ->
    init_states()
    watch_mouse()
    start_polling()


)(jQuery)


jQuery ->
  kanban.init()
