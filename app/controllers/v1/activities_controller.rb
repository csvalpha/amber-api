require 'icalendar/tzinfo'

class V1::ActivitiesController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index upcoming show ical]
  before_action :set_model, only: %i[mail_enrolled]

  def mail_enrolled
    authorize @model
    message = params.dig('data', 'attributes', 'message')

    return render json: no_form_error, status: :unprocessable_entity unless @model.form

    unless message.try(:present?)
      return render json: no_message_present_error, status: :unprocessable_entity
    end

    ActivityMailerJob.perform_later(current_user, @model, message)
    head :no_content
  end

  def ical # rubocop:disable Metrics/AbcSize
    return head :unauthorized unless authenticate_user_by_ical_secret_key

    permitted_categories = params[:categories].try(:split, ',') & Activity.categories ||
                           Activity.categories
    activities_for_ical(permitted_categories).map do |act|
      calendar.add_event(act.to_ical)
    end
    render plain: calendar.to_ical, content_type: 'text/calendar'
  end

  private

  def no_message_present_error
    {
      errors: [
        { detail: 'Message is not present',
          source: { pointer: '/data/attributes/message' } }
      ]
    }
  end

  def no_form_error
    {
      errors: [
        { detail: 'Form is nil',
          source: { pointer: '/data/attributes/form_id' } }
      ]
    }
  end

  def calendar
    @calendar ||= begin
      calendar = Icalendar::Calendar.new
      tz = TZInfo::Timezone.get(Rails.application.config.time_zone)
      timezone = tz.ical_timezone(Time.zone.now)
      calendar.add_timezone(timezone)
      calendar.x_wr_calname = 'Alpha'
      calendar
    end
  end

  def activities_for_ical(categories)
    Activity.where(category: categories)
            .where(start_time: (3.months.ago..1.year.from_now))
  end

  def authenticate_user_by_ical_secret_key
    user = User.activated.login_enabled.find_by(id: params[:user_id], ical_secret_key: params[:key])
    return false unless user

    user.permission?(:read, Activity)
  end
end
