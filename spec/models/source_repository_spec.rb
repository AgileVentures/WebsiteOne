# frozen_string_literal: true

describe SourceRepository, type: :model do
  it { is_expected.to belong_to :project }

  describe '#name' do
    subject(:source_repository) { described_class.new }
    it 'returns the empty string when url is nil' do
      expect(source_repository.name).to be_empty
    end
    it 'returns the url when it has no forward slashes' do
      source_repository.url = 'test'
      expect(source_repository.name).to eq source_repository.url
    end
    it 'returns the last text after the forward slash if one is present' do
      source_repository.url = 'test/name'
      expect(source_repository.name).to eq 'name'
    end
  end
end
