## OpenStack 플랫폼의 서브넷에 대한 Dnsmasq 확장 제한

> [참고] https://access.redhat.com/solutions/3228801
> [참고] https://cloud.ibm.com/docs/containers?topic=containers-changelog_126&locale=ko#1263_1533


### 문제

- fs.inotify.max_user_instance기본적으로 커널 매개변수 값이 128로 설정되어 있기 때문에 기본적으로 클라우드에서 생성할 수 있는 총 서브넷 수는 128개 미만으로 제한됩니다.

```sh
## step-1. 확인
$ ls -al /var/lib/neutron/dhcp | wc -l
# 또는
$ lsof -u nobody | grep inotify | wc -l

## step-2. 설정값 확인
$ sysctl -a | grep "fs.inotify.max_user_instances"
fs.inotify.max_user_instances = 128

## step-2-1. 설정값 변경
$ sysctl -w fs.inotify.max_user_instances=1024 >> /etc/sysctl.conf
```

- 에러 내용

```log
May  3 08:12:41 k3lab-main dnsmasq[57976]: failed to create inotify: Too many open files
May  3 08:12:41 k3lab-main dnsmasq[57976]: FAILED to start up
```