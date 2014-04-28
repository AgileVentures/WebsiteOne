require_relative '../../../app/services/events/creator'

describe Events::Creator do 
  let(:event_repository) { double(:event_repository, new:event) } 
  let(:service) { Events::Creator.new(event_repository) } 

  context 'on success creates an event' do 
    let(:event) { double(:event, save:true) } 
    it 'should display a success message' do 
      service.perform({name:'event'}, 
                      on_success:->(event) do
        "Event created"
      end,
      on_failure:->(event) do 
        "Event not created" 
      end).should == 'Event created'
    end
  end

  context 'on failure display error message' do 
    let(:event) { double(:event, save:false) } 
    it 'should display a failure message' do 
      service.perform({name:'event'}, 
                      on_success:->(event) do
        "Event created"
      end,
      on_failure:->(event) do 
        "Event not created" 
      end).should == 'Event not created'
    end
  end

end
