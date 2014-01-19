module ApplicationHelper
  def gravatar_for(user, options = { size: 80 })
    hash = Digest::MD5::hexdigest(user.email.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=mm"
  end
end
