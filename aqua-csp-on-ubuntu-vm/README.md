# A sample to deploy Ubuntu VM , install docker-ce and deploy Aqua CSP container using CustomScript Extension

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faquasecurity%2Fazure-templates%2Fmaster%2Faqua-csp-on-ubuntu-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Faquasecurity%2Fazure-templates%2Fmaster%2Faqua-csp-on-ubuntu-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

[CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) allows the owner of the Azure Virtual Machines to run customized scripts in the VM.

This template deployed: Ubuntu VM,Storage account,Public IP address,Network interface, VNET. It then installs docker-ce and deploys Aqua CSP container

## Deploy
Download the azuredeploy.parameters.json file and configure the required parameters. In order to deploy the template, follow the following guides:

1. Using Azure CLI

  https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-azure-resource-manager/

2. Using Azure Powershell

  https://azure.microsoft.com/en-us/documentation/articles/powershell-azure-resource-manager/

3. Using Azure Portal

  Click the "Deploy to Azure" button.
  
  
 <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-templates%2Fmaster%2Faqua-csp-on-ubuntu-vm%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>