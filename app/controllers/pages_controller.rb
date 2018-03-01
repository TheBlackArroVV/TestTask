class PagesController < ApplicationController
  require 'csv'

  def index
    if params[:pages] != nil
      pp @file = CSV.open(params[:pages][:file].path)
    else
      original_file
    end
  end

private
  def original_file
    @file = CSV.open(Rails.root.join("session_history.csv"))
  end
end
