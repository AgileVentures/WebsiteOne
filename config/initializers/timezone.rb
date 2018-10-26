Timezone::Lookup.config(:geonames) do |c|
  c.username = ENV['GEONAMES_USERNAME']
  c.offset_etc_zones = true
end
