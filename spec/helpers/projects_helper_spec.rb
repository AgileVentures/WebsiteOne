require 'spec_helper'

include ProjectsHelper

describe ProjectsHelper do
  it 'returns time in correct format' do
    @project = mock_model(Project, created_at: DateTime.new(2000, 1, 1))
    created_date.should eq 'Created: 2000-01-01'
  end
end
