module UsersHelper

  def user_display_name user
    first = user.try(:first_name)
    last = user.try(:last_name)
    str = first.to_s + last.to_s
    if first && last
      [first, last].join(' ')
    elsif !first && !last
      # User has not filled in their profile
      "Anon"
    else
      str
    end
  end

end
