require 'spec_helper'

describe StatusesController do

  # This should return the minimal set of attributes required to create a valid
  # Status. As you add validations to Status, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :code  => 'D',
      :name  => 'Development',
      :color => '#000000' }
  end

  describe "GET index" do
    it "assigns all statuses as @statuses" do
      status = Status.create! valid_attributes
      get :index
      assigns(:statuses).should eq([status])
    end
  end

  describe "GET show" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      get :show, :id => status.id.to_s
      assigns(:status).should eq(status)
    end
  end

  describe "GET new" do
    it "assigns a new status as @status" do
      get :new
      assigns(:status).should be_a_new(Status)
    end
  end

  describe "GET edit" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      get :edit, :id => status.id.to_s
      assigns(:status).should eq(status)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Status" do
        expect {
          post :create, :status => valid_attributes
        }.to change(Status, :count).by(1)
      end

      it "assigns a newly created status as @status" do
        post :create, :status => valid_attributes
        assigns(:status).should be_a(Status)
        assigns(:status).should be_persisted
      end

      it "redirects to the created status" do
        post :create, :status => valid_attributes
        response.should redirect_to(Status.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved status as @status" do
        # Trigger the behavior that occurs when invalid params are submitted
        Status.any_instance.stub(:save).and_return(false)
        post :create, :status => {}
        assigns(:status).should be_a_new(Status)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Status.any_instance.stub(:save).and_return(false)
        post :create, :status => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested status" do
        status = Status.create! valid_attributes
        # Assuming there are no other statuses in the database, this
        # specifies that the Status created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Status.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => status.id, :status => {'these' => 'params'}
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        put :update, :id => status.id, :status => valid_attributes
        assigns(:status).should eq(status)
      end

      it "redirects to the status" do
        status = Status.create! valid_attributes
        put :update, :id => status.id, :status => valid_attributes
        response.should redirect_to(status)
      end
    end

    describe "with invalid params" do
      it "assigns the status as @status" do
        status = Status.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Status.any_instance.stub(:save).and_return(false)
        put :update, :id => status.id.to_s, :status => {}
        assigns(:status).should eq(status)
      end

      it "re-renders the 'edit' template" do
        status = Status.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Status.any_instance.stub(:save).and_return(false)
        put :update, :id => status.id.to_s, :status => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested status" do
      status = Status.create! valid_attributes
      expect {
        delete :destroy, :id => status.id.to_s
      }.to change(Status, :count).by(-1)
    end

    it "redirects to the statuses list" do
      status = Status.create! valid_attributes
      delete :destroy, :id => status.id.to_s
      response.should redirect_to(statuses_url)
    end
  end

end
