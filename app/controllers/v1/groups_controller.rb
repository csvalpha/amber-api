class V1::GroupsController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[get_related_resource]
  before_action :set_model, only: %i[export]

  def export
    authorize @model
    description = params[:description]

    return head :unprocessable_entity if description.blank?

    send_export_notifications(description)
    records = User.active_users_for_group(@model)
    send_data records.to_csv(permitted_serializable_user_attributes),
              filename: "users-#{Time.zone.today}.csv"
  end

  private

  def send_export_notifications(description)
    return unless Rails.env.production?

    # :nocov:
    SlackMessageJob.perform_later(slack_notification(description))
    UserExportMailerJob.perform_later(
      current_user, @model, permitted_serializable_user_attributes.join(', '), description
    )
    # :nocov:
  end

  def permitted_serializable_user_attributes
    @permitted_serializable_user_attributes ||= begin
      attributes = V1::UserResource.new(User.new, context).fetchable_fields
      attrs = params[:user_attrs].presence || 'id'
      attributes & attrs.split(',').map(&:to_sym)
    end
  end

  def slack_notification(description)
    "User ##{current_user.id} (#{current_user.full_name}) "\
      "is exporting users for group #{@model.id} from host #{request.host} with #"\
      "#{permitted_serializable_user_attributes.join(',')}. De gebruiker gaf als "\
      "reden: #{description}"
  end
end
