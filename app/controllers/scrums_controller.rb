require 'you_tube'

class ScrumsController < ApplicationController
  def index
    query = YouTube.new('AtlanticScrum|AmericasScrum|EuroScrum|EuroAsia|OSRA Scrum', 20).perform_query

    @scrums = query
  end
end
