class LineItem < ApplicationRecord
  belongs_to :timesheet
  belongs_to :pay_period
end
