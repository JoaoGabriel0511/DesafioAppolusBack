Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: 'registrations' }
  namespace :api do
    namespace :v1 do
      post :auth, to: 'authentication#create'
      resource :user, only: [:update, :destroy]
      get  '/auth' => 'authentication#fetch'
      get '/account' => 'account#index'
      post '/account/deposit' => 'account#deposit'
      post '/account/withdraw' => 'account#withdraw'
      get 'account/statement' => 'account#account_statement'
      get '/trust_funds' => 'trust_fund#index'
      post '/trust_fund' => 'trust_fund#create'
      post '/trust_fund/invest' => 'trust_fund#invest_value'
      post '/trust_fund/withdraw' => 'trust_fund#withdraw_value'
      get '/account/investments' => 'account#account_investments'
      get '/account/investment/:trust_fund_id' => 'account#account_investment'
    end
  end
end
