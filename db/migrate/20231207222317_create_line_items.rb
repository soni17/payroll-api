class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items do |t|
      t.date :date
      t.integer :hours_worked
      t.integer :employee_id
      t.string :job_group
      t.integer :timesheet_id
      t.integer :pay_period_id
      
      t.timestamps
    end
  end
end
