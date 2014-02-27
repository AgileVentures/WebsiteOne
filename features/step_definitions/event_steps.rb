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