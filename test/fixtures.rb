def marathon_response
  <<-EOF
{
  "tasks": [
    {
      "healthCheckResults": [
        {
          "taskId": "foo_bar.0",
          "lastFailureCause": null,
          "lastSuccess": "2016-07-14T15:27:48.286Z",
          "lastFailure": null,
          "firstSuccess": "2016-07-14T14:10:57.583Z",
          "consecutiveFailures": 0,
          "alive": true
        }
      ],
      "servicePorts": [
        1234
      ],
      "appId": "/foo/bar",
      "ipAddresses": [
        {
          "protocol": "IPv4",
          "ipAddress": "123.123.123.123"
        }
      ],
      "id": "foo_bar.0",
      "slaveId": "0-S0",
      "host": "host.example.com",
      "state": "TASK_RUNNING",
      "startedAt": "2016-07-14T14:09:43.350Z",
      "stagedAt": "2016-07-14T14:09:41.953Z",
      "ports": [
        123450
      ],
      "version": "2016-07-14T14:09:41.270Z"
    },
    {
      "healthCheckResults": [
        {
          "taskId": "broken_app.0",
          "lastFailureCause": null,
          "lastSuccess": null,
          "lastFailure": null,
          "firstSuccess": null,
          "consecutiveFailures": 0,
          "alive": false
        },
        {
          "taskId": "broken_app.1",
          "lastFailureCause": null,
          "lastSuccess": "2016-07-14T15:27:48.286Z",
          "lastFailure": null,
          "firstSuccess": "2016-07-14T14:10:57.583Z",
          "consecutiveFailures": 0,
          "alive": true
        }
      ],
      "servicePorts": [
        1234
      ],
      "appId": "/broken/app",
      "ipAddresses": [
        {
          "protocol": "IPv4",
          "ipAddress": "123.123.123.123"
        }
      ],
      "id": "broken_app.0",
      "slaveId": "0-S0",
      "host": "host.example.com",
      "state": "TASK_RUNNING",
      "startedAt": "2016-07-14T14:09:43.350Z",
      "stagedAt": "2016-07-14T14:09:41.953Z",
      "ports": [
        123450
      ],
      "version": "2016-07-14T14:09:41.270Z"
    },
    {
      "healthCheckResults": [
        {
          "taskId": "broken_app.1",
          "lastFailureCause": "I broke",
          "lastSuccess": null,
          "lastFailure": "2016-07-14T14:09:41.270Z",
          "firstSuccess": null,
          "consecutiveFailures": 1,
          "alive": false
        }
      ],
      "servicePorts": [
        1234
      ],
      "appId": "/broken/app",
      "ipAddresses": [
        {
          "protocol": "IPv4",
          "ipAddress": "123.123.123.123"
        }
      ],
      "id": "broken_app.0",
      "slaveId": "0-S0",
      "host": "host.example.com",
      "state": "TASK_RUNNING",
      "startedAt": "2016-07-14T14:09:43.350Z",
      "stagedAt": "2016-07-14T14:09:41.953Z",
      "ports": [
        123450
      ],
      "version": "2016-07-14T14:09:41.270Z"
    }
  ]
}
EOF
end

def mesos_metrics_response
  <<-EOF
{
    "master/slave_shutdowns_completed": 10,
    "master/invalid_status_updates": 324,
    "master/messages_exited_executor": 0,
    "master/messages_status_update": 9048,
    "master/messages_unregister_slave": 0,
    "master/messages_framework_to_executor": 0,
    "master/messages_reconcile_tasks": 20028,
    "master/tasks_lost": 42,
    "master/messages_decline_offers": 1382080,
    "master/invalid_status_update_acknowledgements": 0,
    "master/tasks_failed": 4388,
    "system/load_5min": 0.07,
    "master/messages_launch_tasks": 4905,
    "master/messages_resource_request": 0,
    "master/messages_status_update_acknowledgement": 9035,
    "master/slaves_connected": 3,
    "master/event_queue_http_requests": 0,
    "master/messages_deactivate_framework": 0,
    "master/messages_reregister_slave": 25,
    "master/messages_executor_to_framework": 0,
    "registrar/log/recovered": 1,
    "master/outstanding_offers": 0,
    "allocator/mesos/allocation_runs": 2403507,
    "master/mem_used": 9032,
    "master/valid_executor_to_framework_messages": 0,
    "allocator/mesos/resources/mem/total": 39003,
    "master/valid_status_updates": 8724,
    "system/load_15min": 0.06,
    "allocator/mesos/event_queue_dispatches": 1,
    "allocator/event_queue_dispatches": 2,
    "master/slaves_active": 3,
    "master/messages_register_slave": 10,
    "allocator/mesos/allocation_run_ms/p90": 0.2970624,
    "allocator/mesos/allocation_run_ms/max": 3.444992,
    "master/cpus_total": 12,
    "allocator/mesos/resources/cpus/offered_or_allocated": 5.2,
    "master/tasks_error": 0,
    "master/invalid_framework_to_executor_messages": 0,
    "master/mem_revocable_total": 0,
    "master/messages_reregister_framework": 15,
    "master/dropped_messages": 1,
    "master/tasks_running": 9,
    "master/uptime_secs": 2401676.78693504,
    "allocator/mesos/resources/disk/total": 76752,
    "master/slave_removals/reason_registered": 0,
    "master/messages_suppress_offers": 0,
    "master/frameworks_active": 2,
    "master/slaves_disconnected": 0,
    "master/invalid_executor_to_framework_messages": 0,
    "master/slave_shutdowns_scheduled": 10,
    "master/messages_register_framework": 0,
    "master/slave_removals/reason_unregistered": 0,
    "master/slaves_inactive": 0,
    "master/messages_update_slave": 27,
    "master/event_queue_dispatches": 0,
    "master/event_queue_messages": 0,
    "allocator/mesos/allocation_run_ms/count": 1000,
    "master/slave_shutdowns_canceled": 0,
    "master/messages_kill_task": 62676,
    "master/slave_reregistrations": 3,
    "allocator/mesos/allocation_run_ms/p999": 0.48373222399993,
    "registrar/state_fetch_ms": 31.993088,
    "master/gpus_used": 0,
    "allocator/mesos/allocation_run_ms/p50": 0.235008,
    "allocator/mesos/allocation_run_ms/min": 0.172032,
    "master/disk_total": 76752,
    "master/valid_status_update_acknowledgements": 9035,
    "master/disk_used": 0,
    "master/slave_removals/reason_unhealthy": 10,
    "master/task_failed/source_slave/reason_container_launch_failed": 620,
    "master/slave_removals": 10,
    "master/recovery_slave_removals": 0,
    "allocator/mesos/allocation_run_ms/p99": 0.39718656,
    "allocator/mesos/allocation_run_ms": 0.227072,
    "registrar/state_store_ms/p90": 53.0578176,
    "master/task_lost/source_master/reason_slave_removed": 35,
    "master/gpus_percent": 0,
    "master/mem_revocable_used": 0,
    "system/cpus_total": 2,
    "registrar/state_store_ms/p999": 53.795556096,
    "master/mem_percent": 0.231571930364331,
    "master/mem_revocable_percent": 0,
    "master/disk_revocable_total": 0,
    "registrar/queued_operations": 0,
    "system/load_1min": 0.03,
    "master/gpus_total": 0,
    "master/cpus_percent": 0.433333333333333,
    "registrar/state_store_ms/p50": 47.450496,
    "master/tasks_finished": 316,
    "master/frameworks_inactive": 0,
    "master/messages_authenticate": 0,
    "master/frameworks_disconnected": 0,
    "master/disk_revocable_used": 0,
    "registrar/state_store_ms/max": 53.803008,
    "master/task_lost/source_slave/reason_reconciliation": 7,
    "master/tasks_staging": 0,
    "allocator/mesos/allocation_run_ms/p9999": 3.1488660224002,
    "master/gpus_revocable_total": 0,
    "master/cpus_revocable_total": 0,
    "allocator/mesos/offer_filters/roles/*/active": 6,
    "allocator/mesos/allocation_run_ms/p95": 0.3269632,
    "master/messages_unregister_framework": 0,
    "master/frameworks_connected": 2,
    "allocator/mesos/roles/*/shares/dominant": 0.433333333333333,
    "master/slave_registrations": 10,
    "master/cpus_revocable_percent": 0,
    "master/gpus_revocable_percent": 0,
    "master/disk_percent": 0,
    "master/disk_revocable_percent": 0,
    "master/gpus_revocable_used": 0,
    "master/task_failed/source_slave/reason_executor_terminated": 3,
    "master/valid_framework_to_executor_messages": 0,
    "master/cpus_used": 5.2,
    "registrar/registry_size_bytes": 758,
    "registrar/state_store_ms/p99": 53.72848896,
    "master/tasks_killed": 141,
    "master/elected": 1,
    "master/messages_revive_offers": 4742,
    "allocator/mesos/resources/cpus/total": 12,
    "master/tasks_killing": 0,
    "registrar/state_store_ms/count": 4,
    "master/cpus_revocable_used": 0,
    "system/mem_total_bytes": 7307726848,
    "allocator/mesos/resources/disk/offered_or_allocated": 0,
    "system/mem_free_bytes": 352153600,
    "master/tasks_starting": 0,
    "registrar/state_store_ms": 51.31904,
    "master/mem_total": 39003,
    "allocator/mesos/resources/mem/offered_or_allocated": 9032,
    "registrar/state_store_ms/min": 38.457856,
    "registrar/state_store_ms/p95": 53.4304128,
    "registrar/state_store_ms/p9999": 53.8022628096
}
  EOF
end

def mesos_slave_response
  <<-EOF
  {
  "slaves": [
    {
      "id": "11c27d89-4935-4347-a4c2-23324e69e314-S11",
      "hostname": "10.0.3.76",
      "port": 5051,
      "attributes": {},
      "pid": "slave(1)@10.0.3.76:5051",
      "registered_time": 1493725119.87166,
      "resources": {
        "disk": 102084,
        "mem": 6037,
        "gpus": 2,
        "cpus": 4,
        "ports": "[1025-2180, 2182-3887, 3889-5049, 5052-8079, 8082-8180, 8182-32000]"
      },
      "used_resources": {
        "disk": 1000,
        "mem": 2048,
        "gpus": 1,
        "cpus": 1,
        "ports": "[1025-1026]"
      },
      "offered_resources": {
        "disk": 0,
        "mem": 0,
        "gpus": 0,
        "cpus": 0
      },
      "reserved_resources": {
        "elastic-role": {
          "disk": 1000,
          "mem": 2048,
          "gpus": 0,
          "cpus": 1,
          "ports": "[1025-1026]"
        }
      },
      "unreserved_resources": {
        "disk": 101084,
        "mem": 3989,
        "gpus": 0,
        "cpus": 3,
        "ports": "[1027-2180, 2182-3887, 3889-5049, 5052-8079, 8082-8180, 8182-32000]"
      },
      "active": true,
      "version": "1.2.1",
      "offered_resources_full": []
    },
    {
      "id": "11c27d89-4935-4347-a4c2-23324e69e314-S10",
      "hostname": "10.0.3.248",
      "port": 5051,
      "attributes": {},
      "pid": "slave(1)@10.0.3.248:5051",
      "registered_time": 1493725100.24233,
      "resources": {
        "disk": 102084,
        "mem": 6037,
        "gpus": 2,
        "cpus": 4,
        "ports": "[1025-2180, 2182-3887, 3889-5049, 5052-8079, 8082-8180, 8182-32000]"
      },
      "used_resources": {
        "disk": 2000,
        "mem": 5144,
        "gpus": 0,
        "cpus": 1.5,
        "ports": "[1025-1025, 9300-9300, 10101-10101]"
      },
      "offered_resources": {
        "disk": 0,
        "mem": 0,
        "gpus": 0,
        "cpus": 0
      },
      "active": true,
      "version": "1.2.1",
      "offered_resources_full": []
    }
  ],
  "recovered_slaves": []
}
  EOF
end
