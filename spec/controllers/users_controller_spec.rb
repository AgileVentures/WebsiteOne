require 'spec_helper'

describe UsersController do

  describe "GET index" do
    it 'should return a status code of 200' do
      expect(response.code).to eq('200')
    end

    it 'should assign the results of the search to @users' do
      user = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET show' do
    before :each do
      @projects = [
          Project.new(slug: 'title-1', title: 'Title 1'),
          Project.new(slug: 'title-2', title: 'Title 2'),
          Project.new(slug: 'title-3', title: 'Title 3')]

      @user = double('User', id: 1,
                     first_name: 'Hermionie',
                     last_name: 'Granger',
                     friendly_id: 'harry-potter',
                     email: 'hgranger@hogwarts.ac.uk',
                     display_profile: true,
                     youtube_id: 'test_id'
      )
      @user.stub(:following_by_type).and_return(@projects)
      @user.stub(:skill_list).and_return([])
      User.stub_chain(:friendly, :find).and_return(@user)
      @user.stub(:bio).and_return('test_bio')

      @youtube_videos = [
          {
              url: "http://www.youtube.com/100",
              title: "Random",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/340",
              title: "Stuff",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/2340",
              title: "Here's something",
              published: '01/01/2015'
          }
      ]
      YoutubeHelper.stub(user_videos: @youtube_videos)
    end

    it 'assigns a user instance' do
      get 'show', id: @user.friendly_id
      expect(assigns(:user)).to eq(@user)
    end

    it 'assigns youtube videos' do
      get 'show', id: @user.friendly_id
      expect(assigns(:youtube_videos)).to eq(@youtube_videos)
    end

    it 'renders the show view' do
      get 'show', id: @user.friendly_id
      expect(response).to render_template :show
    end

    context 'with followed projects' do
      it 'it renders an error message when accessing a private profile' do
        @user.stub(display_profile: false)
        expect{get 'show', id: @user.friendly_id}.to raise_error
      end
    end
  end

  describe 'send hire me button message' do

    let(:mail) { ActionMailer::Base.deliveries }

    before(:each) do
      @user = mock_model(User, id: 500, email: 'middle.of.nowhere@home.com')
      User.stub(:find).with(@user.id.to_s).and_return(@user)
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
        response.should redirect_to 'back'
      end

      it 'should respond with "Your message has been sent successfully!"' do
        expect(flash[:notice]).to eq 'Your message has been sent successfully!'
      end

      it 'should send out an email to the user' do
        expect(mail.count).to eq 1
        mail.last.to.should include @user.email
      end

      it 'should respond with "Your message has not been sent!" if the message was not delivered successfully' do
        Mailer.stub_chain(:hire_me_form, :deliver).and_return(false)
        post :hire_me_contact_form, valid_params
        flash[:alert].should eq 'Your message has not been sent!'
      end
    end

    context 'with invalid parameters' do

      before(:each) { post :hire_me_contact_form, message_form: { name: '', email: '', message: '' } }

      it 'should redirect to the previous page' do
        response.should redirect_to 'back'
      end

      it 'should respond with "Please fill in Name, Email and Message field"' do
        flash[:alert].should eq 'Please fill in Name, Email and Message field'
      end
    end

    context 'with empty parameters' do

      it 'should not fail with empty params' do
        post :hire_me_contact_form, { }
        flash[:alert].should eq 'Please fill in Name, Email and Message field'
      end

      it 'should not fail with empty message_form' do
        post :hire_me_contact_form, message_form: { }
        flash[:alert].should eq 'Please fill in Name, Email and Message field'
      end

      it 'should not fail with no back path' do
        request.env['HTTP_REFERER'] = nil
        post :hire_me_contact_form, message_form: { name: '', email: '', message: '' }
        flash[:alert].should eq 'Please fill in Name, Email and Message field'
      end
    end
  end
end
