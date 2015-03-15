require 'spec_helper'

describe NullUser, type: :model do
  let(:user) { NullUser.new('I am not null') }

  it '#display_name' do
    expect(user.display_name).to eq('I am not null')
  end
  it 'shows that the user was stored from the last session or not' do		
	user.persisted? == false
  end


end
