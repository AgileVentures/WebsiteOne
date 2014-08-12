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

  describe '#user_avatar_with_popover' do
    let(:user) { FactoryGirl.create(:user) }

    it 'renders a popover with user details' do
      allow(subject).to receive(:display_name).and_return('user_name')
      allow(subject).to receive(:gravatar_image).and_return('user_gravatar')

      placement = 'right'
      popover_content = 'Member for: <br/>User rating: <br/>PP sessions:'

      output = subject.user_avatar_with_popover({ placement: placement })

      expect(output).to match(/data-title="user_name"/)
      expect(output).to match(/data-placement="#{placement}"/)
      expect(output).to match(/data-content="#{popover_content}"/)
      expect(output).to match(/user_gravatar/)
      expect(output).to match(/href="#{user_path user}"/)
    end

  end
end
