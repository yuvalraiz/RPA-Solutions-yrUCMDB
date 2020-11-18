namespace: YuvalRaiz.UCMDB
flow:
  name: relatedCI
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
    - ci_id
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${auth_header}'
        navigate:
          - IS_NULL: _authenticate
          - IS_NOT_NULL: http_client_get
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
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'%s/rest-api/dataModel/relatedCI/%s' % (ucmdb_url,ci_id)}"
            - auth_type: anonymous
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: '${auth_header}'
        publish:
          - return_json: '${return_result}'
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
      http_client_get:
        x: 268
        'y': 65
        navigate:
          9fc2dc36-31a2-d218-109c-7671c0600aa8:
            targetId: aa58c667-60c1-977c-6141-3a7e4174a3d9
            port: SUCCESS
    results:
      SUCCESS:
        aa58c667-60c1-977c-6141-3a7e4174a3d9:
          x: 451
          'y': 71
