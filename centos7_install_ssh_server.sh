echo INSTALL SSH DAEMON
yum update -y
yum install -y openssh openssh-server openssh-clients openssl-libs
systemctl start sshd
echo
echo OPEN FIREWALL
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
echo
echo CHECK STATUS
yum install net-tools -y 
netstat -nutlp | grep 22
