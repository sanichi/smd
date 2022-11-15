class AddNoteToPainting < ActiveRecord::Migration[7.0]
  def change
    add_column :paintings, :note, :text, default: nil
  end
end
