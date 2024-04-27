# frozen_string_literal: true

class CookiesController < ApplicationController
  def index
    session[:cookies_accepted] = params[:cookies] if params[:cookies]
    redirect_back_or_to '/'
  end
end
