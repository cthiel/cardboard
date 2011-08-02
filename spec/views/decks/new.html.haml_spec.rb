require 'spec_helper'

describe "decks/new.html.haml" do
  before(:each) do
    assign(:deck, stub_model(Deck,
      :name => "MyString",
      :color => "MyString"
    ).as_new_record)
  end

  it "renders new deck form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => decks_path, :method => "post" do
      assert_select "input#deck_name", :name => "deck[name]"
      assert_select "input#deck_color", :name => "deck[color]"
    end
  end
end
