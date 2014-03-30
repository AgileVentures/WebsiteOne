require 'spec_helper'

describe RegistrationsController do
  describe "#create" do
    context 'successful save' do
      before(:each) do
        request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, user: {email: 'random@random.com', password: 'randomrandom', password_confirmation: 'randomrandom'}
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
      before(:each) do
        request.env["devise.mapping"] = Devise.mappings[:user]
      end

      it 'does not email upon failure to register' do
        post :create, user: {email: 'random@random.com', password: 'randomrando', password_confirmation: 'randomrandom'}
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'sets omniauth session to nil' do
        post :create, user: {email: 'random2@random.com', password: 'randomrando', password_confirmation: 'randomrandom'}
        session[:omniauth].should eq nil
      end

      it 'has an active record error message in the user instance variable when registration fails due to email already being in db' do
        FactoryGirl.create :user
        post :create, user: {email: 'example@example.com', password: 'randomrandom', password_confirmation: 'randomrandom'}
        expect(assigns(:user).errors.full_messages).to include "Email has already been taken"
      end

      # Deal with it later
      xit 'has an active record error message in the user instance variable when registration fails due to non matching passwords' do
        post :create, 'user' => {'email' => 'example2@example.com', 'password' => 'pppppppp', 'password_confirmation' => 'aaaaaaaaaa'}
        expect(assigns(:user).errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe "#update" do
  end
end