require 'spec_helper'

describe User do

  before do
    @attr = attributes_for(:user)
  end

  it 'should fail for a new user' do
    new_user = User.new(@attr.merge first_name: nil, last_name: nil, email: nil)
    new_user.save.should be_false
  end

  it 'should create a new instance given a valid attribute' do
    User.create!(@attr)
  end

  it 'should require an email address' do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it 'should not be valid when the email is nil' do
    user = User.new @attr.merge(email: nil)
    user.should_not be_valid
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

    it 'should display the name when first and last name fields contain white space' do
      user = User.new :first_name => ' Joe ', :last_name => ' Blow '
      user.display_name.should eq 'Joe Blow'
    end

    it 'should display the name when first or last name fields are given' do
      user = User.new :first_name => ' Joe ', :last_name => ' Blow '
      user.display_name.should eq 'Joe Blow'
    end

    it 'should display the name when first or last name field is empty' do
      user = User.new :first_name => 'Joe', :last_name => ''
      user.display_name.should eq 'Joe'
    end

    it 'should display anonymous when there is no first name, last name or email' do
      user = User.new
      user.display_name.should eq 'Anonymous'
    end
  end

  describe 'slug generation' do
    before(:each) do
      @user = User.new first_name: 'Candice',
                       last_name: 'Clemens',
                       email: 'candice@clemens.com',
                       password: '1234567890'
    end

    it 'should automatically generate a slug' do
      @user.save
      expect(@user.slug).to_not eq nil
    end

    it 'should be manually adjustable' do
      slug = 'this-is-a-slug'
      @user.slug = slug
      @user.save
      expect(User.find(@user.id).slug).to eq slug
    end

    it 'should be remade when the display name changes' do
      @user.save
      slug = @user.slug
      @user.update_attributes first_name: 'Shawn'
      expect(@user.slug).to_not eq slug
    end

    it 'should not be affected by multiple saves' do
      @user.save
      slug = @user.slug
      @user.save
      expect(@user.slug).to eq slug
    end
  end

  describe 'geocoding' do
    before(:each) do
      Geocoder.configure(:ip_lookup => :test)
      Geocoder::Lookup::Test.add_stub(
          '85.228.111.204', [
          {
              ip: '85.228.111.204',
              country_code: 'SE',
              country_name: 'Sweden',
              region_code: '28',
              region_name: 'Västra Götaland',
              city: 'Alingsås',
              zipcode: '44139',
              latitude: 57.9333,
              longitude: 12.5167,
              metro_code: '',
              areacode: ''
          }.as_json
      ]
      )

      Geocoder::Lookup::Test.add_stub(
          '50.78.167.161', [
          {
              ip: '50.78.167.161',
              country_code: 'US',
              country_name: 'United States',
              region_code: 'WA',
              region_name: 'Washington',
              city: 'Seattle',
              zipcode: '',
              latitude: 47.6062,
              longitude: -122.3321,
              metro_code: '819',
              areacode: '206'
          }.as_json
      ]
      )

      @user = User.new first_name: 'Geo',
                       last_name: 'Coder',
                       email: 'candice@clemens.com',
                       password: '1234567890',
                       last_sign_in_ip: '85.228.111.204'
    end

    it 'should perform geocode' do
      @user.save
      expect(@user.latitude).to_not eq nil
      expect(@user.longitude).to_not eq nil
      expect(@user.city).to_not eq nil
      expect(@user.country).to_not eq nil
    end

    it 'should set user location' do
      @user.save
      expect(@user.latitude).to eq 57.9333
      expect(@user.longitude).to eq 12.5167
      expect(@user.city).to eq 'Alingsås'
      expect(@user.country).to eq 'Sweden'
    end

    it 'should change location if ip changes' do
      @user.save
      @user.update_attributes last_sign_in_ip: '50.78.167.161'
      expect(@user.city).to eq 'Seattle'
      expect(@user.country).to eq 'United States'
    end

  end

  describe 'email receival' do
    it 'should have a receive_mailings method' do
      user = User.new
      user.should respond_to :receive_mailings
    end

    it 'should be set true by default' do
      user = User.create(@attr)
      user.receive_mailings.should be_true
    end
  end
end
