class SoftDeleteCleanupJob < ApplicationJob
  queue_as :default

  def perform
    models.each do |model|
      next unless model.respond_to?(:only_deleted)
      next unless model.table_name

      records = model.only_deleted.where('deleted_at < ?', 2.years.ago)
      records.map(&:really_destroy!)
    end
  end

  private

  def models
    ActiveRecord::Base.descendants
  end
end
