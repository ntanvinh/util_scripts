# install ssh daemon
yum update -y
yum install -y openssh openssh-server openssh-clients openssl-libs
systemctl start sshd

# open firewall
firewall-cmd --zone=public --add-port=22/tcp –permanent
firewall-cmd –reload

# check status
yum install net-tools -y 
netstat -nutlp | grep 22
