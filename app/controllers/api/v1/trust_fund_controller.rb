class Api::V1::TrustFundController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, except: :index

  def index
    trust_funds = TrustFund.all
    render json: {data: {trust_funds: trust_funds}, message: "trust funds recovered"}, status: :ok
  end

  def create
    trust_fund = TrustFund.new(trust_fund_params)
    trust_fund.user = @userAccount[:user]
    if trust_fund.save!
      render json: {data: {trust_fund: trust_fund}, message: "trust fund created"}, status: :ok
    else
      render json: {errors: trust_fund.errors}, status: :unprocessable_entity
    end
  end

  def invest_value
    investment = Investment.find_or_initialize_by(trust_fund_id: params[:investment][:trust_fund_id], account: @userAccount[:account])
    if investment.save
      @userAccount[:account].withdraw(params[:investment][:value].to_f)
      investment.deposit(params[:investment][:value].to_f)
      if @userAccount[:account].save
        investment.save
        transaction = Transaction.create!(transaction_type: Transaction.transaction_types[:INVEST], value: params[:investment][:value].to_f, balance: @userAccount[:account].balance, account_id: @userAccount[:account].id, trust_fund_id: params[:investment][:trust_fund_id])
        render json: {data:{ user: @userAccount[:user], account: @userAccount[:account], investment: investment, transaction: transaction }, message: "value invested"}, status: :ok
      else
        render json: {errors: {value: ["Cant invest greater the user account balance"]}}, status: :unprocessable_entity
      end
    else
      render json: {errors: investment.errors}, status: :unprocessable_entity
    end
  end

  def withdraw_value
      investment = Investment.find_by(trust_fund_id: params[:investment][:trust_fund_id], account_id: @userAccount[:account].id)
      @userAccount[:account].deposit(params[:investment][:value].to_f)
      investment.withdraw(params[:investment][:value].to_f)
      if investment.save
        @userAccount[:account].save
        transaction = Transaction.create!(transaction_type: Transaction.transaction_types[:INVEST_WITHDRAWN], value: params[:investment][:value].to_f, balance: @userAccount[:account].balance, account_id: @userAccount[:account].id, trust_fund_id: params[:investment][:trust_fund_id])
        render json: {data: {user: @userAccount[:user], account: @userAccount[:account], investment: investment, transaction: transaction }, message: "value withdrawn"}, status: :ok
      else
        render json: {errors: {value: ["Cant withdraw a value greater then the investment value"]}}, status: :unprocessable_entity
      end
  end

  private
    def trust_fund_params
      params.require(:trust_fund).permit(:name, :fund_type)
    end

    def investment_params
      params.require(:investment).permit(:value, :trust_fund_id)
    end

    def set_user
      @userAccount = helpers.recoverCurrentUserAccount(request)
    end

end
