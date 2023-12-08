require 'csv'
require 'active_support/core_ext'

class PayrollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: "Welcome To Payroll Reporter"
  end

  def upload_timesheet
    timesheet = Timesheet.find_by(sheet_id: sheet_id)

    if timesheet
      render status: 500, json: {status: "error", message: "There's already a timesheet with id #{sheet_id}"}
    else
      process_file_upload
      render json: {status: "ok", message: "File content uploaded"}
    end
  end

  def report
    render json: json_report(pay_period_reports)
  end

  private

  def file
    params['file']
  end

  def filename
    file.original_filename
  end

  def sheet_id
    filename.split('-').last.split('.').first
  end

  def file_content
    content = CSV.read(file)
    content.shift # remove first element
    content
  end

  def process_file_upload
    timesheet = Timesheet.create!(filename: filename, sheet_id: sheet_id)

    file_content.each do |row|
      pay_period = create_pay_period(row[0],row[2])
      LineItem.create!(
        date: Date.parse(row[0]),
        hours_worked: row[1],
        employee_id: row[2],
        job_group: row[3],
        timesheet: timesheet,
        pay_period: pay_period
      )
    end
  end
  
  def create_pay_period(date,employee_id)
    date = Date.parse(date)
    start_date = get_start_date(date)
    end_date = get_end_date(date)
    
    PayPeriod.find_or_create_by!(
      start_date: start_date,
      end_date: end_date,
      employee_id: employee_id
    )
  end

  def get_start_date(date)
    start_date = date.day < 16 ? 1 : 16
    Date.new(date.year, date.month, start_date)
  end

  def get_end_date(date)
    end_date = date.day < 16 ? 15 : date.end_of_month.day
    Date.new(date.year, date.month, end_date)
  end

  def json_report(reports)
    {
      "payrollReport": {
        "employeeReports": reports
      }
    }
  end

  def amount_paid(line_items)
    amount = 0
    line_items.each do |line|
      rate = line.job_group == "A" ? 20 : 30
      amount += line.hours_worked * rate
    end
    '%.2f' % amount
  end

  def pay_period_reports
    reports = []
    pay_periods = PayPeriod.all
    pay_periods.each do |period|
      reports << {
        employeeId: "#{period.employee_id}",
        payPeriod: {
          startDate: "#{period.start_date}",
          endDate: "#{period.end_date}"
        },
        amountPaid: "$#{amount_paid(period.line_items)}"
      }
    end
    reports.sort_by {|report| report[:employeeId]}
  end
end
