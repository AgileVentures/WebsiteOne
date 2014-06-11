class Hangout < ActiveRecord::Base
  def started?
    true if hangout_url
  end

  def update_hangout_data(params)
    update(title: params[:title], hangout_url: params[:hangout_url])
  end
end
