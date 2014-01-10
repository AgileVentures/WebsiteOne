require 'spec_helper'

describe 'projects/projects.html.erb' do

  # this is duplicating the specs in cuc scenario, but we have it here anyway
  describe "content elements" do
    it 'should have text List of projects'
    it 'should have text Title'
    it 'should have text Description'
    it 'should have text Created'
    it 'should have text Status'
  end

  describe "content formatting" do
    it 'should be in a table'
    it 'should have columns'
    it 'should be wide or narrow or whatever'
  end

end