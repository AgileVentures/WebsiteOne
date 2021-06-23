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
      project.update(pitch: content(project.github_repo, 'PITCH.md'))
    rescue StandardError => e
      evaluate_exception(e, project)
    end
  end

  def replace_relative_links_with_absolute(project_readme_html, project)
    anchor_tag = 'a'
    base_uri = "#{project.github_url}/blob/master/"
    doc = Nokogiri::HTML(project_readme_html)
    doc.search(anchor_tag).each do |node|
      convert_path(node, base_uri) unless anchor_link?(node[:href])
    end
    doc.to_html
  end

  private

  def anchor_link?(url)
    url.empty? || url.match?(/^\#/)
  end

  def convert_path(node, base_uri)
    node[:href] = "#{base_uri}#{URI(node[:href])}" if URI(node[:href]).relative?
  end

  def project_readme(project)
    project_readme_content = content(project.github_repo, 'README.md')
    project.update(pitch: replace_relative_links_with_absolute(project_readme_content, project))
  rescue StandardError => e
    log_error(e, project)
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
