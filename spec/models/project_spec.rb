require 'spec_helper'

#TODO set constraint: unique titles?
describe Project do
  context '#save' do
    before do
      @project = stub_model(Project, title: 'Title', description: 'Description', status: 'Status')
    end
    let(:project) { @project }
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

