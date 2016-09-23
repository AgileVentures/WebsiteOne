require 'spec_helper'

describe Subscription, :type => :model  do
  it{ should belong_to :user}
end