# frozen_string_literal: true

describe EventInstancesHelper, type: :helper do
  let(:uuid) { '82c2b3b8-42f7-442b-be64-86c2f407b2ed' }

  before do
    expect(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  it 'generates a unique id for a hangout event' do
    user = FactoryBot.build_stubbed(:user, id: '45')

    expect(generate_event_instance_id(user, '85')).to eq("4585-#{uuid}")
  end

  it 'generates an id if project is nil' do
    user = FactoryBot.build_stubbed(:user, id: '45')

    expect(generate_event_instance_id(user)).to eq("4500-#{uuid}")
  end
end
