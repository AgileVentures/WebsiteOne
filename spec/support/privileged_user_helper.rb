# frozen_string_literal: true

def create_privileged_user
  Settings.privileged_users.split(',').each do |email|
    FactoryBot.create(:user, email: email)
  end
end

def get_privileged_user
  create_privileged_user
  user = User.where(email: Settings.privileged_users.split(',')[0]).take
end
