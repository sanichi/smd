class AddSoldToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :sold, :boolean, default: false
  end
end
