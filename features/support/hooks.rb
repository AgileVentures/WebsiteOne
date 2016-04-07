Before('@scrum_query') do
  FactoryGirl.create_list(:event_instance, 25, category: 'Scrum', created_at: rand(1.months).seconds.ago, project_id: nil)
  #VCR.insert_cassette(
  #  'scrums_controller/videos_by_query'
  #)
end


After('@scrum_query') {EventInstance.destroy_all }