class Order < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  validates :user_id, presence: true
  validates :added_items_data, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true



  attribute :added_items_data, :jsonb
end