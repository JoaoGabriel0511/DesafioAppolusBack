class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      render json: { token: JsonWebToken.encode(sub: user.id) }, status: :ok
    else
      render json: { errors: 'invalid email or password' }, status: :unauthorized
    end
  end

  def fetch
    render json: current_user
  end
end
