class ImportGettingStartedStaticPage < ActiveRecord::Migration
  def up
    page_path = Rails.root.join('app', 'views', 'pages', 'getting-started.html.erb')
    page = StaticPage.friendly.find('getting-started')
    page.update(body: File.open(page_path).read) if page.present?
    puts 'Imported Getting_started static page'
  end

  def down

  end
end
