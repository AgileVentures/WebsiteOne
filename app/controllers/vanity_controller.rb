# frozen_string_literal: true

class VanityController < ApplicationController
  include Vanity::Rails::Dashboard
  layout false
end
