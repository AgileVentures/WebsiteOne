module UserNullable 
  def user 
    super || NullUser.new('Anonymous')
  end
end
