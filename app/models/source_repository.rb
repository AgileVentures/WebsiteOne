class SourceRepository < ActiveRecord::Base
  belongs_to :project

  def name
    return '' if url.nil?
    return url unless url.include? '/'
    url.split('/').last
  end
end
