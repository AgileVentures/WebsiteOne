require 'spec_helper'

describe Document do

  before(:all) do
    class Document < ActiveRecord::Base
      has_paper_trail
    end
  end

  end
  before do
    @document = FactoryGirl.create(:document)
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

  context 'return true on correct inputs' do
    it 'belongs to project' do
      expect(@document.project.nil?).to be_false
    end
  end
end

