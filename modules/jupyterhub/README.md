# JupyterHub deployment as part of JHaaS

This module takes care of deploying JupyterHub in a Kubernetes cluster.

It supports definining the docker image user notebooks should be based on,
and OIDC authentication configuration.

## Input variables

#### dns name

The given name is used in the ingress definition for the hub. It will also be
used with cert manager to create TLS certifcates on the fly.

#### kubeconfig

Kubernetes configuration to use

#### spawner_image

Dokcer image to use with KubeSpawner, defaults to latest minimal notebook image


