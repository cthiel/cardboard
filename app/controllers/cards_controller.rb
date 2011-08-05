class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    @last_modified = Card.order("updated_at DESC").first

    if stale?(:last_modified => @last_modified.try(:updated_at).try(:utc), :etag => @last_modified)
      @cards = Card.all(:include => :deck, :order => 'updated_at ASC')
      respond_to do |format|
        format.html # index.html.haml
        format.json  { render :json => @cards.to_json(:methods => [:tag_list]) }
      end
    end
  end

  # GET /cards/1
  def show
    @card = Card.find(params[:id], :include => :deck)

    respond_to do |format|
      format.html # show.html.haml
    end
  end

  # GET /cards/new
  def new
    @card = Card.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id], :include => :deck)
  end

  # POST /cards
  def create
    @card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to(@card, :notice => 'Card was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /cards/1
  def update
    @card = Card.find(params[:id])
    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to(@card, :notice => 'Card was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @card.errors, :deck => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  def destroy
    @card = Card.find(params[:id])
    if @card.destroy
      respond_to do |format|
        format.html { redirect_to(cards_url, :notice => 'Card was deleted.') }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.json { render :json => @card.errors, :deck => :unprocessable_entity }
      end
    end
  end
end
