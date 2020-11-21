namespace :cleanup do
  task doorkeeper_tokens: :environment do |_task|
    options = {
      run: false
    }
    o = OptionParser.new
    o.banner = 'Usage: rake cleanup:doorkeeper_tokens -- [options]'
    o.on('-f', '--force') { options[:run] = true }
    args = o.order!(ARGV)
    o.parse!(args)

    if options[:run]
      # Source: https://github.com/doorkeeper-gem/doorkeeper/issues/500#issuecomment-257043085
      delete_before = (ENV['DOORKEEPER_DAYS_TRIM_THRESHOLD'] || 30).to_i.days.ago
      expire = [
        '(revoked_at IS NOT NULL AND revoked_at < :delete_before) OR ' \
        '(expires_in IS NOT NULL AND ' \
        "(created_at + expires_in * INTERVAL '1 second') < :delete_before)",
        { delete_before: delete_before }
      ]
      Doorkeeper::AccessGrant.where(expire).delete_all
      Doorkeeper::AccessToken.where(expire).delete_all
      puts 'Removed old access tokens'
    else
      puts 'Please specify the -f argument if you really want to remove the old doorkeeper tokens.'\
            ' This action cannot be undone.'
    end
  end
end
