require "guard/compat/plugin"

require "guard/cucumber/focuser"

module Guard
  class Cucumber < Plugin
    # The Cucumber runner handles the execution of the cucumber binary.
    #
    module Runner
      class << self
        # Run the supplied features.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [Array<String>] :feature_sets a list of non-standard
        # feature directory/ies
        # @option options [Boolean] :notification show notifications
        # prefix to the cucumber command. Ideal for running xvfb-run for
        # terminal only cucumber tests.
        # @return [Boolean] the status of the execution
        #
        def run(paths, options = {})
          return false if paths.empty?

          cmd = cucumber_command(paths, options)

          msg1 = "Running all Cucumber features: #{cmd}"
          msg2 = "Running Cucumber features: #{cmd}"
          msg = (paths == ["features"] ? msg1 : msg2)

          message = options[:message] || msg

          paths = Focuser.focus(paths, options[:focus_on]) if options[:focus_on]
          cmd = cucumber_command(paths, options)

          Compat::UI.info message, reset: true

          system(cmd)
        end

        private

        # Assembles the Cucumber command from the passed options.
        #
        # @param [Array<String>] paths the feature files or directories
        # @param [Hash] options the options for the execution
        # @option options [Boolean] :notification show notifications
        # prefix to the cucumber command. Ideal for running xvfb-run for
        # terminal only cucumber tests.
        # @return [String] the Cucumber command
        #
        def cucumber_command(paths, options)
          cmd = []
          _add_cli_options(cmd, options[:cmd] || "cucumber")
          _add_notification(cmd, options)
          _add_cli_options(cmd, options[:cmd_additional_args])
          (cmd + paths).join(" ")
        end

        # Returns a null device for all OS.
        #
        # @return [String] the name of the null device
        #
        def null_device
          RUBY_PLATFORM.index("mswin") ? "NUL" : "/dev/null"
        end

        private

        def _add_notification(cmd, options)
          return unless options[:notification] != false

          this_dir = File.dirname(__FILE__)
          formatter_path = File.join(this_dir, "notification_formatter.rb")
          notification_formatter_path = File.expand_path(formatter_path)

          cmd << "--require #{notification_formatter_path}"
          cmd << "--format Guard::Cucumber::NotificationFormatter"
          cmd << "--out #{null_device}"
          cmd << (options[:feature_sets] || ["features"]).map do |path|
            "--require #{path}"
          end.join(" ")
        end

        def _add_cli_options(cmd, cli)
          cmd << cli if cli
        end
      end
    end
  end
end
