class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :line_items, :timesheets
    add_foreign_key :line_items, :pay_periods
  end
end
