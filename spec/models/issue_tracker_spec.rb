require 'spec_helper'

describer IssueTracker, type: :model do
   it {is_expected.to belong_to :project} 
end