# nginx-docker

install

pip install boto3
pip install boto
pip install ansible

terraform

https://learn.hashicorp.com/terraform/getting-started/install.html


Creating the infra

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


Deploying Docker

```
./deploy_docker.sh

```

Run the parser
Before running the following replace the public_ip with the ip you get from the previous step

```
cd ansible

ansible-playbook -i hosts parser.yml -e public_ip="<public_ip>"

```

the output will be displayed in the console
