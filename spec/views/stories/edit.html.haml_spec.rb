require 'spec_helper'

describe "stories/edit.html.haml" do
  before(:each) do
    @story = assign(:story, stub_model(Story,
      :number => "MyString",
      :name => "MyString",
      :status => stub_model(Status, :code => 'D', :name => 'Development', :color => '#000000')
    ))
  end

  it "renders the edit story form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => stories_path(@story), :method => "post" do
      assert_select "input#story_number", :name => "story[number]"
      assert_select "input#story_name", :name => "story[name]"
      assert_select "select#story_status_id", :name => "story[status_id]"
    end
  end
end
