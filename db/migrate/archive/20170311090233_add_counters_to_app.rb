class AddCountersToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :comments_count, :integer, null: false, default: 0
    add_column :form_forms, :responses_count, :integer, null: false, default: 0
    add_column :forum_categories, :threads_count, :integer, null: false, default: 0
    add_column :forum_threads, :posts_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE articles
           SET comments_count = (SELECT count(1)
                                  FROM article_comments
                                 WHERE article_comments.article_id = articles.id);
        UPDATE form_forms
           SET responses_count = (SELECT count(1)
                                    FROM form_responses
                                   WHERE form_responses.form_id = form_forms.id);
        UPDATE forum_categories
           SET threads_count = (SELECT count(1)
                                 FROM forum_threads
                                WHERE forum_threads.category_id = forum_categories.id);
        UPDATE forum_threads
           SET posts_count = (SELECT count(1)
                               FROM forum_posts
                              WHERE forum_posts.thread_id = forum_threads.id);
    SQL
  end
end
