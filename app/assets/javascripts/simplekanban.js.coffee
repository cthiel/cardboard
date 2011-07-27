$ = jQuery

$ ->
  app_data = {}


  init_app = ->
    init_states()


  init_states = ->
    $.getJSON "/statuses.json", (status_data) ->
      states = {}
      states_order = []

      for datum in status_data
        state = datum.status
        states[state.code] = state.name
        states_order.push state.code

      app_data.states = states
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
    list = $("<ul class='state' id='#{state}'></ul>")

    if board[state]
      for story in board[state]
        story_element = $("<li><div class='box box_#{state}'>#{story.number} #{story.name}</div></li>")
        story_element.data "story", story
        list.append story_element

    list


  create_column = (board, state, headline) ->
    queueClass = if /_Q$/.test(state) then " queue_column" else ""

    state_column = $("<div class='dp10 #{queueClass}'></div>")
      .append("<div class='headline'>#{headline}</div>")
      .append(create_list board, state)
      .data("state", state)


  create_board = (app_data) ->
    table = $("<div id='board'></div>")
    ids = []

    for state in app_data.states_order
      unless /_Q$/.test(state)
        queue_state = "#{state}_Q"

        ids.push "##{queue_state}"
        ids.push "##{state}"

        queue_state_column = create_column(app_data.board, queue_state, app_data.states[state] + " Ready")
        state_column = create_column(app_data.board, state, app_data.states[state])

        table
          .append(queue_state_column)
          .append(state_column)

    $(ids.join(), table).dragsort
      dragBetween: true
      dragEnd: update_story_status

    display_board table


  display_board = (board_table) ->
    $("#output").html board_table


  update_story_status = ->
    story_id = $(this).data("story").id
    story_status = $(this).parent()[0].id

    $.ajax
      type: "PUT"
      url: "stories/#{story_id}"
      data: "story[status_code]=#{story_status}"


  init_app()
