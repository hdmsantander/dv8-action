# DV8 Action
Executes complexity and dependency analysis over a project.

## Example usage

_.github/workflows/main.yml_

```
on: [push]
jobs:
  dv8-analysis:
    runs-on: ubuntu-latest
    name: A job to perform DV8 analysis of source code
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
```
