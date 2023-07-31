# Cert-manager with Helm

## Installing with Helm

### Add Helm repository and Download charts
```sh
## step-1. Add chart repository
$ 
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
$ helm search repo jetstack

# download charts
## Usage:
##  helm pull [chart URL | repo/chartname] [...] [flags]
$ VERSION="1.12.0"
$ helm pull jetstack/cert-manager --untar -d ./assets --version ${VERSION}
```

### Installataion

```sh
## step-1. install using helm
### Usage:
###   helm upgrade [RELEASE] [CHART] [flags]
# helm upgrade harbor kore/harbor \
helm upgrade cert-manager ./assets/cert-manager \
    --install \
    --reset-values \
    --atomic \
    --no-hooks \
    --create-namespace \
    --kubeconfig ${KUBECONFIG} \
    --namespace ${NAMESPACE} \
    --values ${CART_VALUES} \
    --version ${VERSION}
```

### Configuration

```sh
## step-1. install CRDs as part of the Helm release
--set installCRDs=true

```