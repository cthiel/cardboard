require 'spec_helper'

describe "cards/index.html.haml" do
  before(:each) do
    assign(:cards, [
      stub_model(Card,
        :name => "Name 1",
        :deck =>  stub_model(Deck, :name => 'Development', :color => '#000000')
      ),
      stub_model(Card,
        :name => "Name 2",
        :deck => stub_model(Deck, :name => 'Development', :color => '#000000')
      )
    ])
  end

  it "renders a list of cards" do
    render

    assert_select "table" do
      assert_select "tr" do
        assert_select "th", :text => 'Name'
        assert_select "th", :text => 'Deck'
      end
      assert_select "tr" do
        assert_select "td", :text => 'Name 1'
        assert_select "td", :text => 'Development'
      end
      assert_select "tr" do
        assert_select "td", :text => 'Name 2'
        assert_select "td", :text => 'Development'
      end
    end
  end
end
