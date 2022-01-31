module Debit
  class Transaction < ApplicationRecord
    belongs_to :collection
    belongs_to :user

    validates :description, presence: true
    validates :amount, presence: true

    scope :transactions_for, (->(user) { where(user: user) })
  end
end
