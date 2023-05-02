# Horizon 접속 실패

### 에러 메시지

- apache2 log
```sh
[Fri Mar 24 06:10:30.985225 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277] ERROR django.request Internal Server Error: /horizon/auth/login/
[Fri Mar 24 06:10:30.985304 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277] Traceback (most recent call last):
[Fri Mar 24 06:10:30.985313 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/core/handlers/exception.py", line 34, in inner
[Fri Mar 24 06:10:30.985319 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = get_response(request)
[Fri Mar 24 06:10:30.985324 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/core/handlers/base.py", line 115, in _get_response
[Fri Mar 24 06:10:30.985330 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = self.process_exception_by_middleware(e, request)
[Fri Mar 24 06:10:30.985335 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/core/handlers/base.py", line 113, in _get_response
[Fri Mar 24 06:10:30.985353 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = wrapped_callback(request, *callback_args, **callback_kwargs)
[Fri Mar 24 06:10:30.985359 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/decorators/debug.py", line 76, in sensitive_post_parameters_wrapper
[Fri Mar 24 06:10:30.985364 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return view(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985385 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/utils/decorators.py", line 142, in _wrapped_view
[Fri Mar 24 06:10:30.985390 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = view_func(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985395 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/decorators/cache.py", line 44, in _wrapped_view_func
[Fri Mar 24 06:10:30.985403 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = view_func(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985407 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/openstack_auth/views.py", line 143, in login
[Fri Mar 24 06:10:30.985412 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     res = django_auth_views.LoginView.as_view(
[Fri Mar 24 06:10:30.985417 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/generic/base.py", line 71, in view
[Fri Mar 24 06:10:30.985422 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return self.dispatch(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985427 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/utils/decorators.py", line 45, in _wrapper
[Fri Mar 24 06:10:30.985431 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return bound_method(*args, **kwargs)
[Fri Mar 24 06:10:30.985436 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/decorators/debug.py", line 76, in sensitive_post_parameters_wrapper
[Fri Mar 24 06:10:30.985442 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return view(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985447 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/utils/decorators.py", line 45, in _wrapper
[Fri Mar 24 06:10:30.985452 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return bound_method(*args, **kwargs)
[Fri Mar 24 06:10:30.985456 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/utils/decorators.py", line 142, in _wrapped_view
[Fri Mar 24 06:10:30.985461 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = view_func(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985466 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/utils/decorators.py", line 45, in _wrapper
[Fri Mar 24 06:10:30.985471 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return bound_method(*args, **kwargs)
[Fri Mar 24 06:10:30.985475 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/decorators/cache.py", line 44, in _wrapped_view_func
[Fri Mar 24 06:10:30.985480 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     response = view_func(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985485 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/contrib/auth/views.py", line 61, in dispatch
[Fri Mar 24 06:10:30.985490 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return super().dispatch(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985495 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/generic/base.py", line 97, in dispatch
[Fri Mar 24 06:10:30.985503 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return handler(request, *args, **kwargs)
[Fri Mar 24 06:10:30.985508 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/views/generic/edit.py", line 142, in post
[Fri Mar 24 06:10:30.985513 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     return self.form_valid(form)
[Fri Mar 24 06:10:30.985517 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/contrib/auth/views.py", line 90, in form_valid
[Fri Mar 24 06:10:30.985523 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     auth_login(self.request, form.get_user())
[Fri Mar 24 06:10:30.985528 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/contrib/auth/__init__.py", line 108, in login
[Fri Mar 24 06:10:30.985532 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     request.session.cycle_key()
[Fri Mar 24 06:10:30.985537 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/contrib/sessions/backends/base.py", line 297, in cycle_key
[Fri Mar 24 06:10:30.985542 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     self.create()
[Fri Mar 24 06:10:30.985547 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]   File "/usr/lib/python3/dist-packages/django/contrib/sessions/backends/cache.py", line 50, in create
[Fri Mar 24 06:10:30.985552 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277]     raise RuntimeError(
[Fri Mar 24 06:10:30.985556 2023] [wsgi:error] [pid 1667519:tid 139904763131648] [remote 192.168.1.8:53277] RuntimeError: Unable to create a new session key. It is likely that the cache is unavailable.
```

- memcache 상태 정보
```sh
## 상태 정보로 유추 했을때 캐시 메모리 부족으로 판다.
## memcached 캐시 메모리를 64 -> 512로 변경 예정
15:31 root@k3lab-ml:/var/log> systemctl status memcached.service
● memcached.service - memcached daemon
     Loaded: loaded (/lib/systemd/system/memcached.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2023-03-16 20:32:13 KST; 1 weeks 0 days ago
       Docs: man:memcached(1)
   Main PID: 2726 (memcached)
      Tasks: 10 (limit: 629145)
     Memory: 35.9M
     CGroup: /system.slice/memcached.service
             └─2726 /usr/bin/memcached -m 64 -p 11211 -u memcache -l 192.168.88.11 -P /var/run/memcached/memcached.pid

Mar 24 15:20:29 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:20:34 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:20:39 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:24 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:24 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:25 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:27 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:29 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:39 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
Mar 24 15:29:42 k3lab-ml systemd-memcached-wrapper[2726]: accept4(): Too many open files
```

### 해결 방안

- memcached 메모리 설정을 64 -> 512로 변경함.
- memcached Connection Limit을 수정 한다. -c 1024 -> 4096으로 변경함.
- [참고] 연결제한된 컨넥팅 수를 알아보기 위해서는 `stas` 명령으로 "listen_disabled_num"의 수를 확인해서 maxConnection 수를 증가 한다.
```sh
## step-1. memcached 현재 설정 확인 하기
$ echo "stats settings" | nc 192.168.88.11 11211
STAT maxbytes 536870912
STAT maxconns 4096
STAT tcpport 11211
STAT udpport 0
STAT inter 192.168.88.11
STAT verbosity 0
STAT oldest 0
STAT evictions on
STAT domain_socket NULL
STAT umask 700
STAT growth_factor 1.25
STAT chunk_size 48
STAT num_threads 4
...

## step-2. memcached 연결 제한 확인 하기
## telnet 명령을 실행한 후 `stats` 명령을 통해 "listen_disabled_num" 값을 확인 하다. -> 정상은 0 
$ telnet 192.168.88.11 11211
Trying 192.168.88.11...
Connected to 192.168.88.11.
Escape character is '^]'.
stats
STAT pid 1849221
STAT uptime 321338
STAT time 1679974291
STAT version 1.5.22
STAT libevent 2.1.11-stable
STAT pointer_size 64
STAT rusage_user 129.335893
STAT rusage_system 270.040785
STAT max_connections 2048
STAT curr_connections 1738
STAT total_connections 88505
STAT rejected_connections 88504
STAT connection_structures 2022
STAT reserved_fds 20
STAT cmd_get 2684912
STAT cmd_set 188271
STAT cmd_flush 0
STAT cmd_touch 0
STAT cmd_meta 0
STAT get_hits 2612958
STAT get_misses 71954
STAT get_expired 2522
STAT get_flushed 0
STAT delete_misses 0
STAT delete_hits 1
STAT incr_misses 0
STAT incr_hits 0
STAT decr_misses 0
STAT decr_hits 0
STAT cas_misses 0
STAT cas_hits 0
STAT cas_badval 0
STAT touch_hits 0
STAT touch_misses 0
STAT auth_cmds 0
STAT auth_errors 0
STAT bytes_read 825210011
STAT bytes_written 4813234637
STAT limit_maxbytes 536870912
STAT accepting_conns 1
STAT listen_disabled_num 27
...

## step-3. memcached 설정 하기
$ vi /etc/memcached.conf
# memcached default config file
# 2003 - Jay Bonci <jaybonci@debian.org>
# This configuration file is read by the start-memcached script provided as
# part of the Debian GNU/Linux distribution.

# Run memcached as a daemon. This command is implied, and is not needed for the
# daemon to run. See the README.Debian that comes with this package for more
# information.
-d

# Log memcached's output to /var/log/memcached
logfile /var/log/memcached.log

# Be verbose
# -v

# Be even more verbose (print client commands as well)
# -vv

# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
-m 512

# Default connection port is 11211
-p 11211

# Run the daemon as root. The start-memcached will default to running as root if no
# -u command is present in this config file
-u memcache

# Specify which IP address to listen on. The default is to listen on all IP addresses
# This parameter is one of the only security measures that memcached has, so make sure
# it's listening on a firewalled interface.
-l 192.168.88.11

# Limit the number of simultaneous incoming connections. The daemon default is 1024
-c 4096

# Lock down all paged memory. Consult with the README and homepage before you do this
# -k

# Return error when memory is exhausted (rather than removing items)
# -M

# Maximize core file limit
# -r

# Use a pidfile
-P /var/run/memcached/memcached.pid
```