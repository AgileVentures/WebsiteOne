#require_relative '../../app/services/timezone_retriever_service'
#require 'active_support/all'
#ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'

describe TimezoneRetrieverService do
  context 'when the user has coords (happy path)' do
    let(:user) { double(:user, latitude: 57.9333, longitude: 12.5167) }

    east = {cassette_name: 'timezones/query_east'}
    context 'query East of UTC', vcr: east do
      it 'returns the timezone name for a given user' do
        expect(described_class.for(user).success?).to be_true
      end

      it 'returns the timezone name for a given user' do
        expect(described_class.for(user).name).to eql 'Central European Summer Time'
      end

      it 'returns utc offset in hours for a given user' do
        expect(described_class.for(user).offset).to eql 'UTC+1'
      end
    end

    west = {cassette_name: 'timezones/query_west'}
    context 'when the user has coords West of UTC (happy path)', vcr: west do
      it 'negative offsets print correctly' do
        user.stub latitude: 40.7127, longitude: -74.0059
        expect(described_class.for(user).offset).to eql 'UTC-5'
      end
    end
  end

  no_coords = {cassette_name: 'timezones/query_no_coords'}
  context 'when the user coords are unknown (sad path)', vcr: no_coords do
    let(:user) { double(:user, latitude: 0, longitude: 0) }

    it 'returns the timezone name for a given user' do
      expect(described_class.for(user).success?).to be_false
    end

    it 'returns the timezone name for a given user' do
      expect(described_class.for(user).name).to eql ''
    end

    it 'returns utc offset in hours for a given user' do
      expect(described_class.for(user).offset).to eql 'UTC'
    end
  end
end
