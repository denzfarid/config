#!/bin/bash

##
# Author : Farid < farid_@msn.com >
# Script : bash to install webserver Centos
# 18 Feb 2018
##
echo "###############"
echo "# Generate Key #"
echo "###############"
ssh-keygen -t rsa -b 4096 -o -a 100 -f ~/.ssh/id_rsa -N "" > /dev/null

echo "#######################"
echo "# Install Development #"
echo "######################"
yum -y groupinstall "Development Tools"

echo -e "\n"
echo "#####################"
echo "# Install Remi Repo #"
echo "#####################"
yum localinstall http://rpms.famillecollet.com/enterprise/remi-release-7.rpm -y

echo -e "\n"
echo "############################"
echo "#  install epel & other    #"
echo "############################"
yum install epel-release yum-presto -y && yum install httpd net-tools cpan nano screen nfs-utils nfs-utils-lib rsync wget htop ntp ntpdate chrony bash-completion iftop iotop sysstat vim fpaste vnstat i2c-tools.x86_64 i2c-tools-eepromer.x86_64 lm_sensors.x86_64 psmisc -y 


echo -e "\n"
echo "#################################"
echo "#       Install php56 remi      #"
echo "################################"
yum install --enablerepo=remi-php56 php php-mcrypt php-mbstring php-fpm php-gd php-devel php-xml php-mysql php-pdo php-pecl-memcached php-pecl-memcache php-pecl-mongo -y
#php-opcache php-xcache

echo -e "\n"
echo "#####################################"
echo "# configure ssh config skip answere #"
echo "####################################"
cat > ~/.ssh/config << __sshconfhome__
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
__sshconfhome__

echo -e "\n"
echo "##############"
echo "Disable ipv6 #"
echo "##############"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf 
sysctl -p

echo -e "\n"
echo "#####################"
echo "#     Setup Date    #"
echo "#####################"
sed -i "s/centos/id/g" /etc/ntp.conf
sed -i "s/centos/id/g" /etc/chrony.conf
timedatectl set-timezone Asia/Jakarta
systemctl enable chronyd 
systemctl enable ntpdate

echo -e "\n"
echo "#####################"
echo "#     Setup php    #"
echo "#####################"
sed -i -e 's/expose_php = On/expose_php = Off/' /etc/php.ini
sed -i "s/^;date.timezone =$/date.timezone = \"Asia\/Jakarta\"/" /etc/php.ini

echo -e "\n"
echo "##############"
echo "# Nginx Repo #"
echo "##############"
yum -y localinstall http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

echo -e "\n"
echo "######################"
echo "# Brotli & pagespeed #"
echo "#####################"
yum -y localinstall https://extras.getpagespeed.com/redhat/7/noarch/RPMS/getpagespeed-extras-7-0.el7.gps.noarch.rpm &&
yum install nginx-module-nbr  nginx-module-nps -y

