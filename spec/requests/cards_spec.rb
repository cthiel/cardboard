# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Cards" do
  describe "GET /cards" do
    it "works! (now write some real specs)" do
      get cards_path
      response.status.should be(200)
    end
  end
end
