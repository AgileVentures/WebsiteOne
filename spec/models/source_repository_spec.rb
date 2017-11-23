require 'spec_helper'

describe SourceRepository, type: :model do
  it { is_expected.to belong_to :project}
end
