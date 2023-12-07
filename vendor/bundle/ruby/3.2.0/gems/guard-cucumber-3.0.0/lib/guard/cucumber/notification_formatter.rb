# Conditionally require this because it's run outside Guard
#
if Object.const_defined?(:Guard)
  # TODO: MOVE THIS OUTSIDE THE FORMATTER!!!!
  # TODO: (call notify() in Guard::Cucumber, not here in formatter

  # If notifier is defined it's likely Guard::Compat::Plugin's stub
  unless Guard.const_defined?(:Notifier)
    require "guard"
    require "guard/notifier"
  end
end

require "cucumber"
require "guard/compat/plugin"

require "cucumber/formatter/console"
require "cucumber/formatter/io"

module Guard
  class Cucumber < Plugin
    # The notification formatter is a Cucumber formatter that Guard::Cucumber
    # passes to the Cucumber binary. It writes the `rerun.txt` file with the
    # failed features
    # an creates system notifications.
    #
    # @see https://github.com/cucumber/cucumber/wiki/Custom-Formatters
    #
    class NotificationFormatter
      include ::Cucumber::Formatter::Console

      attr_reader :step_mother

      # Initialize the formatter.
      #
      # @param [Cucumber::Runtime] step_mother the step mother
      # @param [String, IO] path_or_io the path or IO to the feature file
      # @param [Hash] options the options
      #
      def initialize(step_mother, _path_or_io, options)
        @options = options
        @file_names = []
        @step_mother = step_mother
        @feature = nil
      end

      def before_background(_background)
        # NOTE: background.feature is nil on newer gherkin versions
      end

      def before_feature(feature)
        @feature = feature
      end

      # Notification after all features have completed.
      #
      # @param [Array[Cucumber::Ast::Feature]] features the ran features
      #
      def after_features(_features)
        notify_summary
        write_rerun_features if !@file_names.empty?
      end

      # Before a feature gets run.
      #
      # @param [Cucumber::Ast::FeatureElement] feature_element
      #
      def before_feature_element(_feature_element)
        @rerun = false
        # TODO: show feature element name instead?
        # @feature = feature_element.name
      end

      # After a feature gets run.
      #
      # @param [Cucumber::Ast::FeatureElement] feature_element
      #
      def after_feature_element(feature_element)
        if @rerun
          @file_names << feature_element.location.to_s
          @rerun = false
        end
      end

      # Gets called when a step is done.
      #
      # @param [String] keyword the keyword
      # @param [Cucumber::StepMatch] step_match the step match
      # @param [Symbol] status the status of the step
      # @param [Integer] source_indent the source indentation
      # @param [Cucumber::Ast::Background] background the feature background
      # @param [String] file name and line number describing where the step is
      # used
      #
      def step_name(_keyword, step_match, status, _src_indent, _bckgnd, _loc)
        return unless [:failed, :pending, :undefined].index(status)

        @rerun = true
        step_name = step_match.format_args(lambda { |param| "*#{param}*" })

        options = { title: @feature.name, image: icon_for(status) }
        Guard::Compat::UI.notify(step_name, options)
      end

      private

      # Notify the user with a system notification about the
      # result of the feature tests.
      #
      def notify_summary
        # TODO: MOVE THIS OUTSIDE THE FORMATTER!!!!
        statuses = [:failed, :skipped, :undefined, :pending, :passed]
        statuses = statuses.reverse
        statuses.select! { |status| step_mother.steps(status).any? }

        messages = statuses.map { |status| status_to_message(status) }

        icon = statuses.reverse.detect { |status| icon_for(status) }

        msg = messages.reverse.join(", ")
        Guard::Compat::UI.notify msg, title: "Cucumber Results", image: icon
      end

      # Writes the `rerun.txt` file containing all failed features.
      #
      def write_rerun_features
        File.open("rerun.txt", "w") do |f|
          f.puts @file_names.join(" ")
        end
      end

      # Gives the icon name to use for the status.
      #
      # @param [Symbol] status the cucumber status
      # @return [Symbol] the Guard notification symbol
      #
      def icon_for(status)
        case status
        when :passed
          :success
        when :pending, :undefined, :skipped
          :pending
        when :failed
          :failed
        end
      end

      def dump_count(count, what, state = nil)
        [count, state, "#{what}#{count == 1 ? '' : 's'}"].compact.join(' ')
      end

      def status_to_message(status)
        len = step_mother.steps(status).length
        dump_count(len, "step", status.to_s)
      end
    end
  end
end
