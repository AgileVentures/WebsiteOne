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
    it 'should redirect to sign in and render a flash error' do
      pending
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
      expect(rendered).to have_selector('form', :action => events_path, :method => 'post') do |form|
        expect(form).to have_selector('input#event_name')
        expect(form).to have_selector('select#event_category')
        expect(form).to have_selector('textarea#event_description')
        expect(form).to have_selector('input#event_event_date')
        expect(form).to have_selector('input#event_start_time')
        expect(form).to have_selector('input#event_end_time')
        expect(form).to have_selector('select#event_repeats') do |value|
          expect(value).to have_text('never')
          expect(value).to have_text('weekly')
        end
        expect(form).to have_selector('fieldset#repeats_weekly_options') do |fieldset|
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_monday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_tuesday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_wednesday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_thursday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_friday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_saturday')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_sunday')
          expect(fieldset).to have_selector('input#event_repeats_every_n_weeks', :type => 'hidden')
          expect(fieldset).to have_selector('input#event_repeats_weekly_each_days_of_the_week_', :type => 'hidden')
        end
        expect(form).to have_selector('select#event_repeat_ends') do |value|
          expect(value).to have_text('never')
          expect(value).to have_text('on')
        end
        expect(form).to have_selector('div#event_repeat_ends_on') do |date_select|
          expect(date_select).to have_selector('select#event_repeat_ends_on_1i') do |year|
            expect(year).to have_text('2014')
            expect(year).to have_text('2013')
            expect(year).to have_text('2013')
          end
          expect(date_select).to have_selector('select#event_repeat_ends_on_2i') do |month|
            expect(month).to have_text('January')
            expect(month).to have_text('February')
            expect(month).to have_text('March')
            expect(month).to have_text('April')
          end
          expect(date_select).to have_selector('select#event_repeat_ends_on_3i') do |day|
            expect(day).to have_text('1')
            expect(day).to have_text('2')
            expect(day).to have_text('13')
          end
        end
        expect(form).to have_link('Cancel', '/')
        expect(form).to have_selector('input.btn-default', value: 'Save')
      end
    end
  end
end