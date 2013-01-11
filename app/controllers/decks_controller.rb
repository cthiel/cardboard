# -*- encoding : utf-8 -*-
class DecksController < ApplicationController
  # GET /decks
  # GET /decks.json
  # GET /decks.css
  def index
    @last_modified = Deck.unscoped.order("updated_at DESC").first
    
    if stale?(:last_modified => @last_modified.try(:updated_at), :etag => @last_modified)
      @decks = Deck.all

      respond_to do |format|
        format.html # index.html.haml
        format.json  { render :json => @decks }
        format.css  # index.css.erb
      end
    end
  end

  # GET /decks/1
  def show
    @deck = Deck.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
    end
  end

  # GET /decks/new
  def new
    @deck = Deck.new

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = Deck.find(params[:id])
  end

  # POST /decks
  def create
    @deck = Deck.new(params[:deck])

    respond_to do |format|
      if @deck.save
        format.html { redirect_to(@deck, :notice => 'Deck was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /decks/1
  def update
    @deck = Deck.find(params[:id])

    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        format.html { redirect_to(@deck, :notice => 'Deck was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /decks/1
  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to(decks_url) }
    end
  end
end
