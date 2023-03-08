# frozen_string_literal: true

class ImportGettingStartedStaticPage < ActiveRecord::Migration[4.2]
  def up
    page_path = Rails.root.join('app', 'views', 'pages', 'getting-started.html.erb')
    page = StaticPage.friendly.find_by_id('getting-started') || StaticPage.create!(title: 'Getting started')
    page.update(body: File.read(page_path))
    puts 'Imported Getting_started static page'
  end

  def down; end
end
