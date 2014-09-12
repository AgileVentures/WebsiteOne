class NullUser < User

  def persisted?
    false 
  end

  def initialize(name)
    super({ first_name: name, created_at: Time.now })
  end

  def presenter
    UserPresenter.new(self)
  end

  def gravatar_image
    super.gravatar_image({ default: true })
  end

end
