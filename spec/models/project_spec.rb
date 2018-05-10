require 'spec_helper'

describe Project, type: :model do

  it { is_expected.to have_many :source_repositories}
  it { is_expected.to have_many :documents}
  it { is_expected.to have_many :event_instances}
  it { is_expected.to have_many :commit_counts}

  it { is_expected.to belong_to :user}

  context '#save' do
    subject { build_stubbed(:project) }
    it { is_expected.to respond_to :create_activity }

    it 'has public-activity enabled' do
      expect(subject.public_activity_enabled?).to eq true
    end

    it 'should be a valid with all the correct attributes' do
      expect(subject).to be_valid
    end

    it 'should be invalid without title' do
      subject.title = ''
      expect(subject).to_not be_valid
    end

    it 'should be invalid without description' do
      subject.description = ''
      expect(subject).to_not be_valid
    end

    it 'should be invalid without status' do
      subject.status = ''
      expect(subject).to_not be_valid
    end

    it 'should not accept invalid github url' do
      subject.source_repositories.create(url: 'https:/github.com/google/instant-hangouts')
      expect(subject).to_not be_valid
    end

    it 'should throw error for incomplete github url' do
      subject.source_repositories.create(url: 'https://github.com/edx')
      expect{ subject.github_repo_name }.to raise_error(NoMethodError, "undefined method `[]' for nil:NilClass")
    end

    it 'should not accept invalid Pivotal Tracker URL' do
      subject.pivotaltracker_url = 'https://www.pivotaltracker.com/s/../../912312'
      expect(subject).to_not be_valid
    end

    context "Updating friendly ids" do
      let(:project) { create(:project, title: 'Old news') }
      before { project.update(title: 'New and seksay title') }

      it "should regenerate the project's friendly id when the title changes" do
        expect(project.friendly_id).to eq 'new-and-seksay-title'
      end

      it "should still be able to find the project by its old id" do
        expect(Project.friendly.find('old-news')).to eq project
      end
    end

    context 'Pivotal Tracker URL' do
      it 'should correct mistakes in pivotal tracker url' do
        subject.pivotaltracker_url = 'www.pivotaltracker.com/s/projects/1234'
        expect(subject).to be_valid
        expect(subject.pivotaltracker_url).to eq 'https://www.pivotaltracker.com/n/projects/1234'
      end

      it 'should accept the subject id and convert that into a valid URL' do
        subject.pivotaltracker_url = '1234'
        expect(subject).to be_valid
        expect(subject.pivotaltracker_url).to eq 'https://www.pivotaltracker.com/n/projects/1234'
      end

      it 'should accept new pivotal traker url format' do
        subject.pivotaltracker_url = 'www.pivotaltracker.com/n/projects/1234'
        expect(subject).to be_valid
        expect(subject.pivotaltracker_url).to eq 'https://www.pivotaltracker.com/n/projects/1234'
      end
    end
  end

  describe '#search' do
    before(:each) { build_stubbed_list(:project, 9) }

    it 'should return paginated projects with 5 per page' do
      expect(Project.search(nil, nil).per_page).to eq(5)
    end
  end

  describe '#url_for_me' do
    it 'returns correct url for show action' do
      expect(subject.url_for_me('show')).to eq "/projects/#{subject.slug}"
    end

    it 'returns correct url for other actions' do
      expect(subject.url_for_me('new')).to eq "/projects/#{subject.slug}/new"
    end
  end

  describe "#youtube_tags" do
    it 'returns the tags for project including the project title' do
      project = build_stubbed(:project, title: "WebsiteOne", tag_list: ["WSO"])
      expect(project.youtube_tags).to eq ["wso", "websiteone"]
    end
  end

  describe "#members_tags" do
    it 'returns the tags for project members with thier youtube user names' do
      users = [User.new(youtube_user_name: 'test_id'), User.new(youtube_user_name: 'test_id_2')]
      allow(subject).to receive(:members).and_return(users)
      expect(subject.members_tags).to eq ["test_id", "test_id_2"]
    end
  end

  describe "#members" do
    it 'returns followers of the project who have a public profile' do
      @users = [ User.new(slug: 'my-friendly-id', display_profile: true) ]
      @more_users = @users + [ User.new(slug: 'another-friendly-id', display_profile: false)]
      allow(subject).to receive(:followers).and_return(@more_users)

      expect(subject.members).to eq @users
    end
  end

  describe "#github_repo" do
    it 'returns blank if github url does not exist' do
      project = build_stubbed(:project, github_url: nil)
      expect(project.github_repo).to be_blank
    end

    it 'returns the proper repo name if github url exists' do
      project = build_stubbed(:project)
      project.source_repositories.create(url: 'https://github.com/AgileVentures/WebsiteOne')
      expect(project.github_repo).to eq 'AgileVentures/WebsiteOne'
    end
  end

  describe "#contribution_url" do
    it 'returns the url for the project github contribution page' do
      allow(subject).to receive(:github_repo).and_return('test/test')
      expect(subject.contribution_url).to eq "https://github.com/test/test/graphs/contributors"
    end
  end

  describe "#github_repo_user_name" do
    it 'deals with hyphen gracefully' do
      project = build_stubbed(:project)
      project.source_repositories.create(url: 'https://github.com/AgileVentures/shf-project')
      expect(project.github_repo_user_name).to eq 'shf-project'
    end
  end

  describe '#codeclimate_gpa' do

    subject(:project) { build_stubbed(:project, github_url: 'https://github.com/AgileVentures/WebsiteOne') }

    it 'returns the CodeClimate GPA' do
      expect(CodeClimateBadges).to receive_message_chain(:new, :gpa).and_return('3.4')
      expect(project.gpa).to eq '3.4'
    end
  end

  context '#jitsi_room_link' do
    it 'returns correct link' do
      project = FactoryBot.build(:project, title: 'Simple Project-~!@#$')
      expect(project.jitsi_room_link).to eq('https://meet.jit.si/AV_Simple_Project')
    end
  end

  context '.with_github_url' do
    it 'returns all projects that have at least one source repository' do
      project = FactoryBot.create(:project)
      project.source_repositories.create(url: 'https://github.com/AgileVentures/shf-project')
      project2 = FactoryBot.create(:project)
      project2.source_repositories.create(url: 'https://github.com/AgileVentures/shf-project2')
      expect(Project.with_github_url).to include(project, project2)
    end

    it 'does not return projects that do not have a source repository' do
      project = FactoryBot.build(:project)
      expect(Project.with_github_url).not_to include(project)
    end
  end
  
  describe '#send_notification_to_project_creator' do
    it 'does not send an email when user\'s receive_mailings attribute is set to false' do
      user = FactoryBot.create(:user, receive_mailings: false)
      project = FactoryBot.create(:project, user: user)
      mail = project.send_notification_to_project_creator(user)
      expect(mail).to be_nil
    end
  end
end
