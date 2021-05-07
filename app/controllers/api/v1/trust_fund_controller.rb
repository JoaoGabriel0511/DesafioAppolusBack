class Api::V1::TrustFundController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: :create

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

  private
    def trust_fund_params
      params.require(:trust_fund).permit(:name, :fund_type)
    end

    def set_user
      @userAccount = helpers.recoverCurrentUserAccount(request)
    end

end
