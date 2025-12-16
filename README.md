# cloudstack_server

Cloudstack ansible deployment playbook


For testing: `scp -i private_ansible_cloud_init ../../ansible_playbook/files/cloudstack.cnf.j2 ../../ansible_playbook/cloudstack_playbook.yaml ansible@192.168.122.141:/home/ansible`

* ansible-playbook --extra-vars "mysql_root_password=SuperSecret"  --extra-vars "primary_nfs_storage=/hdd2/primary_nfs_storage" --extra-vars "secondary_nfs_storage=/hdd1/secondary_nfs_storage" -v cloudstack_playbook.yaml


* ansible-playbook --extra-vars "mysql_root_password=SuperSecret"  -v cloudstack_playbook.yaml

* `/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /hdd1/secondary_nfs_storage -u http://download.cloudstack.org/systemvm/4.18/systemvmtemplate-4.18.0-kvm.qcow2.bz2 -h kvm -F`

### Continue with installation

* https://docs.cloudstack.apache.org/en/4.18.0.0/installguide/configuration.html
* Zone type: Core
* Core zone type: Advanced
* Zone details
  * name: thefirstzone
  * IPv4 DNS1: 192.168.122.254
  * Internal DNS 1: 172.16.1.254
  * Hypervisor: KVM
  * Guest CIDR: 172.16.1.0/24
  * Enable local storage for user VMs: enabled
  * Enable local storage for system VMs: enabled
* Network:
  * pysical network
    * use default 'Pysical Network 1'
  * Public traffic: ?
    * gw: 192.168.122.1
    * netmask: 255.255.255.0
    * vlan: 1
    * start ip: 192.168.122.220
    * end ip: 192.168.122.250
    * click 'Add'
    * click 'Next'
  * Pod
    * Pod name: cloudpod1
    * reserved system gateway: 172.16.2.1
    * nemask: 255.255.255.0
    * st ip 172.16.2.100
    * end ip 172.16.2.200
  * Guest traffic
    * vlan range: 10-100
* add reources
  * cluster
    * cluster name: cloudcluster1
  * ip address
    * host name: tfcloudstack
    * username: root
  * secondary storage
    * provider: NFS
    * Name: nfssecond
    * server: 192.168.122.141
    * path: /hdd1/secondary_nfs_storage
  * primary storage
    * name: nfsprimary
    * protocol: nfs
    * server: 192.168.122.141
    * path: /hdd2/primary_nfs_storage
    * Provider: DefaultPrimary

## Troubleshooting

### troubleshooting advice

* logs: /var/log/cloudstack/management/

#### The subnet of the pod you are adding conflicts with the subnet of the Guest IP Network. Please specify a different CIDR

```text
Something went wrong; please correct the following:
The subnet of the pod you are adding conflicts with the subnet of the Guest IP Network. Please specify a different CIDR.
```

#### Agent not running, or no route to agent on at http://tfcloudstack

The cluster was configured for hyperv.

Delete the cluster and create a new cluser with kvm hypervisor.

```text
2023-09-05 08:03:41,426 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-05 08:03:41,436 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-05 08:03:41,436 INFO  [c.c.h.h.d.HypervServerDiscoverer] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Discover host. dc(zone): 1, pod: 1, cluster: 1, uri host: tfcloudstack
2023-09-05 08:03:41,440 INFO  [c.c.h.h.d.HypervServerDiscoverer] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Creatingcom.cloud.hypervisor.hyperv.resource.HypervDirectConnectResource HypervDirectConnectResource for zone/pod/cluster 1/1/1
2023-09-05 08:03:41,442 DEBUG [c.c.a.r.v.VirtualRoutingResource] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) The router.aggregation.command.each.timeout in seconds is set to 600
2023-09-05 08:03:41,443 DEBUG [c.c.h.h.r.HypervDirectConnectResource] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) POST request to https://192.168.122.141:8250/api/HypervResource/com.cloud.agent.api.ReadyCommand with contents {"contextMap":{},"wait":0,"bypassHostMaintenance":false}
2023-09-05 08:03:41,445 DEBUG [c.c.h.h.r.HypervDirectConnectResource] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Sending cmd to https://192.168.122.141:8250/api/HypervResource/com.cloud.agent.api.ReadyCommand cmd data:{"contextMap":{},"wait":0,"bypassHostMaintenance":false}
2023-09-05 08:03:41,515 ERROR [c.c.u.n.Link] (AgentManager-SSLHandshakeHandler-2:null) (logid:) SSL error caught during wrap data: Empty client certificate chain, for local address=/192.168.122.141:8250, remote address=/192.168.122.141:43414.
2023-09-05 08:03:41,516 ERROR [c.c.h.h.r.HypervDirectConnectResource] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) javax.net.ssl.SSLHandshakeException: Received fatal alert: bad_certificate
2023-09-05 08:03:41,516 DEBUG [c.c.h.h.d.HypervServerDiscoverer] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Agent not running, or no route to agent on at http://tfcloudstack
2023-09-05 08:03:41,516 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 08:03:41,516 WARN  [c.c.h.h.d.HypervServerDiscoverer] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9)  can't setup agent, due to com.cloud.exception.DiscoveryException: Agent not running, or no route to agent on at http://tfcloudstack - Agent not running, or no route to agent on at http://tfcloudstack
2023-09-05 08:03:41,516 WARN  [c.c.r.ResourceManagerImpl] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Cannot find the server resources at http://tfcloudstack
2023-09-05 08:03:41,517 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 08:03:41,517 WARN  [o.a.c.a.c.a.h.AddHostCmd] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Exception: 
com.cloud.exception.DiscoveryException: Unable to add the host: Cannot find the server resources at http://tfcloudstack
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:880)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.strategy.EatWhatYouKill.runTask(EatWhatYouKill.java:338)
        at org.eclipse.jetty.util.thread.strategy.EatWhatYouKill.doProduce(EatWhatYouKill.java:315)
        at org.eclipse.jetty.util.thread.strategy.EatWhatYouKill.tryProduce(EatWhatYouKill.java:173)
        at org.eclipse.jetty.util.thread.strategy.EatWhatYouKill.run(EatWhatYouKill.java:131)
        at org.eclipse.jetty.util.thread.ReservedThreadExecutor$ReservedThread.run(ReservedThreadExecutor.java:409)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
2023-09-05 08:03:41,519 INFO  [c.c.a.ApiServer] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) Unable to add the host: Cannot find the server resources at http://tfcloudstack
2023-09-05 08:03:41,519 DEBUG [c.c.a.ApiServlet] (qtp1278852808-291:ctx-bd8e9d4c ctx-80bd8529) (logid:6264cfa9) ===END===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 08:03:41,526 INFO  [c.c.a.m.AgentManagerImpl] (AgentManager-Handler-10:null) (logid:) Connection from /192.168.122.141 closed but no cleanup was done.
```

#### Unable to add the host: Cannot find the server resources at http://tfcloudstack

```text
Unable to add the host: Cannot find the server resources at http://tfcloudstack
```

#### Failed to add data store: No host up to associate a storage pool with in cluster 2

Primary storage cannot be added until a host has been added to the cluster.

https://docs.cloudstack.apache.org/en/latest/installguide/configuration.html#add-primary-storage

#### Could not add host at [http://tfcloudstack]

use ssh authentication instead

See: 
* https://docs.cloudstack.apache.org/en/latest/installguide/configuration.html#adding-a-host
* https://docs.cloudstack.apache.org/en/latest/installguide/hypervisor/kvm.html

* sudo useradd -m vmadm
* sudo passwd vmadm
* sudo mkdir /home/vmadm/.ssh
* sudo chown vmadm:vmadm /home/vmadm/.ssh
* sudo chmod 700 /home/vmadm/.ssh
* sudo cp /var/lib/cloudstack/management/.ssh/id_rsa.pub /home/vmadm/.ssh/authorized_keys
* sudo chown vmadm:vmadm /home/vmadm/.ssh/authorized_keys
* sudo chmod 600 /home/vmadm/.ssh/authorized_keys
* echo "vmadm ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/vmadm
* sudo chmod 440 /etc/sudoers.d/vmadm

* sudo apt install -y cloudstack-agent
  * https://docs.cloudstack.apache.org/en/latest/installguide/hypervisor/kvm.html

* sudo usermod -aG kvm vmadm
* sudo usermod -aG libvirt vmadm

```text
Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.].
```

sudo tail -f /var/log/cloudstack/management/management-server.log

```text
2023-09-05 08:29:20,321 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-d462a6a6) (logid:780d3c63) ===START===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 08:29:20,321 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-d462a6a6) (logid:780d3c63) Two factor authentication is already verified for the user 2, so skipping
2023-09-05 08:29:20,330 DEBUG [c.c.a.ApiServer] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) CIDRs from which account 'Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]' is allowed to perform API calls: 0.0.0.0/0,::/0
2023-09-05 08:29:20,338 INFO  [o.a.c.a.DynamicRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Account [Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]] is Root Admin or Domain Admin, all APIs are allowed.
2023-09-05 08:29:20,340 WARN  [o.a.c.a.ProjectRoleBasedApiAccessChecker] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Project is null, ProjectRoleBasedApiAccessChecker only applies to projects, returning API [addHost] for user [User {"username":"admin","uuid":"6c8c67d4-4b5d-11ee-b641-525400c62eb4"}.] as allowed.
2023-09-05 08:29:20,342 DEBUG [o.a.c.a.StaticRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) RoleService is enabled. We will use it instead of StaticRoleBasedAPIAccessChecker.
2023-09-05 08:29:20,343 DEBUG [o.a.c.r.ApiRateLimitServiceImpl] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) API rate limiting is disabled. We will not use ApiRateLimitService.
2023-09-05 08:29:20,348 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-05 08:29:20,353 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-05 08:29:20,401 DEBUG [o.a.c.s.SecondaryStorageManagerImpl] (secstorage-1:ctx-01c74517) (logid:fa026444) Enabled non-edge zones available for scan: 
2023-09-05 08:29:20,529 WARN  [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Failed to authenticate with ssh key
2023-09-05 08:29:20,530 INFO  [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Failed to authenticate with ssh key, retrying with password
2023-09-05 08:29:20,530 WARN  [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63)  can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.
2023-09-05 08:29:20,531 DEBUG [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63)  can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.
java.io.IOException: Password authentication failed.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:404)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.S2023-09-05 09:34:54,334 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a) (logid:0d579ad1) ===START===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 09:34:54,335 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a) (logid:0d579ad1) Two factor authentication is already verified for the user 2, so skipping
2023-09-05 09:34:54,350 DEBUG [c.c.a.ApiServer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) CIDRs from which account 'Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]' is allowed to perform API calls: 0.0.0.0/0,::/0
2023-09-05 09:34:54,353 INFO  [o.a.c.a.DynamicRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Account [Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]] is Root Admin or Domain Admin, all APIs are allowed.
2023-09-05 09:34:54,355 WARN  [o.a.c.a.ProjectRoleBasedApiAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Project is null, ProjectRoleBasedApiAccessChecker only applies to projects, returning API [addHost] for user [User {"username":"admin","uuid":"6c8c67d4-4b5d-11ee-b641-525400c62eb4"}.] as allowed.
2023-09-05 09:34:54,356 DEBUG [o.a.c.a.StaticRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) RoleService is enabled. We will use it instead of StaticRoleBasedAPIAccessChecker.
2023-09-05 09:34:54,357 DEBUG [o.a.c.r.ApiRateLimitServiceImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) API rate limiting is disabled. We will not use ApiRateLimitService.
2023-09-05 09:34:54,360 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-05 09:34:54,364 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-05 09:34:54,515 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: ls /dev/kvm
2023-09-05 09:34:54,911 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-2:ctx-67f09f4c) (logid:9d56eb63) HA health check task is running...
2023-09-05 09:34:56,097 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: ls /dev/kvm
SSH command output:/dev/kvm


2023-09-05 09:34:56,105 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:57,156 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:57,157 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:58,220 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:58,221 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:58,913 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-2:ctx-02a07a26) (logid:0c56307b) HA health check task is running...
2023-09-05 09:34:59,279 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:59,279 WARN  [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
2023-09-05 09:34:59,280 DEBUG [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
2023-09-05 09:34:59,281 DEBUG [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:34:59,295 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 09:34:59,297 WARN  [o.a.c.a.c.a.h.AddHostCmd] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Exception: 
com.cloud.exception.DiscoveryException: Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:818)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        ... 54 more
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:34:59,299 INFO  [c.c.a.ApiServer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
2023-09-05 09:34:59,300 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) ===END===  192.168.122.1 -- POST  command=addHost&response=jsoncopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: java.io.IOException: Authentication method password not supported by the server at this stage.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:374)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        ... 56 more
2023-09-05 08:29:20,535 DEBUG [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.].
com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)DEBUG:root:execute:uname -r
DEBUG:root:execute:uname -m
DEBUG:root:execute:hostname -f
DEBUG:root:execute:kvm-ok
DEBUG:root:execute:awk '/MemTotal/ { printf "%.3f \n", $2/1024 }' /proc/meminfo
DEBUG:root:execute:ip a | grep "^\w" | grep -iv "^lo" | wc -l
DEBUG:root:execute:service apparmor status
DEBUG:root:execute:apparmor_status |grep libvirt
DEBUG:root:Failed to execute:
DEBUG:root:cloudbr0 is not a network device, is it down?
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:route -n|awk '/^0.0.0.0/ {print $2,$8}'
DEBUG:root:execute:ifconfig eth0
DEBUG:root:execute:which ovs-vsctl
DEBUG:root:Failed to execute:
DEBUG:root:Found default network device:eth0
DEBUG:root:[Errno 2] No such file or directory: '/etc/network/interfaces'
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 38, in configuration
    result = self.config()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 211, in config
    super(networkConfigUbuntu, self).cfgNetwork()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 116, in cfgNetwork
    self.writeToCfgFile(brName, device)
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 190, in writeToCfgFile
    cfg = open(self.netCfgFile).read()

DEBUG:root:execute:sudo update-rc.d -f apparmor remove
DEBUG:root:execute:sudo update-rc.d -f apparmor defaults
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: java.io.IOException: Password authentication failed.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:404)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        ... 56 more
Caused by: java.io.IOException: Authentication method password not supported by the server at this stage.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:374)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        ... 56 more
2023-09-05 08:29:20,535 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 08:29:20,536 WARN  [o.a.c.a.c.a.h.AddHostCmd] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Exception: 
com.cloud.exception.DiscoveryException: Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.].
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:818)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        ... 54 more
Caused by: java.io.IOException: Password authentication failed.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:404)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        ... 56 more
Caused by: java.io.IOException: Authentication method password not supported by the server at this stage.
        at com.trilead.ssh2.auth.AuthenticationManager.authenticatePassword(AuthenticationManager.java:374)
        at com.trilead.ssh2.Connection.authenticateWithPassword(Connection.java:340)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:268)
        ... 56 more
2023-09-05 08:29:20,538 INFO  [c.c.a.ApiServer] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to java.io.IOException: Password authentication failed. - Password authentication failed.].
2023-09-05 08:29:20,538 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-d462a6a6 ctx-a1f32a87) (logid:780d3c63) ===END===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 08:29:20,841 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-6:ctx-cfda3f11) (logid:21a8050d) HA health check task is running...
2023-09-05 08:29:21,129 DEBUG [c.c.c.ConsoleProxyManagerImpl] (consoleproxy-1:ctx-5f73fd47) (logid:504fa2d7) Skip capacity scan as there is no Primary Storage in 'Up' state
```

#### Failed to setup keystore on the KVM host

put vmadm in /etc/sudoers

* echo "vmadm ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/vmadm
* sudo chmod 440 /etc/sudoers.d/vmadm

```text
Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
```

The acutal error: 

```text
SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required
```

* sudo tail -f /var/log/cloudstack/management/management-server.log

```text
2023-09-05 09:34:54,334 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a) (logid:0d579ad1) ===START===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 09:34:54,335 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a) (logid:0d579ad1) Two factor authentication is already verified for the user 2, so skipping
2023-09-05 09:34:54,350 DEBUG [c.c.a.ApiServer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) CIDRs from which account 'Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]' is allowed to perform API calls: 0.0.0.0/0,::/0
2023-09-05 09:34:54,353 INFO  [o.a.c.a.DynamicRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Account [Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]] is Root Admin or Domain Admin, all APIs are allowed.
2023-09-05 09:34:54,355 WARN  [o.a.c.a.ProjectRoleBasedApiAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Project is null, ProjectRoleBasedApiAccessChecker only applies to projects, returning API [addHost] for user [User {"username":"admin","uuid":"6c8c67d4-4b5d-11ee-b641-525400c62eb4"}.] as allowed.
2023-09-05 09:34:54,356 DEBUG [o.a.c.a.StaticRoleBasedAPIAccessChecker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) RoleService is enabled. We will use it instead of StaticRoleBasedAPIAccessChecker.
2023-09-05 09:34:54,357 DEBUG [o.a.c.r.ApiRateLimitServiceImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) API rate limiting is disabled. We will not use ApiRateLimitService.
2023-09-05 09:34:54,360 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-05 09:34:54,364 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-05 09:34:54,515 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: ls /dev/kvm
2023-09-05 09:34:54,911 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-2:ctx-67f09f4c) (logid:9d56eb63) HA health check task is running...
2023-09-05 09:34:56,097 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: ls /dev/kvm
SSH command output:/dev/kvm


2023-09-05 09:34:56,105 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:57,156 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:57,157 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:58,220 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:58,221 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:34:58,913 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-2:ctx-02a07a26) (logid:0c56307b) HA health check task is running...
2023-09-05 09:34:59,279 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required

2023-09-05 09:34:59,279 WARN  [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
2023-09-05 09:34:59,280 DEBUG [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
2023-09-05 09:34:59,281 DEBUG [c.c.r.ResourceManagerImpl] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:34:59,295 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 09:34:59,297 WARN  [o.a.c.a.c.a.h.AddHostCmd] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Exception: 
com.cloud.exception.DiscoveryException: Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:818)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        ... 54 more
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:34:59,299 INFO  [c.c.a.ApiServer] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
2023-09-05 09:34:59,300 DEBUG [c.c.a.ApiServlet] (qtp1278852808-16:ctx-508e9c8a ctx-f4ce1be7) (logid:0d579ad1) ===END===  192.168.122.1 -- POST  command=addHost&response=json
```

#### Failed to generate CSR file while retrying

* sudo apt install -y cloudstack-agent

```text
2023-09-05 09:45:03,234 DEBUG [c.c.a.ApiServlet] (qtp1278852808-20:ctx-dfebc674) (logid:3a4fd9e2) ===START===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-05 09:45:03,234 DEBUG [c.c.a.ApiServlet] (qtp1278852808-20:ctx-dfebc674) (logid:3a4fd9e2) Two factor authentication is already verified for the user 2, so skipping
2023-09-05 09:45:03,244 DEBUG [c.c.a.ApiServer] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) CIDRs from which account 'Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]' is allowed to perform API calls: 0.0.0.0/0,::/0
2023-09-05 09:45:03,247 INFO  [o.a.c.a.DynamicRoleBasedAPIAccessChecker] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Account [Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]] is Root Admin or Domain Admin, all APIs are allowed.
2023-09-05 09:45:03,250 WARN  [o.a.c.a.ProjectRoleBasedApiAccessChecker] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Project is null, ProjectRoleBasedApiAccessChecker only applies to projects, returning API [addHost] for user [User {"username":"admin","uuid":"6c8c67d4-4b5d-11ee-b641-525400c62eb4"}.] as allowed.
2023-09-05 09:45:03,252 DEBUG [o.a.c.a.StaticRoleBasedAPIAccessChecker] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) RoleService is enabled. We will use it instead of StaticRoleBasedAPIAccessChecker.
2023-09-05 09:45:03,253 DEBUG [o.a.c.r.ApiRateLimitServiceImpl] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) API rate limiting is disabled. We will not use ApiRateLimitService.
2023-09-05 09:45:03,256 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-05 09:45:03,263 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-05 09:45:03,406 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Executing cmd: ls /dev/kvm
2023-09-05 09:45:04,985 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) SSH command: ls /dev/kvm
SSH command output:/dev/kvm


2023-09-05 09:45:04,997 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:45:07,206 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-4:ctx-13654904) (logid:db370f62) HA health check task is running...
2023-09-05 09:45:07,346 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:Failed to generate CSR file, retrying after removing existing settings
Reverting libvirtd to not listen on TLS
Removing cloud.* files in /etc/cloudstack/agent
Retrying to generate CSR file
Failed to generate CSR file while retrying


2023-09-05 09:45:07,346 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:45:07,962 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-bd6a299e) (logid:5ac4dba2) Found 0 routers to update status. 
2023-09-05 09:45:07,964 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-bd6a299e) (logid:5ac4dba2) Found 0 VPC's to update Redundant State. 
2023-09-05 09:45:07,967 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-bd6a299e) (logid:5ac4dba2) Found 0 networks to update RvR status. 
2023-09-05 09:45:08,184 DEBUG [c.c.s.StatsCollector] (StatsCollector-1:ctx-ea404055) (logid:474c2205) DbCollector is running...
2023-09-05 09:45:09,183 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) ManagementServerCollector is running...
2023-09-05 09:45:09,184 DEBUG [c.c.u.d.DbProperties] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) DB properties were already loaded
2023-09-05 09:45:09,184 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c systemctl status cloudstack-usage | grep "  Loaded:" 
2023-09-05 09:45:09,184 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,192 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Exit value is 1
2023-09-05 09:45:09,193 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Unit cloudstack-usage.service could not be found.
2023-09-05 09:45:09,193 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) usage install: null
2023-09-05 09:45:09,193 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Sessions active: 1
2023-09-05 09:45:09,193 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /etc/os-release | grep PRETTY_NAME | cut -f2 -d '=' | tr -d '"' 
2023-09-05 09:45:09,194 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,200 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,201 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c uname -r 
2023-09-05 09:45:09,201 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,203 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,203 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /proc/meminfo | grep MemTotal | cut -f 2 -d ':' | tr -d 'a-zA-z ' 
2023-09-05 09:45:09,204 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,212 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,213 INFO  [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) system memory from /proc: 4101971968
2023-09-05 09:45:09,213 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /proc/meminfo | grep MemFree | cut -f 2 -d ':' | tr -d 'a-zA-z ' 
2023-09-05 09:45:09,214 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,218 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,219 INFO  [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) free memory from /proc: 385712128
2023-09-05 09:45:09,219 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c ps -o rss= 101325 
2023-09-05 09:45:09,220 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,226 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,232 INFO  [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) used memory from /proc: 738128
2023-09-05 09:45:09,232 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c uptime -s 
2023-09-05 09:45:09,232 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,238 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,245 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c ps -o vsz= 101325 
2023-09-05 09:45:09,246 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,255 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,256 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /proc/cpuinfo | grep "cpu MHz" | grep "cpu MHz" | cut -f 2 -d : | tr -d ' '| tr '\n' " " 
2023-09-05 09:45:09,257 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,265 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,268 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /proc/loadavg 
2023-09-05 09:45:09,268 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,271 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,272 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c cat /proc/stat | grep "cpu " | tr -d "cpu" 
2023-09-05 09:45:09,272 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,276 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,279 DEBUG [c.c.u.LogUtils] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) file for FILE : /var/log/cloudstack/management/management-server.log
2023-09-05 09:45:09,280 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c du -sh /var/log/cloudstack/management/management-server.log | cut -f '1' 
2023-09-05 09:45:09,280 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,284 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,285 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing: /bin/bash -c df -h /var/log/cloudstack/management/management-server.log | grep -v Filesystem | awk '{print "on disk " $1 " mounted on " $6 " (" $5 " full)"}' 
2023-09-05 09:45:09,285 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Executing while with timeout : 3600000
2023-09-05 09:45:09,293 DEBUG [c.c.u.s.Script] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Execution is successful.
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersdirect.capacity, 420775
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersdirect.count, 20
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersdirect.used, 420775
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersmapped.capacity, 7832569
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersmapped.count, 295
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail buffersmapped.used, 7832569
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail gcPS-MarkSweep.count, 6
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail gcPS-MarkSweep.time, 1409
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail gcPS-Scavenge.count, 155
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail gcPS-Scavenge.time, 2736
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail jvmname, 101325@tfcloudstack
2023-09-05 09:45:09,295 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail jvmuptime, 50149858
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail jvmvendor, Ubuntu OpenJDK 64-Bit Server VM 11.0.20.1+1-post-Ubuntu-0ubuntu122.04 (11)
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memoryheap.committed, 264765440
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memoryheap.init, 65011712
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memoryheap.usage, 0.10715522127012668
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorynon-heap.committed, 201629696
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorynon-heap.init, 7667712
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorynon-heap.max, -1
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorynon-heap.usage, -1.96101848E8
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorynon-heap.used, 196101848
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.CodeHeap-'non-nmethods'.usage, 0.3121266690091356
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.CodeHeap-'non-profiled-nmethods'.usage, 0.1445920390549502
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.CodeHeap-'profiled-nmethods'.usage, 0.31450363236470275
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.Compressed-Class-Space.usage, 0.011371321976184845
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.Metaspace.usage, 0.973860567536034
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.PS-Eden-Space.usage, 0.05029633465935202
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.PS-Old-Gen.usage, 0.11733333848850581
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorypools.PS-Survivor-Space.usage, 0.71875
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorytotal.committed, 466395136
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorytotal.init, 72679424
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorytotal.max, 1908932607
2023-09-05 09:45:09,296 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail memorytotal.used, 400753088
2023-09-05 09:45:09,297 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail threadsdeadlocks, []
2023-09-05 09:45:09,297 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail threadsnew.count, 0
2023-09-05 09:45:09,298 DEBUG [c.c.s.StatsCollector] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) not storing detail threadstimed_waiting.count, 77
2023-09-05 09:45:09,300 DEBUG [c.c.c.ClusterManagerImpl] (StatsCollector-2:ctx-94f2c9d2) (logid:d302756e) Forwarding {"managementServerHostId":1,"managementServerHostUuid":"338e7add-63ad-4f3b-912d-d375198b1eb5","collectionTime":"Sep 5, 2023, 9:45:09 AM","sessions":1,"cpuUtilization":0.0,"totalJvmMemoryBytes":264765440,"freeJvmMemoryBytes":61098120,"maxJvmMemoryBytes":1908932607,"processJvmMemoryBytes":0,"jvmUptime":50149756,"jvmStartTime":1693856959466,"availableProcessors":2,"loadAverage":0.36328125,"totalInit":72679424,"totalUsed":399769168,"totalCommitted":466395136,"pid":101325,"jvmName":"101325@tfcloudstack","jvmVendor":"Ubuntu","jvmVersion":"11.0.20.1+1-post-Ubuntu-0ubuntu122.04","osDistribution":"Ubuntu 22.04.2 LTS","agentCount":0,"heapMemoryUsed":204560280,"heapMemoryTotal":1908932608,"threadsBlockedCount":0,"threadsDaemonCount":23,"threadsRunnableCount":10,"threadsTerminatedCount":0,"threadsTotalCount":218,"threadsWaitingCount":131,"systemMemoryTotal":4101971968,"systemMemoryFree":385712128,"systemMemoryUsed":738128,"systemMemoryVirtualSize":5119811584,"logInfo":"/var/log/cloudstack/management/management-server.log using: 15M\non disk /dev/vda1 mounted on / (80% full)","systemTotalCpuCycles":6800.0,"systemLoadAverages":[0.36,0.17,0.16],"systemCyclesUsage":[318541,149007,45639728],"dbLocal":true,"usageLocal":false,"systemBootTime":"Sep 2, 2023, 3:51:43 PM","kernelVersion":"5.15.0-76-generic"} to 90520743718580
2023-09-05 09:45:09,300 DEBUG [c.c.c.ClusterManagerImpl] (Cluster-Worker-2:ctx-d39f939d) (logid:50798437) Cluster PDU 90520743718580 -> 90520743718580. agent: 0, pdu seq: 1653, pdu ack seq: 0, json: {"managementServerHostId":1,"managementServerHostUuid":"338e7add-63ad-4f3b-912d-d375198b1eb5","collectionTime":"Sep 5, 2023, 9:45:09 AM","sessions":1,"cpuUtilization":0.0,"totalJvmMemoryBytes":264765440,"freeJvmMemoryBytes":61098120,"maxJvmMemoryBytes":1908932607,"processJvmMemoryBytes":0,"jvmUptime":50149756,"jvmStartTime":1693856959466,"availableProcessors":2,"loadAverage":0.36328125,"totalInit":72679424,"totalUsed":399769168,"totalCommitted":466395136,"pid":101325,"jvmName":"101325@tfcloudstack","jvmVendor":"Ubuntu","jvmVersion":"11.0.20.1+1-post-Ubuntu-0ubuntu122.04","osDistribution":"Ubuntu 22.04.2 LTS","agentCount":0,"heapMemoryUsed":204560280,"heapMemoryTotal":1908932608,"threadsBlockedCount":0,"threadsDaemonCount":23,"threadsRunnableCount":10,"threadsTerminatedCount":0,"threadsTotalCount":218,"threadsWaitingCount":131,"systemMemoryTotal":4101971968,"systemMemoryFree":385712128,"systemMemoryUsed":738128,"systemMemoryVirtualSize":5119811584,"logInfo":"/var/log/cloudstack/management/management-server.log using: 15M\non disk /dev/vda1 mounted on / (80% full)","systemTotalCpuCycles":6800.0,"systemLoadAverages":[0.36,0.17,0.16],"systemCyclesUsage":[318541,149007,45639728],"dbLocal":true,"usageLocal":false,"systemBootTime":"Sep 2, 2023, 3:51:43 PM","kernelVersion":"5.15.0-76-generic"}
2023-09-05 09:45:09,302 DEBUG [c.c.c.ClusterServiceServletImpl] (Cluster-Worker-2:ctx-d39f939d) (logid:50798437) POST http://192.168.122.141:9090/clusterservice response :true, responding time: 2 ms
2023-09-05 09:45:09,303 DEBUG [c.c.c.ClusterManagerImpl] (Cluster-Worker-2:ctx-d39f939d) (logid:50798437) Cluster PDU 90520743718580 -> 90520743718580 completed. time: 2ms. agent: 0, pdu seq: 1653, pdu ack seq: 0, json: {"managementServerHostId":1,"managementServerHostUuid":"338e7add-63ad-4f3b-912d-d375198b1eb5","collectionTime":"Sep 5, 2023, 9:45:09 AM","sessions":1,"cpuUtilization":0.0,"totalJvmMemoryBytes":264765440,"freeJvmMemoryBytes":61098120,"maxJvmMemoryBytes":1908932607,"processJvmMemoryBytes":0,"jvmUptime":50149756,"jvmStartTime":1693856959466,"availableProcessors":2,"loadAverage":0.36328125,"totalInit":72679424,"totalUsed":399769168,"totalCommitted":466395136,"pid":101325,"jvmName":"101325@tfcloudstack","jvmVendor":"Ubuntu","jvmVersion":"11.0.20.1+1-post-Ubuntu-0ubuntu122.04","osDistribution":"Ubuntu 22.04.2 LTS","agentCount":0,"heapMemoryUsed":204560280,"heapMemoryTotal":1908932608,"threadsBlockedCount":0,"threadsDaemonCount":23,"threadsRunnableCount":10,"threadsTerminatedCount":0,"threadsTotalCount":218,"threadsWaitingCount":131,"systemMemoryTotal":4101971968,"systemMemoryFree":385712128,"systemMemoryUsed":738128,"systemMemoryVirtualSize":5119811584,"logInfo":"/var/log/cloudstack/management/management-server.log using: 15M\non disk /dev/vda1 mounted on / (80% full)","systemTotalCpuCycles":6800.0,"systemLoadAverages":[0.36,0.17,0.16],"systemCyclesUsage":[318541,149007,45639728],"dbLocal":true,"usageLocal":false,"systemBootTime":"Sep 2, 2023, 3:51:43 PM","kernelVersion":"5.15.0-76-generic"}
2023-09-05 09:45:09,305 DEBUG [c.c.s.StatsCollector] (Cluster-Worker-402:ctx-93368309) (logid:a91c4bc8) StatusUpdate from 90520743718580, json: {"managementServerHostId":1,"managementServerHostUuid":"338e7add-63ad-4f3b-912d-d375198b1eb5","collectionTime":"Sep 5, 2023, 9:45:09 AM","sessions":1,"cpuUtilization":0.0,"totalJvmMemoryBytes":264765440,"freeJvmMemoryBytes":61098120,"maxJvmMemoryBytes":1908932607,"processJvmMemoryBytes":0,"jvmUptime":50149756,"jvmStartTime":1693856959466,"availableProcessors":2,"loadAverage":0.36328125,"totalInit":72679424,"totalUsed":399769168,"totalCommitted":466395136,"pid":101325,"jvmName":"101325@tfcloudstack","jvmVendor":"Ubuntu","jvmVersion":"11.0.20.1+1-post-Ubuntu-0ubuntu122.04","osDistribution":"Ubuntu 22.04.2 LTS","agentCount":0,"heapMemoryUsed":204560280,"heapMemoryTotal":1908932608,"threadsBlockedCount":0,"threadsDaemonCount":23,"threadsRunnableCount":10,"threadsTerminatedCount":0,"threadsTotalCount":218,"threadsWaitingCount":131,"systemMemoryTotal":4101971968,"systemMemoryFree":385712128,"systemMemoryUsed":738128,"systemMemoryVirtualSize":5119811584,"logInfo":"/var/log/cloudstack/management/management-server.log using: 15M\non disk /dev/vda1 mounted on / (80% full)","systemTotalCpuCycles":6800.0,"systemLoadAverages":[0.36,0.17,0.16],"systemCyclesUsage":[318541,149007,45639728],"dbLocal":true,"usageLocal":false,"systemBootTime":"Sep 2, 2023, 3:51:43 PM","kernelVersion":"5.15.0-76-generic"}
2023-09-05 09:45:09,750 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:Failed to generate CSR file, retrying after removing existing settings
Reverting libvirtd to not listen on TLS
Removing cloud.* files in /etc/cloudstack/agent
Retrying to generate CSR file
Failed to generate CSR file while retrying


2023-09-05 09:45:09,750 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-05 09:45:11,208 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-1:ctx-b4358b71) (logid:275f71ec) HA health check task is running...
2023-09-05 09:45:12,016 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:Failed to generate CSR file, retrying after removing existing settings
Reverting libvirtd to not listen on TLS
Removing cloud.* files in /etc/cloudstack/agent
Retrying to generate CSR file
Failed to generate CSR file while retrying


2023-09-05 09:45:12,017 WARN  [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
2023-09-05 09:45:12,017 DEBUG [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2)  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
2023-09-05 09:45:12,017 DEBUG [c.c.r.ResourceManagerImpl] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:45:12,017 INFO  [c.c.u.e.CSExceptionErrorCode] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Could not find exception: com.cloud.exception.DiscoveryException in error code list for exceptions
2023-09-05 09:45:12,017 WARN  [o.a.c.a.c.a.h.AddHostCmd] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Exception: 
com.cloud.exception.DiscoveryException: Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:818)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.base/java.lang.reflect.Method.invoke(Method.java:566)
        at org.springframework.aop.support.AopUtils.invokeJoinpointUsingReflection(AopUtils.java:344)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.invokeJoinpoint(ReflectiveMethodInvocation.java:198)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:163)
        at org.springframework.aop.interceptor.ExposeInvocationInterceptor.invoke(ExposeInvocationInterceptor.java:97)
        at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:186)
        at org.springframework.aop.framework.JdkDynamicAopProxy.invoke(JdkDynamicAopProxy.java:215)
        at com.sun.proxy.$Proxy200.discoverHosts(Unknown Source)
        at org.apache.cloudstack.api.command.admin.host.AddHostCmd.execute(AddHostCmd.java:136)
        at com.cloud.api.ApiDispatcher.dispatch(ApiDispatcher.java:163)
        at com.cloud.api.ApiServer.queueCommand(ApiServer.java:777)
        at com.cloud.api.ApiServer.handleRequest(ApiServer.java:601)
        at com.cloud.api.ApiServlet.processRequestInContext(ApiServlet.java:347)
        at com.cloud.api.ApiServlet$1.run(ApiServlet.java:154)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext$1.call(DefaultManagedContext.java:55)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.callWithContext(DefaultManagedContext.java:102)
        at org.apache.cloudstack.managed.context.impl.DefaultManagedContext.runWithContext(DefaultManagedContext.java:52)
        at com.cloud.api.ApiServlet.processRequest(ApiServlet.java:151)
        at com.cloud.api.ApiServlet.doPost(ApiServlet.java:110)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:665)
        at javax.servlet.http.HttpServlet.service(HttpServlet.java:750)
        at org.eclipse.jetty.servlet.ServletHolder$NotAsync.service(ServletHolder.java:1450)
        at org.eclipse.jetty.servlet.ServletHolder.handle(ServletHolder.java:799)
        at org.eclipse.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:554)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:143)
        at org.eclipse.jetty.security.SecurityHandler.handle(SecurityHandler.java:600)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:235)
        at org.eclipse.jetty.server.session.SessionHandler.doHandle(SessionHandler.java:1624)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextHandle(ScopedHandler.java:233)
        at org.eclipse.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1440)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:188)
        at org.eclipse.jetty.servlet.ServletHandler.doScope(ServletHandler.java:505)
        at org.eclipse.jetty.server.session.SessionHandler.doScope(SessionHandler.java:1594)
        at org.eclipse.jetty.server.handler.ScopedHandler.nextScope(ScopedHandler.java:186)
        at org.eclipse.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1355)
        at org.eclipse.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
        at org.eclipse.jetty.server.handler.gzip.GzipHandler.handle(GzipHandler.java:772)
        at org.eclipse.jetty.server.handler.HandlerCollection.handle(HandlerCollection.java:146)
        at org.eclipse.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:127)
        at org.eclipse.jetty.server.Server.handle(Server.java:516)
        at org.eclipse.jetty.server.HttpChannel.lambda$handle$1(HttpChannel.java:487)
        at org.eclipse.jetty.server.HttpChannel.dispatch(HttpChannel.java:732)
        at org.eclipse.jetty.server.HttpChannel.handle(HttpChannel.java:479)
        at org.eclipse.jetty.server.HttpConnection.onFillable(HttpConnection.java:277)
        at org.eclipse.jetty.io.AbstractConnection$ReadCallback.succeeded(AbstractConnection.java:311)
        at org.eclipse.jetty.io.FillInterest.fillable(FillInterest.java:105)
        at org.eclipse.jetty.io.ChannelEndPoint$1.run(ChannelEndPoint.java:104)
        at org.eclipse.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:883)
        at org.eclipse.jetty.util.thread.QueuedThreadPool$Runner.run(QueuedThreadPool.java:1034)
        at java.base/java.lang.Thread.run(Thread.java:829)
Caused by: com.cloud.exception.DiscoveredWithErrorException:  can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:376)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        at com.cloud.resource.ResourceManagerImpl.discoverHosts(ResourceManagerImpl.java:644)
        ... 54 more
Caused by: com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.setupAgentSecurity(LibvirtServerDiscoverer.java:178)
        at com.cloud.hypervisor.kvm.discoverer.LibvirtServerDiscoverer.find(LibvirtServerDiscoverer.java:321)
        at com.cloud.resource.ResourceManagerImpl.discoverHostsFull(ResourceManagerImpl.java:811)
        ... 55 more
2023-09-05 09:45:12,018 INFO  [c.c.a.ApiServer] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) Could not add host at [http://tfcloudstack] with zone [1], pod [1] and cluster [2] due to: [ can't setup agent, due to com.cloud.utils.exception.CloudRuntimeException: Failed to setup keystore on the KVM host: 192.168.122.141 - Failed to setup keystore on the KVM host: 192.168.122.141].
2023-09-05 09:45:12,018 DEBUG [c.c.a.ApiServlet] (qtp1278852808-20:ctx-dfebc674 ctx-62fbfc35) (logid:3a4fd9e2) ===END===  192.168.122.1 -- POST  command=addHost&response=json
```

#### No such file or directory: '/etc/network/interfaces'

sudo mkdir /etc/network/interfaces

See: https://rohityadav.cloud/blog/cloudstack-kvm/


Configure Network ...         Configure Network failed, Please check the /var/log/cloudstack/agent/setup.log for detail, due to:[Errno 2] No such file or directory: '/etc/network/interfaces'


```text
DEBUG:root:execute:uname -r
DEBUG:root:execute:uname -m
DEBUG:root:execute:hostname -f
DEBUG:root:execute:kvm-ok
DEBUG:root:execute:awk '/MemTotal/ { printf "%.3f \n", $2/1024 }' /proc/meminfo
DEBUG:root:execute:ip a | grep "^\w" | grep -iv "^lo" | wc -l
DEBUG:root:execute:service apparmor status
DEBUG:root:execute:apparmor_status |grep libvirt
DEBUG:root:Failed to execute:
DEBUG:root:cloudbr0 is not a network device, is it down?
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:route -n|awk '/^0.0.0.0/ {print $2,$8}'
DEBUG:root:execute:ifconfig eth0
DEBUG:root:execute:which ovs-vsctl
DEBUG:root:Failed to execute:
DEBUG:root:Found default network device:eth0
DEBUG:root:[Errno 2] No such file or directory: '/etc/network/interfaces'
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 38, in configuration
    result = self.config()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 211, in config
    super(networkConfigUbuntu, self).cfgNetwork()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 116, in cfgNetwork
    self.writeToCfgFile(brName, device)
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 190, in writeToCfgFile
    cfg = open(self.netCfgFile).read()

DEBUG:root:execute:sudo update-rc.d -f apparmor remove
DEBUG:root:execute:sudo update-rc.d -f apparmor defaults
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
```

sudo mkdir /etc/network/interfaces


```text
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:route -n|awk '/^0.0.0.0/ {print $2,$8}'
DEBUG:root:execute:ifconfig eth0
DEBUG:root:execute:which ovs-vsctl
DEBUG:root:Failed to execute:
DEBUG:root:Found default network device:eth0
DEBUG:root:[Errno 21] Is a directory: '/etc/network/interfaces'
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 38, in configuration
    result = self.config()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 211, in config
    super(networkConfigUbuntu, self).cfgNetwork()
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 116, in cfgNetwork
    self.writeToCfgFile(brName, device)
  File "/usr/lib/python3/dist-packages/cloudutils/serviceConfig.py", line 190, in writeToCfgFile
    cfg = open(self.netCfgFile).read()

DEBUG:root:execute:sudo update-rc.d -f apparmor remove
DEBUG:root:execute:sudo update-rc.d -f apparmor defaults
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
```

* sudo rmdir /etc/network/interfaces
* sudo touch /etc/network/interfaces

```text
DEBUG:root:execute:ifconfig eth0
DEBUG:root:execute:which ovs-vsctl
DEBUG:root:Failed to execute:
DEBUG:root:Found default network device:eth0
DEBUG:root:execute:sudo update-rc.d -f apparmor remove
DEBUG:root:execute:sudo update-rc.d -f apparmor defaults
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo update-rc.d -f network-manager remove
DEBUG:root:execute:sudo update-rc.d -f network-manager defaults
DEBUG:root:Failed to execute:update-rc.d: error: unable to read /etc/init.d/network-manager
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager start
DEBUG:root:Failed to execute:Failed to start network-manager.service: Unit network-manager.service not found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager start
DEBUG:root:Failed to execute:Failed to start network-manager.service: Unit network-manager.service not found.
DEBUG:root:execute:/etc/init.d/networking stop
DEBUG:root:Failed to execute:/bin/sh: 1: /etc/init.d/networking: not found
DEBUG:root:execute:/etc/init.d/networking start
DEBUG:root:Failed to execute:/bin/sh: 1: /etc/init.d/networking: not found
```


```text
2023-09-06 05:44:52,906 DEBUG [c.c.a.ApiServlet] (qtp1278852808-13:ctx-aada519d) (logid:bdeb3e43) ===START===  192.168.122.1 -- POST  command=addHost&response=json
2023-09-06 05:44:52,907 DEBUG [c.c.a.ApiServlet] (qtp1278852808-13:ctx-aada519d) (logid:bdeb3e43) Two factor authentication is already verified for the user 2, so skipping
2023-09-06 05:44:52,914 DEBUG [c.c.a.ApiServer] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) CIDRs from which account 'Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]' is allowed to perform API calls: 0.0.0.0/0,::/0
2023-09-06 05:44:52,916 INFO  [o.a.c.a.DynamicRoleBasedAPIAccessChecker] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Account [Account [{"accountName":"admin","id":2,"uuid":"6c8b47f3-4b5d-11ee-b641-525400c62eb4"}]] is Root Admin or Domain Admin, all APIs are allowed.
2023-09-06 05:44:52,917 WARN  [o.a.c.a.ProjectRoleBasedApiAccessChecker] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Project is null, ProjectRoleBasedApiAccessChecker only applies to projects, returning API [addHost] for user [User {"username":"admin","uuid":"6c8c67d4-4b5d-11ee-b641-525400c62eb4"}.] as allowed.
2023-09-06 05:44:52,918 DEBUG [o.a.c.a.StaticRoleBasedAPIAccessChecker] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) RoleService is enabled. We will use it instead of StaticRoleBasedAPIAccessChecker.
2023-09-06 05:44:52,919 DEBUG [o.a.c.r.ApiRateLimitServiceImpl] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) API rate limiting is disabled. We will not use ApiRateLimitService.
2023-09-06 05:44:52,922 WARN  [c.c.a.d.ParamGenericValidationWorker] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Received unknown parameters for command addHost. Unknown parameters : clustertype
2023-09-06 05:44:52,926 INFO  [c.c.r.ResourceManagerImpl] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Trying to add a new host at http://tfcloudstack in data center 1
2023-09-06 05:44:53,090 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Executing cmd: ls /dev/kvm
2023-09-06 05:44:54,663 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) SSH command: ls /dev/kvm
SSH command output:/dev/kvm


2023-09-06 05:44:54,673 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
2023-09-06 05:44:55,324 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-1:ctx-cf95ee5d) (logid:e22e3bfa) HA health check task is running...
2023-09-06 05:44:56,932 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) SSH command: sudo /usr/share/cloudstack-common/scripts/util/keystore-setup /etc/cloudstack/agent/agent.properties /etc/cloudstack/agent/
SSH command output:

2023-09-06 05:44:57,089 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Executing cmd: sudo /usr/share/cloudstack-common/scripts/util/keystore-cert-import /etc/cloudstack/agent/agent.properties nB9x5f6JmqO2VQNh /etc/cloudstack/agent/
2023-09-06 05:44:59,327 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-2:ctx-a40116ac) (logid:cdd03284) HA health check task is running...
2023-09-06 05:45:00,429 DEBUG [c.c.h.k.d.LibvirtServerDiscoverer] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Succeeded to import certificate in the keystore for agent on the KVM host: 192.168.122.141. Agent secured and trusted.
2023-09-06 05:45:00,432 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) Executing cmd: sudo cloudstack-setup-agent  -m 192.168.122.141 -z 1 -p 1 -c 2 -g 9aecf724-f201-3470-b515-03e0b1162dca -a -s  --pubNic=cloudbr0 --prvNic=cloudbr0 --guestNic=cloudbr0 --hypervisor=kvm
2023-09-06 05:45:03,328 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-5:ctx-81307cd0) (logid:6a9bcd6b) HA health check task is running...
2023-09-06 05:45:07,329 DEBUG [o.a.c.h.HAManagerImpl] (BackgroundTaskPollManager-1:ctx-e7b18898) (logid:ccba951b) HA health check task is running...
2023-09-06 05:45:07,961 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-96ed2621) (logid:e67fa83e) Found 0 routers to update status. 
2023-09-06 05:45:07,962 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-96ed2621) (logid:e67fa83e) Found 0 VPC's to update Redundant State. 
2023-09-06 05:45:07,963 DEBUG [c.c.n.r.VirtualNetworkApplianceManagerImpl] (RouterStatusMonitor-1:ctx-96ed2621) (logid:e67fa83e) Found 0 networks to update RvR status. 
2023-09-06 05:45:08,184 DEBUG [c.c.s.StatsCollector] (StatsCollector-4:ctx-fe3d4a41) (logid:233c8399) DbCollector is running...
2023-09-06 05:45:08,216 DEBUG [c.c.u.s.SSHCmdHelper] (qtp1278852808-13:ctx-aada519d ctx-97dba6cb) (logid:bdeb3e43) SSH command: sudo cloudstack-setup-agent  -m 192.168.122.141 -z 1 -p 1 -c 2 -g 9aecf724-f201-3470-b515-03e0b1162dca -a -s  --pubNic=cloudbr0 --prvNic=cloudbr0 --guestNic=cloudbr0 --hypervisor=kvm
SSH command output:Starting to configure your system:
Configure Host ...            [OK]
Configure Apparmor ...        [OK]
Configure Network ...         [Failed]
Can't start network:cloudbr0 /bin/sh: 1: ifup: not found
Try to restore your system:
Restore Host ...              [OK]
Restore Apparmor ...          [OK]
Restore Network ...           [OK]
```

https://linuxconfig.org/how-to-switch-back-networking-to-etc-network-interfaces-on-ubuntu-22-04-jammy-jellyfish-linux

cloudstack-setup-agent  -m 192.168.122.141 -z 1 -p 1 -c 2 -g 9aecf724-f201-3470-b515-03e0b1162dca -a -s  --pubNic=cloudbr0 --prvNic=cloudbr0 --guestNic=cloudbr0 --hypervisor=kvm

agent/setup.log

```text
DEBUG:root:execute:uname -r
DEBUG:root:execute:uname -m
DEBUG:root:execute:hostname -f
DEBUG:root:execute:kvm-ok
DEBUG:root:execute:awk '/MemTotal/ { printf "%.3f \n", $2/1024 }' /proc/meminfo
DEBUG:root:execute:ip a | grep "^\w" | grep -iv "^lo" | wc -l
DEBUG:root:execute:service apparmor status
DEBUG:root:execute:apparmor_status |grep libvirt
DEBUG:root:Failed to execute:
DEBUG:root:cloudbr0 is not a network device, is it down?
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:route -n|awk '/^0.0.0.0/ {print $2,$8}'
DEBUG:root:execute:ifconfig eth0
DEBUG:root:execute:which ovs-vsctl
DEBUG:root:Failed to execute:
DEBUG:root:Found default network device:eth0
DEBUG:root:cloudbr0:eth0 already configured
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager stop
DEBUG:root:Failed to execute:Failed to stop network-manager.service: Unit network-manager.service not loaded.
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager stop
DEBUG:root:Failed to execute:Failed to stop network-manager.service: Unit network-manager.service not loaded.
DEBUG:root:execute:sudo update-rc.d -f network-manager remove
DEBUG:root:execute:ifup cloudbr0
DEBUG:root:Failed to execute:/bin/sh: 1: ifup: not found
DEBUG:root:execute:sudo update-rc.d -f apparmor remove
DEBUG:root:execute:sudo update-rc.d -f apparmor defaults
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo /usr/sbin/service apparmor status
DEBUG:root:execute:sudo /usr/sbin/service apparmor start
DEBUG:root:execute:sudo update-rc.d -f network-manager remove
DEBUG:root:execute:sudo update-rc.d -f network-manager defaults
DEBUG:root:Failed to execute:update-rc.d: error: unable to read /etc/init.d/network-manager
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager start
DEBUG:root:Failed to execute:Failed to start network-manager.service: Unit network-manager.service not found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager status
DEBUG:root:Failed to execute:Unit network-manager.service could not be found.
DEBUG:root:execute:sudo /usr/sbin/service network-manager start
DEBUG:root:Failed to execute:Failed to start network-manager.service: Unit network-manager.service not found.
DEBUG:root:execute:/etc/init.d/networking stop
DEBUG:root:Failed to execute:/bin/sh: 1: /etc/init.d/networking: not found
DEBUG:root:execute:/etc/init.d/networking start
DEBUG:root:Failed to execute:/bin/sh: 1: /etc/init.d/networking: not found
```

Try: sudo apt install ifupdown net-tools