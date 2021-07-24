class AddWidthAndHeightToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :width, :integer, limit: 2
    add_column :paintings, :height, :integer, limit: 2
  end
end
