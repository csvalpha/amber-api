class DefaultOffPaginator < PagedPaginator
  # This extension of the PagedPaginator makes sure that pagination
  # is only applied when requested by the client
  attr_reader :turned_on

  def apply(relation, _order_options)
    return relation unless @turned_on

    super
  end

  def parse_pagination_params(params)
    @turned_on = params.present?
    super
  end

  def links_page_params(options = {})
    return {} unless @turned_on

    super
  end
end
