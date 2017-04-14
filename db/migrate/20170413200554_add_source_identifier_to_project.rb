class AddSourceIdentifierToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :source_identifier, :string
  end
end
