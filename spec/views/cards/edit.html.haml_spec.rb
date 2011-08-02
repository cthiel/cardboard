require 'spec_helper'

describe "cards/edit.html.haml" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :name => "MyString",
      :deck => stub_model(Deck, :name => 'Development', :color => '#000000')
    ))
  end

  it "renders the edit card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cards_path(@card), :method => "post" do
      assert_select "textarea#card_name", :name => "card[name]"
      assert_select "select#card_deck_id", :name => "card[deck_id]"
    end
  end
end
