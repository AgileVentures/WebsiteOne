require 'spec_helper'

describe 'Assets' do

  it 'should have mercury missing-image.png' do

    Rails.application.assets.find_asset('mercury/missing-image.png').should_not be_nil
  end
end