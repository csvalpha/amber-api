class QuickpostStatistic
  include ActiveModel::Model

  attr_accessor :user_id, :messages_total, :messages_last_month, :messages_last_week

  def self.all
    totals = QuickpostMessage.group(:author_id).count
    last_week = QuickpostMessage.where(created_at: 1.week.ago..Time.zone.now).group(:author_id).count
    last_month = QuickpostMessage.where(created_at: 1.month.ago..Time.zone.now).group(:author_id).count

    quickpost_statistics = []
    totals.each do |user_id, total|
      statistic = QuickpostStatistic.new(
        user_id: user_id,
        messages_total: total,
        messages_last_week: last_week.has_key?(user_id) ? last_week[user_id] : 0,
        messages_last_month: last_month.has_key?(user_id) ? last_month[user_id] : 0
      )
      quickpost_statistics << statistic
    end

    quickpost_statistics
  end

  def readonly?
    true
  end

  def persisted?
    false
  end

  def order(*args)
    [self] # following order collect is called on the result so return an array with self
  end

  def count(*args)
    1 # count is called for meta
  end
end
