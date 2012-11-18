# -*- encoding : utf-8 -*-
require "spec_helper"

describe CardsController do
  describe "routing" do

    it "routes to #show" do
      get("/").should route_to("boards#show", :id => 'default')
    end
  end
end
