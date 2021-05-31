# frozen_string_literal: true

describe UsersController, type: :controller do
  describe '#index' do
    it 'should return a status code of 200' do
      expect(response.code).to eq('200')
    end

    it 'should assign the results of the search to @users' do
      user = FactoryBot.create(:user)
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe '#new' do
    before do
      @user = User.new
    end

    it 'new creates a User object" ' do
      expect(@user).to be_an_instance_of User
    end
  end

  describe '#show' do
    before do
      @projects = build_stubbed_list(:project, 3)
      @user = build_stubbed(:user)
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
        get 'show', params: { id: @user.friendly_id }
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
        expect { get 'show', params: { id: @user.friendly_id } }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'send hire me button message' do
    let(:mail) { ActionMailer::Base.deliveries }

    before(:each) do
      @user = build_stubbed(:user, display_hire_me: true)
      allow(User).to receive(:find).with(@user.id.to_s).and_return(@user)
      request.env['HTTP_REFERER'] = 'back'
      mail.clear
    end

    let(:valid_params) do
      {
        contact_form: {
          name: 'Thomas',
          email: 'example@example.com',
          message: 'This is a message just for you',
          recipient_id: @user.id
        }
      }
    end

    let(:invalid_params) do
      {
        contact_form: {
          name: 'Thomas',
          email: '',
          message: 'This is a message just for you',
          recipient_id: @user.id
        }
      }
    end

    let(:empty_params) do
      {
        contact_form: {
          name: '',
          email: '',
          message: '',
          recipient_id: @user.id
        }
      }
    end

    context 'with valid parameters' do
      before(:each) { post :hire_me, params: valid_params }

      it 'should redirect to the previous page' do
        expect(response).to redirect_to user_path(@user.id)
      end

      it 'should respond with "Your message has been sent successfully!"' do
        expect(flash[:notice]).to eq 'Your message has been sent successfully!'
      end

      it 'should send out an email to the user' do
        expect(mail.count).to eq 1
        expect(mail.last.to).to include @user.email
      end
    end

    context 'with invalid parameters' do
      context 'empty form fields' do
        before(:each) { post :hire_me, params: invalid_params }

        it 'should redirect to the previous page' do
          expect(response).to have_http_status(:ok)
        end

        it 'should respond with "Email cant be blank' do
          expect(flash[:alert]).to include "Email can't be blank"
        end
      end

      context 'invalid email address' do
        before(:each) do
          post :hire_me,
               params: { contact_form: { name: 'Thomas', email: 'example@example..com', message: 'This is a message just for you',
                                         recipient_id: @user.id } }
        end

        it 'should redirect to the previous page' do
          expect(response).to have_http_status :ok
        end

        it 'should respond with "Please give a valid email address"' do
          expect(flash[:alert]).to eq ['Email is invalid']
        end
      end
    end

    context 'with empty parameters' do
      it 'should fail with no back path' do
        request.env['HTTP_REFERER'] = nil
        post :hire_me, params: empty_params
        expect(flash[:alert]).to include 'Email is invalid'
        expect(flash[:alert]).to include "Email can't be blank"
        expect(flash[:alert]).to include "Name can't be blank"
        expect(flash[:alert]).to include "Message can't be blank"
      end
    end
  end

  describe 'PATCH add_status_user' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_attributes) { { status: 'Sleeping at my keyboard', user_id: user.friendly_id } }

    before(:each) do
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    end

    context 'with valid attributes' do
      before(:each) do
        patch :add_status, params: { id: user, user: valid_attributes }
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
        patch :add_status, params: { id: user, user: {} }
        expect(flash[:alert]).to eq 'Something went wrong...'
      end
    end
  end
end
