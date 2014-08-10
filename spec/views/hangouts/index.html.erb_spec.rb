require 'spec_helper'

describe 'hangouts/index', type: :view do
  before do
    # TODO use FG list with associations
    @user_1 = FactoryGirl.create(:user, first_name: 'Yaro', youtube_id: 'youtube_id_1')
    @user_2 = FactoryGirl.create(:user, first_name: 'Jon', youtube_id: 'youtube_id_2')
    @user_3 = FactoryGirl.create(:user, first_name: 'Bob', youtube_id: 'youtube_id_3')

    @hangout = FactoryGirl.build_stubbed(:hangout,
                     created_at: '11:15',
                     event: FactoryGirl.build_stubbed(:event, name: 'Daily Meetup'),
                     category: 'PairProgramming',
                     project: FactoryGirl.build_stubbed(:project, title: 'WebsiteOne'),
                     title: 'Hangouts flow',
                     host: @user_1,
                     hangout_url: 'http://hangout.test',
                     yt_video_id: 'TIG345',
                     participants: [
                        { name: 'Jon', gplus_id: 'youtube_id_2' },
                        { name: 'Bob', gplus_id: 'youtube_id_3' }
                                   ])
    @hangouts = [ @hangout ]
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
    expect(rendered).to have_text('11:15')
    expect(rendered).to have_text('Hangouts flow')
    expect(rendered).to have_text('WebsiteOne')
    expect(rendered).to have_link('Join', href: 'http://hangout.test')
    expect(rendered).to have_link('Watch', href: 'http://www.youtube.com/watch?v=TIG345&feature=youtube_gdata')
  end

  it_behaves_like 'it has clickable user avatar with popover' do
    let(:user){ @user_1 }
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

  describe 'renders participants avatars' do
    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ @user_2 }
    end

    it_behaves_like 'it has clickable user avatar with popover' do
      let(:user){ @user_3 }
    end
  end
end
