Given(/^I am on Events index page$/) do
  visit('/events')
end
Given(/^following events exist:$/) do |table|
  table.hashes.each do |hash|
    Event.create(hash)
    #@event = Event.new(hash)
    #@event.save(:validate=>false)

  end
  #ActionView::Base.any_instance.stub(:cover_for) { image_path('event-scrum-cover.png') }

end

Then(/^I should be on the Events index page$/) do
  current_path.should eq events_path
end