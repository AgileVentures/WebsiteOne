require 'spec_helper'

describe 'layouts/_sponsors' do
	it 'should render the sponsors sidebar' do
		render
		rendered.should have_selector('div#sponsorsBar')
		rendered.should have_selector('a.sponsorMedal')
	end

	it 'should render the become a supporter button' do
		render
		rendered.should have_link 'Become a supporter', static_page_path('Sponsors')
	end

	it 'should render the Makers Academy banner' do
		render
		response.body.should have_xpath("//a",:href => "http://www.makersacademy.com/")
		response.body.should have_selector('a.sponsorMedal img[src*="makers"]')
	end

	it 'should render the airpair banner' do
		render
		response.body.should have_xpath("//a",:href => "http://www.airpair.com/")
		response.body.should have_selector('a.sponsorMedal img[src*="sponsors/airpair"]')
	end
end
