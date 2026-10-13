class FixActiveRecordDoctorWarnings < ActiveRecord::Migration[8.1]
  NOT_NULL = {
    contacts:  %i[first_name last_name],
    contents:  %i[name],
    exhibits:  %i[name location],
    paintings: %i[title],
    users:     %i[name]
  }

  # table, column => [new limit, old limit]
  LIMITS = {
    [:contacts,  :first_name] => [30, 50],
    [:contacts,  :last_name]  => [30, 50],
    [:contacts,  :email]      => [80, 100],
    [:exhibits,  :name]       => [30, 40],
    [:exhibits,  :location]   => [25, 40],
    [:paintings, :title]      => [50, nil],
    [:users,     :name]       => [20, nil],
    [:users,     :otp_secret] => [nil, 32]
  }

  def change
    NOT_NULL.each do |table, columns|
      columns.each { |column| change_column_null table, column, false }
    end

    reversible do |dir|
      LIMITS.each do |(table, column), (new_limit, old_limit)|
        dir.up   { change_column table, column, :string, limit: new_limit }
        dir.down { change_column table, column, :string, limit: old_limit }
      end
    end

    add_index :contacts,  :email,                unique: true
    add_index :contents,  :name,                 unique: true
    add_index :exhibits,  %i[location name],     unique: true
    add_index :paintings, "lower(title)",        unique: true, name: "index_paintings_on_lower_title"
    add_index :users,     :name,                 unique: true

    add_foreign_key :paintings, :exhibits
  end
end
