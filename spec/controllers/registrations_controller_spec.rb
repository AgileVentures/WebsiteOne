require 'spec_helper'

describe RegistrationsController do
  describe 'POST create' do
    context 'successful save' do
      before(:each) do
        request.env['devise.mapping'] = Devise.mappings[:user]
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
        request.env['devise.mapping'] = Devise.mappings[:user]
        ActionMailer::Base.deliveries.clear
      end

      it 'does not email upon failure to register' do
        post :create, user: {email: 'random@random.com', password: 'randomrando', password_confirmation: 'randomrandom'}
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'sets omniauth session to nil' do
        post :create, user: {email: 'random2@random.com', password: 'randomrando', password_confirmation: 'randomrandom'}
        expect(session[:omniauth]).to eq nil
      end
    end
  end

  describe '#update' do
    let(:valid_session) { {} }

    before(:each) do
      # stubbing out devise methods to simulate authenticated user
      @user = double('user', id: 1, friendly_id: 'some-id')
      request.env['warden'].stub :authenticate! => @user
      controller.stub :current_user => @user

      request.env['devise.mapping'] = Devise.mappings[:user]
      User.stub_chain(:friendly, :find).with(an_instance_of(String)).and_return(@user)
      @user.stub(:skill_list=)
    end

    it 'renders edit on preview' do
      @user.stub(:display_email=)
      put :update, id: 'update', preview: true, user: {email: ''}
      expect(response).to render_template(:edit)
    end

    it 'assigns the requested project as @project' do
      expect(@user).to receive(:update_attributes)
      put :update, id: 'update', user: {display_hire_me: true}
      expect(assigns(:user)).to eq(@user)
    end

    context 'successful update' do
      before(:each) do
        @user.stub(:update_attributes).and_return(true)
        put :update, id: 'some-id', user: {display_hire_me: true}
      end

      it 'redirects to the user show page' do
        expect(response).to redirect_to(user_path(@user))
      end

      it 'shows a success message' do
        expect(flash[:notice]).to eq('You updated your account successfully.')
      end
    end

    context 'unsuccessful update' do
      before(:each) do
        @user.stub(:update_attributes).and_return(false)
        put :update, id: 'some-id', user: {email: ''}
      end
      it 'renders edit' do
        expect(response).to render_template(:edit)
      end

      # How to test this
      it 'shows an unsuccessful message' do
        expect(flash[:notice]).to_not eq('You updated your account successfully.')
      end
    end
  end
end
