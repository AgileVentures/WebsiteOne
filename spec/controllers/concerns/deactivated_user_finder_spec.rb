# frozen_string_literal: true

RSpec.describe 'DeactivatedUserFinderConcern' do
  before do
    class FakeController < ActionController::Base
      include DeactivatedUserFinder
    end
    @fake_controller = FakeController.new
  end

  describe '#deactivated_user_with_email' do
    before do
      @deactivated_user = create(:user,
                                 deleted_at: DateTime.new(2000, 1, 1),
                                 email: 'random@random.com')
      @user = create(:user, email: 'example@example.com')
    end

    after do
      Object.send(:remove_const, :FakeController)
    end

    it "is expected to return deactivated user when email is deactivated_user's email" do
      expect(@fake_controller.deactivated_user_with_email(@deactivated_user.email)).to eq @deactivated_user
    end

    it "is expected to return nil when email is user's email" do
      expect(@fake_controller.deactivated_user_with_email(@user.email)).to be nil
    end
  end
end
