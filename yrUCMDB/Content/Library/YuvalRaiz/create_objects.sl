namespace: YuvalRaiz.UCMDB
flow:
  name: create_objects
  inputs:
    - ucmdb_url:
        required: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - clientContext:
        default: '1'
        required: false
    - auth_header:
        required: false
    - ucmdb_objects_json
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${auth_header}'
        navigate:
          - IS_NULL: _authenticate
          - IS_NOT_NULL: http_client_post
    - _authenticate:
        do:
          YuvalRaiz.UCMDB._authenticate:
            - ucmdb_url: '${ucmdb_url}'
            - username: '${username}'
            - password: '${password}'
        publish:
          - token
          - auth_header
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'%s/rest-api/dataModel' % (ucmdb_url)}"
            - auth_type: anonymous
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: '${auth_header}'
            - body: '${ucmdb_objects_json}'
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token
    - authentication_header: '${auth_header}'
    - return_json
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 99
        'y': 79
      _authenticate:
        x: 96
        'y': 225
      http_client_post:
        x: 301
        'y': 76
        navigate:
          cadf4926-58a7-3a25-6087-a2b41cfc6ab9:
            targetId: aa58c667-60c1-977c-6141-3a7e4174a3d9
            port: SUCCESS
    results:
      SUCCESS:
        aa58c667-60c1-977c-6141-3a7e4174a3d9:
          x: 504
          'y': 74
