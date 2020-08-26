class ChangeDefaultPriceValueOfTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :price, :decimal, default: 0
  end

  Task.where(price: nil).update_all(price: 0)
end
