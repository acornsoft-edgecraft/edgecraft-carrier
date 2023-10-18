
# Backup/Restore 확인 

## Prerequisites

### kubeconfig 설정

- `backup-cloud.kubconfig`

- `restore-cloud.kubeconfig`


## 백업용 클라우드에 `nginx` 배포

```bash
./apply-nginx.sh
```

## 백업 & 복원용 클라우드 리소스 확인

```bash
./check-backup-restore.sh
```
