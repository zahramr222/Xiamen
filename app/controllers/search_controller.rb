class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @results = Search.new(@query).call

    set_meta_tags(
      title: @query.present? ? "Search results for #{@query}" : "Search",
      description: "Search Global Synergy products, grades, articles, reports and other website content.",
      robots: "noindex,follow"
    )

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @results }
    end
  end
end