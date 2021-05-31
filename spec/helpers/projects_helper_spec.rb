# frozen_string_literal: true

describe ProjectsHelper do
  describe '#created_date' do
    it 'returns time in correct format' do
      @project = mock_model(Project, created_at: DateTime.new(2000, 1, 1))
      expect(created_date).to eq 'Created: 2000-01-01'
    end
  end
end
