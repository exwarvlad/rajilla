# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :description
      t.date :estimate_date
      t.decimal :price
      t.string :urls, array: true, null: false, default: []
      t.integer :status, default: 0, null: false
      t.integer :progress, null: false, default: 0
      t.references :project, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
