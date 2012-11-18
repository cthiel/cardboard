# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "decks/index.html.haml" do
  before(:each) do
    assign(:decks, [
      stub_model(Deck,
        :name => "Name",
        :color => "Color"
      ),
      stub_model(Deck,
        :name => "Name",
        :color => "Color"
      )
    ])
  end

  it "renders a list of decks" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
