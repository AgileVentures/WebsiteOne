require 'spec_helper'

describe StaticPage do
  before do
    @page = StaticPage.create!(valid_attributes_for(:static_page))
  end

  it { should be_versioned }

  context 'return false on invalid inputs' do
    it 'blank Title' do
      @page.title = ''
      expect(@page.save).to be_false
    end
  end

  it 'should NOT allow friendly IDs to be shared within a project' do
    page = StaticPage.create(title: @page.title)
    expect(page.friendly_id).to_not eq @page.friendly_id
  end

  context 'return true on correct inputs' do
    it 'is valid' do
      expect(@page).to be_valid
    end
  end
end
