class Api::V1::AccountController < ApiController
  before_action :authenticate_user!

  def index
    user = helpers.recoverCurrentUser(request)
    render json: {data: user, message: "user #{user.email} retrieved"}, status: :ok
  end

end
