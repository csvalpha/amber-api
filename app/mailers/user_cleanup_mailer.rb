class UserCleanupMailer < ApplicationMailer
  def cleanup_email(will_archive_users, archived_users)
    @will_archive_users = will_archive_users
    @archived_users = archived_users
    subject = "[Belangrijk!] #{@will_archive_users.count} Alpha accounts"\
              ' staan op het punt gearchiveerd te worden'
    subject = 'Er zijn gebruikers gearchiveerd!' if @will_archive_users.empty?

    mail to: 'ict@csvalpha.nl;bestuur@csvalpha.nl', subject: subject
  end
end
