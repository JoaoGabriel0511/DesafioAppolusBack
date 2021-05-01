class Api::V1::UsersController < ApiController

  before_action :authenticate_user!
  before_action :set_user

  def update
    if @userAccount[:user].update(user_params)
      render json: { message: "user updated", data: {user: @userAccount[:user]} }, status: :ok
    else
      render json: { message: "user not updated", errors: @userAccount[:user].errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @userAccount[:user].destroy
    render json: {message: "user deleted", data: {user: @userAccount[:user], account: @userAccount[:account]}}, status: :ok
  end

  private

    def set_user
      @userAccount = helpers.recoverCurrentUserAccount(request)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
