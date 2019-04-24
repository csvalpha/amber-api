class FakeMail < MailgunFetcher::Mail
  def json_response
    {}
  end
end
