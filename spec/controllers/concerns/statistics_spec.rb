# frozen_string_literal: true

RSpec.describe 'StatisticsConcern' do
  before do
    class FakeController < ActionController::Base
      include Statistics
    end
    @time = Time.now
    @fake_controller = FakeController.new
  end

  after do
    Object.send(:remove_const, :FakeController)
  end

  it 'gets stats for articles' do
    create_list(:article, 5)
    expect(@fake_controller.get_stats_for(:articles)).to eq({ count: 5 })
  end

  describe 'gets stats for projects' do
    it 'and only counts active projects ' do
      create_list(:project, 5, status: 'active')
      create_list(:project, 3, status: 'disactivated')
      expect(@fake_controller.get_stats_for(:projects)).to eq({ count: 5 })
    end

    it 'with mixed case status' do
      create_list(:project, 5, status: 'ACTive')
      expect(@fake_controller.get_stats_for(:projects)).to eq({ count: 5 })
    end
  end

  it 'gets stats for members' do
    create_list(:user, 5)
    expect(@fake_controller.get_stats_for(:members)).to eq({ count: 5 })
  end

  it 'gets stats for documents' do
    create_list(:document, 5)
    expect(@fake_controller.get_stats_for(:documents)).to eq({ count: 5 })
  end

  it 'get stats for pair programming minutes' do
    create_list(:event_instance, 5,
                category: 'PairProgramming',
                created_at: @time,
                updated_at: (@time + 10 * 60))
    expect(@fake_controller.get_stats_for(:pairing_minutes)).to eq({ value: 50 })
  end

  it 'get stats for pair scrum minutes' do
    create_list(:event_instance, 5,
                category: 'Scrum',
                created_at: @time,
                updated_at: (@time + 10 * 60))
    expect(@fake_controller.get_stats_for(:scrum_minutes)).to eq({ value: 50 })
  end
end
