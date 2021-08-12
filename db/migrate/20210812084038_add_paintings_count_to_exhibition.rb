class AddPaintingsCountToExhibition < ActiveRecord::Migration[6.1]
  def up
    add_column :exhibits, :paintings_count, :integer, limit: 2, default: 0

    Exhibit.pluck(:id).each do |id|
      Exhibit.reset_counters(id, :paintings)
    end
  end

  def down
    remove_column :exhibits, :paintings_count
  end
end
