1. you must run install.sh and back again to readme

refference article

1. https://www.vultr.com/docs/how-to-install-erpnext-open-source-erp-on-centos-7
2. https://www.jamescoyle.net/how-to/1717-manually-install-erpnext-on-a-manual-install-of-frappe
3. https://www.jamescoyle.net/how-to/1714-manually-install-frappe-on-ubuntu-14-04-with-a-remote-sql-server

################
# install bench
################
1. create new user to run bench
   ```adduser bench```

2. change password for user bench
   ```passwd bench```

3. Provide sudo permissions to the bench user.
   ```usermod -aG wheel bench```

4. Login as the newly created bench user:
   ```sudo su - bench```

5. Clone the Bench repository in home bench
   ```cd 
   git clone https://github.com/frappe/bench bench-repo```

6. Install Bench using pip.
   ```sudo pip install -e bench-repo```

Once Bench is installed, proceed further to install ERPNext using Bench.

#############################
# Install ERPNext using Bench
#############################

1. Initialize a bench directory with frappe framework installed. To keep everything tidy, we will work under /home/bench directory. 
   Bench will also setup regular backups and auto updates once a day.
  
   ```bench init erpnext && cd erpnext```

2. add configuration in sites/common_site_config.json
   ``` "db_host": "database.host.com",
    "db_port": "3306",```

3. in mariadb server give grant all database
   ```GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'YOUR PASSWORD' WITH GRANT OPTION;```

4. Create a new Frappe site:
   ```bench new-site erp.example.com```

The above command will prompt you for the MySQL root password. Provide the password which you have set for the MySQL root user earlier. 
It will also ask you to set a new password for the administrator account. You will need this password later to log into the administrator dashboard.


5. Download ERPNext installation files from the remote git repository using the Bench.
   ```bench get-app erpnext https://github.com/frappe/erpnext```

6. Install ERPNext on your newly created site 
   ```bench --site erp.example.com install-app erpnext```

7. ERPNext is installed on your server. You can start the application immediately to check if the application is started successfully
   ```bench start```

However, you should stop the execution and proceed further to set up the application for production use.

#################################
# Setup Bench for production use
#################################


```sudo bench setup production bench```

The above command may prompt you before replacing the existing Supervisor default configuration file with a new one. 
Choose y to proceed. Bench adds a number of processes to Supervisor configuration file. 
The above command will also ask you if you wish to replace the current Nginx configuration with a new one. 
Enter y to proceed. Once Bench has finished installing the configuration, provide other users to execute the files in your home directory of Bench user.

```chmod o+x /home/bench```

If you are running a firewall on your server, you will need to configure the firewall to set an exception for HTTP service. Allow Nginx reverse proxy to connect from outside the network.

```sudo firewall-cmd --zone=public --permanent --add-service=http```
```sudo firewall-cmd --zone=public --permanent --add-service=https```
```sudo firewall-cmd --reload```

######################################
# Setting Up SSL Using Let's Encrypt 
######################################

Let's Encrypt provides free SSL certificates to the users. 
SSL can be installed manually or automatically through Bench. 
Bench can automatically install the Let's Encrypt client and obtain the certificates. 
Additionally, it automatically updates the Nginx configuration to use the certificates.

"The domain name which you are using to obtain the certificates from the Let's Encrypt CA must be pointed towards the server. 
The client verifies the domain authority before issuing the certificates."

1. Enable DNS multi-tenancy for the ERPNext application.
   ```bench config dns_multitenant on```

2. Run Bench to set up Let's Encrypt on your site:
   ```sudo bench setup lets-encrypt erp.example.com```

During the execution of the script, the Let's Encrypt client will ask you to temporarily stop the Nginx web server. 
It will automatically install the required packages and Let's Encrypt client. 
The client will prompt for your email address. 
You will also need to accept the terms and conditions. 
Once the certificates have been generated, Bench will also generate the new configuration for Nginx which uses the SSL certificates. 
You will be asked before replacing the existing configuration. 
Bench also creates a crontab entry to automatically renew the certificates every month.

3. Finally, enable scheduler to automatically run the scheduled jobs:
   ```bench enable-scheduler```

