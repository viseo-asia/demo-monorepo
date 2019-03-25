FROM ubuntu

# REF: https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/how-to-install-apache-svn-on-ubuntu-18-04.html

RUN apt-get update && \
    apt-get install -y apache2 apache2-utils wget curl && \
    apt-get install -y subversion subversion-tools libapache2-mod-svn && \
    rm -rf /var/lib/apt/lists/*

COPY startup.sh /startup.sh
COPY dav_svn.conf /etc/apache2/mods-enabled/dav_svn.conf

RUN chmod +x /startup.sh

CMD ["/startup.sh"]
