namespace: SalesforceAD
flow:
  name: DeleteUserSalesforce
  inputs:
    - usersalesforceid: 0055g00000DzWzq
  workflow:
    - GetToken:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "curl --location --request POST 'https://login.salesforce.com/services/oauth2/token' \\--header 'Content-Type: application/x-www-form-urlencoded' \\--header 'Accept: application/json' \\--header 'Cookie: BrowserId=fkYeGP9rEeub1DWLYxFLaw; CookieConsentPolicy=0:0' \\--data-urlencode 'grant_type=password' \\--data-urlencode 'client_id=3MVG9fe4g9fhX0E5xWbOVMPzWhmmqTFOpCzf2HeivRGvCj0JWTB81yGmGrQtKZeb2cGYNV16pUOweupBvTRsm' \\--data-urlencode 'client_secret=9CFE2B44047011D5D035DCC64F97AF8C1526A231F36E8636263516FBC1B87E4C' \\--data-urlencode 'username=bhargav@mf.com' \\--data-urlencode 'password=Itomdemo20$zqyxH6wbJG1cpVdcbI3ihauy'"
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
          - SUCCESS: DeleteSalesforceUser
          - FAILURE: on_failure
    - DeleteSalesforceUser:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'curl --location --request PATCH \\'https://microfocus95-dev-ed.my.salesforce.com/services/data/v52.0/sobjects/User/'+usersalesforceid+'\\' --header \\'Authorization: Bearer '+token+' \\' --header \\'Content-Type: application/json\\' --data-raw \\'{ \"IsActive\": false}\\''}"
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
        x: 268
        'y': 231
      SetToken:
        x: 444
        'y': 228
      DeleteSalesforceUser:
        x: 621
        'y': 224
        navigate:
          d2b21227-22f8-2f7d-53a5-5adb0bef1b8d:
            targetId: 0f9aa048-2a45-af86-0403-19444a3c1fb9
            port: SUCCESS
    results:
      SUCCESS:
        0f9aa048-2a45-af86-0403-19444a3c1fb9:
          x: 788
          'y': 227
