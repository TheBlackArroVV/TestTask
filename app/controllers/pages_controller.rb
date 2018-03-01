class PagesController < ApplicationController
  require 'csv'

  def index
    if params[:pages] == nil
      @file = CSV.read(Rails.root.join("session_history.csv"))
      @file.delete_at(0)
    else
      @file = CSV.read(params[:pages][:file].path)
      @file.delete_at(0)
    end
  end
end
