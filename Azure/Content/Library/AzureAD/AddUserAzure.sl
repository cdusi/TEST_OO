########################################################################################################################
#!!
#! @output azureId: Azure ID
#!!#
########################################################################################################################
namespace: AzureAD
flow:
  name: AddUserAzure
  inputs:
    - jobtitle: Intern
    - company: Oscorp Industries
    - country: France
    - firstname: Peter
    - lastname: Parker
    - department: Engineering
    - username: testpeter@bhargavmicrofocus.onmicrosoft.com
  workflow:
    - GeneratePassword:
        do:
          io.cloudslang.base.utils.random_password_generator:
            - password_length: '16'
            - number_of_lower_case_characters: '8'
            - number_of_upper_case_characters: '4'
            - number_of_numerical_characters: '2'
            - number_of_special_characters: '2'
            - forbidden_characters: '.,@?/;%'
        publish:
          - password: '${return_result}'
        navigate:
          - SUCCESS: GetToken
          - FAILURE: on_failure
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
          - SUCCESS: CreateAzureUser
          - FAILURE: on_failure
    - CreateAzureUser:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'curl --location --request POST \\'https://graph.microsoft.com/v1.0/users\\' --header \\'Authorization: Bearer '+token+' \\' --header \\'Content-Type: application/json\\' --data-raw \\'{ \"accountEnabled\": true, \"displayName\": \"'+firstname+' '+lastname+'\", \"givenName\": \"'+firstname+'\", \"surname\": \"'+lastname+'\", \"companyName\": \"'+company+'\", \"mailNickname\": \"'+firstname+'\", \"userPrincipalName\": \"'+username+'\", \"mail\": \"'+username+'\", \"jobTitle\" : \"'+jobtitle+'\", \"country\" : \"'+country+'\", \"department\" : \"'+department+'\", \"usageLocation\" : \"FR\", \"preferredLanguage\" : \"en-US\", \"passwordProfile\" : {\"password\": \"'+password+'\"}}\\''}"
        publish:
          - return_result
        navigate:
          - SUCCESS: ReturnAzureId
          - FAILURE: on_failure
    - ReturnAzureId:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: id
        publish:
          - azure_id: '${return_result}'
        navigate:
          - SUCCESS: AssignLicense
          - FAILURE: on_failure
    - AssignLicense:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'curl --location --request POST \\'https://graph.microsoft.com/v1.0/users/'+username+'/assignLicense\\' --header \\'Authorization: Bearer '+token+' \\' --header \\'Content-Type: application/json\\' --data-raw \\'{ \"addLicenses\" : [{\"skuId\":\"c42b9cae-ea4f-4ab7-9717-81576235ccac\"}], \"removeLicenses\" : []}\\''}"
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - azureId: '${azure_id}'
    - userpassword: '${password}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      GeneratePassword:
        x: 41
        'y': 186
      GetToken:
        x: 185
        'y': 197
      SetToken:
        x: 305
        'y': 195
      CreateAzureUser:
        x: 459
        'y': 197
      ReturnAzureId:
        x: 603
        'y': 198
      AssignLicense:
        x: 760
        'y': 200
        navigate:
          6b0e1c2b-2b8d-1e97-2ee2-5493494a0cfa:
            targetId: 43a255c0-edab-50c2-2be8-593d4edf693f
            port: SUCCESS
    results:
      SUCCESS:
        43a255c0-edab-50c2-2be8-593d4edf693f:
          x: 950
          'y': 199
