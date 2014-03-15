module Helpers

  # Used to mimic the same method available in feature testing
  # ex.
  #   rendered.within('section#header') do |header|
  #     header.should have_link 'Log Out'
  #   end
  # String.class_eval used instead of class String because the latter loads this as a constant, not a method!
  # Some insight to difference here: http://stackoverflow.com/a/10339348/2197402
  String.class_eval do
    def within(selector)
      # https://github.com/jnicklas/capybara/issues/384#issuecomment-1667712
      Capybara.string(self).find(selector).tap do |selection|
        yield selection
      end
    end
  end

  def invalid_attributes_for(symbol)
    case symbol
      when :event
        {
            event_date: 'Mon, 17 Jun 2013',
            start_time: '2000-01-01 09:00:00 UTC',
            end_time: '2000-01-01 2:00:00 UTC',
            repeats: 'never',
            repeats_every_n_weeks: nil,
            repeat_ends: 'never',
            repeat_ends_on: 'Mon, 17 Jun 2013',
            time_zone: 'Eastern Time (US & Canada)'
        }.as_json

      else
        pending
    end
  end

  def valid_attributes_for(symbol)
    case symbol
      when :event
        {
            name: 'one time event',
            category: 'Scrum',
            description: '',
            event_date: 'Mon, 17 Jun 2013',
            start_time: '2000-01-01 09:00:00 UTC',
            end_time: '2000-01-01 17:00:00 UTC',
            repeats: 'never',
            repeats_every_n_weeks: nil,
            repeat_ends: 'never',
            repeat_ends_on: 'Mon, 17 Jun 2013',
            time_zone: 'Eastern Time (US & Canada)'
        }.as_json

      when :project
        {
            title: Faker::Company.catch_phrase,
            description: Faker::Company.bs,
            status: 'ACTIVE'
        }.as_json

      when :document
        {
            title: Faker::Company.catch_phrase,
            body: Faker::Company.bs
        }.as_json

      else
        pending
    end
  end

end