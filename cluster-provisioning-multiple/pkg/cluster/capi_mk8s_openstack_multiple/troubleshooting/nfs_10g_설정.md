## nfs 네트워크 성능 튜닝

NFS (Network File System)는 클라이언트와 서버 간의 파일 공유를 가능하게 해주는 프로토콜입니다. 10G 네트워크를 사용할 경우 클라이언트 설정에 대해 알아보겠습니다

- 1. NIC 설정 확인
먼저 클라이언트 컴퓨터에 사용하는 NIC(Network Interface Card)가 10Gbps를 지원하는지 확인해야 합니다. 이를 확인하는 방법은 다음과 같습니다.

```sh
$ sudo ethtool <NIC name>
```
- 2. 


- 1. NIC 설정 확인
먼저 클라이언트 컴퓨터에 사용하는 NIC(Network Interface Card)가 10Gbps를 지원하는지 확인해야 합니다. 이를 확인하는 방법은 다음과 같습니다.
```sh
## NIC 이름은 ifconfig 명령어로 확인할 수 있습니다. 해당 명령어를 실행하면 NIC의 속성이 출력되는데, 이 중에 Speed 항목이 10000Mb/s로 표시되어야 합니다.
$ sudo ethtool <NIC name>
```

- 2. MTU 설정
NFS는 TCP/IP 프로토콜 위에서 동작하므로, MTU(Maximum Transmission Unit)를 설정해야 합니다. MTU는 네트워크 패킷의 최대 크기를 의미하며, 10Gbps 네트워크에서는 9000바이트로 설정하는 것이 일반적입니다. MTU를 설정하는 방법은 다음과 같습니다.

```sh
$ sudo ifconfig <NIC name> mtu 9000
```

- 3. NFS 설정
NFS 설정 파일인 /etc/fstab 파일에 다음과 같이 옵션을 추가해야 합니다.

```sh
## 옵션에서 rsize와 wsize는 NFS 패킷의 크기를 의미하며, 32768로 설정하는 것이 좋습니다. proto는 TCP를 사용하도록 설정하고, nfsvers는 NFS 버전을 3으로 설정합니다. timeo는 응답 대기 시간을 설정하는데, 600으로 설정하는 것이 일반적입니다. 마지막으로 _netdev, hard, intr, noatime 옵션을 추가해야 합니다.

$ vi /etc/fstab
<server IP>:/<exported directory> <mount point> nfs rsize=32768,wsize=32768,proto=tcp,nfsvers=3,timeo=600,_netdev,hard,intr,noatime 0 0
```

- 4. NFS 서비스 재시작
설정 변경 후에는 NFS 서비스를 재시작해야 합니다.
```sh
## 위와 같이 클라이언트 설정을 변경하면 10G 네트워크에서 NFS를 사용할 수 있습니다.

$ sudo systemctl restart nfs-client.target
```




