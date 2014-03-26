require 'act_as_page'

class StaticPage < ActiveRecord::Base
  include ActAsPage

  #Sampriti: Used to generate paths, both for routes and testing. DO NOT DELETE
  def self.url_for_me(page)
    static_page = StaticPage.find_by_title(page) || StaticPage.find_by_slug(page)
    if static_page.nil?
      page.parameterize
    else
      static_page.ancestors.map(&:slug).reverse.append(static_page.slug).join("/")
    end
  end
end
