class AddSaleToPainting < ActiveRecord::Migration[7.0]
  def change
    add_column :paintings, :sale, :boolean, default: false
  end
end
