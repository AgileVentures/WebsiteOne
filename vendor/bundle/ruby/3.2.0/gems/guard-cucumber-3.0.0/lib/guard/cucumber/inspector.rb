require "guard/compat/plugin"

module Guard
  class Cucumber < Plugin
    # The inspector verifies of the changed paths are valid
    # for Guard::Cucumber.
    #
    module Inspector
      class << self
        # Clean the changed paths and return only valid
        # Cucumber features.
        #
        # @param [Array<String>] paths the changed paths
        # @param [Array<String>] feature_sets the feature sets
        # @return [Array<String>] the valid feature files
        #
        def clean(paths, sets)
          paths.uniq!
          paths.compact!
          paths = paths.select do |p|
            cucumber_file?(p, sets) || cucumber_folder?(p, sets)
          end
          paths = paths.delete_if { |p| included_in_other_path?(p, paths) }
          clear_cucumber_files_list
          paths
        end

        private

        # Tests if the file is the features folder.
        #
        # @param [String] path the file
        # @param [Array<String>] feature_sets the feature sets
        # @return [Boolean] when the file is the feature folder
        #
        def cucumber_folder?(path, feature_sets)
          sets = feature_sets.join("|")
          path.match(/^\/?(#{ sets })/) && !path.match(/\..+$/)
        end

        # Tests if the file is valid.
        #
        # @param [String] path the file
        # @param [Array<String>] feature_sets the feature sets
        # @return [Boolean] when the file valid
        #
        def cucumber_file?(path, feature_sets)
          cucumber_files(feature_sets).include?(path.split(":").first)
        end

        # Scans the project and keeps a list of all
        # feature files in the `features` directory.
        #
        # @see #clear_jasmine_specs
        # @param [Array<String>] feature_sets the feature sets
        # @return [Array<String>] the valid files
        #
        def cucumber_files(feature_sets)
          glob = "#{feature_sets.join(',')}/**/*.feature"
          @cucumber_files ||= Dir.glob(glob)
        end

        # Clears the list of features in this project.
        #
        def clear_cucumber_files_list
          @cucumber_files = nil
        end

        # Checks if the given path is already contained
        # in the paths list.
        #
        # @param [Sting] path the path to test
        # @param [Array<String>] paths the list of paths
        #
        def included_in_other_path?(path, paths)
          paths = paths.select { |p| p != path }
          massaged = path[0...(path.index(":") || path.size)]
          paths.any? { |p| _path_includes(path, p, massaged) }
        end

        private

        def _path_includes(path, p, massaged)
          includes = path.include?(p)
          return true if includes && path.gsub(p, "").include?("/")
          massaged.include?(p)
        end
      end
    end
  end
end
