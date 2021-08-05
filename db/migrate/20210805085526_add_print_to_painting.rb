class AddPrintToPainting < ActiveRecord::Migration[6.1]
  def change
    add_column :paintings, :print, :integer, limit: 2
  end
end
