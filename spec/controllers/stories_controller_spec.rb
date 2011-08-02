require 'spec_helper'

describe StoriesController do

  before do
    Status.create!({:name => 'Development', :color => '#000000'})
  end

  # This should return the minimal set of attributes required to create a valid
  # Story. As you add validations to Story, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name   => 'Test it!', 
     :status_id => 1}
  end

  describe "GET index" do
    it "assigns all stories as @stories" do
      story = Story.create! valid_attributes
      get :index
      assigns(:stories).should eq([story])
    end
  end

  describe "GET show" do
    it "assigns the requested story as @story" do
      story = Story.create! valid_attributes
      get :show, :id => story.id.to_s
      assigns(:story).should eq(story)
    end
  end

  describe "GET new" do
    it "assigns a new story as @story" do
      get :new
      assigns(:story).should be_a_new(Story)
    end
  end

  describe "GET edit" do
    it "assigns the requested story as @story" do
      story = Story.create! valid_attributes
      get :edit, :id => story.id.to_s
      assigns(:story).should eq(story)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Story" do
        expect {
          post :create, :story => valid_attributes
        }.to change(Story, :count).by(1)
      end

      it "assigns a newly created story as @story" do
        post :create, :story => valid_attributes
        assigns(:story).should be_a(Story)
        assigns(:story).should be_persisted
      end

      it "redirects to the created story" do
        post :create, :story => valid_attributes
        response.should redirect_to(Story.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved story as @story" do
        # Trigger the behavior that occurs when invalid params are submitted
        Story.any_instance.stub(:save).and_return(false)
        post :create, :story => {}
        assigns(:story).should be_a_new(Story)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Story.any_instance.stub(:save).and_return(false)
        post :create, :story => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested story" do
        story = Story.create! valid_attributes
        # Assuming there are no other stories in the database, this
        # specifies that the Story created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Story.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => story.id, :story => {'these' => 'params'}
      end

      it "assigns the requested story as @story" do
        story = Story.create! valid_attributes
        put :update, :id => story.id, :story => valid_attributes
        assigns(:story).should eq(story)
      end

      it "redirects to the story" do
        story = Story.create! valid_attributes
        put :update, :id => story.id, :story => valid_attributes
        response.should redirect_to(story)
      end
    end

    describe "with invalid params" do
      it "assigns the story as @story" do
        story = Story.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Story.any_instance.stub(:save).and_return(false)
        put :update, :id => story.id.to_s, :story => {}
        assigns(:story).should eq(story)
      end

      it "re-renders the 'edit' template" do
        story = Story.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Story.any_instance.stub(:save).and_return(false)
        put :update, :id => story.id.to_s, :story => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested story" do
      story = Story.create! valid_attributes
      expect {
        delete :destroy, :id => story.id.to_s
      }.to change(Story, :count).by(-1)
    end

    it "redirects to the stories list" do
      story = Story.create! valid_attributes
      delete :destroy, :id => story.id.to_s
      response.should redirect_to(stories_url)
    end
  end

end
