require 'spec_helper'

describe "Newsletters" do
  describe "GET /newsletters" do
    it "at least it seems okay" do
      get newsletters_path
      response.status.should be(200)
    end
  end
end
