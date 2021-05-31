# frozen_string_literal: true

RSpec.describe MarkdownConverter, type: :service do
  subject(:markdown_converter) { MarkdownConverter.new(markdown) }

  let(:markdown) { '#This is a title' }
  let(:kramdown) { double('Kramdown::Document', to_html: '<h1>This is a title</h1>') }

  describe '#as_html' do
    it 'returns html' do
      allow(Kramdown::Document).to receive(:new).with(markdown).and_return(kramdown)
      expect(markdown_converter.as_html).to eql('<h1>This is a title</h1>')
    end
  end
end
