class AddSourceToProject < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :source, foreign_key: true
  end
end
