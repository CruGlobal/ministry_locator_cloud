class SearchController < ApplicationController
  def suggest
    locations = Searcher.new.search(params.slice(:q, :fq, :parser, :size, :fields, :start))
    render json: locations.to_json
  end
end
