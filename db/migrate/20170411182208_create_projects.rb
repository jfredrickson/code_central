class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :repository
      t.string :description, null: false
      t.string :license
      t.integer :open_source, null: false
      t.integer :government_wide_reuse, null: false
      t.string :contact_email, null: false

      t.timestamps
    end
  end
end
