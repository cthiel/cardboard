# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "decks/edit.html.haml" do
  before(:each) do
    @deck = assign(:deck, stub_model(Deck,
      :name => "MyString",
      :color => "MyString"
    ))
  end

  it "renders the edit deck form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => decks_path(@deck), :method => "post" do
      assert_select "input#deck_name", :name => "deck[name]"
      assert_select "input#deck_color", :name => "deck[color]"
    end
  end
end
