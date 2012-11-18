# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Decks" do
  describe "GET /decks" do
    it "works! (now write some real specs)" do
      get decks_path
      response.status.should be(200)
    end
  end
end
