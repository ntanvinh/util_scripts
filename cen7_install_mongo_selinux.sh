# requirements
sudo yum install -y git
sudo yum install -y make
sudo yum install -y checkpolicy
sudo yum install -y policycoreutils
sudo yum install -y selinux-policy-devel

# to apply policy:
git clone https://github.com/mongodb/mongodb-selinux
cd mongodb-selinux
make
sudo make install

# to uninstall policy:
# sudo make uninstall