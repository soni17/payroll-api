class PayrollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render plain: "Welcome To Payroll Reporter"
  end

  def upload_timesheet
  end

  def report
  end
end
