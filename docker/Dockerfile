FROM python:3.9.4-slim-buster

# Install curl (required for gcloud CLI install) and envsubst
RUN apt-get update && apt-get install -y \
    curl \
    gettext-base \
  && rm -rf /var/lib/apt/lists/*

# Install gcloud (https://stackoverflow.com/a/53501128)
RUN apt-get update && apt-get install -y apt-transport-https gnupg curl lsb-release
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
  echo "cloud SDK repo: $CLOUD_SDK_REPO" && \
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update -y && apt-get install google-cloud-sdk -y

# Install kubectl from Docker Hub (https://www.jeffgeerling.com/blog/2018/install-kubectl-your-docker-image-easy-way)
COPY --from=lachlanevenson/k8s-kubectl:v1.10.3 /usr/local/bin/kubectl /usr/local/bin/kubectl

# Upgrade pip & install Ansible
 RUN python -m pip install --upgrade pip \
   && pip install ansible requests google-auth

# Install Ansible GCP modules
RUN ansible-galaxy collection install google.cloud

ENV WORKDIR="/workdir"
RUN mkdir -p ${WORKDIR}/ansible \
  && mkdir -p ${WORKDIR}/manifest
WORKDIR ${WORKDIR}

COPY startup.sh .
RUN chmod 755 startup.sh

CMD ["/bin/bash"]
