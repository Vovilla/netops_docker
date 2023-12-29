FROM ubuntu:22.04

ARG ANSIBLE_CORE_VERSION=2.15.5
ARG ANSIBLE_VERSION=8.5.0
ARG ANSIBLE_LINT=6.21.1
ENV ANSIBLE_CORE_VERSION ${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}
ENV ANSIBLE_LINT ${ANSIBLE_LINT}

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y vim gnupg2 python3-pip sshpass git openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN python3 -m pip install --upgrade pip cffi && \  
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} && \
    pip3 install ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install ansible-pylibssh

COPY ./ansible_collections /tmp
RUN ansible-galaxy collection install --force /tmp/junipernetworks.junos
RUN ansible-galaxy collection install --force /tmp/cisco.ios

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
