class CreateTimesheets < ActiveRecord::Migration[7.1]
  def change
    create_table :timesheets do |t|
      t.string :filename
      t.integer :sheet_id
      
      t.timestamps
    end
  end
end
