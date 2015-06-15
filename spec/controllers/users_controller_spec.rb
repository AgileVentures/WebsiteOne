require 'spec_helper'

describe UsersController, :type => :controller do

  describe '#index' do
    it 'should return a status code of 200' do
      expect(response.code).to eq('200')
    end

    it 'should assign the results of the search to @users' do
      user = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe '#new' do
    before do
      @user = User.new
    end

    it 'new creates a User object" 'do
      expect(@user).to be_an_instance_of User
    end
  end

  describe '#show' do
    before do
      @projects = build_stubbed_list(Project, 3) 
      @user = build_stubbed(User)
      allow(@user).to receive(:following_by_type).and_return(@projects)
      allow(@user).to receive(:skill_list).and_return([])
      User.stub_chain(:friendly, :find).and_return(@user)
      allow(@user).to receive(:bio).and_return('test_bio')
    end

    context 'with a public profile' do
      before(:each) do
        object = double('object')
        expect(EventInstance).to receive(:where).with(user_id: @user.id).and_return(object)
        object2 = double('object2')
        expect(object).to receive(:order).with(created_at: :desc).and_return(object2)
        expect(object2).to receive(:limit).with(5).and_return('videos')

        get 'show', id: @user.friendly_id
      end

      it 'assigns a user instance' do
        expect(assigns(:user)).to eq(@user)
      end

      it 'assigns youtube videos' do
        expect(assigns(:event_instances)).to eq('videos')
      end

      it 'renders the show view' do
        expect(response).to render_template :show
      end
    end

    context 'with a private profile' do
      before do
        allow(@user).to receive(:display_profile).and_return(false)
      end

      it 'it renders an error message when accessing a private profile' do
        expect{get 'show', id: @user.friendly_id}.to raise_error
      end
    end
  end

  describe 'send hire me button message' do

    let(:mail) { ActionMailer::Base.deliveries }

    before(:each) do
      @user = build_stubbed(User, display_hire_me: true)
      allow(User).to receive(:find).with(@user.id.to_s).and_return(@user)
      request.env['HTTP_REFERER'] = 'back'
      mail.clear
    end

    let(:valid_params) do
      {
          message_form: {
              name: 'Thomas',
              email: 'example@example.com',
              message: 'This is a message just for you',
              recipient_id: @user.id
          }
      }
    end

    context 'with valid parameters' do
      before(:each) { post :hire_me_contact_form, valid_params }

      it 'should redirect to the previous page' do
        expect(response).to redirect_to 'back'
      end

      it 'should respond with "Your message has been sent successfully!"' do
        expect(flash[:notice]).to eq 'Your message has been sent successfully!'
      end

      it 'should send out an email to the user' do
        expect(mail.count).to eq 1
        expect(mail.last.to).to include @user.email
      end

      it 'should respond with "Your message has not been sent!" if the message was not delivered successfully' do
        Mailer.stub_chain(:hire_me_form, :deliver).and_return(false)
        post :hire_me_contact_form, valid_params
        expect(flash[:alert]).to eq 'Your message has not been sent!'
      end
    end

    context 'with invalid parameters' do

      context 'empty form fields' do
        before(:each) { post :hire_me_contact_form, message_form: { name: '', email: '', message: '' } }

        it 'should redirect to the previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'should respond with "Please fill in Name, Email and Message field"' do
          expect(flash[:alert]).to eq 'Please fill in Name, Email and Message field'
        end
      end

      context 'invalid email address' do
        before(:each) { post :hire_me_contact_form, message_form: { name: 'Thomas', email: 'example@example..com', message: 'This is a message just for you', recipient_id: @user.id } }

        it 'should redirect to the previous page' do
          expect(response).to redirect_to 'back'
        end

        it 'should respond with "Please give a valid email address"' do
          expect(flash[:alert]).to eq 'Please give a valid email address'
        end
      end
    end

    context 'with spam trap field filled out' do

      before(:each) { post :hire_me_contact_form, message_form: { name: 'Thomas', email: 'example@example.com', message: 'spam', fellforit: 'I am a spammer!',  recipient_id: @user.id } }

      it 'should redirect to the home page' do
        expect(response).to redirect_to root_path
      end 

      it 'should not send an email' do
        expect(mail.count).to eq 0
      end

      it 'should respond with "Form not submitted. Are you human?' do
        expect(flash[:notice]).to eq 'Form not submitted. Are you human?'
      end
    end

    context 'when recipent has disabled hire me functionality' do
      before(:each) do
        allow(@user).to receive(:display_hire_me).and_return(false)
        post :hire_me_contact_form, message_form: { name: 'Thomas', email: 'example@example.com', message: 'test', recipient_id: @user.id }
      end

      it 'should redirect to the previous page' do
        expect(response).to redirect_to 'back'
      end

      it 'should respond with appropriate error message' do
        expect(flash[:alert]).to eq 'User has disabled hire me button'
      end

      it 'should not send an email' do
        expect(mail.count).to eq 0
      end
    end

    context 'with empty parameters' do

      it 'should not fail with empty params' do
        post :hire_me_contact_form, { }
        expect(flash[:alert]).to eq 'Please fill in Name, Email and Message field'
      end

      it 'should not fail with empty message_form' do
        post :hire_me_contact_form, message_form: { }
        expect(flash[:alert]).to eq 'Please fill in Name, Email and Message field'
      end

      it 'should not fail with no back path' do
        request.env['HTTP_REFERER'] = nil
        post :hire_me_contact_form, message_form: { name: '', email: '', message: '' }
        expect(flash[:alert]).to eq 'Please fill in Name, Email and Message field'
      end
    end
  end

  describe 'PATCH add_status_user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:valid_attributes) { {status: 'Sleeping at my keyboard', user_id: user.friendly_id} }

    before(:each) do
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    end

    context 'with valid attributes' do
      before(:each) do
        patch :add_status, id: user, user: valid_attributes
      end

      it 'should require user to be signed in' do
        expect(request.env['warden']).to have_received(:authenticate!)
      end

      it 'should redirect to user show page' do
        expect(response).to redirect_to user_path(user)
      end

      it 'should render a successful flash message' do
        expect(flash[:notice]).to eq 'Your status has been set'
      end
    end

    context 'with invalid attributes' do
      it 'should render a failure flash message' do
        patch :add_status, id: user, user: { }
        expect(flash[:alert]).to eq 'Something went wrong...'
      end
    end
  end

  describe '#set_timezone_offset_range' do
    before do
      @user_controller = UsersController.new
      @user_controller.request = ActionController::TestRequest.new
      @user_controller.request.env['HTTP_REFERER'] = 'http://test.com/users'
      @user_controller.response = ActionController::TestResponse.new
    end

    context 'timezone_filter is blank' do
      it 'returns nil' do
        event = @user_controller.send(:set_timezone_offset_range, {timezone_filter: ""})
        expect(event).to be nil
      end
    end

    context 'timezone_filter is not blank' do
      context 'user has timezone offset' do
        before do
          allow_message_expectations_on_nil
          @current_user.stub(:try).and_return(0)
        end

        it 'returns right params when choose "In My Timezone"' do
          event = @user_controller.send(:set_timezone_offset_range, {timezone_filter: "In My Timezone"})
          expect(event).to eq([0, 0])
        end

        it 'returns right params when choose "Wider Timezone Area"' do
          event = @user_controller.send(:set_timezone_offset_range, {timezone_filter: "Wider Timezone Area"})
          expect(event).to eq([-3600, 3600])
        end

        it 'deletes timezone_filter when change names but not corrected the method' do
          params = {timezone_filter: "Wrong Name"}
          @user_controller.send(:set_timezone_offset_range, params)
          expect(params).to eq({})
        end
      end

      context 'user has not timezone offset' do
        it 'reditects with error' do
          event = @user_controller.send(:set_timezone_offset_range, {timezone_filter: "In My Timezone"})
          expect(event).to match(/redirected/)
        end
      end
    end
  end
end
