class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string   :first_name, limit: 50
      t.string   :last_name, limit: 50
      t.string   :email, limit: 100

      t.timestamps
    end
  end
end
