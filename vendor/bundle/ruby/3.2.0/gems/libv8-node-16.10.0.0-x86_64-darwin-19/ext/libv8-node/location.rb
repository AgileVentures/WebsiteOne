# frozen_string_literal: true

require 'yaml'
require 'pathname'
require File.expand_path('paths', __dir__)

module Libv8; end

module Libv8::Node
  class Location
    def install!
      File.open(Pathname(__FILE__).dirname.join('.location.yml'), 'w') do |f|
        f.write(to_yaml)
      end

      0
    end

    def self.load!
      File.open(Pathname(__FILE__).dirname.join('.location.yml')) do |f|
        YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(f) : YAML.load(f) # rubocop:disable Security/YAMLLoad
      end
    end

    class Vendor < Location
      def install!
        require File.expand_path('builder', __dir__)

        builder = Libv8::Node::Builder.new
        exit_status = builder.build_libv8!
        builder.remove_intermediates!

        super if exit_status == 0

        verify_installation!

        exit_status
      end

      def configure(context = MkmfContext.new)
        context.incflags.insert(0, Libv8::Node::Paths.include_paths.map { |p| "-I#{p}" }.join(' ') << ' ')
        context.ldflags.insert(0, Libv8::Node::Paths.object_paths.join(' ') << ' ')
      end

      def verify_installation!
        include_paths = Libv8::Node::Paths.include_paths

        unless include_paths.detect { |p| Pathname(p).join('v8.h').exist? }
          raise(HeaderNotFound, "Unable to locate 'v8.h' in the libv8 header paths: #{include_paths.inspect}")
        end

        Libv8::Node::Paths.object_paths.each do |p|
          raise(ArchiveNotFound, p) unless File.exist?(p)
        end
      end

      class HeaderNotFound < StandardError; end

      class ArchiveNotFound < StandardError
        def initialize(filename)
          super "libv8 did not install properly, expected binary v8 archive '#{filename}'to exist, but it was not found"
        end
      end
    end

    class MkmfContext
      def incflags
        $INCFLAGS # rubocop:disable Style/GlobalVars
      end

      def ldflags
        $LDFLAGS # rubocop:disable Style/GlobalVars
      end
    end
  end
end
