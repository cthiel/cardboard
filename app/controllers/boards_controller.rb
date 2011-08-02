class BoardsController < ApplicationController
  # GET /projects/default
  def show
    redirect_to project_url('default') and return unless params[:id] == 'default'

    @project = "Default"

    respond_to do |format|
      format.html # show.html.haml
    end
  end
end