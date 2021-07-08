require 'icalendar/tzinfo'

class V1::ActivitiesController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index upcoming show ical]
  before_action :set_model, only: %i[generate_alias]

  def generate_alias
    authorize @model

    return render json: no_form_error, status: :unprocessable_entity unless @model.form

    mail_alias = SecureRandom.hex(4)
    forward_to = @model.form.responses.map { |r| r.user.email }

    MailAliasCreateJob.perform_later(mail_alias, forward_to, 'csvalpha.nl')
    MailAliasDestroyJob.set(wait: 24.hours).perform_later(mail_alias, 'csvalpha.nl')

    render json: alias_response("#{mail_alias}@csvalpha.nl")
  end

  def ical
    return head :unauthorized unless authenticate_user_by_ical_secret_key

    permitted_categories = params[:categories].try(:split, ',') & Activity.categories ||
                           Activity.categories
    activities_for_ical(permitted_categories).map do |act|
      calendar.add_event(act.to_ical)
    end
    render plain: calendar.to_ical, content_type: 'text/calendar'
  end

  private

  def no_form_error
    {
      errors: [
        { detail: 'Form is nil',
          source: { pointer: '/data/attributes/form_id' } }
      ]
    }
  end

  def alias_response(mail_alias)
    {
      data: {
        alias: mail_alias,
        expires_at: 24.hours.from_now
      }
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
