class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :review_owner, only: [:edit, :update, :destroy]

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        if user_signed_in?
          redirect_to restaurants_path, alert: "You have already left a review for this restaurant"
        else
          redirect_to new_user_session_path, alert: "Please sign in"
        end
      else
        render :new
      end
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to restaurants_path
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = 'Review deleted successfully'
    redirect_to restaurants_path
  end

  private

  def review_owner
    @review = Review.find(params[:id])
    unless @review.user_id == current_user.id
      flash[:notice] = 'You did not create this review'
      redirect_to restaurants_path
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
