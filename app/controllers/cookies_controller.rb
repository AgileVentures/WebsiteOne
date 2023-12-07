class CookiesController < ApplicationController
  def index
    session[:cookies_accepted] = params[:cookies] if params[:cookies]
    #session[:cookies_accepted] = nil
  end
end
