require 'spec_helper'

describe 'StatisticsConcern' do
  before do
    class FakeController < ActionController::Base
      include Statistics
    end
  end
  let(:fake_controller) { FakeController.new }

  it "gets stats for articles" do
    FactoryGirl.create_list(:article, 5)
    expect(fake_controller.get_stats_for(:articles)).to eq({ count: 5})
  end
    
  it "gets stats for projects" do
    FactoryGirl.create_list(:project, 5, status: 'active')
    FactoryGirl.create_list(:project, 3, status: 'disactivated')
    expect(fake_controller.get_stats_for(:projects)).to eq({ count: 5})
  end

  it "gets stats for members" do
    FactoryGirl.create_list(:user, 5)
    expect(fake_controller.get_stats_for(:members)).to eq({ count: 5})
  end

  it "gets stats for documents" do
    FactoryGirl.create_list(:document, 5)
    expect(fake_controller.get_stats_for(:documents)).to eq({ count: 5})
  end
end
