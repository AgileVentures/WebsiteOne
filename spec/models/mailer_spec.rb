require 'spec_helper'

describe Mailer, :type => :model do
    before(:each) do
        @user1 = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, user: @user1)
        @user2 = FactoryBot.create(:user)
    end
    it 'sends an email to project creator about new member' do
        email = Mailer.alert_project_creator_about_new_member(@project, @user2).deliver_now
        assert !ActionMailer::Base.deliveries.empty?
        assert_equal [@user1.email], email.to
        assert_equal "#{@user2.first_name} #{@user2.last_name} just joined #{@project.title} project", email.subject
    end
end