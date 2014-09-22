module Mercury
  module Authentication

    def can_edit?
      unless user_signed_in? && valid_mercury_path? 
        flash[:alert] = 'You do not have the right privileges to complete action.'
        false
      else
        true
      end
    end
   
    def valid_mercury_path?
      is_project_edit_path? || is_documents_edit_path? || is_static_pages_edit_path? 
    end
 
    def is_project_edit_path?
      /editor(\/|\/\/)projects\/[^\/]+/i =~ request.env['PATH_INFO']
    end

    def is_documents_edit_path?
      /editor(\/|\/\/)projects\/[^\/]+\/documents\/[^\/]+/i =~ request.env['PATH_INFO']
    end

    def is_static_pages_edit_path? 
      StaticPage.friendly.exists?((params[:requested_uri] || request.env['PATH_INFO']).split("/").reject { |i| ["mercury_saved", "mercury_update"].include? i }.last)
    end
  end
end
