#!/bin/bash

## token 무제한 설정
## kubectl --kubeconfig=./kubeconfig -n kubernetes-dashboard edit deployment kubernetes-dashboard
## 
##	      containers:
##	        ...
##	        args:
##	          - --auto-generate-certificates
##	          - --namespace=kubernetes-dashboard
##	          - --token-ttl=0  # 이부분 추가 (0은 무제한)


## NodePort 사용 
## kubectl --kubeconfig=./kubeconfig -n kubernetes-dashboard edit svc kubernetes-dashboard
##
## ...
## nodePort: 31174
## type: NodePort 로 변경
##

## 사용자 토큰 확인
## kubectl --kubeconfig=./kubeconfig -n kubernetes-dashboard describe secret $(kubectl --kubeconfig=./kubeconfig -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

## 대시보드 UI 배포
kubectl --kubeconfig=./kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml

## token 발행
kubectl --kubeconfig=./kubeconfig -n kubernetes-dashboard create token admin-user

## secret 생성
cat <<EOF | kubectl --kubeconfig=./kubeconfig create -f -
apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  annotations:  
    kubernetes.io/service-account.name: admin-user
  name: admin-user
  namespace: kubernetes-dashboard
data:
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklqVXpaelZrVFdoUGNWcHFXWFZ3VUdGalVYUmpSSFJ4YVZkdk5FOVJaMVZVV1dwbWVGazNlbkZtY2xraWZRLmV5SmhkV1FpT2xzaWFIUjBjSE02THk5cmRXSmxjbTVsZEdWekxtUmxabUYxYkhRdWMzWmpMbU5zZFhOMFpYSXViRzlqWVd3aVhTd2laWGh3SWpveE5qZ3hPVFkwTnpVeUxDSnBZWFFpT2pFMk9ERTVOakV4TlRJc0ltbHpjeUk2SW1oMGRIQnpPaTh2YTNWaVpYSnVaWFJsY3k1a1pXWmhkV3gwTG5OMll5NWpiSFZ6ZEdWeUxteHZZMkZzSWl3aWEzVmlaWEp1WlhSbGN5NXBieUk2ZXlKdVlXMWxjM0JoWTJVaU9pSnJkV0psY201bGRHVnpMV1JoYzJoaWIyRnlaQ0lzSW5ObGNuWnBZMlZoWTJOdmRXNTBJanA3SW01aGJXVWlPaUpoWkcxcGJpMTFjMlZ5SWl3aWRXbGtJam9pTWpZMk9HSTFNMll0WldZNFpDMDBaV1ZpTFdFMlpqQXROMlJoTUdZNE56UTBOR0pqSW4xOUxDSnVZbVlpT2pFMk9ERTVOakV4TlRJc0luTjFZaUk2SW5ONWMzUmxiVHB6WlhKMmFXTmxZV05qYjNWdWREcHJkV0psY201bGRHVnpMV1JoYzJoaWIyRnlaRHBoWkcxcGJpMTFjMlZ5SW4wLkwwY1RNRmJ5UGZSbWY1VnNrSXlIOHJoNUpiNUdkUkdIekJBbXZJUVBlUjNlQjhYRjU5UEN5OU5GY2d6NkpvNjhOU0tpN2RlZDNXZFZxZU9wYnRBQlJ1U081MnZnbzRXRGNIRDlodWJKczl6aGlja1VMaUdjRVlUVjY2c2hENVJGT2RvYlZLZDdIRkZHSjJFRzVubVVhNWtwQ0JJd1U0eEdvX0x5QzM5NjZnb0NSQVpuZ3JBTU9EVWNGWmxIUTJ1elh2cmtpclVJNDhwbDMyYm96NkltaUJucFZVSHprU3RhdFNFN0M2d2lkNGRUb1E0VnRHSzc3dERoZXVVUTVaUl9BM1dmRWNYM00wTDdJV3BSY1BnRFBsTFNlZ203aWV6djdpM0xobXM2dnFUZU5mVFZXdHFScWlZU2x1RUw5SGhsVkZrU01keGxxb3RJZEtDSm9rYWZSQQo=
type: kubernetes.io/service-account-token
EOF

 kubectl -n kubernetes-dashboard create secret generic admin-user --from-literal=token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjUzZzVkTWhPcVpqWXVwUGFjUXRjRHRxaVdvNE9RZ1VUWWpmeFk3enFmclkifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjgxOTY0NzUyLCJpYXQiOjE2ODE5NjExNTIsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJhZG1pbi11c2VyIiwidWlkIjoiMjY2OGI1M2YtZWY4ZC00ZWViLWE2ZjAtN2RhMGY4NzQ0NGJjIn19LCJuYmYiOjE2ODE5NjExNTIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbi11c2VyIn0.L0cTMFbyPfRmf5VskIyH8rh5Jb5GdRGHzBAmvIQPeR3eB8XF59PCy9NFcgz6Jo68NSKi7ded3WdVqeOpbtABRuSO52vgo4WDcHD9hubJs9zhickULiGcEYTV66shD5RFOdobVKd7HFFGJ2EG5nmUa5kpCBIwU4xGo_LyC3966goCRAZngrAMODUcFZlHQ2uzXvrkirUI48pl32boz6ImiBnpVUHzkStatSE7C6wid4dToQ4VtGK77tDheuUQ5ZR_A3WfEcX3M0L7IWpRcPgDPlLSegm7iezv7i3Lhms6vqTeNfTVWtqRqiYSluEL9HhlVFkSMdxlqotIdKCJokafRA --type=kubernetes.io/service-account-token

## Serviceaccount생성
cat <<EOF | kubectl --kubeconfig=./kubeconfig create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: admin-user
  namespace: kubernetes-dashboard
secrets:
- name: admin-user
EOF

## 권한을 생성해 준다. cluster-admin이라는 role이 모든 권한을 가지고 있다.
cat <<EOF | kubectl --kubeconfig=./kubeconfig create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
EOF
