class ActivityMailer < ApplicationMailer
  def enrolled_email(user, activity, message)
    @user = user
    @message = message
    @activity = activity
    mail to: user.email, subject: "[Activiteit] Informatiemail over #{activity.title}"
  end
end
