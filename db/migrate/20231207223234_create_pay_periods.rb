class CreatePayPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :pay_periods do |t|
      t.date :start_date
      t.date :end_date
      t.integer :employee_id
      
      t.timestamps
    end
  end
end
