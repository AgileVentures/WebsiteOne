class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.friendly.find(get_page_id(params[:id]))
  end

  def mercury_update
    @page = StaticPage.friendly.find(params[:id])
    if @page.update_attributes(title: params[:content][:static_page_title][:value],
                                   body: params[:content][:static_page_body][:value])
      render text: '' # So mercury knows it is successful
    end
  end

  def mercury_saved
    redirect_to "/#{StaticPage.url_for_me(get_page_id(params[:id]))}", notice: 'The page has been successfully updated.'
  end

  private

  def get_page_id page
    page.split("/").reject { |i| ["mercury_saved", "mercury_update"].include? i }.last
  end
end