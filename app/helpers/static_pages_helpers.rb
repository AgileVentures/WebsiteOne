module StaticPagesHelper
  
  def user_can_edit?
    current_user && current_user.is_privileged? || current_user.membership_type != 'Basic' 
  end
  
end 