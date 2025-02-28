class RenameUserToAuthorInArticles < ActiveRecord::Migration[5.0]
  def change
    rename_column :articles, :user_id, :author_id
  end
end
