class SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
    respond_to do |format|
      format.html { render :new }
      format.json { render json: resource }
    end
  end

  def respond_to_on_destroy
    head :no_content
  end
end