FROM ubuntu:22.04

ARG ANSIBLE_CORE_VERSION=2.15.5
ARG ANSIBLE_VERSION=8.5.0
ARG ANSIBLE_LINT=6.21.1
ENV ANSIBLE_CORE_VERSION ${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}
ENV ANSIBLE_LINT ${ANSIBLE_LINT}

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends vim gnupg2 python3-pip sshpass git openssh-client curl \
    linux-headers-generic gcc build-essential python2 python2-dev libffi-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean



RUN python3 -m pip install --upgrade pip cffi && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} && \
    pip3 install ansible-pylibssh && \
    pip3 install ansible-lint && \
    pip3 install jupyter && \
    pip3 install jupyter_client && \
    pip3 install ansible-jupyter-widgets && \
    pip3 install ipython && \
    pip3 install ansible_kernel && \
    python3 -m ansible_kernel.install

COPY ./ansible_collections /tmp
RUN ansible-galaxy collection install cisco.iosxr
RUN ansible-galaxy collection install --force /tmp/junipernetworks.junos
RUN ansible-galaxy collection install --force /tmp/cisco.ios
# RUN pip install -e /tmp/ansible-jupyter-kernel/. && python -m ansible_kernel.install

WORKDIR /ansible

RUN mkdir -p /etc/ansible

RUN /bin/echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

RUN mkdir -m 700 /root/.jupyter

COPY --chmod=644 jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /root/.ansible/roles

RUN ln -s /usr/local/lib/python3.10/dist-packages/ansible_kernel/roles/ansible_kernel_helpers /root/.ansible/roles/ansible_kernel_helpers

EXPOSE 8888

CMD [ "jupyter-notebook", "--ip", "0.0.0.0", "--no-browser", "--allow-root", "--notebook-dir=/ansible" ]
