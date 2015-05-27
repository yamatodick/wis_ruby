class PasswordResetsController < ApplicationController
 	before_action :get_user, only: [:edit, :update]
 	#before_action :valid_user, only: [:edit, :update]
 	before_action :check_expiration, only: [:edit, :update]
  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "Email sent with password reset instructions"
  		redirect_to root_url
  	end
  end

  def new
  end

  def edit
  end

  def update
  	if both_passwords_blank?
  		flash.now[:danger] = "Password/confirmation can't be blank"
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user
  		flash[:success] = "Password has been reset."
  		redirect_to @user

  	end 
  end

  def user_params
  	params.require(:user).permit(:password, :pasword_confirmation)
  end

  def both_passwords_blank?
  	params[:user][:password].blank? &&
  	params[:user][:pasword_confirmation].blank?
  end

  def check_expiration
  	if @user.password_reset_expired?
  		flash[:danger] = "Password reset has expired"
  		redirect_to new_password_reset_url
  	end
  end

  def get_user
  	@user = User.find_by(email: params[:email])
  end

  def valid_user
  	unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
  		redirect_to root_url
  	end
  end
end
