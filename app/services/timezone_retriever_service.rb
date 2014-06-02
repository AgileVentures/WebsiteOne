require 'geocoder'
require 'google_timezone'

class TimezoneRetrieverService
  def self.for(user)
    coordinates = Coordinates.new(user)
    TimezoneData.new(GoogleTimezone.fetch(coordinates.latitude,
                         coordinates.longitude))
  end

  class Coordinates
    attr_reader :latitude, :longitude
    def initialize(user)
      @latitude = user.latitude || 0
      @longitude = user.longitude || 0
      freeze
    end
  end

  class TimezoneData
    attr_reader :name, :offset
    def initialize(timezone_data)
      @timezone_data = timezone_data
      @name = timezone_data.time_zone_name
      @offset = timezone_data.raw_offset / 3600
    end

    def success?
      @timezone_data.success?
    end

    def offset
      if @offset > 0
        "UTC+#{@offset}"
      elsif @offset < 0
        "UTC#{@offset}"
      else
        "UTC"
      end
    end
  end

end
