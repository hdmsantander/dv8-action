#!/bin/bash

# Building the archreport.properties file with input variables from action.yml
echo "sourceType: code" >> archreport.properties
echo "sourceCodePath: ./" >> archreport.properties
echo "sourceCodeLanguage: ${INPUT_SOURCE_LANGUAGE}" >> archreport.properties
echo "revisionHistoryType: git" >> archreport.properties
echo "projectName: project" >> archreport.properties

# Performing analysis
dv8-console license:activate -licenseKey $INPUT_LICENSE_KEY -activationCode $INPUT_ACTIVATION_CODE
dv8-console arch-report -paramsFile archreport.properties
dv8-console license:deactivate -activationCode $INPUT_ACTIVATION_CODE
