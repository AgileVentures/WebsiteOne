# frozen_string_literal: true

require 'octokit'
require 'base64'

module GithubStaticPagesJob
  extend self

  FILE_NAME_REGEX = /\w+[^.md]/

  def client
    credentials = {
      client_id: Settings.github.client_id,
      client_secret: Settings.github.client_secret
    }
    @client ||= Octokit::Client.new(credentials)
  end

  def run
    content = get_content('agileventures/agileventures')
    process_markdown_pages(get_markdown_pages(content))
  rescue StandardError => e
    ErrorLoggingService.new(e).log('Trying to get the content from the repository may have caused the issue!')
  end

  private

  def get_content(repository)
    client.contents(repository)
  end

  def get_markdown_pages(content)
    content.select { |page| page if page[:path] =~ /\.md$/i }
  end

  def process_markdown_pages(md_pages)
    md_pages.each do |page|
      filename = page[:path]
      page_content = client.contents('agileventures/agileventures', path: filename)
      markdown = Base64.decode64(page_content[:content])
      static_page = StaticPage.find_by_slug(get_slug(filename))
      static_page.nil? ? create_static_page(filename, markdown) : update_body(static_page, markdown)
    rescue Encoding::UndefinedConversionError => e
      ErrorLoggingService.new(e).log("Trying to convert this page: #{filename} caused the issue!")
    end
  end

  def create_static_page(filename, markdown)
    StaticPage.create(
      title: get_title(filename),
      body: convert_markdown_to_html(markdown),
      slug: get_slug(filename)
    )
  end

  def update_body(static_page, markdown)
    static_page.body = convert_markdown_to_html(markdown)
    static_page.save!
  end

  def get_title(filename)
    get_slug(filename).tr('-', ' ').titleize
  end

  def get_slug(filename)
    FILE_NAME_REGEX.match(filename)[0].downcase.tr('_', '-')
  end

  def convert_markdown_to_html(markdown)
    MarkdownConverter.new(markdown).as_html
  end
end
