#!/bin/sh

# install argocd to kubernetes using helm
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" --kubeconfig ../../88apps.kubeconfig | base64 -d

# 초기 비밀번호 변경
# $ kubectl exec -it -n argocd deployment/argocd-server --kubeconfig ../../88apps.kubeconfig -- /bin/bash
# $ argocd login localhost:8080
# Username: admin
# Password: <초기 비밀번호>

# $ argocd account update-password
# *** Enter password of currently logged in user (admin): <초기 비밀번호>
# *** Enter new password for user admin: <new password>
# *** Confirm new password for user admin: <new password>
# Password updated
# Context 'localhost:8080' updated