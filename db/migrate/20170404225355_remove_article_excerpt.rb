class RemoveArticleExcerpt < ActiveRecord::Migration[5.0]
  def change
    remove_column :articles, :excerpt
  end
end
