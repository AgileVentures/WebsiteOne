require 'spec_helper'

RSpec.describe DocumentsHelper, :type => :helper do
  describe "#metadata" do
    before do
      @user = FactoryGirl.build_stubbed(:user, first_name: "User", last_name: nil)
      @document = FactoryGirl.build_stubbed(:document, user: @user)
    end
    
    it "should return metadata of the newly created document" do
      allow(@document).to receive(:versions).and_return([])
      expect(helper.metadata).to eq("Created less than a minute ago by User")
    end
    
    it "should return metadata of the latest version of the document" do
      @document.versions.last.update_attribute(:created_at, 1.month.ago)
      allow(User).to receive(:find_by_id).and_return(@user)
      expect(helper.metadata).to eq("Created about 1 month ago by User")
    end
  end
end