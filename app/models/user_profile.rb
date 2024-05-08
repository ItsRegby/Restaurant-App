class UserProfile < ApplicationRecord
  # Зв'язок один до одного з користувачем
  belongs_to :user

  validates :full_name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
end

