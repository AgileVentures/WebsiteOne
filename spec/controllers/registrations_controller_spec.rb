require 'spec_helper'

describe RegistrationsController do
  describe "#create" do
    context 'successful save' do
      before(:each) do
        request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, 'user' => {'email' => 'random@random.com', 'password' => 'randomrandom', 'password_confirmation' => 'randomrandom'}
      end

      it 'redirects to index' do
        expect(response).to redirect_to(root_path)
      end

      it 'assigns successful message' do
        expect(flash[:notice]).to eq('Welcome! You have signed up successfully.')
      end

      it 'should send an welcome massage to new user' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.subject).to eq 'Welcome to AgileVentures.org'
        recipients = email.to
        expect(recipients.size).to eq 1
        expect(recipients[0]).to eq 'random@random.com'
      end
    end

    context 'unsuccessful save' do
    end
  end

  describe "#update" do
  end
end