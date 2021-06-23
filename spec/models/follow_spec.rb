# frozen_string_literal: true

describe Follow, type: :model do
  it 'should set blocked to true when block! is called ' do
    follow = Follow.new
    expect(follow).to receive(:update_attribute).with(:blocked, true)
    follow.block!
  end
end
