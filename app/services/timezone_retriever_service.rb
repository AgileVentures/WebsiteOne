require 'geocoder' 
require 'google_timezone'

class TimezoneRetrieverService 
  def self.for(user) 
    new(user).timezone
  end

  def initialize(user) 
    @user = user 
    @coordinates = Coordinates.for(
      Geocoder.search(user.last_sign_in_ip).first.data)
  end

  def timezone 
    GoogleTimezone.fetch(@coordinates.latitude,
                         @coordinates.longitude).time_zone_name
  end

  class Coordinates 
    def self.for(data)
      new(data)
    end

    attr_reader :latitude, :longitude
    def initialize(data) 
      @latitude = data.fetch('latitude')
      @longitude = data.fetch('longitude')
      freeze
    end
  end

  private

  attr_reader :user
end
