module Form
  class Form < ApplicationRecord
    belongs_to :author, class_name: 'User', optional: true
    belongs_to :group, optional: true

    has_many :responses, dependent: :destroy
    has_many :open_questions, dependent: :destroy
    has_many :closed_questions, dependent: :destroy

    validates :respond_from, presence: true
    validates :respond_until, presence: true
    validates_datetime :respond_from
    validates_datetime :respond_until, after: :respond_from

    def owners
      if group.present?
        group.active_users + [author]
      else
        [author]
      end
    end

    def allows_responses?
      (respond_from..respond_until).cover?(Time.zone.now)
    end
  end
end
