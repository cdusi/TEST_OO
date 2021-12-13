namespace: SalesforceAD
flow:
  name: AddUserSalesforce
  inputs:
    - username: peter.parker69856@virgilemicrofocus.onmicrosoft.com
    - jobtitle: 'Intern '
    - company: 'Oscorp Industries '
    - country: United States
    - department: Engineering
    - lastname: Parker
    - firstname: Peter
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
          - SUCCESS: CreateSalesforceUser
          - FAILURE: on_failure
    - CreateSalesforceUser:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'curl --location --request POST \\'https://microfocus95-dev-ed.my.salesforce.com/services/data/v52.0/sobjects/User/\\' --header \\'Authorization: Bearer '+token+' \\' --header \\'Content-Type: application/json\\' --data-raw \\'{ \"username\": \"'+username+'\", \"LastName\": \"'+lastname+'\", \"FirstName\": \"'+firstname+'\", \"Email\": \"'+username+'\",  \"Alias\": \"'+cs_substring(username,0,5)+'\", \"Title\": \"'+jobtitle+'\", \"CompanyName\": \"'+company+'\", \"UserRoleId\":\"00E5g000002qeJz\", \"Country\": \"'+country+'\", \"Department\": \"'+department+'\", \"TimeZoneSidkey\" : \"Europe/Paris\", \"LocaleSidKey\" : \"en_US\", \"EmailEncodingKey\" : \"ISO-8859-1\", \"ProfileId\": \"00e5g0000051Yp8\", \"LanguageLocaleKey\": \"en_US\"}\\''}"
        publish:
          - return_result
        navigate:
          - SUCCESS: ReturnSalesforceId
          - FAILURE: on_failure
    - ReturnSalesforceId:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: id
        publish:
          - salesforce_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - SalesforceId: '${salesforce_id}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      GetToken:
        x: 279
        'y': 224
      SetToken:
        x: 448
        'y': 223
      CreateSalesforceUser:
        x: 593
        'y': 224
      ReturnSalesforceId:
        x: 736
        'y': 222
        navigate:
          7d64fe6f-66d3-6318-dc8c-4cbf95a577b2:
            targetId: 129444d2-f905-98bd-4c76-b0285387a220
            port: SUCCESS
    results:
      SUCCESS:
        129444d2-f905-98bd-4c76-b0285387a220:
          x: 955
          'y': 218
