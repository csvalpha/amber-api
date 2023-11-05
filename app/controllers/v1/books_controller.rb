class V1::BooksController < V1::ApplicationController
  def isbn_lookup # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    authorize Book

    return unless params.key?(:isbn)

    isbn = params.require(:isbn)

    product = get_product(isbn)
    return head :not_found if product.nil?

    title = ActionView::Base.full_sanitizer.sanitize(product['volumeInfo']['title'])
    author = ActionView::Base.full_sanitizer.sanitize(product['volumeInfo']['authors'].join(', '))
    description = ActionView::Base.full_sanitizer.sanitize(product['volumeInfo']['description'])
    cover_photo = get_cover_photo(product['id'])
    data = { title: title, author: author, description: description, isbn: isbn,
             cover_photo: cover_photo }
    render json: data
  end

  private

  def get_product(query)
    api_key = Rails.application.config.x.google_api_key
    url = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{query}&maxResults=1&projection=lite&key=#{api_key}"
    result = HTTP.get(url).parse
    return nil if result['items'].blank?

    result['items'].first
  end

  def cover_photo_sizes
    %i[extra_large large medium small thumbnail small_thumbnail]
  end

  def get_cover_photo(product_id) # rubocop:disable Metrics/AbcSize
    api_key = Rails.application.config.x.google_api_key
    url = "https://www.googleapis.com/books/v1/volumes/#{product_id}?fields=volumeInfo(imageLinks)&key=#{api_key}"
    result = HTTP.get(url).parse
    image_links = result['volumeInfo']['imageLinks']
    return nil unless image_links

    camelized_sizes = cover_photo_sizes.map { |val| val.to_s.camelize(:lower) }
    size = (camelized_sizes & image_links.keys).first
    return nil unless size

    result = HTTP.get(image_links[size])
    "data:#{result.content_type.mime_type};base64,#{Base64.strict_encode64(result.to_s)}"
  end
end
