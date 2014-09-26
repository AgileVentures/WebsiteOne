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

  context 'correct urls for static pages' do
    context 'with ancestors' do
      before(:each) do
        @page_child = StaticPage.create!(valid_attributes_for(:static_page).merge(parent_id: @page.id))
        @page_url = "#{@page.slug}/#{@page_child.slug}"
      end

      it 'returns url for static page object' do
        expect(StaticPage.url_for_me(@page_child)).to eq @page_url
      end
      it 'returns url for static page title' do
        expect(StaticPage.url_for_me(@page_child.title)).to eq @page_url
      end
      it 'returns url for static page slug' do
        expect(StaticPage.url_for_me(@page_child.slug)).to eq @page_url
      end
    end

    context 'without ancestors' do
      it 'returns url for static page object' do
        expect(StaticPage.url_for_me(@page)).to eq @page.slug
      end
      it 'returns url for static page title' do
        expect(StaticPage.url_for_me(@page.title)).to eq @page.slug
      end
      it 'returns url for static page slug' do
        expect(StaticPage.url_for_me(@page.slug)).to eq @page.slug
      end
    end

    it 'returns url for non-existant static page' do
      expect(StaticPage.url_for_me('does not exist')).to eq 'does-not-exist'
    end
  end
end
