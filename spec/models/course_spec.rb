require 'course'

RSpec.describe Course, type: :model do
  it { is_expected.to belong_to(:user).optional(true) }

  context '#save' do
    subject { build_stubbed(:course) }

    it 'should be a valid with all the correct attributes' do
      expect(subject).to be_valid
    end

    it 'should be invalid without title' do
      subject.title = ''
      expect(subject).to_not be_valid
    end

    it 'should be invalid without description' do
      subject.description = ''
      expect(subject).to_not be_valid
    end

    it 'should be invalid without status' do
      subject.status = ''
      expect(subject).to_not be_valid
    end
  end

end
