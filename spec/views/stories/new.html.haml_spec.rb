require 'spec_helper'

describe "stories/new.html.haml" do
  before(:each) do
    assign(:story, stub_model(Story,
      :number => "MyString",
      :name => "MyString",
      :status_id => 1
    ).as_new_record)
  end

  it "renders new story form" do
    render

    assert_select "form", :action => stories_path, :method => "post" do
      assert_select "input#story_number", :name => "story[number]"
      assert_select "input#story_name", :name => "story[name]"
      assert_select "select#story_status_id", :name => "story[status_id]"
    end
  end
end
