require 'spec_helper'

describe ApplicationController do 
  controller do
    def events
      render :text => ""
    end 
    def new
      render :text => ""
    end 
    def new_user
      render :text => ""
    end 
    def new_password
      render :text => ""
    end 
    def signout
      render :text => ""
    end 
    def edit_password
      render :text => ""
    end 
  end

  before do
    @routes.draw do
      match "/events" => "anonymous#events", :as => :events, via: [:get, :post, :delete, :put]
      get "/users/sign_in" => "anonymous#new", :as => :user_session
      get "/users/sign_up" => "anonymous#new_user", :as => :new_user_registration
      get "/users/password/new" => "anonymous#new_password", :as => :new_user_password
      get "/users/sign_out" => "anonymous#signout", :as => :destroy_user_session
      get "/users/password/edit" => "anonymous#edit_password", :as => :edit_user_password
    end
  end

  describe "store a location if not a blacklisted url" do
    it "should store the path in the session if a get request" do
      get :events
      expect(session[:previous_url]).to eq('/events')
    end 
  end
  describe "do not store a location if url okay but not a get request" do
    it "should not store the path in the session if a put request" do
      put :events
      expect(session[:previous_url]).to_not eq('/events')
    end 
    it "should not store the path in the session if an xhr request" do
      xhr :get,  :events
      expect(session[:previous_url]).to_not eq('/events')
    end 
    it "should not store the path in the session if a delete request" do
      delete  :events
      expect(session[:previous_url]).to_not eq('/events')
    end 
    it "should not store the path in the session if a post request" do
      post  :events
      expect(session[:previous_url]).to_not eq('/events')
    end 
  end
  describe "do not store a location if a blacklisted url" do
    it "doesn't accept sign in path" do
      get :new
      puts "The user session path is #{user_session_path}"
      expect(session[:previous_url]).to be_nil
    end 
    it "doesn't accept sign up path" do
      get :new_user
      puts "The user session path is #{user_session_path}"
      expect(session[:previous_url]).to be_nil
    end 
    it "doesn't accept new user password path" do
      get :new_password
      puts "The user session path is #{user_session_path}"
      expect(session[:previous_url]).to be_nil
    end 
    it "doesn't accept sign in" do
      get :signout
      puts "The user session path is #{user_session_path}"
      expect(session[:previous_url]).to be_nil
    end 
    it "doesn't accept sign in" do
      get :edit_password
      puts "The user session path is #{user_session_path}"
      expect(session[:previous_url]).to be_nil
    end 
  end
end
