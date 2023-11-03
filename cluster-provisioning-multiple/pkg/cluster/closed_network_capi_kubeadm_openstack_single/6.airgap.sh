#!/bin/bash

# 테스트할 호스트 또는 IP 주소를 설정합니다.
target_host="google.com"
if [[ -n "$1" ]]; then
    target_host="$1"
fi

# 특정 포트 (예: 80, 443)를 테스트할 수도 있습니다.
port=80
if [[ -n "$2" ]]; then
    port=$2
fi

# 패킷 전송 시간 초과 (timeout) 설정 (초)
timeout=5

# 테스트 수행
ping_test=`ping -c 1 -W $timeout $target_host 2>/dev/null`
if [[ -n $ping_test ]]; then
  echo "### 네트워크 연결 확인: $target_host"
  echo "$ping_test"
  echo ""
  
  # 특정 포트로 연결 시도
  echo "### 포트 연결 확인: port $port"
  port_test=`timeout --signal=9 $timeout nc -z -v $target_host $port 2>&1`
  # echo "$port_test" | grep "succeeded"
  if [[ -n "$port_test" ]]; then
    echo "$port_test"
  else
    echo "Connection to $target_host port $port - Connection refused!"
  fi
else
  echo "### 네트워크 연결 실패: $target_host 도달 불가능"
  echo "$(ping -c 1 -W $timeout $target_host)"
fi