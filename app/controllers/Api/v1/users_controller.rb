class Api::V1::UsersController < ApplicationController
  # before_action :authorize_request, except: :create
  before_action :find_user, except: :create

  # GET /users/:id
  def show
    json_response_raw @user, :ok
  end

  # POST /users/
  def create
    @user = User.new(user_params)
    if @user.save
      # send mail to user
      UserNotifierMailer.send_signup_email(@user).deliver
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
    if @user.destroy
      json_response_raw 'Successful', :ok
    else
      json_err_response 'Something Went Wrong', :unprocessable_entity
    end
  end


  private

  def find_user
    token = request.headers['Authorization']
    token = token.split(' ').last if token
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
        :email, :password, :password_confirmation
    )
  end
end
