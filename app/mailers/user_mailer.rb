class UserMailer < ApplicationMailer
  def account_creation_email(user)
    @user = user
    @header_text = 'Welkom op de C.S.V. Alpha webstek!'
    @call_to_action = { text: 'Klik hier om je account te activeren!', url: @user.activation_url }
    mail to: user.email, subject: "Accountactivatie voor #{user.username}"
  end

  def password_reset_email(user)
    @user = user
    @call_to_action = { text: 'Wachtwoord herstellen!', url: @user.activation_url }
    mail to: user.email, subject: "Wachtwoordherstel voor #{user.username}"
  end
end
