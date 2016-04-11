require 'spec_helper'

describe 'layouts/_sponsors' do
	it 'should render the sponsors sidebar' do
		render
		expect(rendered).to have_selector('div#sponsorsBar')
		expect(rendered).to have_selector('a.sponsorMedal')
	end

	it 'should render the become a supporter button' do
		render
		expect(rendered).to have_link 'Become a supporter', static_page_path('Sponsors')
	end

	it 'should render the Craft Academy banner' do
		render
		expect(response.body).to have_link('', href: "http://craftacademy.se/international")
		expect(response.body).to have_selector('a.sponsorMedal img[src*="craft"]')
  end

	it 'should render the airpair banner' do
		render
		expect(response.body).to have_link('', href: "http://www.airpair.com/")
		expect(response.body).to have_selector('a.sponsorMedal img[src*="sponsors/airpair"]')
	end
end
