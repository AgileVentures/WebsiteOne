module ApplicationHelper
  def gravatar_for(email, options = { size: 80 })
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=mm"
  end
end
