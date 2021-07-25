# frozen_string_literal: true

RSpec.describe ProjectsController, type: :controller do
  let(:valid_attributes) do
    { id: 1,
      title: 'WebTwentyFive',
      description: 'My project description',
      status: 'active',
      pitch: 'My project pitch ...',
      pivotaltracker_url: 'https://www.pivotaltracker.com/s/projects/982890',
      slug: 'my-project' }
  end
  let(:valid_session) { {} }

  before :each do
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

    it 'is expected to render index page for projects' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'is expected to assign variables to be rendered by view' do
      allow(Project).to receive(:search).and_return(@project)
      @project.stub(:includes).and_return(@project)
      get :index
      expect(assigns(:projects).title).to eq 'Carrier has arrived.'
    end

    describe '#show' do
      let(:pivotal_tracker) { instance_double(PivotalAPI::Project) }

      before(:each) do
        @project = build_stubbed(:project, valid_attributes)
        allow(@project).to receive(:tag_list).and_return ['WSO']
        Project.stub_chain(:friendly, :find).and_return @project
        @project.stub_chain(:user, :display_name).and_return 'Happy User'
        @users = [build_stubbed(:user, slug: 'my-friendly-id', display_profile: true)]
        expect(@project).to receive(:members).and_return @users
        event_instances = double('event_instances')
        ordered_event_instances = double('ordered_event_instances')
        expect(EventInstance).to receive(:where).with(project_id: @project.id).and_return(event_instances)
        expect(event_instances).to receive(:order).with(created_at: :desc).and_return(ordered_event_instances)
        expect(event_instances).to receive(:count).and_return('count')
        expect(ordered_event_instances).to receive(:limit).with(25).and_return('videos')
        allow(PivotalAPI::Project).to receive(:retrieve).and_return(pivotal_tracker)
        allow(pivotal_tracker).to receive_messages(current_iteration: pivotal_tracker, stories: 'stories')
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

    describe '#new' do
      it 'is expected to render a new project page' do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
        expect(response).to render_template 'new'
      end
    end

    describe '#create' do
      before(:each) do
        @params = {
          project: {
            id: 1,
            title: 'Title 1',
            description: 'Description 1',
            status: 'Status 1'
          }
        }
        @project = mock_model(Project, friendly_id: 'some-project')
        allow(Project).to receive(:new).and_return(@project)
        allow(controller).to receive(:current_user).and_return(@user)
        allow(@project).to receive(:create_activity)
      end

      it 'assigns a newly created project as @project' do
        allow(@project).to receive(:save)
        post :create, params: @params
        expect(assigns(:project)).to eq @project
      end

      context 'successful save' do
        before(:each) do
          allow(@project).to receive(:save).and_return(true)
          post :create, params: @params
        end
        it 'redirects to index' do
          expect(response).to redirect_to(project_path(@project))
        end

        it 'received :create_activity with :create' do
          expect(@project).to have_received(:create_activity).with(:create, { owner: @user })
        end

        it 'assigns successful message' do
          # TODO: YA add a show view_spec to check if flash is actually displayed
          expect(flash[:notice]).to eq('Project was successfully created.')
        end

        it 'passes current_user id into new' do
          expect(Project).to receive(:new).with({ 'title' => 'Title 1', 'description' => 'Description 1',
                                                  'status' => 'Status 1', 'user_id' => @user.id })
          allow(@project).to receive(:save).and_return(true)
          post :create, params: @params
        end
      end

      context 'unsuccessful save' do
        it 'renders new template' do
          allow(@project).to receive(:save).and_return(false)

          post :create, params: @params

          expect(response).to render_template :new
        end

        it 'assigns failure message' do
          allow(@project).to receive(:save).and_return(false)

          post :create, params: @params

          expect(flash[:alert]).to eql('Project was not saved. Please check the input.')
        end
      end
    end

    describe '#edit' do
      before(:each) do
        @project = Project.new
        Project.stub_chain(:friendly, :find).with(an_instance_of(String)).and_return(@project)
        get :edit, params: { id: 'some-random-thing' }
      end

      it 'renders the edit template' do
        expect(response).to render_template 'edit'
      end

      it 'assigns the requested project as @project' do
        expect(assigns(:project)).to eq(@project)
      end
    end

    describe '#update' do
      before(:each) do
        @project = FactoryBot.create(:project)
        allow(@project).to receive(:create_activity)
        Project.stub_chain(:friendly, :find).with(an_instance_of(String)).and_return(@project)
      end

      it 'assigns the requested project as @project' do
        expect(@project).to receive(:update)
        put :update, params: { id: 'update', project: { title: '' } }
        expect(assigns(:project)).to eq(@project)
      end

      context 'successful update' do
        before(:each) do
          allow(@project).to receive(:update).and_return(true)
          put :update, params: { id: 'update', project: { title: '' } }
        end

        it 'received :create_activity with :update' do
          expect(@project).to have_received(:create_activity)
            .with(:update, { owner: @user })
        end

        it 'redirects to the project' do
          expect(response).to redirect_to(project_path(@project))
        end

        it 'shows a success message' do
          expect(flash[:notice]).to eq('Project was successfully updated.')
        end
      end

      context 'unsuccessful save' do
        before(:each) do
          allow(@project).to receive(:update).and_return(false)
          put :update, params: { id: 'update', project: { title: '' } }
        end
        it 'renders edit' do
          expect(response).to render_template(:edit)
        end

        it 'shows an unsuccessful message' do
          expect(flash[:alert]).to eq('Project was not updated.')
        end
      end
    end
  end
end
