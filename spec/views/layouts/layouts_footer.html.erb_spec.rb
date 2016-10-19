require 'spec_helper'

describe 'layouts/_footer' do
  it 'should render the Craft Academy link' do
    render
    expect(response.body).to have_link('', href: "http://craftacademy.se/english")
  end
end
