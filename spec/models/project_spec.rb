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
