class ReviewsController < ApplicationController
  before_action :require_user_logged_in!, except: [:index]

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

  def review_params
    params.require(:review).permit(:review_text, :rating)
  end
end
