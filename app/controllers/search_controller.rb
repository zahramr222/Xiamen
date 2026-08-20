class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @results = Search.new(@query).call

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end
end