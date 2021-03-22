#!/bin/bash

echo "sourceType: code" >> archreport.properties
echo "sourceCodePath: ./" >> archreport.properties
echo "sourceCodeLanguage: ${INPUT_SOURCE_LANGUAGE}" >> archreport.properties
echo "revisionHistoryType: git" >> archreport.properties
echo "projectName: project" >> archreport.properties

echo "Invoking DV8 with key: ${INPUT_LICENSE_KEY} and code: ${INPUT_ACTIVATION_CODE}"
echo "With properties"

cat archreport.properties

dv8-console license:activate -licenseKey $INPUT_LICENSE_KEY -activationCode $INPUT_ACTIVATION_CODE

dv8-console arch-report -paramsFile archreport.properties

tar cvf project.tar project/

dv8-console license:deactivate -activationCode $INPUT_ACTIVATION_CODE
