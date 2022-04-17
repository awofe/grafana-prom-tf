export TERRAFORM_RG_NAME="rg-terraform"
export TERRAFORM_SA_NAME="cloudmorestorage"
export TERRAFORM_CONTAINER_NAME="tfstate"
export TERRAFORM_RG_LOCATION="eastus2"

az storage account check-name --name ${TERRAFORM_SA_NAME}
az group create --location eastus2 --name ${TERRAFORM_RG_NAME}
az storage account create --name ${TERRAFORM_SA_NAME} --resource-group ${TERRAFORM_RG_NAME} --location ${TERRAFORM_RG_LOCATION} --sku Standard_RAGRS --kind StorageV2 --require-infrastructure-encryption true
az storage container create --name ${TERRAFORM_CONTAINER_NAME} --account-name ${TERRAFORM_SA_NAME}
