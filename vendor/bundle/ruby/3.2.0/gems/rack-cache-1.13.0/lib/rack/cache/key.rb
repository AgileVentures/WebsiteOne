require 'rack/utils'

module Rack::Cache
  class Key
    include Rack::Utils

    # A proc for ignoring parts of query strings when generating a key. This is
    # useful when you have parameters like `utm` or `trk` that don't affect the
    # content on the page and are unique per-visitor or campaign. Parameters
    # like these will be part of the key and cause a lot of churn.
    #
    # The block will be passed a key and value which are the name and value of
    # that parameter.
    #
    # Example:
    #   `Rack::Cache::Key.query_string_ignore = proc { |k, v| k =~ /^(trk|utm)_/ }`
    #
    class << self
      attr_accessor :query_string_ignore
    end

    # Implement .call, since it seems like the "Rack-y" thing to do. Plus, it
    # opens the door for cache key generators to just be blocks.
    def self.call(request)
      new(request).generate
    end

    def initialize(request)
      @request = request
    end

    # Generate a normalized cache key for the request.
    def generate
      parts = []
      parts << @request.scheme << "://"
      parts << @request.host

      if @request.scheme == "https" && @request.port != 443 ||
          @request.scheme == "http" && @request.port != 80
        parts << ":" << @request.port.to_s
      end

      parts << @request.script_name
      parts << @request.path_info

      if qs = query_string
        parts << "?"
        parts << qs
      end

      parts.join
    end

  private
    # Build a normalized query string by alphabetizing all keys/values
    # and applying consistent escaping.
    def query_string
      return nil if @request.query_string.to_s.empty?

      parts = @request.query_string.split(/[&;] */n)
      parts.map! { |p| p.split('=', 2).map!{ |s| unescape(s) } }
      parts.sort!
      parts.reject!(&self.class.query_string_ignore)
      parts.map! { |k,v| "#{escape(k)}=#{escape(v)}" }
      parts.empty? ? nil : parts.join('&')
    end
  end
end
