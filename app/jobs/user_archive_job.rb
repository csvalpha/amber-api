class UserArchiveJob < ApplicationJob
  queue_as :default
  ARCHIVE_USER_ID = 0

  def perform(user_id)
    return if user_id == ARCHIVE_USER_ID

    create_global_archive_user

    user = User.find(user_id)

    destroy_soft_deleted_entities(user)
    migrate_keep_entities(user)
    user.really_destroy!
  end

  private

  def create_global_archive_user
    return if User.exists?(ARCHIVE_USER_ID)

    User.create!(id: ARCHIVE_USER_ID,
                 username: 'archived.user',
                 email: Rails.application.config.x.ict_email,
                 first_name: 'Gearchiveerde',
                 last_name: 'Gebruiker',
                 address: 'Onbekend',
                 postcode: 'Onbekend',
                 city: 'Onbekend')
  end

  def migrate_keep_entities(user)
    keep_entities.each do |entity|
      key = entity_key(entity)
      records = entity.where({ key => user })

      migrate_keep_entity_records(key, records)
    end
  end

  # Soft-deleted records are hidden by acts_as_paranoid, so they are neither migrated nor
  # removed by user.really_destroy!, but still reference the user, which then fails on the
  # foreign key. They were already deleted, so they are removed permanently instead.
  def destroy_soft_deleted_entities(user)
    soft_deleted_entities.each do |entity, key|
      entity.only_deleted.where({ key => user }).find_each(&:really_destroy!)
    end
  end

  def soft_deleted_entities
    keep_entities.map { |entity| [entity, entity_key(entity)] } + delete_entities
  end

  def migrate_keep_entity_records(key, records)
    records.each do |r|
      unless r.update({ key => global_archive_user })
        raise ActiveRecord::RecordInvalid.new(r),
              "Failed to update #{r.class} record (ID: #{r.id})"
      end

      r.versions.destroy_all
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
     PhotoTag,
     Poll,
     Form::Form,
     Form::Response,
     Forum::Post,
     Forum::Thread,
     Debit::Collection]
  end

  def delete_entities # rubocop:disable Metrics/MethodLength
    [[Membership, :user],
     [PermissionsUsers, :user],
     [BoardRoomPresence, :user],
     [StudyRoomPresence, :user],
     [PhotoTag, :tagged_user],
     [MailAlias, :user],
     [Forum::ReadThread, :user],
     [Debit::Mandate, :user],
     [Debit::Transaction, :user],
     [Declaration, :user],
     [AlumniContribution, :user]]
  end

  def entity_key(entity)
    return 'author' if entity.has_attribute?('author_id')
    return 'uploader' if entity.has_attribute?('uploader_id')

    'user'
  end
end
