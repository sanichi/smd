class RemoveFilenameFromPainting < ActiveRecord::Migration[6.1]
  def up
    remove_column :paintings, :filename
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
