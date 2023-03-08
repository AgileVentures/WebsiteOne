# frozen_string_literal: true

module Features
  class << self
    def enabled?(feature_name)
      feature = Settings.features.send(feature_name)
      raise "The feature #{feature_name} could not be found" if feature.nil?

      feature&.enabled
    end

    def enable(feature_name)
      Features.send(feature_name).enabled = true
    end

    def disable(feature_name)
      Features.send(feature_name).enabled = false
    end

    def method_missing(method_name, *args, &block)
      Settings.features.send(method_name, *args, &block)
    end
  end
end
