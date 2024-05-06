class TableReservations < ApplicationRecord
  validates :table_id, :reservation_date, presence: true
end