## capi bootstrap 이 진행되지 않느 현상 발생

- 시스템 로그
```sh
## 시스템로그에서 호스트 네임이 변경되지 않은것을 확인했다.

Apr 19 17:17:01 ubuntu20-04-mirror CRON[1589]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Apr 19 17:59:22 ubuntu20-04-mirror systemd[1]: fwupd.service: Succeeded.
Apr 19 18:11:17 ubuntu20-04-mirror systemd[1]: Starting Daily apt download activities...
Apr 19 18:11:17 ubuntu20-04-mirror systemd[1]: Starting Update APT News...
Apr 19 18:11:17 ubuntu20-04-mirror systemd[1]: Starting Update the local ESM caches...
Apr 19 18:11:19 ubuntu20-04-mirror systemd[1]: apt-news.service: Succeeded.
Apr 19 18:11:19 ubuntu20-04-mirror systemd[1]: Finished Update APT News.
Apr 19 18:11:20 ubuntu20-04-mirror systemd[1]: esm-cache.service: Succeeded.
Apr 19 18:11:20 ubuntu20-04-mirror systemd[1]: Finished Update the local ESM caches.
Apr 19 18:11:27 ubuntu20-04-mirror dbus-daemon[805]: [system] Activating via systemd: service name='org.freedesktop.PackageKit' unit='packagekit.service' requested by ':1.17' (uid=0 pid=2021 comm="/usr/bin/gdbus call --system --dest org.freedeskto" label="unconfined")
Apr 19 18:11:27 ubuntu20-04-mirror systemd[1]: Starting PackageKit Daemon...
Apr 19 18:11:27 ubuntu20-04-mirror PackageKit: daemon start
Apr 19 18:11:27 ubuntu20-04-mirror dbus-daemon[805]: [system] Successfully activated service 'org.freedesktop.PackageKit'
Apr 19 18:11:27 ubuntu20-04-mirror systemd[1]: Started PackageKit Daemon.
Apr 19 18:11:51 ubuntu20-04-mirror systemd[1]: apt-daily.service: Succeeded.
Apr 19 18:11:51 ubuntu20-04-mirror systemd[1]: Finished Daily apt download activities.
Apr 19 18:16:32 ubuntu20-04-mirror PackageKit: daemon quit
Apr 19 18:16:32 ubuntu20-04-mirror systemd[1]: packagekit.service: Succeeded.
Apr 19 18:17:01 ubuntu20-04-mirror CRON[2162]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Apr 19 19:17:01 ubuntu20-04-mirror CRON[2175]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Apr 19 19:44:19 ubuntu20-04-mirror snapd[822]: storehelpers.go:769: cannot refresh: snap has no updates available: "core18", "core20", "lxd", "snapd"
Apr 19 19:44:19 ubuntu20-04-mirror snapd[822]: autorefresh.go:551: auto-refresh: all snaps are up-to-date
Apr 19 20:17:01 ubuntu20-04-mirror CRON[2186]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Apr 19 21:17:01 ubuntu20-04-mirror CRON[2197]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
```

- 해결 방법
```sh
## 임시 방법
# 오픈스택 인스탄스를 하드 리부팅 하면 해결 된다.
# 원인 파악중...
```