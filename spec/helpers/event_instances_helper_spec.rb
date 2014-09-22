require 'spec_helper'

describe EventInstancesHelper, type: :helper do
  it 'generates a unique id for a hangout event' do
    user = FactoryGirl.build_stubbed(:user, id: '45')
    project = FactoryGirl.build_stubbed(:project, id: '85')

    allow(Time).to receive(:now).and_return(Time.parse('02/03/2014 10:05:05 UTC'))

    expect(generate_event_instance_id(user, '85')).to eq('45851393754705')
  end

  it 'generates an id if project is nil' do
    user = FactoryGirl.build_stubbed(:user, id: '45')
    allow(Time).to receive(:now).and_return(Time.parse('02/03/2014 10:05:05 UTC'))

    expect(generate_event_instance_id(user)).to eq('45001393754705')
  end
end
