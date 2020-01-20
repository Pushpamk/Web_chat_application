class Api::V1::UsersController < ApplicationController
  # before_action :authorize_request, except: :create
  before_action :find_user, except: [:create, :email_confirmation]
  before_action :check_blacklisted_jwt, except: [:create , :email_confirmation]# only: [:update, :show]
  before_action :auth_token_params, only: :email_confirmation

  # GET /users/:id
  def show
    json_response_raw @user, :ok
  end

  # logout GET /users/:id
  def logout
    blacklistjwt = BlacklistJwt.new(token: @token)
    if blacklistjwt.save
      json_response 'Logout successfully', true, {}, :ok
    else
      json_err_response 'Something Went Wrong', :internal_server_error
    end
  end

  # POST /users/
  def create
    @user = User.new(user_params)
    if @user.save
      # send mail to user
      # UserNotifierMailer.send_signup_email(@user).deliver
      json_response 'User successfully signed up', true, @user, :ok
    else
      json_err_response 'Something Went Wrong', :unprocessable_entity
    end
  end

  # PUT /users/:id
  def update
    if @user.update(user_params)
      json_response_raw 'Successful', :ok
    else
      json_err_response 'Something Went Wrong', :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    blacklistjwt = BlacklistJwt.new(token: @token)
    if blacklistjwt.save
      if @user.destroy
        json_response_raw 'Successful', :ok
      else
        json_err_response 'Something Went Wrong', :unprocessable_entity
      end
    end
  end

  # Email Confirmation
  #def email_confirmation
  #  @user = User.find_by_auth_token(auth_token_params)
  #  if @user
  #    @user.confirmed  = true
  #    if @user.save
  #      json_response 'Successful Confirmation', true,{}, :ok
  #      redirect_to '/api/v1/auth/login'
  #    else
  #      json_err_response 'Something Went Wrong', :internal_server_error
  #    end
  #  else
  #    json_err_response 'Invalid Link', :unprocessable_entity
  #  end
  #end
  def email_confirmation
    @user = User.find_by_auth_token(params[:auth_token])
    if @user.confirmed == true
      json_err_response 'Invalid Link', :unprocessable_entity
    else
      if @user
        if @user.update_column(:confirmed, true)
          json_response 'Successfully Confirmed', true, {}, :ok
        else
          json_err_response 'Something Went Wrong', :internal_server_error
        end
      else
        json_err_response 'Invalid Link', :unprocessable_entity
      end
    end
  end


  private

  def find_user
    token = request.headers['Authorization']
    # Passing token to destroy method to blacklist this token until it gets expired
    @token = token.split(' ').last
    token = @token if token
    begin
      @decoded = JsonWebToken.decode(token)
      @decoded_user = User.find(@decoded[:user_id])
      if @decoded_user.id == params[:id] # check decoded user id is same as in url users/id
        @user = @decoded_user
      else
        json_response 'Unauthorized', false, {}, :unauthorized
      end
    rescue ActiveRecord::RecordNotFound => e
      json_response 'Unauthorized', false, {}, :unauthorized
    rescue JWT::DecodeError => e
      json_response 'Unauthorized', false, {}, :unauthorized
    end
  end

  def user_params
    # add require
    params.permit(
        :email, :password#, :confirmation_password
    )
  end

  def check_blacklisted_jwt
    token = request.headers['Authorization']
    token = token.split(' ').last
    if BlacklistJwt.find_by_token(token)
      json_err_response 'Invalid Token', :unprocessable_entity
    end
  end

  def auth_token_params
    params.permit(
        :auth_token
    )
  end
end
