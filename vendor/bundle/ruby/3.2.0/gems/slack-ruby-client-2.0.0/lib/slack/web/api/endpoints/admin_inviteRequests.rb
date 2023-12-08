# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module AdminInviterequests
          #
          # Approve a workspace invite request.
          #
          # @option options [string] :invite_request_id
          #   ID of the request to invite.
          # @option options [string] :team_id
          #   ID for the workspace where the invite request was made.
          # @see https://api.slack.com/methods/admin.inviteRequests.approve
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/admin.inviteRequests/admin.inviteRequests.approve.json
          def admin_inviteRequests_approve(options = {})
            raise ArgumentError, 'Required arguments :invite_request_id missing' if options[:invite_request_id].nil?
            post('admin.inviteRequests.approve', options)
          end

          #
          # Deny a workspace invite request.
          #
          # @option options [string] :invite_request_id
          #   ID of the request to invite.
          # @option options [string] :team_id
          #   ID for the workspace where the invite request was made.
          # @see https://api.slack.com/methods/admin.inviteRequests.deny
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/admin.inviteRequests/admin.inviteRequests.deny.json
          def admin_inviteRequests_deny(options = {})
            raise ArgumentError, 'Required arguments :invite_request_id missing' if options[:invite_request_id].nil?
            post('admin.inviteRequests.deny', options)
          end

          #
          # List all pending workspace invite requests.
          #
          # @option options [string] :cursor
          #   Value of the next_cursor field sent as part of the previous API response.
          # @option options [integer] :limit
          #   The number of results that will be returned by the API on each invocation. Must be between 1 - 1000, both inclusive.
          # @option options [string] :team_id
          #   ID for the workspace where the invite requests were made.
          # @see https://api.slack.com/methods/admin.inviteRequests.list
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/admin.inviteRequests/admin.inviteRequests.list.json
          def admin_inviteRequests_list(options = {})
            if block_given?
              Pagination::Cursor.new(self, :admin_inviteRequests_list, options).each do |page|
                yield page
              end
            else
              post('admin.inviteRequests.list', options)
            end
          end
        end
      end
    end
  end
end
