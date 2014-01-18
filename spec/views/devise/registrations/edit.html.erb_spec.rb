require 'spec_helper'

describe 'users/registrations/edit.html.erb' do
  it 'fsdfs' do
    view.should_receive(:resource).at_least(1).times.and_return(User.new)
    view.should_receive(:resource_name).at_least(1).times.and_return('user')
    view.should_receive(:devise_mapping).and_return(Devise.mappings[:user])

    render
  end
end
