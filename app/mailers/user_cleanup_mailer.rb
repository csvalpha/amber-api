class UserCleanupMailer < ApplicationMailer
  def cleanup_email(will_remove_users, removed_users)
    @will_remove_users = will_remove_users
    @removed_users = removed_users
    subject = '[Belangrijk!] Er gaan gebruikers worden verwijderd van de website'
    subject = 'Er zijn gebruikers verwijderd!' if @will_remove_users.empty?

    mail to: 'ict@csvalpha.nl;bestuur@csvalpha.nl', subject: subject
  end
end
