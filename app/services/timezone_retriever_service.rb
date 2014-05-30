require 'geocoder'
require 'google_timezone'

class TimezoneRetrieverService
  def self.for(user)
    new(user).timezone
  end

  def initialize(user)
    @user = user
    @coordinates = Coordinates.new(
      Geocoder.search(LastSignInIp.for(user)).first.data)
  end

  def timezone
    Timezone.new(GoogleTimezone.fetch(@coordinates.latitude,
                         @coordinates.longitude))
  end

  class Timezone
    attr_reader :name, :offset
    def initialize(timezone_data)
      @name = timezone_data.time_zone_name
      @offset = timezone_data.raw_offset / 3600
    end

    def offset 
      if @offset > 0 
        "UTC+#{@offset}"
      else
        "UTC#{@offset}"
      end
    end
  end

  class LastSignInIp
    def self.for(user)
      new(user.last_sign_in_ip || '0.0.0.0').ip
    end

    attr_reader :ip
    def initialize(ip)
      @ip = ip
    end
  end



  class Coordinates
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
