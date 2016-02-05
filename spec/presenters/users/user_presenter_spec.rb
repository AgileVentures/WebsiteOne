require 'spec_helper'

describe UserPresenter do
  subject { UserPresenter.new(user) }
  let(:user) { FactoryGirl.build_stubbed(:user, first_name: '', last_name: '', email: '') }

  describe '#display_name' do
    it 'should display the first part of the email address when no name is given' do
      user.email = 'joe@blow.com'
      expect(subject.display_name).to eq 'joe'
    end

    it 'should display the full name when first and last name fields are given' do
      user.first_name = 'Joe'
      user.last_name = 'Blow'
      expect(subject.display_name).to eq 'Joe Blow'
    end

    it 'should display the first name when the last name field is empty' do
      user.first_name = 'Joe'
      user.last_name = ''
      expect(subject.display_name).to eq 'Joe'
    end

    it 'should ignore extra whitespaces' do
      user.first_name = ''
      user.last_name = ' Blow '
      expect(subject.display_name).to eq 'Blow'
    end

    it 'should display anonymous when there is no first name, last name or email' do
      expect(subject.display_name).to eq 'Anonymous'
    end
  end

  describe '#timezone' do
    it 'should display timezone when it can be determined' do
      user.latitude = 25.9500
      user.longitude = 32.5833
      expect(NearestTimeZone).to receive(:to).with(user.latitude, user.longitude).and_return('Africa/Cairo')
      expect(subject.timezone).to eq 'Africa/Cairo'
    end
  end

  describe '#timezone_formatted_offset' do
    it 'should display timezone formatted offset when it can be determined' do
      user.latitude = 25.9500
      user.longitude = 32.5833
      expect(ActiveSupport::TimeZone.new(subject.timezone)).to receive(:formatted_offset).and_return('+02:00')
      expect(subject.timezone_formatted_offset).to eq '+02:00'
    end
  end

  describe '#contributors' do
    let(:user) { create(:user) }
    let(:commit_counts) { create_list(:commit_count, 2, user: user) }

    before do
      user.follow commit_counts.first.project
    end

    it 'should only return commit counts for the projects that the user follows' do
      expect(subject.contributions).to eq([commit_counts[0]])
    end
  end

  describe 'user status' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      @status = FactoryGirl.create_list(:status, 3,
                                        status: Status::OPTIONS[rand(Status::OPTIONS.length)],
                                        user: user)
      user.reload
    end

    it 'should have a status' do
      expect(subject.status).to eq("<span>#{@status[2][:status]}</span>")
    end

    it 'status should be html_safe' do
      expect(subject.status).to be_html_safe
    end

    it 'status? should be true' do
      expect(subject.status?).to eq true
    end
  end

  describe 'empty profile fields' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'should return a list of all fields if they are nil' do
      user.first_name = user.last_name = user.bio = nil
      user.skill_list = nil
      user.save
      user.reload
      expect(subject.blank_fields).to eq('First name, Last name, Skills, and Bio')
    end

    it 'should return a list of all fields if they are empty' do
      user.first_name = user.last_name = user.bio = ''
      user.skill_list = ''
      user.save
      user.reload
      expect(subject.blank_fields).to eq('First name, Last name, Skills, and Bio')
    end

    it 'should return only empty fields' do
      user.last_name = user.bio = ''
      expect(subject.blank_fields).to eq('Last name and Bio')
    end
  end
end
