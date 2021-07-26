class AddGalleryToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :gallery, :integer, limit: 1
  end
end
