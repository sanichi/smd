class AddMediaToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :media, :string, limit: 2
  end
end
