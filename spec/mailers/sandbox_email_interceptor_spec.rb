require 'spec_helper'

describe SandboxEmailInterceptor do
    describe '#delivering_email' do
       before(:each) do
        @user1 = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, user: @user1)
        @user2 = FactoryBot.create(:user)
       end
       it 'delivers all emails to user when intercept_emails is set to true' do
           stub_const('ENV', {'USER_EMAIL' => 'me@ymail.com'})
           mail = Mailer.alert_project_creator_about_new_member(@project, @user2).deliver_now
           SandboxEmailInterceptor.delivering_email(mail)
           expect(ActionMailer::Base.deliveries[0].to).to include(ENV['USER_EMAIL'])
       end
    end
end
