module Debit
  class Transaction < ApplicationRecord
    belongs_to :collection
    belongs_to :user
    belongs_to :declaration, optional: true

    validates :description, presence: true
    validates :amount, presence: true

    scope :transactions_for, ->(user) { where(user:) }
  end
end
