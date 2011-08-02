require 'spec_helper'

describe "statuses/index.html.haml" do
  before(:each) do
    assign(:statuses, [
      stub_model(Status,
        :name => "Name",
        :color => "Color"
      ),
      stub_model(Status,
        :name => "Name",
        :color => "Color"
      )
    ])
  end

  it "renders a list of statuses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
