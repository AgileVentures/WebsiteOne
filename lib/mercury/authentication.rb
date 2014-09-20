module Mercury
  module Authentication

    def can_edit?
      if user_signed_in? && valid_mercury_path? 
        true
      else
        flash[:alert] = 'You do not have the right privileges to complete action.' #TODO: this is not the right error message
        false
      end
    end
   
    def valid_mercury_path?
      return true if is_project_edit_path? || is_in_path? || static_page_exists? 
    end
 
    def is_project_edit_path?
      /editor\/projects\/.+/i =~ request.env['PATH_INFO']
    end

    def is_in_path?
      # TODO: what is this ???
      /editor(\/|\/\/)projects\/[^\/]+\/documents\/[^\/]+/i.match(request.env['PATH_INFO'])
    end

    def static_page_exists?
      StaticPage.friendly.exists?((params[:requested_uri] || request.env['PATH_INFO']).split("/").reject { |i| ["mercury_saved", "mercury_update"].include? i }.last)
    end
  end
end
