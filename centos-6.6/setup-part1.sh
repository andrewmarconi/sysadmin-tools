#!/bin/bash
echo "--> Initial update and installation of packages..."
mkdir ~/Install
cd ~/Install
yum -y update
yum install -y epel-release

echo "--> Adding support for remote TextMate editing..."
curl -Lo /usr/local/bin/rmate https://raw.github.com/textmate/rmate/master/bin/rmate
chmod a+x /usr/local/bin/rmate
yum install -y ruby

echo "--> Installing dev tools..."
yum groupinstall -y 'development tools'
# Install some common tools and libraries not provided by the 'dev tools' group.
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel libxml2-devel
yum install -y openssl-devel readline-devel ncurses-devel tk-devel python-ctypesgen gdbm-devel
yum install -y libmcrypt-devel zlib-devel libcurl-devel libexif-devel openjpeg-devel libpng-devel
yum install -y gd re2c freetype-devel wget nmap

echo "--> Install MariaDB..."
printf "# MariaDB 10.0 CentOS repository list - created 2015-03-12 03:25 UTC\n" > /etc/yum.repos.d/MariaDB-10.repo
printf "# http://mariadb.org/mariadb/repositories/\n" >> /etc/yum.repos.d/MariaDB-10.repo
printf "[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.0/centos6-amd64\n" >> /etc/yum.repos.d/MariaDB-10.repo
printf "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" >> /etc/yum.repos.d/MariaDB-10.repo
rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
yum install -y MariaDB-server MariaDB-client
/etc/init.d/mysql start

echo "--> Install newest Python..."
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz
xz -d Python-2.7.9.tar.xz
tar -xvf Python-2.7.9.tar
cd Python-2.7.9
./configure --prefix=/usr/local
make
make altinstall
ln -s /usr/local/bin/python2.7 /usr/local/bin/python
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
wget https://bootstrap.pypa.io/get-pip.py -O - | python
pip install --upgrade pip
pip install virtualenv

echo "--> Install nginx and start the service..."
printf "[nginx]\nname=nginx repo\nbaseurl=http://nginx.org/packages/centos/6/x86_64/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/nginx.repo
yum install -y nginx
/etc/init.d/nginx start

echo "--> Install php with fpm support..."
cd ~/Install
curl -Lo ~/Install/php-5.6.6.tar.gz http://us1.php.net/get/php-5.6.6.tar.gz/from/this/mirror
tar -xvzf php-5.6.6.tar.gz
cd php-5.6.6
./configure --enable-fpm --with-mysql
make
make install
cp php.ini-development /usr/local/php/php.ini
cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
cp sapi/fpm/php-fpm /usr/local/bin
/usr/local/bin/php-fpm

# TODO Modify nginx to support php-fpm
# Add "index.php" to the location block of /etc/nginx/conf.d/default.conf
#
# location / {
#     root   html;
#     index  index.php index.html index.htm;
# }
#
# Also, uncomment this block to have nginx send php requests to fpm.
#
# location ~* \.php$ {
#     fastcgi_index   index.php;
#     fastcgi_pass    127.0.0.1:9000;
#     include         fastcgi_params;
#     fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;
#     fastcgi_param   SCRIPT_NAME        $fastcgi_script_name;
# }
#
/etc/init.d/nginx restart

echo "--> Install Varnish..."
rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-4.0.el6.rpm
yum install -y varnish

echo "--> Configuring firewall to allow port 80 access (Web)..."
iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
service iptables save
service iptables restart

echo "--> Configuring fail2ban (secure SSH)..."
yum install -y fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
service fail2ban start

echo "--> Just a bit of housekeeping..."
rm -R -f  ~/Install/

echo "====================================================================================================================="
echo "Now, we're going to secure the MariaDB installation. The initial password is blank, so just hit enter at that prompt."
echo "====================================================================================================================="
mysql_secure_installation
