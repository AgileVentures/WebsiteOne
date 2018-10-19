require 'octokit'

module GithubLanguagesJob
  extend self

  def client
    credentials = {
        client_id: Settings.github.client_id,
        client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run
    Project.with_github_url.each do |project| 
      begin
        add_new_languages_to(project)
      rescue StandardError => error
        log_error(error, project)
      end
    end
  end

  def add_new_languages_to(project)
    new_languages_for(project).each { |language| project.languages << Language.find_or_create_by(name: language) }
  end

  def github_languages_for(project)
    languages = client.languages("#{project.github_repo_name}/#{project.github_repo_user_name}")
    languages.to_hash.keys
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