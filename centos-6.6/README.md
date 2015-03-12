# Centos 6.6

These scripts help to automate setup of a Centos 6.6-based system for hosting both Python Django apps as well as Wordpress.

It sets up this stack:

- Varnish
- nginx
- php-fpm
- Python
- Django
- gunicorn
- MariaDB

### Basic Setup
Sign in **as root** to your freshly-installed Centos 6.6 server (either at the console or via ssh), and issue the following command:

```bash
curl -s https://raw.githubusercontent.com/andrewmarconi/sysadmin-tools/master/centos-6.6/setup-part1.sh | bash
```

### Additional Tools
This script installs and configures Solr, Tomcat, Java, and Postgresql. Not really important for the basic stack, but included
here in case I need it.

```bash
curl -s https://raw.githubusercontent.com/andrewmarconi/sysadmin-tools/master/centos-6.6/setup-part2.sh | bash
```


### Setting Up a Non-Root User

```bash
useradd yourname
passwd yourname
usermod -G wheel yourname
visudo
```

Then uncomment the line:
```bash
# %wheel  ALL=(ALL)       ALL
```
This will let the user sudo to root.


