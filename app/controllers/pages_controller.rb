class PagesController < ApplicationController
  require 'csv'

  def index
    if params[:csv] == nil
      @file = CSV.read(Rails.root.join("session_history.csv"))
      @file.delete_at(0)
    else
      @file = CSV.read(params[:csv][:file].path)
      @file.delete_at(0)
    end

    @created_at = Array.new
    @duration = Array.new
    @passed_tests = Array.new
    @failed_tests = Array.new
    @tests_count = Array.new
    @normal = Array.new

    for i in 0 .. @file.count - 1 do
      @created_at[i] = @file[i][2]
      @duration[i] = @file[i][4]
      @passed_tests[i] = @file[i][11].to_i
      @failed_tests[i] = @file[i][12].to_i
    end

    @created_at_date = @created_at.clone
    for i in 0 .. @created_at_date.count - 1 do
      @created_at_date[i] = @created_at_date[i].to_date
    end

    @i = 0
    @avg = 0
    @failed_tests.each do |f|
      if f != 0
        @avg = @avg + f
        @i = @i + 1
      end
    end
    @avg = @avg / @i

    for i in 0 .. @created_at_date.count - 1 do
      if @passed_tests[i].present? and @failed_tests[i].present?
        if (@passed_tests[i] + @failed_tests[i]) == 0
          @created_at_date[i] = nil
          @passed_tests[i] = nil
          @failed_tests[i] = nil
        end
      end
      for j in i + 1 .. @created_at_date.count - 1  do
        if (@created_at_date[i] == @created_at_date[j]) && (@created_at_date[i] != nil)
          @created_at_date[j] = nil
          @passed_tests[i] = @passed_tests[i] + @passed_tests[j]
          @passed_tests[j] = nil
          @failed_tests[i] = @failed_tests[i] + @failed_tests[j]
          @failed_tests[j] = nil
        end
      end
    end

    @created_at_date.delete(nil)
    @passed_tests.delete(nil)
    @failed_tests.delete(nil)
    @abnormal = Array.new
    for i in 0 .. @failed_tests.count - 1 do
      if (@failed_tests[i] >= @avg)
        @abnormal[i] = @failed_tests[i]
      else
        @abnormal[i] = 0
      end
    end
    @data_l = {
      labels: @created_at,
      datasets: [
        {
            label: "Duration vs Time",
            backgroundColor: "rgba(0,0,0,0.2)",
            borderColor: "rgba(0,0,0,1)",
            data: @duration
        }
      ]
    }
    @options_l = {
      responsive: true
    }
    @data_c = {
      labels: @created_at_date,
      datasets: [
        {
            label: "abnormal",
            backgroundColor: "rgb(0, 0, 0)",
            borderColor: "rgb(0, 0, 0)",
            data: @abnormal
        },
        {
            label: "Failed",
            backgroundColor: "rgb(189,19,19)",
            borderColor: "rgb(189,19,19)",
            data: @failed_tests
        },
        {
            label: "Passed",
            backgroundColor: "rgb(38,114,38)",
            borderColor: "rgb(38,114,38)",
            data: @passed_tests
        }
      ]
    }
    @options_c = {
      responsive: true,
      scales: {
                xAxes: [{
                    stacked: true
                }],
                yAxes: [{
                    stacked: true
                  }]
                }
              }
  end
end
