class V1::Webauthn::CredentialResource < V1::ApplicationResource
  model_name 'Webauthn::Credential'
  attributes :nickname, :created_at

  has_one :user, always_include_linkage_data: true
end
