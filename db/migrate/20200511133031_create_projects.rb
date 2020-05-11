class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.decimal :price, null: false

      t.timestamps null: false
    end
  end
end
