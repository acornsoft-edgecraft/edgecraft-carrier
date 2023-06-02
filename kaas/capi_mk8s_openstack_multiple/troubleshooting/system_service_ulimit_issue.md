## process max open files with systemd

> [참고] https://www.jacobbaek.com/1338
/etc/security/limits.conf 내에 nofile 을 변경했음에도 특정 프로세스는 적용이 안되었다

## 이슈 확인

```sh
## step-1. 설정값 확인
$ ulimit -Hn
102400
$ ulimit -Hn
102400
$ vi /etc/security/limits.conf
* hard nofile 102400
* soft nofile 102400
root		hard	nofile		102400
root 		soft	nofile		102400

## step-2. 프로세스 확인
$ systemctl status neutron-dhcp-agent
● neutron-dhcp-agent.service - OpenStack Neutron DHCP agent
     Loaded: loaded (/lib/systemd/system/neutron-dhcp-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-05-03 18:31:29 KST; 2h 9min ago
       Docs: man:neutron-dhcp-agent(1)
   Main PID: 7684 (neutron-dhcp-ag)
      Tasks: 262 (limit: 629145)
     Memory: 372.7M
     CGroup: /system.slice/neutron-dhcp-agent.service
             ├─  7684 neutron-dhcp-agent (/usr/bin/python3 /usr/bin/neutron-dhcp-agent --config-file=/etc/neutron/neutron.conf --config-file=/etc/neutron/dhcp_agent.ini --log-file=/va>
             ├─ 14520 /usr/bin/python3 /usr/bin/privsep-helper --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/dhcp_agent.ini --privsep_context neutron.privileged.d>
             ├─ 14855 haproxy -f /var/lib/neutron/ns-metadata-proxy/15bf1c3d-73a4-42b2-9bda-8174975d6a0c.conf
             ├─ 15309 haproxy -f /var/lib/neutron/ns-metadata-proxy/e01700fd-db44-4321-a2cd-257cad8e2ff9.conf
             ├─ 15474 dnsmasq --no-hosts  --pid-file=/var/lib/neutron/dhcp/22bde283-6d45-4129-bd67-f8281dfc0492/pid --dhcp-hostsfile=/var/lib/neutron/dhcp/22bde283-6d45-4129-bd67-f828>
             ├─ 15484 dnsmasq --no-hosts  --pid-file=/var/lib/neutron/dhcp/29eece34-b1af-43d7-b436-972b0bee0cae/pid --dhcp-hostsfile=/var/lib/neutron/dhcp/29eece34-b1af-43d7-b436-972b>


## step_2-1. 프로세스 설정값 확인
## systemd는 기본적으로 기본값을 따로 가지고 있고 해당 값이 적용되는것으로 보인다.
$ sudo systemctl show -p DefaultLimitNOFILE
DefaultLimitNOFILE=524288
$ cat /proc/<프로세스 ID>/limits  | grep "Max open files"

## step_2-2. 프로세서 설정값 변경
## LimitNOFILE 설정값을 변경 한다.
$ vi /lib/systemd/system/neutron-dhcp-agent.service
...
[Service]
User=neutron
Group=neutron
Type=simple
WorkingDirectory=~
RuntimeDirectory=neutron lock/neutron
CacheDirectory=neutron
ExecStart=/etc/init.d/neutron-dhcp-agent systemd-start
Restart=on-failure
LimitNOFILE=102400
TimeoutStopSec=15
...

## step_2-3. 프로세서 설정 적용
$ systemctl daemon-reload
$ systemctl restart neutron-dhcp-agent.service 
```