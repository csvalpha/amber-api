class UserArchiveJob < ApplicationJob
  queue_as :default
  ARCHIVE_USER_ID = 0

  def perform(user_id)
    create_global_archive_user
    user = User.find(user_id)

    migrate_keep_entities(user)
    user.really_destroy!
  end

  private

  def create_global_archive_user
    return if User.exists?(ARCHIVE_USER_ID)

    User.create!(id: ARCHIVE_USER_ID,
                 username: 'archived.user',
                 email: 'ict@csvalpha.nl',
                 first_name: 'Gearchiveerde Gebruiker',
                 last_name: '-',
                 address: 'Onbekend',
                 postcode: 'Onbekend',
                 city: 'Onbekend')
  end

  def migrate_keep_entities(user)
    keep_entities.each do |entity|
      key = entity_key(entity)
      records = entity.where({ key => user })

      records.each { |r| r.update({ key => global_archive_user }) && r.versions.destroy_all }
    end
  end

  def global_archive_user
    User.find(ARCHIVE_USER_ID)
  end

  def keep_entities # rubocop:disable Metrics/MethodLength
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
     Forum::Thread,
     Debit::Collection]
  end

  def entity_key(entity)
    return 'author' if entity.has_attribute?('author_id')
    return 'uploader' if entity.has_attribute?('uploader_id')

    'user'
  end
end
