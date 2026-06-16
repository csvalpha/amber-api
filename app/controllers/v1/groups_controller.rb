# frozen_string_literal: true

class V1::GroupsController < V1::ApplicationController
  include GraphitiCrud

  before_action :doorkeeper_authorize!, except: %i[index show]
  before_action :set_model, only: %i[export]

  graphiti_resource V1::GroupResource

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
    return unless Rails.env.production? || Rails.env.staging?

    # :nocov:
    UserExportMailerJob.perform_later(
      current_user, @model, permitted_serializable_user_attributes.join(', '), description
    )
    # :nocov:
  end

  def permitted_serializable_user_attributes
    @permitted_serializable_user_attributes ||= begin
      attrs = params[:user_attrs].presence || 'id'
      attrs.split(',').map(&:to_sym)
    end
  end
end
