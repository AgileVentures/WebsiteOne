# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module Api
          #
          # Checks API calling code.
          #
          # @option options [string] :error
          #   Error response to return.
          # @see https://api.slack.com/methods/api.test
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/api/api.test.json
          def api_test(options = {})
            post('api.test', options)
          end
        end
      end
    end
  end
end
