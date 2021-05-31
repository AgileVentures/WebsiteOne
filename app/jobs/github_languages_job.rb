# frozen_string_literal: true

require 'octokit'

module GithubLanguagesJob
  module_function

  def client
    credentials = {
      client_id: Settings.github.client_id,
      client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run
    Project.with_github_url.each do |project|
      add_new_languages_to(project)
    rescue StandardError => e
      log_error(e, project)
    end
  end

  def add_new_languages_to(project)
    new_languages_for(project).each { |language| project.languages << Language.find_or_create_by(name: language) }
  rescue ActiveRecord::RecordNotUnique => e
    log_error(e, project)
    retry
  end

  def github_languages_for(project)
    languages_array = []
    project.source_repositories.each do |source_repository|
      path = URI.parse(source_repository.url).path
      path = path.slice(1..path.length)
      languages = client.languages(path)
      languages_array << languages.to_hash.keys
    end
    languages_array.flatten!
  end

  def db_languages_for(project)
    project.languages.map { |language| language.name.to_sym }
  end

  def new_languages_for(project)
    github_languages_for(project) - db_languages_for(project)
  end

  def log_error(error, project)
    ErrorLoggingService.new(error).log("Updating the languages for #{project.github_url} may have caused the issue!")
  end
end
