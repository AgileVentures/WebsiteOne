class Hangout < ActiveRecord::Base
  belongs_to :event

  def started?
    hangout_url.present?
  end

  strong parameters
  def update_hangout_data(params)
    update(title: params[:title], hangout_url: params[:hangout_url])
  end
end
