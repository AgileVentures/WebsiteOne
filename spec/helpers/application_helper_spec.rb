require 'spec_helper'

describe ApplicationHelper do
  #TODO: Thomas - test the 'user_details' but stick to the story for now
  #describe '#user_details' do
  #  it 'should return the first part of the users email when first name and last name are empty' do
  #    user = FactoryGirl.build(:user, id: 1, email: 'jsimp@work.co.uk', first_name: nil, last_name: nil )
  #    result = user_details(user.id)
  #    debugger
  #    expect(result).to eq "jsimp"
  #  end
  #
  #  it 'should return John when first name is John and last name is empty' do
  #    user = mock_model(User, first_name: 'John')
  #    result = helper.user_details(user)
  #    expect(result).to eq "John"
  #  end
  #
  #  it 'should return Simpson when first name is empty and last name is Simpson' do
  #    user = mock_model(User, last_name: 'Simpson')
  #    result = helper.user_details(user)
  #    expect(result).to eq "Simpson"
  #  end
  #
  #  it 'should return Test User when first name is Test and last name is User' do
  #    user = FactoryGirl.build(:user)
  #    result = helper.user_details(user)
  #    expect(result).to eq "Test User"
  #  end
  #end

  describe '#gravatar_for' do

    before(:each) do
      @email = ' MyEmailAddress@example.com  '
      @user_hash = '0bc83cb571cd1c50ba6f3e8a78ef1346' # hash calculated manually
    end
    it 'constructs a link to image at gravatar.com' do
      expected_gravatar_link = "http://www.gravatar.com/avatar/#{@user_hash}?s=80&d=retro"

      expect(helper.gravatar_for(@email)).to eq(expected_gravatar_link)
    end

    it 'specifies image size' do
      expect(helper.gravatar_for(@email, size: 200)).to match /\?s=200&/
    end
  end

  it '#date_format returns formatted date 1st Jan 2015' do
    expect(date_format(Date.new(2015,1,1))).to eq('1st Jan 2015')
    expect(date_format(Date.new(2015,5,3))).to eq('3rd May 2015')
  end

  describe '#valid_email?' do
    it 'returns true if email is valid' do
      expect(valid_email?('valid@valid.com')).to be_true
    end

    it 'returns false if email is invalid' do
      expect(valid_email?('invalid')).to be_false
      expect(valid_email?('invalid@')).to be_false
      expect(valid_email?('invalid@invalid')).to be_false
      expect(valid_email?('invalid@invalid.')).to be_false
      expect(valid_email?('invalid@.invalid')).to be_false
      expect(valid_email?('invalid@invalid.i')).to be_false
    end
  end
end
