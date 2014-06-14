require 'spec_helper'

#TODO set constraint: unique titles?
describe Project do
  context '#save' do
    before(:each) do
      @project = Project.new title: 'Title',
                             description: 'Description',
                             status: 'ACTIVE'
    end
    let(:project) { @project }

    it 'should be a valid record' do
      project.should be_valid
    end

    context 'returns false on invalid inputs' do
      it 'blank Title' do
        project.title = ''
        expect(project.save).to be_false
      end

      it 'blank Description' do
        project.description = ''
        expect(project.save).to be_false
      end

      it 'blank Status' do
        project.status = ''
        expect(project.save).to be_false
      end

      it 'invalid github url' do
        project.github_url = 'https:/github.com/google/instant-hangouts'
        expect(project.save).to be_false
      end
    end

    context 'GitHub URL' do
    end

    context 'Pivotal Tracker URL' do
      it 'should correct mistakes in pivotal tracker url' do
        project.pivotaltracker_url = 'www.pivotaltracker.com/s/projects/1234'
        expect(project.valid?).to be_true
        expect(project.pivotaltracker_url).to eq 'https://www.pivotaltracker.com/s/projects/1234'
      end

      it 'should accept the project id and convert that into a valid URL' do
        project.pivotaltracker_url = '1234'
        expect(project.valid?).to be_true
        expect(project.pivotaltracker_url).to eq 'https://www.pivotaltracker.com/s/projects/1234'
      end

      %w(
        hahaIamInvalid
        www.pivotaltracker.com/this-is-invalid
        https://www.pivotaltracker.com/s/../../912312
        http://www.evilplace.com/this/is/a/malicious/script
      ).each do |url|
        it "should not accept '#{url}' as a valid Pivotal Tracker URL" do
          project.pivotaltracker_url = url
          expect(project.valid?).to be_false
        end
      end
    end
  end

  describe '::search' do
    before(:each) { 9.times { FactoryGirl.create(:project) } }

    it 'should return paginated projects with 5 per page' do
      expect(Project.search(nil, nil).per_page).to eq(5)
    end
  end

  describe '#members' do
    before do
      @project = Project.new title: 'Title',
                             description: 'Description',
                             status: 'ACTIVE'
    end
    it 'should only return followers of the project' do
      @users = [ mock_model(User, friendly_id: 'my-friendly-id', display_profile: true) ]
      @project.should_receive(:followers).and_return(@users)
      expect(@project.members).to eq(@users)
    end

    it 'should only return with public profiles' do
      @users = [ mock_model(User, friendly_id: 'my-friendly-id', display_profile: true) ]
      @more_users = @users + [ mock_model(User, friendly_id: 'another-friendly-id', display_profile: false)]
      @project.should_receive(:followers).and_return(@more_users)
      expect(@project.members).to eq(@users)
    end
  end

  describe '#videos' do
    it 'retrieves project videos from youtube by calling the YoutubeService' do
      project = FactoryGirl.create(:project)

      mock_service = YoutubeService.new(double(Project))
      YoutubeService.should_receive(:new).with(project).and_return(mock_service)
      mock_service.should_receive(:videos)

      project.videos
    end
  end

  describe '#url_for_me' do
    before(:each) do
      @project = Project.new title: 'Title',
                             description: 'Description',
                             status: 'ACTIVE'
    end

    it 'returns correct url for show action' do
      @project.url_for_me('show').should eq "/projects/#{@project.slug}"
    end

    it 'returns correct url for other actions' do
      @project.url_for_me('new').should eq "/projects/#{@project.slug}/new"
    end
  end

end

