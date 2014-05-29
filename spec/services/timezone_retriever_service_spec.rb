require_relative '../../app/services/timezone_retriever_service'
require 'active_support/all'

Geocoder.configure(:ip_lookup => :test)
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
describe TimezoneRetrieverService do
  let(:user) { double(:user,  last_sign_in_ip: '127.0.0.1') }

  context '.for' do
    it 'returns the timezone name for a given user' do
      expect(described_class.for(user)).to include 'Central European Summer Time'
    end

    it 'returns utc offset in hours for a given user' do
      expect(described_class.for(user)).to include 'UTC+1'
    end
  end

end
