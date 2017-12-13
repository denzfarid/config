#!/bin/bash
#
# edited : denzfarid <farid_@msn.com>
# 15-mar-2017
# Create ami for launch at auto scale group

#AWS Credentials -- Profile in ~/.aws
aws_cli_profile="default"
#Initialize Configurations | AMI Creation
instance_id="YOUR INSTANCE ID <master instance>"
instance_name="Your insrance name for new instance in Auto Scale Group Recomend use date $(date +"%H.%M.%S %d-%m-%y %Z")"
ami_description="Your description Ami image for autoscale group"
aws_region="ap-southeast-1"

#Initialize Configurations | Launch Config Creation
lconfig_name="Your Name for launch configuration-Lconfig-$(date +"%H.%M.%S.%d-%m-%y.%Z")"
instance_type="m3.large"
key_name="keyname.pem"
security_group="your security group"
iam_role="" #set "none" for no IAM Role
ebs_vol_size=20
asgroup_name="Your Autoscale Group Name"


#Create AMI from the instance ID
ami_id=`aws ec2 create-image --instance-id $instance_id --name "$instance_name" --description "$ami_description" --no-reboot --region=$aws_region --profile $aws_cli_profile | jq '.ImageId'`
#echo $ami_id
ami_id=`echo $ami_id | sed -e 's/^"//'  -e 's/"$//'`

#Wait till the AMI is created
while true; do

        ami_state=`aws ec2 describe-images --image-ids $ami_id --profile $aws_cli_profile | jq '.Images[0].State'`
        ami_state=`echo $ami_state | sed -e 's/^"//'  -e 's/"$//'`
        echo $ami_state
        if [ "$ami_state" == "available" ]; then
                break
        fi
        echo "Checking State...."
        sleep 5

done
#echo "AMI Created"

echo "Creating Launch configuration...."
#Create a Launch Config
if [ $iam_role == "none" ]; then
`aws autoscaling create-launch-configuration --launch-configuration-name $lconfig_name --image-id $ami_id --instance-type $instance_type --key-name $key_name --security-groups $security_group --instance-monitoring "Enabled=false" --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$ebs_vol_size,\"VolumeType\":\"gp2\",\"DeleteOnTermination\":true}}]" --profile $aws_cli_profile`

else
`aws autoscaling create-launch-configuration --launch-configuration-name $lconfig_name --image-id $ami_id --instance-type $instance_type --key-name $key_name --iam-instance-profile $iam_role --security-groups $security_group --instance-monitoring "Enabled=false" --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$ebs_vol_size,\"VolumeType\":\"gp2\",\"DeleteOnTermination\":true}}]" --profile $aws_cli_profile`

fi

#Update AutoScaling Group with new Launch Config
echo "updating AutoScaling Group with new launch config...."
`aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asgroup_name --launch-configuration-name $lconfig_name --profile $aws_cli_profile`
