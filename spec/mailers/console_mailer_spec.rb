require 'spec_helper'

describe ConsoleMailer do
  describe "#newsletter" do
    before do
      @user = FactoryGirl.create(:user)
    end
    let(:valid_params) {
      { heading: 'my heading',
        content: 'my multiline\ntext blorb',
        subject: 'specific subject'
      } 
    }
    
    let(:mail) { ConsoleMailer.newsletter(@user, valid_params) }
    
    it 'renders the headers' do
      expect(mail.subject).to eq('specific subject')
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(['info@agileventures.org'])
    end

    it 'renders the heading' do
      expect(mail.body.encoded).to match('my heading')
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('my multiline')
    end

    it 'adds cc to sam' do
      expect(mail).to have_default_cc_addresses
    end

  end

end
