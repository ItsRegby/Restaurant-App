class UserProfile < ApplicationRecord
  # Зв'язок один до одного з користувачем
  belongs_to :user

  # Перевірка наявності повного імені
  validates :phone_number, presence: true
  validates :address, presence: true
end

