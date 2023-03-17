# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, except: %i(show letsencrypt loaderio)

  def loaderio
    render plain: ENV['LOADERIO_TOKEN'] || 'loaderio-296a53739de683b99e3a2c4d7944230f', layout: false
  end

  def letsencrypt
    render plain: "#{params[:id]}.#{ENV.fetch('CERTBOT_SSL_CHALLENGE', nil)}", layout: false
  end

  def show
    return false if redirect_email_blunder

    @page = StaticPage.friendly.find(get_page_id(params[:id]))
    @ancestry = @page.self_and_ancestors.map(&:title).reverse
  end

  private

  def get_page_id(page)
    page.split('/').reject { |i| %w(mercury_saved mercury_update).include? i }.last
  end

  def redirect_email_blunder
    redirect_to(static_page_path('premiumplus')) and return true if params[:id] == 'premiumplus  '
  end
end
