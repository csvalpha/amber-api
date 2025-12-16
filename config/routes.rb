Rails.application.routes.draw do
  scope 'v1' do
    use_doorkeeper
  end

  scope '/rails/action_mailbox', module: 'action_mailbox/ingresses' do
    post '/improvmx/inbound_emails' => 'improvmx/inbound_emails#create',
         as: :rails_improvmx_inbound_emails
  end

  namespace :v1 do
    resources :activities do
      member do
        post :generate_alias
      end
    end
    resources :articles
    resources :article_comments
    resources :board_room_presences
    resources :study_room_presences
    resources :books do
      collection do
        get :isbn_lookup
      end
    end
    resources :groups do
      member do
        get :export
      end
    end
    resources :mail_aliases
    resources :memberships
    resources :permissions, only: %i[index show]
    resources :photo_albums do
      member do
        post :dropzone
        get :zip
      end
    end
    resources :photo_comments
    resources :photo_tags
    resources :photos, only: %i[index show destroy]
    resources :polls
    resources :room_adverts
    resources :static_pages
    resources :stored_mails, only: %i[index show destroy] do
      member do
        post :accept
        post :reject
      end
    end
    resources :daily_verses, only: [:index]
    resources :users, only: %i[index show create update] do
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
      end
    end
    get 'users/me/nextcloud', to: 'users#nextcloud'

    resources :vacancies

    namespace :debit do
      resources :collections do
        member do
          get :sepa
        end
      end
      resources :transactions
      resources :mandates, only: %i[index show create update]
    end

    namespace :form do
      resources :closed_questions
      resources :closed_question_answers
      resources :closed_question_options
      resources :forms
      resources :responses
      resources :open_questions
      resources :open_question_answers
    end

    namespace :forum do
      resources :categories
      resources :posts
      resources :threads do
        member do
          post :mark_read
        end
      end
    end
  end

  get 'coffee', to: 'coffee#index'
  get 'ical/activities', to: 'v1/activities#ical'

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  # See https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
  require_relative '../lib/auth_constraint'
  constraints ->(request) { AuthConstraint.sidekiq?(request) } do
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
