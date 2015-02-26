# Centos 6.6

These scripts help to automate setup of Centos 6.6-based systems for hosting Python Django applications under gunicorn, nginx, and Postgres.

These are a few things you need to do manually that are documented at the end of each script. Eventually, I'll automate this, but at the moment, this is sufficient to save some time while doing a deployment.

There are two parts, the first sets does a lot of the core installation, updates and compilation. Part 2 handles installing some Python tools and installs Postgres.


### Step 1
To use, sign in to your freshly-installed Centos 6.6 server, and issue the following command as root:

```bash
curl -s https://raw.githubusercontent.com/andrewmarconi/sysadmin-tools/master/centos-6.6/setup-part1.sh | bash
```


### Step 2
Update your ~/.bash_profile to place /usr/local/bin at the beginning.

    PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:$HOME/bin


### Step 3
Disable the default PostgreSQL packages in CentOS-Base to prep for installation from the most recent stable source. Edit the repo file:
```bash
vi /etc/yum.repos.d/CentOS-Base.repo
```
Then, add 'exclude=postgresql*' to the bottom of both the [base] and [updates] sections. Save the file and exit out.

### Step 4
```bash
curl -s https://raw.githubusercontent.com/andrewmarconi/sysadmin-tools/master/centos-6.6/setup-part2.sh | bash
```

### TODO
* Configure nginx
* Configure gunicorn
* Init virtualenv and handle deployment

