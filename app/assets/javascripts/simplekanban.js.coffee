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
        tags = story.tag_list.join(', ')
        story_element = $("<li><div class='box box_#{state}'><b>#{story.name}</b><br/>#{tags}</div></li>")
        story_element.data "story", story
        list.append story_element

    list


  create_column = (board, state, headline) ->
    queueClass = if /_Q$/.test(state) then " queue_column" else ""

    state_column = $("<div class='column #{queueClass}'></div>")
      .append("<h2>#{headline}</h2>")
      .append(create_list board, state)
      .data("state", state)


  create_board = (app_data) ->
    table = $("<div id='board'></div>")

    for state in app_data.states_order
      unless /_Q$/.test(state)
        queue_state = "#{state}_Q"

        queue_state_column = create_column(app_data.board, queue_state, app_data.states[state] + " Ready")
        state_column = create_column(app_data.board, state, app_data.states[state])

        table
          .append(queue_state_column)
          .append(state_column)

    $(".column>ul", table).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "box-placeholder"
      stop: update_story_status
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
