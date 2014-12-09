require 'spec_helper'

include RegistrationsHelper

describe RegistrationsHelper, :type => :controller do
  it 'display email' do
  	session[:display_email] = "myname@myname.com"
    session[:display_email].should eq "myname@myname.com"
  end
end
