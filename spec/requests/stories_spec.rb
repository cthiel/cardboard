require 'spec_helper'

describe "Stories" do
  describe "GET /stories" do
    it "works! (now write some real specs)" do
      get stories_path
      response.status.should be(200)
    end
  end
end
