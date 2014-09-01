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

  describe '#gravatar_for' do
    let(:email) { ' MyEmailAddress@example.com  ' }
    let(:user_hash) { '0bc83cb571cd1c50ba6f3e8a78ef1346' }
    let(:user) { User.new(email: email) }

    it 'should construct a link to the image at gravatar.com' do
      regex = /^http[s]:\/\/.*gravatar.*#{user_hash}/
        expect(subject.gravatar_src).to match(regex)
    end

    it 'should be able to specify image size' do
      expect(subject.gravatar_src(size: 200)).to match(/\?s=200&/)
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

end
