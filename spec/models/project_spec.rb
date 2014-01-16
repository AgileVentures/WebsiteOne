require 'spec_helper'

#TODO set constraint: unique titles?
describe Project do
  context '#save' do
    before(:each) do
      @project = stub_model(Project, title: 'Title', description: 'Description', status: 'Status')
    end
    let(:project) { @project }
    context 'returns false on invalid inputs' do
      it 'blank Title' do
        project.title = ''
        expect(project.save).to_not be_true
      end
      it 'blank Description' do
        project.description = ''
        expect(project.save).to_not be_true
      end
      it 'blank Status' do
        project.status = ''
        expect(project.save).to_not be_true
      end
    end
  end
end
