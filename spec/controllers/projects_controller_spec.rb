require 'spec_helper'

describe ProjectsController, :type => :controller do

  let(:valid_attributes) { { id: 1,
                            :title => 'WebTwentyFive',
                            :description => 'My project description',
                            :status => 'Active',
                            :pitch => 'My project pitch ...',
                            :pivotaltracker_url => 'https://www.pivotaltracker.com/s/projects/982890',
                            :slug => 'my-project'} }
  let(:valid_session) { {} }

  #TODO split specs into 'logged in' vs 'not logged in'
  before :each do
    # stubbing out devise methods to simulate authenticated user
    @user = build_stubbed(:user, id: 1, slug: 'some-id')
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
    allow(@user).to receive(:touch)
  end

  let(:user) { @user }

  describe '#index' do
    before(:each) do
      @project = mock_model(Project, title: 'Carrier has arrived.', commit_count: 200, last_github_update: '2000-01-01')
      @project2 = mock_model(Project, title: 'Carrier has left.', commit_count: 100, last_github_update: '2000-02-01')
      @projects = [@project, @project2]
    end

    it 'should render index page for projects' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'should assign variables to be rendered by view' do
      allow(Project).to receive(:search).and_return(@project)
      @project.stub(:includes).and_return(@project)
      get :index
      expect(assigns(:projects).title).to eq 'Carrier has arrived.'
    end

    describe '#show' do
      before(:each) do
        @project = build_stubbed(:project, valid_attributes)
        allow(@project).to receive(:tag_list).and_return ['WSO']
        Project.stub_chain(:friendly, :find).and_return @project
        @project.stub_chain(:user, :display_name).and_return "Happy User"
        @users = [build_stubbed(:user, slug: 'my-friendly-id', display_profile: true)]
        expect(@project).to receive(:members).and_return @users
        event_instances = double('event_instances')
        ordered_event_instances = double('ordered_event_instances')
        expect(EventInstance).to receive(:where).with(project_id: @project.id).and_return(event_instances)
        expect(event_instances).to receive(:order).with(created_at: :desc).and_return(ordered_event_instances)
        expect(event_instances).to receive(:count).and_return('count')
        expect(ordered_event_instances).to receive(:limit).with(25).and_return('videos')
        project = Object.new
        iteration = Object.new
        iteration.stub(stories: "stories")
        project.stub(current_iteration: iteration)
        allow(PivotalAPI::Project).to receive(:retrieve).and_return(project)
      end

      it 'assigns the requested project as @project' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(assigns(:project)).to eq(@project)
      end

      it 'renders the show template' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(response).to render_template 'show'
      end

      it 'assigns the list of members with public profiles to @members' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(assigns(:members)).to eq @users
      end

      it 'assigns the list of related YouTube videos in created_at descending order' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(assigns(:event_instances)).to eq 'videos'
      end

      it 'assigns the count of related YouTube videos' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(assigns(:event_instances_count)).to eq 'count'
      end

      it 'assigns the list of related PivotalTracker stories' do
        get :show, params: { id: @project.friendly_id }.merge(valid_session)
        expect(assigns(:stories)).to eq 'stories'
      end
    end
  end
end
