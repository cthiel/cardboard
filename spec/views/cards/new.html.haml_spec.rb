require 'spec_helper'

describe "cards/new.html.haml" do
  before(:each) do
    assign(:card, stub_model(Card,
      :name => "MyString",
      :deck_id => 1
    ).as_new_record)
  end

  it "renders new card form" do
    render

    assert_select "form", :action => cards_path, :method => "post" do
      assert_select "textarea#card_name", :name => "card[name]"
      assert_select "select#card_deck_id", :name => "card[deck_id]"
    end
  end
end
