require 'spec_helper'

describe 'projects/show.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.build_stubbed(:user)

    @document = FactoryGirl.build_stubbed(:document,
                           title: 'this is a document',
                           user: @user,
                           created_at: 1.month.ago)

    @project = FactoryGirl.build_stubbed(:project,
                          title: 'Title 1',
                          description: 'Description 1',
                          status: 'Active',
                          user: @user,
                          user_id: @user.id)


    @videos = [
                { title: 'First video', user: @user, published: '12/12/2012'.to_date, 
                    url: 'somewhere', id: '123', content: 'some text' },
                { title: 'Second video', user: @user, published: '13/12/2013'.to_date, 
                    url: 'somewhere', id: '123', content: 'some text' }
              ]

    @stories = [ double(story_type: 'chore',
                   estimate: 3,
                   id: 1,
                   name: 'My story',
                   owned_by: { initials: 'my-initials' },
                   current_state: 'active')
               ]

    @documents = [@document]
    allow(@documents).to receive(:roots).and_return(@documents)

    @created_by = ['by:', ([@user.first_name, @user.last_name].join(' '))].join(' ')

    assign :members, [@user]
  end

  it "renders a link to the project's github page" do
    @project.github_url = 'github.com/AgileVentures/myfriend'
    render
    expect(rendered).to have_link("#{@project.github_url.split('/').last}", :href => @project.github_url)
  end

  it 'renders an unlinked message when project has no github link' do
    render
    expect(rendered).to have_text 'not linked to GitHub'
  end

  it "renders a link to the project's Pivotal Tracker page" do
    @project.pivotaltracker_url =  'www.pivotaltracker.com/s/projects/12345'
    render
    expect(rendered).to have_link("#{@project.title}", :href => @project.pivotaltracker_url)
  end

  it 'renders an unlinked message when project has no PivotalTracker link' do
    render
    expect(rendered).to have_text 'not linked to PivotalTracker'
  end

  it 'renders project description' do
    render
    expect(rendered).to have_text @project.title
    expect(rendered).to have_text @project.description
    expect(rendered).to have_text @project.status.upcase
    expect(rendered).to have_text @user.display_name
  end

  it 'renders a list of related documents' do
    render
    expect(rendered).to have_text 'Documents (1)'
    expect(rendered).to have_text @document.title, visible: true
  end

  it 'renders a list of members' do
    render
    expect(rendered).to have_text 'Members (1)'
    expect(rendered).to have_text @user.display_name, visible: false
  end

  context 'Pivotal Tracker stories' do
    it 'renders a message when no Pivotal Tracker stories are found' do
      assign :stories, []
      render
      expect(rendered).to have_text 'No PivotalTracker Stories can be found for project Title 1'
    end

    context 'with Pivotal Tracker stories' do
      before(:each) do
        render
      end

      it 'renders the appropriate story type icon' do
        expect(rendered).to have_css 'i.fa.fa-gear.fa-lg'
      end

      it 'renders the correct story estimate' do
        expect(rendered).to have_css 'i.story_estimate', count: 3
      end

      it 'renders the story title' do
        expect(rendered).to have_text 'My story'
      end

      it 'renders the story owners initials' do
        expect(rendered).to have_text 'my-initials'
      end

      it 'renders the current story state' do
        expect(rendered).to have_text 'active'
      end
    end
  end

  describe 'project videos' do

    it 'renders Videos tab with videos quantity' do
      render
      rendered.within('.nav-tabs') do |content|
        expect(content.find(:css, 'li#videos').text).to match /Videos \(2\)/
      end
      expect(render).to have_selector('div.tab-pane#videos_list')
    end

    it 'renders a table wih videos' do
      render
      rendered.within('div#videos_list table') do |content|
        expect(content).to have_text('Video', 'Host', 'Published')
      end
    end

    it 'renders an embedded player' do
      render
      rendered.within('div#videos_list') do |content|
        expect(content).to have_css('iframe#ytplayer')
      end
    end

    it 'renders list of youtube links and published dates if user has videos' do
      render
      @videos.each do |video|
        expect(rendered).to have_link(video[:title], :href => video[:url])
        expect(rendered).to have_text(video[:user].first_name)
        expect(rendered).to have_text(video[:published])
      end
    end

    it 'renders "no available videos" if user has no videos' do
      assign(:videos, [])
      render
      expect(rendered).to have_text('No videos in project Title 1')
    end
  end

  context 'user is signed in' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(@user)
    end

    context 'user is a member of project' do
      before do
        allow(@user).to receive(:following?).and_return(true)
        allow(view).to receive(:generate_event_id).and_return('546')
      end

      it 'render join project button' do
        render
        expect(rendered).to have_css %Q{a[href="#{unfollow_project_path(@project)}"]}, visible: true
      end

      it_behaves_like 'it has a hangout button' do
        let(:event_id){''}
        let(:category){'PairProgramming'}
        let(:hangout_id){''}
        let(:project){@project}
        let(:topic_name){"PairProgramming on #{@project.title}"}
      end

    end

    context 'user is not a member of project' do
      it 'render leave project button' do
        allow(@user).to receive(:following?).and_return(false)
        render
        expect(rendered).to have_css %Q{a[href="#{follow_project_path(@project)}"]}, visible: true
      end
    end
  end
end
