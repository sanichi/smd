class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string   :name, limit: 20
      t.text     :markdown

      t.timestamps
    end
  end
end
