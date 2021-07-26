class ChangeMediaInPainting < ActiveRecord::Migration[6.1]
  def up
    change_column :paintings, :media, :string, limit: 5
  end

  def down
    change_column :paintings, :media, :string, limit: 2
  end
end
