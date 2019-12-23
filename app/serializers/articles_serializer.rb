include MarkdownHelper

class ArticlesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :content, :publicly_visible, :created_at, :updated_at

  attribute :amount_of_comments do |record|
    record.comments.size
  end

  attribute :cover_photo_url do |record|
    record.cover_photo.url
  end

  attribute :content_camofied do |record|
    camofy(record.content)
  end

  has_many :comments,  record_type: :article_comment
  belongs_to :author, record_type: :user
  belongs_to :group, record_type: :group
end
