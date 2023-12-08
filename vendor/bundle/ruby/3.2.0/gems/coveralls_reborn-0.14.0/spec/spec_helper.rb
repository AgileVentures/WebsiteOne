# frozen_string_literal: true

require 'simplecov'
require 'webmock'
require 'vcr'

require 'pry'

class InceptionFormatter
  def format(result)
    Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

def setup_formatter
  SimpleCov.formatter = if ENV['TRAVIS'] || ENV['COVERALLS_REPO_TOKEN']
                          InceptionFormatter
                        else
                          SimpleCov::Formatter::HTMLFormatter
                        end

  SimpleCov.start do
    add_filter do |source_file|
      source_file.filename =~ /spec/ && source_file.filename !~ /fixture/
    end
    add_filter %r{/.bundle/}
  end
end

setup_formatter

require 'coveralls'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include WebMock::API

  config.after(:suite) do
    setup_formatter
    WebMock.disable!
  end
end

def stub_api_post
  body = '{"message":"","url":""}'
  stub_request(:post, Coveralls::API::API_BASE + '/jobs').with(
    headers: {
      'Accept'          => '*/*; q=0.5, application/xml',
      'Accept-Encoding' => 'gzip, deflate',
      'Content-Length'  => /.+/,
      'Content-Type'    => /.+/,
      'User-Agent'      => 'Ruby'
    }
  ).to_return(status: 200, body: body, headers: {})
end

def silence
  return yield if ENV['silence'] == 'false'

  silence_stream(STDOUT) do
    yield
  end
end

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen(IO::NULL)
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
  old_stream.close
end
