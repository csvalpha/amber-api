class V1::BooksController < V1::ApplicationController
  def isbn_lookup # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless params.key?(:isbn)

    isbn = params.require(:isbn)

    product = get_product(isbn)
    return head :not_found if product.nil?

    title = ActionView::Base.full_sanitizer.sanitize(get_title(product))
    author = ActionView::Base.full_sanitizer.sanitize(product['specsTag'])
    description = ActionView::Base.full_sanitizer.sanitize(product['longDescription'])
    cover_photo = get_cover_photo(product)
    data = { title: title, author: author, description: description, isbn: isbn,
             cover_photo: cover_photo }
    render json: data
  end

  private

  def get_product(query)
    api_key = Rails.application.config.x.bol_com_api_key
    url = "https://api.bol.com/catalog/v4/search?q=#{query}&offset=0&limit=1&dataoutput=products&apikey=#{api_key}&format=json"
    result = HTTP.get(url).parse
    return nil unless (result['totalResultSize']).positive?

    result['products'][0]
  end

  def get_title(product)
    if product['subtitle']
      "#{product['title']} - #{product['subtitle']}"
    else
      product['title']
    end
  end

  def get_cover_photo(product)
    return nil unless product['images']

    cover_photo = product['images'].find { |image| image['key'] == 'XL' }

    # Pick the largest available image if no XL image available
    cover_photo = product['images'].last if cover_photo.nil?

    return nil unless cover_photo

    mime = Rack::Mime.mime_type(".#{cover_photo['url'].split('.').last}")
    cover_photo = HTTP.get(cover_photo['url']).to_s
    "data:#{mime};base64,#{Base64.strict_encode64(cover_photo)}"
  end
end
