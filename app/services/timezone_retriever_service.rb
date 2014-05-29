require 'geocoder' 
require 'google_timezone'

class TimezoneRetrieverService 
  def self.for(user) 
    new(user).timezone
  end

  def initialize(user) 
    @user = user 
  end

  def timezone 
    result = Geocoder.search(user.last_sign_in_ip).first
    timezone = GoogleTimezone.fetch(result.data.fetch('latitude'),
                                    result.data.fetch('longitude'))
    timezone.time_zone_name
  end

  private

  attr_reader :user
end
