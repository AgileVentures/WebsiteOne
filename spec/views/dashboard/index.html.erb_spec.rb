require 'spec_helper'

describe 'dashboard/index.html.erb', type: :view, js: true do
  before :each do
    assign(:stats, {articles: {count: 10},
                    projects: {count: 5},
                    members: {count: 100},
                    documents: {count: 40},
                    pairing_minutes: {value: 300},
                    scrum_minutes: {value: 200},
                 })
  end

  it 'displays a tab view' do
    render
    expect(rendered).to have_css('ul#tabs')
  end

  describe 'displays statistics: ' do

    before(:each) { render }

    it '10 Articles' do
      rendered.within 'div#articles' do |section|
        expect(section).to have_css 'div.panel-heading', text: 'Articles'
        expect(section).to have_css 'div.panel-body', text: '10'
      end
    end

    it '5 Projects' do
      rendered.within '#projects' do |section|
        expect(section).to have_css 'div.panel-heading', text: 'Projects'
        expect(section).to have_css 'div.panel-body', text: '5'
      end
    end

    it '100 Members' do
      rendered.within '#members' do |section|
        expect(section).to have_css 'div.panel-heading', text: 'Members'
        expect(section).to have_css 'div.panel-body', text: '100'
      end
    end

    it '40 Documents' do
      rendered.within '#documents' do |section|
        expect(section).to have_css 'div.panel-heading', text: 'Documents'
        expect(section).to have_css 'div.panel-body', text: '40'
      end
    end

    it '200 Scrum Minutes' do
      rendered.within '#scrum-minutes' do |section|
        expect(section).to have_css 'div.panel-heading', text: 'Scrum Minutes'
        expect(section).to have_css 'div.panel-body', text: '200'
      end
    end
  end

  describe 'render and populate map of users' do
    before(:each) do
      @users = []
      (0..19).each do
        get_country
        @users << FactoryGirl.build(:user, country_name: @country[:country_name], country_code: @country[:country_code])
      end
      render
    end

    it {expect(@users.count).to eq 20}

    it 'includes map legend' do
      expect(rendered).to have_css 'div#info-box', text: 'User statistics'
    end

    it 'includes map' do
      expect(rendered).to have_css 'div#map'
    end
  end
end
