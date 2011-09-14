class BoardsController < ApplicationController
  # GET /board-slug or /
  def show
    if params[:id]
      @board = Board.find(params[:id])
    else
      @board = Board.first
    end

    respond_to do |format|
      format.html # show.html.haml
    end
  end
end