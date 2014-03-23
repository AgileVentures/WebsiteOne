class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.friendly.find(params[:id])
  end
end