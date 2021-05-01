module AuthenticationHelper

  def recoverCurrentUserAccount(request)
    token = request.headers.fetch('Authorization', '')
    payload = JsonWebToken.decode(token)
    user = User.find(payload['sub'])
    account = Account.find_by(user_id: user.id)
    return { user: user, account: account}
  end

end
