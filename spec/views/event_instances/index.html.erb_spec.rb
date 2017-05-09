require 'spec_helper'

describe 'event_instances/index', type: :view do

  before do
    2.times { FactoryGirl.create(:event_instance,
                                 created: '2014/05/12 11:15',
                                 updated: '2014/05/12 11:35') }
    @event_instances = EventInstance.all.paginate(page: nil)
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
    hangout = @event_instances.first
    expect(rendered).to have_css('i.fa-caret-right')
    expect(rendered).to have_text('11:15 12/05')
    expect(rendered).to have_text(hangout.title)
    expect(rendered).to have_link(hangout.project.title, project_path(hangout.project))
    expect(rendered).to have_link('Join', href: hangout.hangout_url)
    expect(rendered).to have_link('Watch', href: "http://www.youtube.com/watch?v=#{hangout.yt_video_id}&feature=youtube_gdata")
  end

  it 'disables the join button if hangout is not live' do
    allow_any_instance_of(EventInstance).to receive(:live?).and_return(false)
    render
    expect(rendered).to have_css('.btn-hg-join.disable', count: @event_instances.count)
  end

  it_behaves_like 'it has clickable user avatar with popover' do
    let(:user){ @event_instances.first.presenter.host }
    let(:placement){ 'top' }
  end

  it 'renders hangout extra headings' do
    render
    expect(rendered).to have_text('Event')
    expect(rendered).to have_text('Category')
    expect(rendered).to have_text('Participants')
    expect(rendered).to have_text('Duration')
  end

  it 'renders hangout extra info' do
    render
    hangout = @event_instances.first
    expect(rendered).to have_link(hangout.event.name, event_path(hangout.event))
    expect(rendered).to have_text(hangout.category)
    expect(rendered).to have_text('20 min')
  end

  describe 'renders participants avatars' do
    before do
      FactoryGirl.create(:user, gplus: @event_instances.first.participants.first.last['person']['id'])
      FactoryGirl.create(:user)
    end

    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ @event_instances.first.presenter.participants.first }
      let(:placement){ 'bottom' }
    end

    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ @event_instances.first.presenter.participants.last }
      let(:placement){ 'bottom' }
    end
  end
end
