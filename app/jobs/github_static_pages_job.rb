require 'octokit'
require 'base64'

module GithubStaticPagesJob
  extend self

  def client
    credentials = {
        client_id: Settings.github.client_id,
        client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run
    repo_content = client.contents('agileventures/agileventures')
    md_pages = repo_content.select{|page| page if page[:path] =~ /\.md$/i}
    md_pages.each do |page|
      page_content = client.contents('agileventures/agileventures', path: page[:path])
      markdown = Base64.decode64(page_content[:content])
      # TODO: identify static page that is gonna get updated
      static_page = StaticPage.find_by_slug('about-us')
      unless static_page.nil?
        static_page.body = MarkdownConverter.new(markdown).as_html
        static_page.save!
      end
      # TODO: create a new static page if we didn't find it?
      break
    end
  end
end
