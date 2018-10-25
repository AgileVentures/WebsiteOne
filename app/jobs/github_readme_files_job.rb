# frozen_string_literal: true

require 'octokit'
require 'base64'

module GithubReadmeFilesJob
  extend self

  def client
    credentials = {
        client_id: Settings.github.client_id,
        client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run(projects)
    projects.each do |project|
      begin
        project.update(pitch: content(project.github_repo, 'PITCH.md'))
      rescue StandardError => e
        evaluate_exception(e, project)
      end
    end
  end

  def replace_relative_links_with_absolute(project_readme_content, project)
    doc = Nokogiri::HTML(project_readme_content)       # doc is a Nokogiri object
    doc.search('a').each do |node|
      convert_path(node, "#{project.github_url}/blob/master/")
    end
    doc.to_html
  end

  private
  
  def convert_path(node, source_site)
    tags = { 'a' => 'href' }
    url_param = tags[node.name]                    # return "href"
    href = node[url_param]                           # node['href'] -> returns the nodes url. node.attributes.value
    unless anchor_link?
      uri = URI.parse(href)
      if uri.relative?
        uri = "#{source_site}#{uri}"
        node[url_param] = uri
      end
    end  
  end
  
  def anchor_link?
    href.empty? || href.match? /^\#/
  end

  def project_readme(project)
    begin
      project_readme_content = content(project.github_repo, 'README.md')
      project.update(pitch: replace_relative_links_with_absolute(project_readme_content, project))
    rescue StandardError => e
      log_error(e, project)
    end
  end

  def error_message(repository)
    "Trying to get the content from #{repository} have caused the issue!"
  end

  def content(repository, path)
    client.contents repository, path: path, accept: 'application/vnd.github.html'
  end

  def evaluate_exception(error, project)
    if error.message.include?('404 - Not Found')
      project_readme(project)
    else
      log_error(error, project)
    end
  end


  def log_error(error, project)
    ErrorLoggingService.new(error).log(error_message(project.github_repo))
  end
end
