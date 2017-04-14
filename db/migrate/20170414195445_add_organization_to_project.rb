class AddOrganizationToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :organization, :string
  end
end
