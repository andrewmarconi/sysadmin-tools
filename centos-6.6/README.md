# Centos 6.6

These scripts help to automate setup of Centos 6.6-based systems for hosting Python Django applications under gunicorn, nginx, and Postgres.

These are a few things you need to do manually that are documented at the end of each script. Eventually, I'll automate this, but at the moment, this is sufficient to save some time while doing a deployment.

There are two parts, the first sets does a lot of the core installation, updates and compilation. Part 2 handles installing some Python tools and installs Postgres.
