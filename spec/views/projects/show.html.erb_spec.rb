require 'spec_helper'

describe 'projects/show.html.erb', type: :view do

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:members) { FactoryGirl.build_list(:user, 10) }
  let(:document) { FactoryGirl.build_stubbed(:document, user: user) }
  let(:documents) { [document] }
  let(:project) { FactoryGirl.build_stubbed(:project, user: user) }
  let(:created_by) { ['by:', ([user.first_name, user.last_name].join(' '))].join(' ') }
  let(:event_instances) { 2.times.map { FactoryGirl.build_stubbed(:event_instance, user: user) } }
  let(:event_instances_count) { 2 }

  let(:stories) do
    [
        double(story_type: 'chore',
               estimate: 3,
               id: 1,
               name: 'My story',
               owned_by: {initials: 'my-initials'},
               current_state: 'active')
    ]
  end

  before :each do
    allow(documents).to receive(:roots).and_return(documents)

    assign :members, members
    assign :user, user
    assign :document, document
    assign :project, project
    assign :documents, documents
    assign :created_by, created_by
    assign :event_instances, event_instances
    assign :event_instances_count, event_instances_count
    assign :stories, stories
  end

  it 'renders a link to the project\'s github page' do
    project.github_url = 'github.com/AgileVentures/myfriend'
    render
    expect(rendered).to have_link("#{project.github_url.split('/').last}", :href => project.github_url)
  end

  it 'renders an unlinked message when project has no github link' do
    render
    expect(rendered).to have_text 'not linked to GitHub'
  end

  it 'renders a link to the project\'s Pivotal Tracker page' do
    project.pivotaltracker_url = 'www.pivotaltracker.com/s/projects/12345'
    render
    expect(rendered).to have_link("#{project.title}", :href => project.pivotaltracker_url)
  end

  it 'renders an unlinked message when project has no PivotalTracker link' do
    render
    expect(rendered).to have_text 'not linked to PivotalTracker'
  end

  it 'renders project description' do
    render
    expect(rendered).to have_text project.title
    expect(rendered).to have_text project.description
    expect(rendered).to have_text project.pitch
    expect(rendered).to have_text project.status.upcase
    expect(rendered).to have_text user.display_name
  end

  it 'renders a list of related documents' do
    render
    expect(rendered).to have_text 'Documents (1)'
    expect(rendered).to have_text document.title, visible: true
  end

  it 'renders first 5 members in sidebar' do
    render
    rendered.within('#members-list ul.media-list') do |content|
      expect(content).to have_css 'li.media-item', count: 5
    end
  end

  it 'renders a count of members' do
    render
    rendered.within('#members-list') do |content|
      expect(content).to have_text 'Members (10)'
    end
  end

  it 'renders a link to full members list' do
    render
    rendered.within('#members-list') do |content|
      expect(content).to have_css 'a', text: 'View full list'
    end
  end

  it 'renders a modal with full members list' do
    render
    expect(rendered).to have_css '#members-modal'
    rendered.within('#members-modal') do |content|
      expect(content).to have_css 'li.media-item', count: 10
    end
  end

  context 'Project pitch tab' do
    before(:each) do
      render
    end

    context 'the project pitch is present' do

      it 'renders pitch' do
        expect(rendered).to have_text '\'I AM the greatest!\' - M. Ali'
      end
    end

    context 'the project pitch is not set' do
      let(:project) { FactoryGirl.build_stubbed(:project, user: user, pitch: nil) }

      it 'renders default message if no pitch is present' do
        expect(rendered).to have_text 'Project content missing :( A compelling pitch can make your project more appealing to potential collaborators. Please edit project details to add pitch content.'
      end
    end
  end

  context 'Pivotal Tracker stories' do
    it 'renders a message when no Pivotal Tracker stories are found' do
      assign :stories, []
      render
      expect(rendered).to have_text "No PivotalTracker Stories can be found for project #{project.title}"
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
      rendered.within('div.tab-pane#videos_list') do |content|
        expect(content).to have_css('table')
        expect(content).to have_text('Video')
        expect(content).to have_text('Host')
        expect(content).to have_text('Published')
      end
    end

    it 'renders an embedded player' do
      render
      rendered.within('div.tab-pane#videos_list') do |content|
        expect(content).to have_css('iframe#ytplayer')
      end
    end

    it 'renders list of youtube links and published dates if user has videos' do
      render
      event_instances.each do |video|
        href = "http://www.youtube.com/watch?v=#{video.yt_video_id}&feature=youtube_gdata"
        expect(rendered).to have_link(video.title, :href => href)
        expect(rendered).to have_text(video.user.first_name)
        expect(rendered).to have_text(video.created_at.strftime('%H:%M %d/%m'))
      end
    end

    it 'renders "no available videos" if user has no videos' do
      assign(:event_instances, [])
      render
      expect(rendered).to have_text("No videos in project #{project.title}")
    end
  end

  context 'user is signed in' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
    end

    context 'user is a member of project' do
      before do
        allow(user).to receive(:following?).and_return(true)
        allow(view).to receive(:generate_event_id).and_return('546')
      end

      it 'render a project actions dropdown' do
        render
        expect(rendered).to have_css('button#actions-dropdown', text: 'Project Actions')
        rendered.within('ul.list-inline') do |content|
          expect(content).to have_css('a', text: 'Edit Project Details')
          expect(content).to have_css('a', text: 'Edit Project Pitch')
          expect(content).to have_css('a', text: 'Create new document')
          expect(content).to have_css('a', text: 'Leave Project')
        end
      end

      it 'render leave project link' do
        render
        expect(rendered).to have_css %Q{a[href="#{unfollow_project_path(project)}"]}, visible: true
      end

      it_behaves_like 'it has a hangout button' do
        let(:title) { "PairProgramming on #{project.title}" }
        let(:project_id) { project.id }
        let(:event_id) { '' }
        let(:category) { 'PairProgramming' }
        let(:event_instance) { '' }
        let(:event_instance_project) { project }
        let(:topic_name) { "PairProgramming on #{project.title}" }
      end

    end

    context 'user is not a member of project' do
      it 'render join project button' do
        allow(user).to receive(:following?).and_return(false)
        render
        expect(rendered).to have_css %Q{a[href="#{follow_project_path(project)}"]}, visible: true
      end
    end

    context "mercury editor is active" do
      it 'does not render "Edit Pitch" link when inside Mercury editor' do
        allow(controller.request).to receive(:original_url).and_return('mercury_frame=true')
        render
        expect(rendered).not_to have_css('a', text: 'Edit Pitch')
      end
    end
  end
end
