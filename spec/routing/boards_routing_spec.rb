require "spec_helper"

describe StoriesController do
  describe "routing" do

    it "routes to #show" do
      get("/").should route_to("projects#show", :id => 'default')
    end
  end
end
