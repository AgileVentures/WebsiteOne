# frozen_string_literal: true

Geocoder.configure(
  lookup: :google,
  ip_lookup: :freegeoip,
  timeout: 2
)
