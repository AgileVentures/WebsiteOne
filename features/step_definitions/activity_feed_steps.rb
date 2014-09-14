Then(/^I should see a activity feed$/) do
  expect(page).to have_css('div#feed')
end

And(/^activities exists$/) do
  PublicActivity::Activity.stub(id: 2,
                                trackable_id: 15,
                                trackable_type: 'Document',
                                owner_id: 1,
                                owner_type: 'User',
                                key: 'document.create',
                                parameters: {},
                                recipient_id: nil,
                                recipient_type: nil,
                                created_at: '2014-09-14 15:02:34',
                                updated_at: '2014-09-14 15:02:34')
end