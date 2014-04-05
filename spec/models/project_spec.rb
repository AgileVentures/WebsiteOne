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
    before(:each) { 9.times { FactoryGirl.create(:project) } }
    after(:each) { Project.delete_all }

    it 'returns paginated values' do
      Project.search(nil, nil).should eq Project.first 5
    end
  end

  describe '#all_tags' do
    it 'returns all project tags' do
      FactoryGirl.create(:project_with_tags, tags: ['Tag_1', 'Tag_2'])
      FactoryGirl.create(:project_with_tags, tags: ['Tag_2', 'Tag_3'])

      expect(Project.all_tags).to include('Tag_1', 'Tag_2', 'Tag_3')
    end
  end
end

