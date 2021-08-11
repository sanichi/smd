class CreateExhibits < ActiveRecord::Migration[6.1]
  def change
    create_table :exhibits do |t|
      t.string   :name, limit: 40
      t.string   :link
      t.string   :location, limit: 40
      t.boolean  :previous, default: false

      t.timestamps
    end
  end
end
