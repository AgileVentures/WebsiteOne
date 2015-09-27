require 'spec_helper'

describe "hookups/index", type: :view do
  before do
    event_pending = FactoryGirl.build(:event,
                                       name: "Hookup pending",
                                       start_datetime: 'Mon, 1 Jan 2099 09:00:00 UTC',
                                       duration: 60,
                                       time_zone: "UTC",
                                       category: "PairProgramming",
                                       id: 1)
    @pending_hookups = [event_pending]

    hangout_active = FactoryGirl.build(:event_instance,
                                        hangout_url: 'x@x.com',
                                        updated: 'Mon, 1 Jan 2014 09:35:00',
                                        created: 'Mon, 1 Jan 2014 09:30:00',
                                        category: "PairProgramming",
                                        event: nil,
                                        title: 'Hookup active')
    @active_pp_hangouts = [hangout_active]
  end

  context 'for all users' do
    it "renders pending hookups table" do
      render
      expect(rendered).to have_text("Pending Hookups")
      expect(rendered).to have_text("Title")
      expect(rendered).to have_text("Time range")
      expect(rendered).to have_text("Actions")
    end

    it "renders active hookups table" do
      render
      expect(rendered).to have_text("Active Hookups")
      expect(rendered).to have_text("Title")
      expect(rendered).to have_text("Time range")
      expect(rendered).to have_text("Actions")
    end
  end

  context 'for NOT signed in users' do
    it "displays a pending hookup event" do
      render
      expect(rendered).to have_text("Hookup pending")
      expect(rendered).to have_text("09:00-10:00")
      expect(rendered).not_to have_link("Create Hangout")
    end

    it "displays an active hookup event" do
      render
      expect(rendered).to have_text("Hookup active")
      expect(rendered).to have_text("09:30")
      expect(rendered).to have_link("Join")
    end
  end

  context 'for signed in users' do
    before :each do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it "displays a pending hookup event" do
      render
      expect(rendered).to have_text("Hookup pending")
      expect(rendered).to have_text("09:00-10:00")
      expect(rendered).to have_link("Create Hangout")
    end

    it "displays an active hookup event" do
      render
      expect(rendered).to have_text("Hookup active")
      expect(rendered).to have_text("09:30")
      expect(rendered).to have_link("Join")
    end
  end
end


