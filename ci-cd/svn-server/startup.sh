#!/bin/bash

set -e

if [ ! -f /opt/svn/initialized ]; then
  echo 'Initialization...'
  chown -R www-data /opt/svn
  svnadmin create /opt/svn/demo-repo
  htpasswd -cmb /opt/svn/dav_svn.passwd admin admin
  touch /opt/svn/initialized
fi

apachectl -D FOREGROUND
