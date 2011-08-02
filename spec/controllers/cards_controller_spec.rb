require 'spec_helper'

describe CardsController do

  before do
    Deck.create!({:name => 'Development', :color => '#000000'})
  end

  # This should return the minimal set of attributes required to create a valid
  # Card. As you add validations to Story, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name   => 'Test it!', 
     :deck_id => 1}
  end

  describe "GET index" do
    it "assigns all cards as @cards" do
      card = Card.create! valid_attributes
      get :index
      assigns(:cards).should eq([card])
    end
  end

  describe "GET show" do
    it "assigns the requested card as @card" do
      card = Card.create! valid_attributes
      get :show, :id => card.id.to_s
      assigns(:card).should eq(card)
    end
  end

  describe "GET new" do
    it "assigns a new card as @card" do
      get :new
      assigns(:card).should be_a_new(Card)
    end
  end

  describe "GET edit" do
    it "assigns the requested card as @card" do
      card = Card.create! valid_attributes
      get :edit, :id => card.id.to_s
      assigns(:card).should eq(card)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Card" do
        expect {
          post :create, :card => valid_attributes
        }.to change(Card, :count).by(1)
      end

      it "assigns a newly created card as @card" do
        post :create, :card => valid_attributes
        assigns(:card).should be_a(Card)
        assigns(:card).should be_persisted
      end

      it "redirects to the created card" do
        post :create, :card => valid_attributes
        response.should redirect_to(Card.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved card as @card" do
        # Trigger the behavior that occurs when invalid params are submitted
        Card.any_instance.stub(:save).and_return(false)
        post :create, :card => {}
        assigns(:card).should be_a_new(Card)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Card.any_instance.stub(:save).and_return(false)
        post :create, :card => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested card" do
        card = Card.create! valid_attributes
        # Assuming there are no other cards in the database, this
        # specifies that the Card created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Card.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => card.id, :card => {'these' => 'params'}
      end

      it "assigns the requested card as @card" do
        card = Card.create! valid_attributes
        put :update, :id => card.id, :card => valid_attributes
        assigns(:card).should eq(card)
      end

      it "redirects to the card" do
        card = Card.create! valid_attributes
        put :update, :id => card.id, :card => valid_attributes
        response.should redirect_to(card)
      end
    end

    describe "with invalid params" do
      it "assigns the card as @card" do
        card = Card.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Card.any_instance.stub(:save).and_return(false)
        put :update, :id => card.id.to_s, :card => {}
        assigns(:card).should eq(card)
      end

      it "re-renders the 'edit' template" do
        card = Card.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Card.any_instance.stub(:save).and_return(false)
        put :update, :id => card.id.to_s, :card => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested card" do
      card = Card.create! valid_attributes
      expect {
        delete :destroy, :id => card.id.to_s
      }.to change(Card, :count).by(-1)
    end

    it "redirects to the cards list" do
      card = Card.create! valid_attributes
      delete :destroy, :id => card.id.to_s
      response.should redirect_to(cards_url)
    end
  end

end
