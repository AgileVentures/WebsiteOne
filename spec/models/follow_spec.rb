require 'spec_helper'

describe Follow do

  it 'should set blocked to true when block! is called ' do
    follow = Follow.new
    follow.should_receive(:update_attribute).with(:blocked, true)
    follow.block!
  end
end
