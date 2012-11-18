# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "decks/show.html.haml" do
  before(:each) do
    @deck = assign(:deck, stub_model(Deck,
      :name => "Name",
      :color => "Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/Color/)
  end
end
