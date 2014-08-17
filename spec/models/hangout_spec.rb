require 'spec_helper'

describe Hangout, type: :model do
  let(:event){ FactoryGirl.build_stubbed(:event) }
  let(:hangout){ FactoryGirl.create(:hangout, updated: '10:00', hangout_url: nil) }

  describe 'default_scope' do
    it 'returns hangouts sorted by created_at DESC' do
      FactoryGirl.create_list(:hangout, 2)
      expect(Hangout.all.first.created_at).to be >= Hangout.all.last.created_at
    end
  end

  context 'hangout_url is not present' do
    before do
      allow(Time).to receive(:now).and_return(Time.parse('01:00 UTC'))
    end

    it '#started? returns falsey' do
      expect(hangout.started?).to be_falsey
    end

    it '#live? returns false' do
      expect(hangout.live?).to be_falsey
    end

    it '#expired? returns false' do
      expect(hangout.expired?).to be_falsey
    end
  end

  context 'hangout_url is present' do
    before { hangout.hangout_url = 'test' }

    it 'reports live if the link is not older than 5 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:04:59'))
      expect(hangout.live?).to be_truthy
    end

    it 'reports not live if the link is older than 5 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:05:01 UTC'))
      expect(hangout.live?).to be_falsey
    end

    it 'reports expired if the link is older than 5 minutes' do
      allow(Time).to receive(:now).and_return(Time.parse('10:05:01 UTC'))
      expect(hangout.expired?).to be_truthy
    end
  end

  describe '#update_hangout_data' do
    let(:project){ FactoryGirl.create(:project) }
    let(:event){ FactoryGirl.create(:event) }
    let(:user){ FactoryGirl.create(:user) }
    let(:participant){ FactoryGirl.create(:user, youtube_id: 'yt_id_1') }

    let(:params) do
      { title: 'Oasis',
        project_id: project.id,
        event_id: event.id,
        category: 'Bacon',
        host_id: user.id,
        participants: [{ name: participant.first_name, gplus_id: participant.youtube_id },
                       { name: 'Greg', gplus_id: 'unregistered_id' }],
        hangout_url: 'http://hangout.test',
        yt_video_id: 'YTID234'
      }
    end

    context 'all params are suplied' do
      it 'updates basic data' do
        hangout.update_hangout_data(params)

        expect(hangout.title).to eq('Oasis')

        expect(hangout.project).to eq(project)
        expect(hangout.event).to eq(event)
        expect(hangout.category).to eq('Bacon')

        expect(hangout.user).to eq(user)
        expect(hangout.participants).to eq(params[:participants])

        expect(hangout.hangout_url).to eq('http://hangout.test')
        expect(hangout.yt_video_id).to eq('YTID234')
      end
    end

    context 'some params are suplied' do
      it 'updates basic data' do
        params.delete(:project_id)
        params.delete(:category)

        params[:event_id] = nil
        params[:host_id] = ''
        params[:participants] = ""

        hangout.update_hangout_data(params)

        expect(hangout.title).to eq('Oasis')

        expect(hangout.project).to be_nil
        expect(hangout.event).to be_nil
        expect(hangout.category).to be_nil

        expect(hangout.user).to be_nil
        expect(hangout.participants).to be_empty

        expect(hangout.hangout_url).to eq('http://hangout.test')
        expect(hangout.yt_video_id).to eq('YTID234')
      end
    end
  end
end
