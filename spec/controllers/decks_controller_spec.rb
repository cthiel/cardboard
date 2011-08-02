require 'spec_helper'

describe DecksController do

  # This should return the minimal set of attributes required to create a valid
  # Deck. As you add validations to Deck, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name  => 'Development',
      :color => '#000000' }
  end

  describe "GET index" do
    it "assigns all decks as @decks" do
      deck = Deck.create! valid_attributes
      get :index
      assigns(:decks).should eq([deck])
    end
  end

  describe "GET show" do
    it "assigns the requested deck as @deck" do
      deck = Deck.create! valid_attributes
      get :show, :id => deck.id.to_s
      assigns(:deck).should eq(deck)
    end
  end

  describe "GET new" do
    it "assigns a new deck as @deck" do
      get :new
      assigns(:deck).should be_a_new(Deck)
    end
  end

  describe "GET edit" do
    it "assigns the requested deck as @deck" do
      deck = Deck.create! valid_attributes
      get :edit, :id => deck.id.to_s
      assigns(:deck).should eq(deck)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Deck" do
        expect {
          post :create, :deck => valid_attributes
        }.to change(Deck, :count).by(1)
      end

      it "assigns a newly created deck as @deck" do
        post :create, :deck => valid_attributes
        assigns(:deck).should be_a(Deck)
        assigns(:deck).should be_persisted
      end

      it "redirects to the created deck" do
        post :create, :deck => valid_attributes
        response.should redirect_to(Deck.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved deck as @deck" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deck.any_instance.stub(:save).and_return(false)
        post :create, :deck => {}
        assigns(:deck).should be_a_new(Deck)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Deck.any_instance.stub(:save).and_return(false)
        post :create, :deck => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested deck" do
        deck = Deck.create! valid_attributes
        # Assuming there are no other decks in the database, this
        # specifies that the Deck created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Deck.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => deck.id, :deck => {'these' => 'params'}
      end

      it "assigns the requested deck as @deck" do
        deck = Deck.create! valid_attributes
        put :update, :id => deck.id, :deck => valid_attributes
        assigns(:deck).should eq(deck)
      end

      it "redirects to the deck" do
        deck = Deck.create! valid_attributes
        put :update, :id => deck.id, :deck => valid_attributes
        response.should redirect_to(deck)
      end
    end

    describe "with invalid params" do
      it "assigns the deck as @deck" do
        deck = Deck.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deck.any_instance.stub(:save).and_return(false)
        put :update, :id => deck.id.to_s, :deck => {}
        assigns(:deck).should eq(deck)
      end

      it "re-renders the 'edit' template" do
        deck = Deck.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Deck.any_instance.stub(:save).and_return(false)
        put :update, :id => deck.id.to_s, :deck => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested deck" do
      deck = Deck.create! valid_attributes
      expect {
        delete :destroy, :id => deck.id.to_s
      }.to change(Deck, :count).by(-1)
    end

    it "redirects to the decks list" do
      deck = Deck.create! valid_attributes
      delete :destroy, :id => deck.id.to_s
      response.should redirect_to(decks_url)
    end
  end

end
