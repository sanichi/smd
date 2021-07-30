class AddArchivedToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :archived, :boolean, default: false
  end
end
