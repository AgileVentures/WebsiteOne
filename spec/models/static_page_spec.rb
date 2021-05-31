# frozen_string_literal: true

describe StaticPage, type: :model do
  subject { FactoryBot.create(:static_page) }

  it { is_expected.to be_versioned }

  it 'should be valid with all the correct attributes' do
    expect(subject).to be_valid
  end

  it 'should be invalid without title' do
    subject.title = ''
    expect(subject).to_not be_valid
  end

  context 'correct urls for static pages' do
    context 'with ancestors' do
      let(:page_child) { FactoryBot.create(:static_page, parent_id: subject.id) }
      let(:page_url) { "#{subject.slug}/#{page_child.slug}" }

      it 'returns url for static page object' do
        expect(StaticPage.url_for_me(page_child)).to eq page_url
      end
      it 'returns url for static page title' do
        expect(StaticPage.url_for_me(page_child.title)).to eq page_url
      end
      it 'returns url for static page slug' do
        expect(StaticPage.url_for_me(page_child.slug)).to eq page_url
      end
    end

    context 'without ancestors' do
      it 'returns url for static page object' do
        expect(StaticPage.url_for_me(subject)).to eq subject.slug
      end
      it 'returns url for static page title' do
        expect(StaticPage.url_for_me(subject.title)).to eq subject.slug
      end
      it 'returns url for static page slug' do
        expect(StaticPage.url_for_me(subject.slug)).to eq subject.slug
      end
    end

    it 'returns url for non-existant static page' do
      expect(StaticPage.url_for_me('does not exist')).to eq 'does-not-exist'
    end
  end
end
