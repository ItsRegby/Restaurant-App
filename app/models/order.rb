class Order < ApplicationRecord
  # Зв'язок багато до одного з користувачем (клієнтом)
  belongs_to :customer, class_name: 'User'

  # Зв'язок один до багатьох з деталями замовлення
  belongs_to :order_detail, dependent: :destroy

  # Перевірка наявності клієнта
  validates :customer_id, presence: true
end