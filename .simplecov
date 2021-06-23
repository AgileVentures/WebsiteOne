# frozen_string_literal: true

if ENV['COVERAGE']
  SimpleCov.start 'rails' do
    add_filter ['/test/', '/features/', '/spec/', 'lib/tasks']

    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
    add_group 'Presenters', 'app/presenters'
    add_group 'Helpers', 'app/helpers'
    add_group 'Services', 'app/services'
    add_group 'Mailers', 'app/mailers'
    add_group 'Jobs', 'app/jobs'
  end
end
