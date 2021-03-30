# DV8 Action
Executes complexity and dependency analysis over a project.

## Inputs

### `license key`

**Required** The licence of the product.

### `activation code`

**Required** The activation code of the product.

### `source language`

The language of the source code, accepted values are: java, cpp, python and ruby. The default value is **java**

## Outputs

### `project`

A folder containing the results of the DV8 analysis, the results can be parsed or they can be uploaded to the workflow as artifacts. The structure of the project folder is as follows:

* project/
  + config/
    * history-extended-config.xml
    * structure-extended-config.xml
  + depends-output/
    * dependency.csv
    * depends-dv8map.mapping
    * dependency.json
  + dv8-analysis-output/
    * anti-pattern/
    * dsm/
    * hotspot/
    * maintenance-costs/
    * root/
    * file-measure-report.csv
    * analysis-summary.html
  + project.dv8.proj

## Example usage

Create a yml file inside the .github/workflows folder to define a new workflow.

_.github/workflows/main.yml_

```
on: [push]
jobs:
  dv8-analysis:
    runs-on: ubuntu-latest
    name: A job to perform DV8 analysis of source code over a project
    steps:
      # Check out the repository
      - name: Checkout
        uses: actions/checkout@v2.3.4

      # Use the DV8 action
      - name: DV8 analysis
        id: dv8
        uses: hdmsantander/dv8-action@main
        with: 
          license key: ${{ secrets.LICENSE_KEY }}
          activation code: ${{ secrets.ACTIVATION_CODE }}
          source language: java

      # Store the DV8 results as an artifact in the workflow
      - name: Store DV8 analysis
        uses: actions/upload-artifact@v2
        with:
          name: project
          path: project/
```
