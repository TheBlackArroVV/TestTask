class PagesController < ApplicationController
  require 'csv'

  def index
    @file = CSV.open(Rails.root.join("session_history.csv")) #do |csv|
      # csv.each do |c|
        # pp c
      # end
    # end
  end
end
