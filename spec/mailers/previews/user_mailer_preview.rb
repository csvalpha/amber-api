# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def account_creation
    user = User.first
    UserMailer.account_creation_email(user)
  end

  def password_reset
    user = User.first
    UserMailer.password_reset_email(user)
  end
end
