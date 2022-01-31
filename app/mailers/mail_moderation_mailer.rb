class MailModerationMailer < ApplicationMailer
  def request_for_moderation_email(moderator, stored_mail)
    @user = moderator
    @sender = stored_mail.sender
    @mail_alias = stored_mail.mail_alias
    @moderator = stored_mail.mail_alias.moderator_group.name
    @subject = stored_mail.subject
    @received_at = stored_mail.received_at
    @header_text = 'Moderatieverzoek'
    @call_to_action = { text: 'Klik hier om te modereren', url: to_moderation_url(stored_mail) }

    mail to: @user.email, subject: "Moderatieverzoek: #{@subject}"
  end

  def awaiting_moderation_email(sender, stored_mail)
    @user = Struct(:full_name, :email).new(sender, sender)
    @mail_alias = stored_mail.mail_alias
    @subject = stored_mail.subject
    @received_at = stored_mail.received_at
    @moderator = stored_mail.mail_alias.moderator_group.name

    mail to: @user.email, subject: "Moderatieverzoek in behandeling: #{@subject}"
  end

  def accept_email(sender, stored_mail, approver)
    @user = Struct.new(:full_name, :email).new(sender, sender)
    @mail_alias = stored_mail.mail_alias
    @subject = stored_mail.subject
    @approver = approver

    mail to: @user.email, subject: "Mail goedgekeurd: #{@subject}"
  end

  def reject_email(sender, stored_mail, approver)
    @user = Struct.new(:full_name, :email).new(sender, sender)
    @mail_alias = stored_mail.mail_alias
    @subject = stored_mail.subject
    @approver = approver

    mail to: @user.email, subject: "Mail afgekeurd: #{@subject}"
  end

  def reminder_for_moderation_email(moderator, stored_mail)
    @user = moderator
    @sender = stored_mail.sender
    @mail_alias = stored_mail.mail_alias
    @moderator = stored_mail.mail_alias.moderator_group.name
    @subject = stored_mail.subject
    @received_at = stored_mail.received_at
    @header_text = 'Herinnering moderatieverzoek'
    @call_to_action = { text: 'Klik hier om te modereren', url: to_moderation_url(stored_mail) }

    mail to: @user.email, subject: "Herinnering moderatieverzoek: #{@subject}"
  end

  private

  def to_moderation_url(stored_mail)
    default_options = Rails.application.config.action_mailer.default_url_options
    path = "/mail-moderations/#{stored_mail.id}"
    URI::Generic.build(default_options.merge(path: path)).to_s
  end
end
