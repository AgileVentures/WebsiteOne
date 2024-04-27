# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  context '#save' do
    subject { build_stubbed(:role) }

    it 'should be a valid with all the correct attributes' do
      expect(subject).to be_valid
    end

    it 'should be invalid without name' do
      subject.name = ''
      expect(subject).to_not be_valid
    end
  end
end
