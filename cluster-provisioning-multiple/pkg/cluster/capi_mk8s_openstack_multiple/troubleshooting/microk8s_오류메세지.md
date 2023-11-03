```log
● snap.microk8s.daemon-k8s-dqlite.service - Service for snap application microk8s.daemon-k8s-dqlite
     Loaded: loaded (/etc/systemd/system/snap.microk8s.daemon-k8s-dqlite.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-05-30 05:33:58 UTC; 53min ago
   Main PID: 2729 (k8s-dqlite)
      Tasks: 14 (limit: 2344)
     Memory: 234.7M
     CGroup: /system.slice/snap.microk8s.daemon-k8s-dqlite.service
             └─2729 /snap/microk8s/4916/bin/k8s-dqlite --storage-dir=/var/snap/microk8s/4916/var/kubernetes/backend/ --listen=unix:///var/snap/microk8s/4916/var/kubernetes/backend/kine.sock:12379

May 30 05:49:17 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:49:17Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
May 30 05:53:33 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:53:24Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
May 30 05:53:33 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:53:24Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
May 30 05:53:33 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:53:24Z" level=error msg="error in txn: query (try: 0): context canceled"
May 30 05:53:34 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:53:34Z" level=error msg="error in txn: query (try: 0): context canceled"
May 30 05:53:37 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:53:37Z" level=error msg="error in txn: query (try: 0): context canceled"
May 30 05:55:59 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:55:59Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
May 30 05:56:02 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:56:00Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
May 30 05:56:02 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: I0530 05:56:00.103991    2729 log.go:181] [ERROR] dqlite: proxy: first: remote -> local: local error: tls: bad record MAC
May 30 05:56:02 mk8s-os-cluster-44-control-plane-76szv microk8s.daemon-k8s-dqlite[2729]: time="2023-05-30T05:56:02Z" level=error msg="error in txn: query (try: 0): context deadline exceeded"
```