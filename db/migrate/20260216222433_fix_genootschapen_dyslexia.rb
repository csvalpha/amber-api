class FixGenootschapenDyslexia < ActiveRecord::Migration[7.2]
  def up
    Activity.where(category: "Genootschapen").update_all(category: "Genootschappen")
  end

  def down
    Activity.where(category: "Genootschappen").update_all(category: "Genootschapen")
  end
end
