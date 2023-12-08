# frozen_string_literal: true
# This file was auto-generated by lib/tasks/web.rake

module Slack
  module Web
    module Api
      module Endpoints
        module AuthTeams
          #
          # List the workspaces a token can access.
          #
          # @option options [string] :cursor
          #   Set cursor to next_cursor returned by the previous call to list items in the next page.
          # @option options [boolean] :include_icon
          #   Whether to return icon paths for each workspace. An icon path represents a URI pointing to the image signifying the workspace.
          # @option options [integer] :limit
          #   The maximum number of workspaces to return. Must be a positive integer no larger than 1000.
          # @see https://api.slack.com/methods/auth.teams.list
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/auth.teams/auth.teams.list.json
          def auth_teams_list(options = {})
            if block_given?
              Pagination::Cursor.new(self, :auth_teams_list, options).each do |page|
                yield page
              end
            else
              post('auth.teams.list', options)
            end
          end
        end
      end
    end
  end
end
