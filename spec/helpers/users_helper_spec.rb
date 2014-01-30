require 'spec_helper'


describe UsersHelper do
  describe '#user_display_name' do
    it 'should return Anon when first name and last name are empty' do
      user = mock_model(User)
      result = helper.user_display_name(user)
      expect(result).to eq "Anon"
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
  end
end
