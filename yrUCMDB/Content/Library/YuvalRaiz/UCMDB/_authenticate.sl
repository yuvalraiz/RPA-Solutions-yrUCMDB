namespace: YuvalRaiz.UCMDB
flow:
  name: _authenticate
  inputs:
    - ucmdb_url
    - username
    - password:
        sensitive: false
    - clientContext: '1'
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'%s/rest-api/authenticate' % (ucmdb_url)}"
            - auth_type: anonymous
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - body: |-
                ${'''{
                    "username": "%s",
                    "password": "%s",
                    "clientContext": "1"
                 }''' % (username,password)}
            - content_type: application/json
        publish:
          - token: "${return_result.split('\"')[3]}"
          - auth_header: "${'Authorization: Bearer '+token+'\\n'}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token
    - auth_header
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 41
        'y': 97
        navigate:
          400ecd43-05c4-5e36-da1b-de69b5e09454:
            targetId: aa58c667-60c1-977c-6141-3a7e4174a3d9
            port: SUCCESS
    results:
      SUCCESS:
        aa58c667-60c1-977c-6141-3a7e4174a3d9:
          x: 234
          'y': 96
