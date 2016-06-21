class StaticPagesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def show
    return false if redirect_email_blunder
    @page = StaticPage.friendly.find(get_page_id(params[:id]))
    @ancestry = @page.self_and_ancestors.map(&:title).reverse
  end

  def mercury_update
    @page = StaticPage.friendly.find(params[:id])
    if @page.update_attributes(title: params[:content][:static_page_title][:value],
                                   body: params[:content][:static_page_body][:value])
      render text: '' # So mercury knows it is successful
    else
      render nothing: true
    end
  end

  def mercury_saved
    redirect_to static_page_path(get_page_id(params[:id])), notice: 'The page has been successfully updated.'
  end

  private

  def get_page_id page
    page.split('/').reject { |i| ['mercury_saved', 'mercury_update'].include? i }.last
  end

  def redirect_email_blunder
    if params[:id] == "premiumplus  "
      redirect_to(static_page_path("premiumplus")) and return true
    end
  end
end
