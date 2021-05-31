# frozen_string_literal: true

describe 'Assets' do
  it 'should have mercury missing-image.png' do
    expect(Rails.application.assets.find_asset('mercury/missing-image.png')).to_not be_nil
  end
end
