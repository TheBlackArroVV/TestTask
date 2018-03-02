class PagesController < ApplicationController
  require 'csv'

  def index
    if params[:csv].nil?
      @file = CSV.read(Rails.root.join('session_history.csv'))
    else
      @file = CSV.read(params[:csv][:file].path)
    end
    @file.delete_at(0)

    # line chart
    @created_at = []
    @duration = []
    @summary_status = []
    @normal = []

    @file.each do |f|
      @created_at.push(f[2])
      @summary_status.push(f[3])
      @duration.push(f[4])
    end

    @data_l = {
      labels: @created_at,
      datasets: [{
            label:  'Duration vs Time',
            backgroundColor:   'rgba(0,0,0,0.2)',
            borderColor:  'rgba(0,0,0,1)',
            data:  @duration
        }]
    }
    @options_l = {
      responsive: true
    }

    # stacked chart

    @passed_builds = []
    @failed_builds = []

    @created_at_date = @created_at.clone
    @created_at_date.map! { |c| c.to_date  }

    for i in 0..@created_at_date.count - 1 do
      if @summary_status[i] == 'passed'
        @passed_builds[i] = @passed_builds[i].to_i + 1
        @failed_builds[i] = 0
      elsif @summary_status[i] == 'failed'
        @failed_builds[i] = @failed_builds[i].to_i + 1
        @passed_builds[i] = 0
      else
        @failed_builds[i] = 0
        @passed_builds[i] = 0
      end
    end

    # @created_at_date.each do |c|
    #   if c == 'passed'
    #     @passed_builds.push(1)
    #     @failed_builds.push(0)
    #   elsif c == 'failed'
    #     @passed_builds.push(0)
    #     @failed_builds.push(1)
    #   else
    #     @passed_builds.push(0)
    #     @failed_builds.push(0)
    #   end
    # end

    for i in 0..@created_at_date.count - 1 do
      for j in i + 1..@created_at_date.count - 1 do
        if @created_at_date[i] == @created_at_date[j] && !@created_at_date[i].nil?
          @created_at_date[j] = nil
          @passed_builds[i] = @passed_builds[i] + @passed_builds[j]
          @passed_builds[j] = nil
          @failed_builds[i] = @failed_builds[i] + @failed_builds[j]
          @failed_builds[j] = nil
        end
      end
    end

    @created_at_date.delete(nil)
    @passed_builds.delete(nil)
    @failed_builds.delete(nil)

    @i = 0
    @avg = 0
    @failed_builds.each do |f|
      if f != 0
        @avg += f
        @i += 1
      end
    end
    @avg /= @i

    @abnormal = []
    for i in 0..@failed_builds.count - 1 do
      if @failed_builds[i] >= @avg
        @abnormal[i] = @failed_builds[i]
      else
        @abnormal[i] = 0
      end
    end

    @data_c = {
      labels: @created_at_date,
      datasets: [
        {   label:  'Abnormal',
            backgroundColor: 'rgb(0,0,0)',
            borderColor: 'rgb(0,0,0)',
            data: @abnormal
        },
        {   label:  'Failed',
            backgroundColor: 'rgb(189,19,19)',
            borderColor: 'rgb(189,19,19)',
            data: @failed_builds
        },
        {  label:  'Passed',
            backgroundColor: 'rgb(38,114,38)',
            borderColor: 'rgb(38,114,38)',
            data: @passed_builds
        }
      ]
    }
    @options_c = {
      responsive: true,
      scales: {
                xAxes:  [{  stacked:  true }],
                yAxes:  [{  stacked:  true }]
              }
            }
  end
end
