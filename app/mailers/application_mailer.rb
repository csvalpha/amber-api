class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.x.noreply_email
  layout 'mailer'
end
