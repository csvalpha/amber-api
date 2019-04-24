module Import
  class SendActivateMail
    def send!
      users_to_send.find_each do |user|
        user.update(::User.activation_token_hash)
        UserMailer.account_creation_email(user).deliver_now
      end
    end

    def print_users
      result = ''
      users_to_send.find_each do |user|
        result << "#{user.full_name} <#{user.email}> \n"
      end
      result
    end

    private

    def users_to_send
      ::User.where(activated_at: nil, activation_token: nil)
    end
  end
end
