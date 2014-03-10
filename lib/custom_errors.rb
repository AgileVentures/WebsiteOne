module CustomErrors
  class << self
    def setup(options = {})
      anonymous = Module.new do

        def self.included(base)
          base.rescue_from Exception, with: ->(exception) { render_error 500, exception }

          base.rescue_from ActionController::RoutingError,
                           ActionController::UnknownController,
                           AbstractController::ActionNotFound,
                           ActiveRecord::RecordNotFound,
                           with: ->(exception) { render_error 404, exception }
        end

        private

        def render_error(status, error)
          raise error unless Rails.env.production?

          Rails.logger.error error.message
          error.backtrace.each_with_index { |line, index| Rails.logger.error line; break if index >= (options['log-limit'] || 5) }

          if options[status.to_s]
            hash = options[status.to_s]
            render template: hash['template'], layout: (hash['layout'] || 'layouts/application'), status: status
          else
            hash = options['500']
            if hash
              render template: hash['template'], layout: (hash['layout'] || 'layouts/application'), status: 500
            else
              raise error
            end
          end
        end
      end

      anonymous.class_eval %Q{
      def options
        @options ||= #{options.as_json}
      end
      }

      return anonymous
    end
  end
end