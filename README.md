# nginx-docker

## H2 install

pip install boto3
pip install boto
pip install ansible
brew install jq ( a JQ parser )

terraform

https://learn.hashicorp.com/terraform/getting-started/install.html


## H2 Creating the infra

Setting the environment Variables

set the following variables in the file deploy/env.sh
```
export AWS_PROFILE="xxx"
export TF_VAR_key_pair_name="xxx"
export TF_VAR_access_key="xxx"
export TF_VAR_secret_key="xxx"
```

 ```
 cd deploy
./plan.sh
./apply.sh
```

The apply step will give the public IP of the instance. Give it a few minutes for docker to initialise
eg:
```

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

nginx-docker-host = 13.211.180.222

```


## H2 Deploying Docker

```
./deploy_docker.sh

```

## H2 Run the parser
Before running the following replace the public_ip with the ip you get from the previous step

```
cd ansible

ansible-playbook -i hosts parser.yml -e public_ip="<public_ip>"

```

the output will be displayed in the console


## H2 Access to Docker

export DOCKER_HOST="tcp://<public_ip>:2375"




## H2 Outcomes

- Terraform will create infrastructure and deploy the nginx container

- The Container logs will be logged in cloudwatch in its own stream based on the container ID
- The ansible parser will do the content manipulations

## H2 Reasons for solution selection
 - Terraform as opposed to ansible for docker. This was done so that terraform can maintain a state of the containers that were deployed. ideally the state locking, idempotancy mechanisms can be leveraged

 - TLS for docker. This would mean I would have to either pass on the private_key in the repo. or dynamically get the TLS provider in terraform to generate the Certs and download it. I deemed for this to be beyond scope

 - Using the default Subnet.. Ideally I would get terraform to deploy its own VPC or accept this as an input var.
