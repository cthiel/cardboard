require 'spec_helper'

describe "statuses/index.html.haml" do
  before(:each) do
    assign(:statuses, [
      stub_model(Status,
        :code => "Code",
        :name => "Name",
        :color => "Color"
      ),
      stub_model(Status,
        :code => "Code",
        :name => "Name",
        :color => "Color"
      )
    ])
  end

  it "renders a list of statuses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
