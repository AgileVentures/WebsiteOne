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

  describe '#search' do
    before(:each) { 9.times { build_stubbed(:project) } }

    it 'should return paginated projects with 5 per page' do
      expect(Project.search(nil, nil).per_page).to eq(5)
    end
  end

  describe '#all_tags' do
    it 'returns all project tags' do
      FactoryGirl.create(:project_with_tags, tags: ['Tag_1', 'Tag_2'])
      FactoryGirl.create(:project_with_tags, tags: ['Tag_2', 'Tag_3'])

      expect(Project.all_tags).to include('Tag_1', 'Tag_2', 'Tag_3')
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
      project = Project.new
      allow(project).to receive(:members).and_return(users)
      expect(project.members_tags).to eq ["test_id", "test_id_2"]
    end
  end

  describe "#members" do
    it 'returns followers of the project who have a public profile' do
      project = build_stubbed(:project)
      @users = [ User.new(slug: 'my-friendly-id', display_profile: true) ]
      @more_users = @users + [ User.new(slug: 'another-friendly-id', display_profile: false)]
      allow(project).to receive(:followers).and_return(@more_users)

      expect(project.members).to eq @users
    end
  end
end

