require 'spec_helper'

describe "cards/show.html.haml" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :name => "Name",
      :deck => stub_model(Deck, :name => 'Development', :color => '#000000')
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/D/)
  end
end
