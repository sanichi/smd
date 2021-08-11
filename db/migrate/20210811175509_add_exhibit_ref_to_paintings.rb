class AddExhibitRefToPaintings < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :paintings, :exhibit
  end
end
