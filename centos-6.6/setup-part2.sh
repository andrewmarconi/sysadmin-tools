#!/bin/bash
echo "--> Install setuptools and pip..."
cd ~
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
wget https://bootstrap.pypa.io/get-pip.py -O - | python
pip install virtualenv

echo "--> Install Postgres 9.4..."
cd ~
wget http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
rpm -ivh pgdg*
yum install -y postgresql94-server
service postgresql-9.4 initdb
chkconfig postgresql-9.4 on
service postgresql-9.4 start
#su - postgres
#psql
