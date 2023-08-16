#!/bin/bash

# 함수 정의
my_function() {
  local arr=()
  local str=""

  # 인자의 타입에 따라 처리
  for arg in "$@"; do
    if [[ "${arg}" =~ ^\[.*\]$ ]]; then
      # 배열 인자인 경우
      arr=("${arg[@]}")
    else
      # 문자열 인자인 경우
      str="${arg}"
    fi
  done

  # 배열 출력
  echo "배열 인자:"
  for item in "${arr[@]}"; do
    echo "$item"
  done

  # 문자열 출력
  echo "문자열 인자: $str"
}

# 함수 호출
my_array=("value1" "value2" "value3")
my_string="Hello, World!"
my_function "${my_array[@]}" "$my_string"