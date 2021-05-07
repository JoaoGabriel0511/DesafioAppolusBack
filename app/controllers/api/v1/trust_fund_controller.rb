class TrustFundController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: :create

  def index
    trust_funds = TrustFund.all
    render json: {message: "trust funds recovered", trust_funds: trust_funds}, status: :ok
  end

  def create
    trust_fund = TrustFund.new(trust_fund_params)
    trust_fund.user = @userAccount[:user]
    if trust_fund.save!
      render json: {message: "trust fund created", trust_fund: trust_fund}, status: :ok
    else
      render json: {errors: trust_fund.errors}, status: :unprocessable_entity
    end
  end

  private
    def trust_fund_params
      params.require(:trust_fund).permit(:name, :fund_type, :fund_value)
    end

    def set_user
      @userAccount = helpers.recoverCurrentUserAccount()
    end

end
