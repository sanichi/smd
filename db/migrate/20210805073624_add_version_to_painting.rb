class AddVersionToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :version, :integer, limit: 2, default: 0
  end
end
