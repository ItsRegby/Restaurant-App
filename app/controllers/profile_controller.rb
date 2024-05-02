class ProfileController < ApplicationController
  before_action :require_user_logged_in!

  def edit
    @profile = UserProfile.find_or_initialize_by(user_id: Current.user.id)
  end

  def update
    @profile = UserProfile.find_or_initialize_by(user_id: Current.user.id)
    if @profile.update(profile_params)
      redirect_to home_path, notice: "Profile updated successfully"
    else
      render :edit
    end
  end

  def create
    @profile = UserProfile.new(profile_params)
    @profile.user_id = Current.user.id
    if @profile.save
      redirect_to home_path, notice: "Profile created successfully"
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(:full_name, :address, :phone_number)
  end
end