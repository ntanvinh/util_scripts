rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
yum -y install xrdp tigervnc-server
systemctl start xrdp.service
systemctl enable xrdp.service
netstat -antup | grep xrdp
firewall-cmd --permanent --zone=public --add-port=3389/tcp
firewall-cmd --reload