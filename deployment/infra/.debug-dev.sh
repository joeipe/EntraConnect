# set the subscription
export ARM_SUBSCRIPTION_ID="57f4859b-8037-4106-ac17-61520b9de19b"

# set the application / environment
export TF_VAR_application_name="entra-connect-3"
export TF_VAR_environment_name="dev"
export TF_VAR_environment_full_name="Development"

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

# terraform $*
# dispatch based on first arg
cmd="$1"
shift || true

case "$cmd" in
  plan)
    terraform plan -input=false "$@"
    ;;
  apply)
    terraform apply -auto-approve -input=false "$@"
    ;;
  *)
    terraform "$cmd" "$@"
    ;;
esac

rm -rf .terraform