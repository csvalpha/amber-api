class UpdateActivityAndGroupCategories < ActiveRecord::Migration[6.1]
  def change
    Activity.where(category: 'jaargroepen').update(category: 'kiemgroepen')
    Group.where(kind: 'jaargroep').update(kind: 'kiemgroep')
  end
end
