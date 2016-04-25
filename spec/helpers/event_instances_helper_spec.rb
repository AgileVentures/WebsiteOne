require 'spec_helper'

describe EventInstancesHelper, type: :helper do
  it 'generates a unique id for a hangout event' do
    user = FactoryGirl.build_stubbed(:user, id: '45')

    expect(generate_event_instance_id(user, '85')).to eq('4585')
  end

  it 'generates an id if project is nil' do
    user = FactoryGirl.build_stubbed(:user, id: '45')

    expect(generate_event_instance_id(user)).to eq('4500')
  end
end
