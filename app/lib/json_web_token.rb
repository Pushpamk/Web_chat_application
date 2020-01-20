# encoding and decoding of json web token
class JsonWebToken
  # secret key to encode and decode json web token
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  # creating jwt token (encoding)
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # decoding jwt token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end