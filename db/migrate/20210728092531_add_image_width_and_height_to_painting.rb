class AddImageWidthAndHeightToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :image_width, :integer, limit: 2
    add_column :paintings, :image_height, :integer, limit: 2
  end
end
