require 'spec_helper'

describe UserPresenter do
  subject { UserPresenter.new(user) }

  describe '#display_name' do
    let(:user) { User.new }

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
end
