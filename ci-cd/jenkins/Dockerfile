FROM jenkins/jenkins:latest

USER root

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && \
  apt-get install -y \
  nodejs \
  jq \
  libltdl7 \
  curl \
  wget \
  bzip2 \
  gnupg \
  python-pip \
  python-setuptools \
  git \
  subversion \
  unzip \
  apt-transport-https \
  ca-certificates \
  curl \
  kubectl \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-18.06.1-ce.tgz && \
  curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  tar --strip-components=1 -xvzf docker-18.06.1-ce.tgz -C /usr/local/bin

RUN groupadd -g 999 docker && \
  usermod -aG docker jenkins

# USER jenkins
