Geocoder.configure(
    :lookup => :google,
    # IP address geocoding service (see below for supported options):
    :ip_lookup => :freegeoip,
    :timeout => 5
)