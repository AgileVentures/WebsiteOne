require 'act_as_page'

class StaticPage < ActiveRecord::Base
  include ActAsPage

  #Sampriti: Used to generate paths, used only in testing.
  # Might want to switch to rake generated paths in the future
  def url_for_me(action)
    if action == 'show'
      "/#{self.slug}"
    else
      "/#{self.slug}/#{action}"
    end
  end
end
