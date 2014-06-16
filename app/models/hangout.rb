class Hangout < ActiveRecord::Base
  belongs_to :event

  def started?
    true if hangout_url.present?
  end

  def update_hangout_data(params)
    update(title: params[:title], hangout_url: params[:hangout_url])
  end
end
