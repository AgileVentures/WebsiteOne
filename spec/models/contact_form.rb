 

RSpec.describe ContactForm do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }

  it 'email should have a valid regex' do
    contact_form = ContactForm.new(name: 'Nick', message: 'Refactoring rocks!!', email: 'something$frissby.com')
    expect(contact_form).to_not be_valid
  end

  it 'valid email should pass' do
    contact_form = ContactForm.new(name: 'Nick', message: 'Refactoring rocks!!', email: 'something@frissby.com')
    expect(contact_form). to be_valid
  end
end
