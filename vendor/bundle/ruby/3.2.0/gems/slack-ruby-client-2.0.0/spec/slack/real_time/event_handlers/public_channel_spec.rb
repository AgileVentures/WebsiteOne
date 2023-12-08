# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Slack::RealTime::Client, vcr: { cassette_name: 'web/rtm_connect' } do
  include_context 'connected client'
  include_context 'loaded client'

  context 'public channel' do
    it 'channel_archive' do
      channel = client.public_channels['C0HNTD0CW']
      expect(channel.is_archived).to be false
      event = Slack::RealTime::Event.new(
        'type' => 'channel_archive',
        'channel' => 'C0HNTD0CW',
        'user' => 'U04KB5WQR'
      )
      client.send(:dispatch, event)
      expect(channel.is_archived).to be true
    end

    it 'channel_created' do
      expect(client.public_channels['C024BE91L']).to be_nil
      event = Slack::RealTime::Event.new(
        'type' => 'channel_created',
        'channel' => {
          'id' => 'C024BE91L',
          'name' => 'fun',
          'created' => 1360782804,
          'creator' => 'U04KB5WQR'
        }
      )
      client.send(:dispatch, event)
      channel = client.public_channels['C024BE91L']
      expect(channel).not_to be_nil
      expect(channel.name).to eq 'fun'
      expect(channel.creator).to eq 'U04KB5WQR'
      expect(channel.created).to eq 1360782804
    end

    it 'channel_deleted' do
      expect(client.public_channels['C0HLE0BBL']).not_to be_nil
      event = Slack::RealTime::Event.new(
        'type' => 'channel_deleted',
        'channel' => 'C0HLE0BBL'
      )
      client.send(:dispatch, event)
      expect(client.public_channels['C0HLE0BBL']).to be_nil
    end

    context 'channel_joined' do
      it 'creates channel' do
        expect(client.public_channels['CDEADBEEF']).to be_nil
        event = Slack::RealTime::Event.new(
          'type' => 'channel_joined',
          'channel' => {
            'id' => 'CDEADBEEF',
            'name' => 'beef'
          }
        )
        client.send(:dispatch, event)
        channel = client.public_channels['CDEADBEEF']
        expect(channel).not_to be_nil
        expect(channel.name).to eq 'beef'
      end

      it 'updates channel' do
        expect(client.public_channels['CDEADBEEF']).to be_nil
        client.public_channels['CDEADBEEF'] =
          Slack::RealTime::Models::Channel.new('id' => 'CDEADBEEF', name: 'beef')
        event = Slack::RealTime::Event.new(
          'type' => 'channel_joined',
          'channel' => {
            'id' => 'CDEADBEEF',
            'name' => 'beef',
            'updated' => true
          }
        )
        client.send(:dispatch, event)
        channel = client.public_channels['CDEADBEEF']
        expect(channel).not_to be_nil
        expect(channel.updated).to be true
      end
    end

    it 'channel_left' do
      channel = client.public_channels['C0JHNAB5H']
      expect(channel.members).to include client.self.id
      event = Slack::RealTime::Event.new(
        'type' => 'channel_left',
        'channel' => 'C0JHNAB5H'
      )
      client.send(:dispatch, event)
      expect(channel.members).not_to include client.self.id
    end

    it 'channel_rename' do
      channel = client.public_channels['C0HLE0BBL']
      expect(channel.name).to eq 'gifs'
      event = Slack::RealTime::Event.new(
        'type' => 'channel_rename',
        'channel' => {
          'id' => 'C0HLE0BBL',
          'name' => 'updated',
          'created' => 1_360_782_804
        }
      )
      client.send(:dispatch, event)
      expect(channel.name).to eq 'updated'
    end

    it 'channel_unarchive' do
      channel = client.public_channels['C0HLE0BBL']
      expect(channel.is_archived).to be true
      event = Slack::RealTime::Event.new(
        'type' => 'channel_unarchive',
        'channel' => 'C0HLE0BBL',
        'user' => 'U04KB5WQR'
      )
      client.send(:dispatch, event)
      expect(channel.is_archived).to be false
    end
  end
end
