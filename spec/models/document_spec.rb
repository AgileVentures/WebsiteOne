require 'spec_helper'

describe Document do

  before(:all) do
    class Document < ActiveRecord::Base
      has_paper_trail
    end
  end

  before do
    @project = Project.create!(valid_attributes_for(:project))
    @document = @project.documents.create!(valid_attributes_for(:document))
  end

  it { should be_versioned }

  context 'return false on invalid inputs' do
    it 'blank Title' do
      @document.title = ''
      expect(@document.save).to be_false
    end
    
    it 'blank project' do
      @document.project_id = nil
      expect(@document.save).to be_false
    end
  end

  # TODO Bryan: this scenario cannot be implemented with the current gem
  #it 'should allow friendly IDs to be shared between projects' do
  #  project = Project.create! valid_attributes_for(:project)
  #  doc = project.documents.create! title: @document.title
  #  expect(doc.friendly_id).to eq @document.friendly_id
  #end

  it 'should NOT allow friendly IDs to be shared within a project' do
    doc = Document.create(title: @document.title, project_id: @document.project_id)
    expect(doc.friendly_id).to_not eq @document.friendly_id
  end

  context 'return true on correct inputs' do
    it 'belongs to project' do
      expect(@document.project.nil?).to be_false
    end
  end
end
