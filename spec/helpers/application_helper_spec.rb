require 'spec_helper'

describe ApplicationHelper do
  describe '#gravatar_for' do

    before(:each) do
      @email = ' MyEmailAddress@example.com  '
      @user_hash = '0bc83cb571cd1c50ba6f3e8a78ef1346' # hash calculated manually
    end
    it 'constructs a link to image at gravatar.com' do
      expected_gravatar_link = "http://www.gravatar.com/avatar/#{@user_hash}?s=80&d=mm"

      expect(helper.gravatar_for(@email)).to eq(expected_gravatar_link)
    end

    it 'specifies image size' do
      expect(helper.gravatar_for(@email, size: 200)).to match /\?s=200&/
    end
  end

  describe '#valid_email?' do
    it 'returns true if email is valid' do
      expect(valid_email?('valid@valid.com')).to be_true
    end

    it 'returns false if email is invalid' do
      expect(valid_email?('invalid')).to be_false
      expect(valid_email?('invalid@')).to be_false
      expect(valid_email?('invalid@invalid')).to be_false
      expect(valid_email?('invalid@invalid.')).to be_false
      expect(valid_email?('invalid@.invalid')).to be_false
      expect(valid_email?('invalid@invalid.i')).to be_false
    end
  end
end
