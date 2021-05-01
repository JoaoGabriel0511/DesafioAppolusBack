class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    if @user.save
      account = Account.create(user_id: @user.id)
      render json: { message: "user created", data: {user: @user, account: account} }, status: :ok
    else
      render json: { message: "user not created", errors: @user.errors}, status: :unprocessable_entity
    end
  end

  private
    def sign_up_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

end
