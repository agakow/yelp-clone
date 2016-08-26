class EndorsementsController < ApplicationController

  before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    @review.endorsements.create
    redirect_to restaurants_path
  end

end
