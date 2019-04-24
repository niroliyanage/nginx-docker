export AWS_PROFILE="nirothegreat"
export TF_VAR_region="ap-southeast-2"
export region="ap-southeast-2"
export tfplan="nginx-docker.tfplan"
export TF_VAR_access_key="AKIAJXQKTIHFJEUBMHXQ"
export TF_VAR_secret_key="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"
export TF_VAR_key_pair_name="testing"
export TF_VAR_main_vpc_id=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" | jq -r  .Vpcs[0].VpcId)
export TF_VAR_public_subnet_id=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$TF_VAR_main_vpc_id" | jq -r  .Subnets[0].SubnetId)
