#!/bin/bash
echo "--> Initial update and installation of packages..."
yum -y update
yum groupinstall -y 'development tools'
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel wget nmap epel-release nginx fail2ban

echo "--> Configuring firewall to allow port 80 access (Web)..."
iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
service iptables save
service iptables restart

echo "--> Configuring fail2ban (secure SSH)..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
service fail2ban start

echo "--> Install newest Python..."
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
xz -d Python-2.7.9.tar.xz
tar -xvf Python-2.7.9.tar
cd Python-2.7.9
./configure --prefix=/usr/local
make
make altinstall
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
/etc/init.d/nginx start

echo "------------------------------------"
echo "Now there are two steps to complete:"
echo "------------------------------------"
echo " "
echo "1. Update your ~/.bash_profile to place /usr/local/bin at the beginning."
echo " "
echo "    PATH=/usr/local/bin:$PATH:$HOME/bin"
echo " "
echo " "
echo "2. Disable the default PostgreSQL packages in CentOS-Base to prep for"
echo "   installation from the most recent stable source, by adding"
echo "   'exclude=postgresql*' to the bottom of the [base] and [updates]"
echo "   sections of /etc/yum.repos.d/CentOS.Base.repo"
echo " "
