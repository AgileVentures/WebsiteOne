# frozen_string_literal: true

Given(/^a gplus user who has attended one event$/) do
  hangout = FactoryBot.create(:event_instance, created: '1979-10-14 11:15 UTC')
  @gplus_user = FactoryBot.create(:user, gplus: hangout.participants.first.last['person']['id'])
end

Then(/^the gplus user should be credit as having attended one event$/) do
  expect(@gplus_user.reload.hangouts_attended_with_more_than_one_participant).to eq 1
end
