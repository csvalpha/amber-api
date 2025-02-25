class ChangeUserIntoAuthorArticleAndPhotoComments < ActiveRecord::Migration[5.1]
  def change
    rename_column :article_comments, :user_id, :author_id
    rename_column :photo_comments, :user_id, :author_id
  end
end
