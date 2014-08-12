require 'spec_helper'

describe NullUser, type: :model do
  let(:user) { NullUser.new('I am not null') }

  it '#presenter' do
    expect(user.presenter).to eq(user)
  end

  it '#display_name' do
    expect(user.display_name).to eq('I am not null')
  end

  it '#gravatar_image' do
    output = user.gravatar_image(size: 40, id: 'user-gravatar', class: 'img-circle')

    expect(output).to match(/<img alt="I am not null" class="img-circle" height="40" id="user-gravatar"/)
    expect(output).to match(/#{"https://www.gravatar.com/avatar/1&amp;d=retro&amp;f=y"}/)
  end

  it '#user_avatar_with_popover' do
    allow(user).to receive(:display_name).and_return('user_name')
    allow(user).to receive(:gravatar_image).and_return('user_gravatar')

    placement = 'right'
    popover_content = 'Member for: <br/>User rating: <br/>PP sessions:'

    output = user.user_avatar_with_popover({ placement: placement })

    expect(output).to match(/data-title="user_name"/)
    expect(output).to match(/data-placement="#{placement}"/)
    expect(output).to match(/data-content="not registered"/)
    expect(output).to match(/user_gravatar/)
    expect(output).to match(/href="#"/)
  end
end
