class Api::V1::AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  #POST /api/v1/auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user &.authenticate(params[:password])
      token = JsonWebToken.encode({user_id: @user.id, user_email: @user.email})
      time = Time.now + 24.hours.to_i
      json_response 'Successful Sign In',
                    true,
                    {
                          token: token,
                          exp: time.strftime("%m-%d-%Y %H:%M"),
                          uuid: @user.id
                        },
                    :ok
    else
      json_err_response'Unauthorized', :unauthorized
    end
  end

  private
  def login_params
    params.permit(email, password)
  end
end
