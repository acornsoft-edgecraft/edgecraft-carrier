# Tags

큰 playbook이 있는 경우 전체 playbook을 실행하는 대신 특정 부분 만 실행하는 것이 유용 할 수 있습니다. Ansible tag로 이 작업을 수행 할 수 있습니다.


## Adding tags to includes

playbook의 include에 tag를 적용할 수 있다. 이는 include 에만 적용 되기 때문에 include로 불러오는 task의 내용에는 적용 되지 않는다.