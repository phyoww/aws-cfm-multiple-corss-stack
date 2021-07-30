# aws-cfm-multiple-cross-stack

# Lab enviroment will be consist of below CFM template:
1. Create VPC , public subenet and public routing table, Export VPC ID , Subnet ID and public routing table
2. Create security  custom group (import vpc id), Export Security group ID
3. Create public route association each public subnet (import public subnet & public route table) and Internet Gateway attach vpc (import vpc & default route) ,(import public route table)
4. Create private subnet (import vpc id) , private routing table each private subnet (import vpc id) , Export each private subnete id and each private route table id) 
5. Create natGateway x3 with elastic ip and import public subnet ID , Export natGateway ID
6. Create private route association each private subnet (import private subnet and private route table) and default route to natGateway (import natGateway ID and private subnet ID)
6.  Create public instance ,Export instance dns
7.  Create private x 3 instances , Export instance dns


# IP Addresss assigments 
```
cloudideastarMasterVpc1 - 192.168.0.0/16
public subnet - 192.168.1.0/24 , 192.168.2.0/24 , 192.168.3.0/24
private subnet - 192.168.4.0/24 , 192.168.5.0/24 , 192.168.6.0/24
```

# Steps: 
# Simple Diagram > Update diagram will coming soon !!!!!
![header image](/pc1.png)

![header image](/pc2.png)

## 1.Run infra-stack
- [infra-stack.yaml](./infra-stack.yaml)

```bash
aws cloudformation create-stack --stack-name infra-stack --template-body file://infra-stack.yaml
```

## 2.Run security-stack
- [security-stack.yaml](./security-stack.yaml)

```bash
aws cloudformation create-stack --stack-name security-stack --template-body file://security-stack.yaml --parameters ParameterKey='infraStackName',ParameterValue='infra-stack'
```
## 3.Run public-routes-stack
- [public-routes-stack.yaml](./public-routes-stack.yaml)

```bash
aws cloudformation create-stack --stack-name public-routes-stack --template-body file://public-routes-stack.yaml --parameters ParameterKey='infraStackName',ParameterValue='infra-stack'
```

## 4.Run private-subnets-stack
- [private-subnets-stack.yaml](./private-subnets-stack.yaml)

```bash
aws cloudformation create-stack --stack-name private-subnet-stack --template-body file://private-subnets-stack.yaml --parameters ParameterKey='infraStackName',ParameterValue='infra-stack'
```

## 5.Run nat-gateways-stack
- [nat-gateways-stack.yaml](./nat-gateways-stack.yaml)

```bash
aws cloudformation create-stack --stack-name nat-gateways-stack --template-body file://nat-gateways-stack.yaml --parameters ParameterKey='infraStackName',ParameterValue='infra-stack'

```

## 6.Run private-routes-stack
- [private-routes-stack.yaml](./private-routes-stack.yaml)

```bash
aws cloudformation create-stack --stack-name private-routes-stack --template-body file://private-routes-stack.yaml --parameters ParameterKey='NATGWStackName',ParameterValue='nat-gateways-stack' ParameterKey='privateSubnetStackName',ParameterValue='private-subnet-stack'

```

## 7.Run public-instance-stack
- [public-instance-stack.yaml](./public-instance-stack.yaml)

```bash
aws cloudformation create-stack --stack-name public-instance-stack --template-body file://public-instance-stack.yaml --parameters ParameterKey='securityGroupStackName',ParameterValue='security-stack' ParameterKey='infraStackName',ParameterValue='infra-stack'

```

## 8.Run private-instance-stack
- [private-instance-stack.yaml](./private-instance-stack.yaml)

```bash
aws cloudformation create-stack --stack-name private-instance-stack --template-body file://private-instance-stack.yaml --parameters ParameterKey='securityGroupStackName',ParameterValue='security-stack' ParameterKey='privateSubnetStackName',ParameterValue='private-subnet-stack'

```

## 9.Delete stack

```bash
for i in private-instance-stack public-instance-stack private-routes-stack nat-gateways-stack private-subnets public-routes-stack security-stack infra-stack; do aws cloudformation delete-stack --stack-name $i; sleep 200; done
```
