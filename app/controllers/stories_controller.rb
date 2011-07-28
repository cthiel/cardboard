class StoriesController < ApplicationController
  # GET /stories
  # GET /stories.json
  def index
    @last_modified_story = Story.find(:first, :order => 'updated_at DESC')

    if stale?(:last_modified => @last_modified_story.updated_at.utc, :etag => @last_modified_story)
      @stories = Story.all(:include => :status)
      respond_to do |format|
        format.html # index.html.haml
        format.json  { render :json => @stories.to_json(:methods => [:status_code, :tag_list]) }
      end
    end
  end

  # GET /stories/1
  def show
    @story = Story.find(params[:id], :include => :status)

    respond_to do |format|
      format.html # show.html.haml
    end
  end

  # GET /stories/new
  def new
    @story = Story.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id], :include => :status)

    respond_to do |format|
      format.html # edit.html.haml
      format.js   # edit.js.haml
    end
  end

  # POST /stories
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to(@story, :notice => 'Story was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /stories/1
  def update
    @story = Story.find(params[:id])
    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to(@story, :notice => 'Story was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url) }
    end
  end
end
