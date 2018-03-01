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
  end
end
