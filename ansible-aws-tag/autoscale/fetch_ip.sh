#!/bin/bash
#
# Edited : denzfarid <farid_@msn.com>
# 15-mar-2017
# Fetching Ip active in autoscale group


#Initialize Auto Scaling Group
asgroup_name="" 

#Get instance count for autoscaling group
instance_count=`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "$asgroup_name" --profile default | jq '.AutoScalingGroups[0].Instances | length'`

#Iterate through each instance and get Instance Id -> Private IP -> execute deployment script for each IP

counter=0
while [ $counter -lt $instance_count ]; do

        #Get instance ID from Autoscaling group
        instance_id=`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "$asgroup_name" --profile default | jq '.AutoScalingGroups[0].Instances['$counter'].InstanceId'`
        instance_ids=`echo $instance_id | sed -e 's/^"//'  -e 's/"$//'`

        #Get private IP of the instance ID
        private_ip=`aws ec2 describe-instances --instance-ids $instance_ids  --profile default | jq '.Reservations[0].Instances[0].PrivateIpAddress'`
        private_ips=`echo $private_ip | sed -e 's/^"//'  -e 's/"$//'`
        #Execute the deployment script for specific private IP
        #echo "[" $counter "]" $private_ips
         echo -e "\e[38;5;198m $counter \e[0m"  $private_ips

        #Increment the counter
        let counter=counter+1
done
