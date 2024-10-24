class QuickpostMessage < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :message, presence: true, length: { minimum: 1, maximum: 500 }

  after_create :publish_to_message_bus

  private

  def publish_to_message_bus
    attributes = { id: id, author_id: author.id, message: message, created_at: created_at }
    MessageBus.publish('/quickpost_messages', attributes.to_json, group_ids: [0])
  end
end
