# frozen_string_literal: true

RSpec.describe ContactForm do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :message }

  it 'is expected to accept valid email ' do
    contact_form = ContactForm.new(
      name: 'Nick',
      message: 'Refactoring rocks!!',
      email: 'something@frissby.com'
    )
    expect(contact_form).to be_valid
  end

  it 'is expected to reject invalid email' do
    contact_form = ContactForm.new(
      name: 'Nick',
      message: 'Refactoring rocks!!',
      email: 'something$frissby.com'
    )
    expect(contact_form).to_not be_valid
  end
end
