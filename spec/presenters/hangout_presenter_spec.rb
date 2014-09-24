require 'spec_helper'

describe HangoutPresenter do
  let(:presenter){ HangoutPresenter.new(hangout) }

  context 'all fields are present' do
    let(:hangout){ FactoryGirl.build_stubbed(:hangout, created: '1979-10-14 11:15 UTC') }

    it 'displays created time' do
      expect(presenter.created_at).to eq('11:15 14/10')
    end

    it 'displays title' do
      expect(presenter.title).to eq(hangout.title)
    end

    it 'displays category' do
      expect(presenter.category).to eq(hangout.category)
    end

    it 'displays project' do
      expect(presenter.project_link).to match %Q(<a href="#{project_path(hangout.project)}")
      expect(presenter.project_link).to match "#{hangout.project.title}"
    end

    it 'displays event' do
      expect(presenter.event_link).to match %Q(<a href="#{event_path(hangout.event)}")
      expect(presenter.event_link).to match "#{hangout.event.name}"
    end

    it 'returns host' do
      expect(presenter.host).to eq(hangout.user)
    end

    it 'returns an array of participants' do
      participant = FactoryGirl.create(:user, gplus: hangout.participants.first.last[:person][:id])

      expect(presenter.participants.count).to eq(2)
      expect(presenter.participants.first).to eq(participant)
    end

    it 'do not show the host in the list of participants' do
      participant = FactoryGirl.create(:user, gplus: hangout.participants.first.last[:person][:id])
      expect(presenter.participants).not_to include(hangout.user)
    end

    it 'returns video url' do
      expect(presenter.video_url).to eq("http://www.youtube.com/watch?v=yt_video_id&feature=youtube_gdata")
    end
  end

  context 'some fields are missing' do
    let(:hangout){ FactoryGirl.build_stubbed(:hangout,
                         title: nil,
                         category: nil,
                         project: nil,
                         event: nil,
                         user: nil,
                         yt_video_id: nil,
                         participants: nil) }

    it 'displays title' do
      expect(presenter.title).to eq('No title given')
    end

    it 'displays category' do
      expect(presenter.category).to eq('-')
    end

    it 'displays project' do
      expect(presenter.project_link).to eq('-')
    end

    it 'displays event' do
      expect(presenter.event_link).to eq('-')
    end

    it 'returns host' do
      expect(presenter.host.display_name).to eq('Anonymous')
    end

    it 'returns an array of participants' do
      expect(presenter.participants).to eq([])
    end

    it 'returns an array with nullUser if participant gplus_id is not found' do
      hangout.participants = [ [ "0", { :person => { displayName: "Bob", id: "not_registered" } } ] ]
      expect(presenter.participants.first.display_name).to eq('Bob')
    end

    it 'returns video url' do
      expect(presenter.video_url).to eq('#')
    end
  end

end

