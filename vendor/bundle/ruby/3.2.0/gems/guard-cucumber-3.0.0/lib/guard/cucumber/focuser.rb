require "guard/compat/plugin"

module Guard
  class Cucumber < Plugin
    # The Cucumber focuser updates cucumber feature paths to
    # focus on sections tagged with a provided focus_tag.
    #
    # For example, if the `foo.feature` file has the provided focus tag
    # `@bar` on line 8, then the path will be updated using the cucumber
    # syntax for focusing on a section:
    #
    # foo.feature:8
    #
    # If '@bar' is found on lines 8 and 16, the path is updated as follows:
    #
    # foo.feature:8:16
    #
    # The path is not updated if it does not contain the focus tag.
    #
    module Focuser
      class << self
        # Focus the supplied paths using the provided focus tag.
        #
        # @param [Array<String>] paths the locations of the feature files
        # @param [String] focus_tag the focus tag to look for in each path
        # @return [Array<String>] the updated paths
        #
        def focus(paths, focus_tag)
          return false if paths.empty?

          paths.inject([]) do |updated_paths, path|
            focused_line_numbers = scan_path_for_focus_tag(path, focus_tag)

            if focused_line_numbers.empty?
              updated_paths << path
            else
              updated_paths << append_line_numbers_to_path(
                focused_line_numbers, path
              )
            end

            updated_paths
          end
        end

        # Checks to see if the file at path contains the focus tag
        # It will return an empty array if the path is a directory.
        #
        # @param [String] path the file path to search
        # @param [String] focus_tag the focus tag to look for in each path
        # @return [Array<Integer>] the line numbers that include the focus tag
        # in path
        #
        def scan_path_for_focus_tag(path, focus_tag)
          return [] if File.directory?(path) || path.include?(":")

          line_numbers = []

          File.open(path, "r") do |file|
            while (line = file.gets)
              if line.include?(focus_tag)
                line_numbers << file.lineno
              end
            end
          end

          line_numbers
        end

        # Appends the line numbers to the path
        #
        # @param [Array<Integer>] line_numbers the line numbers to append to
        # the path
        # @param [String] path the path that will receive the appended line
        # numbers
        # @return [String] the string containing the path appended with the
        # line number
        #
        def append_line_numbers_to_path(line_numbers, path)
          line_numbers.each { |num| path += ":" + num.to_s }

          path
        end
      end
    end
  end
end
