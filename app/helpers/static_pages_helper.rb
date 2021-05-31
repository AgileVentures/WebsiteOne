# frozen_string_literal: true

module StaticPagesHelper
  def github_static_pages_edit_url
    "https://github.com/AgileVentures/AgileVentures/edit/master/#{@page.title.tr(' ', '_').upcase}.md"
  end
end
