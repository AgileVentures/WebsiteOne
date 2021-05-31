# frozen_string_literal: true

Geocoder.configure(ip_lookup: :test)
Geocoder::Lookup::Test.add_stub(
  '127.0.0.1', [
    {
      ip: '127.0.0.1',
      country_code: 'SE',
      country_name: 'Sweden',
      region_code: '28',
      region_name: 'Västra Götaland',
      city: 'Alingsås',
      zipcode: '44139',
      latitude: 57.9333,
      longitude: 12.5167,
      metro_code: '',
      areacode: ''
    }.as_json
  ]
)
