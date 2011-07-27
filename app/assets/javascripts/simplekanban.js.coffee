$ = jQuery

$ ->
  app_data = {}
  init_app = ->
    init_states()

  init_states = ->
    $.getJSON "/statuses.json", (status_data) ->
      states = {}
      states_order = []
      i = 0

      while i < status_data.length
        state = status_data[i].status
        states[state.code] = state.name
        states_order.push state.code
        i++

      app_data.states = states
      app_data.states_order = states_order
      init_stories()

  init_stories = (stories) ->
    board = {}
    $.getJSON "/stories.json", (stories_data) ->
      i = 0

      while i < stories_data.length
        story = stories_data[i].story
        state = story.status_code
        board[state] = [] unless board[state]
        board[state].push story
        i++

      app_data.board = board
      create_board app_data

  create_list = (board, state) ->
    list = $("<ul class=\"state\" id=\"" + state + "\"></ul>")

    if board[state]
      i = 0
      len = board[state].length

      while i < len
        story = board[state][i]
        story_element = $("<li><div class=\"box box_" + state + "\">" + story.number + " " + story.name + "</div></li>")
        story_element.data "story", story
        list.append story_element
        i++

    list

  create_column = (board, state, headline) ->
    state_column = $("<div class=\"dp10" + (if (not /_Q$/.test(state)) then "" else " queue_column") + "\"></div>")
    state_column.append $("<div class=\"headline\">" + headline + "</div>")
    state_column.append create_list(board, state)
    state_column.data "state", state
    state_column

  create_board = (app_data) ->
    table = $("<div id=\"board\"></div>")
    ids = ""
    j = 0

    while j < app_data.states_order.length
      state = app_data.states_order[j]
      unless /_Q$/.test(state)
        queue_state = state + "_Q"
        ids += "#" + queue_state + ","
        queue_state_column = create_column(app_data.board, queue_state, app_data.states[state] + " Ready")
        table.append queue_state_column
        ids += "#" + state + ","
        state_column = create_column(app_data.board, state, app_data.states[state])
        table.append state_column
      j++

    $(ids, table).dragsort
      dragBetween: true
      dragEnd: update_story_status

    display_board table

  display_board = (board_table) ->
    $("#output").empty()
    $("#output").append board_table

  update_story_status = ->
    story_id = $(this).data("story").id
    story_status = $(this).parent()[0].id
    story_url = "stories/" + story_id
    story_data = "story[status_code]=" + story_status

    $.ajax
      url: story_url
      data: story_data
      type: "PUT"
      success: ->

  init_app()
