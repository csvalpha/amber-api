class UpdateStaticPage < ActiveRecord::Migration[5.1]
  def change
    remove_column :static_pages, :position
    add_column :static_pages, :category, :string, nullable: false, default: 'vereniging'
  end
end
