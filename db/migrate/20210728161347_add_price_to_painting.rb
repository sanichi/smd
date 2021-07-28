class AddPriceToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :price, :integer, limit: 2
  end
end
