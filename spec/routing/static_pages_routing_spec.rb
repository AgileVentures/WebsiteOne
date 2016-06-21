require "spec_helper"

  describe StaticPagesController do
    context 'email link blunder' do
      include RSpec::Rails::RequestExampleGroup
      it 'redirects to premiumplus' do
        expect(get('/premiumplus%C2%A0%C2%A0')).to redirect_to('/premiumplus')
      end
    end
  end