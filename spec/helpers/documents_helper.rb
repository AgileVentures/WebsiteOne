
require 'spec_helper'

 describe DocumentsHelper do

  it '#shows metadata which includes data and the owner of document' do
     @document = mock_model(Document, user: "John", created_at: (Date.new(2015,1,1)))
     expect(document).to match / "Created #{time_ago_in_words(@document.created_at)} ago by #{@document.user.display_name}/
     end
  it '#shows the date of a document' do
     @document = mock_model(Document, user: "John", created_at: (Date.new(2015,1,1)))
     expect(document).to match / "Created #{time_ago_in_words(@document.created_at)} ago/
     end
   end
end


