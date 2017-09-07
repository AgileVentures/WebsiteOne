require 'spec_helper'

describe 'UsersHelper' do
  describe '#activity_tab' do
    it "should return active when param_tab is activity" do
      expect(helper.activity_tab("activity")).to eq "active"
    end
    
    it "should return nil when param_tab is not activity" do
      expect(helper.activity_tab("some-other-tab")).to be nil
    end
  end
  
  describe '#about_tab' do
    it "should return nil when param_tab is activity" do
      expect(helper.about_tab("some-other-tab")).to eq "active"
    end
    
    it "should return active when param_tab is not activity" do
      expect(helper.about_tab("activity")).to be nil
    end
  end
  
  describe '#deactivated_user_with_email' do
    before do
      @deactivated_user = FactoryGirl.create(:user, deleted_at: DateTime.new(2000, 1, 1), email: 'random@random.com')
      @user = FactoryGirl.create(:user, email: 'example@example.com')
    end
    
    it "should return deactivated user when email is deactivated_user's email" do
      expect(helper.deactivated_user_with_email(@deactivated_user.email)).to eq @deactivated_user
    end
    
    it "should return nil when email is user's email" do
      expect(helper.deactivated_user_with_email(@user.email)).to be nil
    end
  end
end