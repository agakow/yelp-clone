class Review < ApplicationRecord

  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant aleady" }

  belongs_to :user
  belongs_to :restaurant

end
