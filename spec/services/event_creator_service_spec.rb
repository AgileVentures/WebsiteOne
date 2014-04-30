require_relative '../../app/models/event_date'
require_relative '../../app/models/start_time'
require_relative '../../app/models/end_time'
require_relative '../../app/services/event_creator_service'
describe EventCreatorService do
  let(:event_repository) { double(:event_repository, new: event) }
  let(:event_params) do
    { name: 'event', end_time: '', start_time: '', event_date: '' }
  end
  let(:service) { EventCreatorService.new(event_repository) }
  let(:callback) do
    { success: ->(event) { 'success' },
      failure: ->(event) { 'failure' } }
  end

  context 'on success creates an event' do
    let(:event) { double(:event, save: true) }
    it 'should display a success message' do
      service.perform(event_params, callback).should == 'success'
    end
  end

  context 'on failure display error message' do
    let(:event) { double(:event, save: false) }
    it 'should display a failure message' do
      service.perform(event_params, callback).should == 'failure'
    end
  end
end
