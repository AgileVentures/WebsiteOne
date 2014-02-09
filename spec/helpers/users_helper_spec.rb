require 'spec_helper'


describe UsersHelper do
  describe '#user_display_name' do
    it 'should return the first part of the users email when first name and last name are empty' do
      user = mock_model(User, email: 'jsimp@work.co.uk')
      result = helper.user_display_name(user)
      expect(result).to eq "jsimp"
    end

    it 'should return John when first name is John and last name is empty' do
      user = mock_model(User, first_name: 'John')
      result = helper.user_display_name(user)
      expect(result).to eq "John"
    end

    it 'should return Simpson when first name is empty and last name is Simpson' do
      user = mock_model(User, last_name: 'Simpson')
      result = helper.user_display_name(user)
      expect(result).to eq "Simpson"
    end

    it 'should return Test User when first name is Test and last name is User' do
      user = FactoryGirl.build(:user)
      result = helper.user_display_name(user)
      expect(result).to eq "Test User"
    end

    it '#date_format returns formatted date 1st Jan 2015' do
      expect(date_format(Date.new(2015,1,1))).to eq('1st Jan 2015')
      expect(date_format(Date.new(2015,5,3))).to eq('3rd May 2015')
    end
  end
end
