require 'spec_helper'

describe 'events/new' do

  before(:each) do
    assign(:event, stub_model(Event).as_new_record)
    @user = stub_model(User, email: 'test@test.com', password: '12345678')
    assign(:user, @user)
  end

  context 'user is not signed in' do
    before :each do
      view.stub(:authenticate_user!).and_return(true)
    #  #@controller.view_context.stub(:authenticate_user!).and_return(false)
    #  view.should_receive(:user_signed_in?).and_return(false)
    end

    xit 'should redirect to sign in and render a flash error' do
    #  render
    #  expect(rendered).to have_text 'You need to sign in or sign up before continuing.'
    end
  end

  context 'user is signed in' do
    before :each do
      #@controller.view_context.stub(:authenticate_user!).and_return(true)
      #view.should_receive(:current_user).and_return(mock(:user))
    end

    it 'should display form with all form elements' do
      view.lookup_context.prefixes = %w[events application]
      render
      expect(rendered).to have_form events_path, 'post' do
        with_tag 'input', id: 'event_name'
        with_tag 'select', id: 'event_category'
        with_tag 'textarea', id: 'event_description'
        with_tag 'input', id: 'start_date'
        with_tag 'input', id: 'start_time'
        with_tag 'input', id: 'event_duration'
        with_tag 'select', id: 'event_repeats' do
          with_text 'never'
          with_text 'weekly'
        end
        with_tag 'fieldset', id: 'repeats_weekly_options' do
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_monday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_tuesday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_wednesday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_thursday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_friday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_saturday'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_sunday'
          with_tag 'input', id: 'event_repeats_every_n_weeks', :type => 'hidden'
          with_tag 'input', id: 'event_repeats_weekly_each_days_of_the_week_', :type => 'hidden'
        end
        with_tag 'select', id: 'event_repeat_ends_string' do
          with_text 'never'
          with_text 'on'
        end
        with_tag 'a', href: '/', text: 'Cancel'
        with_tag 'input', id: 'btn-default', value: 'Save'
      end
    end
  end
end
