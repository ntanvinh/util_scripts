curl -sSLO https://dev.mysql.com/get/mysql80-community-release-el7-6.noarch.rpm
sudo rpm -ivh mysql80-community-release-el7-6.noarch.rpm
sudo yum install --nogpgcheck mysql-server
sudo systemctl start mysqld
sudo systemctl status mysqld
sudo grep 'temporary password' /var/log/mysqld.log
sudo mysql_secure_installation
mysqladmin -u root -p version