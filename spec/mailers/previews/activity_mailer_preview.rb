# Preview all emails at http://localhost:3000/rails/mailers/activity_mailer
class ActivityMailerPreview < ActionMailer::Preview
  def enrolled_email
    user = User.first
    activity = Activity.first
    message = Faker::Hipster.paragraph
    ActivityMailer.enrolled_email(user, activity, message)
  end
end
