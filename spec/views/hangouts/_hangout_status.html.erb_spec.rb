describe 'Hangout information' do
    before(:each) do
      @hangout = stub_model(Hangout, event_id: 375,
                            hangout_url: 'http://hangout.test',
                            started?: true)
      assign :hangout, @hangout
    end

    it 'renders hangout link' do
      render partial: 'hangouts/hangout_status'
      expect(rendered).to have_link 'Click to join the hangout', @hangout.hangout_url
    end
end
