# Using Ansible's GCP Module to Provision a Kubernetes Cluster in Google Cloud

## Tutorial

For a full tutorial on using Ansible to provision a Kubernetes cluster on Google Cloud, check out Dzero Labs' [blog post](https://medium.com/@dee_zero/6fd1910f1700?source=friends_link&sk=2a6334af25a2e16d0c9cc34ad063c63f) on Medium.

Be sure to also check out our post on [Shifting from Infrastructure as Code to Infrastructure as Data](https://medium.com/@dee_zero/bdb1ae1840e3?source=friends_link&sk=4416407624889f0139bcb1d5b15ec1bb).

## Quickstart

If you'd like to skip the tutorial altogether, you can use the quickstart guide below.

For your convenience, I've created a `Dockerfile` with `Ansible` and the `gcloud` CLI installed.

### Pre-requisites
* A Google Cloud project
* A Google Cloud service account
* [Docker](https://www.docker.com) installed on your local machine

### 1- Set up project values

You must replace the following values in `setup.sh`:

* `<gcp_project_name>`: Your own GCP project name
* `<service_account_name>`: Name of your GCP service account
* `<service_account_private_key_json>`: Fully-qualified name of your Google Service Account's private key JSON file (e.g. `/home/myuser/my-sa.json` or `./my-sa.json`)

Next, run the following script:

```bash
./setup.sh
```

This will replace the values you set above with your own GCP project's values in `playbook.yml` and `startup.sh`.

### 2- Build the Dockerfile

```bash
docker build -t docker-ansible:1.0.0 docker
```

### 2- Start the container instance

Run the container instance. Here, we're mapping the `ansible` folder on our host machine to the `/workdir/ansible` folder in the container instance.

```bash
docker run -it --rm \
    -v $(pwd)/ansible:/workdir/ansible \
    docker-ansible:1.0.0 /bin/bash
```

### 3- Run the playbook

This playbook will create a GKE cluster and node pool, and update the *container instance's* `kubeconfig` so that you can connect to the cluster.

From within the container instance run the following command:

```bash
./startup.sh && ansible-playbook -vv --extra-vars cluster_state=present ansible/playbook.yml
```

To delete the cluster and node pool, run the following command from within the container instance:

```bash
./startup.sh && ansible-playbook -vv --extra-vars cluster_state=absent ansible/playbook.yml
