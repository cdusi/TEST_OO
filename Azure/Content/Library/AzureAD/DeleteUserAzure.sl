namespace: AzureAD
flow:
  name: DeleteUserAzure
  inputs:
    - useremail: testpeter@bhargavmicrofocus.onmicrosoft.com
  workflow:
    - GetToken:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "curl --location --request POST 'https://login.microsoftonline.com/173afac8-2ba6-41b5-a2eb-ecac65f7cc01/oauth2/v2.0/token' \\\n--header 'Content-Type: application/x-www-form-urlencoded' \\\n--header 'Cookie: buid=0.AQwADQSIkWdsW0yxEjajBLZtrXbeMWemFK5Jl7xuumkUOR4zAAA.AQABAAEAAAD--DLA3VO7QrddgJg7Wevrh2tl_S9C9VgS3qcjgT5ibG0GAHV63XtSN-47bZUO86cUAJLJo8_BK7QKOWPNj47aGqiN_rzNL0GZWeVAz2XJcJiFf8zBLBGUGGS3ozTcbi4gAA; esctx=AQABAAAAAAD--DLA3VO7QrddgJg7WevrcKNZxZiYfBAuZKm_ktUfYAPIL6uzwCPadT_zvyvwVA8LOVAHp6tXWPQoRZYqxM1SOmfRUQt6wb_qE3yy8GbpdrEtCBsx-HsscPbS3ABoUaLnHRnigtD4CdbuPfV2eHylBi2xvjhci2ivQjuuNP3H8mPT4ypVrCMbNNGOsvYG2A0gAA; fpc=AtUaGLz-H79NrrO2M8E4_D4cKTtEAQAAAKm_jNgOAAAA; stsservicecookie=estsfd; x-ms-gateway-slice=estsfd' \\\n--data-urlencode 'grant_type=client_credentials' \\\n--data-urlencode 'client_id=fdea6c27-f5b5-4aec-bb01-a33e63805b5d' \\\n--data-urlencode 'client_secret=Oib7Q~MCevBMGv15~SBxXgcjkOuTcYYtEAcic' \\\n--data-urlencode 'scope=https://graph.microsoft.com/.default'"
        publish:
          - return_result
        navigate:
          - SUCCESS: SetToken
          - FAILURE: on_failure
    - SetToken:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: access_token
        publish:
          - token: '${return_result}'
        navigate:
          - SUCCESS: DeleteAzureUser
          - FAILURE: on_failure
    - DeleteAzureUser:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'curl --location --request DELETE \\'https://graph.microsoft.com/v1.0/users/'+useremail+'\\' --header \\'Authorization: Bearer '+token+' \\' --header \\'Content-Type: application/json\\' --data-raw \\'{}}\\''}"
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      GetToken:
        x: 133
        'y': 203
      SetToken:
        x: 332
        'y': 202
      DeleteAzureUser:
        x: 521
        'y': 198
        navigate:
          b9423a55-f41f-9e8d-3ede-0005e95e0cc2:
            targetId: c1517ee4-44bf-d06e-7f9f-4a5e879bc478
            port: SUCCESS
    results:
      SUCCESS:
        c1517ee4-44bf-d06e-7f9f-4a5e879bc478:
          x: 691
          'y': 198
