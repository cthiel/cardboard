class StatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.json
  # GET /statuses.css
  def index
    @last_modified_status = Status.find(:first, :order => 'updated_at DESC')
    
    if stale?(:last_modified => @last_modified_status.updated_at.utc, :etag => @last_modified_status)
      @statuses = Status.all

      respond_to do |format|
        format.html # index.html.haml
        format.json  { render :json => @statuses }
        format.css  # index.css.erb
      end
    end
  end

  # GET /statuses/1
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
    end
  end

  # GET /statuses/new
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to(@status, :notice => 'Status was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /statuses/1
  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to(@status, :notice => 'Status was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /statuses/1
  def destroy
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_url) }
    end
  end
end
