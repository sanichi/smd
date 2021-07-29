class AddStarsToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :stars, :integer, limit: 1
  end
end
