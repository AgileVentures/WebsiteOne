# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module Dialog
          #
          # Open a dialog with a user
          #
          # @option options [string] :dialog
          #   The dialog definition. This must be a JSON-encoded string.
          # @option options [string] :trigger_id
          #   Exchange a trigger to post to the user.
          # @see https://api.slack.com/methods/dialog.open
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/dialog/dialog.open.json
          def dialog_open(options = {})
            raise ArgumentError, 'Required arguments :dialog missing' if options[:dialog].nil?
            raise ArgumentError, 'Required arguments :trigger_id missing' if options[:trigger_id].nil?
            # dialog must be passed as an encoded JSON string
            if options.key?(:dialog)
              dialog = options[:dialog]
              dialog = JSON.dump(dialog) unless dialog.is_a?(String)
              options = options.merge(dialog: dialog)
            end
            post('dialog.open', options)
          end
        end
      end
    end
  end
end
