def create_privileged_user
  Settings.privileged_users.each do |email|
    FactoryGirl.create(:user, email: email)
  end
end

def get_privileged_user
  create_privileged_user
  user = User.where(email: Settings.privileged_users[0]).take
end
