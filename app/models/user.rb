class User < ApplicationRecord

  has_secure_password

  before_create :generate_user_id

  def admin?
    role == 'admin'
  end


  private

  def generate_user_id
    self.user_id = SecureRandom.hex(10)
  end

  # Зв'язок один до одного з профілем користувача
  has_one :user_profile, dependent: :destroy

  # Зв'язок один до багатьох з відгуками
  has_many :reviews, dependent: :destroy
  has_many :orders
  has_many :table_reservations, class_name: 'TableReservations'

  # Перевірка наявності емейлу і ролі
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "must be a valid email address." }
  validates :role, presence: true
end
