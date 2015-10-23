class DeviseApiController < ActionController::Base

  def create
    with_auth do
      user = User.create email: params[:email]
      user.send_reset_password_instructions
      respond_to do |format|
        format.json { render json: user.id, layout: false }
      end
    end
  end

  def update
    with_auth do
      user = User.find(params[:id])
      user.email = params[:email]
      user.save
      respond_to do |format|
        format.json { render json: true, layout: false }
      end
    end
  end

  def destroy
    with_auth do
      User.destroy(params[:id])
      respond_to do |format|
        format.json { render json: true, layout: false }
      end
    end
  end

  private

  def with_auth
    if ENV['DEVISE_API_SECRET'] == params[:devise_api_secret]
      yield
    else
      respond_to do |format|
        format.json { render json: {message: 'unauthorized access', code: 403}, layout: false }
      end
    end
  end
end
