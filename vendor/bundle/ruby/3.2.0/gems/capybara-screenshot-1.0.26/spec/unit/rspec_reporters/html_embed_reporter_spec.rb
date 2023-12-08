require 'spec_helper'

describe Capybara::Screenshot::RSpec::HtmlEmbedReporter do
  include_context 'html reporter'

  context 'when an image was saved' do
    before do
      set_example double("example", metadata: {screenshot: {image: "path/to/image"}})
    end

    it 'embeds the image base64 encoded into the content' do
      expect(File).to receive(:binread).with("path/to/image").and_return("image data")
      encoded_image_data = Base64.encode64('image data')
      content_without_styles = @reporter.extra_failure_content(nil).gsub(/ ?style='.*?' ?/, "")
      expect(content_without_styles).to eql("original content<img src='data:image/png;base64,#{encoded_image_data}'>")
    end
  end

  context 'when an image was saved to s3' do
    let(:s3_image_url) { "http://s3.amazon.com/path/to/image" }

    before do
      set_example double("example", metadata: {screenshot: {image: s3_image_url}})
    end

    it 'embeds the image URL into the content' do
      content_without_styles = @reporter.extra_failure_content(nil).gsub(/ ?style='.*?' ?/, "")
      expect(content_without_styles).to eql("original content<img src='#{s3_image_url}'>")
    end
  end
end
