require 'spec_helper'

describe "stories/show.html.haml" do
  before(:each) do
    @story = assign(:story, stub_model(Story,
      :name => "Name",
      :status => stub_model(Status, :name => 'Development', :color => '#000000')
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/D/)
  end
end
