#!/bin/bash
echo "--> Install setuptools and pip..."
cd ~/Install
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
wget https://bootstrap.pypa.io/get-pip.py -O - | python
pip install virtualenv

echo "--> Install Postgres 9.4..."
cd ~/Install
wget http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
rpm -ivh pgdg*
yum install -y postgresql94-server
service postgresql-9.4 initdb
chkconfig postgresql-9.4 on
service postgresql-9.4 start
#su - postgres
#psql


echo "--> Installing Java and Tomcat..."
yum install -y java
yum -y install tomcat6 tomcat6-webapps tomcat6-admin-webapps
chkconfig tomcat6 on
service tomcat6 start

#Temporarily open port 8080 for Tomcat (We'll close it later)
iptables -I INPUT 7 -p tcp --dport 8080 -j ACCEPT
service iptables save

vi /etc/tomcat6/tomcat-users.xml
echo "!!!!! TODO - Add roles and users to file."
# Add these inside the <tomcat-users> block:
#<role rolename="manager" />
#<role rolename="admin" />
#<user username="solr" password="je7S9Yad2kAf2Ji0Hen4youd4hog2H" roles="manager,admin" />
#
service tomcat6 restart

echo "--> Installing Apache Commons Loggins..."
http://mirror.cogentco.com/pub/apache/commons/logging/binaries/commons-logging-1.2-bin.tar.gz
tar zxf commons-logging-1.2-bin.tar.gz
cd commons-logging-1.2
cp commons-logging-*.jar /usr/share/tomcat6/lib

echo "Installing SLF4J..."
wget http://www.slf4j.org/dist/slf4j-1.7.10.tar.gz
tar xvf slf4j-1.7.10.tar.gz
cd slf4j-1.7.10
rm -f slf4j-android-*.jar
cp slf4j-*.jar /usr/share/tomcat6/lib

echo "--> Install Solr..."
## Solr 5.0.0 and Haystack are not compatible at the moment due to depreciation issues.

#wget http://mirror.olnevhost.net/pub/apache/lucene/solr/5.0.0/solr-5.0.0.tgz
#tar xvf solr-5.0.0.tgz
#cp solr-5.0.0/dist/solr-*.jar /usr/share/tomcat6/lib
#cp solr-5.0.0/server/webapps/solr.war /usr/share/tomcat6/webapps/solr.war
#mkdir /srv/solr
#cp -R solr-5.0.0/server/solr/* /srv/solr
#chown -R tomcat /srv/solr
#service tomcat6 restart
#vi /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml

wget http://www.eng.lsu.edu/mirrors/apache/lucene/solr/4.9.1/solr-4.9.1.tgz
tar xvf solr-4.9.1.tgz
cp solr-4.9.1/dist/solr-*.jar /usr/share/tomcat6/lib
cp solr-4.9.1/example/webapps/solr.war /srv/solr
chown -R tomcat /srv/solr
service tomcat6 restart
vi /usr/share/tomcat6/webapps/solr/WEB-INF/web.xml

echo "!!!!! TODO - Update solr configuration."
# Update to read (remove the comment tags):
# <env-entry>
#    <env-entry-name>solr/home</env-entry-name>
#    <env-entry-value>/srv/solr</env-entry-value>
#    <env-entry-type>java.lang.String</env-entry-type>
# </env-entry>
service tomcat6 restart

echo "--> Cleaning up..."
cd ~
rm -Rf ~/Install
