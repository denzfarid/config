yum install epel-release yum-presto
yum groupinstall -y "Development tools";
yum install -y redhat-lsb-core git python-setuptools python-devel openssl-devel libffi-devel  net-tools cpan nano screen nfs-utils nfs-utils-lib rsync wget htop ntp ntpdate chrony bash-completion iftop iotop sysstat vim fpaste vnstat i2c-tools.x86_64 i2c-tools-eepromer.x86_64 lm_sensors.x86_64;
wget https://bootstrap.pypa.io/get-pip.py;python get-pip.py;pip install --upgrade pip setuptools;pip install ansible

#nginx,node,redis
sudo curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum -y localinstall http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm;
yum -y localinstall https://extras.getpagespeed.com/redhat/7/noarch/RPMS/getpagespeed-extras-7-0.el7.gps.noarch.rpm &&
yum -y install nginx nodejs redis nginx-module-nbr supervisor;
npm install -g express yarn socket.io superagent rollup;

systemctl start {nginx,redis,supervisord}
systemctl enable {nginx.redis,supervisord}

#wkhtml
yum -y install libXrender libXext xorg-x11-fonts-75dpi xorg-x11-fonts-Type1
cd /opt
curl -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz | tar xJf -
ln -s /opt/wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf; ln -s /opt/wkhtmltox/bin/wkhtmltoimage /usr/bin/wkhtmltoimage


