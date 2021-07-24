class CreatePaintings < ActiveRecord::Migration[6.1]
  def change
    create_table :paintings do |t|
      t.string   :filename
      t.string   :title

      t.timestamps
    end
  end
end
