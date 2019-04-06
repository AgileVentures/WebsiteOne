require 'spec_helper'

describe IssueTracker, type: :model do
   it {is_expected.to belong_to :project} 
end