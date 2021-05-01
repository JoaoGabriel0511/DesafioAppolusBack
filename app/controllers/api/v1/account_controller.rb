class Api::V1::AccountController < ApiController
  before_action :authenticate_user!
  before_action :set_user

  def index
    render json: { data: { user: @userAccount[:user], account: @userAccount[:account]}, message: "user #{@userAccount[:user].email} retrieved"}, status: :ok
  end

  def deposit
    value = deposit_parms[:value].to_f
    @userAccount[:account].deposit(value)
    @userAccount[:account].save
    render json: {data: {account: @userAccount[:account]}, message: "Deposit made to account"}, status: :ok
  end

  def withdraw
    value = withdraw_parms[:value].to_f
    @userAccount[:account].withdraw(value)
    if @userAccount[:account].save
      render json: {data: {account: @userAccount[:account]}, message: "Withdraw made from account"}, status: :ok
    else
      render json: {error: "User can`t withdraw a value greater than the balance"}, status: :not_acceptable
    end
  end

  private
    def set_user
      @userAccount = helpers.recoverCurrentUserAccount(request)
    end

    def deposit_parms
      params.require(:deposit).permit(:value)
    end

    def withdraw_parms
      params.require(:withdraw).permit(:value)
    end

end
