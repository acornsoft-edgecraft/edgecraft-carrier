# Edgecraft-Carrier

Edgecraft-Carrier is based on Helm charts, allowing you to configure platform applications according to their mutual dependencies and install them on a Kubernetes cluster.

## Features
- Install/Uninstall platform applications

## Required packages
 * Podman(container tools) - This is required, if not installed it will be installed automatically.

## go-ansible 
Go-ansible is a package for running ansible-playbook or ansible commands from Golang applications.

## Getting Start

Edgecraft-Carrier는 Kubernetes cluster에서 사용할 수 있는 상호 의존성 관계의 애플리케이션들을 설치/삭제 할 수 있다.

### You can install/uninstall platform applications with dependency relationships using Edgecraft-Carrier.

- Kore-on 명령어: carrierctl
This command deploys the application to Kubernetes. Use helm as the package manager for Kubernetes.


| CMD        | 설명                    |
|:-----------:|:------------------------|
| init | Get Addon configuration file |
| addon | Deployment Applications in kubernetes cluster |

-----
## Documents

- See our documentation in the /docs repository, please [find the index here](/docs/README.md).