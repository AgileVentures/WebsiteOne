# frozen_string_literal: true

require 'spec_helper'

describe Coveralls::SimpleCov::Formatter do
  before do
    stub_api_post
  end

  def source_fixture(filename)
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', filename))
  end

  let(:result) do
    SimpleCov::Result.new(source_fixture('app/controllers/sample.rb') => [nil, 1, 1, 1, nil, 0, 1, 1, nil, nil],
                          source_fixture('app/models/airplane.rb')    => [0, 0, 0, 0, 0],
                          source_fixture('app/models/dog.rb')         => [1, 1, 1, 1, 1],
                          source_fixture('app/models/house.rb')       => [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                          source_fixture('app/models/robot.rb')       => [1, 1, 1, 1, nil, nil, 1, 0, nil, nil],
                          source_fixture('app/models/user.rb')        => [nil, 1, 1, 1, 1, 0, 1, 0, nil, nil],
                          source_fixture('sample.rb')                 => [nil, 1, 1, 1, nil, 0, 1, 1, nil, nil])
  end

  describe '#format' do
    context 'when should run' do
      before do
        Coveralls.testing = true
        Coveralls.noisy = false
      end

      it 'posts json' do
        expect(result.files).not_to be_empty
        silence do
          expect(described_class.new.format(result)).to be_truthy
        end
      end
    end

    context 'when should not run, noisy' do
      it 'only displays result' do
        silence do
          expect(described_class.new.display_result(result)).to be_truthy
        end
      end
    end

    context 'without files' do
      let(:result) { SimpleCov::Result.new({}) }

      it 'shows note that no files have been covered' do
        Coveralls.noisy = true
        Coveralls.testing = false

        silence do
          expect do
            described_class.new.format(result)
          end.not_to raise_error
        end
      end
    end

    context 'with api error' do
      it 'rescues' do
        e = SocketError.new

        silence do
          expect(described_class.new.display_error(e)).to be_falsy
        end
      end
    end

    describe '#get_source_files' do
      let(:source_files) { described_class.new.get_source_files(result) }

      it 'nils the skipped lines' do
        source_file = source_files.first
        expect(source_file[:coverage]).not_to eq result.files.first.coverage
        expect(source_file[:coverage]).to eq [nil, 1, 1, 1, nil, 0, 1, 1, nil, nil, nil, nil, nil]
      end
    end

    describe '#short_filename' do
      subject { described_class.new.short_filename(filename) }

      let(:filename) { '/app/app/controllers/application_controller.rb' }

      before do
        allow(SimpleCov).to receive(:root).and_return(root_path)
      end

      context 'with nil root path' do
        let(:root_path) { nil }

        it { is_expected.to eql filename }
      end

      context 'with multiple matches of root path' do
        let(:root_path) { '/app' }

        it { is_expected.to eql 'app/controllers/application_controller.rb' }
      end
    end
  end
end
