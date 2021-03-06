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
    transaction = Transaction.create(transaction_type: Transaction.transaction_types[:DEPOSIT], account_id: @userAccount[:account].id, value: value, balance: @userAccount[:account].balance)
    render json: {data: {account: @userAccount[:account], transaction: transaction}, message: "Deposit made to account"}, status: :ok
  end

  def withdraw
    value = withdraw_parms[:value].to_f
    @userAccount[:account].withdraw(value)
    if @userAccount[:account].save
      transaction = Transaction.create(transaction_type: Transaction.transaction_types[:WITHDRAW], account_id: @userAccount[:account].id, value: value, balance: @userAccount[:account].balance)
      render json: {data: {account: @userAccount[:account], transaction: transaction}, message: "Withdraw made from account"}, status: :ok
    else
      render json: {error: "User can`t withdraw a value greater than the balance"}, status: :not_acceptable
    end
  end

  def account_statement
    account_statement = Transaction.where(account_id: @userAccount[:account].id).order('transactions.created_at')
    account_statement = account_statement.map do |trasaction|
      if trasaction.trust_fund_id
        {statement: trasaction, trust_fund: TrustFund.find(trasaction.trust_fund_id).name}
      else
        {statement: trasaction, trust_fund: "-"}
      end
    end
    render json: {data: {account_statement: account_statement}, message: "Account statement recovered"}, status: :ok
  end

  def account_investments
    investments = Investment.where(account_id: @userAccount[:account].id)
    render json: {data: {account: @userAccount[:account], investments: investments.map{|i| {investment: i, trust_fund: i.trust_fund}} }}, status: :ok
  end

  def account_investment
    investment = Investment.find_by(account_id: @userAccount[:account].id, trust_fund_id: params[:trust_fund_id])
    render json: {data: {investment: investment}}, status: :ok
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
