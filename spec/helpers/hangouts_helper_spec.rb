require 'spec_helper'

describe HangoutsHelper, type: :helper do
  it 'generates a unique id for a hangout event' do
    user = double(User, id: '45')
    project = double(Project, id: '85')
    allow(Time).to receive(:now).and_return(Time.parse('02/03/2014 10:05:05'))
    expect(generate_hangout_id(user, project)).to eq('45851393754705')
  end
end
