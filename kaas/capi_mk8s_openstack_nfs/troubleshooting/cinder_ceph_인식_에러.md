# Cinder에서 ceph 인식 안됨.

```log
May 18 11:55:18 k3lab-ml cinder-volume[475004]: ERROR cinder.volume.manager [None req-8827bb04-ab74-435f-b2ce-bd99695138d1 None None] Failed to initialize driver.: AttributeError: 'Retrying' object has no attribute 'call'
                                                ERROR cinder.volume.manager Traceback (most recent call last):
                                                ERROR cinder.volume.manager   File "/usr/local/lib/python3.8/dist-packages/cinder/volume/manager.py", line 482, in _init_host
                                                ERROR cinder.volume.manager     self.driver.check_for_setup_error()
                                                ERROR cinder.volume.manager   File "/usr/local/lib/python3.8/dist-packages/cinder/volume/drivers/rbd.py", line 425, in check_for_setup_error
                                                ERROR cinder.volume.manager     with RADOSClient(self):
                                                ERROR cinder.volume.manager   File "/usr/local/lib/python3.8/dist-packages/cinder/volume/drivers/rbd.py", line 194, in __init__
                                                ERROR cinder.volume.manager     self.cluster, self.ioctx = driver._connect_to_rados(pool)
                                                ERROR cinder.volume.manager   File "/usr/local/lib/python3.8/dist-packages/cinder/volume/drivers/rbd.py", line 505, in _connect_to_rados
                                                ERROR cinder.volume.manager     return _do_conn(pool, remote, timeout)
                                                ERROR cinder.volume.manager   File "/usr/local/lib/python3.8/dist-packages/cinder/utils.py", line 614, in _wrapper
                                                ERROR cinder.volume.manager     return r.call(f, *args, **kwargs)
                                                ERROR cinder.volume.manager AttributeError: 'Retrying' object has no attribute 'call'
                                                ERROR cinder.volume.manager
May 18 11:55:22 k3lab-ml cinder-volume[475004]: INFO cinder.volume.manager [None req-8827bb04-ab74-435f-b2ce-bd99695138d1 None None] Starting volume driver RBDDriver (1.2.0)
```