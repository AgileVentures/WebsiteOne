require 'spec_helper'

describe EventInstancePresenter do
  let(:presenter){ EventInstancePresenter.new(hangout) }

  context 'all fields are present' do
    let(:hangout){ FactoryGirl.build_stubbed(:event_instance, created: '1979-10-14 11:15 UTC') }

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
      FactoryGirl.create(:user, gplus: hangout.participants.first.last[:person][:id])
      expect(presenter.participants).not_to include(hangout.user)
    end

    it 'returns video url' do
      expect(presenter.video_url).to eq("http://www.youtube.com/watch?v=#{presenter.yt_video_id}&feature=youtube_gdata")
    end

    it 'returns a link to video' do
      expect(presenter.video_link).to include(
        'class="yt_link"', "data-content=\"#{presenter.title}\"",
        "href=\"#{presenter.video_url}\"", "id=\"#{presenter.yt_video_id}\""
      )
    end

    it 'returns a link to youtube player' do
      link = "http://www.youtube.com/embed/#{presenter.yt_video_id}?enablejsapi=1"
      expect(presenter.video_embed_link).to eq(link)
    end
  end

  context 'some fields are missing' do
    let(:hangout){ FactoryGirl.build_stubbed(:event_instance,
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

    it "don't throw an exception when have nil person at participants" do
      hangout.participants = [ [ "0", { :person => nil } ] ]
      expect(presenter.participants).to be_empty
    end

    it 'returns video url' do
      expect(presenter.video_url).to eq('#')
    end

    it 'returns a link to video' do
      expect(presenter.video_link).to be_nil
    end

    it 'returns a link to youtube player' do
      expect(presenter.video_embed_link).to be_nil
    end
  end

end

