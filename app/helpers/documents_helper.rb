# frozen_string_literal: true

module DocumentsHelper
  def documents
    @documents = Document.where('project_id = ?', @project.id).order(:created_at).includes([:user, :children])
  end

  def metadata
    if @document.versions.empty?
      "Created #{time_ago_in_words(@document.created_at)} ago by #{@document.user.display_name}"
    else
      "#{@document.versions.last.event.titleize}d #{time_ago_in_words(@document.versions.last.created_at)} ago by #{user_details(@document.versions.last.version_author)}"
    end
  end

  def inside_mercury?
    controller.request.original_url =~ /mercury_frame=true/
  end
end
