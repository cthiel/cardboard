require 'spec_helper'

describe "statuses/show.html.haml" do
  before(:each) do
    @status = assign(:status, stub_model(Status,
      :name => "Name",
      :color => "Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/Color/)
  end
end
