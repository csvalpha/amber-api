class V1::UsersController < V1::ApplicationController # rubocop:disable Metrics/ClassLength
  include SpreadsheetHelper
  before_action :doorkeeper_authorize!, except: %i[activate_account reset_password
                                                   get_related_resource]
  before_action :set_model, only: %i[update archive activate_account
                                     resend_activation_mail generate_otp_secret
                                     activate_otp activate_webdav]

  def update
    password = params.dig('data', 'attributes', 'password')
    old_password = params.dig('data', 'attributes', 'old_password')
    if password.present? && !@model.authenticate(old_password)
      render json: old_password_invalid_error, status: :unprocessable_entity
    else
      remove_password_from_params_when_blank?
      super
    end
  end

  def archive
    authorize @model

    return head :forbidden if @model == current_user

    UserArchiveJob.perform_later(@model.id)
    head :no_content
  end

  def activate_account
    activation_token = params[:activationToken]
    unless @model.activation_token == activation_token &&
           @model.activation_token_valid_till.try(:>, Time.zone.now)
      return head :not_found
    end

    @model.activate_account!
    @model.update(password: params[:password])
    head :no_content
  end

  def resend_activation_mail
    authorize @model
    return head :not_found if @model.activated_at?

    @model.update(model_class.activation_token_hash)
    UserMailer.account_creation_email(@model).deliver_later
    head :no_content
  end

  def reset_password
    @user = User.find_by(email: params[:email])
    return head :no_content unless @user.try(:login_enabled)

    @user.update(model_class.activation_token_hash)
    UserMailer.password_reset_email(@user).deliver_later
    head :no_content
  end

  def generate_otp_secret
    authorize @model

    if @model.otp_required?
      return render json: otp_already_required_error,
                    status: :unprocessable_entity
    end

    render json: { otp_code: regenerate_otp_provisioning_uri! }
  end

  def activate_otp
    authorize @model
    unless @model.authenticate_otp(params[:one_time_password], drift: 10)
      return render json: otp_invalid_error, status: :unprocessable_entity
    end

    @model.update(otp_required: true)
    head :no_content
  end

  def activate_webdav
    authorize @model
    @model.generate_webdav_secret_key
    @model.save
    head :no_content
  end

  def nextcloud
    render json: { id: current_user.id,
                   displayName: current_user.full_name,
                   email: current_user.email,
                   groups: nextcloud_groups }
  end

  def batch_import # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    authorize model_class

    file = decode_upload_file(params['file'])
    group = Group.find_by(id: params['group'])
    live_run = params['live_run']

    import = Import::User.new(file, group)

    unless import.valid?
      return render json: { errors: import.errors }, status: :unprocessable_entity
    end

    import.save!(live_run)
    render json: { users: import.imported_users.to_json(except: excluded_display_properties),
                   errors: import.errors }
  end

  def context
    super.merge(model: @model)
  end

  private

  def excluded_display_properties
    %i[created_at updated_at deleted_at activated_at archived_at password_digest activation_token
       avatar activation_token_valid_till sidekiq_access otp_secret_key otp_required
       ical_secret_key id]
  end

  def otp_already_required_error
    {
      errors: [
        { detail: 'OTP is already required',
          source: { pointer: '/data/attributes/otp-required' } }
      ]
    }
  end

  def otp_invalid_error
    {
      errors: [
        { detail: 'Given OTP is invalid',
          source: { pointer: '/data/attributes/one-time-password' } }
      ]
    }
  end

  def old_password_invalid_error
    {
      errors: [
        { detail: 'Old password does not match current password',
          source: { pointer: '/data/attributes/password' } }
      ]
    }
  end

  def regenerate_otp_provisioning_uri!
    @model.otp_regenerate_secret
    @model.save
    @model.provisioning_uri(@model.username, issuer: 'Alpha')
  end

  def remove_password_from_params_when_blank?
    params[:data][:attributes].delete(:password) if params[:data][:attributes][:password].blank?
  end

  def nextcloud_groups
    current_user.active_groups.map { |g| { gid: g.id, displayName: g.name } }
  end
end
