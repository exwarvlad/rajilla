# frozen_string_literal: true

class AddArchivePublicUrlToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :archive_public_url, :string, default: nil
  end
end
