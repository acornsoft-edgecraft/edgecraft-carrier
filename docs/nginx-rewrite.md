# Harbor request_uri 변경 하기

## docker late limit 구성시 nginx에서 설정 할때

```sh
## step-1. nginx 설정
$ vi /var/lib/kore-on/harbor/common/config/nginx/nginx.conf
  server {
    listen 8443 ssl;
    listen [::]:8443 ssl;
#    server_name harbordomain.com;
    # Rewrite for proxy cache
    rewrite ^/v2/docker.io/v2(.*)$ /v2/docker.io/$1;
...
```