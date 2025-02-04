FactoryBot.create(
  :application,
  name: 'A.M.B.E.R. - Webstek der C.S.V. Alpha',
  uid: '123456789',
  redirect_uri: 'https://example.com',
  scopes: 'public',
  confidential: false
)

FactoryBot.create(
  :application,
  name: 'SOFIA - Streepsysteem der C.S.V. Alpha',
  uid: '987654321',
  redirect_uri: 'http://localhost:5000/users/auth/amber_oauth2/callback',
  scopes: 'public sofia',
  confidential: false
)
