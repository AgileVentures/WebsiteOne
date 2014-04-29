require 'spec_helper'

include ApplicationHelper

describe DocumentsHelper do
  describe "#clean_html_summary" do
    it 'strips out all html and keeps only text' do
      sample_text = "<script>alert(1)</script>"
      clean_html_summary(sample_text).should eq " alert(1) "
    end
  end

  describe "#metadata" do
    it 'displays metadata with user name and event' do
      @user = stub_model(User, display_name: "Sampriti Panda")
      User.stub(:find_by_id) .and_return(@user)
      @version = stub_model(PaperTrail::Version,
                            item_type: "Document",
                            event: "create",
                            whodunnit: @user.id,
                            object: nil,
                            created_at: 3.minutes.from_now
      )
      @document = stub_model(Document, versions: [@version], user: @user)

      metadata.should eq "Created 3 minutes ago by Sampriti Panda"
    end
  end
end