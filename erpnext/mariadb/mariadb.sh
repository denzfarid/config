cp -rf maria.repo /etc/yum.repos.d/
yum -y install mariadb mariadb-server mysql-devel
cp -rf server mysql-clients.cnf /etc/my.cnf.d/
systemctl start mariadb.service
systemctl enable mariadb.service
mysql_secure_installation

