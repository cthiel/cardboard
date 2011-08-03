class BoardsController < ApplicationController
  # GET /projects
  def index
    render :show
  end
  
  # GET /projects/id
  def show
    @board = Board.find(params[:id], :include => :decks) || Board.first

    respond_to do |format|
      format.html # show.html.haml
    end
  end
end