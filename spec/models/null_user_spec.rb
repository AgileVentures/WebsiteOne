require 'spec_helper'

describe NullUser, type: :model do
  let(:user) { NullUser.new('I am not null') }

  it '#display_name' do
    expect(user.display_name).to eq('I am not null')
  end
  it 'persisted?' do		
	user.persisted? == false
  end


end
