require 'spec_helper'

describe 'hangouts/index', type: :view do

  let(:hangout){ FactoryGirl.build_stubbed(:hangout, created: '11:15') }

  before do
    @hangouts = [ hangout ]
  end

  it 'renders toggle buttons' do
    render
    expect(rendered).to have_button('toggle summary')
    expect(rendered).to have_link('show all/live')
  end

  it 'renders table main headings' do
    render
    expect(rendered).to have_text('Started')
    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Project')
    expect(rendered).to have_text('Host')
    expect(rendered).to have_text('Hangout')
  end

  it 'renders hangouts basic info' do
    render
    expect(rendered).to have_css('i.fa-caret-right')
    expect(rendered).to have_text('11:15')
    expect(rendered).to have_text(hangout.title)
    expect(rendered).to have_link(hangout.project.title, project_path(hangout.project))
    expect(rendered).to have_link('Join', href: hangout.hangout_url)
    expect(rendered).to have_link('Watch', href: "http://www.youtube.com/watch?v=#{hangout.yt_video_id}&feature=youtube_gdata")
  end

  it_behaves_like 'it has clickable user avatar with popover' do
    let(:user){ hangout.presenter.host }
    let(:placement){ 'top' }
  end

  it 'renders hangout extra headings' do
    render
    expect(rendered).to have_text('Event')
    expect(rendered).to have_text('Category')
    expect(rendered).to have_text('Participants')
  end

  it 'renders hangout extra info' do
    render
    expect(rendered).to have_link(hangout.event.name, event_path(hangout.event))
    expect(rendered).to have_text(hangout.category)
  end

  describe 'renders participants avatars' do
    before do
      FactoryGirl.create(:user, youtube_id: hangout.participants.first[:gplus_id])
      FactoryGirl.create(:user, youtube_id: hangout.participants.last[:gplus_id])
    end

    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ hangout.presenter.participants.first }
      let(:placement){ 'bottom' }
    end

    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ hangout.presenter.participants.last }
      let(:placement){ 'bottom' }
    end
  end
end
