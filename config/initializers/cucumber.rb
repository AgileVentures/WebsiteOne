# frozen_string_literal: true

# Based on https://github.com/cucumber/cucumber-ruby/issues/1432
# HACK: this method was available in cucumber 3.1 and VCR relies on it to
# generate cassette names.
Cucumber::Core::Test::Case.class_eval do
  def feature
    string = File.read(location.file)
    document = ::Gherkin::Parser.new.parse(string)
    document[:feature]
  end
end
