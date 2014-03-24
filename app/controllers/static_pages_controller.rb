class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.friendly.find(params[:id])
  end

  def mercury_update
    @page = StaticPage.friendly.find(params[:id])
    if @page.update_attributes(title: params[:content][:static_page_title][:value],
                                   body: params[:content][:static_page_body][:value])
      render text: '' # So mercury knows it is successful
    end
  end

  def mercury_saved
    redirect_to static_page_path(params[:id]), notice: 'The page has been successfully updated.'
  end
end