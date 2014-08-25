require 'spec_helper'
require 'statistics'

describe "Statistics", type: :controller do
  it "gets stats for" do
    expect(Statistics::get_stats_for(:articles)).to eq({})
  end
end
