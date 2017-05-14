require 'spec_helper'

describe 'getting_started/show' do
  before(:each) do
    @progress_task = assign(:progress_task, stub_model(ProgressTask,
                                                 :title => "Title",
                                                 :description=> "My Description"
    ))
  end

  it 'renders attributes in <ol>' do
    render
    expect(rendered).to match /Title/
  end
end