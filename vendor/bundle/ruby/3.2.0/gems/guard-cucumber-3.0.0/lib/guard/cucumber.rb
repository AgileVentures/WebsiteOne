require "cucumber"
require "guard/cucumber/version"
require "guard/cucumber/runner"
require "guard/cucumber/inspector"
require "guard/cucumber/focuser"

module Guard
  # The Cucumber guard that gets notifications about the following
  # Guard events: `start`, `stop`, `reload`, `run_all` and `run_on_change`.
  #
  class Cucumber < Plugin
    attr_accessor :last_failed, :failed_path

    KNOWN_OPTIONS = %w(
      cmd
      cmd_additional_args

      all_after_pass
      all_on_start
      keep_failed
      feature_sets

      run_all
      focus_on
      notification
    ).map(&:to_sym)

    # Initialize Guard::Cucumber.
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [Array<String>] :feature_sets a list of non-standard
    # feature directory/ies
    # @option options [Boolean] :notification show notifications
    # @option options [Boolean] :all_after_pass run all features after changed
    # features pass
    # @option options [Boolean] :all_on_start run all the features at startup
    # @option options [Boolean] :keep_failed Keep failed features until they
    # pass
    # @option options [Boolean] :run_all run override any option when running
    # all specs
    # @option options [Boolean] :cmd the command to run
    # @option options [Boolean] :cmd_additional_args additional args to append
    #
    def initialize(options = {})
      super(options)

      @options = {
        all_after_pass: true,
        all_on_start: true,
        keep_failed: true,
        cmd: "cucumber",
        cmd_additional_args: "--no-profile --color --format progress --strict",
        feature_sets: ["features"]
      }.update(options)

      unknown_options = @options.keys - KNOWN_OPTIONS
      unknown_options.each do |unknown|
        msg = "Unknown guard-cucumber option: #{unknown.inspect}"
        Guard::Compat::UI.warning(msg)
      end

      @last_failed  = false
      @failed_paths = []
    end

    # Gets called once when Guard starts.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def start
      run_all if @options[:all_on_start]
    end

    # Gets called when all specs should be run.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def run_all
      opts = options.merge(options[:run_all] || {})
      opts[:message] = "Running all features"
      passed = Runner.run(options[:feature_sets], opts)

      if passed
        @failed_paths = []
      elsif @options[:keep_failed]
        @failed_paths = read_failed_features
      end

      @last_failed = !passed

      throw :task_has_failed unless passed
    end

    # Gets called when the Guard should reload itself.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def reload
      @failed_paths = []
    end

    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    # @raise [:task_has_failed] when stop has failed
    #
    def run_on_modifications(paths)
      paths += @failed_paths if @options[:keep_failed]
      paths = Inspector.clean(paths, options[:feature_sets])

      options = @options

      msg = "Running all features"
      options[:message] = msg if paths.include?("features")

      _run(paths, options)
    end

    private

    # Read the failed features that from `rerun.txt`
    #
    # @see Guard::Cucumber::NotificationFormatter#write_rerun_features
    # @return [Array<String>] the list of features
    #
    def read_failed_features
      failed = []

      if File.exist?("rerun.txt")
        failed = File.open("rerun.txt") { |file| file.read.split(" ") }
        File.delete("rerun.txt")
      end

      failed
    end

    def _run(paths, options)
      if Runner.run(paths, options)
        # clean failed paths memory
        @failed_paths -= paths if @options[:keep_failed]
        # run all the specs if the changed specs failed, like autotest
        run_all if @last_failed && @options[:all_after_pass]
        return
      end

      # remember failed paths for the next change
      @failed_paths += read_failed_features if @options[:keep_failed]
      # track whether the changed feature failed for the next change
      @last_failed = true
      throw :task_has_failed
    end
  end
end
