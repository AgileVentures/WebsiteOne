module Mercury
  module Authentication

    def can_edit?
      if user_signed_in?
        true
      else
        flash[:alert] = 'You do not have the right privileges to complete action.'
        false
      end
    end

  end
end
