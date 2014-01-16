require 'spec_helper'

describe "Documents" do
  describe "GET /documents" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get documents_path
      response.status.should be(200)
    end
  end
end
