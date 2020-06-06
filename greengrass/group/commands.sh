#aws greengrass list-function-definitions | jq -c '.Definitions[] | select(.Id | contains("78b22e0f-e56b-4355-ac88-b4248660464d"))'
aws lambda list-functions | jq  '.Functions[] | select(.FunctionName | contains("lambdaInGreengrassCore"))'

aws lambda publish-version --function-name arn:aws:lambda:eu-west-1:199982716068:function:lambdaInGreengrassCore

aws greengrass create-device-definition --cli-input-json file://./create-device-definition.json

aws greengrass create-function-definition --cli-input-json file://./create-function-definition-version.json

aws greengrass create-core-definition \
    --name "MyCores" \
    --initial-version "{\"Cores\":[{\"Id\":\"my_core_device\",\"ThingArn\":\"arn:aws:iot:eu-west-1:199982716068:thing/my_core_device\",\"CertificateArn\":\"arn:aws:iot:eu-west-1:199982716068:cert/79e75b460339453ef08abcf8c6c4cb7ce827a95d8dd2154aa1b37c91ed19270f\",\"SyncShadow\":true}]}"

aws greengrass create-subscription-definition --cli-input-json file://./create-subscription-definition.json

aws greengrass create-group --initial-version=FunctionDefinitionVersionArn=arn:aws:greengrass:eu-west-1:199982716068:/greengrass/definition/functions/cbb6cb4d-361b-4a24-afbb-4c871f775576/versions/f026a85e-5130-47f7-a0e7-127a1bd397b3,CoreDefinitionVersionArn=arn:aws:greengrass:eu-west-1:199982716068:/greengrass/definition/cores/092a4a04-6144-4b2a-8835-963849ed5144/versions/4833655c-0eb7-4a91-81bf-a3b30d65bf37,DeviceDefinitionVersionArn=arn:aws:greengrass:eu-west-1:199982716068:/greengrass/definition/devices/857acf06-4e2c-4c9d-8af0-3f5e8156e6b3/versions/8610c8e4-df93-49c8-9703-8aa5e1a913e9  --name=greenGrassGroup

