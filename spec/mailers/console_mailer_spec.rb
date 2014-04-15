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
      mail.subject.should eq('specific subject')
      mail.to.should eq([@user.email])
      mail.from.should eq(['info@agileventures.org'])
    end

    it 'renders the heading' do
      mail.body.encoded.should match('my heading')
    end

    it 'renders the body' do
      mail.body.encoded.should match('my multiline')
    end

  end

end
