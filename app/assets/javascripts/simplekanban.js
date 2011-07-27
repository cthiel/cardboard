$(document).ready(function(){

var app_data = {};

var init_app = function(){
  init_states();
}

var init_states = function() {
  $.getJSON("/statuses.json",function(status_data){
    var states = {};
    var states_order = [];
    for ( var i=0; i<status_data.length; i++ ) {
      var state = status_data[i]['status'];
      states[state.code] = state.name;
      states_order.push(state.code);
    }
    app_data['states'] = states;
    app_data['states_order'] = states_order
    init_stories();
  });
}

var init_stories = function(stories) {
  var board = {}
  $.getJSON("/stories.json",function(stories_data){
    for ( var i=0; i<stories_data.length; i++ ) {
      var story = stories_data[i]['story'];
      var state = story.status_code;
      if (! board[state]) {
        board[state] = [];
      }
      board[state].push(story);
    }
    app_data['board'] = board;
    create_board(app_data);
  });
}

var create_list = function(board, state) {
  var list = $("<ul class=\"state\" id=\"" + state + "\"></ul>");
  if (board[state]) {
    for (var i=0, len=board[state].length; i<len; i++) {
      var story = board[state][i];
      var story_element = $("<li><div class=\"box box_" + state  + "\">" + story.number + " " + story.name + "</div></li>");
      story_element.data("story",  story);
      list.append(story_element);
    }
  }
  return list;
}

var create_column = function(board, state, headline) {
  var state_column = $("<div class=\"dp10" + ((! /_Q$/.test(state)) ? "" : " queue_column")+ "\"></div>")
  state_column.append($("<div class=\"headline\">" + headline + "</div>"));
  state_column.append(create_list(board, state));
  state_column.data("state", state);
  return state_column;
}

var create_board = function(app_data) {
  var table = $("<div id=\"board\"></div>");
  var ids = "";
  for (j=0; j< app_data.states_order.length; j++) {
    var state = app_data.states_order[j]
    if (! /_Q$/.test(state)) {
      var queue_state = state + "_Q";
      ids += "#" + queue_state + ",";
        var queue_state_column = create_column(app_data.board, queue_state, app_data.states[state] + " Ready")
      table.append(queue_state_column)

      ids += "#" + state + ","
      var state_column = create_column(app_data.board, state, app_data.states[state])
      table.append(state_column)
    }
  }
  $(ids, table).dragsort({ dragBetween: true, dragEnd: update_story_status});
  display_board(table);
}

var display_board = function(board_table){
  $("#output").empty();
  $("#output").append(board_table);
}

var update_story_status = function(){
  var story_id = $(this).data('story').id;
  var story_status = $(this).parent()[0].id;
  var story_url = "stories/" + story_id;
  var story_data = "story[status_code]=" + story_status;
  $.ajax({
    url: story_url,
    data: story_data,
    type: 'PUT',
    success: function() {}
  });
}

init_app();

});
