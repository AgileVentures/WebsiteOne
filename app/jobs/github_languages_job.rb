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
    Project.with_github_url.each do |p|
      begin
        languages = client.languages("#{p.github_repo_name}/#{p.github_repo_user_name}")
        language_names = languages.to_hash.keys
        existing_languages = p.languages.collect(&:name).collect(&:to_sym)
        incoming_languages = language_names - existing_languages
        incoming_languages.each { |language| p.languages.build(name: language) }
        p.save!
      rescue StandardError => e
        ErrorLoggingService.new(e).log("Updating the languages for #{p.github_url} may have caused the issue!")
      end
    end
  end
end
