class Api::V1::AccountController < ApiController
  before_action :authenticate_user!

  def index
    userAccount = helpers.recoverCurrentUserAccount(request)
    render json: { data: { user: userAccount[:user], account: userAccount[:account]}, message: "user #{userAccount[:user].email} retrieved"}, status: :ok
  end

end
