# frozen_string_literal: true

class StaticPage < ApplicationRecord
  include ActAsPage

  # Sampriti: Used to generate paths, both for routes and testing. DO NOT DELETE
  def self.url_for_me(page)
    static_page = StaticPage.find_by_title(page.to_s) || StaticPage.find_by_slug(page.to_s) || (if page.is_a? StaticPage
                                                                                                  page
                                                                                                end)
    if static_page.nil?
      page.parameterize
    else
      static_page.to_param
    end
  end

  def to_param
    self_and_ancestors.map(&:slug).reverse.join('/')
  end
end
