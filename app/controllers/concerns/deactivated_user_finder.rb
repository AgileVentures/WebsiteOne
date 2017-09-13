module DeactivatedUserFinder 
  extend ActiveSupport::Concern
  
  def deactivated_user_with_email(email)
    User.only_deleted.where(email: email).first
  end
end
