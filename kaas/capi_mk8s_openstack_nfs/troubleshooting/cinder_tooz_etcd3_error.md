##

```log
ERROR oslo_messaging.rpc.server
ERROR oslo_messaging.rpc.server [req-ed1560e6-93a2-44a3-82ce-f401f7e59d87 req-1fd3188e-0580-495f-bd76-6d7e7188fd9c edgecraft-test None] Exception during message handling: tooz.ToozError: Not Found
ERROR oslo_messaging.rpc.server Traceback (most recent call last):
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/drivers/etcd3gw.py", line 42, in wrapper
ERROR oslo_messaging.rpc.server     return func(*args, **kwargs)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/drivers/etcd3gw.py", line 117, in acquire
ERROR oslo_messaging.rpc.server     return _acquire()
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tenacity/__init__.py", line 329, in wrapped_f
ERROR oslo_messaging.rpc.server     return self.call(f, *args, **kw)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tenacity/__init__.py", line 409, in call
ERROR oslo_messaging.rpc.server     do = self.iter(retry_state=retry_state)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tenacity/__init__.py", line 356, in iter
ERROR oslo_messaging.rpc.server     return fut.result()
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3.8/concurrent/futures/_base.py", line 437, in result
ERROR oslo_messaging.rpc.server     return self.__get_result()
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3.8/concurrent/futures/_base.py", line 389, in __get_result
ERROR oslo_messaging.rpc.server     raise self._exception
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tenacity/__init__.py", line 412, in call
ERROR oslo_messaging.rpc.server     result = fn(*args, **kwargs)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/drivers/etcd3gw.py", line 107, in _acquire
ERROR oslo_messaging.rpc.server     result = self._coord.client.transaction(txn)
ERROR oslo_messaging.rpc.server   File "/usr/local/lib/python3.8/dist-packages/etcd3gw/client.py", line 344, in transaction
ERROR oslo_messaging.rpc.server     return self.post(self.get_url("/kv/txn"),
ERROR oslo_messaging.rpc.server   File "/usr/local/lib/python3.8/dist-packages/etcd3gw/client.py", line 91, in post
ERROR oslo_messaging.rpc.server     raise exceptions.Etcd3Exception(resp.text, resp.reason)
ERROR oslo_messaging.rpc.server etcd3gw.exceptions.Etcd3Exception: Not Found
ERROR oslo_messaging.rpc.server
ERROR oslo_messaging.rpc.server The above exception was the direct cause of the following exception:
ERROR oslo_messaging.rpc.server
ERROR oslo_messaging.rpc.server Traceback (most recent call last):
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/oslo_messaging/rpc/server.py", line 165, in _process_incoming
ERROR oslo_messaging.rpc.server     res = self.dispatcher.dispatch(message)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/oslo_messaging/rpc/dispatcher.py", line 309, in dispatch
ERROR oslo_messaging.rpc.server     return self._do_dispatch(endpoint, method, ctxt, args)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/oslo_messaging/rpc/dispatcher.py", line 229, in _do_dispatch
ERROR oslo_messaging.rpc.server     result = func(ctxt, **new_args)
ERROR oslo_messaging.rpc.server   File "<decorator-gen-719>", line 2, in create_volume
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/cinder/objects/cleanable.py", line 208, in wrapper
ERROR oslo_messaging.rpc.server     result = f(*args, **kwargs)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/cinder/volume/manager.py", line 773, in create_volume
ERROR oslo_messaging.rpc.server     with coordination.COORDINATOR.get_lock(locked_action):
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/locking.py", line 49, in __enter__
ERROR oslo_messaging.rpc.server     acquired = self.acquire(*args, **kwargs)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/drivers/etcd3gw.py", line 52, in wrapper
ERROR oslo_messaging.rpc.server     utils.raise_with_cause(coordination.ToozError,
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/tooz/utils.py", line 224, in raise_with_cause
ERROR oslo_messaging.rpc.server     excutils.raise_with_cause(exc_cls, message, *args, **kwargs)
ERROR oslo_messaging.rpc.server   File "/usr/lib/python3/dist-packages/oslo_utils/excutils.py", line 142, in raise_with_cause
ERROR oslo_messaging.rpc.server     raise exc_cls(message, *args, **kwargs) from kwargs.get('cause')
ERROR oslo_messaging.rpc.server tooz.ToozError: Not Found
ERROR oslo_messaging.rpc.server
INFO cinder.volume.flows.manager.create_volume [req-aeb48ba1-6bda-463a-a9b3-3e6eba389f61 req-1da277c3-11f1-47e5-a94e-91533731256d edgecraft-test None] Volume 8bdf9f32-8b14-40a8-be1e-c572c1ad48ab: being created as snap with specification: {'status': 'creating', 'volume_name': 'volume-8bdf9f32-8b14-40a8-be1e-c572c1ad48ab', 'volume_size': 20, 'snapshot_id': '482e329e-2b3a-4624-b4b9-c8214a2df715'}
```