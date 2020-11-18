namespace: YuvalRaiz.UCMDB
flow:
  name: get_TQL_queryName
  inputs:
    - ucmdb_url:
        default: 'https://obm.mfdemos.com:443'
        required: true
    - username:
        default: admin
        required: false
    - password:
        default: 'MFadmin@12345!'
        required: false
    - clientContext:
        default: '1'
        required: false
    - auth_header
    - query
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${auth_header}'
        navigate:
          - IS_NULL: _authenticate
          - IS_NOT_NULL: http_client_post_1
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
          - SUCCESS: http_client_post_1
    - http_client_post_1:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'%s/rest-api/topologyQuery' % (ucmdb_url)}"
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: '${auth_header}'
            - body: '${query}'
            - content_type: application/json
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
      _authenticate:
        x: 96
        'y': 225
      http_client_post_1:
        x: 279
        'y': 67
        navigate:
          8161ddc7-07ec-6673-f902-d36a1b868f8e:
            targetId: aa58c667-60c1-977c-6141-3a7e4174a3d9
            port: SUCCESS
      is_null:
        x: 99
        'y': 79
    results:
      SUCCESS:
        aa58c667-60c1-977c-6141-3a7e4174a3d9:
          x: 451
          'y': 71
