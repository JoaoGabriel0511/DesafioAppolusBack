module AuthenticationHelper

  def recoverCurrentUser(request)
    token = request.headers.fetch('Authorization', '')
    payload = JsonWebToken.decode(token)
    User.find(payload['sub'])
  end

end
