# frozen_string_literal: true

module Mercury
  module Authentication
    def can_edit?
      if user_signed_in? && valid_mercury_path?
        true
      else
        flash[:alert] = 'You do not have the right privileges to complete action.'
        false
      end
    end

    def valid_mercury_path?
      is_project_edit_path? || is_documents_edit_path? || is_static_pages_edit_path?
    end

    def is_project_edit_path?
      %r{editor(/|//)projects/[^/]+}i =~ request.env['PATH_INFO']
    end

    def is_documents_edit_path?
      %r{editor(/|//)projects/[^/]+/documents/[^/]+}i =~ request.env['PATH_INFO']
    end

    def is_static_pages_edit_path?
      StaticPage.friendly.exists?((params[:requested_uri] || request.env['PATH_INFO']).split('/').reject do |i|
                                    %w(mercury_saved mercury_update).include? i
                                  end.last)
    end
  end
end
