require_relative 'routes/contact_sync_handler'

Rails.application.routes.draw do
  scope 'v1', &method(:use_doorkeeper)

  namespace :v1 do
    jsonapi_resources :activities do
      jsonapi_relationships
      member do
        post :mail_enrolled
      end
    end
    jsonapi_resources :articles
    jsonapi_resources :article_comments
    jsonapi_resources :board_room_presences
    jsonapi_resources :groups do
      jsonapi_relationships
      member do
        get :export
      end
    end
    jsonapi_resources :mail_aliases
    jsonapi_resources :memberships
    jsonapi_resources :permissions, only: %i[index show]
    jsonapi_resources :photo_albums do
      jsonapi_relationships
      member do
        post :dropzone
        get :zip
      end
    end
    jsonapi_resources :photo_comments
    jsonapi_resources :photos, only: %i[index show destroy]
    jsonapi_resources :polls
    jsonapi_resources :static_pages
    jsonapi_resources :stored_mails, only: %i[index show destroy] do
      jsonapi_relationships
      member do
        post :accept
        post :reject
      end
    end
    resources :daily_verse, only: [:index]
    jsonapi_resources :users, only: %i[index show create update] do
      jsonapi_relationships
      collection do
        post :reset_password
        post :batch_import
      end
      member do
        post :activate_account
        post :archive
        post :resend_activation_mail
        post :generate_otp_secret
        post :activate_otp
        post :activate_webdav
      end
    end
    get 'users/me/nextcloud', to: 'users#nextcloud'

    jsonapi_resources :quickpost_messages

    namespace :debit do
      jsonapi_resources :collections do
        jsonapi_relationships
        member do
          get :sepa
        end
      end
      jsonapi_resources :transactions
      jsonapi_resources :mandates, only: %i[index show create update]
    end

    namespace :form do
      jsonapi_resources :closed_questions
      jsonapi_resources :closed_question_answers
      jsonapi_resources :closed_question_options
      jsonapi_resources :forms
      jsonapi_resources :responses
      jsonapi_resources :open_questions
      jsonapi_resources :open_question_answers
    end

    namespace :forum do
      jsonapi_resources :categories
      jsonapi_resources :posts
      jsonapi_resources :threads
    end

    namespace :vote do
      jsonapi_resources :forms
      jsonapi_resources :responses
    end
  end

  get 'coffee', to: 'coffee#index'
  get 'ical/activities', to: 'v1/activities#ical'
  post 'mailgun', to: 'mailgun#webhook'
  post 'mailgun/bounces', to: 'mailgun#bounces'

  namespace :webdav do
    match ':user_id/:key/contacts', via: :all, to: ContactSyncHandler.new(
      resource_class: DAV4Rack::Carddav::PrincipalResource,
      books_collection: '/books/'
    )

    match ':user_id/:key/contacts/books/', via: :all, to: ContactSyncHandler.new(
      resource_class: DAV4Rack::Carddav::AddressbookCollectionResource
    )

    match ':user_id/:key/contacts/books/:book_id', via: :all, to: ContactSyncHandler.new(
      resource_class: DAV4Rack::Carddav::AddressbookResource
    )

    match ':user_id/:key/contacts/books/:book_id/:contact_id(.vcf)',
          via: :all, to: ContactSyncHandler.new(
            resource_class: DAV4Rack::Carddav::ContactResource
          )
  end

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  # See https://github.com/mperham/sidekiq/wiki/Monitoring#forbidden
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

  # See https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
  require_relative '../lib/auth_constraint'
  constraints ->(request) { AuthConstraint.sidekiq?(request) } do
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
