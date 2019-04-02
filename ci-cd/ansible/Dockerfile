FROM alpine

COPY playbooks /opt/ansible/playbooks
COPY ansible.cfg /root/ansible.cfg
COPY ssh /root/.ssh
ADD https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.2-amd64.tgz?spm=a2c63.p38356.a3.2.6a49f09ddVHglw&file=aliyun-cli-linux-3.0.2-amd64.tgz /tmp/aliyun.tar.gz

RUN apk add --no-cache \
    ansible \
    openssh \
    openssh-server \
    bash \
    git \
    python \
    perl \
    alpine-sdk \
    nodejs \
    py2-pip \
    curl \
    jq && \
    chmod -R o-rwx /root/.ssh && \
    chmod -R g-rwx /root/.ssh && \
    chmod +x /opt/ansible/execute-playbook.sh && \
    mkdir -p /var/run/sshd && \
    /usr/bin/ssh-keygen -A && \
    cd /tmp && \
    tar xzf aliyun.tar.gz && \
    cp aliyun /usr/local/bin && \
    chmod +x /usr/local/bin/aliyun && \
    pip --no-cache-dir install awscli && \
    rm -rf /tmp/*

WORKDIR /opt/ansible

CMD ["/usr/sbin/sshd", "-D"]