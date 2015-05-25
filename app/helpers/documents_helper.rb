module DocumentsHelper
  # Not used anywhere
  def clean_html_summary(html)
    sanitize(html.gsub(/<[^>]*>/, ' '), tags: [], attributes: []).truncate(250, separator: ' ')
  end

  def documents
    @documents = Document.where("project_id = ?", @project.id).order(:created_at).includes(:user)
  end

  def metadata
    if @document.versions.empty?
      "Created #{time_ago_in_words(@document.created_at)} ago by #{@document.user.display_name}"
    else
      "#{@document.versions.last.event.titleize}d #{time_ago_in_words(@document.versions.last.created_at)} ago by #{user_details(@document.versions.last.version_author)}"
    end
  end

  # Not used
  def created_date
    "Created #{time_ago_in_words(@document.created_at)} ago"
  end

  def inside_mercury?
    controller.request.original_url =~ /mercury_frame=true/
  end
end
