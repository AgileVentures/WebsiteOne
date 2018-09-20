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
    source_site = "#{project.github_url}/blob/master/"
    doc = Nokogiri::HTML(project_readme_content)
    tags = { 'a' => 'href' }
    doc.search(tags.keys.join('')).each do |node|
      url_param = tags[node.name]
      href = node[url_param]
      unless (href.empty?) || (href.match?(/^\#/))
        uri = URI.parse(href)
        if uri.relative?
          uri = "#{source_site}#{uri}"
          node[url_param] = uri
        end
      end
    end
    doc.to_html
  end

  private

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
