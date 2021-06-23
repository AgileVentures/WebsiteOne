# frozen_string_literal: true

module UserNullable
  def user
    super || NullUser.new('Anonymous')
  end
end
