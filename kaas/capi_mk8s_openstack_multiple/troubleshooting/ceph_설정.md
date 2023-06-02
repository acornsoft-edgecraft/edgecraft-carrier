# Ceph 설정

## ceph 설정이 서버 재부팅 되면 사라지는가?

```sh
[global]
fsid = 659018a6-ae80-11ed-8e3c-8b661d437487
mon_host = [v2:192.168.88.11:3300/0,v1:192.168.88.11:6789/0]
public_network = 192.168.88.0/24
cluster_network = 192.168.222.0/24

[mon.k3lab-ml]
host = k3lab-ml
mon_addr = 192.168.88.11

[mon.k3lab-main]
host = k3lab-main
mon_addr = 192.168.88.12

[osd.0]
host = k3lab-ml
public_addr = 192.168.88.11
cluster_addr = 192.168.222.11

[osd.1]
host = k3lab-main
public_addr = 192.168.88.12
cluster_addr = 192.168.222.12

[osd.2ce]
host = k3lab-ml
public_addr = 192.168.88.11
cluster_addr = 192.168.222.11
```