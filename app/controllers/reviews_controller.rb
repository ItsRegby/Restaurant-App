class ReviewsController < ApplicationController
  before_action :require_user_logged_in!, except: [:index]
  before_action :require_user_profile, only: [:create]

  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = Current.user.id

    if @review.save
      flash[:success] = 'Відгук успішно створено!'
      redirect_to reviews_path
    else
      flash.now[:alert] = 'Помилка при створенні відгуку'
      render :new
    end
  end

  private

  def require_user_profile
    unless Current.user.user_profile.present?
      redirect_to profile_edit_path, alert: "Please fill in your profile before placing an order."
    end
  end
  def review_params
    params.require(:review).permit(:review_text, :rating)
  end
end
