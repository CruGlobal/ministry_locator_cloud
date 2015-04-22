class Searcher

  # def suggest(q, size = 10)
  #   csd.suggest(
  #         query: q,
  #         suggester: 'location_name',
  #         size: size
  #   )
  # end

  def search(params)
    size = params[:size].to_i
    size = size > 0 ? size : 25
    start = params[:start].to_i

    search_params = {
      query: params[:q],
      query_parser: params[:parser] || 'simple',
      filter_query: params[:fq],
      size: size,
      start: start
    }
    search_params.merge!(query_options: {fields: Array.wrap(params[:fields])}.to_json)
    res = csd.search(search_params)
    locations = []
    if res.hits.found > 0
      locations = res.hits.hit.collect { |h| Location.new(h) }
    end

    {
      locations: locations,
      meta: {
        start: start + 1,
        end: start + size,
        total: res.hits.found
      }
    }
  end

  private
  def csd
    @csd ||= Aws::CloudSearchDomain::Client.new(endpoint: Rails.application.secrets.doc_endpoint)
  end
end