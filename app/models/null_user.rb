# frozen_string_literal: true

class NullUser < User
  def persisted?
    false
  end

  def initialize(name)
    super({ id: -1, first_name: name, created_at: Time.now })
  end

  def presenter
    UserPresenter.new(self)
  end

  def gravatar_image
    super.gravatar_image({ default: true })
  end
end
