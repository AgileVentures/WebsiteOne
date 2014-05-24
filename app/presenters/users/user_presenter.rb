class UserPresenter

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def display_name
    user.display_name
  end

  def title_list
    user.title_list.join(', ')
  end

  def country
    user.country if user.country.present?
  end

  def gravatar_src(options={size: 80})
    hash = Digest::MD5::hexdigest(user.email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=retro"
  end
end
