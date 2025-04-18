class Activity < ApplicationRecord
  mount_base64_uploader :cover_photo, CoverPhotoUploader
  has_paper_trail skip: [:cover_photo]

  belongs_to :form, class_name: 'Form::Form', optional: true
  has_many :responses, through: :form, class_name: 'Form::Response'
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  validates :category, presence: true, inclusion: { in: ->(_) { Activity.categories } }
  validates :description, presence: true
  validates :form, uniqueness: true, allow_nil: true
  validates :location, presence: true
  validates :price, inclusion: { in: 0..1000 }
  validates :price, presence: true
  validates :publicly_visible, inclusion: [true, false]
  validates :start_time, presence: true
  validates :title, presence: true
  validates_datetime :end_time, after: :start_time
  validate :small_changes_allowed_on_present_responses
  validate :removing_form_not_allowed_on_present_responses

  scope :upcoming, lambda {
    where('(start_time < ? and end_time > ?) or start_time > ?', Time.zone.now,
          Time.zone.now, Time.zone.now)
  }
  scope :publicly_visible, -> { where(publicly_visible: true) }
  scope :closing, lambda { |days_ahead = 7|
    now = DateTime.current
    ahead = days_ahead.days.from_now.to_datetime
    joins(:form).where(form_forms: { respond_until: now..ahead })
  }

  after_save :copy_author_and_group_to_form!

  def self.categories
    %w[algemeen societeit vorming kring
       choose ifes ozon disputen kiemgroepen huizen extern eerstejaars curiositates]
  end

  def full_day?
    start_time == start_time.midnight && end_time == end_time.midnight
  end

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end

  def humanized_category
    case category
    when 'choose'
      'ChOOSE'
    when 'ozon', 'ifes'
      category.upcase
    when 'societeit'
      'Sociëteit'
    else
      category.capitalize
    end
  end

  def to_ical # rubocop:disable Metrics/AbcSize
    default_options = Rails.application.config.action_mailer.default_url_options
    activity_url = URI::Generic.build(default_options.merge(path: "/activities/#{id}"))

    event = Icalendar::Event.new
    event.dtstart     = full_day? ? Icalendar::Values::Date.new(start_time) : start_time
    event.dtend       = full_day? ? Icalendar::Values::Date.new(end_time) : end_time
    event.summary     = "#{title} (#{humanized_category})"
    event.description = "#{description}\n#{activity_url}\n\nLaatst bijgewerkt: #{Time.zone.now}"
    event.location    = location
    event
  end

  private

  def copy_author_and_group_to_form!
    return unless form

    form.update(author:, group:)
  end

  def small_changes_allowed_on_present_responses
    return if !changed? || responses.empty? ||
              changes.keys.to_set(&:to_sym) <= always_changable_fields.to_set

    errors.add(:form, 'has any responses')
  end

  def removing_form_not_allowed_on_present_responses
    errors.add(:form, 'has any responses') if form_id_changed? && form_id_was.present? &&
                                              Form::Form.find(form_id_was).responses.present?
  end

  def always_changable_fields
    %i[location start_time end_time cover_photo description
       category title group_id publicly_visible]
  end
end
