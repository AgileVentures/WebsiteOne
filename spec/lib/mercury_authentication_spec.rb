require 'spec_helper'
require 'mercury/authentication.rb'

describe Mercury::Authentication, type: 'controller' do
  controller do
    include Mercury::Authentication
  end

  context 'when not signed in' do
    before do
      controller.stub(user_signed_in?: false)
    end

    it 'does not allow user to edit page' do
      (controller.can_edit?).should be_false
    end

    it 'sets proper flash message' do
      controller.can_edit?
      expect(flash[:alert]).to eq 'You do not have the right privileges to complete action.'
    end
  end

  context 'when signed in' do
    before do
      controller.stub(user_signed_in?: true)
    end

    it 'allows user to edit project documents' do
      controller.request.env['PATH_INFO'] = 'editor/projects/hello/documents/test'
      (controller.can_edit?).should be_true
    end

    it 'allows user to edit project sub-documents' do
      controller.request.env['PATH_INFO'] = 'editor/projects/hello/documents/test/test2'
      (controller.can_edit?).should be_true
    end

    it 'allows user to edit valid static pages' do
      controller.request.env['PATH_INFO'] = '/about-us'
      StaticPage.stub_chain(:friendly, :exists?).and_return(true)
      (controller.can_edit?).should be_true
    end

    it 'does not allow user to edit invalid static pages or path' do
      controller.request.env['PATH_INFO'] = '/fake=page'
      StaticPage.stub_chain(:friendly, :exists?).and_return(false)
      (controller.can_edit?).should be_false
    end
  end
end