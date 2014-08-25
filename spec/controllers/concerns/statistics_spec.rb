require 'spec_helper'

class FakeController < ActionController::Base
  include Statistics
end

describe 'StatisticsConcern' do
  let(:fake_controller) { FakeController.new }

  describe FakeController, type: :controller do
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
  end
end
