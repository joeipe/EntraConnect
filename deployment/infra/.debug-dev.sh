# set the subscription
export ARM_SUBSCRIPTION_ID="Personal-Sub(1)(57f4859b-8037-4106-ac17-61520b9de19b)"

# set the application / environment
export TF_VAR_application_name="entra-connect"
export TF_VAR_environment_name="dev"

# set the backend
export BACKEND_RESOURCE_GROUP="rg-terraform-state-dev"
export BACKEND_STORAGE_ACCOUNT="st422y5xu5ny"
export BACKEND_STORAGE_CONTAINER="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

#run terraform
terraform init \
  -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP}" \
  -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
  -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
  -backend-config="key=${BACKEND_KEY}"

terraform $*

rm -rf .terraform