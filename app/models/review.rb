class Review < ApplicationRecord
  # Зв'язок багато до одного з користувачем
  belongs_to :user
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
