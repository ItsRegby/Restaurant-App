class Category < ApplicationRecord
  # Зв'язок один до багатьох з пунктами меню
  has_many :menu_items, class_name: 'Menu', dependent: :destroy

  attr_accessor :image_base64

  # Перевірка наявності назви категорії
  validates :category_name, presence: true
end
