require 'spec_helper'

describe "Statuses" do
  describe "GET /statuses" do
    it "works! (now write some real specs)" do
      get statuses_path
      response.status.should be(200)
    end
  end
end
