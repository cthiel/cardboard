require 'spec_helper'

describe "statuses/new.html.haml" do
  before(:each) do
    assign(:status, stub_model(Status,
      :code => "MyString",
      :name => "MyString",
      :color => "MyString"
    ).as_new_record)
  end

  it "renders new status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => statuses_path, :method => "post" do
      assert_select "input#status_code", :name => "status[code]"
      assert_select "input#status_name", :name => "status[name]"
      assert_select "input#status_color", :name => "status[color]"
    end
  end
end
