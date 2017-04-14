class AddHarvestedAtToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :harvested_at, :datetime
  end
end
