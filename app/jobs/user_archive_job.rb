class UserArchiveJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    migrate_keep_entities(user)
    user.really_destroy!
  end

  def migrate_keep_entities(user)
    keep_entities.each do |entity|
      key = entity_key(entity)
      records = entity.where({key => user})

      records.each {|r| r.update({key => global_archive_user})}
      records.each {|r| r.versions.destroy_all}
    end
  end

  private

  def global_archive_user
    User.find(0)
  end

  def keep_entities
    [ArticleComment,
    PhotoComment,
    Article,
    Activity,
    Photo,
    PhotoAlbum,
    Poll,
    QuickpostMessage,
    Form::Form,
    Form::Response,
    Forum::Post,
    Forum::Thread
    ]
  end

  def entity_key(entity)
    return 'author' if entity.has_attribute?('author_id')
    return 'uploader' if entity.has_attribute?('uploader_id')

    'user'
  end

end
