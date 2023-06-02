# neutron error

```sh
]: /usr/lib/python3/dist-packages/sqlalchemy/orm/relationships.py:1994: SAWarning: Setting backref / back_populates on relationship QosNetworkPolicyBinding.port to refer to viewonly relationship Port.qos_network_policy_binding should include sync_backref=False set on the QosNetworkPolicyBinding.port relationship.  (this warning may be suppressed after 10 occurrences)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   util.warn_limited(
Mar 24 17:46:43 k3lab-ml neutron-server[8974]: /usr/lib/python3/dist-packages/sqlalchemy/orm/relationships.py:1994: SAWarning: Setting backref / back_populates on relationship Tag.standard_attr to refer to viewonly relationship StandardAttribute.tags should include sync_backref=False set on the Tag.standard_attr relationship.  (this warning may be suppressed after 10 occurrences)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   util.warn_limited(
Mar 24 17:46:43 k3lab-ml neutron-server[8974]: Traceback (most recent call last):
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/eventlet/hubs/hub.py", line 476, in fire_timers
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     timer()
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/eventlet/hubs/timer.py", line 59, in __call__
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     cb(*args, **kw)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/common/utils.py", line 905, in wrapper
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     return func(*args, **kwargs)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/notifiers/batch_notifier.py", line 58, in synced_send
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     self._notify()
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/notifiers/batch_notifier.py", line 69, in _notify
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     self.callback(batched_events)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/services/segments/plugin.py", line 211, in _send_notifications
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     event.method(event)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/services/segments/plugin.py", line 379, in _delete_nova_inventory
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     aggregate_id = self._get_aggregate_id(event.segment_id)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron/services/segments/plugin.py", line 366, in _get_aggregate_id
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     aggregate_uuid = self.p_client.list_aggregates(
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron_lib/placement/client.py", line 57, in wrapper
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     return f(self, *a, **k)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron_lib/placement/client.py", line 553, in list_aggregates
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     return self._get(url).json()
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/neutron_lib/placement/client.py", line 189, in _get
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     return self._client.get(url, endpoint_filter=self._ks_filter,
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/keystoneauth1/session.py", line 1141, in get
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     return self.request(url, 'GET', **kwargs)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/keystoneauth1/session.py", line 811, in request
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     base_url = self.get_endpoint(auth, allow=allow,
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/keystoneauth1/session.py", line 1241, in get_endpoint
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     auth = self._auth_required(auth, 'determine endpoint URL')
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:   File "/usr/lib/python3/dist-packages/keystoneauth1/session.py", line 1181, in _auth_required
Mar 24 17:46:43 k3lab-ml neutron-server[8974]:     raise exceptions.MissingAuthPlugin(msg_fmt % msg)
Mar 24 17:46:43 k3lab-ml neutron-server[8974]: keystoneauth1.exceptions.auth_plugins.MissingAuthPlugin: An auth plugin is required to determine endpoint URL
```

### dhcp 포트가 down 되는 현상 (30개 생성시 발생)