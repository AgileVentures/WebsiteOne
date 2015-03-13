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


    render

  end

  it 'displays a tab view' do
    expect(rendered).to have_css('ul#tabs')
  end

  describe 'displays statistics: ' do
    it { expect(rendered).to include('10 Articles') }
    it { expect(rendered).to include('5 Projects') }
    it { expect(rendered).to include('100 Members') }
    it { expect(rendered).to include('40 Documents') }
    it { expect(rendered).to include('300 PairProgramming Minutes') }
    it { expect(rendered).to include('200 Scrum Minutes') }
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
