module Mercury
  module Authentication

    def can_edit?
      if user_signed_in? and /editor(\/|\/\/)projects\/[^\/]+\/documents\/[^\/]+/i.match(request.env['PATH_INFO'])
        # TODO Bryan: examine user privileges
        true
      else
        flash[:alert] = 'You do not have the right privileges to complete action.'
        false
      end
    end

  end
end
