require 'spec_helper'

describe 'hangouts/index', type: :view do
  before do
    # TODO use FG list with associations
    hangout = FactoryGirl.build_stubbed(:hangout, created_at: '11:15',
                                 event: FactoryGirl.build_stubbed(:event, name: 'Daily Meetup'),
                                 category: 'PairProgramming',
                                 project: FactoryGirl.build_stubbed(:project, title: 'WebsiteOne'),
                                 title: 'Hangouts flow',
                                 host: FactoryGirl.build_stubbed(:user, first_name: 'Yaro'),
                                 hangout_url: 'http://hangout.test',
                                 yt_video_id: 'TIG345')
    @hangouts = [ hangout ]
  end

  it 'renders table main headings' do
    render
    expect(rendered).to have_text('Started')
    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Project')
    expect(rendered).to have_text('Host')
    expect(rendered).to have_text('Join')
    expect(rendered).to have_text('Watch')
  end

  it 'renders hangouts main info' do
    render
    expect(rendered).to have_text('11:15')
    expect(rendered).to have_text('Hangouts flow')
    expect(rendered).to have_text('WebsiteOne')
    # expect(rendered).to have_text('Yaro')

    expect(rendered).to have_link('Join', href: 'http://hangout.test')
    expect(rendered).to have_link('Watch', href: 'http://www.youtube.com/watch?v=TIG345&feature=youtube_gdata')
  end

  it 'renders hangout extra headings' do
    render
    expect(rendered).to have_text('Event')
    expect(rendered).to have_text('Category')
    expect(rendered).to have_text('Participants')

    expect(rendered).to have_button('toggle all hangouts')
  end

  it 'renders hangout extra info' do
    render
    expect(rendered).to have_text('Daily Meetup')
    expect(rendered).to have_text('PairProgramming')
  end
end
