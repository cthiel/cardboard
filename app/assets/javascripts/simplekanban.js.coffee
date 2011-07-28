$ = jQuery

$ ->
  app_data = {}


  init_app = ->
    init_states()


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


  create_list = (board, state) ->
    list = $("<ul class='state' id='status#{app_data.states_ids[state]}'></ul>")

    if board[state]
      for story in board[state]
        tags = story.tag_list.sort().join(', ')

        story_element = $("<li><div class='box box_#{state}' data-story_id='#{story.id}'><b>#{story.name}</b><br/>#{tags}</div></li>")

        story_element
          .data("story", story)
          .delegate 'div', 'dblclick', ->
            show_edit_dialog(story)

        list.append story_element

    list


  # Create a functional edit dialog
  show_edit_dialog = (story) ->
    $form = null

    # Our lovely submit handler
    _submit = (e) ->
      # Handle the submit via ajax
      $.post($form.attr('action'), $form.serialize())
        .complete ->
          $dialog.remove()
          init_stories() # Refresh the stories!

      e.preventDefault() # Don't do the default submit action

    # The actual dialog object, stored in a var for reference
    $dialog = $("<div/>").dialog
      title: "Editing item #{story.id}"
      width: "50%"
      position: [$(window).width() / 4, $(window).height() / 5]
      modal: true

      buttons:
        "Cancel"        : -> $dialog.remove()
        "Update Story"  : _submit

      close: -> $dialog.remove()

      create: ->
        # Add content from the edit page
        $('.ui-dialog-content', $dialog)
          .load "/stories/#{story.id}/edit #edit-form", ->
            $('#edit-form').hide().slideDown 200, ->
              # Preselect the name field
              $("#story_name", $dialog).select()
              # Capture the $form object & set the submit handler
              $form = $('form', $dialog).submit _submit


  create_column = (board, state, headline) ->
    queueClass = if /_Q$/.test(state) then " queue_column" else ""

    state_column = $("<div class='column #{queueClass}'></div>")
      .append("<h2>#{headline}</h2>")
      .append(create_list board, state)
      .data("state", state)


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
    .disableSelection()

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


  init_app()
