class TableReservations < ApplicationRecord
  belongs_to :user

  validates :reservation_date, presence: true
  validate :reservation_date_cannot_be_in_the_past

  private

  def reservation_date_cannot_be_in_the_past
    if reservation_date.present? && reservation_date < Time.now
      errors.add(:reservation_date, "can't be in the past")
    end
  end
end