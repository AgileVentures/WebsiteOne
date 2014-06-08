module DisqusHelper
  def render_disqus_for(type)
    case type
    when :article
      render partial: 'shared/disqus', locals: {id: 'article_' + @article.id.to_s, title: @article.title, url: article_path(@article, only_path: false)}
    when :document
      render partial: 'shared/disqus', locals: {
          id: 'document_' + @document.id.to_s,
          title: @document.title,
          url: project_document_path(@project, @document, only_path: false)
      } unless controller.request.original_url =~ /mercury_frame=true/
    end
  end
end
