class ChangeDescriptionAndUrlsColumnsToText < ActiveRecord::Migration[6.0]
  def change
    change_column :projects, :description, :text
    change_column :tasks, :description, :text
    change_column :tasks, :urls, :text, default: [], array: true, null: false
  end
end
