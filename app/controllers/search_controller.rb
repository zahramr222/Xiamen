class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @results = Search.new(@query).call

    respond_to do |format|
      format.html { render :index }  # ✅ Render HTML view
      format.json { render json: @results }  # ✅ Return JSON for AJAX
    end
  end
end