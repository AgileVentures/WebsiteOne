# frozen_string_literal: true

module Helpers
  # Used to mimic the same method available in feature testing
  # ex.
  #   rendered.within('section#header') do |header|
  #     expect(header).to have_link 'Log Out'
  #   end
  # String.class_eval used instead of class String because the latter loads this as a constant, not a method!
  # Some insight to difference here: http://stackoverflow.com/a/10339348/2197402
  String.class_eval do
    def within(selector, &block)
      # https://github.com/jnicklas/capybara/issues/384#issuecomment-1667712
      Capybara.string(self).find(selector).tap(&block)
    end
  end

  def view_spec_page
    require 'launchy'
    filename = "tmp/view_spec_render-#{Time.now.to_i}.html"
    File.open(filename, 'w') { |file| file.write(rendered) }
    Launchy.open filename
  rescue LoadError
    warn 'Sorry, you need to install launchy to open pages: `gem install launchy`'
  end

  def get_country
    country = File.readlines("#{Rails.root}spec/fixtures/country_codes.txt").sample
    code, name = country.chomp.split('|')
    @country = { country_name: name, country_code: code }
  end
end

RSpec::Matchers.define :have_default_cc_addresses do
  match do |mail|
    mail.cc && (mail.cc.include? 'support@agileventures.org')
  end
end
