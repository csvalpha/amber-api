class DeclarationMailer < ApplicationMailer
  def approved_email(declaration)
    @user = declaration.user
    @declaration = declaration
    @call_to_action = { text: 'Bekijk je declaratie', url: declaration_url(declaration) }

    mail to: @user.email, subject: "Declaratie goedgekeurd: #{declaration.description}"
  end

  def rejected_email(declaration)
    @user = declaration.user
    @declaration = declaration
    @call_to_action = { text: 'Bekijk je declaratie', url: declaration_url(declaration) }

    mail to: @user.email, subject: "Declaratie afgekeurd: #{declaration.description}"
  end

  # The declaration itself is already (soft) deleted, so its values are passed instead
  def deleted_email(user, description, amount, deleted_by)
    @user = user
    @description = description
    @amount = amount
    @deleted_by = deleted_by

    mail to: @user.email, subject: "Declaratie verwijderd: #{description}"
  end

  private

  def declaration_url(declaration)
    default_options = Rails.application.config.action_mailer.default_url_options
    URI::Generic.build(default_options.merge(path: "/declarations/#{declaration.id}")).to_s
  end
end
