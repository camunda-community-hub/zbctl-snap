[![Community Extension](https://img.shields.io/badge/Community%20Extension-An%20open%20source%20community%20maintained%20project-FF4700)](https://github.com/camunda-community-hub/community)
(https://img.shields.io/badge/Lifecycle-Incubating-blue)](https://github.com/Camunda-Community-Hub/community/blob/main/extension-lifecycle.md#incubating-)

# zbctl via Snap

[![zbctl](https://snapcraft.io/zbctl/badge.svg)](https://snapcraft.io/zbctl)
[![zbctl](https://snapcraft.io/zbctl/trending.svg?name=0)](https://snapcraft.io/zbctl)

Zeebe CLI via Snap.

This is the command-line client for [Camunda Cloud](https://camunda.com), packaged for installation on Linux via [Snap](https://snapcraft.io/about).

## Installation

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/zbctl)

```bash
sudo snap install zbctl
```

## Usage

```
zbctl [options] [command]
```

```
zbctl is a command line interface for Camunda Cloud designed to create and read resources inside a Zeebe broker.
It can be used for regular development and maintenance tasks such as:
        * Deploying processes
        * Creating process instances and job workers
        * Activating, completing, or failing jobs
        * Updating variables and retries
        * Viewing cluster status

Usage:
  zbctl [command]

Available Commands:
  activate    Activate a resource
  cancel      Cancel resource
  complete    Complete a resource
  create      Create resources
  deploy      Creates new workflow defined by provided BPMN or YAML file as workflowPath
  fail        Fail a resource
  generate    Generate documentation
  help        Help about any command
  publish     Publish a message
  resolve     Resolve a resource
  set         Set a resource
  status      Checks the current status of the cluster
  update      Update a resource
  version     Print the version of zbctl

Flags:
      --address string        Specify a contact point address. If omitted, will read from the environment variable 'ZEEBE_ADDRESS' (default '127.0.0.1:26500')
      --audience string       Specify the resource that the access token should be valid for. If omitted, will read from the environment variable 'ZEEBE_TOKEN_AUDIENCE'
      --authzUrl string       Specify an authorization server URL from which to request an access token. If omitted, will read from the environment variable 'ZEEBE_AUTHORIZATION_SERVER_URL' (default "https://login.cloud.camunda.io/oauth/token/")
      --certPath string       Specify a path to a certificate with which to validate gateway requests. If omitted, will read from the environment variable 'ZEEBE_CA_CERTIFICATE_PATH'
      --clientCache string    Specify the path to use for the OAuth credentials cache. If omitted, will read from the environment variable 'ZEEBE_CLIENT_CONFIG_PATH' (default "/Users/sitapati/.camunda/credentials")
      --clientId string       Specify a client identifier to request an access token. If omitted, will read from the environment variable 'ZEEBE_CLIENT_ID'
      --clientSecret string   Specify a client secret to request an access token. If omitted, will read from the environment variable 'ZEEBE_CLIENT_SECRET'
  -h, --help                  help for zbctl
      --insecure              Specify if zbctl should use an unsecured connection. If omitted, will read from the environment variable 'ZEEBE_INSECURE_CONNECTION'

Use "zbctl [command] --help" for more information about a command.
```

## Update

If you want to submit a PR to update the package with a newer version of `zbctl`, you need to:

1. Update the package version in `snap/snapcraft.yaml` to match the Zeebe release version number from the [Zeebe release page](https://github.com/camunda-cloud/zeebe/releases).
2. Update the `source-checksum` with the value of the `camunda-cloud-zeebe-*.tar.gz.sha1sum` file from the [Zeebe release page](https://github.com/camunda-cloud/zeebe/releases).
