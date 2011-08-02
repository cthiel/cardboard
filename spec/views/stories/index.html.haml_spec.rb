require 'spec_helper'

describe "stories/index.html.haml" do
  before(:each) do
    assign(:stories, [
      stub_model(Story,
        :name => "Name 1",
        :status =>  stub_model(Status, :name => 'Development', :color => '#000000')
      ),
      stub_model(Story,
        :name => "Name 2",
        :status => stub_model(Status, :name => 'Development', :color => '#000000')
      )
    ])
  end

  it "renders a list of stories" do
    render

    assert_select "table" do
      assert_select "tr" do
        assert_select "th", :text => 'Name'
        assert_select "th", :text => 'Status'
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
