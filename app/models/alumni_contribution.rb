class AlumniContribution < ApplicationRecord
  belongs_to :user

  validates :user, uniqueness: true
  validates :sponsoring_amount, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :help_digtus, inclusion: [true, false]
  validates :help_kring, inclusion: [true, false]
  validates :help_vereniging, inclusion: [true, false]
  validates :help_anders, length: { maximum: 1000, allow_nil: true }
end
