class Api::V1::UsersController < ApiController

  before_action :authenticate_user!
  before_action :set_user

  def update
    if @user.update(user_params)
      render json: { message: "user updated", data: @user }, status: :ok
    else
      render json: { message: "user not updated", errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: {message: "user deleted", data: @user}, status: :ok
  end

  private

    def set_user
      @user = helpers.recoverCurrentUser(request)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
