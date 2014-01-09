require 'spec_helper'

describe 'layouts/application.html.erb', :type => :feature do
  it 'should include bootstrap 3.0+ css & js files' do
    render
    rendered.should have_xpath("//link[contains(@href, 'bootstrap')]")
    rendered.should have_xpath("//script[contains(@src, 'bootstrap')]")
    rendered.should have_xpath("//script[contains(@src, 'jquery')]")
  end
end

