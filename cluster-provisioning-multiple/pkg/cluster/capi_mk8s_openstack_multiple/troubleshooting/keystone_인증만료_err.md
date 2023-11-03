## 인스턴스 401 에러 발생시 keystone의 인증서 토크 만료 확인

- keystone의 인증서 토큰 만료 시간은 기본적으로 1시간이다.

```sh
## 인증서 만료 시간을 연장 하자.(초단위)
$ vi /etc/keystone/keystone.conf
...
[token]
expiration = 7200
...
```