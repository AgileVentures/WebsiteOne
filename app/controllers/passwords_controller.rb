class PasswordsController < Devise::PasswordsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    respond_to do |format|
      format.html { render :new }
      format.json { render json: resource }
    end
  end
end
