namespace: test_UUID
flow:
  name: UUID_TEST
  workflow:
    - uuid_generator:
        do:
          io.cloudslang.base.utils.uuid_generator: []
        publish:
          - uuid: '${new_uuid}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - flow_output: '${cs_substring(uuid,0,5)}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      uuid_generator:
        x: 440
        'y': 120
        navigate:
          187783ce-7071-5947-04cc-551daff40767:
            targetId: 4159c2ea-0b53-180e-e29b-6c177afbc31a
            port: SUCCESS
    results:
      SUCCESS:
        4159c2ea-0b53-180e-e29b-6c177afbc31a:
          x: 680
          'y': 80
