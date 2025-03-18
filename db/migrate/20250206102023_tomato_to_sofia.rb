class TomatoToSofia < ActiveRecord::Migration[7.0]
  def up
    rename_column(:users, :allow_tomato_sharing, :allow_sofia_sharing)
  end

  def down
    rename_column(:users, :allow_sofia_sharing, :allow_tomato_sharing)
  end
end
