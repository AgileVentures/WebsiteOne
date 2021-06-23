# frozen_string_literal: true

describe 'UsersHelper' do
  describe '#activity_tab' do
    it 'should return active when param_tab is activity' do
      expect(helper.activity_tab('activity')).to eq 'active'
    end

    it 'should return nil when param_tab is not activity' do
      expect(helper.activity_tab('some-other-tab')).to be nil
    end
  end

  describe '#about_tab' do
    it 'should return nil when param_tab is activity' do
      expect(helper.about_tab('some-other-tab')).to eq 'active'
    end

    it 'should return active when param_tab is not activity' do
      expect(helper.about_tab('activity')).to be nil
    end
  end
end
