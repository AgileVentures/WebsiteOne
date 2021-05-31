# frozen_string_literal: true

RSpec.describe CalendarController, type: :controller do
  it 'is expected to have calendar route' do
    get :index
    expect(response.status).to eq(200)
  end
  context 'is expected to send a file' do
    before do
      @time = Time.now
      @name = 'Test_Event'
      @event = create(:event, category: 'PairProgramming', name: @name, start_datetime: @time, repeat_ends: false)
    end
    it 'with proper headers' do
      get :index
      expect(response.header['Content-Type']).to eq('text/calendar')
      expect(response.header['Content-Transfer-Encoding']).to eq('binary')
    end
    it 'and proper content' do
      get :index
      expect(response.body).to match(/BEGIN:VCALENDAR/)
      expect(response.body).to include(@name)
      expect(response.body).to include(@event.start_datetime.strftime('%Y%m%d'))
    end
  end
end
