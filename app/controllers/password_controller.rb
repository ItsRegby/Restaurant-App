class PasswordController < ApplicationController
  before_action :require_user_logged_in!

  def edit

  end

  def update
    if Current.user.update(user_params)
      redirect_to home_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end