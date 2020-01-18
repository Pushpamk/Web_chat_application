class ApplicationController < ActionController::API
  # /app/controllers/concerns/response.rb
  include Response

  def authorize_request
    token = request.headers['Authorization']
    token = token.split(' ').last if token
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      json_response 'Unauthorized', false, {}, :unauthorized
    rescue JWT::DecodeError => e
      json_response 'Unauthorized', false, {}, :unauthorized
    end
  end
end
