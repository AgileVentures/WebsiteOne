require 'spec_helper'

describe User do

  before do
    @attr = attributes_for(:user)
  end

  it 'should create a new instance given a valid attribute' do
    User.create!(@attr)
  end

  it 'should require an email address' do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it 'should accept valid email addresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.se]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addresses' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicate email addresses' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should reject email addresses identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'passwords' do

    before(:each) do
      @user = build(:user)
    end

    it 'should have a password attribute' do
      @user.should respond_to(:password)
    end

    it 'should have a password confirmation attribute' do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe 'password validations' do

    it 'should require a password' do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
    end

    it 'should reject short passwords' do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe 'password encryption' do

    before(:each) do
      @user = create(:user)
    end

    it 'should have an encrypted password attribute' do
      @user.should respond_to(:encrypted_password)
    end

    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe 'display name' do
    
    it 'should have a display_name method' do
      user = User.new
      user.should respond_to :display_name
    end

    it 'should display the first part of the email address when no name is given' do
      user = User.new :email => 'joe@blow.com'
      user.display_name.should eq 'joe'
    end
  end

  # first and last white space chars
  # only first or last given
  # test behavior of when first and last given.
  # first and last given but with extra white space

end