# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProjectMailer, type: :mailer do
  describe '#alert_project_creator_about_new_member' do
    before(:each) do
      @project_creator = FactoryBot.create(:user, first_name: 'Reva', last_name: 'Satterfield')
      @project = FactoryBot.create(:project, title: 'Title 1', user: @project_creator)
      @new_member = FactoryBot.create(:user, email: 'leif.kozey@bruen.org')
    end
    it 'sends an email to project creator about new member' do
      email = ProjectMailer.with(user: @new_member, project: @project,
                                 project_creator: @project_creator).alert_project_creator_about_new_member.deliver_now
      assert !ActionMailer::Base.deliveries.empty?
      assert_equal [@project_creator.email], email.to
      assert_equal "#{@new_member.display_name} just joined #{@project.title} project", email.subject
      assert_equal read_fixture('project_creator_notification_text').join, email.text_part.body.to_s
      assert_equal read_fixture('project_creator_notification_html').join, email.html_part.body.to_s
    end
  end

  describe '#welcome_project_joinee' do
    context 'websiteone project' do
      before(:each) do
        @project_creator = FactoryBot.create(:user, first_name: 'Sam', last_name: 'Satterfield')
        @project = FactoryBot.create(:project, title: 'WebsiteOne', user: @project_creator)
        @new_member = FactoryBot.create(:user, first_name: 'Billy', last_name: 'Bob', email: 'billybob@example.org')
        @email = ProjectMailer.with(user: @new_member, project: @project,
                                    project_creator: @project_creator).welcome_project_joinee.deliver_now
      end
      it 'queues mailer for delivery' do
        assert !ActionMailer::Base.deliveries.empty?
      end

      it 'sends an email to the new project joinee' do
        assert_equal [@new_member.email], @email.to
      end

      it 'displays the project title in the subject' do
        assert_equal 'Welcome to the WebsiteOne project!', @email.subject
      end

      it 'sends an email with a text part' do
        assert_equal read_fixture('project_joinee_notification_text').join, @email.text_part.body.to_s
      end

      it 'sends an email with an html part' do
        assert_equal read_fixture('project_joinee_notification_html').join, @email.html_part.body.to_s
      end
    end
    context 'hello world project' do
      before(:each) do
        @project_creator = FactoryBot.create(:user, first_name: 'Reva', last_name: 'Satterfield')
        @project = FactoryBot.create(:project, title: 'Hello World', user: @project_creator,
                                               slack_channel_name: '#helloworld')
        @new_member = FactoryBot.create(:user, first_name: 'John', last_name: 'Boy', email: 'billybob@example.org')
        @email = ProjectMailer.with(user: @new_member, project: @project,
                                    project_creator: @project_creator).welcome_project_joinee.deliver_now
      end
      it 'queues mailer for delivery' do
        assert !ActionMailer::Base.deliveries.empty?
      end

      it 'sends an email to the new project joinee' do
        assert_equal [@new_member.email], @email.to
      end

      it 'displays the project title in the subject' do
        assert_equal 'Welcome to the Hello World project!', @email.subject
      end

      it 'sends an email with a text part' do
        assert_equal read_fixture('project_joinee_notification_helloworld_text').join, @email.text_part.body.to_s
      end

      it 'sends an email with an html part' do
        assert_equal read_fixture('project_joinee_notification_helloworld_html').join, @email.html_part.body.to_s
      end
    end
  end
end
