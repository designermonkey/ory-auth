- id: ory:kratos:public
  upstream:
    url: http://kratos_server:4433
    preserve_host: true
    strip_path: /.ory/kratos/public
  match:
    url: https://auth.${HOSTNAME}/.ory/kratos/public/<**>
    methods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
  authenticators:
    - handler: noop
  authorizer:
    handler: allow
  mutators:
    - handler: noop

- id: ory:kratos_self_ui:anonymous
  upstream:
    url: http://kratos_self_ui:4435
    preserve_host: true
  match:
    url: https://auth.${HOSTNAME}/<{,registration,welcome,recovery,verification,login,error,health/{alive,ready},**.css,**.js,**.png,**.svg,**.woff*}>
    methods:
      - GET
  authenticators:
    - handler: anonymous
  authorizer:
    handler: allow
  mutators:
    - handler: noop

- id: ory:oathkeeper:public
  upstream:
    url: http://oathkeeper:4456
    preserve_host: true
  match:
    url: https://auth.${HOSTNAME}/.well-known/jwks.json
    methods:
      - GET
  authenticators:
    - handler: anonymous
  authorizer:
    handler: allow
  mutators:
    - handler: noop

- id: ory:kratos_self_ui:protected
  upstream:
    url: http://kratos_self_ui:4435
    preserve_host: true
  match:
    url: https://auth.${HOSTNAME}/<{sessions,settings}>
    methods:
      - GET
  authenticators:
    - handler: cookie_session
    - handler: bearer_token
  authorizer:
    handler: allow
  errors:
    - config:
        to: https://auth.${HOSTNAME}/login
      handler: redirect
  mutators:
    - handler: id_token

- id: datum:whoami:protected
  match:
    url: https://whoami.${HOSTNAME}/
    methods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
  authenticators:
    - handler: cookie_session
    - handler: bearer_token
  authorizer:
    handler: allow
  errors:
    - handler: redirect
  mutators:
    - handler: id_token

- id: datum:mail:protected
  match:
    url: https://mail.${HOSTNAME}/<{,**}>
    methods:
      - GET
      - POST
      - PUT
      - DELETE
      - PATCH
  authenticators:
    - handler: cookie_session
    - handler: bearer_token
  authorizer:
    handler: allow
  errors:
    - handler: redirect
  mutators:
    - handler: id_token
