class DeviseApiController < ActionController::Base

  def create
    ensure_auth
    user = User.create email: params[:email]
    user.send_reset_password_instructions
    respond_to do |format|
      format.json { render json: user.id, layout: false }
    end
  end

  def update
    ensure_auth
    user = User.find(params[:id])
    user.email = params[:email]
    user.save
    respond_to do |format|
      format.json { render json: true, layout: false }
    end
  end

  def destroy
    ensure_auth
    User.destroy(params[:id])
    respond_to do |format|
      format.json { render json: true, layout: false }
    end
  end

  private

  def ensure_auth
    # TODO
  end
end
