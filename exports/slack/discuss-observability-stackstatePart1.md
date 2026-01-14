

**Marc Rua Herrera** (2025-03-19 11:59):
This is in Merck. I am aware of the bug at Rabo, but I am not sure if it id the same or not. I believe it is not

---

**Amol Kharche** (2025-03-19 13:04):
Not sure if it related to https://stackstate.atlassian.net/browse/STAC-22443. cc: @Remco Beckers

---

**Remco Beckers** (2025-03-19 13:06):
If you're not seeing any logs it is not related to STAC-22443.

---

**Dinesh Chandra** (2025-03-20 02:07):
Is there any document for different components and functions? More specifically which has what PV has what data and purpose?
My customer wants to put small notes/description on each PV.  Below is related to 5.1 but doesnt have PV specific info. Not sure if this is still applicable?
https://docs.stackstate.com/5.1/use/concepts/stackstate_architecture

---

**Amol Kharche** (2025-03-20 05:32):
This link can explain components and its function.
Overview-of-subsystems (https://docs.stackstate.com/self-hosted-setup/install-stackstate/troubleshooting/advanced-troubleshooting#overview-of-subsystems) .

---

**Dinesh Chandra** (2025-03-20 06:23):
Thanks @Amol Kharche

---

**Warner Chen** (2025-03-20 08:53):
Hi Team, Does SOB have a built-in watchdog mechanism to monitor whether the alerting system itself is functioning properly?

---

**Louis Lotter** (2025-03-20 08:56):
We do have some self monitoring capabilities yes. @Remco Beckers or @Lukasz Marchewka can you guys expand on that for Warner ?

---

**Remco Beckers** (2025-03-20 09:12):
Yes, but that's not really a watchdog. What we have is, as part of the SUSE Observability stackpack, a form of self-monitoring where if a pod goes down or some processing becomes very slow a monitor triggers. But if it is the monitor/notification system itself that is in trouble chances are the alert will not reach you timely.

We don't have real watchdog behavior, to have that we would need a monitor that will periodically trigger an alert that can then be used in the notification system to trigger, for example, the DeadManSwitch in PagerDuty or the HeartBeats in Opsgenie.

Is that the thing you're looking for?

---

**Warner Chen** (2025-03-20 09:45):
Yes, I am also looking for available metrics to create watchdog alert rules for self-monitoring.

---

**Remco Beckers** (2025-03-20 09:54):
You mean simply a metric that is always present or a metric that reflects the health of the monitors / notifications?

---

**Remco Beckers** (2025-03-20 09:58):
Either way you could use the metrics that are used to track running of monitors, they are produced internally (directly from the monitor system to the metric store). For example:
```changes(stackstate_monitor_latency_seconds_count{stackstate_app="true"}[5m])```

---

**Warner Chen** (2025-03-20 10:12):
Yes both are fine. I’m looking for a metric similar to `vector(1)`.:joy:

---

**Remco Beckers** (2025-03-20 10:14):
Haha, you can then simply run that query. That's even easier, it's just promql: `1` will give you a consistent value of 1

---

**Warner Chen** (2025-03-20 10:25):
yes i will do a test. thx so much Louis and Remco!

---

**Bram Schuur** (2025-03-20 10:53):
Is there anything In the receiver logs @Marc Rua Herrera?

---

**Marc Rua Herrera** (2025-03-20 11:32):
That's something I have not checked. I don't have access by myself to their env tho. I will check with them later.

---

**Bram Schuur** (2025-03-20 13:24):
Nothing relevant there. Is there anything in the middle between agent/platform that might bounce the request? Like a proxy/gateway or somesuch?

---

**Remco Beckers** (2025-03-20 13:27):
Don't logs go through the `receiver-logs` pod?

---

**Bram Schuur** (2025-03-20 13:28):
good catch, could you get the logs for that pod @Marc Rua Herrera?

---

**Marc Rua Herrera** (2025-03-20 13:29):
Nothing in there:

---

**Marc Rua Herrera** (2025-03-20 13:31):
There is nothing in between the agent and StS. Also, metrics, topology are arriving to StackState. Only thing we miss are the logs

---

**Rajesh Kumar** (2025-03-20 14:24):
Hi Team, While installing the observability-agent through Rancher, we have found inconsistencies in the way the values file is rendered.

1 - Configuring the private registry url updates the image.registry (https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability-agent/values.yaml#L81), but imageRegistry (https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability-agent/values.yaml#L7) stays same registry.rancher.com (http://registry.rancher.com) and images are pulled through registry.rancher.com (http://registry.rancher.com).
2 -  Adding username in the UI adds username under imagePullCredentials.username instead of imagePullCredentials.&lt;registryname&gt;.username as shown (https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability-agent/templates/pull-secret.yaml#L5) here.
3 - There is no option to disable SSL check on the UI.

---

**Bram Schuur** (2025-03-20 15:14):
@Marc Rua Herrera i double checked and the receiver should log all 4xx errors, which makes me think we are not reaching the receiver but the 4xx is coming from something inbetween.  Could you check the router pod? What URL was the agent configured with? Does the the 'scheme' part of the url (http/https) match the encryption of the instance?

---

**Warner Chen** (2025-03-20 15:39):
The *Add new metric threshold monitor* requires setting an identifier, but `vector(1)` does not have any available labels. It seems not feasible.:thinking_face:

---

**Remco Beckers** (2025-03-20 15:49):
You don't need to have any labels, you can also use a fixed identifier. The identifier maps the monitor state to a component so you could simply pick a component where you'd want to map that health state onto and use its exact identifier.
The side-effect is that that component is always in a critical  or deviating state

---

**Rajesh Kumar** (2025-03-21 06:57):
@Mark Bakker, I need your help understanding it. I am not sure if it should go into Rancher or Observability

---

**Mark Bakker** (2025-03-21 08:42):
@Bram Schuur can you have a look with your team?

---

**Saurabh Sadhale** (2025-03-21 08:47):
Hello we are attempting to install StackState on an ARO ( Azure Red Hat OpenShift ) cluster. The click house pod fails to come up because of the following error:

We have attempted to provide scc but still it fails.

---

**Louis Lotter** (2025-03-21 08:53):
<!here> We have noticed quite a few people using the SOB acronym for Suse Observability. As there are some obviously negative connotations to SOB we would really prefer this does not become a standard way to refer to our team and product.
Could we plead of everyone to use Suse Obs or come up with another more suitable acronym :pleading_face:.
Pretty please.

---

**Paul Gonin** (2025-03-21 08:55):
Actually “Acronyms are not allowed per new brand guidelines”

---

**Manuel Recena** (2025-03-21 08:56):
This is why I write every time SUSE Application Collection instead of AppCo :laughing:

---

**Bram Schuur** (2025-03-21 08:58):
I added the following ticket and scheduled it for next sprint: https://stackstate.atlassian.net/browse/STAC-22549

---

**Paul Gonin** (2025-03-21 08:58):
correction... I did not find "Not allowed"...  it is in Ground Rules "Acronyms are bad"

---

**Louis Lotter** (2025-03-21 08:59):
Yeah. I think for a long time Suse Observability is just more clear to everyone anyways.

---

**Javier Lagos** (2025-03-21 08:59):
Hey @Saurabh Sadhale,this looks like a problem related with the SCC default configured by Openshift in all the pods automatically and probably Clickhouse pod requires more permissions. Try executing this command and let me know if it helps.

oc adm policy add-scc-to-user anyuid system:serviceaccount:suse-observability:<serviceaccount-of-clickhouse-pod>

I don't know if there is a possibility to modify this pod to not require this extra permissions.

---

**Paul Gonin** (2025-03-21 08:59):
~Suse~ SUSE though :wink:

---

**Louis Lotter** (2025-03-21 09:00):
:slightly_smiling_face:

---

**Yingluo Zhang** (2025-03-21 09:02):
SUSE O11y :grin:

---

**Yingluo Zhang** (2025-03-21 09:02):
just like k8s

---

**Remco Beckers** (2025-03-21 09:07):
Would be nice to be able to not need the full name, but just using "Observability" or "O11y" will be to generic and confusing

---

**Vladimir Iliakov** (2025-03-21 09:07):
For some of the workload we can't adopt the securityContext. @Saurabh Sadhale have you tried this SCC https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/openshift_install#manually-create-secu[…]configuration-objects (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/openshift_install#manually-create-securitycontextconfiguration-objects). We don't regurlarly test it, I can't say if we have tested it with Clickhouse....

---

**Remco Beckers** (2025-03-21 09:08):
Now I wonder if "o11y" also counts as an acronym and is bad...

---

**Marc Rua Herrera** (2025-03-21 09:24):
I need to check again with the customer. I will do in our next session.

---

**Frank van Lankvelt** (2025-03-21 09:25):
I think you know the answer to that.  It's a big improvement over SOB, so I would be happy to use that for internal communications.  Don't think it should ever be used outside of SUSE though

---

**Remco Beckers** (2025-03-21 09:27):
Not for the name no, but I use it all the time for abbreviating the annoyingly long "observability", similar to k8s

---

**Bram Schuur** (2025-03-21 10:01):
Coolio, i will be on holiday next week, so you'll have to pull in someone else to continue this one

---

**Saurabh Sadhale** (2025-03-21 11:12):
@Javier Lagos appreciate your update. I tried that already but that did not work.

@Vladimir Iliakov does that mean we need to create one more SCC for clickchouse ?

I can see that there is an sCC object created while the installation was done.

```oc describe scc suse-observability-suse-observability
Name:						suse-observability-suse-observability
Priority:					&lt;none&gt;
Access:						
  Users:					&lt;none&gt;
  Groups:					system:serviceaccounts:suse-observability
Settings:					
  Allow Privileged:				false
  Allow Privilege Escalation:			true
  Default Add Capabilities:			&lt;none&gt;
  Required Drop Capabilities:			&lt;none&gt;
  Allowed Capabilities:				&lt;none&gt;
  Allowed Seccomp Profiles:			&lt;none&gt;
  Allowed Volume Types:				configMap,downwardAPI,emptyDir,ephemeral,persistentVolumeClaim,projected,secret
  Allowed Flexvolumes:				&lt;all&gt;
  Allowed Unsafe Sysctls:			&lt;none&gt;
  Forbidden Sysctls:				&lt;none&gt;
  Allow Host Network:				false
  Allow Host Ports:				false
  Allow Host PID:				false
  Allow Host IPC:				false
  Read Only Root Filesystem:			false
  Run As User Strategy: RunAsAny		
    UID:					&lt;none&gt;
    UID Range Min:				&lt;none&gt;
    UID Range Max:				&lt;none&gt;
  SELinux Context Strategy: MustRunAs		
    User:					&lt;none&gt;
    Role:					&lt;none&gt;
    Type:					&lt;none&gt;
    Level:					&lt;none&gt;
  FSGroup Strategy: RunAsAny			
    Ranges:					&lt;none&gt;
  Supplemental Groups Strategy: RunAsAny	
    Ranges:					&lt;none&gt;```

---

**Vladimir Iliakov** (2025-03-21 11:41):
@Saurabh Sadhale Can we get a full error message in plain-text? Maybe we can adopt Clichouse values...

---

**Vladimir Iliakov** (2025-03-21 11:42):
@Mark Bakker just want to confirm if we still support the platform installation to Openshift?

---

**Saurabh Sadhale** (2025-03-21 11:51):
```create Pod suse-observability-clickhouse-shardO-O in StatefulSet suse-observability-clickhouse-shardO failed error: pods "suse-observability-clickhouse-shardO-O" is forbidden: unable to validate against any security context constraint: [provider "anyuid":
Forbidden: not usable by user or serviceaccount, provider restricted-v2: spec.securityContext.fsGroup: Invalid value: []int64{1001}: 1001 is not an allowed group, provider restricted-v2: .containers[OJ.runAsUser: Invalid value: 1001: must be in the ranges: [1000750000, 1000759999], provider restricted-v2: .containers[l].runAsUser: Invalid value: 1001: must be in the ranges: [1000750000, 1000759999], provider "restricted": Forbidden: not usable by user or serviceaccount, provider "nonroot-v2": Forbidden: not usable by user or serviceaccount, provider "nonroot": Forbidden: not usable by user or serviceaccount, pod.metadata.annotations[seccomp.security.alpha.kubernetes.io/pod (http://seccomp.security.alpha.kubernetes.io/pod)]: Forbidden: seccomp may not be set, pod.metadata.annotations[container.seccomp.security.alpha.kubernetes.io/clickhouse (http://container.seccomp.security.alpha.kubernetes.io/clickhouse)]: Forbidden: seccomp may not be set, pod.metadata.annotations[container.seccomp.security.alpha.kubernetes.io/backup (http://container.seccomp.security.alpha.kubernetes.io/backup)]: Forbidden: seccomp may not be set, provider
"hostmount-anyuid": Forbidden: not usable by user or serviceaccount, provider "machine-api-termination-handler": Forbidden: not usable by user or serviceaccount, provider "hostnetwork-v2": Forbidden: not usable by user or serviceaccount, provider
"hostnetwork": Forbidden: not usable by user or serviceaccount, provider "hostaccess": Forbidden: not usable by user or serviceaccount, provider "node-exporter": Forbidden: not usable by user or serviceaccount, provider "privileged": Forbidden: not usable by user```

---

**Vladimir Iliakov** (2025-03-21 12:20):
I created a ticket to investigate it https://stackstate.atlassian.net/browse/STAC-22556

---

**Saurabh Sadhale** (2025-03-21 12:22):
We have tried this in 10-nonha sizing.

---

**Vladimir Iliakov** (2025-03-21 12:27):
These extra values disable securityContext, which might help with the deployment, but there are no guarantees  anything else won't be broken
```clickhouse:
  podSecurityContext:
    enabled: false
  containerSecurityContext:
    enabled: false```
Maybe @Lukasz Marchewka has some ideas...

---

**Mark Bakker** (2025-03-21 12:59):
@Vladimir Iliakov yes we still support OpenShift

---

**Mark Bakker** (2025-03-21 13:00):
We have customers running on it...

---

**Vladimir Iliakov** (2025-03-21 13:02):
Ok, then we have to investigate it....

---

**Vladimir Iliakov** (2025-03-21 13:29):
Ah, so no easy win.

---

**James Mason** (2025-03-21 15:03):
If only slack had built-in sed expansions like hipchat did.

---

**Marc Rua Herrera** (2025-03-21 15:59):
No problem Bram. Thanks for you help and enjoy your Holidays :cat-wave:

---

**Sheng Yang** (2025-03-21 16:03):
I would accept o11y. Not OBS though since that’s `openSUSE Build Service`

---

**Sam Chen** (2025-03-21 17:05):
Hi there, we are visited some customer (FSI, CSP) and we got some questions.
1. can we export all logs to another logging system(e.g. ELK)? because CSP have regulation for logs must stored for 6 months.
2. do we have data tiering concept for log retrieve? hot data for 1 or 2 week, over 2 week move those to another storage.
3. if customer have some service running on A cluster and need to access B cluster, can we correlation those service relationship ? 
4. can we collect Cisco、Palo Alto、Fortinet firewall logs?
5. if customer already have ELK, can we use customer’s ELK logs data for o11y?

---

**Paul Gonin** (2025-03-21 17:06):
and IT IS Open Broadcaster Software

---

**Aaron Conklin** (2025-03-22 00:18):
howdy folks. I have this memory that the Observability SaaS was not meant to allow private offers, but all 4 listings currently allow that option. Is this intended?

---

**Andy Fitzsimon** (2025-03-24 00:17):
I can't believe we are discussing this again but for the sake of consistency,  I urge everyone to consider context and that we are optimising our naming for new audiences not people ' in the know'

> Will others encounter what was written?   be it a partner, a colleague at a customer or a new colleague at SUSE?If so... 
*DO NOT USE ACRONYMS FOR OUR SOLUTIONS OR PRODUCTS* 

> Is this in a DM, personal journal or other medium that is not part of any system of record? 
_use whatever you want._ 

> Is this in a message or part of content that is used by ANY system of record, be it public slack, customer exchange, salesforce comment, email etc?   
*DO NOT USE ACRONYMS FOR OUR SOLUTIONS OR PRODUCTS* 


For the massive benefits clarity brings to all minds and eyeballs, we can afford the extra bytes of bandwidth.  Please do your part.

---

**Seh Guan Lim** (2025-03-24 08:04):
Hi. We have a customer who encounter issues recently with regards to kube proxy, which has since been fixed by a newer version of k8s.
This issue occurs while a cert rotation has been performed, whereby the kube proxy would not restart automatically and continue to behave erratically by going into pending state intermitently.
While the issue has been resolved, the customer is interested to know whether SUSE Observability would be able to help monitor such issues in case it happens again.
From what I have gathered, this issue is not a generic issue due to the following
1. Kube proxy is a key k8s component and is deployed as a static pod in k8s
2. A Kube proxy issue could potentially be a node wide issue, such that it might also impact the other pods running in the node which includes the StackState agent
Hence for such issues, how could SUSE Observability helps? Is there any monitors "for ep, Pod Ready State" that works right of the box? Is there any write ups or documentations around this?
Many thanks for looking into this.

---

**Remco Beckers** (2025-03-24 08:40):
You can use all of those. The error you shared seems to be caused by using `https` for the URL while the loadbalancer doesn't support TLS. Here is a setup I use with the service name when running the otel collector and SUSE Observability in the same cluster:

```otlp/stackstate:
  auth:
    authenticator: bearertokenauth
  endpoint: http://suse-observability-otel-collector.monitoring.svc.cluster.local:4317
otlphttp/stackstate:
   auth:
      authenticator: bearertokenauth
   endpoint: http://suse-observability-otel-collector.monitoring.svc.cluster.local:4318```
Note that port 4317 us for OTLP and 4318 for OTLP over HTTP.

---

**Remco Beckers** (2025-03-24 08:45):
It is hard to say without knowing more details about "the issue with kube proxy". But SUSE Observability has monitors for generic issues:
• Pod Ready State (takes a pod too long to get to a ready state)
• Container restarts (too many restarts within a limited time period)
• Pods in waiting state (pods too long in a waiting state)
• Desired vs actual replica count (checks for insufficient # pods for replicasets, statefulsets and deployments)

---

**Remco Beckers** (2025-03-24 08:46):
You can see for yourself on a pod: https://play.stackstate.com/#/components/urn:kubernetes:%2Fgke-demo-public.gcp.stacksta[…]81-9176-4e1ede2587ca?detachedFilters=namespace%3Asock-shop (https://play.stackstate.com/#/components/urn:kubernetes:%2Fgke-demo-public.gcp.stackstate.io%2Fpod%2Feae056a0-33a0-4281-9176-4e1ede2587ca?detachedFilters=namespace%3Asock-shop)

Or the complete list of monitors: https://play.stackstate.com/#/monitors

---

**Remco Beckers** (2025-03-24 09:16):
Which of those 2 exporters are you using in the pipelines? I see I am only using OTLP over HTTP.  So I can only confirm that one works.

The OTLP exporter uses GRPC which requires TLS by default. To disable that you need to include `insecure: true`  in its TLS configuration to disable TLS. For all config option see https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/otlpexporter/README.md.

Note that in the end you need to only configure one of the two exporters and use that one in all of the pipelines.

---

**Dinesh Chandra** (2025-03-24 09:31):
Oh Let me check this. Thanks again for the details.

---

**Dinesh Chandra** (2025-03-24 11:59):
Thanks @Remco Beckers it works after changing the pipeline using OTLP over HTTP

---

**Remco Beckers** (2025-03-24 12:02):
:thumbs-up:

---

**Louis Lotter** (2025-03-25 10:32):
@Lukasz Marchewka can you help out here ?

---

**Lukasz Marchewka** (2025-03-25 10:50):
in 30 minutes, I have to finish code review

---

**Louis Lotter** (2025-03-25 10:50):
np. just don't want Sam to wait forever

---

**Daniel Barra** (2025-03-25 11:19):
*We are pleased to announce the release of 2.3.1, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.1).*

---

**Troy Topnik** (2025-03-25 22:55):
Would we consider Kubeshark a competitor to SUSE Observability? https://www.kubeshark.co/

---

**Troy Topnik** (2025-03-25 22:56):
I ask because their CRO has reached out on LinkedIn. I expect we may see them express interest as a Rancher partner. Let me know if I should politely put the brakes on that.

---

**Andreas Prins** (2025-03-26 06:25):
Yes for sure I would say. They provide a nice map to visualize some metrics we have in our system

---

**Paul Gonin** (2025-03-26 06:58):
I’m not totally familiar with Kubeshark but I identified them as a different type of solution. More like a tool in the cluster admin toolbox that you use and enable during troubleshooting periods.

---

**John Pugh** (2025-03-26 08:17):
Kubeshark only provides network visibility. That's it. No remediation suggestions, no tracing, no logging...just network. If we're about choice...I would embrace it. There is no way it can compete with the extensive capability of observability.

---

**Sam Chen** (2025-03-26 08:50):
Hi Folks, we have a online event with customer at Friday, can we provide a short version for customer questions?

---

**Lukasz Marchewka** (2025-03-26 08:50):
doing it now

---

**Lukasz Marchewka** (2025-03-26 10:14):
1. We store logs in ElasticSearch, there is few options how to expert/sync logs to another ELK cluster. But they can configure retention for logs, more details is here: https://docs.stackstate.com/self-hosted-setup/data-management/data_retention
2. ElasticSearch allows configure hot, warm, cold indices. I'm not sure if we can configure it easily for indices created by us. I think it is possible but I'm not sure.
3. @Remco Beckers do you know if it is possible
4. @Remco Beckers do you know if it is possible
5. It should be possible but it can cause issues. We install all dependencies (databases) instead reuse existing one. But why? Already existing databases may be configure in a way to cause performance issues or limit some functionality. Also version of these components maybe not be compatible. We had such problems in the past.

If you need more details, please ping me.

---

**Remco Beckers** (2025-03-26 10:43):
1. For shipping logs somewhere else I would suggest to customize the log shipper configuration to directly ship to a location that is used for long-term storage
2. We don't support that level of configuration right now
3. We can, but it requires some extra setup to be able to do this: https://docs.stackstate.com/agent/k8sts-agent-request-tracing. Next to this you could also use Open Telemetry traces to get the same result, but that requires instrumenting your applications
4. At the moment our log collection and UI only supports Kubernetes pods. Improving this to support logs from any system (both for collection and in the UI) is on the roadmap however.
5. We don't support that. It was a big cause for problems and support tickets. Moreover it is very likely we'll move away from Elasticsearch when we improve the logs support.

---

**Louis Lotter** (2025-03-26 10:47):
Thanks guys.

---

**Mark Bakker** (2025-03-26 10:47):
@Troy Topnik I would say they do compete a little but indeed only focus on the network visibility.
From our perspective I don't see a big benefit of a partnership. I also don't see them as a thread so it won't hurt us other than that it takes time we can invest in other partners.

---

**Mark Bakker** (2025-03-26 10:48):
@Remco Beckers or @Frank van Lankvelt can you look into this issue?

---

**Louis Lotter** (2025-03-26 10:55):
This key can be used for internal use only -&gt;
```U8ZAU-74W8U-SZ8NA ```
It will expire 1 September 2025. Please do not share with any customers.

---

**Sam Chen** (2025-03-26 11:21):
Thanks you guys, it’s really helpful for me. :+1:

---

**Alejandro Acevedo Osorio** (2025-03-26 11:49):
@Rajesh Kumar We picked up the ticket and made the relevant updates. The changes will be included on the next release

---

**Derek So** (2025-03-26 13:26):
Hi Team,

A customer is asking if they can collect all systemd journal logs to SUSE Observability cluster.  Apparently this is possible by configuring and running another `promtail` pod to achieve this as suggested by this doc (https://docs.stackstate.com/logs/k8sts-log-shipping#running-additional-promtail-pods)?

Any guidance or help on how this can be done is appreciated. Thanks!

---

**Frank van Lankvelt** (2025-03-26 13:28):
@Dinesh Chandra: apparently the collector cannot forward the metrics to vmagent - is there a problem with that, or the backend store victoria metrics?

---

**Frank van Lankvelt** (2025-03-26 13:37):
please refrain from using the SOB acronym.  This was recently discussed here: https://suse.slack.com/archives/C079ANFDS2C/p1742543639813079

---

**Derek So** (2025-03-26 13:45):
Thank you @Frank van Lankvelt for clarifying this with me! I didn’t mean for any negative meaning behind this acronym. Has edited my question and see if there’s any suggestion for this. Appreciate your help.

---

**Frank van Lankvelt** (2025-03-26 13:55):
I think you misread the document.  Logs are expected to be shipped to SUSE Observability by running our agent pod.  The section on additional promtail pods is for dealing with other destinations.  If logs need to be shipped to another destination in addition to SUSE Observability, the customer needs to run an additional promtail - instead of trying to get the one embedded in our agent to do this.

---

**Graham Hares** (2025-03-26 14:32):
I noticed a new menu for GenAI Observability components, if there a doc on what to install to add that please?

---

**Derek So** (2025-03-26 14:33):
Thanks Frank! I was thinking shipping the systemd logs to their own SIEM if SUSE Observability cluster is not an option. To do this, does it meant to configure promtail to ship off systemd journal in another container? Any guidance or example we can take for customer as reference?

---

**Jeroen van Erp** (2025-03-26 14:37):
@Graham Hares I assume you’re looking at the SA instance? This is not generally available

---

**Frank van Lankvelt** (2025-03-26 14:37):
I don't know what SIEM is, or how to best ship logs to it.  For SUSE Observability, just deploy its agent.

---

**Graham Hares** (2025-03-26 14:39):
Yes, thanks @Jeroen van Erp I was trawling around the docs to try to find it :slightly_smiling_face:
Is it generally available internally to try out, test etc?  any version dependancies etc..

---

**Derek So** (2025-03-26 14:47):
The default deployment for SUSE Observability agent can only ship pod level logs to the SUSE observability cluster, not systemd journal logs. Is there any other options to configure the agent to ship systemd logs to the cluster?

---

**Frank van Lankvelt** (2025-03-26 14:54):
@Louis Parkin: can you offer any insights here?

---

**Louis Parkin** (2025-03-26 14:56):
Hey @Frank van Lankvelt, this is more @Bram Schuur’s thing... Am I understanding the question correctly? The goal is to ship logs of the systemd on the node, i.e. not logs from a pod in the cluster, but from the node's filesystem?

---

**Louis Parkin** (2025-03-26 14:57):
If so, we'd have to read up what promtail allows.  Maybe with sufficient config and permissions given to the pod, it could be done, but off the top of my head, I just don't know.

---

**Derek So** (2025-03-26 15:15):
The goal is to ship both node level systemd logs and pod level logs to the suse observability cluster.

---

**Jeroen van Erp** (2025-03-26 15:24):
@Ravan Naidoo Can tell you more about this extension. I think that the AI team is working on making this an official extension

---

**Ravan Naidoo** (2025-03-26 15:27):
The extension in the SA instance is a prototype.  It has been handed over to the AI dev team (Thiago Bertoldi )  for productization.

---

**Mark Bakker** (2025-03-26 15:27):
We have an Epic on our roadmap to support general logs via OpenTelemetry, this is something coming this year, until than we only support pod logs.

---

**Mark Bakker** (2025-03-26 15:27):
node and systemd logs can than be shipped via OpenTelemetry format.

---

**Louis Parkin** (2025-03-26 15:30):
Good to know, thanks Mark!

---

**Lionel Meoni** (2025-03-26 16:13):
Question, we are able to generate subscription on our SCC for demo purpose on observability, but how we translate the subscription in valid license?

---

**Mark Bakker** (2025-03-26 16:34):
Better to ask this in <#C02AYV7UJSD|>

---

**Derek So** (2025-03-26 16:36):
Thank you everyone for prompt response!

---

**Lionel Meoni** (2025-03-26 16:37):
done yes thanks

---

**Derek So** (2025-03-26 16:38):
@Mark Bakker Will this new feature be able to ship node and systemd logs from SLE-Micro  based node provisioned by Elemental Operator?

---

**Mark Bakker** (2025-03-26 16:46):
We aim to make that possible, but that needs to be detailed out. Running a pod with a logshipper in otel-format is our target architecture, but we still need to work out details like SLE-Micro

---

**Garrick Tam** (2025-03-26 18:15):
Hi, anyone know what component takes on the duties of the server pod in an HA deployment?  I'm in a call trying to troubleshooting OIDC authentication and the last deployment results in an internal error message.

---

**Jeroen van Erp** (2025-03-26 18:21):
Api pod I think

---

**Garrick Tam** (2025-03-26 18:25):
yes, found it by age with
```kubectl get pods -n suse-observability -l app.kubernetes.io/name=suse-observability (http://app.kubernetes.io/name=suse-observability)```

---

**IHAC** (2025-03-26 18:36):
@Garrick Tam has a question.

:customer:  Kroger

:facts-2: *Problem (symptom):*  
Working with customer to address OIDC Redirect URI issue but after making some changes to authentication.yaml and redeploy, we are now seeing 500 internal error.

---

**Garrick Tam** (2025-03-26 18:48):
:resolved: found the secret was a mismatch.

---

**Garrick Tam** (2025-03-26 18:50):
BTW, we can only fix the redirect URI error after setting the redirectUri value in authentication.yaml; which the documentation says is optional.  Anyone else can confirm this with OIDC with Microsoft Entra ID?

---

**Dinesh Chandra** (2025-03-26 23:31):
Thanks @Frank van Lankvelt will check those

---

**Remco Beckers** (2025-03-27 07:53):
If you don't specify the `redirectUri` the `redirectUri` is generated by SUSE Observability based on the `baseUrl` that is required. If you have provided the correct `baseUrl` that should normally be fine because the path part that gets added is fixed. So it depends on what the fix for the `redirectUri` was, maybe that fix also needs to be applied to the `baseUrl.`

---

**Amol Kharche** (2025-03-27 08:01):
@Vladimir Iliakov @Remco Beckers I’ve noticed some unusual behavior while configuring the S3 Gateway. I can see that the backup for the configuration and ClickHouse were successfully created under those buckets, but not for the others. Is there something I'm missing in the configuration?
 Here is my backup.yaml file.
```cat aws-backup.yaml
backup:
  enabled: true
  stackGraph:
    bucketName: sts-stackgraph-backup-26-03-2025-08-16
  elasticsearch:
    bucketName: sts-elasticsearch-backup-26-03-2025-08-16
  configuration:
    bucketName: sts-configuration-backup-26-03-2025-08-16
victoria-metrics-0:
  backup:
    enabled: true
    bucketName: sts-victoria-metrics-backup-26-03-2025-08-16
victoria-metrics-1:
  backup:
    enabled: true
    bucketName: sts-victoria-metrics-backup-26-03-2025-08-16
clickhouse:
  backup:
    enabled: true
    bucketName: sts-clickhouse-backup-26-03-2025-08-16
minio:
  accessKey: dummy-access-key
  secretKey: not-so-secret
  s3gateway:
    enabled: true
    accessKey: AKIA********************
    secretKey: ****************************************
    #serviceEndpoint: s3.ap-south-1.amazonaws.com (http://s3.ap-south-1.amazonaws.com)```
Logs from minio pod.
```API: PutObject(bucket=sts-stackgraph-backup-26-03-2025-08-16, object=sts-backup-20250327-0300.graph)
Time: 03:01:00 UTC 03/27/2025
DeploymentID: f07dc017-2304-4543-b066-5d0e6cfe5a2e
RequestID: 183089B341EE7AF7
RemoteHost: 10.244.0.77
Host: suse-observability-minio:9000
UserAgent: aws-sdk-go-v2/1.26.1 os/linux lang/go#1.22.10 md/GOOS#linux md/GOARCH#amd64 api/s3#1.53.1
Error: The bucket you are attempting to access must be addressed using the specified endpoint. Please send all future requests to this endpoint. (minio.ErrorResponse)
       4: cmd/api-errors.go:2026:cmd.toAPIErrorCode()
       3: cmd/api-errors.go:2051:cmd.toAPIError()
       2: cmd/object-handlers.go:1660:cmd.objectAPIHandlers.PutObjectHandler()
       1: net/http/server.go:2171:http.HandlerFunc.ServeHTTP()```

---

**Remco Beckers** (2025-03-27 08:05):
The S3 buckets will not necessarily be created automatically. You need to create it yourself first

---

**Remco Beckers** (2025-03-27 08:05):
Oh I see you have them

---

**Remco Beckers** (2025-03-27 08:12):
AFAIK this is the error I previously gave this response to: https://suse.slack.com/archives/C079ANFDS2C/p1741879539401629?thread_ts=1741868018.175169&amp;cid=C079ANFDS2C. But maybe @Vladimir Iliakov can help out again?

---

**Amol Kharche** (2025-03-27 08:15):
I tried that one also (`serviceEndpoint: s3.ap-south-1.amazonaws.com (http://s3.ap-south-1.amazonaws.com)`) but minio pod is going into `CrashLoopBackOff` forever saying
```$ kubectl logs suse-observability-minio-596ddd65c5-f2r4g
ERROR Invalid argument: unable to guess port from scheme```

---

**Remco Beckers** (2025-03-27 08:16):
Did you try including a scheme? I.e. `https://`

---

**Amol Kharche** (2025-03-27 08:16):
No, Let me try

---

**Vladimir Iliakov** (2025-03-27 08:20):
I would first check the logs of the backup container of the Clickhouse pod for the related errors/warnings

---

**Remco Beckers** (2025-03-27 08:21):
Mmm yeah, that should also be failing if all buckets are in the same account/region. All uploads go through Minio so use the exact same config :think_spin:

---

**Vladimir Iliakov** (2025-03-27 08:24):
Sorry, I meant to check the logs of the failed backups:
stackgraph (K8s jobs/pods)
victoriametrics (backup container)
for elasticsearch it is a bit treaky (you have to port-forward port and query snapshot/slm API)

---

**Amol Kharche** (2025-03-27 08:25):
&gt; Did you try including a scheme? I.e. `https://`
Wow, It seems its working after putting `https://` , Backup job completed without errors.
```NAME                                                              READY   STATUS      RESTARTS      AGE
suse-observability-backup-conf-27t071723-v8htr                    0/1     Completed   0             52s
suse-observability-backup-init-27t071723-jk5k7                    0/1     Completed   0             51s

$ kubectl logs suse-observability-backup-init-27t071723-jk5k7
Defaulted container "configure" out of: configure, wait (init)
=== Testing for existence of MinIO bucket "sts-stackgraph-backup-26-03-2025-08-16"...
=== Testing for existence of MinIO bucket "sts-configuration-backup-26-03-2025-08-16"...
=== Testing for existence of MinIO bucket "sts-victoria-metrics-backup-26-03-2025-08-16"...
=== Testing for existence of MinIO bucket "sts-victoria-metrics-backup-26-03-2025-08-16"...
=== Testing for existence of MinIO bucket "sts-clickhouse-backup-26-03-2025-08-16"...
=== Testing for existence of MinIO bucket "sts-elasticsearch-backup-26-03-2025-08-16"...
=== Configuring ElasticSearch snapshot repository "sts-backup" for bucket "sts-elasticsearch-backup-26-03-2025-08-16"...
{
  "acknowledged" : true
}
=== Configuring ElasticSearch snapshot lifecycle management policy "auto-sts-backup" for snapshot repository "sts-backup"...
{
  "acknowledged" : true
}```
No error reported in minio pod logs.
```NAME                                                              READY   STATUS      RESTARTS      AGE
suse-observability-minio-54ff8569cb-qxq99                         1/1     Running     0             100s

$ kubectl logs suse-observability-minio-54ff8569cb-qxq99
Endpoint: http://10.244.0.195:9000  http://127.0.0.1:9000

Browser Access:
   http://10.244.0.195:9000  http://127.0.0.1:9000

Object API (Amazon S3 compatible):
   Go:         https://docs.min.io/docs/golang-client-quickstart-guide
   Java:       https://docs.min.io/docs/java-client-quickstart-guide
   Python:     https://docs.min.io/docs/python-client-quickstart-guide
   JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
   .NET:       https://docs.min.io/docs/dotnet-client-quickstart-guide```

---

**Vladimir Iliakov** (2025-03-27 08:27):
This jobs just initialises backup (prepare Minio, ES policy)...

---

**Vladimir Iliakov** (2025-03-27 08:29):
The Clickhouse, Stackgraph, and configuration backups are done by the cronjobs
. So you see nothing in the buckets you have to check the logs of these jobs

---

**Vladimir Iliakov** (2025-03-27 08:30):
For VM you have to check the logs of the sidecar container

---

**Amol Kharche** (2025-03-27 08:30):
```# kubectl get cronjobs.batch
NAME                                               SCHEDULE        TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
suse-observability-backup-conf                     0 4 * * *       &lt;none&gt;     False     0        3h29m           16h
suse-observability-backup-sg                       0 3 * * *       &lt;none&gt;     False     0        4h29m           16h
suse-observability-clickhouse-full-backup          45 0 * * *      &lt;none&gt;     False     0        6h44m           16h
suse-observability-clickhouse-incremental-backup   45 3-23 * * *   &lt;none&gt;     False     0        44m             16h```

---

**Vladimir Iliakov** (2025-03-27 08:32):
For Elasticsearch
```k port-forward svc/suse-observability-elasticsearch-master-headless 9200:9200```
and in a different terminal
```curl 127.0.0.1:9200/_slm/policy | jq .```

---

**Amol Kharche** (2025-03-27 08:34):
Just a quick question: When we apply the `backup.yaml` file, does the backup start immediately, or does it wait for the next cycle defined in the cron job? Or will it perform a full backup right away?

---

**Vladimir Iliakov** (2025-03-27 08:35):
it waits for the next cycle defined in the cron job

---

**Amol Kharche** (2025-03-27 09:05):
@Remco Beckers @Vladimir Iliakov Thanks for your support :saluting_face:

---

**Tapas Nandi** (2025-03-27 10:56):
Hello Team,
For a 150 HA setup , the sizing is I believe  103 CPU cores and 131 GB memory minimum and 2 TB HDD as per our doc. So considering I have a 3 Node setup will this requirement be cumulative of all 3 nodes or per node.
If I am installing the server in 3 VM can i just go with a combined 103 vCPU and 131 GB of mem requirements in total

---

**Andreas Prins** (2025-03-27 10:59):
Hi team, we very much need some social media boost, sharing is caring!! We just published a new video in our under-3-minutes-series for SUSE Cloud native. have a look, and please comment like and reshare. Comments are amzing!
https://www.linkedin.com/posts/andreasprins_observability-opensource-cloudnative-acti[…]m=member_desktop&amp;rcm=ACoAAADjq30BFYAdX1wFuXEB-b7Mn9w7WlkOjOE (https://www.linkedin.com/posts/andreasprins_observability-opensource-cloudnative-activity-7310962434351988736-iakQ?utm_source=share&amp;utm_medium=member_desktop&amp;rcm=ACoAAADjq30BFYAdX1wFuXEB-b7Mn9w7WlkOjOE)

---

**Tapas Nandi** (2025-03-27 11:19):
Please Guide

---

**Vladimir Iliakov** (2025-03-27 11:30):
It doesnt feel alive :smile:

---

**Marc Rua Herrera** (2025-03-27 11:32):
Hi Tapas,
The sizing requirements you've mentioned — 103 vCPUs, 131 GB memory, and 2 TB HDD — are cumulative for the entire 3-node setup, not per node.
So yes, if you're installing the server across 3 VMs, you can distribute the total 103 vCPUs and 131 GB memory across them. Just make sure the individual nodes still meet any minimum per-node requirements (e.g., sufficient resources to run critical services and handle failover scenarios if needed).

---

**Tapas Nandi** (2025-03-27 11:32):
Thanks @Marc Rua Herrera

---

**Andreas Prins** (2025-03-27 11:36):
this is really fun, it was 100% human, not even recorded with a script or anything like that. Glad you think AI get's so close. Of sadly my behaviour is adjusted to AI to much. :smile:

---

**Vladimir Iliakov** (2025-03-27 11:48):
Or it just me not seeing the difference any longer :facepalm:

---

**Remco Beckers** (2025-03-27 12:14):
If the pod got stuck in `pending` state it would have indeed been caught by the `Pod Ready State` monitor. If a pod is unschedulable or if it takes longer than 15m for the pod to be ready that monitor will go to a critical state (red)

---

**Olli Tuominen** (2025-03-27 14:26):
Hi. I'm just going to present and using the playground but it is acting funny. Example related health violations doesn't show the topology right.

---

**Andreas Prins** (2025-03-27 14:27):
can you paste the URL?

---

**Olli Tuominen** (2025-03-27 14:30):
Components | SUSE Observability (https://play.stackstate.com/#/components/urn:endpoint:%2Fgke-demo-public.gcp.stackstate.io:10.2.147.211/highlights?detachedFilters=namespace%3Asock-shop%2Ccluster-name%3Agke-demo-public.gcp.stackstate.io&amp;timeRange=LAST_3_HOURS&amp;timestamp=1743077700000)

---

**Hugo de Vries** (2025-03-27 14:30):
Works for me, for example here: https://play.stackstate.com/#/components/urn:service:%2Fgke-demo-public.gcp.stackstate.io:otel-demo:od-frontend

---

**Andreas Prins** (2025-03-27 14:31):
there is no related health violation at a dependent component, so you therefore there is nothing special in the topology of the monitor

---

**Hugo de Vries** (2025-03-27 14:32):
You are looking at the lowest level unhealthy component already, to see the other related component you need to switch on the impacted components:

---

**Hugo de Vries** (2025-03-27 14:33):
For demo's I advise to use the services in the otel-demo namespace

---

**Olli Tuominen** (2025-03-27 14:35):
Ahh. I see. Usually the demo has landed into situation where the ad service has been the issue.

---

**Hugo de Vries** (2025-03-27 14:35):
I think that was the more complex example you were looking for:

---

**Hugo de Vries** (2025-03-27 14:35):
https://play.stackstate.com/#/components/urn:service:%2Fgke-demo-public.gcp.stackstate.[…]eRange=1743060949536_1743082549536&amp;timestamp=1743081203109 (https://play.stackstate.com/#/components/urn:service:%2Fgke-demo-public.gcp.stackstate.io:otel-demo:od-frontend?timeRange=1743060949536_1743082549536&amp;timestamp=1743081203109)

---

**Zia Rehman** (2025-03-27 16:06):
Hi Team, I’m conducting a beta session for *SUSE Observability* next week, which will include customers, partners, and internal participants. The session will feature a hands-on installation of Observability, where I plan to use the following license key: *'*BEWRF-34GQNG-G348DY*'*.
Could you confirm if it's appropriate to share this key with all participants? If not, please advise on the correct key to use.

---

**James Mason** (2025-03-27 16:11):
Is https://more.suse.com/SUSE_Cloud_Observability_Early_Access_Program.html still applicable, or is there a better destination to point new customers to? The use case is in prerequisites listed in documentation for an alternative provider of the agent (AWS EKS add-on in AWS Marketplace)

---

**Andreas Prins** (2025-03-27 16:16):
no it is no longer applicable, bring them over to the https://www.suse.com/products/cloud/observability/ (AWS marketplace)
And if they don't like cloud saas, go for the regular path: v

---

**Jeroen van Erp** (2025-03-27 16:17):
Hi Zia, definitely not. We do not want to share a long-living key. @Louis Lotter could give you a key that’s valid for a few days

---

**Louis Lotter** (2025-03-27 16:18):
when should it expire ?

---

**Zia Rehman** (2025-03-27 16:20):
I have no idea, it was shared by Andreas to me.

---

**Zia Rehman** (2025-03-27 16:21):
Can you provide a key which is valid for a week. My session will be from 1-4 April. So key can expire on 5th April.

---

**Louis Lotter** (2025-03-27 16:29):
ok thats what I meant

---

**Louis Lotter** (2025-03-27 16:30):
AD49Q-SUDVH-UU16A

---

**Louis Lotter** (2025-03-27 16:30):
This key expires 7 April 2025

---

**Louis Lotter** (2025-03-27 16:30):
To give you some leeway.

---

**Zia Rehman** (2025-03-27 16:31):
Thanks @Louis Lotter.

---

**James Mason** (2025-03-27 17:01):
https://suse.slack.com/archives/C02B5UVEC94/p1743090799223929

---

**Aline Werner** (2025-03-27 17:24):
Hi, I wanted to check if we have a package on OBS/IBS that provides stackstate-cli. I need to install it in a container.

---

**Louis Lotter** (2025-03-27 17:34):
@Zia Rehman @Frank van Lankvelt reminded me that keys can only expire at the end of months so the key I gave you may stop working 1 April

---

**Louis Lotter** (2025-03-27 17:34):
I generate a new on YL7ZY-XJH8D-TJADA
It will work up to 1 May 2025

---

**Zia Rehman** (2025-03-27 17:35):
Okay, I'll use this one. Thanks Louis!

---

**Alejandro Bonilla** (2025-03-27 17:46):
Guys how do we set tlsverify to no in the chart?

---

**Alejandro Bonilla** (2025-03-27 17:46):
For the agent install.

---

**Marc Rua Herrera** (2025-03-27 17:48):
```--set 'nodeAgent.skipSslValidation'=true \
--set 'clusterAgent.skipSslValidation'=true \
--set 'checksAgent.skipSslValidation'=true \```

---

**Alejandro Bonilla** (2025-03-27 17:49):
Yep found in the yams, thanks. We need this in the questions.yaml

---

**Alejandro Bonilla** (2025-03-27 17:50):
Very common in a POC to not have proper Certa

---

**Alejandro Bonilla** (2025-03-27 17:57):
Where do we get the token for the extension?

---

**Alejandro Bonilla** (2025-03-27 17:57):
Sorry! On a remote call and I’ve been living a SaaS life so far with Observability

---

**Alejandro Bonilla** (2025-03-27 17:58):
@Marc Rua Herrera would you know that one?

---

**Marc Rua Herrera** (2025-03-27 17:59):
Which token? For the agent?

---

**Marc Rua Herrera** (2025-03-27 17:59):
The API Key?

---

**Alejandro Bonilla** (2025-03-27 18:00):
For the extension. It wants a url and a key.

---

**Alejandro Bonilla** (2025-03-27 18:00):
I know the URL is the same as the one for the instances but the token is different for the Rancher extension

---

**Alejandro Bonilla** (2025-03-27 18:01):
The APi key and URL in the stack pack is for the downstream cluster, right?

---

**Marc Rua Herrera** (2025-03-27 18:02):
You can get both API Key and URL from the stackpacks section in Suse Observability.

---

**Alejandro Bonilla** (2025-03-27 18:02):
Yes, but that’s for the clusters

---

**Alejandro Bonilla** (2025-03-27 18:03):
Do we need to observe the local cluster?

---

**Alejandro Bonilla** (2025-03-27 18:04):
I’m looking for a key for the extension

---

**Alessio Biancalana** (2025-03-27 19:22):
actually I don't think so, which container do you need to install it in? Would it be ok to have it in factory/tumbleweed?

---

**Jeroen van Erp** (2025-03-27 19:49):
You need a service token for the Ui extension

---

**Jeroen van Erp** (2025-03-27 19:49):
Those can be created through the cli

---

**Jeroen van Erp** (2025-03-27 19:49):
Sts service-token create...

---

**Karen Van der Veer** (2025-03-27 19:54):
https://suse.slack.com/archives/C02B5UVEC94/p1743090799223929

---

**Alejandro Bonilla** (2025-03-27 22:30):
Where is sts? It’s a client to installed and consumed with kubeconfig or is there sts somewhere already installed.

---

**Jeroen van Erp** (2025-03-27 22:34):
https://docs.stackstate.com/cli/cli-sts :slightly_smiling_face:

---

**Jeroen van Erp** (2025-03-27 22:37):
You can also login to your Observability instance, and then click on the “Hamburger” menu, and then the CLI menu option

---

**Jeroen van Erp** (2025-03-27 22:37):
That shows you the installation instructions also

---

**IHAC** (2025-03-28 02:31):
@Garrick Tam has a question.

:customer:  Lumen Technologies (CenturyLink)

:facts-2: *Problem (symptom):*  
Customer Request RBAC control with namespace scoping.  See original request below.  I created the following authentication.yaml to create the custom view only role limiting to cluster but not sure how to scope it to just namespaces.  Can someone lend me a hand on what I am missing?

--- Customer Request --
Our cluster consists of several namespaces managed by different teams through security group assignment. I'm looking to find out if its possible to achieve role-based access control with namespace scoping in suse observability as well; such that members belonging to a specific team are only able to see &amp; access their namespace workloads, metrics, logs etc. in the observability tool

---authentication.yaml---
```stackstate:
  authentication:
    keycloak:
      url: "https://keycloak.24.199.71.163.sslip.io/auth"
      realm: master
      authenticationMethod: client_secret_basic
      clientId: sts
      secret: "I50MxHWZHUaqGA8wmn4NKSp8Kqeg20mJ"
      jwsAlgorithm: RS256
      scope: ["openid", "profile", "email"]
      jwtClaims:
        usernameField: preferred_username
        groupsField: group
    roles:
      guest: [ "" ]
      powerUser: [ "" ]
      admin: [ "administrators" ]
      demo: [ "demo" ]
      custom:
        demo:
          systemPermissions:
          - access-cli
          - access-view
          - access-explore
          - execute-component-actions
          - manage-star-view
          - perform-custom-query
          - read-permissions
          - read-settings
          - read-system-notifications
          - read-telemetry-streams
          - update-visualization
          - view-monitors
          viewPermissions:
          - access-view
          topologyScope: "(label = 'kube_cluster_name:dosts')"```

---

**Garrick Tam** (2025-03-28 06:14):
Is the below how to limit to specific namespace?  What permission would I need to run queries because my custom role user is getting Forbidden trying to execute a query.
```topologyScope: "(label = 'kube_cluster_name:dosts' AND domain IN ('demo'))"```

---

**Louis Lotter** (2025-03-28 07:48):
@Garrick Tam RBAC is our primary focus atm. It's making good progress.

---

**Louis Lotter** (2025-03-28 07:49):
@Alejandro Acevedo Osorio can you take a look at the requirements here :point_up: And verify if our current RBAC design caters for everything in here ? If not we need to make @Mark Bakker aware so we can follow up after the first release with enhancements if they make sense.

---

**Remco Beckers** (2025-03-28 08:27):
@Alejandro Acevedo Osorio Didn't you add this just earlier this week?

---

**Alejandro Acevedo Osorio** (2025-03-28 09:27):
@Garrick Tam in the current RBAC model the way to limit to a namespace would be
```topologyScope: "(label = 'cluster_name:dosts' AND label IN ('namespace:some-Namespace'))"```
And as a note this model only applies scope to topology.

---

**Alejandro Acevedo Osorio** (2025-03-28 09:33):
Yes on the next release the `questions.yaml` will include `global.skipSslValidation`

---

**Vladimir Iliakov** (2025-03-28 14:50):
I think I have seen such behaviour, the server pod got restarted on the first run after the deployment. And after automatic restart it should be ok...

---

**Rajesh Kumar** (2025-03-28 15:07):
hmm I have restarted it several times even before sending the logs to get the fresh logs

---

**Alejandro Acevedo Osorio** (2025-03-28 15:18):
how do the `suse-observability-hbase-stackgraph-0` and `suse-observability-hbase-tephra-0` look like? Any errors over there?

---

**Rajesh Kumar** (2025-03-28 15:39):
I am interested in learning how to debug this.

---

**Rajesh Kumar** (2025-03-28 15:39):
There are a few errors, but not sure if they are related.

---

**Rajesh Kumar** (2025-03-28 15:41):
I am using trial profile, with 2 node 8 cpu 16GB memory each

---

**Alejandro Acevedo Osorio** (2025-03-28 16:01):
seems that we got an issue with a thread that should be running and it just silently continues ...

---

**Alejandro Acevedo Osorio** (2025-03-28 16:01):
Can you restart stackgraph and tephra?

---

**Rajesh Kumar** (2025-03-28 16:04):
Is there any dependency that we should first start stackgraph and then tephra?

---

**Alejandro Acevedo Osorio** (2025-03-28 16:06):
stackgraph should be first but tephra would keep restarting until it finds a healthy stackgraph

---

**Alejandro Acevedo Osorio** (2025-03-28 16:09):
@Remco Beckers I created this ticket https://stackstate.atlassian.net/browse/STAC-22596 .. not sure if I put the correct sprint/labels though

---

**Rajesh Kumar** (2025-03-28 16:17):
Restarted but the error is still present, restarted server pod as well but crashed.

---

**Alejandro Acevedo Osorio** (2025-03-28 16:27):
I guess the server pod has pretty much the same logs you showed before?

---

**Alejandro Acevedo Osorio** (2025-03-28 16:28):
Can you describe the server pod? Is it due to an error that restarts or is it due to the readiness/liveness probe?

---

**Rajesh Kumar** (2025-03-28 16:28):
Okay.. give me 5 mins

---

**Rajesh Kumar** (2025-03-28 17:01):
Sorry, was preparing dinner

---

**Alejandro Acevedo Osorio** (2025-03-28 17:26):
```  Warning  Unhealthy         47m (x13 over 51m)  kubelet            Readiness probe failed: Get "http://10.42.0.230:1618/readiness": dial tcp 10.42.0.230:1618: connect: connection refused
  Warning  Unhealthy         42m (x19 over 51m)  kubelet            Liveness probe failed: Get "http://10.42.0.230:1618/liveness": dial tcp 10.42.0.230:1618: connect: connection refused```

---

**Alejandro Acevedo Osorio** (2025-03-28 17:27):
Apparently the `2 node 8 cpu 16GB memory each` are not enough? Or takes too long to start the server pod

---

**Alejandro Acevedo Osorio** (2025-03-28 17:28):
You can try to tweak the liveness and readiness probe to make it more relax ... or even drop it ... Or add another node perhaps (although in theory should not be  needed)

---

**James Mason** (2025-03-28 17:33):
https://www.suse.com/c/start-observing-your-aws-eks-cluster-in-less-than-5-minutes/

---

**Alejandro Acevedo Osorio** (2025-03-28 17:39):
checking the describe of your pod it seems you have tweaked the values?
```    Limits:
      cpu:                3
      ephemeral-storage:  6Gi
      memory:             6Gi
    Requests:
      cpu:                2
      ephemeral-storage:  1Mi
      memory:             6Gi```
does not exactly match the values for `trial`

---

**Rajesh Kumar** (2025-03-28 18:01):
Yes, i changed it

---

**Rajesh Kumar** (2025-03-28 18:01):
I thought it's crashing because of resources

---

**Rajesh Kumar** (2025-03-28 18:02):
But node top commands were pretty fine

---

**Garrick Tam** (2025-03-28 18:24):
@Alejandro Acevedo Osorio Given the namespace limitation only applies scope to topology; then we should have a feature request in place to support "see &amp; access their namespace workloads, metrics, logs etc."  Can you please let me know what Jira ID exists to support the requested functionality so I can associated it with the customer case?

---

**Rajesh Kumar** (2025-03-28 18:59):
Yes, probably you were right. I didn't do anything and now it's stable. The problem is debugging, how can we debug these issues. We will have to come back to Engineering even if it has nothing to do with the codebase

---

**Rajesh Kumar** (2025-03-28 19:14):
So, I have been working on a fix for externalsecret issue. I made the below changes, and it is working fine for me for server auth and licence.

---

**Garrick Tam** (2025-03-28 19:15):
Something appears to be wrong with custom roles.  I created a custom role with yaml from --&gt; https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_roles#custom-roles-with-custom-scopes-and-permissions-via-the-configuration-file but am not seeing Kubernetes from left nav and also getting Forbidden error when trying to run Query.  Here's the YAML and I even took the topologyScope out.  Since this custom role is the same as predefined k8sTroubleshooter role, when I login with the k8sTroubleshooter role I see Kubernetes from left nav pane and also get a successful query response.  Can someone help me understand if I'm doing something wrong or is this a bug?
```stackstate:
  authentication:
    keycloak:
      url: "https://keycloak.24.199.71.163.sslip.io/auth"
      realm: master
      authenticationMethod: client_secret_basic
      clientId: sts
      secret: "I50MxHWZHUaqGA8wmn4NKSp8Kqeg20mJ"
      jwsAlgorithm: RS256
      scope: ["openid", "profile", "email"]
      jwtClaims:
        usernameField: preferred_username
        groupsField: group
    roles:
      guest: [ "" ]
      powerUser: [ "" ]
      admin: [ "demo" ]
      test: [ "administrators" ]
      custom:
        test:
          systemPermissions:
          - access-cli
          - create-views
          - execute-component-actions
          - export-settings
          - manage-monitors
          - manage-notifications
          - manage-stackpacks
          - manage-star-view
          - perform-custom-query
          - read-agents
          - read-metrics
          - read-permissions
          - read-settings
          - read-system-notifications
          - read-telemetry-streams
          - read-traces
          - run-monitors
          - update-visualization
          - view-metric-bindings
          - view-monitors
          - view-notifications
          viewPermissions:
          - access-view
          - save-view
          - delete-view```

---

**chihjen.huang** (2025-03-31 03:23):
Hey Team, :wave:
I’m working on installing Observability in the lab environment. Most of the pods are running, and I can log in to the UI console, but a few pods aren't starting properly.
After checking the logs, it looks like the issue is related to Elasticsearch (since other pods depend on it). Specifically, it seems to be failing on Elasticsearch’s Readiness and Liveness probes.
I’m not sure how to dig deeper to resolve this. Could anyone assist with troubleshooting?
I’ve attached the relevant info for reference (it’s an HTML file, please save it locally to view some highlighted sections). Thanks in advance! :pray:

---

**Mark Bakker** (2025-03-31 07:25):
Be aware the full Role Based Access setup is changing in a few months. We will have full support for Project Level Access for Metrics, Traces, Logs, Topology and Events.
Currently we the scoping is limited to the Topology.

---

**Marc Rua Herrera** (2025-03-31 15:23):
Hey Team,
A customer is using `HTTPRoute` instead of `Ingress` in their clusters. I haven't seen any `HTTPRoute` components appearing in SUSE Observability.
Do you know if SUSE Observability supports capturing `HTTPRoute` components and their metrics?
Thanks!

---

**Remco Beckers** (2025-03-31 16:24):
Which externalsecret issue are you referring to? STAC-22411  (https://stackstate.atlassian.net/browse/STAC-22411)maybe? A fix for that got released in version 2.3.1

---

**Remco Beckers** (2025-03-31 16:25):
&gt; Specifying custom authentication breaks on missing license key

---

**Remco Beckers** (2025-03-31 16:25):
Or are there more that we don't know about?

---

**Remco Beckers** (2025-03-31 16:29):
From the symptoms you describe it seems like your user doesn't have any permissions at all. With the configuration you have a user will get the custom permissions only when the username is `test` or when they are in the `test` group (the group comes from the OIDC Provider). Is that indeed your setup?

---

**Remco Beckers** (2025-03-31 16:32):
The line `test: [ "administrators" ]` is not supported by the helm chart. The keys you define under `custom` , so in this case `test` , are expected to directly match a user or group name.

---

**Remco Beckers** (2025-03-31 16:34):
We also don't have components for ingress. So there is no difference there

---

**Garrick Tam** (2025-03-31 16:35):
Ok, thank you for pointing out my syntax error.

---

**Remco Beckers** (2025-03-31 16:36):
Oh correction, we do have ingress components but not on an overview page

---

**Remco Beckers** (2025-03-31 16:38):
But we don't have any metrics connected to them.

---

**Remco Beckers** (2025-03-31 16:38):
The metrics are on the ingress controller pod (that actually implements the ingress). For exmaple nginx-ingress-controller in our own clusters

---

**Marc Rua Herrera** (2025-03-31 16:41):
So, for making it clear. I won't se an HTTPRoute component, right?

---

**Remco Beckers** (2025-03-31 16:41):
HTTPRoute is similar to ingress but we don't support it yet

---

**Remco Beckers** (2025-03-31 16:42):
But metrics for traffic we will still have, the Gateway + HTTPRoute resources together are similar to the ingress resource before iirc

---

**Remco Beckers** (2025-03-31 16:43):
And there is still a controller that is actually doing the routing work defined in those resources (like traefik, envoy, kong or nginx gateway fabrik, but the original nginx ingress controller not anymore, that's getting deprecated I believe)

---

**Remco Beckers** (2025-03-31 16:46):
Oh and of course you will also have metrics on the services.

---

**Marc Rua Herrera** (2025-03-31 17:01):
Okay. Thanks for your response Remco !!

---

**Jacob Perkins** (2025-03-31 22:45):
Is there a way to override the registration URL for StackState to something other than scc.suse.com (http://scc.suse.com)? RGS uses a proxy for our customers that sits in front of scc.suse.com (http://scc.suse.com) and we'd like the ability to use our licenses through that

---

**Garrick Tam** (2025-03-31 22:59):
what profile are you trying to bring up and what size are your nodes?

---

**chihjen.huang** (2025-03-31 23:07):
I'm using `10-nonha` profile, and my cluster is a 3 nodes with 72GB ram and 48 cpus.
```sizing.profile='10-nonha'```

---

**Garrick Tam** (2025-03-31 23:11):
Ok, then node size shouldn't be a problem.

---

**Garrick Tam** (2025-03-31 23:31):
• From our kxfer deck, it is noted EA pod will restart automatically when
    ◦ Liveness probe fails
    ◦ Container crashes (for example due to OOM)
Have you check Zookeeper?

---

**Lasith Haturusinha** (2025-04-01 05:11):
Has anyone come across this -&gt; Welcome to the Observability Cloud (https://www.observeinc.com/)

---

**Amol Kharche** (2025-04-01 05:13):
Could you please help us to attach logs. Support Package (Logs) | SUSE Observability (https://docs.stackstate.com/self-hosted-setup/install-stackstate/troubleshooting/support-package-logs)

---

**chihjen.huang** (2025-04-01 05:43):
Here is the log.

---

**chihjen.huang** (2025-04-01 05:44):
After numerous restarts, it finally succeeded. Please note that I didn't make any changes to my cluster.
```neuvector@ubuntu2204-E:~/olly/log$ k get pods -n suse-observability
NAME                                                              READY   STATUS    RESTARTS          AGE
kafkaclient                                                       1/1     Running   0                 144m
nfs-subdir-external-provisioner-6bf7467b87-s96tn                  1/1     Running   0                 28h
suse-observability-clickhouse-shard0-0                            2/2     Running   0                 27h
suse-observability-correlate-d6469d94d-d9hwt                      1/1     Running   4 (27h ago)       27h
suse-observability-e2es-7b78949955-v8vc8                          1/1     Running   185 (5h49m ago)   27h
suse-observability-elasticsearch-master-0                         1/1     Running   132 (18h ago)     27h
suse-observability-hbase-stackgraph-0                             1/1     Running   0                 27h
suse-observability-hbase-tephra-0                                 1/1     Running   0                 27h
suse-observability-kafka-0                                        2/2     Running   0                 27h
suse-observability-kafkaup-operator-kafkaup-6696df7b49-xpt88      1/1     Running   0                 27h
suse-observability-otel-collector-0                               1/1     Running   0                 27h
suse-observability-prometheus-elasticsearch-exporter-86f5599j4q   1/1     Running   0                 27h
suse-observability-receiver-876df75c7-7gkgb                       1/1     Running   0                 27h
suse-observability-router-7bf6bb65b6-qmss4                        1/1     Running   0                 27h
suse-observability-server-7bdbff894f-r4r5h                        1/1     Running   4 (27h ago)       27h
suse-observability-ui-5c7b954d7f-hxdln                            2/2     Running   0                 27h
suse-observability-victoria-metrics-0-0                           1/1     Running   0                 27h
suse-observability-vmagent-0                                      1/1     Running   0                 27h
suse-observability-zookeeper-0                                    1/1     Running   0                 27h```

---

**chihjen.huang** (2025-04-01 05:46):
@Garrick Tam, zookeeper looks good.
as the current status :point_up: , it recovered automatically (don't know why).

---

**Amol Kharche** (2025-04-01 05:57):
The error I see in correlate pod. which indicate that the required Kafka topics are currently missing. it might have taken a long time for Kafka to start and the job that creates the topics might have already failed earlier.
```2025-03-30 23:59:53,060 ERROR none - Stopping correlate app. Topic check failed.
com.stackstate.kafka.StsKafkaAdminClient$MissingKafkaTopics: These Kafka topics do not exist at the moment: sts_topo_process_agents, sts_correlate_endpoints, sts_correlated_connections, sts_correlate_http_trace_observations. StackState expects these topics to be available. Please contact support if this happens with a standard installation.```
The easiest way to create the topics is by running the `helm upgrade` command to do an "upgrade" (no pods will be really affected if you don't make any changes in configuration). It will start the `create-topic` job again, it should be able to create the topics without a problem now and after that the pods in crashloopbackoff should also recover.

---

**Amol Kharche** (2025-04-01 06:00):
By the way, Suse Observability don't recommend to use NFS for persistence volumes.
https://suse.slack.com/archives/C07CF9770R3/p1731321912118639?thread_ts=1730962730.143879&amp;cid=C07CF9770R3

---

**chihjen.huang** (2025-04-01 06:11):
I don't have permission for the link, could you share the content with me?

---

**Amol Kharche** (2025-04-01 06:12):
Stackstate engineer (*Vladimir Iliakov*) - Maybe we should stop here. We, Suse Observability, don't recommend to use NFS for persistence volumes, especially in production

---

**chihjen.huang** (2025-04-01 06:14):
I see, thanks for your information.  This is for my personal testing so it should be okay

---

**chihjen.huang** (2025-04-01 06:14):
I want to avoid using cloud, it's a bit expensive.

---

**Amol Kharche** (2025-04-01 06:16):
May be can try local path provisioner
https://github.com/rancher/local-path-provisioner

---

**chihjen.huang** (2025-04-01 06:16):
nice, thanks for your sharing !

---

**Rajesh Kumar** (2025-04-01 07:25):
yes 22411, additionally I was trying to use suse-observability-values helm chart for external-secrets but there is no way, that creates confusion from what is mentioned in the document (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/kubernetes_install) . So I added the implementation in the values chart.

---

**Mark Bakker** (2025-04-01 07:51):
Hi @Lasith Haturusinha yes they are known in the Observability space. Don't hear them to often.

---

**Remco Beckers** (2025-04-01 08:23):
No problem :slightly_smiling_face:

---

**Remco Beckers** (2025-04-01 08:56):
I'll discuss with the team whether we can include that in the values helm chart. It's main purpose is to simplify configuration of the parts that repeatedly appear in the main charts values (like affinity) or that use a single input to set a lot of values (like the profile).
There are many settings that users might want to set on the main helm chart and we included none of them in the values chart to keep that simple to configure and not repeat ourselves

---

**Saurabh Sadhale** (2025-04-01 09:35):
@Remco Beckers @Louis Lotter is there a possibility to add about the Button ( Show Logs ) Removal in the release notes ?

---

**Remco Beckers** (2025-04-01 10:02):
We can, but it will be on a old version (actually I think the first version released as SUSE Observability)

---

**Nick Zhao** (2025-04-02 03:30):
hi team, do we support find what is consuming memory for pod in code level?  Such as: . net core, java.  My customer is facing memory leap.  thank you.

---

**Frank van Lankvelt** (2025-04-02 07:44):
Hi Nick.  We ingest metrics by those VMs by default and expose them for pods running them.  You should be able to find some examples on https://play.stackstate.com (https://play.stackstate.com)

---

**Saurabh Sadhale** (2025-04-02 10:11):
I think that should help.

---

**Remco Beckers** (2025-04-02 10:23):
It's there now: https://docs.stackstate.com/self-hosted-setup/release-notes/v2.0.0

---

**Saurabh Sadhale** (2025-04-02 10:24):
Thank you so much the quick response :smile:

---

**Nick Zhao** (2025-04-02 10:50):
I want to see which part of the code/class has the memory leak issue. Can't see it from the metric, right?

---

**Frank van Lankvelt** (2025-04-02 10:52):
no, you'll have to attach a debugger or get a memory dump for that level of analysis.

---

**Nick Zhao** (2025-04-02 10:55):
how about open-telemetry? can we leverage it with custom dashboard to show something valuable?

---

**Frank van Lankvelt** (2025-04-02 11:03):
debugging these issues goes well beyond observability.  With the metrics and deployment history in hand, it is possible to bisect the change that introduced the leak.

---

**Lasith Haturusinha** (2025-04-02 12:29):
Seems like certain capabilities and features similar to us...

---

**Zia Rehman** (2025-04-02 14:06):
Hi Team,
During my ongoing beta, I came across three questions and would appreciate your insights:
1. How do we configure RBAC in SUSE Observability?
2. What is the purpose of using the CLI when SUSE Observability already has a robust UI? (might be for scripting and automation) 
3. Is Open_Telemetry SDK use cases related in anyway to the "extensions" used with Suse Observability ? Or both are different topics ?
Looking forward to your responses. Thanks!

---

**Louis Lotter** (2025-04-02 14:37):
RBAC is still a work i progress. It's our top priority atm.

---

**Louis Lotter** (2025-04-02 14:43):
@Mohamed Elnemr Could probably expand nicely on everything he and @Marc Rua Herrera used the CLI for.

---

**Louis Lotter** (2025-04-02 14:44):
@Remco Beckers can you tackle question 3 ?

---

**Remco Beckers** (2025-04-02 14:50):
RBAC integration with Rancher/Kubernetes is work in progress, but we do have RBAC support already. That is documented on our docs site: https://docs.stackstate.com/self-hosted-setup/security/rbac

---

**Remco Beckers** (2025-04-02 14:53):
For 3. I'm not sure what you mean by
&gt; "extensions" used with SUSE Observablity
If you are referring to the Rancher extension for SUSE Observability, the answer is no. Open Telemetry is entirely unrelated. The typical use-case for Open Telemetry is to instrument your own applications in more depth to get  traces and custom metrics. With the open telemetry collector it is also possible to scrape metrics from many third-party applications (for example many databases are supported or anything with a Prometheus exporter can be scraped).

---

**Remco Beckers** (2025-04-02 14:55):
The CLI is usually used in gitops scenarios where configuration is (partially) automated in CI/CD pipelines.
But there are also some configurations that are not supported in the UI but that can be done via the CLI (for example creating service tokens or ingestion api keys).

---

**Zia Rehman** (2025-04-02 15:44):
Got it, thanks a lot for sharing the information.

---

**Thomas Muntaner** (2025-04-02 15:44):
Hi SUSE Obervability team.

our cluster's ingress has a certificate signed by the SUSE CA. Because the agent doesn't have the CA, I saw that we have to use `global.skipSslValidation` to get it to speak to our cluster.

Do we have a more secure option that lets us add the CA to the agent pods?

Thanks

---

**Nick Zhao** (2025-04-03 05:24):
Thank you Frank.  So it is out of our support scope.

---

**Rajesh Kumar** (2025-04-03 06:44):
This https://docs.stackstate.com/self-hosted-setup/security/self-signed-certificates ?

---

**Thomas Muntaner** (2025-04-03 09:08):
Thanks. I thought this was only for the SUSE Observability server, and not the agent

---

**Thomas Muntaner** (2025-04-03 09:10):
actually, I don't see the trust store at all in the agent helm chart values

---

**Dinesh Chandra** (2025-04-03 09:16):
Hi Team, my customer wants custom metrics pulled from Apps and available in SUSE observability for example velero backup related info, is there any guide for same?
https://grafana.com/grafana/dashboards/15469-kubernetes-addons-velero-stats/

I am testing auto-instrumentation  (https://github.com/open-telemetry/opentelemetry-operator?tab=readme-ov-file#opentelemetry-auto-instrumentation-injection)but so far no luck. It only work if app has some way to export to otel-collector. Any suggestions please Thanks

---

**Marc Rua Herrera** (2025-04-03 09:18):
Just to add on the RBAC part: at the moment, RBAC can't be configured via the UI yet. Since it's typically a one-time setup, some customers prefer to do it using the CLI. Others who want to automate the deployment or integrate it in their GitOps flow often include the configuration directly in the Helm chart—especially useful when managing multiple environments or clusters. This way, access control is versioned and consistently applied across setups.

---

**Saurabh Sadhale** (2025-04-03 09:55):
Can you please also help with the release for observability agent 1.0.30 for the bug https://stackstate.atlassian.net/browse/STAC-22443 as the same customer has raised a new case reporting similar behaviour.

is there any workaround that we can suggest to the customer ?

---

**Remco Beckers** (2025-04-03 10:08):
I believe the new agent was released. @Alessio Biancalana did you check if the agent was released?

---

**Saurabh Sadhale** (2025-04-03 10:31):
```% helm search repo suse-observability
NAME                                        	CHART VERSION	APP VERSION                                 	DESCRIPTION                                       
suse-observability/suse-observability       	2.3.1        	7.0.0-snapshot.20250312150320-master-1f9655b	Helm chart for SUSE Observability                 
suse-observability/suse-observability-agent 	1.0.25       	3.0.0                                       	Helm chart for the SUSE observability Agent.      
suse-observability/suse-observability-values	1.0.7        	1.0.0                                       	Helm Chart for rendering SUSE Observability Values```

---

**Remco Beckers** (2025-04-03 10:42):
I just checked and it wasn't released due to a bug in the release pipeline. I've asked someone to look at that now

---

**Remco Beckers** (2025-04-03 10:43):
In the mean time maybe @Alessio Biancalana can you help maybe by explaining the configuration changes? They could apply them to their logs agent installation I think

---

**Alessio Biancalana** (2025-04-03 10:50):
@Saurabh Sadhale I created a new scraping job in the logs agent config map

```    - job_name: static-pod-logs
      kubernetes_sd_configs:
        - role: pod
      pipeline_stages:
        - docker: {}
        - cri: {}
      relabel_configs:
        - action: replace
          source_labels:
            - __meta_kubernetes_pod_name
          target_label: pod_name
        - action: replace
          source_labels:
            - __meta_kubernetes_pod_uid
          target_label: pod_uid
        - action: replace
          source_labels:
            - __meta_kubernetes_pod_container_name
          target_label: container_name
        # The __path__ is required by the promtail client

  

  

  
        - replacement: /var/log/pods/*$1/*.log
          separator: /
          source_labels:
            - __meta_kubernetes_pod_annotation_kubernetes_io_config_mirror
            - __meta_kubernetes_pod_container_name
          target_label: __path__
        # Drop all remaining labels, we do not need those
        - action: labeldrop
          regex: __meta_(.*)```

---

**Alessio Biancalana** (2025-04-03 10:50):
I think the shortest path is just to get the new helm chart out anyway

---

**Remco Beckers** (2025-04-03 10:50):
Maybe just give it a minute indeed. Looks like they already have a fix and we should be able to publish it soon.

---

**Davide Rutigliano** (2025-04-03 10:52):
Hey SUSE Observability team,

We would like to use RBAC integration with Rancher roles. As I understood it's not yet rolled out but is there any beta/experimental feature available already?

---

**Davide Rutigliano** (2025-04-03 10:52):
For instance I see helm chart has `stackstate.experimental.k8sAuthorization`  parameter. Is that related?

---

**Alejandro Acevedo Osorio** (2025-04-03 10:54):
It is related indeed, that's the feature flag we are using internally while developing. But unfortunately is not there yet to be tried out

---

**Davide Rutigliano** (2025-04-03 10:56):
I see the parameter in chart `v2.3.1` (stackstate `7.0.0-snapshot.20250312150320-master-1f9655b` ), won't it work if I enable it?

---

**Alejandro Acevedo Osorio** (2025-04-03 11:00):
it won't completely work. It will enable some bits on the SUSE Observability instance (where there are still bits missing) but it would be missing an agent that needs to be deployed to all the observed clusters. So it definitely won't work

---

**Davide Rutigliano** (2025-04-03 11:01):
you mean suse-observability agent or?

---

**Alejandro Acevedo Osorio** (2025-04-03 11:03):
a new RBAC agent

---

**Davide Rutigliano** (2025-04-03 11:05):
aha ok, make sense thanks!

---

**Davide Rutigliano** (2025-04-03 11:06):
as far as you know, is there any plan for the RBAC agent to be released in experimental version?

---

**Alejandro Acevedo Osorio** (2025-04-03 11:11):
that's a good question, I'm not sure what the plan is about that

---

**Davide Rutigliano** (2025-04-03 11:12):
We (itpe-core team) would be very happy to be customer 0 for it :)

---

**Alejandro Acevedo Osorio** (2025-04-03 11:13):
Awesome @Davide Rutigliano. Let me tag the right people here so they keep you in mind @Remco Beckers @Louis Lotter @Mark Bakker :point_up:

---

**Louis Lotter** (2025-04-03 11:30):
@Davide Rutigliano RBAC  is our top priority atm. It's complex and should not be rushed but it's also not years away. We work fast. Please be patient with us :bow:

---

**Louis Lotter** (2025-04-03 11:32):
We will clearly anounce it when it's ready and would love to have you as an early tester.

---

**Zia Rehman** (2025-04-03 14:59):
@Marc Rua Herrera, thanks for the explanation.
I have one more question:
When we install the STS CLI using the command:
`curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="&lt;URL&gt;" STS_API_TOKEN="&lt;API-TOKEN&gt;" bash`
the configuration file is automatically generated at `.config/stackstate-cli/config.yaml`.
Given this, why do we still need to run the following configuration command?
`sts context save --name &lt;NAME&gt; --url &lt;URL&gt; --api-token &lt;API-TOKEN&gt;` 
--
Following are the reason or any other aspect is there:
1.Installation generates a default config but doesn’t name a context explicitly.
2.Using sts context save allows you to define multiple contexts and switch between them easily.

---

**Remco Beckers** (2025-04-03 16:11):
Nope, that's why you would manually save the context. No need to do that if you're happy with the `default`

---

**Zia Rehman** (2025-04-03 16:45):
Okay got it. Thanks @Remco Beckers.

---

**Saurabh Sadhale** (2025-04-03 16:45):
I have tested this in my lab by patching the configmap and it works. I can see logs for all static pods as well. example is for etcd pod:

---

**Davide Rutigliano** (2025-04-04 14:26):
Hi SUSE Observability team,

We are trying to setup LDAP authentication against `ucs-ldap.dmz-prg2.suse.org (http://ucs-ldap.dmz-prg2.suse.org)` . I am providing the custom CA certificate using `stackstate.authentication.ssl.trustCertificateBase64Encoded`  but whenever I try to authenticate in the UI login fails with invalid credentials (both for local admin user that was working before and LDAP users) and I get following error in suse-observability-api pod about `java.security.cert.CertPathValidatorException: name constraints check failed`.

I have tried also trustCertificate (no base 64) and trustStore (for which I didn't find any trustStorePassword parameter BTW) without success and I’m not sure how to dig deeper to resolve this. Anyone who could assist with troubleshooting? :pray:

---

**Alejandro Bonilla** (2025-04-04 14:52):
@Mark Bakker here is a request from two customers I’ve talked to in the last 2 weeks. One of them includes Kroger:
• ability to one-click add a cluster to Observability. Meaning that if the Rancher Manager has the extension installed, one can go into a downstream cluster and click “Observe” or install and it would handle the stack pack configuration and agent install.
• they also requested the ability to observe at cluster creation, without having to do anything manually. Looks like the best way would be to add a button to the rancher provisioning (cluster creation) so that we handle the addition.
Do we have these on roadmap or is there a current JIRA for something similar? Thanks

---

**Alejandro Bonilla** (2025-04-04 14:57):
For the first point, we could copy the workflow from Kubewarden…! Check it out.

---

**Lukasz Marchewka** (2025-04-04 14:59):
can you confirm if it works, if yes then I will make changes to our helm chart :slightly_smiling_face:

---

**Lukasz Marchewka** (2025-04-04 15:09):
@Saurabh Sadhale please wait, I want to test sth else before

---

**Luca Barzè** (2025-04-04 15:18):
hello! I have two questions:
• a prospect is using graylog to centralize their logs from different sources (active directory, windows event viewer, … ) can we use open telemetry agents to collect also this logs into suse observability? 
• we do not support windows k8s worker nodes, don’t we?
thank you!

---

**David Noland** (2025-04-05 19:35):
If this a paid customer such as Kroger, it's probably best to have them file a support case on SCC so we can track it properly as an RFE.

---

**Alejandro Bonilla** (2025-04-06 01:02):
@Wayne Patton ^^

---

**Surya Boorlu** (2025-04-07 07:08):
Hi Team, Customer Wabra Bank is facing an issue where stackstate server pod is restarting and causing UI not available.

Here are the logs and yaml of the server pod.

Is this due to the timeout?

---

**Remco Beckers** (2025-04-07 08:17):
• At the moment SUSE Observability only supports logs for pods. So even though you can use Open Telemetry to collect the logs they will not be available in SUSE Observability afterwards. We have full log support on the roadmap to support these use-cases though.
• We don't support Windows worker nodes indeed

---

**Remco Beckers** (2025-04-07 08:37):
The `name constraints check failed.` error suggests that the CA certificate has some `name constraints` defined and apparently the `ucs-ldap.dmz-prg2.suse.org (http://ucs-ldap.dmz-prg2.suse.org)` fails one of those checks. That's about where my knowledge on certificates ends. This (https://www.gradenegger.eu/en/use-name-constraints-to-allow-a-ca-to-issue-certificates-only-for-certain-domain-names/) looks like a detailed explanation on `name constraints`. But here is a more concrete example: https://www.pkisolutions.com/name-constraints-extension/

I would try to view the details of the certificate to see what constraints are defined in the CA certificate, For example with `openssl` that should be possible, but also with `keytool` that comes with a Java distribution or, in Windows, right-click and select open on the certificate.

---

**Chris Riley** (2025-04-07 09:13):
@Surya Boorlu Please post case-related queries like this in <#C07CF9770R3|>

---

**Remco Beckers** (2025-04-07 09:30):
The new agent has been released as well now

---

**Lukasz Marchewka** (2025-04-07 13:04):
@Saurabh Sadhale
1. can you share configuration of clickhouse which you have applied (`clickhouse.*` from `values.yaml` ) 
2. can you export one of clickhouse pod to YAML ?
3. do you have more logs when you have disabled Security Context

---

**Saurabh Sadhale** (2025-04-07 13:05):
@Lukasz Marchewka the cluster is gone. I will set up one more time and then get back to you.

Do you want me to add the above clickhouse: configuration that you have shared. ?

---

**Vladimir Iliakov** (2025-04-07 13:36):
Hi @James Mason, is the Saas tenant still needed?

---

**Lukasz Marchewka** (2025-04-07 13:45):
nope,  please use this one
```clickhouse:
  podSecurityContext:
    enabled: false
  containerSecurityContext:
    enabled: false```

---

**Lukasz Marchewka** (2025-04-07 13:46):
can you ping me when a cluster will be ready

---

**James Mason** (2025-04-07 17:01):
You can close if necessary, but I would like to be able to test future versions before publishing

---

**Davide Rutigliano** (2025-04-07 18:47):
Hi team, I am trying to configure LDAP authentication in stackstate but I am not sure which certificates I need to include in the trustStore/trustCertificate. Should they include the entire CA certificates chain or is the root CA enough (as reported in my previous question (https://suse.slack.com/archives/C079ANFDS2C/p1743769598425569) seems it's not)? I am following the docs (https://docs.stackstate.com/self-hosted-setup/security/authentication/ldap#:~:text=trustStore%20%2D%20Optional%2C%20Java%20trust%20store%20file%20for%20SSL.%20If%20both%20trustCertificates%20and%20trustStore%20are%20specified%2C%20trustCertificatesPath%20takes%20precedence) but I don't have the full chain of PEM files so I would like to use the trustStore instead. Is there any way to provide a password for it? I don't see any `stackstate.ldap.ssl.trustStorePassword`  (while I see it's available for java trustStore instead). Anyone who could help us here (also by pointing out docs/examples/tests to take inspiration from)?

---

**Remco Beckers** (2025-04-08 08:10):
Normally providing the root CA is enough, and there is no need for the entire chain

---

**Remco Beckers** (2025-04-08 08:11):
Did you check my suggestion in the other thread?

---

**Remco Beckers** (2025-04-08 08:18):
As for the trust store: there is no way to provide a password for that, but the password is also not needed to read a certificate from the store (it is only required for updating the store).

---

**Vladimir Iliakov** (2025-04-08 09:11):
I think, this is necessary since there are costs involved...
@Louis Lotter FYI

---

**Davide Rutigliano** (2025-04-08 09:12):
Thanks Remco, make sense :slightly_smiling_face: About the root CA I am not sure if I am doing something else wrong then. The LDAP server  (ucs-ldap.dmz-prg2.suse.org (http://ucs-ldap.dmz-prg2.suse.org)) has following chain:
• Server certificate signed by `SUSE CA dmz-prg2.suse.org (http://dmz-prg2.suse.org)` 
• `SUSE CA dmz-prg2.suse.org (http://dmz-prg2.suse.org)` intermediate certificate signed by  `SUSE CA Root`
• `SUSE CA Root` certificate signed by `SUSE Trust Root`
I am using `SUSE Trust Root`  only (either PEM or JKS format) but stackstate api cannot validate the ldap endpoint and at each login i get errors reporting `Caused by: java.security.cert.CertPathValidatorException: name constraints check failed`.

---

**Remco Beckers** (2025-04-08 09:13):
So you provide SUSE Observability with the `SUSE CA Root` certificate?

---

**Remco Beckers** (2025-04-08 09:18):
@Mark Bakker I've had this request (for the first bullet) a few times as well. The KubeWarden approach (for Rancher Prime only) of using the extension to simplify the installation looks like it could work for our agents as well

---

**Davide Rutigliano** (2025-04-08 09:20):
`SUSE Trust Root`  that is the CA used for signing the `SUSE CA Root` certificate (which I think is an intermediate CA)

---

**Remco Beckers** (2025-04-08 09:29):
Ok. Did you try using `SUSE CA Root` ?

---

**Remco Beckers** (2025-04-08 09:30):
I'm definitely not an expert on this, but the error indicates restrictions on the certificate used for verification

---

**Davide Rutigliano** (2025-04-08 09:33):
Didn't try `SUSE CA Root`  as I don't have it by hand but for other ldap configurations (eg. with grafana) we use `SUSE Trust Root`

---

**Davide Rutigliano** (2025-04-08 09:34):
and from what i got (no expert here as well) I understood Java is a bit picky with certificates and that's why I thought it would need the entire certificate chain

---

**Remco Beckers** (2025-04-08 09:50):
Then I guess the only thing left is try a trust store that has certificates for the entire certificate chain

---

**Remco Beckers** (2025-04-08 09:50):
I'll ask in our team to see if anyone has seen something similar before

---

**Mark Bakker** (2025-04-08 09:51):
@Alejandro Bonilla having a tighter integration with all ECM products is on our roadmap, thanks for sharing those two specific asks. From who came which of the asks and who is the second customer so I can add that to our feedback tracking?

---

**Mark Bakker** (2025-04-08 09:52):
@David Noland better not to file RFE's since we will change that process soon to a process where customers can only file Idea's. An RFE gives an expectation which we don't like to give.
An idea is something we can count and if many have the same request we can account for it.

---

**Mark Bakker** (2025-04-08 09:56):
@Alejandro Bonilla do you have some more information about the cluster creation one? What exactly are they searching for regarding this?

---

**Davide Rutigliano** (2025-04-08 10:14):
I have maually crafted the certificate chain adding SUSE Trust Root and the 2 intermediate CAs I had in ldap server certificate and it seems I got a step further. I can passthrough the login screen and I get an Internal Server Error (that may be related to the way I configured LDAP and not to stackstate)

---

**Remco Beckers** (2025-04-08 10:22):
:sweat_smile:

---

**Marc Rua Herrera** (2025-04-08 13:26):
Hi Team, I see this error in the Traces. I had a look at all the pods but apparently there are not any issues. I also inspected the network and saw an strange thing, a 404 error. What else can I check here?

---

**Amol Kharche** (2025-04-08 13:50):
What is under endpoint? I would love to see the logs from client otel collector and suse-observability-otel-collector-0 statefulset pod. Also it is possible to share otel-collector.yaml file here ?
```  exporters:
    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: &lt;otlp-stackstate-endpoint&gt;:443
    otlphttp/stackstate:
       auth:
          authenticator: bearertokenauth
       endpoint: https://&lt;otlp--http-stackstate-endpoint&gt;  ```

---

**Marc Rua Herrera** (2025-04-08 13:58):
I need to ask to the customer to these files. However, I believe its well configured because we are receiving metrics. It is just the traces view, which it does not load

---

**Amol Kharche** (2025-04-08 14:10):
Okay, @Remco Beckers Have you seen like metrics is fine but not traces , I have no idea now.

---

**Alejandro Bonilla** (2025-04-08 14:48):
Nowcom and Kroger. Kroger wants to easily observe clusters. Meaning to avoid even the agent install and cluster creation. Maybe @Wayne Patton can add more

---

**Remco Beckers** (2025-04-08 15:31):
It looks like the traces api is completely disabled to be honest

---

**Remco Beckers** (2025-04-08 15:32):
Which version did they install and do they have clickhouse running?

---

**Ivan Wong** (2025-04-08 15:40):
Hi, is there any evaluation key for SUSE Observability?  Thx.

---

**Mark Bakker** (2025-04-08 15:44):
And which ones where from Nowcom?

---

**Remco Beckers** (2025-04-08 16:07):
To be clear: this has nothing to do with whether or not trace data is shipped to SUSE Observability. This is the platform API returning a 404 for the trace endpoints.

---

**Remco Beckers** (2025-04-08 16:09):
More useful information would be: logs, specifically from the api pod but preferably the entire support package: https://docs.stackstate.com/self-hosted-setup/install-stackstate/troubleshooting/support-package-logs

---

**Jaroslaw Biniek** (2025-04-08 16:32):
Hi team, what is the licensing status of StackState/Observability? I know it was supposed to be open-sourced soon after SUSE took over but have we actually done it yet?

---

**Louis Lotter** (2025-04-08 16:35):
It's pinned in this channel

---

**Louis Lotter** (2025-04-08 16:36):
Open sourcing Suse Observability has not happened yet. It's on the roadmap but is fighting for priority with a lot of key features like RBAC, Dashboarding etc.

---

**Mark Bakker** (2025-04-08 16:51):
It is planned for end of this year @Jaroslaw Biniek

---

**Alejandro Bonilla** (2025-04-08 17:16):
1. NowCom and other customers, as well as my agreement on the UX - With the one click inclusion with the extension.
2. Kroger wants automated ways for clusters to be observed. It was my opinion to add a check-box in Rancher provisioning to then have this happen automatically with the cluster addition.

---

**Alejandro Bonilla** (2025-04-08 17:16):
As these "System Services" listed at the bottom.

---

**Alejandro Bonilla** (2025-04-08 17:17):
but, we can setup a call with Kroger for you to ask these questions or we can ask them for you.

---

**Alejandro Bonilla** (2025-04-08 17:17):
Please provide the questions and we can pass them on

---

**Wayne Patton** (2025-04-08 18:18):
The original question from Kroger was:

```"Do you know if there is a way for Suse Observability to automatically add a new cluster stackpack if it starts reporting to it? I hate to have to automatically add new clusters when they get deployed."```

---

**David Noland** (2025-04-08 20:49):
Do we at least plan on dropping the mandatory license key soon? We get quite a few support cases for this.

---

**David Noland** (2025-04-09 00:15):
When will "Ideas" be rolled out so we can track customer RFEs?

---

**Michael Bukva** (2025-04-09 04:34):
What is the support and "direction" for using/pitching SUSE Observability to customers with Openshift k8s clusters?

The only existing public docs, still Stackstate-branded, describe integrating Openshift with the SAAS version of SUSE Observability (that is in the quick-start guide) and then there is a separate section for setting up Observability within Rancher Prime which mentions rke2 and the three big hyperscalers' k8s-aas but not Openshift.

Just want to understand what is and isn't supported and in what mode of operation. Sort of thing a support matrix would do.

---

**Bram Schuur** (2025-04-09 09:10):
FYI @Louis Lotter: I put a task on our backlog to contact @Davide Rutigliano you when we are ready. https://stackstate.atlassian.net/browse/STAC-22641

---

**Mark Bakker** (2025-04-09 13:05):
In the future SCC will be leading with the registering of Rancher managers to it and getting the entitlements from it. This however is not in the short term for Observability yet.

---

**George Yao** (2025-04-09 13:16):
Hi team, one prospect is asking if Observability is configurable to integrate with external database rather than using its own database like Victoria Metrics,ElasticSearch, ClickHouse, StackGraph. Or do we have the  plan to support this in future.

---

**Frank van Lankvelt** (2025-04-09 13:21):
SUSE Observability neither has that capability nor the intention to support that.  We tried that in the past, but that ties us down the lowest common denominator and severely limits the functionality that can be provided.

---

**George Yao** (2025-04-09 13:38):
OK, understood. Thanks for your reply.

---

**Mark Bakker** (2025-04-09 13:41):
From a technology point of view we support OpenShift and have multiple customers observing OpenShift.
From a licensing perspective this is supported if they import the clusters in Rancher since we support any workload managed by Rancher Prime.

---

**Michael Bukva** (2025-04-09 13:46):
Right, that’s reasonable and what I’d hoped for. @Lasith Haturusinha

---

**Dawid van der Merwe** (2025-04-09 15:21):
Hi Team, do we have a SUSE version, and a more recent version, of this document? - https://assets.ctfassets.net/ud9dfq0vudar/37BRx9BHbuhsZ5V6VFkPrD/b542c8c6758de459eed29cbb396acb4b/StackState_Technical_Overview_-_Q1_2021.pdf

+

https://assets.ctfassets.net/ud9dfq0vudar/7dNTFzy4LwD6RZrh5LmgST/005e98b636c597b358146ba762b9ca08/Data_Sheet_-_4T_Data_Model_-_November_2020.pdf

+

https://516677.fs1.hubspotusercontent-na1.net/hubfs/516677/stackstate-observability-maturity-model.pdf

---

**Erico Mendonca** (2025-04-09 21:22):
What would cause the nodes to be reported as "Not Ready" in Observability even though they are also "Clear" and "Healthy", with dozens of running workloads and available resources?

---

**Jeroen van Erp** (2025-04-09 21:27):
The status column is coming from kubernetes,

---

**Erico Mendonca** (2025-04-09 21:28):
but...
```[root@rancher03 ~]# kubectl get nodes
NAME        STATUS   ROLES                       AGE   VERSION
rancher02   Ready    <none>                      33d   v1.30.6+rke2r1
rancher03   Ready    control-plane,etcd,master   39d   v1.30.6+rke2r1
[root@rancher03 ~]# ```

---

**Erico Mendonca** (2025-04-09 21:31):
and if I open the "Node Readiness" monitor on one of the nodes... :confusedparrot:

---

**Erico Mendonca** (2025-04-09 21:33):
Is this a Schroedinger's node? :schrodinger_cat:

---

**Jeroen van Erp** (2025-04-09 21:40):
Can you check in the metrics explorer: `kubernetes_state_node_by_condition{condition="Ready"}`

---

**Jeroen van Erp** (2025-04-09 21:42):
@Remco Beckers @Bram Schuur Might be one for you guys to look at tomorrow

---

**Erico Mendonca** (2025-04-09 21:43):
From the mouse over text:
```kubernetes_state_node_by_condition {kubelet_version="v1.30.6+rke2r1", container_runtime_version="<containerd://1.7.22-k3s1>", sts_host="rancher02-worker01", interval="0", condition="Ready", status="true", kernel_version="5.14.0-565.el9.x86_64", node="rancher02", os_image="CentOS Stream 9", cluster_name="worker01"}```

---

**Alejandro Acevedo Osorio** (2025-04-10 00:01):
Seems like the same issue https://suse.slack.com/archives/C07CF9770R3/p1744154187179919 (https://suse.slack.com/archives/C07CF9770R3/p1744154187179919)

---

**Erico Mendonca** (2025-04-10 00:35):
It seems I don't have access to the link you provided.

---

**James McKenzie** (2025-04-10 05:27):
Were you ever to get this figured out.  I am having the same issue through ingress setup on a new cluster, fresh install.

---

**James McKenzie** (2025-04-10 05:34):
never mind, tried the incognito and it worked.  Now just need a reg code

---

**Alejandro Acevedo Osorio** (2025-04-10 09:17):
It would be nice to collect the component data. You can do that in the right hand side panel. On the 3 dot menu there’s an option to get the component JSON representation and there I can inspect what we get from k8s

---

**Lukasz Marchewka** (2025-04-10 09:42):
Hi @Saurabh Sadhale , can you share the status

---

**Saurabh Sadhale** (2025-04-10 09:46):
Apologies I have been busy with other issues. I will share details today. I have an OCP cluster setup have not installed stackstate yet.

---

**Nick Zhao** (2025-04-10 10:39):
hi team, our customer has certs assigned by internal microsoft enterprise ca provider server.  they required for using this cert for o11y deployment, how can we do with the external cert files?  thanks

---

**Alejandro Acevedo Osorio** (2025-04-10 10:41):
@Erico Mendonca after investigating how we derive that `node.status` column I see that the source data we use to derive it has some issues. We have a bug ticket to fix that https://stackstate.atlassian.net/browse/STAC-22603 ... the metrics that @Jeroen van Erp mentioned are corrected, and our monitor works with those metrics thus the health state `CLEAR`

---

**Davide Rutigliano** (2025-04-10 10:46):
Hello team, one clarification about SUSE observability agent and stackpacks. We have a SUSE observability cluster to which we plan to connect multiple RKE2 clusters (harvester, rancher and downstream clusters in OpenPlatform). As our list of cluster names could change over time, is it possible to connect SUSE observability agents deployed in a cluster to SUSE Observability receiver without manually adding the stackpack?

---

**Davide Rutigliano** (2025-04-10 10:50):
As I understood the `stackstate.stackpacks.installed` parameter in SUSE observability helm chart allows to pre-configure stackpacks at install time. While this could be enough and we can artifact some automation in our pipelines to fetch the list of cluster names, we were wondering if there is any way to make stackpacks installed dynamically (i.e., when a new agent connects to the receiver)?

---

**Ravan Naidoo** (2025-04-10 10:56):
SUSE Observability does not have this capability out of the box. I think this functionality can be easily achieved with a custom helm chart that depends on  the agent chart.  The custom chart has  job to run the CLI to register the Kubernetes StackPack instance with the backend.

---

**Saurabh Sadhale** (2025-04-10 11:02):
@Lukasz Marchewka please confirm do i add only in the openshift-values.yaml file whhile installing ?

```clickhouse:
  podSecurityContext:
    enabled: false
  containerSecurityContext:
    enabled: false```

---

**Jeroen van Erp** (2025-04-10 11:13):
```    /usr/local/bin/sts stackpack install --name kubernetes-v2 --url $url --service-token $service_token -p "kubernetes_cluster_name=$cluster_name" --unlocked-strategy fail```

---

**Jeroen van Erp** (2025-04-10 11:14):
And to create a dedicated ingestion (receiver) API key:

```  resp=$(/usr/local/bin/sts ingestion-api-key create --name $cluster_name -o json --url $url --service-token $service_token)
  echo $resp | jq -r '."ingestion-api-key".apiKey'```

---

**Mikhail Nikitin** (2025-04-10 11:26):
Wondering if we have any competitive analysis on https://github.com/coroot/coroot

It's an open-source eBPF-based observability tool that looks like does a lot of what we do in a similar fashion plus has some nice options on top like cloud cost monitoring that we don't have

---

**Davide Rutigliano** (2025-04-10 11:46):
this also requires to generate a dedicated service token (with sts cli) for each agent, correct?

---

**Jeroen van Erp** (2025-04-10 11:47):
Service token you only need one, that’s needed for the API that you as a user (or your automation) interacts with.

The Ingestion API Token (hihglighted above) is what the Agent uses to connect to the receiver API

---

**Davide Rutigliano** (2025-04-10 12:04):
thanks @Jeroen van Erp, I am giving it a try but I hit another issue in the meantime (and stackpack is pending in installing phase). I see `suse-observability-sync`  is continuously restarting and logging:
```exec /usr/bin/tini: exec format error```

---

**Davide Rutigliano** (2025-04-10 12:04):
is that a known issue / something related ?

---

**Jeroen van Erp** (2025-04-10 12:04):
stackpack == pending is good, meaning it’s waiting to receive data

---

**Jeroen van Erp** (2025-04-10 12:05):
It will go into green once there’s incoming data

---

**Davide Rutigliano** (2025-04-10 12:05):
it's "installing"

---

**Jeroen van Erp** (2025-04-10 12:05):
Ahh… first time can take a few secs (30+)

---

**Davide Rutigliano** (2025-04-10 12:05):
btw it was working til couple of days ago

---

**Jeroen van Erp** (2025-04-10 12:06):
Not sure about the sync service @Alejandro Acevedo Osorio?

---

**Davide Rutigliano** (2025-04-10 12:06):
I think that is breaking some flow, as the stackpack is installing since &gt;10m

---

**Davide Rutigliano** (2025-04-10 12:12):
Maybe this is also related?
`*api* 2025-04-10 10:00:49,361 ERROR c.s.security.authenticators.PersonalTokenAuthenticator - Personal API Token &lt;XXX&gt; is unknown`

---

**Remco Beckers** (2025-04-10 15:02):
That looks like the replica count for clickhouse is only 1 but should be 3.

---

**Remco Beckers** (2025-04-10 15:02):
So that sounds like a weird bug on our helm chart

---

**Remco Beckers** (2025-04-10 15:03):
That or 2 out of the 3 clickhouse pods are not starting up properly.

---

**Remco Beckers** (2025-04-10 15:03):
Could you check if that's the case?

---

**Remco Beckers** (2025-04-10 15:05):
Never mind, I see you shared the entire package

---

**Marc Rua Herrera** (2025-04-10 15:09):
That's a new set of logs after we tweek some stuff. Restart pods, redeploy Clickhouse and increase sync pods resources as it (didn't have enough resources)

---

**Remco Beckers** (2025-04-10 15:14):
I see one thing that is the likely cause for the traces api not working: the 4000-nonha profile disables traces in the api. Can you check in the generated `sizing_values.yaml` and remove the `traces: false` setting from the `experimental` section? It beats me why that is in there (it is in non of the other profiles)

---

**Marc Rua Herrera** (2025-04-10 15:15):
:thumbs-up:

---

**Remco Beckers** (2025-04-10 15:19):
Another thing that may be causing problems (and I can't see what is causing that) is that the otel-collector pod has trouble connecting to the api pod. It only succeeds occassionally, while most of the time it gives this error. But I see that the api was restarted very recently, so that might well be the cause (the last call succeeded again)

---

**Marc Rua Herrera** (2025-04-10 15:51):
Just tested it. It was the `stackstate.experimental.traces=false`

---

**Remco Beckers** (2025-04-10 15:54):
I thought so. That was a nice little bug that snuck in when setting up the 4000 profile (none of the other profiles had that)

---

**Erico Mendonca** (2025-04-10 17:59):
Here's the JSON.
``````

---

**Alejandro Acevedo Osorio** (2025-04-10 18:01):
Thanks, it does match with the issue that the ticket https://stackstate.atlassian.net/browse/STAC-22603 describes.

---

**Sam Chen** (2025-04-11 04:09):
hi there, we have a customer wants to know can we setup notification mail group by LDAP?

---

**andy.wu** (2025-04-11 05:07):
Hi Team
Is there any way to put the results of Metrics query through PromQL on views?
We have a customer who wants to customize icons, like grafana.

---

**Lasith Haturusinha** (2025-04-11 06:41):
Hi Team,
We've got few questions regarding SUSE Observability. Appreciate if someone can provide some context/answers to them :slightly_smiling_face:

1. Can the agent be installed in another way rather than using Rancher UI? Can we automate this to deploy multiple clusters?
2. What customizations we can do with SUSE Observability and how it is been done? how they can be customised to behave in certain ways based on things like thresholds?
3. Can we create custom dashboards?
4. Is there a way to define SLO?
5. Can the markers be labelled? how long do they persist? Are they visible to other users once it is set?
6. What IaC options do you have for configuring/customising your observability stack (eg. is there a terraform provider?)
If one requires me to send an email with all of the questions above, please let me know. Thanks in advance :)

---

**Amol Kharche** (2025-04-11 06:59):
1. Can the agent be installed in another way rather than using Rancher UI? Can we automate this to deploy multiple clusters?
--&gt;  Here is the sts cli command that you can be used into you gitops.
```sts --url YOUR_SO_URL --api-token YOUR_SO_TOKEN stackpack install -n kubernetes-v2 -p kubernetes_cluster_name=YOUR_CLUSTER_NAME```

---

**Lasith Haturusinha** (2025-04-11 07:31):
Thanks @Amol Kharche...appreciate your reply to the 1st question :slightly_smiling_face:

---

**Frank van Lankvelt** (2025-04-11 07:49):
Maybe it's easier to track the questions by putting them each in a separate thread?

---

**Lasith Haturusinha** (2025-04-11 07:50):
Thanks @Frank van Lankvelt, I'll put them separately now

---

**Lasith Haturusinha** (2025-04-11 07:51):
As suggested, dropping the above questions separately....starting with the 2nd :slightly_smiling_face:
2) What customizations we can do with SUSE Observability and how it is been done? how they can be customised to behave in certain ways based on things like thresholds?

---

**Lasith Haturusinha** (2025-04-11 07:51):
3) Can we create custom dashboards?

---

**Lasith Haturusinha** (2025-04-11 07:52):
4) Is there a way to define SLO?

---

**Lasith Haturusinha** (2025-04-11 07:52):
5) Can the markers be labelled? how long do they persist? Are they visible to other users once it is set?

---

**Lasith Haturusinha** (2025-04-11 07:52):
6) What IaC options do you have for configuring/customising your observability stack (eg. is there a terraform provider?)

---

**Frank van Lankvelt** (2025-04-11 07:53):
this is precisely what we're working on now, under the moniker "dashboarding".  It is already possible to create custom graphs by making your own stackpack.  With a metric binding, a promql query can be bound to a component.  There is even a limited amount of configurability for the placement of these graphs.

---

**Frank van Lankvelt** (2025-04-11 07:58):
Most of the UI elements are driven by configuration out of stackpacks.  Also monitors and their default thresholds.  Some monitors inspect annotations on components and use these to override the defaults.

---

**andy.wu** (2025-04-11 08:03):
Hi @Frank van Lankvelt Thank you for your reply.
So what you are saying is that in the future there will be a new feature called “dashboarding” that will allow customers to customize their visual charts right?

---

**Remco Beckers** (2025-04-11 08:20):
Even now they can already add metric charts to components (to be precise to the `metrics` perspective of a component, see https://docs.stackstate.com/metrics/custom-charts/k8s-add-charts.

Dashboards will allow a user to create a collection of charts (and other widgets) like in Grafana

---

**Remco Beckers** (2025-04-11 08:22):
Do you mean that they want SUSE Observability to use these certificates to provide HTTPS endpoints?

---

**Remco Beckers** (2025-04-11 08:25):
The recommended way is to setup an ingress controller that  handles the TLS encryption. Then configure an ingress for SUSE Observability and provide the certificates as the TLS secret: https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-via-the[…]e-observability-helm-chart (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-via-the-suse-observability-helm-chart).

SUSE Observability itself doesn't support HTTPS directly

---

**Remco Beckers** (2025-04-11 08:26):
SUSE Observability can send notifications via e-mail. So if you configure it to send the email to the mail group I think that should work.

---

**Frank van Lankvelt** (2025-04-11 08:42):
A thread about this just started in the channel. Tldr: not as user yet, developers can.  But it's under active development.

---

**Frank van Lankvelt** (2025-04-11 08:50):
the markers are not persisted - so I think they just last a single browser session - maybe not even that.  The timerange and instant of the "topology timeline" ARE persisted in the URL.  So you can easily share the view at a particular instant and others will see the exact same state.

---

**Mark Bakker** (2025-04-11 08:55):
For the monitor to set custom thresholds, see:
https://docs.stackstate.com/monitors-and-alerts/customize/k8s-override-monitor-arguments
To add custom charts:
https://docs.stackstate.com/metrics/custom-charts/k8s-add-charts
For the rest I like the question to be more specific. What does your customer/ prospect like to adjust/ add?

---

**Mark Bakker** (2025-04-11 08:56):
They are per session (browser)

---

**Nick Zhao** (2025-04-11 09:02):
alright，let me have a try. thanks

---

**Ravan Naidoo** (2025-04-11 09:03):
To understand UI elements mentioned by Frank, see
https://github.com/ravan/suse-observability-guides/blob/main/guides/suse/observability/view-customization/README.md

---

**Ravan Naidoo** (2025-04-11 09:06):
See https://docs.stackstate.com/metrics/custom-charts/k8s-add-charts.

For a practical example, see https://github.com/ravan/suse-observability-guides/blob/main/guides/suse/virtualization/metrics/README.md#step-4-adding-custom-dashboard-charts

---

**Ravan Naidoo** (2025-04-11 09:19):
The is no terraform provider.  But you can wrap the CLI to perform tasks.

For examples see https://github.com/SUSE/lab-setup/tree/develop/scripts#suse-observability

---

**Lasith Haturusinha** (2025-04-11 10:14):
Thanks @Ravan Naidoo. This may sound as a silly question, but is there a way to answer this question in a way to say why there's no IaC options for Observability? the reason behind...I don't know whether there's any such options for other tools.

---

**Lasith Haturusinha** (2025-04-11 10:15):
Thank you both @Frank van Lankvelt and @Ravan Naidoo. That'll help for now.

---

**Lasith Haturusinha** (2025-04-11 10:17):
Thanks @Frank van Lankvelt and @Mark Bakker. Appreciate it very much and it makes sense. The customer loved the "marker" functionality for troubleshooting....

---

**Ravan Naidoo** (2025-04-11 10:22):
There are many different provisioning tools over the years (Ansible, Salt, Puppet,  Terraform, Pulumi, etc.)  and CI/CD pipelines (Jenkins, AzureDevops, Github Actions, ArgoCD,  etc.) with each org having their own preference. As a small team there is no time cater for them all, so by having the CLI, people are free to wrap it however they like.   So the CLI is the driver.  As for the “as-code” part, all SUSE Observability configuration can be expressed in a yaml format. Example of a Monitor:

```_version: 1.0.85
nodes:
- _type: Monitor
  arguments:
    comparator: GTE
    failureState: DEVIATING
    metric:
      aliasTemplate: metric absent
      query: absent_over_time(stackstate_agent_running{sts_host=~"susecon-frb-cluster.*"}[1m]) or vector(0)
      unit: short
    threshold: 1.0
    urnTemplate: urn:cluster:/kubernetes:susecon-frb-cluster-0
  description: Agent has not sent data in 1 minute
  function: {{ get "urn:stackpack:common:monitor-function:threshold"  }}
  id: -13
  identifier: urn:custom:monitor:agent-connection-lost
  intervalSeconds: 60
  name: Agent connection lost
  remediationHint: |-
    No data received from agent.
    - Check network connectivity
    - Check agent deployed on observed cluster using Rancher Manager
  status: ENABLED
  tags:
  - agent```

---

**Lukasz Marchewka** (2025-04-11 12:46):
@Saurabh Sadhale is it ready

---

**Saurabh Sadhale** (2025-04-11 12:47):
I have an OCP cluster however facing other difficulties installing SUSE Observability on it.

---

**Saurabh Sadhale** (2025-04-11 12:47):
Let me know if I can share the details here.

---

**Saurabh Sadhale** (2025-04-11 12:47):
URL: https://console-openshift-console.apps.am970cxfa69043732c.southindia.aroapp.io/

Username: kubeadmin
Password: bRUaF-mu7cs-86Fnf-E5dwc

---

**Lukasz Marchewka** (2025-04-14 09:19):
@Saurabh Sadhale I want to continue this openshift problem, but I see the app is uninstalled. I have access to the cluster but maybe it would be better if you can install the app and then I will fix it. Otherwise I can install it myself but I don't have experience with Openshift so I can brake sth on. Who is the owner of the cluster ?

---

**Saurabh Sadhale** (2025-04-14 09:21):
@Lukasz Marchewka I am owner. 

I will try to complete the installation as soon as possible. I apologise for this delay.

---

**Bram Schuur** (2025-04-14 09:50):
@Davide Rutigliano about the `exec /usr/bin/tini: exec format error`. Could it be that pod landed on an arm64 node or something? Google tells me this error pops up when running on a different architecture

---

**Dawid van der Merwe** (2025-04-14 09:53):
Hi Team, does anyone have a POC or a Software Test template for Observability? A client needs to test Observability before they can accept and deploy in their estate? Help would be appreciated.

---

**Remco Beckers** (2025-04-14 10:00):
You can define your own (metric) monitors to define SLOs on certain components.

---

**Davide Rutigliano** (2025-04-14 11:32):
@Bram Schuur all nodes are amd64

---

**Bram Schuur** (2025-04-14 11:54):
Could you give the exact docker URL of the image? I'll see whether i can reproduce locally

---

**Davide Rutigliano** (2025-04-14 12:16):
`registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250312150320-master-1f9655b-2.5 (http://registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250312150320-master-1f9655b-2.5)`

---

**Bram Schuur** (2025-04-14 13:40):
I am at a loss then, that exact image is running fine for me locally aswell as in our cloud

---

**Nick Zhao** (2025-04-14 14:03):
hi team, do we support to watch the crd?

---

**Bram Schuur** (2025-04-14 14:34):
Right now we do not. It is on the roadmap, but I don't know exactly where

---

**Louis Lotter** (2025-04-14 14:35):
@Ravan Naidoo @Jeroen van Erp How is this normally approached ?

---

**Ravan Naidoo** (2025-04-14 14:48):
@Louis Lotter I’ve answered Dawid via mail already.

In general, attached is an old template that we used to use for StackState Pocs before only concentrating on Kubernetes. We used to do Pocs that needed detailed planning. When we switched to Kubernetes, customers just put the product through its paces internally. Platform Engineering teams are pretty opinionated and know what they want. We hardly ever got involved so I don’t have any up to date documents for that.

The attached PocExampleScenarios is just examples of what a prospect could potential use to evaluate. But these things are really driven depending on the customer and their teams needs.

---

**Gabriel Lins** (2025-04-14 15:04):
Hello, team. Could us generate a trial code to a customer test observability's install during a PoC? What's the best procedure in this case?

---

**Louis Lotter** (2025-04-14 15:17):
@Mark Bakker Does the scc handle this ? or do I step in ?

---

**Louis Lotter** (2025-04-14 15:18):
or should this just come from that spreadsheet I generated ?

---

**Louis Lotter** (2025-04-14 15:19):
the
```Partner &amp; Prospect Trial licenses```
doc

---

**Mark Bakker** (2025-04-14 15:25):
I don't know the process for trial for customers the partner sheet is only for partners mainly. Best to ask in <#C02AYV7UJSD|> channel.

---

**Gabriel Lins** (2025-04-14 15:56):
Does this partner spreadsheet contain a collection of licenses or just one? What is the validity period of each one? Since we have a partner connected to this customer, maybe they could provide the license. By the way, I asked in <#C02AYV7UJSD|> and am waiting for the correct approach. Thanks!

---

**Mark Bakker** (2025-04-14 16:00):
Best to ask @Meriem Ahmed-Wolters to get a trial license for partners she manages them

---

**Nick Zhao** (2025-04-14 18:15):
I hope it could be released asap since our many prospects require it.

---

**Masashi Homma** (2025-04-15 08:14):
Hello team, according to comment from thread https://suse.slack.com/archives/C079ANFDS2C/p1724207127214089, we can enter rancher FQDN into SUSE Observability URL. But it causes attached error. What URL should I use?

---

**Wilco van der Stek** (2025-04-15 08:34):
Despite the url message, you need to remove https://

---

**Masashi Homma** (2025-04-15 08:40):
Thank you! But another error occurs. I am using WLJWJ-5V5CF-NR1FA for service token.

---

**Ravan Naidoo** (2025-04-15 09:18):
Refer to Installing UI Extensions (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#installing-ui-extensions) in the docs.  You can follow the `Obtain a Service Token`  section to create a token that you can use.

---

**Masashi Homma** (2025-04-15 09:28):
Thank you. The document says "Log into the SUSE Observability instance". How to log in it?

---

**Jeroen van Erp** (2025-04-15 09:42):
@Masashi Homma The key you’re now entering is the license key, not the service token. Different thing altogether :slightly_smiling_face:

---

**George Yao** (2025-04-15 10:26):
Hi Team, A quick question, does SUSE Observability support to configure custom sizing.profile like `30-nonha` otherwise customer has to follow `50-nonha`  size to build Observability Server cluster.

---

**Bram Schuur** (2025-04-15 10:37):
The platform supports exactly the profiles that are listed on the docs (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#requirements), no others (so no `30-nonha`)

---

**Marc Rua Herrera** (2025-04-15 12:25):
Hey! I’m trying to pull all events for some stats we need from the Rabobank environment. If I remember right, we used to have an API for that—something like `http://.../api/events`—but I don’t remember the exact URL and can’t access it now.
Is the API still available? Could someone remind me of the correct URL?

---

**Bram Schuur** (2025-04-15 12:27):
Hey Marc, will you be accessing this api one-off or use it as part of their solution? Right now the events api is not for consumption by customers, hence why i am asking.

---

**Marc Rua Herrera** (2025-04-15 12:48):
For now is just one time use. It will not be part of any recurrent scripting.

---

**Marc Rua Herrera** (2025-04-15 12:49):
They want to some statistic, for example how often a specif component flips to a critica state in a time window

---

**Bram Schuur** (2025-04-15 12:51):
the openapi spec can be found here: (for your eyes only, please do not let customer go and integrate with this, many of these apis are internal): https://gitlab.com/stackvista/platform/stackstate-openapi/-/blob/master/spec/openapi.yaml

---

**Ben Craft** (2025-04-15 14:15):
Please would it be possible for a tenant to be created on the cloud serviceability instance for rancher saas?

Id like to utilise observability in the client clusters, which for now is only short lived staging instances, once we get a volume of customers im happy to set up observability in our management controlplane to remove the load from your cloud instance. However for now it would be greatly appreciated if I could just focus on the client side.

Thank you!

---

**Jorn Knuttila** (2025-04-15 22:20):
Just to confirm. SUSE Observability currently does *not* support ARM on either server or downstream, correct?

---

**Thiago Bertoldi** (2025-04-15 23:00):
Hey! Did anything change in registry.rancher.com (http://registry.rancher.com)?
Yesterday I was able to
`docker pull registry.rancher.com/suse-observability/sts-opentelemetry-collector (http://registry.rancher.com/suse-observability/sts-opentelemetry-collector)`
but today I had to specify the version
`docker pull registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.14 (http://registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.14)`

---

**Louis Lotter** (2025-04-16 08:39):
No but we are currently working on this

---

**Mark Bakker** (2025-04-16 08:50):
To be clear we are working on the Agent as we speak an the server is planned later this year.

---

**Remco Beckers** (2025-04-16 10:29):
Not that I know. But I also wasn't aware there was a `latest` version published for our docker images.

Maybe something changes in the rancher registry setup itself?

---

**Remco Beckers** (2025-04-16 10:33):
I just checked and we only publish specific tags

---

**Lukasz Marchewka** (2025-04-16 13:03):
@Saurabh Sadhale I have installed clickhouse to your OpenShift cluster (`ch-test` namespace) and it works correctly. I had to disable SC for clickhouse
```clickhouse:
  podSecurityContext:
    enabled: false
  containerSecurityContext:
    enabled: false```
and SC for clickhouse backup, it isn't possible to disable via values so I had to disable it manually in the helm chart. Now I'm going to add to the helm chart. Eventually I wasn't able to reproduce your problem. Can you help me to reproduce it ?

---

**Jorn Knuttila** (2025-04-16 14:22):
Thanks, gentlemen

---

**Jorn Knuttila** (2025-04-16 14:23):
Idea: This very much feels like something that should be in the requirements section of the documentation. Agreed?

---

**Nick Zhao** (2025-04-17 04:49):
Hi team, IHAC who are doing o11y POC, can we replace the trial lic key to the formal one when finished the ordering without re-deployment?  if so, how to do that?  Thanks a lot.

---

**Rajesh Kumar** (2025-04-17 05:16):
Hi @Alejandro Acevedo Osorio When can we expect the fix? which version?

---

**Alejandro Acevedo Osorio** (2025-04-17 08:55):
Hi @Rajesh Kumar there's a version being prepared that includes the fix, but I'm not completely sure about the exact date. @Bram Schuur do we have an estimate?

---

**Bram Schuur** (2025-04-17 10:13):
The fix has been (silently) released with the latest 1.0.33 rolling release, published this morning, and will be announced with the next platform release (which is expected early next week).

---

**Saurabh Sadhale** (2025-04-17 15:42):
Okay let me circle back to this on Monday if that is fine by you. I will re-create the OCP cluster and once it’s done I will share the cluster details.

---

**Zia Rehman** (2025-04-17 17:56):
Hi everyone, I am trying to set up a notification channel using Slack and have been following these steps:
1. Created an app on the Slack API using a manifest — received the *App Client ID* and *App Client Secret*.
2. Created a `values.yaml` file containing the `app_client_id` and `app_client_secret`.
3. Executed the `helm upgrade` command with all the necessary `values.yaml` files.
4. Attempted to configure the Slack notification from the Observability UI.
    ◦ When I select the Slack channel and click *Choose Workspace*, I try to sign in by entering `my-workspace-name.slack.com (http://my-workspace-name.slack.com)`.
    ◦ However, I encounter the error (Screenshot attached).  
It seems I do not have the necessary permissions to create an app within Slack.
Could you please suggest how I should proceed further?
Alternatively, if a Slack notification channel or app has already been created that I could use for demonstration purposes, that would also work.

---

**Marc Rua Herrera** (2025-04-17 19:26):
Hi,
I’m looking into a security compliance issue in a customer’s Azure environment. The issue is being raised across all the *SUSE Observability node agent pods*, which are currently configured to share the `hostprocessID` and the `hostIPCnamespace`. This setup conflicts with the customer's security policies, which state that workloads should not share these host namespaces.
I assume this configuration is essential for monitoring purposes, but I need a bit more input to give the customer a proper answer.
• Why do the SUSE Observability node agents need access to the `hostprocessID` and `hostIPCnamespace`?
• Are these required for the agent to function correctly?
• If disabled, would it impact SUSE Observability’s behavior or visibility?
• Is there an alternative that avoids sharing these host namespaces?

---

**Brian Six** (2025-04-18 00:23):
What is the approx storage needed for approx 600 downstream servers over a 2 week period?

---

**Remco Beckers** (2025-04-18 08:38):
When the license keys is about to expire (2 weeks before I believe) a dialog will be shown right after logging in where the new license key can be provided.

If you want to update the license key before that moment there is no UI for that but you can do it using the CLI using the `sts license update --key &lt;new-key&gt;` command. See our docs for how to get the CLI https://docs.stackstate.com/cli/cli-sts.

---

**Remco Beckers** (2025-04-18 08:38):
This won't require a restart

---

**Remco Beckers** (2025-04-18 08:39):
To set that up you indeed need admin access for the workspace which we don't have for the SUSE Slack.

---

**Remco Beckers** (2025-04-18 08:40):
We had that on our old stackstate Slack however which is where we developed and tested it.

The easiest way to demo it is to use one of our saas tenants which has this pre-configured. But if you need to set it up yourself I think the quickest way is to create your own Slack workspace and use that

---

**Bram Schuur** (2025-04-18 09:30):
Hey Marc, the short answer here is: we need this access to provide the experience we give today. We did an effort end last year to reduce the amount of permissions we need for the node agent, so I'm reasonably confident they are 'minimized'.

The longer answer is: we might take a fresh look at these two exact permissions, especially the hostIPCnamespace one is suspect to me, i cannot come up with a place we would need that. The hostPID i am very sure we need, however, we might investiagte whether we can gimp the agent in some way that keeps it functional (no guarantees there, connection correlation typically needs a host-wide view of network traffic, including the processes).

This is all quite a bit of work though, because we need to reevaluate the entire functioning of the agent. I can make a story for this but I cannot guarantee it will be picked up. What is the urgency here?

Side-question: is the customer using `nodeAgent.scc.enabled=true`? (are they on openshift?)

---

**Marc Rua Herrera** (2025-04-18 09:55):
Just to clarify — if I understand correctly, these permissions allow the SUSE Observability agent (running in a container) to access process IDs and IPC information from the host. This implies some level of data crossing from the container to the host, which breaks strict isolation.

That said, in most cases the data is sent to StackState, which is running in the same cluster — meaning the traffic stays within the same virtual network and environment.

Is there any argument I could use to justify that this setup is still reasonably safe? For example, can we say that because everything runs within the same isolated network boundary and doesn’t leave the cluster, the risk is limited? Any input that could help me position this in a more acceptable way from a security perspective would be appreciated.

---

**Bram Schuur** (2025-04-18 09:58):
If the platform is running in the same cluster this for sure is true (the collected traffic will travel only between agent and platform). This depends on how the platform is exposed though (i we send the traffic through an web-based ALB the traffic will actually go on the web and back into the smae cluster).

---

**Bram Schuur** (2025-04-18 10:02):
I will write the story you request. Are there other permissions the customer does not want to allow? Our process agent also runs privileged with enabled. If the really do not want our agent to see antyhing on the host that is also bad: https://kubernetes.io/docs/concepts/security/pod-security-standards/ and makes me want to have a chat about this, because our OOB functionality just requires the agent to look at host/other pods so basically 'breaching' security up to a point. I'd also not call our agent a workload but agent really, so it should be regarded an infrastructure component rather than a isolated pod doing some work

---

**Nick Zhao** (2025-04-18 11:57):
cool，thanks.  Remco :thumbs-up:

---

**Mark Bakker** (2025-04-18 12:21):
See https://docs.stackstate.com/get-started/k8s-suse-rancher-prime and then the storage section

---

**Marc Rua Herrera** (2025-04-18 14:14):
Not that I know. I believe these were raised automatically from Azure

---

**Benoît Loriot** (2025-04-18 14:24):
Hi, I work with a customer (large bank) on SO PoC. He did an internal presentation that went well.
A few questions arised, could you help me answer ?

• The http metrics are great, but how does it work? What does it do behind the curtains to get all those metrics regarding http per upstream/downstream pod (error, latency, throughput) and network throughput?
• We are concerned about the footprint. Do you have metrics regarding stress test or intense use cases to see what is the impact of collecting all this data on the observed cluster (CPU, memory and network consumption) and sending it to the observability cluster? Could it impact the applications running on the observed cluster (less network throughput, memory or CPU for them)?
• For the timeline feature, we can for example navigate through time to see the changes made on secrets and configmaps, does that mean that the observability cluster stores all versions of those file (storing secrets of observed clusters)? What exactly goes to the storage of the observability cluster and what does not?
Thanks !

---

**Bram Schuur** (2025-04-18 14:56):
The following story was filed: https://stackstate.atlassian.net/browse/STAC-22672, what customer is this for?

---

**Mark Bakker** (2025-04-18 14:59):
1. the metrics are gathered by inspecting all traffic between all processes in all pods and inspecting the calls to encryption libraries. After that the data is inside the kernel processed to get Error, Throughput and Latency out of of them. 
2. The impact on the applications is minimal &lt;3% overhead in normal cases. This is due too the fact that most is done with eBPF inside the kernel.
3. We do not store secrets, only the hash of a secret. For other files we only store the diff of each version like git also does it.

---

**Bram Schuur** (2025-04-18 15:00):
For a bit more in-depth info on eBPF (both how it works and the performance benefits) we have a blog post on the SUSE blog (hat-tip to @Mark Bakker): https://www.suse.com/c/ebpf-revolutionizing-observability-for-devops-and-sre-teams/

---

**Mark Bakker** (2025-04-18 15:08):
Hi @Shady Khattab is asking if we already know SUSE Observability works on Alibaba Cloud. I know you @Yash Tripathi are testing this. Next week I am out. Can you update @Shady Khattab if we know more?

---

**Lukasz Marchewka** (2025-04-18 15:18):
@Saurabh Sadhale I have updated doc how to install in on OpenShift: https://github.com/StackVista/stackstate-docs/pull/1606/files  can you test if it works. I have installed only ClickHouse with this changes it was ok

---

**Zia Rehman** (2025-04-18 15:26):
Thanks Remco.
Yeah, I tried creating a Slack workspace but seems it will be enabled by admin. I'll try if admin allows my workspace or else I'll use already created saas tenant.

---

**Jorn Knuttila** (2025-04-18 15:42):
I've tried something similar in the past and pretty much got a talk-to-the-hand from IT. (as it relates to Slack permissions)

---

**Remco Beckers** (2025-04-18 15:44):
Oh, I should have said: create your own slack organization (always get confused about workspace vs organization). I think you can simply do that entirely outside of the SUSE Slack account

---

**Jorn Knuttila** (2025-04-18 15:45):
yeah, make a `suse-tech-training.slack.com (http://suse-tech-training.slack.com)` or something instance on your own just so you can get those alerts/screencaps. :slightly_smiling_face:

---

**Brian Six** (2025-04-18 15:46):
Omg :-).  I looked at that page several times and missed that.   Sorry for asking about something so obvious :-).

---

**Benoît Loriot** (2025-04-18 15:50):
Thanks a lot guys !

---

**Mark Bakker** (2025-04-18 15:52):
@Brian Six no problem :slightly_smiling_face: It can happen

---

**Shaun Gardiner** (2025-04-18 15:53):
~Good day Observers,~
~Do I understand it properly SUSE Observability is now only available to customers through a support entitlement?  I know there was a period where there was a trial open to all customers but has that gone away?~

---

**Marc Rua Herrera** (2025-04-18 16:30):
This is Rabobank

---

**Yingluo Zhang** (2025-04-18 17:01):
Thank you for the  professional explanations. This has been invaluable for our technical presentations about SUSE Observability at client sites.:+1:

---

**Joel Endel** (2025-04-18 17:16):
Hi Team,

My Client is Playing around with SUSE Observability and wants to release it to their Dev teams, but they need the RBAC integration.

Is SUSE observability still on target for it's release with the Rancher RBAC integration hopefully sometime next month? Also what version of Rancher will be required, I'm assuming 2.11.

Thank you

---

**Shaun Gardiner** (2025-04-18 17:57):
I have been properly informed:
&gt; Unless something has changed, all Rancher Prime customers get SUSE Observability.

---

**Garrick Tam** (2025-04-18 18:41):
Here are the logs.

---

**Tom McGonagle** (2025-04-18 19:12):
Hello one of my customers is keen to use suse observability. They have installed the helm chart with their licesnse key from SCC but are still seeing locks in the interface. Is there any documentation on getting rid of the locks with a licensed version of suse observability?

---

**Garrick Tam** (2025-04-18 19:17):
I found previous discussion here --&gt; https://suse.slack.com/archives/C079ANFDS2C/p1735294445472839 and how to lower the retention period (https://docs.stackstate.com/self-hosted-setup/data-management/clear_stored_data).  I suggested this to customer.

---

**Alejandro Bonilla** (2025-04-18 19:19):
Is there someone that can help with a few questions around using Kafka with otel?

---

**Alejandro Bonilla** (2025-04-18 19:33):
How can we ingest metrics when an application is not running on k8s?

---

**Alejandro Bonilla** (2025-04-18 19:36):
Where are all our training resources to use, consume or customize SUSE Observability? We are about to hit a year after the Stackstate acquisition and this continues as a black box where we have little to no information, videos or content on how to help our customers.

---

**Frank van Lankvelt** (2025-04-18 19:37):
This is determined by the deployment mode, that's maybe still set to 'community'?

---

**Tom McGonagle** (2025-04-18 19:38):
How do you change the deployment mode from communitiy. Do you know of any documentation I could reference. Thank you very much

---

**Frank van Lankvelt** (2025-04-18 19:40):
SUSE observability exposes a Prometheus write endpoint, you can send any metrics to that.  And query them later using the promql api.

---

**Alejandro Bonilla** (2025-04-18 19:43):
where is that? the goal is to capture Kafka metrics, perhaps logs into observability.

---

**Alejandro Bonilla** (2025-04-18 19:43):
Where is that mentioned so I can have a look?

---

**Frank van Lankvelt** (2025-04-18 19:46):
https://docs.stackstate.com/metrics/advanced-metrics/k8s-prometheus-remote-write (https://docs.stackstate.com/metrics/advanced-metrics/k8s-prometheus-remote-write) has some info on the endpoint.  How best to scrape the Kafka metrics is probably best determined by yourself

---

**Tom McGonagle** (2025-04-18 19:48):
I searched the docs.stackstate.com (http://docs.stackstate.com) and came up dry on community setting.

---

**Frank van Lankvelt** (2025-04-18 19:56):
does the values.yaml have a key `stackstate.deployment.edition` that is set to `Community`?  Removing that should set it to the default, `Prime`.  That will also end up in the `suse-observability-server`  configmap.

---

**Alejandro Bonilla** (2025-04-18 19:56):
OK, all we need is the token and then configure the remote write in prometheus...

---

**Tom McGonagle** (2025-04-18 19:56):
Got it. Ill take alook

---

**Frank van Lankvelt** (2025-04-18 19:57):
I'm a bit puzzelled as this should be pretty much default behavior when deploying the helm chart manually

---

**Tom McGonagle** (2025-04-18 19:58):
My customer deployed SUSE Observability via the helmchart in Rancher. They did not deploy manually. Does that explain the behavior?

---

**Frank van Lankvelt** (2025-04-18 19:59):
ah, okay.  Yeah, I'm not very knowledgeable on that front I'm afraid

---

**Tom McGonagle** (2025-04-18 19:59):
Gotcha thank you

---

**IHAC** (2025-04-18 21:10):
@Garrick Tam has a question.

:customer:  Child Rescue Coalition

:facts-2: *Problem (symptom):*  
Customer has the following question/problem:
```We see our license in the SCC, however there is now way to enter it in the SaaS solution.
The agent helm chart values only point to an apiKey.
Where do we enter our license key?

Currently the Saas solution displays lots of key metrics with logs and requests that we register for Rancher Prime, which we already have.```
Does anyone know how to address above?  I try looking up SaaS in the documentation website and got Page not found --&gt; https://docs.stackstate.com/v/stackstate-saas

---

**Garrick Tam** (2025-04-18 22:28):
@Mark Bakker Disney had this feedback regarding this issue.
```I still there there should be better handling of this condition than a crash loop and an error buried in the logs. Can you open a feature request and/or bug for that?```
I suggested the following.  Can you please take it as a feature request from Disney?
```The overall product status can be more clear and possibly funnel up to a working UI.  However; I don't believe current method of implementation is a bug and don't believe our team will accept a bug report for this condition.  I will provide feedback to our engineer/product team with your concern and request a feature improvement for a better way to indicate overall deployment health.```

---

**Frank van Lankvelt** (2025-04-18 22:30):
Don't know much about it, just that auto-instrumentation does a decent job of creating producer/consumer spans.  And in SUSE Observability we connect those together to form a relation between the otel services in the topology.

---

**Garrick Tam** (2025-04-19 00:44):
I hope someone might confirm my suspicion.  While troubleshooting authentication, we had to enable debug logging following the recommendation here --&gt; https://docs.stackstate.com/self-hosted-setup/security/authentication/troubleshooting.  After we fixed the creation of custom role and was able to login with the custom role user, the UI became slow and some view don't load successfully.  Upon disabling debug logging, the loading bar is moving faster but topology continues to not load anymore.  The customer is running with an HA profile.  At this point, we addressed the authentication with custom role question but the UI became no longer useful with topology no longer loading.  I reviewed the components pod logs but didn't find any recurring exceptions.  Any quick way to restore topology view?

Can someone confirm if debug logging taxed the components to the point where maybe some of the data processing broken or cannot catchup?

Should I be fearful of employing debug logging to troubleshoot in the future?

---

**Garrick Tam** (2025-04-19 00:53):
Here's a screenshot of topology not loading.

---

**Garrick Tam** (2025-04-19 01:10):
Can someone confirm if "SUSE Cloud Observability" is the only Observability SaaS currently available?  Also, what is the licensing details for this solution? Any documentations, etc... available?

---

**Christian Frank** (2025-04-19 14:56):
Are we still on track for open-sourcing SUSE Observability?

---

**Yash Tripathi** (2025-04-21 08:11):
Sure, @Shady Khattab Currently trying to deploy suse-observability on ACK, will let you know how it goes

---

**Zia Rehman** (2025-04-21 09:31):
Ohh got it. Thanks Jorn and Remco I'll proceed with it.

---

**Saurabh Sadhale** (2025-04-21 09:56):
Hello <#C079ANFDS2C|> Is there a possibility to configure *DEFAULT* Telemetry time interval as explained below in the 5.1 documentation ?

https://docs.stackstate.com/5.1/configure/telemetry/custom_telemetry_interval

I don’t find this in 6.0 branch or SUSE Observability branch of the  documentation.  I am assuming something has changed.

---

**Shady Khattab** (2025-04-21 16:24):
Thank you so much ,looking forward

---

**Garrick Tam** (2025-04-21 20:02):
I spoke to Roberto at Child Rescue Coalition and gotten a clearer understanding of what's going on.
```Customer is accessing their POC on StackState SaaS via https://sts-16225955.app.stackstate.io and wants to get full access.  Currently, contents are blurred and states the message "Upgrade to Rancher Prime and enjoy faster troubleshooting".  See the limitations customer is trying to access in attached screenshots.  ```
@Chad McIntyre @Mike Nelson @christopher.malise @Al Kalafian Is this something the customer's account team can help with?
@Mark Bakker @Louis Lotter  Is stackstate SaaS still offer and available for this customer to fully trial and buy?

---

**Yash Tripathi** (2025-04-21 22:58):
I managed to deploy and play around with it with the following values
```zookeeper:
  persistence:
    size: 20Gi
clickhouse:
  replicaCount: 1
  persistence:
    size: 50Gi
elasticsearch:
  volumeClaimTemplate:
    resources:
      requests:
        storage: 100Gi
backup:
  configuration:
    scheduled:
      pvc:
        size: 20Gi
stackstate:
  stackpacks:
    pvc:
      size: 20Gi
  components:
    checks:
      tmpToPVC:
        volumeSize: 20Gi
    healthSync:
      tmpToPVC:
        volumeSize: 20Gi
    state:
      tmpToPVC:
        volumeSize: 20Gi
    sync:
      tmpToPVC:
        volumeSize: 20Gi
    vmagent:
      persistence:
        size: 20Gi```
did not have time for more extensive testing, but for now everything seems to be working fine
`alibaba has a 20Gi lower limit for volumes so the value overrides are important`

---

**Louis Lotter** (2025-04-22 09:03):
SaaS does not require a key. Keys are for on prem installations.

---

**Louis Lotter** (2025-04-22 09:03):
SUSE Cloud Observability is the only SaaS currently available

---

**Andreas Prins** (2025-04-22 09:21):
Yes indeed, this is a correct observation.
The customer is on the SaaS instance with particular limitations.

The customer should move to the full version, however this is on-prem for now That version is included in their subscription.

@Garrick Tam would this customer be okay with an on-prem version? of not @David Stauffer this is another customer where we can go for the full suse observability as a SaaS. I know Mark is working on a proposal however off this week. We could use CRC as a first one to try this out.

---

**Andreas Prins** (2025-04-22 09:22):
up to product to tune in.

---

**Bram Schuur** (2025-04-22 09:22):
Indeed, this feature did not carry to 6.0/7.0, due to the platform being a more out-of-the-box experience. I will write a ticket to reevaluate this choice. Got some questions to write a proper story:

What value would you like to change the default to?
Why is the current default not supporting your use-case?

---

**Saurabh Sadhale** (2025-04-22 09:26):
@Bram Schuur appreciate your update and confirmation. The customer who has raised the case would like to change it to 1 hour or 15 mins.

---

**Bram Schuur** (2025-04-22 09:27):
@Garrick Tam for sure debug logging will slow down the system, so if your issue is fixed, please proceed to remove the debug logging again. If the system remains slow, this could be due to some other changes, in that case, lets connect with a developer to see what is going on

---

**Saurabh Sadhale** (2025-04-22 09:29):
I will get back with an answer to the other question.

---

**Saurabh Sadhale** (2025-04-22 11:45):
@Bram Schuur Customer would prefer 1 hour. The default 6 hour interval is too broad with information. Customers only need most of the time the last hour or 15 minutes or so.

An additional question has popped up as well:

• Would putting a smaller interval also increase the performance in the GUI (loading times)?

---

**Bram Schuur** (2025-04-22 12:00):
Thanks for report, i filed the following ticket: https://stackstate.atlassian.net/browse/STAC-22677

---

**Saurabh Sadhale** (2025-04-22 12:00):
@Bram Schuur that is awesome. :smile:

---

**Saurabh Sadhale** (2025-04-22 12:10):
@Lukasz Marchewka appreciate your extended help on this. I will test a quick lab set-up on  ARO cluster and confirm

---

**Matt Farina** (2025-04-22 14:48):
Hello. I have a scale question. What are the current scale limit for observability? I'm looking at nodes and clusters.

---

**Bram Schuur** (2025-04-22 14:53):
Dear Matt, the current biggest instance we support is the 4000 'default nodes' instance, documented here: https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#requirements (there is also more information on how big a default node is)

---

**Garrick Tam** (2025-04-22 17:25):
Thanks for your review and feedback.  So far, Lumen has not opened a case to report the issue is continuing.  Let's hope the system was able to catch up and issue is no longer happening.

---

**Garrick Tam** (2025-04-22 17:33):
Customer does not want to stand up an on-prem Observability cluster; hence seeking to get full access to SaaS.

---

**Garrick Tam** (2025-04-22 17:49):
I spoke too soon.  Customer just open a new case reporting the symptom still exists.  The description.
```when attempting to view components (e.g clusters, pods, etc.), the observability dashboard is taking time to load and sometimes displays a "something went wrong" message.```

---

**David Stauffer** (2025-04-22 17:59):
Hi, thanks for highlighting it. Agreed, that they could be a great first customer and catalyst. @Mark Bakker is already working on it. Happy to have a meeting and discuss how to proceed with the customer.

---

**Garrick Tam** (2025-04-22 23:13):
@David Stauffer I'm confused.  Did you want to have a call with me or with the customer or with Engineering?

---

**George Yao** (2025-04-23 03:37):
Hi Team, partner requested a NFR subscription to install SUSE observability, but it prompted an error to ask enter a valid license key when login, please help to check why the registration code is not valid. Thanks.

---

**Amol Kharche** (2025-04-23 04:42):
The valid license key should be in ABCDE-ABCDE-ABCDE format.
Which license key you are using and what is the customer name? I can recheck in SCC portal.

---

**George Yao** (2025-04-23 05:06):
The partner used the registration code in the snapshot, please help to check the partner name `Beijing RayooAIOps Technology Co.Ltd`

---

**Amol Kharche** (2025-04-23 05:10):
That's not valid key and can see the same key associated with suse observability in SCC portal.
Could you please post question in <#C02AYV7UJSD|>, They will assist you to correct key.

---

**George Yao** (2025-04-23 05:15):
OK, I will. Thanks for your checking.@Amol Kharche

---

**David Stauffer** (2025-04-23 08:33):
With the customer.

---

**Louis Lotter** (2025-04-23 09:35):
Thanks Amol

---

**Vladimir Iliakov** (2025-04-23 13:22):
Hi Zia, these warnings are "normal" and should be ignored. They are caused by the 3-rd party subcharts and, unfortunatelly, not easy to fix.

---

**Amol Kharche** (2025-04-23 13:22):
https://suse.slack.com/archives/C079ANFDS2C/p1720694723817009?thread_ts=1720694195.839709&amp;cid=C079ANFDS2C

---

**Zia Rehman** (2025-04-23 13:24):
Got it, thanks @Vladimir Iliakov and @Amol Kharche.

---

**Jan Bruder** (2025-04-23 16:49):
Hi team, what are the correct steps to request a license key for a prospect performing an on-premise installation of Observability as part of a Rancher Prime Suite PoC? And what are the steps to request a trial account for Observability Cloud / Stackstate SaaS ?

---

**Marc Rua Herrera** (2025-04-23 16:56):
Hi! Can this License key still be used? *WLJWJ-5V5CF-NR1FA*

---

**Louis Lotter** (2025-04-23 17:26):
The SCC provides the keys

---

**Louis Lotter** (2025-04-23 17:27):
Trial accounts are available on aws marketplace.

---

**Louis Lotter** (2025-04-23 17:28):
https://aws.amazon.com/marketplace/pp/prodview-w36cds3q4i2hc

---

**Jan Bruder** (2025-04-23 17:28):
Assume that the prospect is not an AWS customer

---

**Louis Lotter** (2025-04-23 17:28):
The first 2 weeks or month is free I'm not sure

---

**Louis Lotter** (2025-04-23 17:28):
for Saas that's where we host it so they still need to sign up for it there

---

**Louis Lotter** (2025-04-23 17:29):
their infrastructure does not need to be on aws

---

**Jan Bruder** (2025-04-23 17:29):
You need to sign up to AWS in order to use Observability Saas ?

---

**Jan Bruder** (2025-04-23 17:29):
That sounds strange

---

**Jan Bruder** (2025-04-23 17:29):
How about this: https://www.stackstate.com/trial-sign-up/

---

**Louis Lotter** (2025-04-23 17:30):
Speak to @Mark Bakker and @Oliver Ries about that.

---

**Louis Lotter** (2025-04-23 17:31):
that trial page is not supported anymore.
We went for aws marketplace first as it comes with billing etc.
I'm sure we'll expand it but we have a lot to do.

---

**Jan Bruder** (2025-04-23 17:32):
Ah that is good information. Would it be a good idea to take this page offline then?

---

**Louis Lotter** (2025-04-23 17:33):
Yeah probably. @Andreas Prins @Genevieve Cross :point_up:

---

**Jan Bruder** (2025-04-23 17:34):
Reverting back to the question of license key for on-prem install of observability. I am assuming “license key available in SCC” means that i should create an employee license key (`internal-`) and hand that out to the prospect?

---

**Louis Lotter** (2025-04-23 17:36):
nope, we have special keys but the SCC manages that. Best ask in <#C02AYV7UJSD|>
Or maybe @Amol Kharche can give you pointers. Apologies that part of things is opaque to me.

---

**Louis Lotter** (2025-04-23 17:36):
ever prime customer has been issued a key

---

**Louis Lotter** (2025-04-23 17:36):
but the SCC hands them out

---

**Jan Bruder** (2025-04-23 17:36):
No worries, i will try to find that info in <#C02AYV7UJSD|>. AFAIK there are no trial accounts for Rancher Prime in SCC.

---

**Jan Bruder** (2025-04-23 17:39):
For future reference: https://suse.slack.com/archives/C02AYV7UJSD/p1745422751972669

---

**Jan Bruder** (2025-04-23 17:57):
Sorry to bother you again @Louis Lotter but i have been told specifically that you are able to generate and provide a license key for an on-premise evaluation of Observability. Is that still the case?

---

**Louis Lotter** (2025-04-23 17:57):
yeah. But I've generally been told not do that for Prime customers

---

**Louis Lotter** (2025-04-23 17:57):
am I misunderstanding something here ?

---

**Jan Bruder** (2025-04-23 17:58):
Well they are not a Prime customer. They are a Prime *prospect*

---

**Jan Bruder** (2025-04-23 17:58):
So i guess whatever you were told doesnt apply here :grin:

---

**Louis Lotter** (2025-04-23 17:58):
ok missed that detail apologies

---

**Louis Lotter** (2025-04-23 17:58):
ok when should the key expire ?

---

**Jan Bruder** (2025-04-23 17:58):
I guess 3 months from now would be fair

---

**Louis Lotter** (2025-04-23 17:59):
1 August expiry ok ?

---

**Louis Lotter** (2025-04-23 17:59):
can only be the 1st of a month

---

**Jan Bruder** (2025-04-23 17:59):
Sounds great

---

**Garrick Tam** (2025-04-23 19:48):
Got it.  I will check your calendar and coordinate the call.  Who else should be invited to this call with the customer?  I will hand the customer off to you and close the support case as this is not post-sales support.

---

**Marc Rua Herrera** (2025-04-24 10:18):
It says is expired

---

**Louis Parkin** (2025-04-24 10:19):
@Louis Lotter help a Herrera out

---

**Louis Lotter** (2025-04-24 10:42):
@Marc Rua Herrera what do you need a key for ?

---

**Marc Rua Herrera** (2025-04-24 10:43):
Is not for me actually. I got questions from other consultants that want to test some stuff.

---

**Louis Lotter** (2025-04-24 10:43):
for internal use we have one pinned in this channel

---

**Martin Piala** (2025-04-24 10:50):
@Thomas Muntaner @Davide Rutigliano FYI

---

**Thomas Muntaner** (2025-04-24 10:50):
@Martin Piala we're currently using our own license

---

**Marc Rua Herrera** (2025-04-24 10:50):
Thanks Louis!

---

**Zia Rehman** (2025-04-24 13:08):
Hi All, while performing backup and restore, I have downloaded all the backup-scripts and while executing list command for configuration backup I can see there are multiple *.sty backups.
```./list-configuration-backups.sh 
job.batch/configuration-list-backups-20250424t045416 created
=== Waiting for pod to start...
=== Listing StackGraph backups in local persistent volume...
sts-backup-20250421-0400.sty
sts-backup-20250422-0400.sty
sts-backup-20250423-0400.sty
sts-backup-20250423-1422.sty
===
=== Listing settings backups in storage bucket "sts-configuration-backup"...
sts-backup-20250423-1422.sty
===
=== Cleaning up job configuration-list-backups-20250424t045416
job.batch "configuration-list-backups-20250424t045416" deleted```
But while I try to execute the backup-configuration-now script it gives me error:
```./backup-configuration-now.sh 
error: from must be an existing cronjob: no kind "CronJob" is registered for version "batch/v1" in scheme "k8s.io/kubectl/pkg/scheme/scheme.go:28"```
This script do not execute, how can I run this script or the configuration backup is will be done automatically only by the cron job at 4:00 am only.

---

**Vladimir Iliakov** (2025-04-24 13:11):
Hi Zia, can you run this script with tracing enabled?
```bash -x ./backup-configuration-now.sh ```

---

**Zia Rehman** (2025-04-24 13:20):
I would like to demonstrate the *upgrade process for SUSE Observability from one version to another*. Currently, when we run the `helm upgrade --install` command using all the necessary `values.yaml` files, it installs the *latest available version* of SUSE Observability by default.
On the *UI*, the deployed version appears as *v2.3.1*. However, in the *official documentation*, after StackState v6.0, the listed versions for SUSE Observability start from *v1.0*, which creates some confusion regarding the versioning scheme.
Could you please clarify the current versioning for SUSE Observability? Additionally, how can we *demonstrate an actual upgrade*—for example, upgrading from v2.2 to v2.3.1—instead of directly installing the latest version?

---

**Vladimir Iliakov** (2025-04-24 13:29):
That doesn't make any sense :smile:

---

**Vladimir Iliakov** (2025-04-24 13:30):
What does `kubectl version` return?

---

**Zia Rehman** (2025-04-24 13:31):
```kubectl version
Client Version: version.Info (http://version.Info){Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:28:09Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info (http://version.Info){Major:"1", Minor:"30", GitVersion:"v1.30.3+rke2r1", GitCommit:"6fc0a69044f1ac4c13841ec4391224a2df241460", GitTreeState:"clean", BuildDate:"2024-07-17T22:00:38Z", GoVersion:"go1.22.5 X:boringcrypto", Compiler:"gc", Platform:"linux/amd64"}```

---

**Bram Schuur** (2025-04-24 13:31):
helm allows for specifying a specific version through the `--version` flag, you could use this to show the upgrade.

I can see why the versioning is confusing, @Louis Lotter can you put discussing clarifying the version on the engineering meeting topic list?

---

**Vladimir Iliakov** (2025-04-24 13:32):
It is very old client version

---

**Zia Rehman** (2025-04-24 13:33):
Ohh, let me try updating kubectl then.

---

**Vladimir Iliakov** (2025-04-24 13:34):
Ideally kubectl version matches the K8s server version, 1.30 in your case. Or as recommended
```kubectl
kubectl is supported within one minor version (older or newer) of kube-apiserver.```

---

**Vladimir Iliakov** (2025-04-24 13:34):
But 1.20 is really old one.

---

**Zia Rehman** (2025-04-24 13:35):
Got it, thanks. I'll update it.

---

**Zia Rehman** (2025-04-24 15:44):
Hi @Bram Schuur @Louis Lotter Please add me in the meeting also.

---

**Louis Lotter** (2025-04-24 15:56):
Hi Zia this is an internal meeting but if we need to discuss this before or after this we can do that.

---

**Joel Endel** (2025-04-24 17:59):
Hi Team,

My Client is Playing around with SUSE Observability and wants to release it to their Dev teams, but they need the RBAC integration.

Is SUSE observability still on target for it's release with the Rancher RBAC integration hopefully sometime next month? Also what version of Rancher will be required, I'm assuming 2.11.

Thank you

---

**Daniel Barra** (2025-04-24 19:57):
*We are pleased to announce the release of 2.3.2, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.2).*

---

**Alejandro Bonilla** (2025-04-24 21:22):
Should the SCC key work for o11s? Or is that not yet working?

---

**Frank van Lankvelt** (2025-04-24 21:37):
The rancher/SO integration is coming along and is one of our top priorities.  It may be good to realize that SO does not have access to application data.  For troubleshooting it generally helps to have a system-level view on topology and be able to dive into metrics.  Imposing strict RBAC will make it harder to diagnose cross-team issues.
So while there can be good reasons to implement RBAC, maybe for now it is also important to realise the drawbacks.

---

**Frank van Lankvelt** (2025-04-24 21:38):
What is o11s?

---

**Alejandro Bonilla** (2025-04-24 23:21):
Observability- I guess it was o11y

---

**Alejandro Bonilla** (2025-04-25 00:49):
@Mark Bakker can we confirm that aarch64 for the server is not supported? I had asked before and was told the bits should all be built for ARM on the server but the agent wouldn’t because of ebpf and some other requirements.
A customer that is expected to grow has acquired the servers already and needs it supported.

---

**Louis Lotter** (2025-04-25 08:22):
@Louis Parkin can you answer here. Mark is still off.

---

**Frank van Lankvelt** (2025-04-25 08:55):
we're indeed first focusing on the agent, making sure that can run on ARM.  The platform/server comes after that.  While most of it is architecture independent (JVM based), some storage technologies are compiled (e.g. clickhouse is C++).

---

**Louis Parkin** (2025-04-25 08:56):
Good morning, I can confirm that the platform does not have full official ARM support, and ARM support for the agent is currently in progress.

---

**Louis Parkin** (2025-04-25 08:57):
I am also about 60% sure that work to achieve ARM support for the platform was slated to be done in the second half of this year.

---

**Lukasz Marchewka** (2025-04-25 11:19):
@Saurabh Sadhale had you opportunity to test it ?

---

**Saurabh Sadhale** (2025-04-25 11:31):
@Lukasz Marchewka yes I did test the part where I can install clickhouse and it worked without issues. However, unable to deploy complete trial version also on ARO due to constraint issues.

---

**George Yao** (2025-04-25 11:35):
Hi team, Rancher UI shows the status of suse-observability helm release is failed, but all the workload in suse-observability namespace is `running` , could you help to see how to debug this.

---

**Vladimir Iliakov** (2025-04-25 11:42):
You can run `helm ls -n &lt;namespace&gt;` to confirm that it was Helm deployment issue, but I am not sure how to get more details. If Rancher stores somewhere logs for the Helm commands it might give a clue...

---

**Vladimir Iliakov** (2025-04-25 11:45):
maybe `helm status suse-observability` ???

---

**George Yao** (2025-04-25 13:29):
helm status suse-observability didn't give any clue..., let me check with Rancher team.Thanks in advance.

---

**Vladimir Iliakov** (2025-04-25 13:43):
If possible you may trigger the re-deployment from Rancher UI, and check the events in the Suse observability namespace with `kubectl get events -n suse-observability`
Also it might be one of the Helm pre-hooks jobs failed to schedule a pod, so it can be checked with `kubectl get jobs -n suse-observability`

but the Helm logs will say for sure what was the deployment issue...

---

**George Yao** (2025-04-25 15:16):
Hi Mark, May I ask if the multi-tenant function would be implemented and released in this year, or do we have a release plan for it as customer mentioned they need this function couple of times.

---

**Joel Endel** (2025-04-25 18:36):
Thank you frank. My customer went to susecon and saw that RBAC was going to be included in suse observability. This is still the case correct? Do we have any timeline at all I can give them?

---

**Yingluo Zhang** (2025-04-28 05:39):
Hello SUSE observability experts,
We are currently preparing a demo for a SUSE AI marketing event. Could you please let us know when the `SUSE Observability for AI`  is expected to be released? If it is not yet available, is there an internal version that we could use for deployment?
Thank you very much.

---

**Louis Lotter** (2025-04-28 09:40):
The SCC manages keys for Suse Observability yes. They should have one for every Prime customer.

---

**Louis Lotter** (2025-04-28 09:42):
It's coming along well but it's also dependant on the new OIDC feature in Rancher being released. For timelines you have to check with @Mark Bakker and or @Oliver Ries . Mark is on holiday though.

---

**Jorn Knuttila** (2025-04-28 14:16):
I seem to recall @Ronald Nunan saying not until some time into May, if memory serves me correctly.

---

**Erico Mendonca** (2025-04-28 19:46):
I see that the Geeko Insurance demo cluster is not appearing on the Observability instance on the VPN... did something happen?

---

**Gabriel Lins** (2025-04-28 19:48):
I got the same behavior in here. Can't find the insurance example cluster and its namespace..

---

**Mark Abrams 518.421.1504** (2025-04-28 21:51):
Docs indicate that the SUSE Observability agent V3 is deployed as a daemonset on every node and
&gt; Host information is retrieved from the Kubernetes or OpenShift API.
If the cluster is from a managed provider EKS, AKS, etc. can we assume that host information is not retrieved in these cases?

---

**Thiago Bertoldi** (2025-04-28 22:32):
@Yingluo Zhang we currently have this user guide on how to install the extension with a helm chart
https://confluence.suse.com/display/AAI/SUSE+AI+Observability+Extension+-+User+Guide
the chart is available here, but will soon be on AppCo as well:
https://build.suse.de/package/show/SUSE:SLE-15-SP6:Update:Products:AI/suse-ai-observability-extension-chart

---

**Erico Mendonca** (2025-04-28 23:41):
From a partner trying to update to Observability 2.3.2 from the Rancher UI. The components suse-observability-receiver, correlate, e2es and server are forever in Updating status until the Helm chart times out. I noticed that the kafka pods appear to be working without errors until they're killed. There is a job that always appear to crash (topic-create). Have you guys seen this?

---

**Amol Kharche** (2025-04-29 04:50):
The error screenshot does not provide a clear picture of what is wrong with the setup.
Could you please share complete support bundle (https://docs.stackstate.com/self-hosted-setup/install-stackstate/troubleshooting/support-package-logs) logs.

---

**Amol Kharche** (2025-04-29 05:24):
&gt; Host information is retrieved from the Kubernetes or OpenShift API.
This applies regardless of whether the cluster is self-managed or a managed Kubernetes service like EKS, AKS, or GKE. The agent will still query the Kubernetes API for node information. By the way The Kubernetes API server is fully managed by EKS, AKS ,GKE, etc*.*

---

**Amol Kharche** (2025-04-29 05:25):
Here are the screenshots of the nodes from my AKS cluster:point_up_2:.

---

**andy.wu** (2025-04-29 07:18):
Hi Team,We have a customer who wants to know what will happen if the `STS_NETWORK_TRACING_ENABLED` environment variable in the node-agent pod is changed to `false`?
Or do we have any documentation on what these environmental variables do?

---

**Hugo de Vries** (2025-04-29 08:43):
I believe that’s related to: https://docs.stackstate.com/agent/k8sts-agent-request-tracing (https://docs.stackstate.com/agent/k8sts-agent-request-tracing)

---

**Bram Schuur** (2025-04-29 08:56):
This feature flag governs whether we do network observations at all (not just http request tracing, but also our tcpv4 connection correlation). This is not a public feature flag. @andy.wu Could you detail what the customer is looking for? Are they worried about security? Do they want certain features enabled/disabled?

---

**Louis Lotter** (2025-04-29 08:56):
@Vladimir Iliakov do you know who takes care of this instance. I don't remember anything about this instance.

---

**andy.wu** (2025-04-29 09:00):
Thank you for the quick reply.
Because the customer encountered the following error during installation, they have understood that this is a problem caused by a low kernel version.
```2025-04-22 03:45:33 CRITICAL (main_common.go:207) - Error creating collector: failed to intialize check connections:
network tracer unsupported by OS: error checking for ebpf helper FnMapLookupElem support: detect support for FnMapLookupElem for program type Kprobe:
detect support for Kprobe: load program: operation not permitted. Set the environment STS_NETWORK_TRACING_ENABLED to false to disable network connections reporting```

---

**Bram Schuur** (2025-04-29 09:01):
This issue has been solved in the latest version of our agent, `1.0.33`

---

**Vladimir Iliakov** (2025-04-29 09:04):
We manage the tenant, but not the Geeko Insurance demo cluster.

---

**andy.wu** (2025-04-29 09:05):
Got it,thanks.

---

**Vladimir Iliakov** (2025-04-29 09:05):
First thing to check its status in the Stackpacks page. If it is "Orange", then the tenant is not receiving data from the agent, so the agent logs have to be checked for any issues.

---

**Louis Lotter** (2025-04-29 09:21):
We had a version change when we went from Stackstate -&gt; Suse Observability.
It's seen as a new product.

---

**Louis Lotter** (2025-04-29 09:22):
@Mark Bakker can maybe discuss this with you in more detail when he is back.

---

**Louis Lotter** (2025-04-29 09:23):
Can you explain more what you mean with "*demonstrate an actual upgrade*—for example, upgrading from v2.2 to v2.3.1—instead of directly installing the latest version?"

---

**Zia Rehman** (2025-04-29 10:32):
Hi @Louis Lotter it is resolved now. While installing Suse Observability I used `v2.3.0` and then upgraded to `v2.3.2` using `--version`. I will be demonstrating it in the elearning course that I am creating.

---

**andy.wu** (2025-04-29 10:59):
Hi @Bram Schuur I'd like to ask if fixing this problem means that the os kernel can support this parameter to be configured as true even if it's lower than 5.15 without reporting error?

---

**Mark Bakker** (2025-04-29 11:07):
This is planned to be released with or soon after Rancher 2.12

---

**Mark Bakker** (2025-04-29 11:09):
@Garrick Tam please include me in the call

---

**Bram Schuur** (2025-04-29 11:54):
yes, we support any 5.x kernel, with the parameter enabled

---

**Erico Mendonca** (2025-04-29 13:44):
Here you go.

---

**Vladimir Iliakov** (2025-04-29 14:50):
It looks like Kafka is trying to recover the data from the snapshots, after probably forced restart or kill, but can't succeed due to livenessProbe time limitation.

---

**Vladimir Iliakov** (2025-04-29 14:55):
@Erico Mendonca I am afraid the manual steps are required to fix Kafka and the whole deployment.
Can you try to remove livenessProbe from the Kafka statefulset?

You can do it with `kubectl edit`

`kubectl edit -n suse-observability sts suse-observability-kafka`
Find and delete the following section
```        livenessProbe:
          failureThreshold: 3
          initialDelaySeconds: 240
          periodSeconds: 10
          successThreshold: 1
          tcpSocket:
            port: kafka-client
          timeoutSeconds: 5```
It will restart Kafka pod without livenessProbe and make it possible for Kafka to finish the recovery process.

---

**Erico Mendonca** (2025-04-29 14:58):
Will try it right away.

---

**Thomas Muntaner** (2025-04-29 15:02):
we're running into the same problem with SUSE Observability (storage backed by netapp nfs).

it takes around 40 minutes to recover

---

**Vladimir Iliakov** (2025-04-29 15:04):
And as Amol mentioned we don't recommend NFS for the persistent volumes, though it is the first time I see something happened with Kafka, usually it is Stackgraph.
Unfortunatelly we weren't and aren't able to efficiently troubleshot databases running on the NFS persistent volumes.

---

**Thomas Muntaner** (2025-04-29 15:05):
our Kafka seems to go down once every few days and takes a while to recover

---

**Thomas Muntaner** (2025-04-29 15:05):
but we'll look into another storage

---

**Mark Abrams 518.421.1504** (2025-04-29 15:06):
Good to know. Thank you.

---

**Thomas Muntaner** (2025-04-29 15:17):
@Vladimir Iliakov would iSCSI be fine? If so I'll work with my colleague to set it up on the netapp

---

**Vladimir Iliakov** (2025-04-29 15:22):
I can't say for sure. All our instances Saas and internal are backed up by the AWS EBS (block storage) and in the past it was also GCP block storage, there haven't been such issues.

But there is still a question, what is happened in the first place? Was the Kafka pod killed without properly saving all disk transactions or it was a storage issue?

---

**Thomas Muntaner** (2025-04-29 15:25):
I haven't fully investigated on my end, but it may have happened around when we were deploying changes to the cluster

---

**Thomas Muntaner** (2025-04-29 15:25):
if I find more info, I'll let you know

---

**Vladimir Iliakov** (2025-04-29 15:25):
That would be great :thumbs-up:

---

**Vladimir Iliakov** (2025-04-29 15:26):
Please collect the logs of the Kafka pod before and after redeployment.

---

**Thomas Muntaner** (2025-04-29 15:27):
I'll check SUSE Observability when it's back up :)

---

**Erico Mendonca** (2025-04-29 15:28):
FYI, I removed the section Vladimir mentioned, and it recovered successfully.

---

**Vladimir Iliakov** (2025-04-29 15:29):
@Erico Mendonca you mean the whole Suse Observability tenant is running and available, right?

---

**Erico Mendonca** (2025-04-29 15:30):
Should I recommend them to reinstall with a different storage? It's a demo cluster, but if you need to test anything else related to this issue, we can use it.

---

**Vladimir Iliakov** (2025-04-29 15:30):
Ok, glad to hear that. Now please redeploy it again to restore Kafka livenessProbe

---

**Vladimir Iliakov** (2025-04-29 15:32):
&gt; Should I recommend them to reinstall with a different storage?
The block storage in AWS,GCP, Azure is ideal. If available of course.

---

**Gabriel Lins** (2025-04-29 20:02):
Hello! A customer needs to implement permissions and limitations in SUSE Observability. RBAC integration is already ready to use?
Following this documentation https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_roles  wasn't possible to add a user to role `development-troubleshooter`
We couldn't even understand how to grant roles to a user or add a user to a group with pre-defined permissions

---

**Louis Lotter** (2025-04-30 09:20):
@Gabriel Lins The RBAC integration is still a work in progress. Top priority but its a large feature that is taking some time. The document you are linking to is the current older implementation of roles that we were using in Stackstate.

---

**Thomas Muntaner** (2025-04-30 16:06):
Hi @Vladimir Iliakov,

Through the logs I was able to access, nothing stood out, but then I think I found the root cause: `terminationGracePeriodSeconds`.

The default is 30 seconds, and it may be that our cluster with NFS needed more than that. As an attempt to verify this, I set it to 300, and it was able to do new deploys, which it failed at before.

---

**Thomas Muntaner** (2025-04-30 16:07):
I think everything was normal, and that k8s killed pods (for normal reasons), and we didn't give it enough time to shut down.

---

**Anthony Tortola** (2025-04-30 17:45):
Hello,  I am trying to install the otel collector on one of my lab clusters and I am seeing the following error: Warning Failed   5m50s (x4 over 7m19s) kubelet      Failed to pull image "otel/opentelemetry-collector-k8s:0.123.1": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/otel/opentelemetry-collector-k8s:0.123.1 (http://docker.io/otel/opentelemetry-collector-k8s:0.123.1)": failed to resolve reference "docker.io/otel/opentelemetry-collector-k8s:0.123.1 (http://docker.io/otel/opentelemetry-collector-k8s:0.123.1)": docker.io/otel/opentelemetry-collector-k8s:0.123.1 (http://docker.io/otel/opentelemetry-collector-k8s:0.123.1): not found. Any help would be great

---

**Mauricio Alves da Silva Perez** (2025-04-30 20:30):
@Louis Lotter, is the old RBAC implementation still working? We have a customer trying to configure some roles, but it is not working; the users are not getting the permissions.

---

**Remco Beckers** (2025-05-01 08:17):
It looks like they never published the docker image for version `0.123.1`. Instead you can try `0.123.0`

---

**Louis Lotter** (2025-05-01 08:25):
we will need more information about what they did and what is going wrong here.

---

**Anthony Tortola** (2025-05-01 15:06):
Thanks Remco,  I id make the change, I get a new error: error decoding 'receivers': unknown type: "nop" for id: "nop" (valid values: [filelog fluentforward journald k8s_cluster otelarrow receiver_creator hostmetrics jaeger k8s_events k8sobjects prometheus httpcheck kubeletstats otlp opencensus zipkin])

---

**Remco Beckers** (2025-05-01 15:09):
That looks like a change, that we made in the config after testing it, didn't make it into the final docs update. Sorry about that. Let me check what the correct config is.

---

**Remco Beckers** (2025-05-01 15:18):
The `nop` receiver is not needed and should be removed from the `receivers` section. Then the `logs` pipeline that uses it should be updated to this:

```      logs:
        receivers: [otlp]
        processors: []
        exporters: [nop]```

---

**Remco Beckers** (2025-05-01 15:18):
This makes sure that any SDK sending logs will not fail but will just ignore the logs (because we don't support that yet)

---

**Remco Beckers** (2025-05-01 15:19):
For the exact change you can also look at the diff of my docs PR that I now created: https://github.com/StackVista/stackstate-docs/pull/1612/files

---

**Anthony Tortola** (2025-05-01 15:20):
Let me that a look

---

**Mark Abrams 518.421.1504** (2025-05-01 21:23):
Is there a list of what out-of-the-box monitors are available to stack state users? It would be nice to talk about some of the quick hits with prospects if there is something of significant value here.

---

**Ravan Naidoo** (2025-05-02 07:59):
A list of monitors can be seen in the product (https://play.stackstate.com/#/monitors?detachedFilters=namespace%3Asock-shop%2Ccluster-name%3Ademo-playground.demo.stackstate.io&amp;timeRange=LAST_3_HOURS&amp;timestamp=1746159300000) (monitors menu option).  The first image has about 40 out of box monitors

SUSE Observability can also be extended with custom monitors.  Image 2 is an example of about another 60 monitors that the team uses to observe SISE Observability itself .

---

**aki.liu** (2025-05-02 15:56):
Hi Team,

My customer is asking how to check host level like journalctl , systemd logs and disk mount point utilization using SUSE Observability with RKE2 cluster.

Could you please advise SUSE Observability how to accessing host level logs and how to customize dashboard to check the OS disk mount point utilization metrics?

Any advice would be greatly appreciated.

---

**Mauricio Alves da Silva Perez** (2025-05-02 16:34):
Louis, the customer's user database is in a Microsoft AD, but uses the Google OIDC provider.

To better understand the process, they are trying to create a custom role following the example in the documentation (https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_roles#custom-roles-with-custom-scopes-and-permissions-via-the-configuration-file).

After creating the role, we tried to add a user to the role `development-troubleshooter` custom role, but it's not working.
If we add the user to one of the predefined roles, it works.


Below is an example of what we tried.

```YAML
stackstate:
  apiKey:
    key:
  authentication:
    adminPassword:
    oidc:
      clientId: 22cc95ef-9d1b-4d32-aa25-420f9f0924f0
      customParameters:
        access_type: offline
      discoveryUri: https://idp.mpf.mp.br/nidp/oauth/nam/.well-known/openid-configuration
      jwsAlgorithm: RS256
      jwtClaims:
        groupsField: department
        usernameField: email
      scope:
      - openid
      - email
      - profile
      secret:
    roles:
      custom:
        development-troubleshooter:
          systemPermissions:
          - access-cli
          - create-views
          - execute-component-actions
          - export-settings
          - manage-monitors
          - manage-notifications
          - manage-stackpacks
          - manage-star-view
          - perform-custom-query
          - read-agents
          - read-metrics
          - read-permissions
          - read-settings
          - read-system-notifications
          - read-telemetry-streams
          - read-traces
          - run-monitors
          - update-visualization
          - view-metric-bindings
          - view-monitors
          - view-notifications
          viewPermissions:
          - access-view
          - save-view
          - delete-view
      admin:
      - <mailto:uilsonvasconcelos@mpf.mp.br|uilsonvasconcelos@mpf.mp.br>
      development-troubleshooter:
      - <mailto:arsiclaro@mpf.mp.br|arsiclaro@mpf.mp.br>```

---

**Anthony Tortola** (2025-05-02 16:36):
Sorry, I forgot to update.  After making the changes above I was able to load open-telemetry

---

**Remco Beckers** (2025-05-02 16:36):
Nice. Thanks for the update

---

**Anthony Tortola** (2025-05-02 16:38):
I do have one suggestion for the documentation, where we have &lt;otlp-suse-observability-endpoint&gt; change it to &lt;otlp-suse-observability-endpoint:port&gt;

---

**Anthony Tortola** (2025-05-02 16:38):
maybe give an example too

---

**Remco Beckers** (2025-05-02 16:41):
Thanks. We are making another small update soon and I'll make sure to include that

---

**Mark Abrams 518.421.1504** (2025-05-02 20:56):
Cool. Many of the 40 oob are fairly obvious what they are for but some like "span duration for pods" may need more explanation as I suspect there is some kind of default range defined. Are these documented or is this list equivalent to "the documentation".

---

**Mark Abrams 518.421.1504** (2025-05-02 20:57):
Mostly, I think it is enough to work with for discussion with prospects outside of a more detailed demo or docs

---

**Ravan Naidoo** (2025-05-03 13:16):
https://docs.stackstate.com/monitors-and-alerts/kubernetes-monitors#pod-span-duration

---

**Lasith Haturusinha** (2025-05-06 04:29):
Hi team,
Does SUSE Observability support OTEL Logs? and can a customer use OTEL directly to register the client than using an agent ( I believe this is yes but want to clarify/confirm)?
Thanks

---

**Remco Beckers** (2025-05-06 08:22):
OTEL Logs are not supported, but are on the roadmap. Do you have a customer name related to the question? We track these feature requests

---

**Remco Beckers** (2025-05-06 08:23):
I'm not exactly sure what you mean with "register the client", but you can use OTEL without installing our agent.

---

**Bram Schuur** (2025-05-06 09:05):
Dear Aki,
We do not support host-level logs right now, only pod logs. Host logs are on the roadmap, but quite far in the future.

For custom metrics on disck I/O, you can use the following documentation to bring in custom metrics and custom metrics charts
• https://docs.stackstate.com/metrics/advanced-metrics/k8s-prometheus-remote-write
• https://docs.stackstate.com/metrics/custom-charts/k8s-add-charts

---

**Louis Lotter** (2025-05-06 09:18):
@Bram Schuur can you take a look here ?

---

**Lasith Haturusinha** (2025-05-06 11:06):
Thanks @Remco Beckers for the answers. Yes the customer is Jemena (Australia)

---

**Bram Schuur** (2025-05-06 13:20):
@Mauricio Alves da Silva Perez could you share the contents of the configmap with the name: `&lt;release_name&gt;-suse-observability-&lt;api|server&gt;` (The name depends on the deployment type chosen, it should be either api or server).

---

**Mauricio Alves da Silva Perez** (2025-05-06 15:10):
Hi, Louis and Bram. Thank you so much for your help. I asked the customer for the ConfigMap. As soon as he sends it, I will post it here.

---

**Gustavo Varela** (2025-05-06 16:09):
is observavility still closed source ?

---

**Amol Kharche** (2025-05-06 16:22):
This might help here.
https://suse.slack.com/archives/C079ANFDS2C/p1744122762239529?thread_ts=1744122762.239529&amp;cid=C079ANFDS2C (https://suse.slack.com/archives/C079ANFDS2C/p1744122762239529?thread_ts=1744122762.239529&amp;cid=C079ANFDS2C)

---

**Thiago Bertoldi** (2025-05-06 20:55):
Is there a way to retrieve the STS_API_TOKEN for the CLI without using the web interface?
*Context*: an automated installation script deploys SUSE Observability and then later uses the CLI to manage stackpacks.
If there's another authentication method for the CLI or any viable workaround, I'd appreciate the details.

---

**Jeroen van Erp** (2025-05-06 21:19):
You can setup a bootstrap service token

---

**Jeroen van Erp** (2025-05-06 21:20):
https://docs.stackstate.com/self-hosted-setup/security/authentication/service_tokens#set-up-a-bootstrap-service-token

---

**Thiago Bertoldi** (2025-05-06 21:21):
Perfect! Thanks Jeroen

---

**Jeroen van Erp** (2025-05-06 21:21):
you’re welcome

---

**Mauricio Alves da Silva Perez** (2025-05-06 21:40):
Hi, @Bram Schuur, the customer just sent the ConfigMap.

---

**Bram Schuur** (2025-05-07 11:44):
@Mauricio Alves da Silva Perez could you try giving the 'development-troubleshooter' the same rights as the admin? Could be an essential permission is needed there:

---

**Bram Schuur** (2025-05-07 11:44):
```"systemPermissions": [
            "access-cli",
            "access-explore",
            "access-log-data",
            "access-synchronization-data",
            "access-topic-data",
            "create-views",
            "execute-component-actions",
            "execute-component-templates",
            "execute-node-sync",
            "execute-restricted-scripts",
            "export-settings",
            "import-settings",
            "manage-annotations",
            "manage-ingestion-api-keys",
            "manage-metric-bindings",
            "manage-monitors",
            "manage-notifications",
            "manage-service-tokens",
            "manage-stackpacks",
            "manage-star-view",
            "manage-telemetry-streams",
            "manage-topology-elements",
            "perform-custom-query",
            "read-metrics",
            "read-permissions",
            "read-settings",
            "read-stackpacks",
            "read-telemetry-streams",
            "read-traces",
            "run-monitors",
            "update-permissions",
            "update-settings",
            "update-visualization",
            "upload-stackpacks",
            "view-metric-bindings",
            "view-monitors",
            "view-notifications",
            "read-agents",
            "read-system-notifications",
            "create-dashboards",
            "view-dashboards",
            "update-dashboards",
            "delete-dashboards",
            "create-favorite-dashboards",
            "delete-favorite-dashboards",
            # "unlock-node" We disable unlock node by default because we do not encourage unlocking stackpack-provided settings
            # (rather update the settings). In dire straits this config part can be patched to allow the unlocking.
        ],
        "viewPermissions" : [ "access-view", "save-view", "delete-view" ]```

---

**Bram Schuur** (2025-05-07 15:50):
This is obsolete functionality and can be ignored, i will write a story to remove it.

---

**Cameron Seader** (2025-05-07 18:21):
What is our appetite for this conference?
https://events.linuxfoundation.org/open-observability-summit-otel-community-day/

---

**Warner Chen** (2025-05-08 10:10):
Hello Team, Does SUSE Observability support directly scraping metrics defined by existing ServiceMonitors? We understand that data is typically sent to the SUSE Observability Server via OpenMetrics annotations or Prometheus remote write, but the customer is hoping to reuse their existing ServiceMonitor definitions to simplify the migration process as much as possible.

---

**Jeroen van Erp** (2025-05-08 10:25):
I don’t think so, but maybe @Bram Schuur or @Remco Beckers has an idea… Otherwise it’s a great feature request

---

**Nick Zhao** (2025-05-08 10:48):
Hi team, IHAC (Swire coca-cola) are using o11y.  They have an issue about the EFS monitoring.  Do we only support to monitor the EBS but EFS?  Or  it needs any configurations further?

---

**Remco Beckers** (2025-05-08 11:50):
With the Open Telemetry operator this is possible. It has a target allocator that reads the existing ServiceMonitors to configure the Prometheus scraping in the collector(s). The collectors send the data to SUSE Observability.

We have documentation (https://docs.stackstate.com/open-telemetry/getting-started/getting-started-k8s-operator) on how to configure the operator, but only for the purpose of auto-instrumentation. The setup for ServiceMonitor support is slightly different:
• The collector needs to be setup using the statefulset (or daemonset) mode instead of the deployment mode used in the docs
• You can skip the instrumentation section in that documentation
• Instead you'll need to follow the operator documentation in its Github repo to enable the target allocator and prometheus receiver for the collector, configure it and assign it the proper RBAC permissions: https://github.com/open-telemetry/opentelemetry-operator/blob/main/cmd/otel-allocator/README.md#target-allocator
We haven't fully tested this setup, that's also why it is not in the docs (yet).

---

**Bram Schuur** (2025-05-08 11:56):
Dear niick, thanks for reporting! I filed a ticket: https://stackstate.atlassian.net/browse/STAC-22748

---

**Warner Chen** (2025-05-08 12:01):
Thanks @Remco Beckers, I will do a test. It would be great if this part could be included in the documentation in the future.:smile:

---

**Remco Beckers** (2025-05-08 12:03):
It's on the list.

---

**Davide Rutigliano** (2025-05-08 16:06):
Hello team, I can't find anything in the docs about setting up notifications throught CLI / other options. Is https://docs.stackstate.com/monitors-and-alerts/notifications/configure the only way to configure notifications?

---

**Bram Schuur** (2025-05-08 16:16):
I think the UI is the only official way now to make notifications (@Remco Beckers correct me if i am wrong). @Davide Rutigliano what is your use-case for wanting a cli or something else?

---

**Davide Rutigliano** (2025-05-08 16:23):
We are migrating OpenPlatform observability to SUSE Observability and we are trying to use notifications to replace alertmanager. As we have our current alertmanager configuration in helm I was looking for something more aligned with our IaC setup

---

**Bram Schuur** (2025-05-08 16:40):
thanks @Davide Rutigliano i filed a ticket for this: https://stackstate.atlassian.net/browse/STAC-22755

---

**Thomas Muntaner** (2025-05-08 16:48):
Hi team,

I'm currently working on migrating some of our previous alerts from Prometheus/AlertManager to SUSE Observability.

I've successfully sent my metrics with OTEL, but I have some questions for the monitor:

I created a custom monitor, but I'm stuck with the urnTemplate.

• With metrics not mapped to a current component type, what do we have to do? Do I need to create my own custom types?
• Can I ignore that it's unmapped and still get a notification if the monitor passes the threshold?
Thanks

---

**Thomas Muntaner** (2025-05-08 16:55):
e.g.

```nodes:
  - _type: Monitor
    arguments:
      metric:
        query: gitlab_ci_pipeline_status{status="failed", kind="branch", ref="main"}
        unit: Short
        aliasTemplate: "Failed Pipeline"
      comparator: "GTE"
      threshold: 1
      failureState: "DEVIATING"
      titleTemplate: Gitlab project ${project} has failing ref ${ref}
      urnTemplate: urn:gitlab-project:${project}
    description: "Failed pipeline"
    function: {{ get "urn:stackpack:common:monitor-function:threshold" }}
    identifier: urn:custom:monitor:failed-gitlab-pipeline
    intervalSeconds: 30
    name: Gitlab - Failed pipeline
    remediationHint: Fix it
    status: "ENABLED"
    tags:
      - "gitlab"```

---

**Matt Farina** (2025-05-08 17:15):
I have a quick question. In a k8s cluster, what system resources (cpu/memory/network) are used by the stst agents? My case is a single node k3s cluster and the cpus and memory are fixed. There is a collection of microservices that will run on it.

---

**Matt Farina** (2025-05-08 17:16):
Sorry if I missed this in the docs

---

**Daniel Barra** (2025-05-08 18:43):
*We are pleased to announce the release of 2.3.3, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.3).*

---

**Mauricio Alves da Silva Perez** (2025-05-08 19:55):
Bram, yesterday I asked the customer to change the permissions and test the access. I'm waiting for his reply.

---

**Warner Chen** (2025-05-09 04:27):
Hello Team, The IHAC (Swire coca-cola) customer reported encountering some error messages in the server pod. They have currently deployed the SUSE O11y Agent in only two clusters, with a total of around 5 nodes. From the logs, it appears the issue may be related to the number of loaded components (over 1000), which seems to have triggered a certain limitation.

I checked the Helm chart's values configuration and it seems there’s currently no option available to adjust this limit. Could you please advise whether this issue could have a real impact?

---

**Amol Kharche** (2025-05-09 06:01):
https://stackstate.atlassian.net/issues/STAC-22148

---

**Warner Chen** (2025-05-09 06:05):
Thanks! @Amol Kharche

---

**Amol Kharche** (2025-05-09 07:28):
It doesn't appear to be mentioned in the documentation, but here is the calculation of total CPU and memory usage for the SUSE observability agent (v1.0.36).
*CPU Requests -&gt; 155m*
*CPU Limits -&gt; 2495m*
*Memory Requests-&gt;  1432Mi*
*Memory Limits  -&gt;   4584Mi*

---

**Amol Kharche** (2025-05-09 07:29):
@Alejandro Acevedo Osorio Please correct me If I'm wrong here.

---

**Remco Beckers** (2025-05-09 09:02):
Metrics don't have to be mapped to a component, but monitors must be mapped to a component in the SUSE Observability model. That's where the health states are reported (in the data model and to the user), and it is the basis for sending out notifications.

We are working on a solution to easily create components from OTel attributes, but we're still working on the design for that. So, to be honest, I don't know of a good solution for you at the moment.

@Bram Schuur Do you know of other options?

---

**Thomas Muntaner** (2025-05-09 09:20):
Hi @Remco Beckers,

worst case for us, we have a prometheus still in the mix also collecting the metrics, so we can trigger alerts from there, but we would love to  consolidate to SUSE Observability.

I would expect that our use-case is also not so uncommon :)

---

**Remco Beckers** (2025-05-09 09:22):
That's our experience too. That's one of the reason we're working on creating topology from OTEL data. Now we only support some hard-coded types (like services, service instances etc).

---

**Remco Beckers** (2025-05-09 09:24):
Oh, that's something you could make use of:
• Add a `service.name` (and ideally `service.namespace` attribute to your metrics (you can also use a `service.instance.id`). 
• Use the urn template to put the monitor health on either the service or service instance components

---

**Thomas Muntaner** (2025-05-09 09:24):
sure, I'll try that today

---

**Remco Beckers** (2025-05-09 09:25):
Given that you're working with Gitlab pipelines maybe this would work:
• namespace: `Gitlab`
• service.name: &lt;the-gitlab-project&gt;
• service.instance.id: &lt;the-gitlab-pipeline-id&gt;

---

**Remco Beckers** (2025-05-09 09:28):
What we want to achieve with the work we're still doing, is that, with a little bit of configuration, you can create components of type "Gitlab pipeline", "Gitlab Project", etc. Then you could use those for your metrics.

---

**Alejandro Acevedo Osorio** (2025-05-09 09:30):
That looks right @Amol Kharche .... @Remco Beckers do you know if we have something written about the agent resources?

---

**Thomas Muntaner** (2025-05-09 09:30):
would

• namespace: gitlab
• service.name: gitlab
• service.instance.id: gitlab-project
work as well?

We would only want one monitor and raise alerts if any project is currently failing

---

**Thomas Muntaner** (2025-05-09 09:32):
we have many custom exporters that we would also map for other things, for example:

• are downstream clusters still connected to rancher
• can users log into rancher
• can we use the kubernetes api of downstream clusters
• ...

---

**Remco Beckers** (2025-05-09 09:35):
yeah that would work too. You could also not have a service.instance.id at all and put the monitor on the service

---

**Thomas Muntaner** (2025-05-09 09:39):
thanks, I'll try this a little later and see what we get

---

**Remco Beckers** (2025-05-09 09:39):
&gt; • are downstream clusters still connected to rancher
&gt; • can users log into rancher
&gt; • can we use the kubernetes api of downstream clusters
&gt; • ...
Monitors for these we usually map to components in the Kuberntes topology. For example (but you may choose differently):
• Downstream clusters: put the monitor on the `cluster` component
• Log into rancher: Monitor on the Rancher `Pod` or `Deployment` (or `Service`)
• Kubernetes API: On the kube-apiserver `deployment`/`pod`/`service` or possibly just on the `cluster`

---

**Thomas Muntaner** (2025-05-09 09:39):
true, I should be able to map some of these to kubernetes components

---

**Remco Beckers** (2025-05-09 09:40):
I don't know, But I guess not (these are also the defaults, under high/low load you might have to increase or could decrease the requests etc)

---

**Remco Beckers** (2025-05-09 09:47):
Maybe good to know: we have a monitor, that is enabled by default, on the `cluster` components that aggregates the health state from all pods in `kube-system` and all `nodes` as an approximation of cluster health (i.e. if a node or some pods in  kube-system are unhealthy the cluster is unhealthy and is in need of attention)

---

**Amol Kharche** (2025-05-09 13:48):
@Remco Beckers Can we add in our documentation then? I can raise ticket if you want.

---

**Amol Kharche** (2025-05-09 14:04):
https://stackstate.atlassian.net/browse/STAC-22756

---

**Zohar Dansky** (2025-05-09 14:47):
Hi, do we have RSS feeds for SUSE Observability that customers can add to their slack channels?

---

**Frank van Lankvelt** (2025-05-09 14:50):
am not sure what kind of messages you would expect to see - releases or alerts?  For alerts, it is possible to setup a Slack notifications; see https://docs.stackstate.com/monitors-and-alerts/notifications/channels/slack

---

**Louis Lotter** (2025-05-09 15:26):
@Zohar Dansky we do  have an integration to allow monitor alerts to go to slack directly as well if that's the way you are thinking.

---

**Zohar Dansky** (2025-05-09 15:47):
thanks both, the customer is registered to receive release updates and alerts for Rancher via slack. They asked if we have the same for SUSE Observability

---

**Jorn Knuttila** (2025-05-09 18:42):
I agree it would be nice for *all* our products to have RSS feeds like Rancher releases do.

---

**Bram Schuur** (2025-05-12 11:32):
added the ticket to the'incoming' sprint for triage

---

**Warner Chen** (2025-05-13 05:24):
Hi @Remco Beckers, The customer would like to know when the documentation for this part might be updated. Would it be possible to provide an estimated timeline to share with them?

---

**Remco Beckers** (2025-05-13 08:04):
Hi, it's on the backlog but as of yet unplanned. So I cannot provide any concrete timeline yet

---

**Remco Beckers** (2025-05-13 08:09):
If they want to get started quickly I advice them to use the existing documentation by the OTel project as I described earlier in this thread.

---

**Remco Beckers** (2025-05-13 08:09):
Can you share the customer? We try to keep track of the different requests we get

---

**Warner Chen** (2025-05-13 08:13):
OK, I’ll ask the customer to refer to the documentation you mentioned earlier for now. The customer is OOCL.

---

**Remco Beckers** (2025-05-13 09:50):
From the error I'm not 100% sure, but victoria metrics and/or vmagent seem to be either slow or the collector cannot connect to vmagent.

Do you have errors in the vmagent or victoriametrics logs? Are they running close to their cpu/memory limits and/or getting throttled?

---

**Thomas Muntaner** (2025-05-13 09:52):
but let me look. I think we bumped the resources and everything should be within range

---

**Remco Beckers** (2025-05-13 09:57):
The error is about writing to prometheus remote write, which goes via vmagent to Tephra. The receiver is not in that path so I don't expect the error in the receiver log to be related.
However given that that also is a timeout it may be that some pods are running at their limit (or a node is running at 100% cpu), slowing everything down

---

**Thomas Muntaner** (2025-05-13 10:00):
actually, it looks like we may be at some memory limits :melting_face:

---

**Thomas Muntaner** (2025-05-13 10:01):
I'm guessing we just have too much data hitting it and will need to adjust.

---

**Remco Beckers** (2025-05-13 10:02):
Could be, but also Elasticsearch is not involved in the metrics processing (only logs and events).

---

**Thomas Muntaner** (2025-05-13 10:03):
kafka-2 is nearly at 100% memory. Could that be it?

---

**Thomas Muntaner** (2025-05-13 10:05):
and checks is the only pod at over 100% CPU, which I should adjust as well

---

**Remco Beckers** (2025-05-13 10:15):
That might help, but instead of tweaking individual resources you might want to scale up to a bigger profile.

---

**Remco Beckers** (2025-05-13 10:17):
But none of these are in the path for storing metrics from otel. That goes

otel-collector -&gt; vmagent -&gt; victoria-metrics.

Did you try restarting the otel-collector? You mentioned the other 2.

---

**Thomas Muntaner** (2025-05-13 10:18):
we're already on the 250 profile with under 100 nodes :)

---

**Thomas Muntaner** (2025-05-13 10:18):
but we have 15 clusters and multiple harvesters connected to it

---

**Remco Beckers** (2025-05-13 10:20):
How big are your nodes? The 250 is based of nodes with 4 vCPUs and 16GB of memory

---

**Thomas Muntaner** (2025-05-13 10:21):
you're right, I forgot to bump up the nodes after we adjusted the profile. I'll get on that

---

**Thomas Muntaner** (2025-05-13 10:23):
and yes, I recreated the otel pod. It's stuck in a crash loop anyways where it builds up memory until OOM and then restarts

---

**Remco Beckers** (2025-05-13 10:23):
That definitely indicates the metrics are not getting stored then.

---

**Remco Beckers** (2025-05-13 10:24):
If you're still stuck after bumping nodes we should probably get on a call so I can have a look with you to speed things up

---

**Thomas Muntaner** (2025-05-13 10:25):
this used to work and it works for our other development cluster, but I think pushing vm data from harvester with OTEL is causing issues

---

**Thomas Muntaner** (2025-05-13 10:32):
so I was wrong, I was looking at our ETCD node and not the worker node:

---

**Davide Rutigliano** (2025-05-13 11:35):
@Bram Schuur since I have your attention I'd like to ask you if you advise any approach to "automatically" configure monitors. Use case is I have a `monitors.yaml` file that I can apply with sts commands. I was wondering what would be the best approach to apply them in a reproducible/automatic way using terraform/helm

---

**Remco Beckers** (2025-05-13 12:02):
Let's do that. Anything between 14.00 and 16.00 (CEST) works for me today. Or we can do right now, I've got almost half an hour

---

**Thomas Muntaner** (2025-05-13 12:04):
let's just a quick call now. Just give me a min to get it ready

---

**Thomas Muntaner** (2025-05-13 12:33):
logs from the call

---

**Marc Rua Herrera** (2025-05-13 14:46):
Hi team, quick question:
If I manually add a permission (e.g., `unlock-node`) to the Admin role in SUSE Observability, will that permission be retained after an upgrade? Just want to confirm whether RBAC changes to built-in roles are persistent or overwritten.
Thanks!

---

**Bram Schuur** (2025-05-13 14:50):
if you added it through the cli, that should stay. if you added in lets say a configmap, that should be overwritten by the upgrade

---

**Bram Schuur** (2025-05-13 14:52):
at this point we do not support monitors as kubernetes CRs, this is on our medium/long term roadmap. The only way of applying them automatically right now is through the cli `settings` command

---

**Lisa Guerineau** (2025-05-13 19:16):
Hi Team!  I have a customer running into issues when setting up SUSE Observability.  Is this the correct Reg Code?  It's my understanding they should have dashes in the code.

What's the best step forward to correct this? Are you able to provide a new code, or should the customer create a support case?

---

**Mohamed Belgaied** (2025-05-13 19:36):
A customer of mine is asking the following questions about SUSE Observability:
• Does SUSE Observability expose an API for Notifications/Alerts in order to query them from NRPE (Nagios Remote Plugin Executor) ?
• Can you confirm that SUSE Observability does not yet integrate with Rancher's Multi-tenancy and the Project permissions concept, but it is work in progress ? If yes, can you have a vague timeline ?
• Does another Multi-tenancy concept already exist ? Can users only see their assigned dashboards in some way ?

---

**Marc Rua Herrera** (2025-05-13 19:39):
Got it! Thanks Bram

---

**Zia Rehman** (2025-05-14 03:00):
Hi All,

While installing the SUSE Observability agent, I noticed that in the StackPack section, the deploy command URL for every distribution type starts with `htpp` instead of `http`.

Will this be corrected from the backend?

---

**David Noland** (2025-05-14 03:02):
Normally you need to get help at <#C02AYV7UJSD|> for license keys.

---

**David Noland** (2025-05-14 04:06):
Or if the customer opens a support case, my team will go to <#C02AYV7UJSD|> and request help.

---

**Deon Taljaard** (2025-05-14 07:52):
Hi Zia, that URL gets constructed from the `stackstate.baseUrl` provided through Helm values. Could you double-check the value used for `baseUrl` when generating the value files?

---

**Frank van Lankvelt** (2025-05-14 08:31):
that code is very weird - it indeed does not have dashes, but it also has the wrong number of characters.  So it's definitely incorrect.

---

**Bram Schuur** (2025-05-14 09:05):
Dear Mohamed,
1. Currently we do not have an out of the box upstream integration with nagios. We do have an api that would allow you to ingest nagios notifications/alerts as health/monitor information into the platform: https://docs.stackstate.com/health/health-synchronization
2. We are actively working on rancher.k8s native RBAC permission support. Delivery should be in a couple of months
3. There is another concept (our old RBAC system), but we recommend waiting for the rancher based one, there is a high chance our previous iteration will be deprecated.

---

**Mohamed Belgaied** (2025-05-14 09:39):
OK, thank you for your answers.
However for the point 1., I meant it the other way around: not ingesting metrics from Nagios, but expose alerts in an API so that it can be queried from the outside (NRPE).

---

**Bram Schuur** (2025-05-14 09:42):
Sorry, i misunderstood. I am not familiar with NRPE, but suse observability does allow forwarding notifications to extenral services by implementing a webhook. This is not immediately queryable but would allow you to reach the desired goal i think:
• https://docs.stackstate.com/monitors-and-alerts/notifications/channels/webhook#notification-life-cycle

---

**Mohamed Belgaied** (2025-05-14 10:11):
Thank you so much ! These are the answers I needed!

---

**Zia Rehman** (2025-05-14 10:27):
@Deon Taljaard Yes, while running the helm template command I had done typing mistake. Thanks for the correction.

---

**Mohamed Belgaied** (2025-05-14 11:31):
A customer of mine is asking if they can use SUSE Observability agent to ship logs to Kafka (additionally to the SUSE Observability cluster).
My understanding is that:
• Right now, running an additional promtail pod is needed (https://docs.stackstate.com/logs/k8sts-log-shipping#running-additional-promtail-pods). However, Promtail is deprecated upstream (https://grafana.com/docs/loki/latest/send-data/promtail/#promtail-agent).
• SUSE Observability does support Open Telemetry, but Logs are not yet supported in that context (https://docs.stackstate.com/open-telemetry/getting-started/concepts#signals).
• SUSE Observability is working on a new Open Telemetry Log Shipper.
Is this right ?
Do we have a OTA for the new Open Telemetry Log Shipper ?
Should my *new* customer begin with deploying an additional promtail, and migrate down the line ?

---

**Remco Beckers** (2025-05-14 12:43):
Correct. You can't use our agent (promtail) to ship logs somewhere else. But you don't have to use as an additional promtail pod, you could use anything else to ship the logs to Kafka.

It's also correct that SUSE observabilitiy doesn't support OTel logs. But we're not yet working on a new log shipper and api. It is on the roadmap but not yet planned when we will be starting the work.

So I can't give an ETA on the new log shipper.

My suggestion for the customer would be to not use the deprecated promtail but use the Open Telemetry Collector as the log shipper to ship logs to Kafka. See also https://opentelemetry.io/blog/2024/otel-collector-container-log-parser/ for setting up the pod log collection.

---

**Remco Beckers** (2025-05-14 12:44):
Can you share the customer name? I can add them to the list of interested people for the logs roadmap item

---

**Mohamed Belgaied** (2025-05-14 12:47):
Thank you for the clear answers. Yes, the customer is ANFSI, a government agency in France.

---

**Christian Frank** (2025-05-14 12:50):
Hi @Mohamed Belgaied, just to clarify: ANFSI wants to ship logs to Kafka, outside of SUSE Observability, correct? What do they expect to happen with the logs?

---

**Mohamed Belgaied** (2025-05-14 12:52):
Yes, that's right. So, they will still use logging features of SUSE observability but they also have multiple logging solutions that can consume log events from Kafka. They use it for other legacy applications and might use it with K8s as well.

---

**Remco Beckers** (2025-05-14 12:55):
If they already have consumers for those logs on Kafka they might be limited in their choice by the log format that is expected on Kafka. So they probably want to check that the OTel Kafka logs exporter uses a format that they support (same problem if they decide to use promtail of course)

---

**Mohamed Belgaied** (2025-05-14 12:56):
Good to know, thank you! :+1:

---

**Christian Frank** (2025-05-14 12:56):
The Rancher Logging Operator supports Kafka, too :slightly_smiling_face:

---

**Mohamed Belgaied** (2025-05-14 12:58):
Yes, but since this is a new customer, I am hesitant about recommending Rancher logging...

---

**Christian Frank** (2025-05-14 12:59):
Can you explain?

---

**Mohamed Belgaied** (2025-05-14 13:04):
Well, SUSE observability is supposed to replace the monitoring and logging stack that come with Rancher. At some point in the future, I am expecting Rancher logging to come out of support. And knowing how well we handled migration paths in the past, I do not want a new customer to use our "older" solution.

---

**Christian Frank** (2025-05-14 13:09):
Both our monitoring and logging stacks are stable upstream projects; they won't go away anytime soon :slightly_smiling_face:

---

**Christian Frank** (2025-05-14 13:11):
If StackState perseveres, the max they would lose would be the UI integration

---

**gaetan.trellu** (2025-05-14 15:12):
To re-bounce on @Mohamed Belgaied question. Does SUSE Observability has a global API?
• Get the registered clusters
• Retrieve `deviating` objects per cluster or overall
• Retrieve the last changes of an object
• etc...

---

**Bram Schuur** (2025-05-14 15:14):
We do not offer a documented comprehensive api right now for retrieval, there are apis but those are not for public use.

---

**gaetan.trellu** (2025-05-14 15:16):
Thanks @Bram Schuur, does the API will be documented at some point?

---

**Bram Schuur** (2025-05-14 15:17):
we have plans to come out with a standardized api, but that is pretty far on the backlog

---

**gaetan.trellu** (2025-05-14 15:17):
Ok, thanks.

---

**Lisa Guerineau** (2025-05-14 15:35):
Thanks all.  The customer has created Case # 01580459 and I can see the Reg Code has been updated in the SCC.  I will advise the customer to try again with the new code. Thank you.

---

**Marc Rua Herrera** (2025-05-14 16:57):
Hi all,

The installation works, but when I run commands like `sts agent list` or `sts context save`, I get this error:

&gt; :x: Could not connect to https://observability01.rhos02.rb-dcs.bosch.com/api (undefined response type)
When I run the command with `-v`, I can confirm that the CLI *reaches the endpoint*, because it logs this request:

```GET /api/server/info HTTP/1.1
Host: 
observability01.******.com
User-Agent: StackStateCLI/3.0.5
Accept: application/json
X-API-Token: ********
Accept-Encoding: gzip


2025/05/14 09:53:28
HTTP/1.1 200 OK
Cache-Control: no-store, no-cache
Content-Security-Policy-Report-Only: object-src 'none'; base-uri 'self'; script-src 'self' 'nonce-ThemY_72CHkY6qOYv9TZ-A' 'unsafe-inline' 'unsafe-eval' https://*.msauth.net (http://msauth.net) https://*.msftauth.net (http://msftauth.net) https://*.msftauthimages.net (http://msftauthimages.net) https://*.msauthimages.net (http://msauthimages.net) https://*.msidentity.com (http://msidentity.com) https://*.microsoftonline-p.com (http://microsoftonline-p.com) https://*.microsoftazuread-sso.com (http://microsoftazuread-sso.com) https://*.azureedge.net (http://azureedge.net) https://*.outlook.com (http://outlook.com) https://*.office.com (http://office.com) https://*.office365.com (http://office365.com) https://*.microsoft.com (http://microsoft.com) https://*.bing.com (http://bing.com) 'report-sample'; report-uri https://csp.microsoft.com/report/ESTS-UX-All
Content-Type: text/html; charset=utf-8
Date: Wed, 14 May 2025 07:53:27 GMT
Expires: -1
Link: &lt;https://aadcdn.msftauth.net&gt;; rel=preconnect; crossorigin,&lt;https://aadcdn.msftauth.net&gt;; rel=dns-prefetch,&lt;https://aadcdn.msauth.net&gt;; rel=dns-prefetch
P3p: CP="DSP CUR OTPi IND OTRi ONL FIN"
Pragma: no-cache
Set-Cookie: ***; expires=Fri, 13-Jun-2025 07:53:27 GMT; path=/; secure; HttpOnly; SameSite=None
Set-Cookie: e*****; domain=.login.microsoftonline.com (http://login.microsoftonline.com); path=/; secure; HttpOnly; SameSite=None
Set-Cookie: *****; domain=.login.microsoftonline.com (http://login.microsoftonline.com); path=/; secure; HttpOnly; SameSite=None
Set-Cookie: fpc=Aoy4tLfuvw9PhqrCnWcVigykjkD5AQAAAPZCtt8OAAAA; expires=Fri, 13-Jun-2025 07:53:27 GMT; path=/; secure; HttpOnly; SameSite=None
Set-Cookie: x-ms-gateway-slice=estsfd; path=/; secure; samesite=none; httponly
Set-Cookie: stsservicecookie=estsfd; path=/; secure; samesite=none; httponly
Strict-Transport-Security: max-age=31536000; includeSubDomains
Vary: Accept-Encoding
X-Content-Type-Options: nosniff
X-Dns-Prefetch-Control: on
X-Frame-Options: DENY
X-Ms-Ests-Server: 2.1.20663.11 - FRC ProdSlices
X-Ms-Request-Id: 0d982aa3-b854-44ea-b470-46fd998f5500
X-Ms-Srs: 1.P
X-Xss-Protection: 0```
And the response includes a full *Microsoft login HTML page*, not JSON:

```<!DOCTYPE html>
&lt;html dir="ltr" class="" lang="en"&gt;
&lt;head&gt;
    &lt;title&gt;Sign in to your account&lt;/title&gt;
...```
I also see in the API pod logs:

```OidcPersonalTokenProfileCreator - No refresh token found
PersonalTokenAuthenticator - User authenticated with token _Iq7w...```
Does anyone know how I can troubleshoot this or what could be the reason?

---

**Frank van Lankvelt** (2025-05-14 17:07):
you sure the api pod logs appear when trying this command - they weren't from an earlier access?  It sure looks like you are being redirected by a gateway of some sort

---

**Marc Rua Herrera** (2025-05-14 17:11):
I think you are right, they could be indeed from early access. As I also see some other user in the API logs

---

**Derek So** (2025-05-15 07:55):
Hello team, where can we find a complete list of out-of-the-box metrics in our documentation that we can share with customers? Thanks!

---

**Alessio Biancalana** (2025-05-15 08:26):
hi, I think you can refer to this https://docs.stackstate.com/monitors-and-alerts/kubernetes-monitors

---

**Derek So** (2025-05-15 08:33):
Thanks @Alessio Biancalana I showed this page to the customer buy they are looking for list of metrics, not monitors with alert threshold.

---

**Alessio Biancalana** (2025-05-15 08:36):
I'm sorry I didn't understand your question at first, I don't know about metrics :confused:

---

**Derek So** (2025-05-15 09:06):
They would like to see the definition of metrics used in building the PromQL as documented here: https://docs.stackstate.com/metrics/k8sts-explore-metrics

---

**Bram Schuur** (2025-05-15 09:11):
Dear Derek, we do not have documentation for each individual metric right now.

---

**Derek So** (2025-05-15 09:13):
Thanks @Bram Schuur and @Alessio Biancalana! Do you know if there’s any plan to produce this document for customer reference?

---

**Bram Schuur** (2025-05-15 09:14):
there is no immediate plan, we can put this on our backlog, but it depends on the priority of this how quick this will get picked up.

---

**Derek So** (2025-05-15 09:27):
This is requested by a customer who is evaluating this product. It seems we are missing a very important piece of document in this observability product. Be great if this can be prioritized. Thank you very much!

---

**Alejandro Acevedo Osorio** (2025-05-15 09:33):
Perhaps you can enable debug logging to see if you can get more info https://docs.stackstate.com/self-hosted-setup/security/authentication/troubleshooting

---

**Marc Rua Herrera** (2025-05-15 09:34):
I will try this. Thanks Alex.

---

**Alejandro Acevedo Osorio** (2025-05-15 09:37):
I remember a customer case with `Microsoft Identity Platform` on the old 5.1 the ran into this issue
```
SUSE Observability needs OIDC offline access. For some identity providers, this requires an extra scope, usually called offline_access.```

---

**Marc Rua Herrera** (2025-05-15 09:41):
Is this by any chance in our previous support platform?

---

**Alejandro Acevedo Osorio** (2025-05-15 09:42):
This is in our docs https://docs.stackstate.com/self-hosted-setup/security/authentication/oidc#configure-the-oidc-provider (last bullet point)

---

**Remco Beckers** (2025-05-15 10:01):
Are they looking for specific metrics or categories/groups of metrics or the exact list of metric names.
The latter would become a rather unwieldy list of hundreds of metrics.

---

**Vladimir Iliakov** (2025-05-15 10:02):
These 500-s can be ignored, they happened because api was restarted at the same time.

---

**Vladimir Iliakov** (2025-05-15 10:02):
I guess the answer might be in the node agent logs

---

**Derek So** (2025-05-15 10:08):
@Remco Beckers
1. They are planning to migrate from Prometheus/Grafana + Kiali to SUSE Observability. To estimate the effort, they would like to have a complete list of the available metrics out-of-the-box for the migration effort estimation and if the solution can replace their existing monitoring stack.
2. They need this to make use of building up PromQL and add to the dashboard.

---

**Hugo de Vries** (2025-05-15 10:35):
Its a very long list of metrics for:
• Datadog based host/node agent
• Datadog based process agent
• Kubestate metrics from clusteragent
• Metrics provided by OpenTelemetry instrumentation of applications and databases. The repo of each otel integration usually has a list of metrics that it’s collecting.
I tried querying for a list of all the metric names but was not succesful yet.

This is an overview of the host and processagent metrics from datadog agents. When you check the metrics explorer on our playground you’ll see that we collect most of them. They are formated with underscores instead of periods. So system_cpu_ etc.

I expect we will already cover about the same collection of metrics. Since we also support PromQL, they can use the same queries when adding metrics to dashboards in Suse Observability.

1. *Host Agent (core agent) – System Metrics*
These are collected out-of-the-box:

CPU
	•	system.cpu.user
	•	system.cpu.system
	•	system.cpu.idle
	•	system.cpu.stolen
	•	system.cpu.iowait
	•	system.cpu.guest
	•	system.cpu.guest_nice
	•	system.cpu.nice
	•	system.cpu.interrupt
	•	system.cpu.softirq
	•	system.cpu.steal

Memory
	•	system.mem.total
	•	system.mem.used
	•	system.mem.free
	•	system.mem.cached
	•	system.mem.buffered
	•	system.mem.swap.total
	•	system.mem.swap.free
	•	system.mem.swap.used
	•	system.mem.available

Disk
	•	system.disk.read_time
	•	system.disk.write_time
	•	system.disk.read_bytes
	•	system.disk.write_bytes
	•	system.disk.read_ops
	•	system.disk.write_ops
	•	system.disk.in_use
	•	system.disk.free
	•	system.disk.total

Network
	•	system.net.bytes_sent
	•	system.net.bytes_rcvd
	•	system.net.packets_sent
	•	system.net.packets_rcvd
	•	system.net.errors_in
	•	system.net.errors_out
	•	system.net.drops_in
	•	system.net.drops_out

Load
	•	system.load.1
	•	system.load.5
	•	system.load.15

IO
	•	system.io.r_s (read/s ops)
	•	system.io.w_s (write/s ops)
	•	system.io.rkb_s (read KB/s)
	•	system.io.wkb_s (write KB/s)

Filesystem
	•	system.disk.in_use
	•	system.disk.free
	•	system.disk.total
	•	per mountpoint

Others
	•	system.uptime
	•	system.processes.total
	•	system.processes.running
	•	system.processes.sleeping
	•	system.processes.stopped
	•	system.processes.zombies

⸻

1. *Process Agent – Process Metrics*
Collected if the Process Agent is enabled (via process_config.enabled: "true"):

Per-process Metrics
	•	process.cpu.user
	•	process.cpu.system
	•	process.cpu.total_pct
	•	process.mem.rss
	•	process.mem.vms
	•	process.mem.pct
	•	process.io.read_bytes
	•	process.io.write_bytes
	•	process.open_file_descriptors
	•	process.thread_count

Process count per name or group
	•	process.running
	•	process.stopped
	•	process.sleeping
	•	process.zombie

These are grouped and tagged by:
	•	process.name
	•	process.pid
	•	process.user
	•	Custom tags (from config)

---

**Remco Beckers** (2025-05-15 11:08):
We also have a huge list of Kubernetes (and Kubernetes state) metrics  plus quite a list container metrics

---

**Remco Beckers** (2025-05-15 11:08):
Not sure where you got those list from @Hugo de Vries

---

**Marc Rua Herrera** (2025-05-15 12:10):
This clusters not receiving metrics are in a ACI Cisco Netwrok, and they have to open manually the ports. The strange thing is that we receive topology.

One question maybe. If we skip TLS verification, does it use the port 8080 instead of 443? We only opened 443.

---

**Marc Rua Herrera** (2025-05-15 12:16):
The errors in the node-agent, a part for the "too many errors for the endpoint". Also say:

---

**Marc Rua Herrera** (2025-05-15 12:20):
And the to many errors are for 2 different endpoints:

`receiver/stsAgent/intake/`

`receiver/stsAgent/api/v1/series`

---

**Vladimir Iliakov** (2025-05-15 12:29):
That Client.Timeout might be caused by traffic filtering in between or the platform performance issues...

---

**Vladimir Iliakov** (2025-05-15 12:29):
I can't say for sure.

---

**Vladimir Iliakov** (2025-05-15 12:29):
<!subteam^S08HEN1JX50> <!subteam^S08HHSW67FE> fya

---

**Marc Rua Herrera** (2025-05-15 12:31):
Performance issues? I see some GC of 500 ms. These are the receiver-base logs

---

**Vladimir Iliakov** (2025-05-15 12:36):
Is there any http proxy between the agent and the platform?

---

**Marc Rua Herrera** (2025-05-15 12:37):
No proxies

---

**Vladimir Iliakov** (2025-05-15 12:41):
The errors about malformed and corrupt content look suspicious.

---

**Derek So** (2025-05-15 12:47):
Thanks everyone! The list is helpful.

---

**Hugo de Vries** (2025-05-15 13:04):
Be careful sharing this list 1:1 with the customers, we might not collect all of these so needs validation first. Kiali is observability interface for Isio. Istio can be instrumented with metrics and traces using the Prometheus exporter and Otel instrumentation for traces. https://istio.io/latest/docs/reference/commands/pilot-discovery/#metrics

@Remco Beckers good point, there are even more metrics from Kubernetes that we collect indeed. I got this list via datadog website https://docs.datadoghq.com/integrations/#cat-os-system

---

**Hugo de Vries** (2025-05-15 13:06):
Long story short, no noteworthy difference expected in coverage of metrics collected, so migrating should not be an issue. If there is particular interest in certain metrics, please let customer provide the metric name and we can look into it.

---

**Derek So** (2025-05-15 13:49):
Got it. Really appreciate your team’s quick responses! thanks again :pray:

---

**Alessandro Festa** (2025-05-15 17:43):
Hi Observability gurus... newbie question, when I try to use openlit.init() in an application I receive an `ERROR: Failed to export batch code: 401, reason: Unauthorized`  but I have no idea what to pass and how..I found I have an `otlp_headers` but not sure is the right thing to use... anyone has idea or examples? Maybe is a stupid question but I really struggling to find a solution

---

**Remco Beckers** (2025-05-16 08:26):
If you've configured the SUSE Observability otel endpoint directly into openlit you'll need to authenticate using an api key.

We normally recommend, for production at least, running an otel collector close to your application and handle the authentication there: https://docs.stackstate.com/open-telemetry/getting-started/getting-started-k8s.

But it is fine to ignore that (especially when developing, testing, etc). You can simply configure an authentication header with the api token. The getting started has more details but the tldr; is to add bearer token authentication with the scheme `SUSEObservabilty` and an api key as the token.

---

**Remco Beckers** (2025-05-16 08:29):
You can also directly set the header yourself:
`Authentication: SUSEObservability &lt;api-key&gt;`

---

**Zohar Dansky** (2025-05-16 11:38):
How can a customer learn about new releases or patches at the moment? Is that communicated at the Rancher Channels? any formal support pages?

---

**Warner Chen** (2025-05-19 04:19):
Hello Team, May I ask if the JSON data format sent by a Webhook type Notification supports customization?
https://docs.stackstate.com/monitors-and-alerts/notifications/channels/webhook#webhook-requests-and-payload

---

**Frank van Lankvelt** (2025-05-19 08:32):
it's possible to attach custom metadata/tags to a notification.  The idea of the webhook is that you create a custom handler that then transforms the JSON into whatever works best for the customer.

---

**Warner Chen** (2025-05-19 08:38):
thx, i am currently doing some testing on this.:grin:

---

**Benoît Loriot** (2025-05-20 11:03):
Hi, a prospects asked me if it is possible to limit the amount of data sent by the downstream cluster (SO agent) to SUSE Observability?
They have clusters in Africa where bandwidth is limited to 2 Mbps.

---

**Bram Schuur** (2025-05-20 11:10):
There is no out of the box support for this right now, there might be an option for them to route the traffic through a proxy (https://docs.stackstate.com/agent/k8s-network-configuration-saas/k8s-network-configuration-proxy) and have the proxy throttle the traffic, but i have not direct experience with such a setup (just an idea).

---

**Benoît Loriot** (2025-05-20 11:12):
Thanks @Bram Schuur that's a first lead to explore if they would deploy SO in such environments.

---

**Benoît Loriot** (2025-05-20 11:25):
I am wondering now, can we choose to only gather and send datas of a specific namespace ou subset of the cluster ?
That could also be a solution to limit amount of bandwidth required.

---

**Bram Schuur** (2025-05-20 11:26):
we do not support tweaking that right now, we always send everything

---

**Davide Rutigliano** (2025-05-20 15:25):
Hi SUSEObs team, I am trying to configure slack notifications. I have already configured the Slack app ID/secret for access to SUSE Software Ltd (this) workspace. In the UI, after I allow access for the app to the workspace, I see an empty list of channels and errors when trying to reach `https://<suse_obs_url>/api/notifications/channels/slack/<some_id>/listSlackChannels`  with `"message":"Slack API returned an error: ratelimited"`. Could be that due to the fact that stackstate tries to fetch ALL channels in the workspace? Any way to limit/configure this?

---

**Davide Rutigliano** (2025-05-20 15:30):
actually on very first request before getting rate limited I get
```"errors":[{"message":"Operation timeout error.","errorCode":408,"_type":"ServerTimeoutError"}]```

---

**Bram Schuur** (2025-05-20 15:54):
Yes, stackstate tries to fetch all channels. I can see this is an issue in such a big organisation. Filing a ticket...

---

**Bram Schuur** (2025-05-20 15:57):
Thanks for reporting @Davide Rutigliano, filed the following ticket: https://stackstate.atlassian.net/browse/STAC-22771

---

**Davide Rutigliano** (2025-05-20 15:58):
Thanks @Bram Schuur!

---

**Garrick Tam** (2025-05-20 20:29):
Hello.  I have a customer that is stuck with the same issue.  The Observability is installed into a Rancher downstream cluster and the Observability exposed over Rancher Ingress using a self-signed certificate.  When attempting to configure the Observability UI-Extension, the Rancher local cluster ingress returns a 502.

Does the UI-Extension support Observability URL with self-signed certificate?

---

**Garrick Tam** (2025-05-21 02:26):
I believe it is the case where CA signed certificate is required.  An ingress for STS URL backed by CA signed cert returns 401 without correct token while ingress for STS URL backed by Default Ingress Controller Certificate (self-signed) returns 502.

---

**Garrick Tam** (2025-05-21 02:27):
self-signed

---

**Garrick Tam** (2025-05-21 02:27):
@Tj Patel This is what I found.

---

**Garrick Tam** (2025-05-21 02:29):
Can someone that works to integrate UI Extension please confirm this is the expected behavior and a requirement.

---

**Tj Patel** (2025-05-21 18:46):
If so, we really need it in the docs. We have a lot of customers who use air gapped environments and their own private ca's

---

**Jeroen van Erp** (2025-05-21 20:30):
The cert indeed needs to be trusted by rancher, or either a real cert, or add the cert to the truststore

---

**Garrick Tam** (2025-05-21 20:47):
Thx for the response @Jeroen van Erp .   How to make Rancher trust ingress Fake cert?   Which trust store to add cert to and how?

---

**Jeroen van Erp** (2025-05-21 21:16):
That is beyond my knowledge. Best to ask in discuss-rancher?

---

**Tj Patel** (2025-05-21 21:17):
He has, but no one has responded.

---

**Tj Patel** (2025-05-21 21:19):
There are a couple people I've been talking to about our CA certs that I was considering highlighting, but need to double check I don't highlight the wrong person if I do :stuck_out_tongue:

---

**Davide Rutigliano** (2025-05-22 10:43):
Hi team, I am trying to write a remediation guide (https://docs.stackstate.com/monitors-and-alerts/customize/k8s-write-remediation-guide) for a custom monitor and I would like to include metrics labels in the remediation. I am getting a server error when creating the monitor with sts `*message: 'Failed to parse Handlebars template:* Parameter ''labels'' not provided.'`.  Am I doing something wrong?

---

**Davide Rutigliano** (2025-05-22 10:43):
My monitor look like this:
```- _type: Monitor
  arguments:
    comparator: GT
    failureState: DEVIATING
    metric:
      ...
    urnTemplate: urn:cluster:/kubernetes:${cluster_name}
  remediationHint: |-
    The cluster `\{{labels.cluster_name\}}` is lagging too much.```

---

**Davide Rutigliano** (2025-05-22 10:46):
And a funny thing I cannot explain myself is, if I copy/paste the yaml of a built-in monitor referencing metric labels (e.g. `urn:stackpack:stackstate:shared:monitor:clickhouse-distributed-files-to-insert-high`) I get the exact same error about 'labels' not provided

---

**Bram Schuur** (2025-05-22 11:19):
when do you get this issue? when uploading through the cli or in the ui? Could you share the exact file that you are uploading and how?

---

**Davide Rutigliano** (2025-05-22 11:20):
I think it was due to an un-escaped `{{ }}`  sequence

---

**Bram Schuur** (2025-05-22 11:21):
that is what i figured, we might improve our messages there, thanks for reporting:+1:

---

**Andreas Prins** (2025-05-22 13:54):
Sharing is caring:

https://www.linkedin.com/posts/andreasprins_suse-observability-usage-of-ebpf-activity-7331272659822915584-uexB?utm_source=share&amp;utm_medium=member_ios&amp;rcm=ACoAAADjq30BFYAdX1wFuXEB-b7Mn9w7WlkOjOE (https://www.linkedin.com/posts/andreasprins_suse-observability-usage-of-ebpf-activity-7331272659822915584-uexB?utm_source=share&amp;utm_medium=member_ios&amp;rcm=ACoAAADjq30BFYAdX1wFuXEB-b7Mn9w7WlkOjOE)


Leaving a good comment works the best

---

**Bram Schuur** (2025-05-22 14:47):
This is not a work queue but actual state. Could you check the health of the hbase region servers? if loading times out it might be due to them getting restarted.

---

**Bram Schuur** (2025-05-22 14:49):
Side-question: What is the profile used for installing stackstate? How many clustr nodes are hooked up?

---

**Thomas Muntaner** (2025-05-22 14:50):
okay, the hbases are stable, but their storage is slow right now because of a netapp scan going on (https://suse.slack.com/archives/C02AET1AAAD/p1747907110942369?thread_ts=1747407687.687679&amp;cid=C02AET1AAAD).

I was hoping it was something I could just clear and get running, even if it was slow.

---

**Thomas Muntaner** (2025-05-22 14:50):
we have like 15 clusters connected, including 4 harvesters. We're on the 250 node profile, but that may need to be adjusted

---

**Thomas Muntaner** (2025-05-22 14:55):
I can open the question again when everything goes healthy on netapp and if the problem continues

---

**Bram Schuur** (2025-05-22 14:55):
:+1:makes sense

---

**Zia Rehman** (2025-05-23 11:05):
Hi all,
The eLearning course for SUSE Observability will be launching soon. For learners who do not have an SCC subscription and wish to proceed with a trial, how can they obtain a trial license key for SUSE Observability for installation purposes? Is there a specific link or email address where they can request this? I need to include this information in the course.

---

**Josh Stringfellow** (2025-05-23 17:43):
There is a blog post floating around that some of my Rancher Prime Suite customers think implies that they have SaaS observabillity included with their subscription. I am getting several questions about this. Any feedback?
&gt; *Enhanced Rancher Prime Observability for Enterprise Needs*
&gt; SUSE Observability enhances the commercial Rancher Prime offering with robust observability and monitoring features, making it ideal for enterprise environments. Available both as a SaaS service for quick deployment and as an on-premise solution for organizations requiring more control, it provides out-of-the-box golden signals detection and issue detection for applications, queues and databases. Visibility extends beyond the cluster, offering infinite dependency maps through eBPF discovery.
https://www.suse.com/c/introducing-rancher-prime-observability-providing-advanced-insight-into-the-most-complex-environments/

---

**Louis Lotter** (2025-05-26 07:51):
@Andreas Prins

---

**Bram Schuur** (2025-05-26 09:20):
Under this link it is documented how to have rancher trust a custom certficate: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/custom-ca-root-certificates

---

**Louis Lotter** (2025-05-27 11:32):
@Ben Craft Do you know how long you will need this.

---

**Louis Lotter** (2025-05-27 11:33):
I need to report on the costs etc. so If you can write a short justification and time period then we can do this for you.

---

**Ben Craft** (2025-05-27 11:36):
Likely just a couple of months while we are internally testing, so it'll just be our control plane and a very low number of early access tenant instances.

Beyond that and once the product becomes GA i'm happy to deploy our own instance, or work out a way to compensate for the usage internally (not sure if we have any prior art to doing that, but can investigate)

---

**Louis Lotter** (2025-05-27 11:54):
@Vladimir Iliakov What else do you need to know from @Ben Craft to do this for him ?

---

**Vladimir Iliakov** (2025-05-27 11:59):
The name of the tenant, region: EU or US, the number of nodes to observe.

---

**Vladimir Iliakov** (2025-05-27 12:00):
@Louis Lotter the tenant will be deployed to the "Customer" production cluster  and contribute to "Customer" cost category.

---

**Louis Lotter** (2025-05-27 12:01):
@Vladimir Iliakov this is not for a specific customer

---

**Louis Lotter** (2025-05-27 12:01):
I think this is infrastructure monitoring for Rancher customers

---

**Louis Lotter** (2025-05-27 12:01):
So put it in Infra

---

**Ben Craft** (2025-05-27 12:03):
EU please.

Yes this will be for our control plane, and the downstream tenant clusters (which will only be a few for now)

---

**Louis Lotter** (2025-05-27 12:14):
@Ben Craft How many nodes will you be observing ?

---

**Ben Craft** (2025-05-27 12:14):
2 per cluster, so lets say 10 total for now

---

**Vladimir Iliakov** (2025-05-27 12:34):
&gt; So put it in Infra
The only way to do it is to deploy it to saas-tooling internal cluster...

---

**Vladimir Iliakov** (2025-05-27 12:37):
Which has its own Keycloak, shortly, we can't do that.

---

**Vladimir Iliakov** (2025-05-27 13:50):
Hi @Ben Craft , soon, in 15-30 minutes, you should get a welcome email with the info how to login to your tenant.

I will decommission the tenant on Jul 27, with informing you in advance.

---

**Ben Craft** (2025-05-27 13:52):
Thats great - thank you

---

**Mark Abrams 518.421.1504** (2025-05-27 14:11):
Perhaps if you repost in <#C02ER7LFAR2|> you will get some insight

---

**Louis Lotter** (2025-05-27 14:12):
Thanks Vladimir

---

**Warner Chen** (2025-05-28 10:14):
Hello Team, Does SUSE O11y have built-in support or functionality similar to Blackbox Exporter for performing service availability probing and response content monitoring?

---

**Andreas Prins** (2025-05-28 10:26):
thanks @Josh Stringfellow for highlighting this, we can certainly nuance the blogpost a bit to make that very clear. @Ivan Tarin if you can later today add a few lines that would be great.

Furthermore it is a real product positioning question.
Currently
• SUSE Observability is included in Prime, this is the full product with all features. The customer will host this themselves.
• SUSE Observability as a full package is NOT available as SaaS
• SUSE Cloud Observability, a slimmed down version of the product is available as a SaaS, the customer pays for the "hosting" of this service, it should act as an entry point into the Prime bundle.
Nearby future:
• SUSE Cloud Obs. as described above remains the same
• SUSE Observability will get a SaaS variant, where every Prime customer can purchase this, there is a bit of cost involved, again because we take care for the hosting. 
@Mark Bakker can share more details if you have followup questions

---

**Remco Beckers** (2025-05-28 10:40):
No it doesn't have that. We use the blackbox exporter ourselves. The exporter can be scraped using the OTel collector or our agent to ship the data to SUSE Observability

---

**Warner Chen** (2025-05-28 10:51):
Thx, If I understand correctly, the user still needs to deploy the Blackbox Exporter themselves and then send the data to SUSE O11y.

---

**Remco Beckers** (2025-05-28 10:52):
Yes, that's correct

---

**Bram Schuur** (2025-05-28 15:53):
cc @Mark Bakker

---

**Gabriel Lins** (2025-05-28 23:23):
Hello. How can we integrate opencost with observability? The idea is demonstrate to costumer that it's possíble to have this information presented through SUSE Observability

---

**Nick Zhao** (2025-05-29 04:51):
Are we able to watch code-level profiling, memory and CPU usage analysis, and call analysis of third-party components in SUSE O11y.  Or opentelemetry does?

---

**Frank van Lankvelt** (2025-05-29 08:50):
Some technologies, like the jvm, expose metrics that can be made use of.  Otherwise we can only collect process level metrics.  If you want deeper insights into what's happening in a process, instrumentation (either automatic or manual) is going to be needed.  Open telemetry is then indeed the way to get that data into SUSE Observability.

---

**Nick Zhao** (2025-05-29 09:10):
This is a dashboard from grafana which looks like containing those metrics.  Does our o11y have?  Stackpack?  if there is any hands on docs?  Appreciate it.

---

**Alessio Biancalana** (2025-05-29 09:15):
as Frank already said you can see in the screenshot this is pretty specific to the JVM and I guess what you're looking at are opentelemetry traces.

Usually these data are not available out of the box simply because for example the binaries inside containers are compiled without debug symbols or the operating system is shipped without frame pointers support to actually help build a flame graph.

---

**Alessio Biancalana** (2025-05-29 09:17):
I guess you can look at our Traces Perspective section for further material.

https://docs.stackstate.com/views/k8s-view-structure/k8s-traces-perspective

---

**Zia Rehman** (2025-05-29 09:52):
@Mark Bakker Please let me know.

---

**Zia Rehman** (2025-05-29 09:53):
@Jeroen van Erp Please suggest.

---

**Jeroen van Erp** (2025-05-29 09:54):
I think there's a process for that, but I don't know.

---

**Zia Rehman** (2025-05-29 10:23):
Okay, can you please suggest someone who may know the process.

---

**Frank van Lankvelt** (2025-05-29 11:32):
Maybe this is based on https://github.com/grafana/opentelemetry-ebpf-profiler (https://github.com/grafana/opentelemetry-ebpf-profiler)?  I guess it should be possible to deploy an agent that pushes the otel spans from this profiler to use Observability.  As open telemetry is an open standard, any collector should work - including this one.

---

**Frank van Lankvelt** (2025-05-29 11:34):
If you can send the data as metrics or open telemetry spans/traces, then this should certainly be possible.

---

**Nick Zhao** (2025-05-29 11:34):
how about our o11y collector?  How to do that?:smile:

---

**Frank van Lankvelt** (2025-05-29 13:06):
Sorry, but the SUSE Observability team has not been involved in the development of observability for SUSE AI.  I wouldn't even know where to find the relevant code.  You might have better luck with the SUSE AI team.

---

**George Yao** (2025-05-29 13:10):
Sure, Thanks all the same.:handshake:

---

**Thiago Bertoldi** (2025-05-29 17:56):
Yes, the AI Team can help with that. I'll get in touch with you in the direct messages.

---

**Bram Schuur** (2025-05-30 11:38):
@Amol Kharche @Remco Beckers i raised the following bugticket based on the reported issue around the unauthorized UI extension causing issues in the rancher UI:
• https://stackstate.atlassian.net/browse/STAC-22825

---

**Brian Six** (2025-05-31 00:08):
Customer is asking if in our .yaml configuration file if they can change the "stackstate" wording to something else.  Here is the code they are talking about wanting to change the wording "stackstate":

---

**Bram Schuur** (2025-06-02 09:27):
@Louis Lotter maybe you can help @Zia Rehman, i am oblivious to how license keys are handed out now

---

**Louis Lotter** (2025-06-02 09:29):
@Zia Rehman I don't think I would like to interact with every learner.
Who is in charge of this course ?
Best would probably be to generate a set of short term keys, put it in a spreadsheet and then you or whoever is in charge can hand them out ?

---

**Louis Lotter** (2025-06-02 09:29):
I have no idea if anyone has already planned a process for this but no one has asked me.

---

**Louis Lotter** (2025-06-02 09:30):
I'm happy to help set it up though.

---

**Ravan Naidoo** (2025-06-02 09:34):
Yes they can change the names to anything they like.  They must remember however to redeploy any SUSE Observability Agents and Open Telemetry Agents to point to the newly named url.

---

**Mark Bakker** (2025-06-02 09:47):
We currently don't have a formal process for trial keys outside customers (SCC). We do provide trial keys on request for sales engagements via a spreadsheet which is kept by sales. I like to understand who the typical user which follows these courses?
I also like to understand the content of the course, is this installation, usage, ... ?

---

**Zia Rehman** (2025-06-02 10:27):
1 have developed an e-learning course on SUSE Observability, which also covers the installation process. Learners who do not have an SCC account will need a license key to proceed. Therefore, I need to include information in the course on how they can obtain the license key. Users will be our customers, partners and the SCI's who will be delivering this course.

---

**Hugo de Vries** (2025-06-03 15:07):
Can former StackState customers also use SCC to create tickets? I'm getting ongoing complaints from Accenture,  Rabobank and NN about response times on support request created via zendesk, mainly the initial response that takes days or even longer then a week in some cases. I'd like to onboard these handful of customer to SCC and let them make use of the Suse Sbservability support process in place for Rancher Prime customers. To discuss this, who do I need to reach out to?

---

**Remco Beckers** (2025-06-03 15:13):
@Mark Bakker Maybe you can answer this. I would be happy with that approach too

---

**Alessio Biancalana** (2025-06-03 15:16):
if the roadblock is merely technical then maybe <#C02AYV7UJSD|> is the place to go

---

**Louis Lotter** (2025-06-03 15:28):
i think there may be contractual issues but I agree if possible we need to get this done

---

**Owen Lewis** (2025-06-03 15:59):
Hi Hugo - our plan for 'legacy' StackState customers is that we will support them through Zendesk until they renew to Rancher Prime when we will onboard them to SUSE systems including SCC.

@David Noland Please could you check with the former StackState team on Hugo's feedback and how we can improve the service level on these requests.  Thanks.

---

**Mark Bakker** (2025-06-03 16:03):
I would love to get them on SCC but indeed in their contract we need to do this from NL, I look at the tickets once per day. I would be really happy if we can move them to SCC to be fair!

---

**David Noland** (2025-06-03 16:22):
The agreement was to keep legacy customers on StackState's Zendesk and support tickets need to be handled by the StackState team. I believe there was a legal requirement for multiple legacy customers that only staff within a certain country (Netherlands?) can have access to their tickets. We had to revoke my team's access to Zendesk to satisfy this legal requirement. So unless we can geofence these cases in SCC, we do not want them coming into SCC/SFDC is my understanding.

---

**David Noland** (2025-06-03 16:23):
But if these legacy customers want to purchase Rancher Prime, then they should have no issues getting access to SCC.

---

**Hugo de Vries** (2025-06-03 16:37):
Thanks for the swift responses. So asking them for permission to let first line support potentially be handled by non Dutch citizens would would not be enough then. Accenture has recently renewed, I'll check the contract if Prime is part of that as well.

---

**Owen Lewis** (2025-06-03 16:44):
@Hugo de Vries As and when legacy customers renew to Rancher Prime at the end of their current term is the point at which we can onboard them to SUSE systems and Support processes.  In the meantime, @Mark Bakker please continue to keep an eye on the Zendesk queue so we can give these customers a prompt service.  Thanks all.

---

**Mark Bakker** (2025-06-03 17:37):
@Owen Lewis yes I do, be aware that we had a payment issue for a few weeks which indeed gave slower responses lately.

---

**Graham Hares** (2025-06-03 18:41):
Sorry for this dumb and confusing question, but trying to understand the auth between the otel collector/exporter and a remote suse observability otel collector:
```otlp:
  protocols:
   grpc:
    auth:
     authenticator: ingestion_api_key_auth
     endpoint: ${env:MY_POD_IP}:4317
   http:
    auth:
     authenticator: ingestion_api_key_auth
     endpoint: ${env:MY_POD_IP}:4318```
I have suse obs behind an aws lb with ports 4317 and 4318 open with tcp protocol, the otel ingress objects have self signed certs via cert-manager issuer,
The collector running on a separate cluster is configured with:
```exporters:
  otlp:
   endpoint: https://oltp-${OBS_HOSTNAME}:4317
   headers:
    Authorization: "SUSEObservability ${env:API_KEY}"
   tls:
    insecure: true```
oltp-${OBS_HOSTNAME} is in public Route53 DNS and open.

Question is will GPRC Auth work through the EC2 LB? and is the same API_KEY used for the remote observability agent work for Otel or should I use a different value for header Authorization: string or key?
ty

---

**Graham Hares** (2025-06-03 18:52):
remote collector pod has this in it's log:
```2025-06-03T16:51:22.260Z  warn  grpc@v1.72.1/clientconn.go:1405 [core] [Channel #3 SubChannel #4]grpc: addrConn.createTransport failed to connect to {Addr: "oltp-obs.demo.suselabs.net:4317 (http://oltp-obs.demo.suselabs.net:4317)", ServerName: "oltp-obs.demo.suselabs.net:4317 (http://oltp-obs.demo.suselabs.net:4317)", BalancerAttributes: {"&lt;%!p(pickfirstleaf.managedByPickfirstKeyType={})&gt;": "&lt;%!p(bool=true)&gt;" }}. Err: connection error: desc = "transport: authentication handshake failed: context deadline exceeded"  {"resource": {}, "grpc_log": true}```

---

**Graham Hares** (2025-06-03 18:53):
wondering about mTLS auth :thinking_face:

---

**Remco Beckers** (2025-06-04 09:55):
Your exporter configuration looks a bit strange:
• indentation of the keys inside `otlp` seems wrong (only 1 space), although somehow it seems to work (judging from the logs), so maybe it just got mangled copy/pasting into slack
• The authentication cannot be configured in the exporter, the way to do that is to use the `bearertokenauth` extension and refer that in the exporter, for an example see our docs here: https://docs.stackstate.com/open-telemetry/getting-started/getting-started-k8s#configure-and-install-the-collector

---

**Remco Beckers** (2025-06-04 09:56):
Make sure to enable the extension (and not only configure it) by including it in the `service.extensions` array as well

---

**Graham Hares** (2025-06-04 09:56):
Morning @Remco Beckers I cut and pasted bits from deployment and rancher manager ui :slightly_smiling_face:

---

**Graham Hares** (2025-06-04 09:58):
I stopped my cluster now, reading through configs and will try things again, my demo moved out a week so have the opportunity to get this extra bit figured out

---

**Graham Hares** (2025-06-04 09:59):
Thank you for the extension doc link :pray:

---

**Graham Hares** (2025-06-04 11:07):
I did a test this morning but didn't get the config right I think:
```  helm --kubeconfig=./local/admin-cluster1.conf upgrade \
    --install obs suse-observability/suse-observability \
    --namespace suse-observability --create-namespace \
    --values ./local/suse-observability-values/templates/baseConfig_values.yaml \
    --values ./local/suse-observability-values/templates/sizing_values.yaml \
    --values ./local/suse-observability-values/templates/ingress_values.yaml \
    --values ./local/suse-observability-values/templates/otel_values.yaml \
    --values ./local/suse-observability-values/templates/authentication.yaml
...
coalesce.go:286: warning: cannot overwrite table with non table for suse-observability.opentelemetry-collector.config.receivers.jaeger (map[protocols:map[grpc:map[endpoint:${env:MY_POD_IP}:14250] thrift_compact:map[endpoint:${env:MY_POD_IP}:6831] thrift_http:map[endpoint:${env:MY_POD_IP}:14268]]])
coalesce.go:286: warning: cannot overwrite table with non table for suse-observability.opentelemetry-collector.config.receivers.prometheus (map[config:map[scrape_configs:[map[job_name:opentelemetry-collector scrape_interval:10s static_configs:[map[targets:[${env:MY_POD_IP}:8888]]]]]]])
coalesce.go:286: warning: cannot overwrite table with non table for suse-observability.opentelemetry-collector.config.receivers.zipkin (map[endpoint:${env:MY_POD_IP}:9411])
Error: values don't meet the specifications of the schema(s) in the following chart(s):
opentelemetry-collector:
- (root): Additional property exporters is not allowed
- service: Additional property extensions is not allowed```
with otel_values.yaml:
```opentelemetry:
  enabled: true
opentelemetry-collector:
  extraEnvsFrom:
    - secretRef:
        name: open-telemetry-collector

  config:
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    extensions:
      # Use the API key from the env for authentication
      bearertokenauth:
        scheme: SUSEObservability
        token: "${env:API_KEY}"
  exporters:
    nop: {}
    otlp/suse-observability:
      auth:
        authenticator: bearertokenauth
      # Put in your own otlp endpoint, for example suse-observability.my.company.com:443
      endpoint: otlp-obs.demo.suselabs.net
      compression: snappy
  service:
    extensions: [ health_check,  bearertokenauth ]

  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/proxy-body-size: "50m"
      nginx.ingress.kubernetes.io/backend-protocol: GRPC
      cert-manager.io/cluster-issuer: selfsigned-issuer
    hosts:
      - host: otlp-obs.demo.suselabs.net
        paths:
          - path: /
            pathType: Prefix
            port: 4317
    tls:
      - hosts:
          - otlp-obs.demo.suselabs.net
        secretName: otlp-tls-secret
    additionalIngresses:
      - name: otlp-http
        annotations:
          nginx.ingress.kubernetes.io/proxy-body-size: "50m"
          cert-manager.io/cluster-issuer: selfsigned-issuer
        hosts:
          - host: otlp-http-obs.demo.suselabs.net
            paths:
              - path: /
                pathType: Prefix
                port: 4318
        tls:
          - hosts:
              - otlp-http-obs.demo.suselabs.net
            secretName: otlp-http-tls-secret
---```

---

**Remco Beckers** (2025-06-04 11:12):
Are you trying to install SUSE Observability or the OTEL collector in a cluster you're monitoring?

---

**Remco Beckers** (2025-06-04 11:12):
The documentation I linked to is about installing an otel collector  in a cluster you want to monitor. But the helm command you now shared is to install SUSE Observability

---

**Graham Hares** (2025-06-04 11:14):
This is a cluster that is dedicated to SUSE Observability with the otel stackpack added, remote clusters have the receiver agent installed, one has SUSE AI to send otel back

---

**Graham Hares** (2025-06-04 11:14):
just focusing on getting the SUSE Observability cluster deployed correctly atm

---

**Remco Beckers** (2025-06-04 11:15):
The only customizations that are needed (and that are possible) on the otel collector that's part of SUSE Observability is the ingress section. The rest should not be customized because it is used to store data in our internal databases.

---

**Remco Beckers** (2025-06-04 11:16):
In short, in the `opentelemetry-collector:` section you should only keep the `ingress:` and `additionalIngress:` parts and remove the rest.

---

**Graham Hares** (2025-06-04 11:17):
Oh okay, miss-understood, sorry, so by default it's expecting the remote cluster to use the auth extension config

---

**Graham Hares** (2025-06-04 11:17):
That's what I had before, I'll rip it out again :slightly_smiling_face:

---

**Remco Beckers** (2025-06-04 11:18):
The documentation I linked to earlier is to configure a collector in a remote cluster that you want to monitor, but I guess you already have that setup as part of the SUSE AI setup

---

**Graham Hares** (2025-06-04 11:19):
I do, but I don't think it works as is though, unless I miss-understood that too :slightly_smiling_face:

---

**Graham Hares** (2025-06-04 11:19):
I'll fix the obs deployment and move on to it..

---

**Nico Lamberti** (2025-06-04 12:27):
Hi Team, Is there an API for querying data? Customer would like to build a simple external dashboard with Grafana to visualize the health status. Then, for analysis, they will dive into Observability. Any documentation, etc. available? (fyi @Dominik Mathern) BR Nico

---

**Marc Rua Herrera** (2025-06-04 12:32):
Hey team,

We know there are different predefined HA profiles available, but for a customer case (NN), we’re looking into creating a more tailored deployment that ensures maximum stability.

To do that, we want to better understand the available configuration options beyond just sizing. There are several parameters in the profiles (see attached screenshot) that we’re not fully familiar with.

Could someone help explain what these options are for and how they impact the deployment, so we can tweak them if needed for a more stable and custom setup?

Thanks in advance.

---

**Frank van Lankvelt** (2025-06-04 12:34):
you can use SUSE Observability as a Grafana DataSource: https://docs.stackstate.com/metrics/advanced-metrics/k8s-stackstate-grafana-datasource

---

**Frank van Lankvelt** (2025-06-04 12:36):
though this is just the metric data that is collected - you seem to be looking for something else.  Don't think this is a scenario we'll put any energy into supporting

---

**Nico Lamberti** (2025-06-04 12:59):
Thank you Frank - Maybe to put the question more simply - where can I find the API documentation - where data can be export/retrieve  from the observability area and in which format. this should be enough for them to evaluate.

---

**Louis Lotter** (2025-06-04 13:35):
@Bram Schuur would it not be best for you or @Alejandro Acevedo Osorio to collaborate with Marc a bit here ?

---

**Louis Lotter** (2025-06-04 13:35):
maybe pull in @Alessio Biancalana, @Fedor Zhdanov or @Deon Taljaard as well so they can learn more about this stuff

---

**Bram Schuur** (2025-06-04 14:37):
Maybe, although it will take quite some time to explain this with the right context. Also: I'd rather have NN tell us what stability scenarios they are interested in and we can turn that into a profile. Maybe in the short term they are happy tinkering with the platform, but in the long run, we're going to have to give additional support there and most likely less rather than a more stable system.

---

**Bram Schuur** (2025-06-04 14:37):
We can also discuss this on discord some moment

---

**Alejandro Acevedo Osorio** (2025-06-04 16:07):
Agreed, it will be easier to discuss that explain all those flags on slack, and agreed that I'd like to understand the motivation to deviate/customise the profile

---

**Marc Rua Herrera** (2025-06-04 16:29):
Thanks all. I understand your points, and I agree it makes sense to align live rather than try to go through everything over Slack.
What I proposed to NN was to start from one of the default profiles and help adjust it if needed.
That said, they’re quite advanced and have a good level of knowledge. Yoland specifically mentioned he’d prefer to understand the details so they’re not dependent on us if things change on their end (e.g. new clusters, additional data sources, etc.).
On top of that, I’m also working with Bosch, who are already using the largest profile (4000-ha), and they’re running into issues with the sync pods. One of their main questions is how to scale the config to avoid resource constraints going forward.
So getting a deeper understanding of this would help me support both these cases — and likely others in the future.
Happy to jump on a call or Discord to go through it together.

---

**Bram Schuur** (2025-06-04 16:31):
Coolio, i booked a meeting for tomorrow, we have enough to chat about including the bosch question

---

**Marc Rua Herrera** (2025-06-04 16:39):
Thank you Bram!

---

**Deon Taljaard** (2025-06-04 16:42):
Could you invite me to that meeting, please?

---

**Deon Taljaard** (2025-06-04 16:46):
Thanks. I see I probably won't be able to make it (need to attend to a private matter during that time tomorrow). Could you record the session?

---

**Bram Schuur** (2025-06-04 16:46):
Will do:+1:

---

**Garrick Tam** (2025-06-04 18:24):
Is the only way to rename a Kubernetes StackPacks Instance (cluster) is to uninstall and reinstall with updated Kubernetes Cluster Name?

---

**Bram Schuur** (2025-06-04 19:28):
Yes, this is the only way

---

**Garrick Tam** (2025-06-04 19:30):
Thank you for the quick confirmation.

---

**Frank van Lankvelt** (2025-06-04 19:48):
Most of our api is documented in an OpenAPI spec - https://github.com/StackVista/stackstate-openapi (https://github.com/StackVista/stackstate-openapi) .  Note that it is not something we actively try to keep backwards compatible, but extend and modify as the product evolves.  A lot of APIs rarely change though.
Probably the best way to get real examples of the usage is to look at the requests the frontend sends - it uses this same OpenAPI spec.

---

**IHAC** (2025-06-05 01:04):
@Garrick Tam has a question.

:customer:  Fortinet

:facts-2: *Problem (symptom):*  
Current authentication mechanisms does not include SAML.  (https://docs.stackstate.com/self-hosted-setup/security/authentication/authentication_options)

Is SAML planned for future support?

---

**Remco Beckers** (2025-06-05 08:48):
At the moment there are no plans to support SAML.

---

**Remco Beckers** (2025-06-05 08:50):
We are working on authentication (and authorization) integration with Rancher (i.e. Rancher as authentication provider for SUSE Observability). And I believe Rancher does support SAML. So when that's released they should be able to use that mechanism to authenticate via SAML

---

**Daniel Barra** (2025-06-05 15:17):
*We are pleased to announce the release of 2.3.4, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.4).*

---

**Ala Eddin Eltai** (2025-06-05 16:03):
Is there a JIRA for the integration of rancher authentication in suse obs ?

---

**Remco Beckers** (2025-06-05 16:27):
There is not a single JIRA ticket. In our own Jira we have an epic to implement Rancher authentication + authorization (we plan to release this together) and in Rancher there are several tickets for implementing an OIDC Provider in Rancher. This is our epic ticket https://stackstate.atlassian.net/browse/STAC-21788, but it depends on the OIDC provider in Rancher being released. That is planned for the 2.12 release. This is the EPIC issue on Rancher: https://github.com/rancher/rancher/issues/49571

---

**Nico Lamberti** (2025-06-06 14:22):
Thank you Frank :green_heart:

---

**Gabriel Lins** (2025-06-06 16:00):
Hey @Frank van Lankvelt! I have defined an prometheus exporter to opencost. Now, i'm trying to get this metrics in observability.
Do you know how to do that? Is there any documentation regarding that?

---

**Frank van Lankvelt** (2025-06-06 16:01):
the way to do that would be to use the "remote write" endpoint - fully prometheus compatible: https://docs.stackstate.com/metrics/advanced-metrics/k8s-prometheus-remote-write

---

**Graham Hares** (2025-06-06 16:25):
Just following up from above, I created a test single node instance observability deployment and deployed my otlp ingress after the suse-observability chart deployment, created a test namespace for the exporters and got it working using the otlp-http with post 80 and the host based ingress.  Main issue I had in the end was that I hadn't opened up port 80 on the aws load balancer.  Appreciate the help :slightly_smiling_face: :thankyou:

---

**Graham Hares** (2025-06-06 17:22):
On an all-in-one suse-observability test noticed the agent-logs-agent pod failing with:
```gmini [aws-suse-observability]$ k -n suse-observability logs pod/suse-observability-agent-logs-agent-kzspk
level=info ts=2025-06-06T15:17:05.587855504Z caller=promtail.go:133 msg="Reloading configuration file" md5sum=897697f2543df939b96bc47ec2cdb91c
level=error ts=2025-06-06T15:17:05.588096571Z caller=main.go:170 msg="error creating promtail" error="failed to make file target manager: too many open files"```
trying to up fs.inotify.max_user_instances from 128 to 1024 but wondered if there was other preferred tuning? ty

---

**Graham Hares** (2025-06-06 17:24):
Seems stable now :thumbs-up:
Added this to my host config:
```# Tuning
# Environment: promtail 2.9.8 on amd64 EC2
echo "fs.inotify.max_user_instances = 1024" | tee -a /etc/sysctl.conf
sysctl -p
sysctl fs.inotify```

---

**Gabriel Lins** (2025-06-06 21:17):
Nice!! I'm almost there, but for some reason i can't visualize the metrics through observability. At this moment I could verify that:
1. My opencost sending metrics to a prometheus 
2. Prometheus sending metrics to 'stackstate'  via remote_write with no errors
3. But can't figure out where to get my metrics via observability UI
The screnshoots below shows that
1-promql to remote_storage defined as observability URL getting hits
2-promql from opencost received
3-no errors in sending samples do observability

---

**Zia Rehman** (2025-06-09 11:20):
Hi, @Mark Bakker  @Louis Lotter is there any solution for the above query?

---

**Davide Rutigliano** (2025-06-10 10:55):
Hello Team, as I don't have access to stackstate jira and I can't see the status of STAC-22771 (https://stackstate.atlassian.net/browse/STAC-22771) can I kindly ask anyone for an update on the ticket (access to jira would be even better)?

---

**Louis Lotter** (2025-06-10 11:10):
@Zia Rehman Can I schedule a call with you ?. I'm sure we can handle this together.

---

**Louis Lotter** (2025-06-10 11:17):
This has not been picked up yet Davide. I'll check with the team if this is hard to fix and when we could take a look.

---

**Davide Rutigliano** (2025-06-10 11:22):
Thanks for the update @Louis Lotter!

---

**Zia Rehman** (2025-06-10 11:36):
Hi @Louis Lotter yup sure. You can schedule at your prefered time.

---

**Ala Eddin Eltai** (2025-06-10 11:36):
GM Team,
IHAC who has setup microsoft entra id (oidc) as authentication and is running into problems:
• There are users of the admin group which are able to login
• BUT there a users who cant login which are part of the same ad-group
Did someone observe something similar so far with the stackstate authentication ?

---

**Dominic Giebert** (2025-06-10 12:02):
A customer of ours want to use Observability in partially connected scenario, since I am not an expert on StackState yet is there a way to buffer until the agent is able to send the data?

---

**Marc Rua Herrera** (2025-06-10 12:11):
Bosch have like 150 cluster like this :sweat_smile:

---

**Alessio Biancalana** (2025-06-10 12:13):
what do you mean as buffer? What kind of partial connectivity do they have?

---

**Vladimir Iliakov** (2025-06-10 12:17):
The groups are returned in the access token, as far as I know it is not possible to check a token at Microsoft Entra ID's side.
@Remco Beckers does API log anything that can be useful to troubleshoot it?

@Ala Eddin Eltai Can the User check the logs of the API for any clues?
Microsoft Entra ID is a complex thing and configurations may vary, maybe the User can find the relevant differences between those who can log in and who can't.

---

**Alejandro Acevedo Osorio** (2025-06-10 12:18):
The ones from the image are the ones already onboarded into SUSE Observability?

---

**Bram Schuur** (2025-06-10 12:18):
Right now SUSE Observability is a (near) realtime platform, designed to continuously observe data and troubleshoot issues as they arise. We have gotten some gentle nudges to look at (tiny) edge usecases where data is coming at less regular intervals or only when something is wrong, but this is for now nt on an immediate roadmap

---

**Bram Schuur** (2025-06-10 12:19):
@Mark Bakker @Remco Beckers feel free to chime in

---

**Louis Lotter** (2025-06-10 12:23):
Hi Davide. This issue will take some time to be prioritised as it's significant effort and you are the first to encounter it. We do want it fixed of course but we are juggling many priorities atm.

---

**Marc Rua Herrera** (2025-06-10 12:29):
This is just an example of the cluster sizing they have

---

**Marc Rua Herrera** (2025-06-10 12:29):
But this are real clusters:

---

**Dominic Giebert** (2025-06-10 12:30):
@Giuseppe Cozzolino this would also mean our friends can’t use it.

---

**Marc Rua Herrera** (2025-06-10 12:31):
The platform is not working any longer. Health States missing, sync pod crashing, and also some errors in the Zookeeper. These are 30 cluster and they have 150 in production env + they want to add open telemetry

---

**Mark Bakker** (2025-06-10 12:45):
This is correct, we don't have anything planned for this kind of setup. It will also not fit our near term roadmap. So not something we expect anytime soon.

---

**Dominic Giebert** (2025-06-10 12:46):
Good to know :+1:

---

**Giuseppe Cozzolino** (2025-06-10 13:01):
Hi @Dominic Giebert, I remember we involved someone from StackState, why no one shared this with us before?

---

**Alejandro Acevedo Osorio** (2025-06-10 13:09):
Those `30` clusters they have now, to how many `default nodes` (4 vCPUs and 16GB of memory) are they equivalent? ... Just from the `13` shown in the screenshot I already get to `1167` default nodes.
It sounds quite something those `150` production clusters. For sure the best is what Bram suggested with the strong/close collaboration with them

---

**Ala Eddin Eltai** (2025-06-10 13:09):
@Vladimir Iliakov I'll see the customer this week will try to get to the logs

---

**Remco Beckers** (2025-06-10 13:13):
If they want to see what groups are seen by SUSE Observability there is documentation to enable debug logging for authentication here: https://docs.stackstate.com/self-hosted-setup/security/authentication/troubleshooting. Just be aware that this will dump the entire requests included the (secret) tokens that are part of the oidc flow. So you want to disable it as soon as you're done debugging.

---

**Mark Bakker** (2025-06-10 13:57):
To be clear, at the moment the agent buffers, but this is only to solve temporary issues with connectivity, it will also mean that the topology will not be updated during or after that period, it will be updated at the moment data will flow in. Metrics, traces and logs should just backfill as long as the agent buffer is not filled.
This still means that this is only meant for small connectivity issues, not as a feature to send only sometimes. @Bram Schuur did I explain this correct?

---

**Marc Rua Herrera** (2025-06-10 14:04):
Exaclty, and this image only shows 13 out of the 29 clusters they already have installed

---

**Dinesh Chandra** (2025-06-10 15:13):
Hi Team, One of my customer has couple of questions need help with
1. Rancher service latency is mostly 20m and cluster status for Rancher cluster is not clear because of the monitor (HTTP - response time - is above 3 seconds). I also noticed same in my lab as well as other customers. I guess this could be due to different charts etc getting refreshed. Is there a way to identify what might be causing this latency?
2. Is there any way to exclude Rancher service from this Monitor or creating new Monitor which would exclude specific Rancher service?

---

**Gabriel Lins** (2025-06-10 15:44):
Hey! Could someone here help me with `remote_write` to observability? I'm almost getting there, but maybe I'm forgetting something.

---

**Remco Beckers** (2025-06-10 15:48):
We don't really a preferred tuning. This is also dependent on what is running on the node next to the logs agent. The only way to fix it is to indeed increase the ulimits.

---

**Niel Bornstein** (2025-06-10 15:49):
For a demo/poc of SObservability for SVirtualization, can I install SO on the SV bare metal RKE2 cluster or does it need to be in a separate cluster?

---

**Javier Lagos** (2025-06-10 16:00):
I am currently managing one customer case with the same alert happening on just one of all the monitored cluster. We have seen that rancher is working fine without issues even when the latency is high and on this cluster there is nothing than just rancher deployed on it.

One important thing I saw during a call with them is that Rancher latency can be seen only on the local rancher that is managing multiple downstream clusters but not on the downstream clusters. Is what I have just said the same on your side @Dinesh Chandra?  Maybe this latency is something that can be expected for upstream rancher clusters? What are your thoughts about it @Remco Beckers?

On the other side, It is possible to exclude rancher system of being analyzed by adding an annotation to the rancher service on cattle-system namespace https://docs.stackstate.com/monitors-and-alerts/customize/k8s-override-monitor-arguments

In my case I have executed the following command to exclude rancher from the http monitor in my local cluster.

``` kubectl annotate service -n cattle-system rancher \
  monitor.kubernetes-v2.stackstate.io/http-response-time='{ (http://monitor.kubernetes-v2.stackstate.io/http-response-time='{)
    "threshold": 0.0,
    "failureState": "CRITICAL",
    "enabled": false
  }'```

---

**Graham Hares** (2025-06-10 16:02):
Thanks @Remco Beckers a single test node is a crazy thing tbf :slightly_smiling_face:

---

**Remco Beckers** (2025-06-10 16:02):
Let me have a look in our test setup. This is a work around that will work indeed but it is unexpected that it is needed at all

---

**Graham Hares** (2025-06-10 16:13):
Question on license codes please, are SCC generated subscription codes linked with SUSE Observability now?, remember a few months back that was in the pipe
If they are, can an SA generate an NFR subscription on a partner's account for a PoC (partner to evaluate, not end user) and what's the process for that, is the subscription key value simply compatible to add to the helm template license field? ty

---

**Remco Beckers** (2025-06-10 16:14):
I see the same behavior on our test setup, the monitor just doesn't go red because we don't have enough requests hitting the 20s mark (or &gt;3s).

---

**Javier Lagos** (2025-06-10 16:19):
Thanks for checking @Remco Beckers!

Does that mean then that this rancher latency is an expected behavior? Can we consider this as known behavior of rancher so we can safely disable http monitor on rancher pods?

At least on the case I'm currently managing the customer is receiving more than 30 alerts per day about the same HTTP request on rancher pods which is creating a lot of noise and, for that reason, the customer has decided to disable the monitor but it would be great if we can confirm the situation and next steps to be taken by the product. Maybe we can monitor rancher pods in a different way by default.

---

**Remco Beckers** (2025-06-10 16:22):
I'm still checking, I find the latency quite excessive and I'm wondering if we're not looking at a bug where the websockets used by Rancher get reported as slow responses (and getting cut-off at 20 seconds). But that's just a hunch for now.

---

**Remco Beckers** (2025-06-10 16:23):
With the annotation in place they should be able to keep the monitor enabled

---

**tiernan.ohalmhain** (2025-06-10 16:24):
Still in the pipeline afaik. Eval codes are not currently supported for Cloud Native products, and all PoCs need to be done via $0 quote - this is also being worked on as far as I know.

---

**Bram Schuur** (2025-06-10 16:25):
Could you describe the problem you are facing? What status codes are you seeing?

---

**Javier Lagos** (2025-06-10 16:25):
Shouldn't we have an internal ticket for this research? I can create it if needed with all the info so we can comment to our customers in case they do have the same alert on rancher pods that this is being analyzed internally as we have been able to reproduce it on our lab. In the meantime we can recommend to disable monitor http request on rancher.

---

**Graham Hares** (2025-06-10 16:27):
Thank you @tiernan.ohalmhain would the key obtained via the $0 quote be a time limited one, not sure how the internal logic works, thinking 3 months would be a good length of time for a partner to mobilise

---

**Bram Schuur** (2025-06-10 16:27):
@Ravan Naidoo maybe you can give guidance here? The SUSE Observability team is not actively working on Harvester integration, but maybe the harvester team is? Or is there a demo being worked on?

---

**Niel Bornstein** (2025-06-10 16:27):
I am looking at https://www.suse.com/c/monitoring-suse-virtualization-environment/

---

**tiernan.ohalmhain** (2025-06-10 16:28):
Depends on what's stuck on the quote I imagine, I'm not sure how that's handled - that's done by the SPR team. I know evals have a max of 120 days, so that's probably the most that can be done on $0 quotes as well? Either way, the SCC team will still need to manually replace the key with the proper one.

---

**Ravan Naidoo** (2025-06-10 16:38):
Hi Niel.  The article you referring to was just to show basic Open Telemetry integration.  In the mean time, I’ve written a more complete integration with VM topology.  See https://github.com/ravan/so-virt/blob/main/setup/README.MD

I’ve sent you an email with creds to a demo environment where you can see it all working.

For your demo setup, I guess you could install SUSE Observability on your SUSE Virtualization cluster if the specs meet the trial requirements: https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#requirements

---

**Niel Bornstein** (2025-06-10 16:42):
Thanks! To let you know the use case, I am working with HPE managed services on a demo for Home Depot and they want to use OpsRamp but there is no integration with kubevirt/Harvester (only RKE2 or Prometheus), so I'd like them to see what we can bring to the party.

---

**Gabriel Lins** (2025-06-10 16:49):
I'm trying to visualize OpenCost metrics, exported by Prometheus, in SUSE Observability, but I'm unable to see them in the UI.
I have already verified that:
1. OpenCost is correctly sending metrics to Prometheus.
2. Prometheus is forwarding metrics to the SUSE Observability `remote_write` endpoint without errors.
However, I can't seem to find the metrics anywhere in the SUSE Observability UI. The attached screenshots confirm that the `remote_write` is active and that samples are being sent successfully.

Could you help me understand what might be missing or where to look for these metrics?

---

**Bram Schuur** (2025-06-10 16:52):
Your best bet is the metrics explorer to find your metric, it has autocomplete: &lt;your_instance&gt;/#/metrics

---

**Bram Schuur** (2025-06-10 16:53):
I am wondering about the `https://observability.app.stackstate.io`, is this your saas instance? Or a local dns record?

---

**Gabriel Lins** (2025-06-10 16:58):
Hmm, it's supposed to be a different URL. I'll investigate, as that is probably the problem. Thanks

---

**Remco Beckers** (2025-06-10 16:59):
That seems ok to me. Where would you create the ticket though? We're using our own Jira https://stackstate.atlassian.net/jira and are creating a ticket to look into this in more detail (first investigation shows websockets used by Rancher could accidentally be included in the latency calculation and they are usually long-lived). But that ticket won't be readily accessible for everyone

---

**Gabriel Lins** (2025-06-10 17:35):
@Bram Schuur I have changed to observability.demolab.latam (my local DNS for observability) and prometheus is showing that is connected, but not yet getting the metrics via "Explore metrics" in UI

---

**Gabriel Lins** (2025-06-10 17:37):
Changed the remote_write url to the correct one

---

**Gabriel Lins** (2025-06-10 17:38):
Trying to catch the "node_cpu_hourly_cost" opencost's metric in Observability but returning nothing

---

**Bram Schuur** (2025-06-10 17:42):
What do you mean with catch?

Yourlast example shows a 401, authentication not provided, are you putting the api key for authentication?

---

**Gabriel Lins** (2025-06-10 18:17):
With "catch" I mean "query" . Sorry!
 The terminal example is a `curl -k -v -X POST -H "Content-Type: application/x-protobuf" -H "X-Prometheus-Remote-Write-Version: 0.1.0" --data-binary "" "https://observability.demolab.latam/receiver/prometheus/api/v1/write"`  just to represent the metrics being sent. I'm just testing if the endpoint receives the POST correctly and don't effectly trying to send it.

---

**Gabriel Lins** (2025-06-10 19:27):
I did it! From my side it was a problem regarding the URL provided. As I don't have a valid ingress tls certificate, using https was a problem. Changed to http and internal domain request and worked. Thanks @Bram Schuur

---

**Bram Schuur** (2025-06-10 19:44):
:+1: Good job

---

**Javier Lagos** (2025-06-10 20:53):
I think that creating an internal Stackstate case will be enough for most of the situations. I have already created a Bug jira case with as many details as possible on your jira board.

Can you @Remco Beckers please take a look at it and let me know if you need anything else? https://stackstate.atlassian.net/browse/STAC-22887

I really appreciate your help! Thanks!

---

**Dinesh Chandra** (2025-06-10 22:59):
Thanks @Javier Lagos and @Remco Beckers for help. For now annotation helps and good enough for customer.

---

**Surya Boorlu** (2025-06-11 06:46):
@Bram Schuur I got a query regarding GPU monitoring from customer NowCom Corporation.

---

**Louis Lotter** (2025-06-11 08:32):
@Remco Beckers @Mark Bakker @Andreas Prins https://www.honeycomb.io/blog/its-the-end-of-observability-as-we-know-it-and-i-feel-fine

---

**Remco Beckers** (2025-06-11 08:43):
That's definitely Claude indeed. I get a very similar result with using only our Metrics API from Claude on our Sock-shop demo scenario:

&gt; :mag: *Investigation Summary - FIRST POTENTIAL CAUSE IDENTIFIED*
&gt; *Root Cause: Severe CPU Throttling in Catalogue Service*
&gt; *Key Findings:*
&gt; 1. *catalogue* deployment had *2 container restarts* in the past 30 minutes
&gt; 2. *Massive CPU throttling* occurring:
&gt;     ◦ catalogue containers: ~*2,000,000+ throttles/second*
&gt;     ◦ catalogue-db: ~*5,300,000 throttles/second*
&gt; 3. *Very restrictive CPU limits*:
&gt;     ◦ catalogue: Only *0.1 CPU cores* limit
&gt;     ◦ catalogue-db: 1.0 CPU cores limit
&gt; 4. Evidence of deployment activity (two different catalogue replicasets running)
&gt; *Impact:* The catalogue service is the core component for product listings in a sock-shop application. When it's CPU-starved and throttled, it will cause:
&gt; • Slow response times for product catalog requests
&gt; • Cascading delays throughout the application
&gt; • Poor user experience with slow page loads
&gt; *Recommended Actions:*
&gt; 1. *Immediate*: Increase CPU limits for catalogue containers (from 0.1 to at least 0.5-1.0 cores)
&gt; 2. *Monitor*: Check if catalogue-db also needs higher limits despite having 1.0 core
&gt; 3. *Investigate*: The deployment activity and container restarts around the incident time
That's where I stopped it, but it would continue (and run out of context and/or tokens)

---

**Remco Beckers** (2025-06-11 08:44):
The title is a bit click-bait though, there'll still be a place for the existing UIs. Even if it is just for showing the LLM results to the users

---

**Andreas Prins** (2025-06-11 08:58):
lol, he still thinks you need to be nice to LLMs, starting with please :smile:

---

**Andreas Prins** (2025-06-11 08:59):
sorry for picking this small detail, I think context will be king. but hey, we still need to invest in it

---

**Mark Bakker** (2025-06-11 09:08):
Thanks for sharing

---

**Bram Schuur** (2025-06-11 09:10):
Thanks for reporting and filing the ticket  @Dinesh Chandra @Javier Lagos. I pulled it into our sprint immediately to be worked on

---

**David Noland** (2025-06-12 03:39):
Sorry for the late response on this, but seeing similar behavior on our hosted rancher setup. Not only rancher service, but other services showing 20s HTTP latency and in "Critical" health.

---

**Daniel Murga** (2025-06-12 07:49):
Hi @Davide Rutigliano @Louis Lotter I will provide updates to the SCC case! Thanks! https://scc.suse.com/support/cases/01583525

---

**Remco Beckers** (2025-06-12 09:15):
We've found the cause and a fix is being made

---

**Dinesh Chandra** (2025-06-12 09:19):
Thanks @Remco Beckers world is waiting for the fix :)

---

**Javier Lagos** (2025-06-12 09:19):
Just for curiosity @Remco Beckers, May I know what was the root cause? I have a meeting with the customer today and it would be great if I can give him those details.

---

**Remco Beckers** (2025-06-12 09:21):
It's what I mentioned in a previous message: websocket connections (that keep a connection open for a long time) were included in the latency of HTTP responses (a websocket requests starts as a normal HTTP requests to get upgraded later to a websocket).

---

**Cyril Cuvier** (2025-06-12 10:56):
Hi team, for a customer willing to install Observability on a dedicated cluster on premise, should they purchase additional Rancher Prime subscription for this cluster or is it covered like the RMS cluster ?

---

**Amol Kharche** (2025-06-12 10:57):
Can you please share customer name ? I can quickly check

---

**Cyril Cuvier** (2025-06-12 10:58):
DOXALIA but I have this question from various Rancher Prime customer

---

**Amol Kharche** (2025-06-12 11:01):
They have SUSE Observability subscription and license key on SCC portal.

---

**Amol Kharche** (2025-06-12 11:03):
I believe it comes with the Rancher Prime subscription, but I'm not entirely sure. @Louis Lotter could you please confirm if it's included in the Rancher Prime subscription?

---

**Cyril Cuvier** (2025-06-12 11:05):
Coming with Prime is a fact but from a purchasing perspective do they have to pay for the nodes that will host it when deployed on premise or is it free of extra Rancher Prime subscription for this cluster ?

---

**Amol Kharche** (2025-06-12 11:28):
I am not sure.

---

**Amol Kharche** (2025-06-12 11:30):
Can you please post your question in <#C02AYV7UJSD|> channel.

---

**Amol Kharche** (2025-06-12 12:00):
https://suse.slack.com/archives/C02AYV7UJSD/p1749722177694809?thread_ts=1749722128.130639&amp;cid=C02AYV7UJSD
@Louis Lotter can you please help here or tag someone. I am unsure about per node subscription

---

**Mark Bakker** (2025-06-12 12:17):
Rancher prime included the management servers without license costs for those. Observability is part of the management servers.

---

**Cyril Cuvier** (2025-06-12 12:19):
thanks Mark, does that means Observability backend must be deployed on the same cluster as the RMS or another dedicated cluster ? (purely from a subscription compliance perspective )

---

**Mark Bakker** (2025-06-12 12:19):
No it should be deployed on a seperate cluster it just means you dont need extra licenses for those nodes

---

**Cyril Cuvier** (2025-06-12 12:20):
perfectly clear

---

**Gabriel Lins** (2025-06-12 15:01):
@Mark Bakker, this raises a follow-up question: If a customer runs other applications on the same nodes as the observability stack, how should that be factored into our resource planning? Should we recommend tainting these nodes to dedicate them to observability workloads, similar to how infra-nodes are used in OCP?

---

**Gustavo Varela** (2025-06-12 15:39):
are we planning virtualization support ? for when ? will we have correlation betwen vm, container and the rest of the data ?

---

**Mark Bakker** (2025-06-12 15:55):
In that case those nodes are just billable

---

**Mark Bakker** (2025-06-12 15:56):
Or indeed tainting them

---

**Gabriel Lins** (2025-06-12 15:56):
Clear, ok!

---

**Dinesh Chandra** (2025-06-13 00:04):
One of my customer wants to send notification from specific cluster and specific namespace. If customer select tags `cluster:lab, namespace:test` in the notification it works as OR function and any match is sent as notification to destination.
Customer is looking of AND function so only specific namespace from selected cluster selected as notification source. What is best way to achieve this?

---

**Bram Schuur** (2025-06-13 07:40):
This is a known bug, that will be picked up hopefully next, but otherwise the sprint after: https://stackstate.atlassian.net/browse/STAC-22716 (https://stackstate.atlassian.net/browse/STAC-22716)

---

**Dinesh Chandra** (2025-06-13 07:57):
Thanks @Bram Schuur

---

**Martin Weiss** (2025-06-13 09:41):
It would be great to get a bit more details on how much data we can buffer / when we start to loose data.. basically this is more or less the same challenge we have / had with fluentd :wink:

---

**Mark Bakker** (2025-06-13 10:00):
@Bram Schuur I think you can answer this one, as I remember it's configurable but I am not so sure.

---

**Bram Schuur** (2025-06-13 10:11):
From the (process) agent side there is a queue size, defaults to 20, which gives it a 10 mniute buffer. However, the platform does correlation (based on timeouts, ~1.5 minutes), so when the upstream process agent is queuing, there will already be data loss due to late arriving events missing their windows.

There are actually more agents (cluster agent, logs, otel collector, traces) separately with separate behavior i do not know off the top of my head.

I will repeat my earlier statement: The platform is now tailored to real-time monitoring, with slight tolerations for network partitions (e.g. 30seconds), after that various forms of degradation will occur, this is not something easily changed through configuration.

---

**Martin Weiss** (2025-06-13 10:16):
Basically Rancher-Logging / Rancher-Monitoring or any tracing have similar problems - so do we have an answer from a SUSE ECM side of things on "disconnected" / "weak connected" / "sometimes connected" monitoring/logging/tracing? Or don´t offer anything? In this case - what 3rd party solutions could we recommend?

---

**Mark Bakker** (2025-06-13 10:28):
@Martin Weiss from ECM side we indeed don't offer anything for the disconnected cases, I guess the Edge team has better intel on what we can recommend, I don't know solutions which focus on this very well since it's not our main target area.

---

**Martin Weiss** (2025-06-13 10:29):
Seems we are really missing the SUSE internal interoperability between the BUs / silos.. but ok - will ask, there..

---

**Brynn Harrison** (2025-06-13 17:38):
Is it supported yet to use a certificate signed by a private CA for the stackstate baseURL?

---

**Hugo de Vries** (2025-06-13 18:13):
do we already have an MCP server on our roadmap?

---

**Brian Six** (2025-06-13 20:57):
Question from a customer asking if Observability will ever support Oauth creds instead of API keys/Service Tokens?

---

**Mark Bakker** (2025-06-13 23:01):
Not in the really short term, but at the end of the year beginning of the new year AI is a real important part of our roadmap incl. MCP.

---

**Brian Six** (2025-06-14 00:56):
Ran across this and thought that in addition to our Remediation steps we outline, being able to have an AI component to Observability would be a great addition.
https://k8sgpt.ai/

---

**Eric Lajoie** (2025-06-15 01:25):
@Mark Bakker do you know who can give me a one year or more permanent license key for observability as the one shared in this chat back in August last year is no longer active.

---

**Eric Lajoie** (2025-06-15 01:26):
As a side note, how can a SUSE AI users get their license as I dont see any way in SCC to get it unless I am missing a tab or link.

---

**Eric Lajoie** (2025-06-15 03:56):
Do we have a self-serve model for internal licenses? I see this as a must for SAs and DSAs.

---

**Louis Lotter** (2025-06-16 08:42):
We have pinned a new key

---

**Louis Lotter** (2025-06-16 08:43):
What do you mean with a self-serve model ? Do you want access to generating these licenses yourself ?

---

**Mark Bakker** (2025-06-16 09:15):
In the <#C07U0P4CE76|> SAs and DSAs can find a pinned key they can use.

---

**Mark Bakker** (2025-06-16 09:15):
@Eric Lajoie

---

**Eric Lajoie** (2025-06-16 09:56):
Thank you @Mark Bakker and @Louis Lotter

---

**Marc Rua Herrera** (2025-06-16 10:03):
Good morning, I do have a sync pod in red state after an upgrade on AKS. Logs show a blocked service for a componentWorker 1 and 2. What does this error mean?

---

**Alejandro Acevedo Osorio** (2025-06-16 10:05):
it means it's not making any progress ... and most probably `nnnnn`seconds ago you might find the Exception that produced the blockage

---

**Bram Schuur** (2025-06-16 10:26):
@Mark Bakker question here: this is something the virtualization team will work on right? or is it somehting for the observability team?

---

**Bram Schuur** (2025-06-16 10:39):
we support skipping ssl validation, but not actually validating the certificate:
https://docs.stackstate.com/get-started/k8s-suse-rancher-prime/k8s-suse-rancher-prime-agent-air-gapped#installing-suse-observability-agent

A ticket was filed to improve support there, because we get more questions around this:
https://stackstate.atlassian.net/browse/STAC-22901

---

**Bram Schuur** (2025-06-16 10:40):
This is not on our roadmap right now, could you lay out for me what in what scenario the user would benefit form this?
• Is this in a saas or on-prem scenario?
• What user flow would improve with oauth credentials?

---

**Marc Rua Herrera** (2025-06-16 10:41):
Hey Alex, thanks for the quick response. It starts with few warnings, and then the errors start:

---

**Marc Rua Herrera** (2025-06-16 10:42):
And then, there is few errors like these, and the blocked components start.

---

**Marc Rua Herrera** (2025-06-16 10:44):
This happened right after a AKS upgrade.

---

**Alejandro Acevedo Osorio** (2025-06-16 10:45):
the `NoSuchElementException` over there look like a StackGraph data corruption

---

**Alejandro Acevedo Osorio** (2025-06-16 10:45):
Have you restarted the sync pod? Does it get stuck as well?

---

**Marc Rua Herrera** (2025-06-16 10:45):
Yes, it gets stuck again

---

**Alejandro Acevedo Osorio** (2025-06-16 10:47):
And I guess the Exception where it gets stuck is something similar to `NoSuchElementException` or vertex does not exist

---

**Alejandro Acevedo Osorio** (2025-06-16 10:52):
I guess something went wrong during the upgrade, and here there are a lot of things that play a part,
• ha setup or not
• how was the app cordoned, tear down before the upgrade
• what kind of storage they are using
@Bram Schuur FYI :point_up:

---

**Bram Schuur** (2025-06-16 10:52):
ay, what customer is this?

---

**Marc Rua Herrera** (2025-06-16 10:54):
This is Rabobank. I believe they had the same issue 3 weeks ago and Vladimir was having a look at it.

---

**Bram Schuur** (2025-06-16 11:00):
based on that issue we're now landing work to improve anti-affinity between pods for better stability.

---

**Mark Bakker** (2025-06-16 11:19):
@Gustavo Varela this is something the virtualization team will work on, it's outside of the scope for the Observability team. They provide the platform and extensibility (the later will be changed to make it easier form te virt team to do this in the coming months).

---

**Brian Six** (2025-06-16 17:52):
Customer’s response:

---

**Brian Six** (2025-06-16 17:52):
As an application, when I publish trace/metrics/log data I want to use the oauth credential (like Microsoft Entra Enterprise Application) so that my application and its data can be accurately identified and the data lineage is clear.

 

As the Suse Observability Platform, when I receive data from applications I need to authorization the application sending the data is in fact permitted to send the data and I want to be able to track data lineage [identify the source of the data].  I (Suse Observability) do not want to manage API keys as it is an additional operational support item when every application in my ecosystem will be identified by an Oauth credential.

 

I believe these are both applicable to onprem and saas.

---

**Shaun Gardiner** (2025-06-16 18:50):
odd question: https://www.stackstate.com/ is there any timeline for moving this site to the overall SUSE Branding etc?  Seems odd that in having acquired the company over 1+ year ago there is barely a message or blurb about StackState being a part of SUSE

---

**Emine Uygun** (2025-06-16 19:40):
Hi all, could you please help @Marc Rua Herrera with this? The customer escalated this to me as well. Could we please prioritize this? @Mark Bakker FYI as well :)

---

**John Pugh** (2025-06-16 20:12):
Sore subject it seems. I "think" it's happening, but it's a slow boat.

---

**Bram Schuur** (2025-06-16 20:22):
@Marc Rua Herrera to get them back up and running I'd suggest restoring the backup like they did 3 weeks ago, there is not much else when data is corrupted. We will start a release this sprint to get anti affinity settings released.

---

**Genevieve Cross** (2025-06-16 22:50):
@Shaun Gardiner - Yes! We have plans to decommission the www.stackstate.com (http://www.stackstate.com) site. Before doing so, the Playgound needs to move over to a SUSE domain. These discussions are in process.

---

**Shaun Gardiner** (2025-06-16 22:51):
good news, it just seemed quite odd to me after so long of being a part of the SUSE family that the website shows so little information about SUSE, I would have expected some banner on the front page or something about being acquired etc

---

**Marc Rua Herrera** (2025-06-17 09:40):
Hey Bram, I already suggested restoring the backup, but the team is insisting on understanding the root cause before doing so — they’re concerned that restoring without knowing what caused the issue could just lead to it happening again next week.
Do we know exactly why this happened? From reading the ticket, it’s still not clear to me (or to them) what the underlying issue was.

---

**Rajesh Kumar** (2025-06-17 11:10):
@Gabriel Lins @Frank van Lankvelt I am here as well. I can see the metrics from prometheus in observability metrics section using promql but is it possible to make charts, graphs etc out of it, like we do in grafana?

---

**Frank van Lankvelt** (2025-06-17 11:19):
with the current release you'll need to create `MetricBinding`s - see https://docs.stackstate.com/metrics/custom-charts/k8s-add-charts.  There's a big effort underway to make this a lot easier and to be able to create dashboards.

---

**Rajesh Kumar** (2025-06-17 11:20):
Yeah. I am looking into it.

---

**Rajesh Kumar** (2025-06-17 11:20):
Thank you!

---

**Rajesh Kumar** (2025-06-17 12:44):
These are specifically for kubernetes only I think. I was trying to scrape a simple linux machine.

---

**Aslam Raffee** (2025-06-17 13:02):
do we have anything to offer customer who would like to right size their  downstream cluster environment. Observe the clusters for 30 days and where developers have over commited resources , Vcpu and memory rectify any over commitments ?

---

**Alejandro Acevedo Osorio** (2025-06-17 13:05):
~We have this guide depending on the landscape they want to observe to try to help them choose the sizing for the SUSE Observability instance https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/install-stackstate/requirements.html~

Ooops totally misunderstood the question

---

**Frank van Lankvelt** (2025-06-17 13:43):
the examples on that page are indeed geared towards kubernetes - but MetricBindings work for any kind of component.  Just make sure the topology query matches it

---

**Frank van Lankvelt** (2025-06-17 13:48):
maybe the "Clusters" overview in SUSE Observability is what you're looking for?  It shows the usage of cpu &amp; memory

---

**Jeroen van Erp** (2025-06-17 13:51):
And I think the pod overview to highlight which pods are over-consuming. We don’t have any “auto-correct”, SUSE Observability is read-only and will not auto-change your environment

---

**Rajesh Kumar** (2025-06-17 15:12):
hmm I am lost.. I added metricsbinding. Can you help a bit more. When I go to views I see a blank page with no options to add views or anything. I know I can save views when I am exploring te components like deploy, services etc. But right now I am not scraping any kubernetes resource, its just a linux node. Where to see, how to find and add the view

---

**Frank van Lankvelt** (2025-06-17 15:45):
if you save one of the predefined views as a new view, you can then change the STQL query by going to Filters.

---

**Frank van Lankvelt** (2025-06-17 15:46):
but if this is you're just starting with SUSE Observability, I would recommend going with a Kubernetes cluster first.  Get your bearings and only then start customizing

---

**Rajesh Kumar** (2025-06-17 15:47):
Not the first time, but yeah first time customising things. I have it running in kubernetes and stackpacks in 2 clusters but I was trying to see if we can have non-kubernetes things there as well.

---

**Bram Schuur** (2025-06-17 17:20):
@Marc Rua Herrera if you want to short-circuit the affinity, you can follow the docs here (https://github.com/rancher/stackstate-product-docs/pull/32/files) and use the latest 'internal' version of `suse-observability-values` chart to generate the affinity.yaml and ship that to rabo

---

**Marc Rua Herrera** (2025-06-17 17:22):
Thanks Bram

---

**Bram Schuur** (2025-06-18 09:03):
Np, keep us posted, team borg will start the release to get this fix out officially

---

**Aslam Raffee** (2025-06-18 09:45):
we are competing against https://github.com/robusta-dev/krr

---

**Aslam Raffee** (2025-06-18 09:49):
My customer only deploys open source software, any date or progress I can share with my customer on releasing the code for this solution?

---

**Jeroen van Erp** (2025-06-18 09:52):
This should be relatively simple to do using monitors… Maybe someone in the DSA team could help out writing one of those.

---

**Louis Lotter** (2025-06-18 09:59):
Hi @Aslam Raffee. This is still being discussed and we are hoping we can work on this before year's end.
It's competing with some Epics like RBAC etc. that everyone is asking for though.

---

**Dinesh Chandra** (2025-06-18 10:23):
Is there any configuration required forPV usage or not support?

---

**Jain Joseph** (2025-06-18 11:36):
Hey team, just a quick question around observability, are we able to configure alerts as code ?

---

**Frank van Lankvelt** (2025-06-18 11:40):
quick answer: yes

---

**Jain Joseph** (2025-06-18 11:53):
awesome, thank you @Frank van Lankvelt, just another one aswell if you know, do we have visibility into CRDS?:smiley:

---

**Timothy Choi** (2025-06-18 12:20):
Hello Team.
In the SUSE observability, is there a function like generate pdf file for specific metric information?(such as cluster node's cpu status or memory status)

---

**Frank van Lankvelt** (2025-06-18 12:44):
I don't know if we collect those - we certainly don't map them into views

---

**dieter.reuter** (2025-06-18 13:30):
where do I get a valid internal license key for SUSE AI Observability?
In the docs it states I should use my "Registration Code" for the product "SUSE AI" from SCC. This has the form "INTERNAL-USE-ONLY-efb2-3dab" but is not valid in SUSE Observability, error shown is "The license key is not valid!"
Is this the correct way for the customer/partner as well? I'm just trying to follow our official docs and getting stuck here.

---

**Frank van Lankvelt** (2025-06-18 13:39):
no - we do offer industry-standard APIs to query metric data, so if you can find a tool that generates a pdf from a metric it can very likely be made to work

---

**Remco Beckers** (2025-06-18 13:42):
You'll need a SUSE Observability internal license key. There is one pinned to this channel. We were not involved in the SUSE AI Observability work so I can't tell you how the "Registration code" is supposed to work.

---

**dieter.reuter** (2025-06-18 13:48):
Thanks, the pinned internal license key is working now!

---

**Mark Bakker** (2025-06-18 13:58):
Not yet this is on the roadmap

---

**Timothy Choi** (2025-06-18 14:01):
Thank you. I will try.

---

**Remco Beckers** (2025-06-18 14:04):
I just checked and it is correct that customers should be able to use the Registration code from SCC. Only for internal users that doesn't work

---

**Timothy Choi** (2025-06-18 15:04):
@Frank van Lankvelt with observability, do we have a way to provide predictable resource consumption? Like prometheus predict_linear.

---

**Frank van Lankvelt** (2025-06-18 15:07):
sure you can use predict_linear.  Like all other prometheus functions

---

**Brynn Harrison** (2025-06-18 15:59):
Thanks Bram, I can confirm this works, except if I enable the RBAC feature, there doesn't seem to be a box to skip tls for this component.

---

**Kelly Hair  (1.646.247.3899)** (2025-06-18 19:58):
A buddy sent me via LinkedIn:

https://www.linkedin.com/posts/balkansky_announcing-our-seed-and-series-a-from-sequoia-act/ (https://www.linkedin.com/posts/balkansky_announcing-our-seed-and-series-a-from-sequoia-act/)

---

**Louis Lotter** (2025-06-19 08:57):
the link does not work for me

---

**Deon Taljaard** (2025-06-19 09:31):
Me neither, found this in the meantime: https://www.traversal.com/post/%20launch-announcement

---

**Marc Rua Herrera** (2025-06-19 10:54):
Hi Team, quick question regarding restoring backups. Does the restore of Stackgraph also includes the restore of the configuration? If I want to restore both, which one should I restore first? Does it really matter?

---

**Bram Schuur** (2025-06-19 11:02):
The restore of stackgraph includes the configuration. You do not need to do a separate config backup after, even more strong: i think if you do a config restore it wipes all data (@Remco Beckers can deny/confirm this)

---

**Remco Beckers** (2025-06-19 12:04):
That's correct

---

**Marc Rua Herrera** (2025-06-19 13:50):
I just followed all the steps to do a restore and nothing is restored. Is there any way to troubleshoot that? Any logging I can check?

---

**Remco Beckers** (2025-06-19 14:21):
It is still busy restoring

---

**Remco Beckers** (2025-06-19 14:21):
A stackgraph restore can take a LONG time

---

**Bram Schuur** (2025-06-19 14:21):
that log should include at least some message: 'Done!'. It seems the restore process was terminated early? OOMKilled maybe?

---

**Kelly Hair  (1.646.247.3899)** (2025-06-19 16:09):
Apologies,  I tried to strip out all the tracking bits.

Full URL: https://www.linkedin.com/posts/balkansky_partnering-with-traversal-because-every-activity-7341114420292481024-fKvt?utm_source=share&amp;utm_medium=member_android&amp;rcm=ACoAAABF7wsBEEVApKvzyxgDudwFcQkOmfdsBwo (https://www.linkedin.com/posts/balkansky_partnering-with-traversal-because-every-activity-7341114420292481024-fKvt?utm_source=share&amp;utm_medium=member_android&amp;rcm=ACoAAABF7wsBEEVApKvzyxgDudwFcQkOmfdsBwo)

---

**gaetan.trellu** (2025-06-19 17:42):
Hello o/ I just refreshed my SUSE Observability chart but now I don't  have the CLI/StackPack tabs in the left menu. Any ideas?

---

**Yash Tripathi** (2025-06-19 17:59):
You need to click on the arrow at the bottom, above the Hint: Stackpacks...

---

**Yash Tripathi** (2025-06-19 18:01):
I also find it a little counterintuitive

---

**gaetan.trellu** (2025-06-19 18:02):
Pouaaaaaa xD... Shame on me...

---

**Brian Six** (2025-06-20 05:59):
@Bram Schuur any thoughts on the customers response?

---

**Bram Schuur** (2025-06-20 09:30):
Dear Brian, sorry this slipped my attention. Thanks for gathering the use case, makes sense. 

I made a story now that will put this request on our backlog. We have a meeting Thursday to prioritize, but I am afraid we will not get to this anytime soon due to workload on the team and this being a single customer requesting for this.

 https://stackstate.atlassian.net/browse/STAC-22943 (https://stackstate.atlassian.net/browse/STAC-22943)

---

**Marc Rua Herrera** (2025-06-20 13:15):
We finally succeed with the back up restore. As you pointed, the back up process was interrupted and did not finish, although we don't know why that happened.

---

**Marc Rua Herrera** (2025-06-20 13:16):
Also, as a feedback, for the scale up script that needs to be run after the victoria metrics restore, it scales up the deployments, but not the statefulset. Thus, the victoria metric pods do not spin up unless you do it manually

---

**Hugo de Vries** (2025-06-20 13:16):
Last weekend Rabobank hit a data corruption issue on their new instance. On monday morning they created a ticket (Mitesh Patel), which for them has high priority, ticket# 1489. *They have yet to get their first response.* This customer pays over 800k per year. This is absolutely unacceptable and the process needs to be improved ASAP. Of course this led to another escalation. This is not just related to a payment issue of zendesk. @Sanne Vloon

---

**Owen Lewis** (2025-06-20 13:18):
@Mark Bakker please can you review/advise - thanks

---

**Sanne Vloon** (2025-06-20 13:39):
These customers have the highest priority in The Netherlands in terms of strategic positioning and potential. By not giving them top class support on the current ‘limited’ products, how will we ever position ourselves to become their crucial infrastructure providers? Can we please get a solution? 1 person manually checking tickets besides his day job responsibilities is not enterprise support and definitely not for 800k euros a year. 
Can we provide them with a single Rancher Prime license so they can log tickets in SCC? Are the contracts bound to only receiving support from NL?

---

**Owen Lewis** (2025-06-20 13:49):
Hi Sanne - I agree, it's a poor experience for Rabobank.  Before we look into the Rancher Prime license idea (as the current set up is in place for more than just Rabobank, we are supporting other legacy StackState customer in the same way), @Mark Bakker is there something we can do to make the process more robust, e.g. can we assign other people people to check the queue (e.g. some of the legacy Engineering team in NL), so we don't have a single point of failure?

---

**Mark Bakker** (2025-06-20 14:13):
Before stating things as unacceptable, please ask if we acted on it.
This requests is via Slack actively being supported, see:
https://suse.slack.com/archives/C079ANFDS2C/p1750060990910589
I should indeed also have responded to the ticket. But the support is given. The fact that they had the issue is somethings else, that was a bad user experience

---

**Mark Bakker** (2025-06-20 14:14):
Ps. I would love if we can get support engineers looking into the queue multiple times a day, it does not really fit my work. But I look each day. This ticket I already did see the thread in slack and expected that to resolve the issue. I should have answered, which I will do now.

---

**Louis Lotter** (2025-06-20 14:17):
@Marc Rua Herrera Are you not looking into the Rabobank issue already ?

---

**Hugo de Vries** (2025-06-20 14:18):
From the customers perspective they did not get a reply, that's why they followed up on it today and escalated it. The support process is not hoping that their paid consultant is maybe or maybe not doing some requests on the side via slack. They expect a response and proper follow-up on their support request.

---

**Louis Lotter** (2025-06-20 14:22):
@Hugo de Vries Ok I'll make this my focus and come up with a solution even if I have to take care of it for a bit.

---

**Mark Bakker** (2025-06-20 14:22):
Can you join me and Hugo:
https://meet.google.com/iko-mhce-rqy

---

**Brian Six** (2025-06-20 16:06):
No worries.   Appreciate the consideration.  Perhaps others will trickle in and this would be the first of many.

---

**Benoît Loriot** (2025-06-20 16:40):
Hi, a customer asked this in a RFP
&gt; Our group's Observability solution is powered by Dynatrace. Given that it's a global tool, your Observability solution should provide fine-grained, Kubernetes-specific functionalities.
&gt; However, it must integrate complementarily with our group's offering, both from a functional and architectural perspective (connections and data push to Dynatrace).
Do we have Dynatrace integrations in SUSE Observability, or can we push data to Dynatrace?
I see a doc page (https://docs.stackstate.com/5.1/stackpacks/integrations/dynatrace) about dynatrace stackpack but cannot access the website.

---

**Mark Bakker** (2025-06-20 16:49):
We don't support Dynatrace as an endpoint for our data. We do support webhooks to external tools.

---

**Mark Bakker** (2025-06-20 16:49):
The Dynatrace stackpack is better not to be used, it's only for a few old customers.

---

**Benoît Loriot** (2025-06-20 16:50):
Thanks Mark, can you elaborate on what we can do with webhooks?

---

**Benoît Loriot** (2025-06-20 16:54):
I found the doc page working : https://documentation.suse.com/cloudnative/suse-observability/next/en/use/alerting/notifications/channels/webhook.html
fyi https://docs.stackstate.com/ is not working anymore on my side.

So basically events can trigger webhooks (HTTP POST). So we could imagine sending notifications of some sort to dynatrace for specific events occurences.

---

**Mark Bakker** (2025-06-20 16:54):
Yes indeed

---

**Lasith Haturusinha** (2025-06-20 19:07):
Hi Team,
Quick question relating to the license key for SUSE Observability: Yesterday I installed SUSE Observability and used my SCC Registration key but failed.
It only worked when used the internal registration key? Is this still the case for customers as well? Can they use their SCC Registration Code during deployment?

---

**Lasith Haturusinha** (2025-06-20 19:11):
My 2nd question is:
play.stackstate.com (http://play.stackstate.com) showed three different clusters (with GKE and RKE2) and now it shows only a single cluster. Have we changed from multi-cluster to a single cluster or am I seeing something completely different?
Thanks : )

---

**Mark Bakker** (2025-06-20 19:23):
Customers can use the key in scc

---

**gaetan.trellu** (2025-06-21 04:20):
So... `eBPF` was not enable on Calico...

---

**Lasith Haturusinha** (2025-06-21 04:48):
Thank you Sir!!!

---

**Amol Kharche** (2025-06-23 06:06):
The license key from SCC should be in `ABCDE-ABCDE-ABCDE` format.
For internal we have pinned the key in this channel here. (https://suse.slack.com/archives/C079ANFDS2C/p1742982913401109)

---

**Lasith Haturusinha** (2025-06-23 06:54):
Thank you @Amol Kharche. Appreciate it very much.

---

**Lasith Haturusinha** (2025-06-23 07:14):
Hi team,
I'm having trouble deploying SUSE Observability on Rancher 2.10.6. Anyone having issues?

---

**Lasith Haturusinha** (2025-06-23 07:18):
I manage to deploy on Rancher 2.9.7 without any issues. But the deployment doesn't get completed after the upgrade to 2.10.6. Anyone can help or shed some light about this?
Thanks in advance.

---

**Amol Kharche** (2025-06-23 07:43):
I see most of the pods in `Init` phase. which storage provisioner you are using?
`kubectl get events -n suse-observability`
`kubectl get sc`

---

**Lasith Haturusinha** (2025-06-23 07:45):
Uses longhorn

---

**Amol Kharche** (2025-06-23 07:51):
please help to get the output of events command as well

---

**Amol Kharche** (2025-06-23 07:55):
Also what is the lognhorn version?

---

**Lasith Haturusinha** (2025-06-23 07:57):
Do you want me to reply here this thread or separately?
Longhorn version 1.8.1

---

**Amol Kharche** (2025-06-23 07:58):
Yes, Here only

---

**Lasith Haturusinha** (2025-06-23 08:03):
@Amol Kharche hope you can see the snippet above

---

**Amol Kharche** (2025-06-23 08:04):
Yes, I can see it.

---

**Lasith Haturusinha** (2025-06-23 08:05):
Okay :eyes:

---

**Lasith Haturusinha** (2025-06-23 08:06):
What can I do to fix this? Is it related to Longhorn?
Sorry for the ignorance...

---

**Lasith Haturusinha** (2025-06-23 08:07):
I did not have this issue when I was using Rancher 2.9.7. I simply deploy Longhorn and then run through the SUSE Observability steps

---

**Lasith Haturusinha** (2025-06-23 08:10):
sure...give me 2 minutes and I'll call you directly

---

**Bram Schuur** (2025-06-23 08:41):
:+1:i filed the following ticket @Remco Beckers: https://stackstate.atlassian.net/browse/STAC-22945

---

**Bram Schuur** (2025-06-23 08:48):
Skpping SSL is a global setting and should apply to the RBAC agent aswell. The RBAC agent is in 'coming soon' state now so is incomplete and unusable as of yet. I am still interested: what issues do you see when enabling it?

---

**Ben Craft** (2025-06-23 12:19):
is there a public swagger ui for observability?

---

**Louis Lotter** (2025-06-23 12:23):
Hi Lasith we will need a bit more information. Was the previous post for the same issue ?. Has @Amol Kharche been able to help you ?

---

**Amol Kharche** (2025-06-23 12:27):
yes, this is for previous post for the same issue, I had a call with Lasith and found the storage is insufficient and due to that SUSE Observability components failing. I asked to assign more storage and ping back.

---

**Bram Schuur** (2025-06-23 12:59):
there is not, right now the api is also not considered public/stable

---

**Lasith Haturusinha** (2025-06-23 13:15):
Hi @Louis Lotter , Yes Amol helped me over this issue. As he suggested, it is the longhorn version that was failing the deployment. For anyone's reference, I used Longhorn 1.7.2 for the deployment of SUSE Observability and then it worked.
Thanks @Amol Kharche for your suggestions and for the prompt support on this.

---

**Ben Craft** (2025-06-23 13:21):
No problem, thanks!

---

**Louis Lotter** (2025-06-23 14:01):
Thanks for helping out Amol

---

**Ben Craft** (2025-06-23 14:04):
just a small query then - is it possible to get all the pods that match the below request for the below request without specifying the UID? i.e replicas at play

````https://ben-craft.app.stackstate.io/api/k8s/logs?cluster=buddy&amp;containerNames=rancher-audit-log&amp;direction=OLDEST&amp;from=1750670603482&amp;page=1&amp;pageSize=50&amp;podUID=a2e26e2d-60c1-42ca-9a91-c37536f38ba1&amp;to=1750674203482```

---

**Gustavo Varela** (2025-06-25 08:37):
how is the SUSE Observability Optimization deliver ?

---

**Louis Lotter** (2025-06-25 08:46):
Hi Gustavo. I'm not sure I understand your question. Could you clarify a bit ?

---

**Mark Bakker** (2025-06-25 10:15):
At this moment this only entails an extra StackPack for old customers

---

**Gustavo Varela** (2025-06-25 11:01):
so, nothing for new SUSE Rancher Suite customers ?

---

**Mark Bakker** (2025-06-25 11:11):
No clear differentiation yet. But upcoming.

---

**Gustavo Varela** (2025-06-25 11:12):
oki, can you provide a line one what are you guys working on, just in case a customer ask ?

---

**Mark Bakker** (2025-06-25 11:15):
Yes automated troubleshooting is one of them

---

**Flavien Rugiano** (2025-06-25 11:49):
Good morning team, I'm working with a customer on designing a Rancher Prime platform and we have some questions regarding the log in SUSE Observability:
• Are the K8s logs saved in Elastic Search or is it a Standard output?
• For legal purpose they will need to store logs for a long period ( at least a year). Is that a wise thing to do ? 
• If we can't store logs for long term is there a way to externalize them elsewhere ? Something like Splunk for example.

---

**Rodolfo de Almeida** (2025-06-25 13:14):
Hello @Mark Bakker
It looks like the SUSE Observability documentation is not updated. There are some outdated information regarding the Kubernetes version supported.

In this link it shows Kubernetes: 1.21 to 1.30
https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/install-stackstate/requirements.html

In the quickstart it shows that k8s 1.32 is supported.
https://documentation.suse.com/cloudnative/suse-observability/next/en/k8s-quick-start-guide.html#_kubernetes

Can we update this information in the docs? I have a customer complaining about it.

---

**Bram Schuur** (2025-06-25 13:55):
@Akash Raj could you pick this up?

---

**Mark Bakker** (2025-06-25 16:09):
Logs are stored in Elastic
We do not support long term storage for logs at the moment
We have an epic defined to revisit our log capabilities somewhere next year. We will take this requirement in consideration.

---

**Flavien Rugiano** (2025-06-25 16:11):
So then It wouldn't be a problem to have the current Rancher logging stack alongside SUSE observability to export them somewhere ?

---

**Mark Bakker** (2025-06-25 16:11):
No that is indeed the current solution

---

**Lionel Meoni** (2025-06-25 17:41):
Hi, we installed for a customer suse ai demo suse observability, we configured 20 nonHA with a lic generated by SSC team, we have only 6nodes and we have this message...any idea? bug?

---

**Alejandro Acevedo Osorio** (2025-06-25 18:15):
I think it might be related to the concept we have of a ‘default node’ where the 6 nodes list might be equivalent to more of our default nodes.

---

**Alejandro Acevedo Osorio** (2025-06-25 18:16):
An observed node is taken to be 4 vCPUs and 16GB of memory, our default node size.
If nodes in your observed cluster are bigger, they can count for multiple default nodes, so a node of 12vCPU and 48GB counts as 3 default nodes

---

**Lionel Meoni** (2025-06-25 18:27):
ok thank you

---

**Lionel Meoni** (2025-06-25 18:28):
i removed the harvester01 at this stage

---

**Lionel Meoni** (2025-06-25 18:30):
the 2 remaining nodes have 4 vcpu and 16gb ram

---

**Jeroen van Erp** (2025-06-26 08:01):
@Alejandro Acevedo Osorio it might be good to expose the cpu and memory size of nodes in the overview page.

---

**Lionel Meoni** (2025-06-26 08:43):
could be great please...thank you :)

---

**Alejandro Acevedo Osorio** (2025-06-26 09:10):
Sounds like a good improvement. I’ll make a story for it

---

**Jeroen van Erp** (2025-06-26 09:32):
Also, it would be good to have a specific “license overview” page, where you would see which node attributes to which usage part of your license, and you see how close you are to your limit

---

**Bram Schuur** (2025-06-26 10:21):
@Alejandro Acevedo Osorio could you put the ticket into the 'incoming' sprint for us to look at?

---

**Alejandro Acevedo Osorio** (2025-06-26 10:23):
@Jeroen van Erp @Lionel Meoni @Bram Schuur Seems our node overview page already has `Mem` and `Cpu`  allocatable over there, it's just that in the screenshot were hidden by the notification. I think we already have the info over there

---

**Alejandro Acevedo Osorio** (2025-06-26 10:24):
Regarding @Jeroen van Erp idea of a "license overview" then it's more like a complete new feature I guess ...

---

**Bram Schuur** (2025-06-26 10:26):
How about we show the 'default nodes' on that page?

---

**Jeroen van Erp** (2025-06-26 10:27):
That would be a new feature indeed

---

**Alejandro Acevedo Osorio** (2025-06-26 10:27):
I like the `default nodes` column on the nodes overview page

---

**Jeroen van Erp** (2025-06-26 10:27):
I think allocatable is not what we base the license measure on... Allocatable is typically lower than the amount in the node

---

**Bram Schuur** (2025-06-26 10:29):
Do you have a link to the license 'rules' @Jeroen van Erp? I'll see whether we bring them both inthere, or consolidate our default node size to the license sizing

---

**Jeroen van Erp** (2025-06-26 10:32):
I don't have it no... I would refrain from adding default nodes to the k8s nodes overview. That requires too much explanation

---

**Jan Bruder** (2025-06-26 12:32):
Hi, what ports and protocols need to be opened when there is a firewall between SUSE Observability server and downstream cluster? I couldn’t find any such information in the docs.

---

**Louis Parkin** (2025-06-26 12:43):
Comms from the agent to the platform only flows one way, using https, AFAIK.  Docs (https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/k8s-network-configuration-saas.html) confirm.

---

**Amol Kharche** (2025-06-26 12:50):
@Louis Parkin Is the listed port in v5.1 documentation still valid?
https://docs.stackstate.com/5.1/setup/install-stackstate/requirements#port-list-per-process

---

**Louis Parkin** (2025-06-26 12:51):
That should not be relevant for comms through a firewall, unless I am misunderstanding the context?

---

**Jan Bruder** (2025-06-26 12:56):
Why does the documentation assume that the customer is using SUSE Cloud Observability?
&gt;  You need to allow egress traffic to the internet.
This is not correct for SUSE Observability self-hosted

---

**Louis Parkin** (2025-06-26 12:57):
I just selected an example from that docs that deal with Network configuration.

---

**Jan Bruder** (2025-06-26 12:58):
Also very confusing:

---

**Louis Parkin** (2025-06-26 12:58):
If you don't use SUSE Cloud Observability, then that can be skipped.

---

**Jan Bruder** (2025-06-26 12:58):
“SUSE Observability” is _not_ a SaaS offering hosted in the cloud.

---

**Jan Bruder** (2025-06-26 12:58):
“SUSE Cloud Observability” is the SaaS

---

**Louis Parkin** (2025-06-26 12:59):
@Jan Bruder I am not here to nit-pick documentation accuracy.  Did I answer your original question RE firewall ports?

---

**Louis Parkin** (2025-06-26 12:59):
@Louis Lotter / @Mark Bakker it seems our docs can use some love.

---

**Jan Bruder** (2025-06-26 13:00):
Technically yes, but the customer is expecting the docs relevant for the self-hosted version. The link you shared is specifically for the networking configuration as it relates to the SaaS product.

---

**Louis Parkin** (2025-06-26 13:01):
That's fine. We can allocate someone to review the docs.

---

**Jan Bruder** (2025-06-26 13:02):
That would be great, thanks. In the meantime i will point out to the customer that the documentation applies to self-hosted minus the internet access and the `.app.stackstate.io (http://app.stackstate.io)` URL hostname suffix

---

**Louis Lotter** (2025-06-26 13:03):
@John Krug @Remco Beckers What would be the best way to capture feedback like this ?

---

**Bram Schuur** (2025-06-26 13:16):
@Dinesh Chandra a new verison of the platform and agent has been released which solves the issue for latency reporting on websockets

---

**John Krug** (2025-06-26 13:20):
Open an issue in GitHub.com/rancher/stackstate-product-docs (http://GitHub.com/rancher/stackstate-product-docs) is probably best. What do you think Remco?

---

**Eric Lajoie** (2025-06-26 13:20):
Jira doc ticket?

---

**Eric Lajoie** (2025-06-26 13:21):
I would assume we have Jira for engineering internal doc process

---

**Eric Lajoie** (2025-06-26 13:22):
And when a new release it GAed then engineering updates the docs as part of the process and release criteria

---

**Remco Beckers** (2025-06-26 13:28):
We, the engineering team, don't really look at Github issues (maybe we should?), but use our  Jira (which is another one than the SUSE internal Jira to complicate things).

---

**Remco Beckers** (2025-06-26 13:29):
Since we only just moved our docs to the SUSE docs site I think we still need to figure out how to best do this. If it is a ticket that doesn't need engineering input it could be handled fine by just the docs team. But I think the docs team doesn't use the same Jira.

---

**Eric Lajoie** (2025-06-26 13:32):
It would be awesome if we have a company wide way of doing doc update requests and feature requests across all products =)

---

**Eric Lajoie** (2025-06-26 13:32):
We have something on the SUSE AI side

---

**Eric Lajoie** (2025-06-26 13:33):
plus corresponding private slack channels for docs to make sure the doc team gets reviews from specialists and such

---

**Dinesh Chandra** (2025-06-26 14:23):
Thanks @Bram Schuur

---

**Jan Bruder** (2025-06-26 15:29):
Hi, another question from a prospect: Does the self-hosted Observability server support multi-tenancy, in the sense that each tenant/account can observe their own clusters, completely segregated from other tenant’s clusters.

---

**Bram Schuur** (2025-06-26 15:47):
We are current working on 'kubernetes rbac' which allows cluster/project/namespace level access control for all telemetry data. This will in the first version only work on rancher prime, and can be used self-hosted.

This feature will be released with the next rancher release.

---

**Bram Schuur** (2025-06-26 16:34):
Just to confirm: this indeed landed lower on our feature request log (so lower prio for now).

---

**Gabriel Lins** (2025-06-26 18:09):
Hey, what's the updates about the new Platform Optimizarion that was on roadmap. Do we have news regarding functionalities like platform cost, sustainability and right-sizing?

---

**Brian Six** (2025-06-26 18:49):
I’ll continue to ask customers and see if there is a bigger need as time goes by.

---

**Thiago Bertoldi** (2025-06-27 14:29):
https://instrumentation-score.com

---

**Mark Bakker** (2025-06-27 16:46):
Thanks for sharing

---

**Adam Toy** (2025-06-27 19:55):
:wave: just want to ensure we're looking ahead.. are there any known future plans to move away from the existing air-gap methodology to aggregate the images via the bash scripts (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime/k8s-suse-rancher-prime-air-gapped)? other projects provide a list of images as part of the artifacts of a release (check the artifacts list (https://github.com/rancher/rke2/releases/tag/v1.33.1%2Brke2r1) here), but wasn't sure if there were plans for observability to do the same.

---

**Remco Beckers** (2025-06-30 08:47):
We don't have that on the planning at the moment. When we last updated our air-gapped support we loosely based ourselves on the approach that is used for Rancher (https://documentation.suse.com/cloudnative/rancher-manager/latest/en/installation-and-upgrade/other-installation-methods/air-gapped/publish-images.html#_1_find_the_required_assets_for_your_rancher_version), also because that was similar to what we already were doing before.

If this is something that people are requesting we can of course change it, but I think one of the differences is that  for SUSE Observability you'd need to download a dozen or so images. With the scripts that is all automated, which makes it less work than having to download from the releases page

---

**Jan Bruder** (2025-06-30 09:49):
Okay, i understand from this that there is no multi-tenancy support in Observabiity.
Question regarding the RBAC: Will there be scopes automatically created and mapped to users, so that a user who has access to Cluster Foo and Bar in Rancher, will automatically have a scope in Observability to only see the data for those two clusters?

---

**Vladimir Iliakov** (2025-06-30 11:27):
@Marc Rua Herrera `Also, as a feedback, for the scale up script that needs to be run after the victoria metrics restore` 

To scale up VM instance you are supposed to run a `kubectl` command:

---

**Marc Rua Herrera** (2025-06-30 11:29):
Was it there all the time :sweat_smile:?

---

**Vladimir Iliakov** (2025-06-30 11:53):
Most likely. I guess it was added by Lukasz who is very scrupulous about such things, and I also don't remember doung extra steps during the restore...

---

**Remco Beckers** (2025-06-30 11:57):
No recent changes that I know of indeed

---

**Bram Schuur** (2025-06-30 12:00):
Gotcha, so it was in the docs there. I do think rabobank really has a point there that there are many steps that are super uncomfrotable to go through when doing a restore in the heat of the moment. I think this 'read the docs' moment also shows that. What do you think @Louis Lotter @Marc Rua Herrera?

---

**Remco Beckers** (2025-06-30 12:05):
Tbh the elasticsearch restore steps are much much worse

---

**Remco Beckers** (2025-06-30 12:05):
while StackGraph and Clickhouse are a bit more convenient :shrug:

---

**Vladimir Iliakov** (2025-06-30 12:26):
'read the docs' is inevitable when dealing with the backup/restore and moreover SRE assumes you do it regularly, so you are prepared when time comes. The other questions whether the docs are clear enough/easy to read and the scripts work as expected, but for that we need a feedback from the users to improve...

---

**Marc Rua Herrera** (2025-06-30 12:28):
I did the restore with them. There were three of us, and none of us spotted this in the documentation (Shame on us :cry:). But what I would expect is that if there’s a script to scale up, it should scale up everything, not just the deployments. Although it was apparently documented, it was quite unintuitive.

Apart from that, overall the backup is a bit of a rambling experience:
1. There is a backup for Configuration.
2. There is a backup for VictoriaMetrics.
3. There is a backup for Elasticsearch.
4. There is a backup for StackGraph, but this backup also includes the Configuration, which is confusing.
Each backup has its own separate procedure, which adds to the complexity.

It did work in the end, resolving the data corruption issue, but it took a while to figure everything out. The ~backup~ *restore* itself took several hours to complete and failed twice, interrupting the process without any error message.

---

**Bram Schuur** (2025-06-30 12:42):
@Marc Rua Herrera with 'backup' you mean 'restore' in that last sentence right?

---

**Vladimir Iliakov** (2025-06-30 12:53):
We can come up with the single program/script to manage backup/restore, but will take time if we want to do it "right".

---

**Jacob Perkins** (2025-06-30 14:19):
Is there a way to have the Observability Rancher UI extension / plugin skip TLS verification?

---

**Remco Beckers** (2025-06-30 14:26):
At the moment there is no way to skip that. But you can configure Rancher to trust the certificate. https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/custom-ca-root-certificates

---

**Adam Toy** (2025-06-30 15:14):
got it.. there's a little confusion on our side in terms of what constitutes a "release" of observability.. aka, there isn't a version mapping between the `suse-observability-values` helm chart and the `suse-observability` helm chart.. so for a user, if i'm air-gap "upgrading" through versions of observability in the future, there's no way to know currently if a version of the values chart is compatible with the version of observability that i'm trying to use.

is it possible in a future release to match/map versions of the `suse-observability-values` chart with the `suse-observability` chart? just don't want to get into a situation where a customer is trying to upgrade, they grab the "latest" values chart, and that chart is for some reason not compatible with the target version of observability, since there's a chance that might not be latest.

---

**Akash Raj** (2025-07-01 06:57):
@Rodolfo de Almeida @Bram Schuur  I was on vacation until yesterday and checked the requests just now.

I'll the update the docs shortly :+1::skin-tone-2:  So, 1.32 would be the latest version, correct?

---

**Bram Schuur** (2025-07-01 08:50):
yes! thanks for picking this up @Akash Raj

---

**Bram Schuur** (2025-07-01 08:53):
Indeed, currently no multitenancy. The next rancher release will include it.

We will be shipping role and cluster role templates that can be bound to users/groups in rancher to configure who has access to what project/cluster. Binding the role/cluster templates is all that is required for configuration.

---

**Benoît Loriot** (2025-07-01 11:00):
Hi, a customer is asking in a RFP if we can monitor electric consumption of a cluster and by namespace? Is it something we can do with SO? I suppose not by default but maybe with a custom development?

---

**Louis Lotter** (2025-07-01 11:07):
we have discussed integrating with something like https://github.com/kubecost

---

**Louis Lotter** (2025-07-01 11:07):
many times but it's hard to get priority for it.

---

**Remco Beckers** (2025-07-01 11:08):
@Louis Lotter that's about cost, not electric consumption.

I think a tool like Kepler, https://github.com/sustainable-computing-io/kepler, can get the metrics for this that can be then integrated into SUSE Observability.

---

**Louis Lotter** (2025-07-01 11:09):
interesting. I guess we would try to gather multiple types of data together though

---

**Remco Beckers** (2025-07-01 11:09):
So definitely not something we support out-of-the-box indeed, similar to cost

---

**Jeroen van Erp** (2025-07-01 11:14):
I think maybe @Ravan Naidoo did something with Kepler already…

---

**Ravan Naidoo** (2025-07-01 11:23):
Kepler exposes a metric endpoint so we can configure our open telemetry collector to scape it and send it to SUSE Observability.

``` receivers:
              prometheus:
                config:
                  scrape_configs:
                  - job_name: 'kepler-metrics'
                    scrape_interval: 3s
                    scheme: http
                    relabel_configs:
                        - action: replace
                          regex: (.*)
                          replacement: $1
                          source_labels:
                          - __meta_kubernetes_pod_node_name
                          target_label: instance
                    kubernetes_sd_configs:
                      - role: service
                        namespaces:
                          own_namespace: true
                        selectors:
                          - role: service
                            label: "app.kubernetes.io/name=kepler (http://app.kubernetes.io/name=kepler)"```
Kepler has a predefined dashboard for use in grafana: https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/v1alpha1/hack/dashboard/assets/kepler/dashboard.json
So we have an example on how to use the Kepler metrics and can create a similar dashboard in SUSE Observability.

---

**Jeroen van Erp** (2025-07-01 11:31):
:heart-eyes:

---

**Jan Bruder** (2025-07-01 12:58):
Hi Bram, does that mean that Observability will have a notion of Rancher projects and accordingly show/hide the data pertaining to workloads in a shared cluster depending on user’s project membership?

---

**Bram Schuur** (2025-07-01 13:05):
yes. exactly that, users can be authorized to see data in a project or not. (technically the platform will not understand projects but namespaces, but that is a technical/implementation detail, the functionality is as you describe)

---

**Jan Bruder** (2025-07-01 13:09):
thats great :thumbs-up: its worth noting that when the Virtual Cluster feature in Rancher becomes GA, there will be similar requests from customers to map virtual cluster ownership to Observability. As far as i understand, virtual cluster “shared mode” uses namespaces to isolate the workloads pertaining to different virtual clusters, similarily as what Projects do.

---

**Bram Schuur** (2025-07-01 13:10):
gotcha, thanks for sharing that. We were not aware that that was developed, so i'll make a note to investigate how virtual clusters will interact with rbac.

---

**Rodolfo de Almeida** (2025-07-01 14:00):
Thank you!

---

**Benoît Loriot** (2025-07-01 14:22):
Very nice, thanks a lot for the inputs

---

**Benoît Loriot** (2025-07-01 14:41):
Hi again, in the same RFP the customer is asking if we can generate reports based on historic datas to reflect usage but also forecast (capacity planning).
I would say SO is more focused on short term analysis and troubleshooting, but less on storing datas in the long term for capacity planning. Am I right?
Do we have a way to generate reports (pdf, csv...) based on the metrics gathered?

---

**Louis Lotter** (2025-07-01 15:01):
How long term ? We don't store data  for more than a few months. We have some requests and vague plans about longer term data storage but it's not likely to be priortized soon.

---

**Benoît Loriot** (2025-07-01 15:03):
That's what I thought. I suppose they would need at least a year for efficient capacity planning.

---

**Benoît Loriot** (2025-07-01 15:10):
I would be nice to have a feature to export a PDF from the metric explorer view (for reporting)

---

**Louis Lotter** (2025-07-01 15:29):
our metrics are stored in a prometheus/grafana comptible  database calle victoriametric. so I'm pretty sure there must be an open source solution for this in the interim.

---

**Louis Lotter** (2025-07-01 15:30):
@Anton Ovechkin once we are done with dasboarding we may take a look at something like https://github.com/IzakMarais/reporter and see how hard it would be to generate pdf's maybe

---

**Anton Ovechkin** (2025-07-01 15:33):
added to backlog https://stackstate.atlassian.net/browse/STAC-22993

---

**Benoît Loriot** (2025-07-01 15:34):
Thanks for the answers, I'll mention this could be a RFE if formally requested by the customer.

---

**Maxime Vielle** (2025-07-01 17:37):
Hello, does SUSE Observability connect to AWS Session Manager ? https://docs.aws.amazon.com/es_es/systems-manager/latest/userguide/session-manager.html

---

**Remco Beckers** (2025-07-01 17:42):
No we don't. Why would that be useful?

---

**Maxime Vielle** (2025-07-01 18:03):
An AWS customer is using it alongside Rancher Community version. They would find it useful to observe apparently

---

**Remco Beckers** (2025-07-01 18:04):
To observe you mean. I thought it was about some kind of authentication or remote access.  Maybe there is some way to do that using an exporter or by scraping cloudwatch metrics with open telemetry, but we don't have it built-in.

---

**Maxime Vielle** (2025-07-01 19:09):
Ok thanks!

---

**Jan Bruder** (2025-07-02 09:53):
Here is a site on the intranet with more information: https://sites.google.com/suse.com/virtualclusters/home

---

**Davide Rutigliano** (2025-07-04 15:21):
Hi, question about STAC-22940 (https://stackstate.atlassian.net/browse/STAC-22940). Is there any plan to also include descheduler metrics (https://github.com/kubernetes-sigs/descheduler/blob/master/metrics/metrics.go)?

---

**Tapas Nandi** (2025-07-08 07:18):
Hello Team,
I am trying to deploy a observability server using custom CA certs.
I followed the steps as mentioned in docs and my server is setup using the tls as in my certs .
I have also added the certs in /var/lib/rancher/rke2/server and agents tls directories as we as OS cert store and executed update CA in both the observability server as well as in downstream clusters.
But even after that when i try to onboard my cluster in observability using stackpacks it fails giving cert error.
I exec into one of the pods and checked the cert and couldn't see my cert in there.
Is there any thing i am missing. Please guide.

---

**Louis Lotter** (2025-07-08 08:30):
@Fedor Zhdanov @Remco Beckers can you guys help answer here ?

---

**Remco Beckers** (2025-07-08 08:35):
We are still considering if we can bring this forward now or that we want to wait until we have some problems related to collecting the data resolved.

Having said that, the descheduler is not part of the autoscaler. So is anyway not included.

Are you interested in the autoscaler monitoring too or just in the descheduler?

---

**Bram Schuur** (2025-07-08 10:50):
currently we do not support self-signed certificates for the agent. it is possible to skip ssl validation for the agent, doc for that is a bit hidden now, which is something we'll tackle soon: https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/agent/k8s-network-configuration-proxy.html#_via_values_yaml_file

---

**Tapas Nandi** (2025-07-08 11:32):
Oh Ok, i thought it would be available now. So even for custom CA  its a no and the possible approach is to skip tls verification all together. I will try this and get back

---

**Tapas Nandi** (2025-07-08 11:33):
Thanks @Bram Schuur for the update

---

**Tapas Nandi** (2025-07-08 11:36):
so all i need to do is add :
```--set global.skipSslValidation=true```
During agent installation and it should work correct

---

**Tapas Nandi** (2025-07-08 11:42):
Thanks @Bram Schuur

---

**Gustavo Varela** (2025-07-08 12:24):
Hello, the one subcription that appeared for every Rancher client in SCC allows them to cover all the machines or this needs adjusted after the expiration ? to the exact quantity of covered clusters/nodes ?

---

**Mark Bakker** (2025-07-08 13:01):
We currently do no check the amount of nodes with the license. We expect the customers to be in compliance for that.

---

**Gustavo Varela** (2025-07-08 14:09):
they should have one license per worker node ?

---

**Ben Craft** (2025-07-08 14:31):
Hi - is it possible to get all the pods that match the container name like in the below request without specifying the UID? i.e replicas at play

`https://ben-craft.app.stackstate.io/api/k8s/logs?cluster=buddy&amp;containerNames=rancher-audit-log&amp;direction=OLDEST&amp;from=1750670603482&amp;page=1&amp;pageSize=50&amp;podUID=a2e26e2d-60c1-42ca-9a91-c37536f38ba1&amp;to=1750674203482`

---

**Bram Schuur** (2025-07-08 15:11):
currently this is not supported. currently logging is per-pod, we have 'generalized logging/querying' on the medium-term roadmap

---

**Ben Craft** (2025-07-08 15:12):
ok np, thanks

---

**Mark Bakker** (2025-07-08 15:50):
Yes, normal prime licensing. It's part of prime

---

**Brynn Harrison** (2025-07-08 16:35):
When using the Mini.io (http://Mini.io) as a gateway for backup, is it possible to use another S3 target (eg Scality) at the target instead of AWS S3 or Azure or PVC?

---

**Vladimir Iliakov** (2025-07-08 16:44):
Officially AWS S3, Azure Blob storage, and PVC are supported as Minio backends https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/data-management/backup_restore/kubernetes_backup.html#_enable_backups.

---

**Vladimir Iliakov** (2025-07-08 16:47):
&gt; is it possible to use another S3 target (eg Scality)
We have never tried it, so there is no way to say for sure.

---

**Brynn Harrison** (2025-07-08 16:48):
OK - I guessed that was the case as there is no way to configure teh Scality S3 endpoint

---

**Vladimir Iliakov** (2025-07-08 16:53):
It is possible to configure an S3 endpoint with Helm value: `minio.s3gateway.serviceEndpoint`

```minio:
  accessKey: YOUR_ACCESS_KEY
  secretKey: YOUR_SECRET_KEY
  s3gateway:
    enabled: true
    accessKey: AWS_ACCESS_KEY
    secretKey: AWS_SECRET_KEY
    serviceEndpoint: .....```
I also see that aws cli can be used to interact with Scality https://downloads.scality.com/artesca-ova/doc/reference/configuring_and_using_aws_cli.html
So there is a chance that will work.

---

**Brian Six** (2025-07-10 06:46):
Do we have an estimate as to when the User/Authentication management will be fully integrated into Rancher?  I have customers looking for IDP options for logging into Observability.

---

**Mark Bakker** (2025-07-10 08:08):
Shortly after 2.12

---

**Frank van Lankvelt** (2025-07-10 08:08):
That will be part of the 2.12 release, scheduled for the end of the month.

---

**Jarek Sliwinski** (2025-07-10 09:16):
Hi All. Can somebody help me to understand how to configure open-telemetry exporter? I’m just setting up SUSE AI demo box, based on Harvester. The last element I’m missing is to setup exporter. Have configured 2 clusters - one dedicated for observability server, second dedicated to ai workloads. On observability cluster I exposed opentelemetry-collector, as explained in Observability docs in section “Configure Ingress Rule for Open Telemetry” with the following:
```opentelemetry-collector:
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/proxy-body-size: "50m"
      nginx.ingress.kubernetes.io/backend-protocol: GRPC
    hosts:
      - host: otlp-stackstate.observability.suseai.demo
        paths:
          - path: /
            pathType: Prefix
            port: 4317
    additionalIngresses:
      - name: otlp-http
        annotations:
          nginx.ingress.kubernetes.io/proxy-body-size: "50m"
        hosts:
          - host: otlp-http-stackstate.observability.suseai.demo        
            paths:
              - path: /
                pathType: Prefix
                port: 4318    ```
But I’m struggling with connect to it with the exporter on the ai cluster. AI docs assume within cluster setup: http://suse-observability-otel-collector.suse-observability.svc.cluster.local:4317, but in my case, whatever i try it either tries to point locally within cluster:
```Err: connection error: desc = "transport: Error while dialing: dial tcp: lookup otlp-stackstate.observability.suseai.demo on 10.43.0.10:53: no such host"	{"resource": {"service.instance.id": "4d4f818c-545c-4860-a7a5-a97e3d15d176", "service.name": "otelcol-k8s", "service.version": "0.128.0"}, "grpc_log": true} ```
or fails with deploying if I omit port number…

---

**Remco Beckers** (2025-07-10 09:23):
You need to configure the `bearertokenauth` and otlp exporter like this on the collector in your observed cluster:
```# Set the API key from the secret as an env var:
extraEnvsFrom:
  - secretRef:
      name: open-telemetry-collector
config:
  extensions:
    # Use the API key from the env for authentication
    bearertokenauth:
      scheme: SUSEObservability
      token: "${env:API_KEY}"
  exporters:
    nop: {}
    otlphttp/suse-observability:
      auth:
        authenticator: bearertokenauth
      # Put in your own otlp endpoint, for example suse-observability.my.company.com:443 (http://suse-observability.my.company.com:443)
      endpoint: otlp-http-stackstate.observability.suseai.demo:80
      compression: snappy
  service:
    extensions: [ bearertokenauth ]```
And make sure to include the `otlphttp/suse-observability` in the exporter section of the pipelines

For creating the secret and more details please see our docs (https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/otel/getting-started/getting-started-k8s.html).

---

**Marc Rua Herrera** (2025-07-10 15:20):
I am trying to include a monitor in a custom Stackpack for a customer. I am using exactly the same YAML file as the one used for the monitor itself, but I keep receiving these errors. I also get the same error when I upload it using the CLI. However, if I edit it, it succeeds in uploading a new version. Additionally, the monitor does not upload correctly to Master.
What does the error in this picture mean? The query itself works fine.

---

**Remco Beckers** (2025-07-10 15:21):
The error means that you cannot use `withNeighboursOf` or `withCauseOf` in the monitor topology query

---

**Marc Rua Herrera** (2025-07-10 15:22):
Is this new from the latest version?

---

**Marc Rua Herrera** (2025-07-10 15:22):
This monitor have been there for months

---

**Remco Beckers** (2025-07-10 15:22):
Depends on the monitor function, but I don't think we made any changes there

---

**Alejandro Acevedo Osorio** (2025-07-10 15:24):
I think we added a validation for the queries to be simplified STQL after the usage of NN on  the aggregated health monitor functions where it can drag the performance down

---

**Remco Beckers** (2025-07-10 15:25):
Aha, that was when you added the `Derived State` Monitor function

---

**Alejandro Acevedo Osorio** (2025-07-10 15:26):
Indeed we think that if you really need to derive state based on the graph then you should use the derived state monitor https://documentation.suse.com/cloudnative/suse-observability/next/en/use/alerting/k8s-derived-state-monitors.html#_overview

---

**Alejandro Acevedo Osorio** (2025-07-10 15:26):
and then the aggregated health state (https://documentation.suse.com/cloudnative/suse-observability/next/en/use/alerting/kubernetes-monitors.html#_aggregated_health_state_of_a_cluster) should only accept basic stql queries

---

**Erico Mendonca** (2025-07-10 17:08):
The tephra pod is running... nothing was changed. I remember there was an issue with a livenessProbe somewhere that caused this?

---

**Alejandro Acevedo Osorio** (2025-07-10 17:09):
It seems that the `tephra` pod might need a restart anywho if the `server` is not able to establish connection

---

**Erico Mendonca** (2025-07-10 17:10):
This cluster is somewhat strapped for CPU, maybe some operation is not completing on time?

---

**Alejandro Acevedo Osorio** (2025-07-10 17:11):
Could be that the initialization of `tephra` was not completed properly due to the CPU scarcity. We have a bug being worked on with such conditions.

---

**Alejandro Acevedo Osorio** (2025-07-10 17:21):
has tephra suffered any restarts?

---

**Alejandro Acevedo Osorio** (2025-07-10 17:23):
and the `tephra` restarts are related to `livenessProbe` failures?

---

**Erico Mendonca** (2025-07-10 17:26):
it appears they all failed with the same timeout:
```Caused by: java.lang.Exception: Thrift error for co.cask.tephra.distributed.TransactionServiceClient$13@4e307b53: Unable to discover transaction service within timeout```

---

**Alejandro Acevedo Osorio** (2025-07-10 17:27):
well that's the error on the `server` ... I was asking about any restarts on the `tephra` pod

---

**Erico Mendonca** (2025-07-10 17:31):
Someone asked it to shut down?

---

**Alejandro Acevedo Osorio** (2025-07-10 17:32):
We would need to whole logs. But given that it has restarted then the hypothesis is that due to a bug we have the last restart did not completely succeed to initialize tephra (the bug is that we leave it running) and due to this failed init is rejecting the connection attempts of the server pod. So I would restart tephra once more to see if that helps

---

**Erico Mendonca** (2025-07-10 17:37):
after a few more restarts, it appears to be holding

---

**Jarek Sliwinski** (2025-07-11 08:58):
Hi @Remco Beckers thank you this put me I believe on the right track. Looks like communication is possible now, but have a message that the user does not have rights to retrieve resources:
```E0711 06:55:16.538497       1 reflector.go:166] "Unhandled Error" err="k8s.io/client-go@v0.32.3/tools/cache/reflector.go:251 (http://k8s.io/client-go@v0.32.3/tools/cache/reflector.go:251): Failed to watch *v1.Service: failed to list *v1.Service: services is forbidden: User \"system:serviceaccount:observability:opentelemetry-collector\" cannot list resource \"services\" in API group \"\" in the namespace \"gpu-operator\"" logger="UnhandledError"```
I have added role binding rules as here:
```apiVersion: rbac.authorization.k8s.io/v1 (http://rbac.authorization.k8s.io/v1)
kind: Role
metadata:
  name: suse-observability-otel-scraper
rules:
  - apiGroups:
      - ""
    resources:
      - services
      - endpoints
    verbs:
      - list
      - watch
 
---
apiVersion: rbac.authorization.k8s.io/v1 (http://rbac.authorization.k8s.io/v1)
kind: RoleBinding
metadata:
  name: suse-observability-otel-scraper
roleRef:
  apiGroup: rbac.authorization.k8s.io (http://rbac.authorization.k8s.io)
  kind: Role
  name: suse-observability-otel-scraper
subjects:
  - kind: ServiceAccount
    name: opentelemetry-collector
    namespace: observability```
but something is still missing…

---

**Remco Beckers** (2025-07-11 09:15):
This is the collector running the ai workloads cluster I think? Which receivers do you have configured that can cause this error?  I would expect that the AI Observability setup has documentation on the permissions that are needed, we haven't been part of that setup so I can only guess.

---

**Jarek Sliwinski** (2025-07-11 10:29):
Hi. Yes, Indeed I’m setting up SUSE AI instance. As per receivers open telemetry collector is configured and on. Observability server is installed on separate cluster with open telemetry exposed with ingress rule. From stack-packs: kubernetes and open-telemetry are up.
Your suggestions helped me to fix the end point and I also added :bearertokenauth” section to collector values, which enabled communication. The only thing added in AI docs is to set up rbac rules as described above.  By the way “bearertokenauth” is not mentioned…

---

**Remco Beckers** (2025-07-11 11:09):
I'm referring to the receivers that are part of the OTel collector configuration. The OTel collector receivers do the scraping so I expect one of them is running into the permission errors. But maybe you can better ask the SUSE AI team that created this setup, they probably know more about how and what is scraped

---

**Jarek Sliwinski** (2025-07-11 11:10):
ok, thanks will do

---

**Luca Barzè** (2025-07-11 12:38):
Hello is it possible to use different SUSE observability clusters for k8s clusters related to the same rancher environment? Thank you

---

**Jeroen van Erp** (2025-07-11 12:41):
Hi Luca, yes and no, for Suse observability itself this is not a problem. However the Ui extension that integrates the data into rancher assumes a 1-1 relation

---

**Luca Barzè** (2025-07-11 13:35):
thank you! do we plan to integrate “a lot more” the observability ui within rancher or dismiss the SUSE observability frontend?

---

**Jeroen van Erp** (2025-07-11 13:44):
Rancher and observability will integrate more from what I’ve heard, but the UI of SUSE Obs will also stay and be your main entrypoint for troubleshooting. Rancher’s Logging and metrics will be sourced from SUSE Obs from what I understood, but @Mark Bakker can tell you more as the PM

---

**Luca Barzè** (2025-07-11 13:45):
Thank you!

---

**Mark Bakker** (2025-07-11 14:01):
The above is indeed correct

---

**IHAC** (2025-07-11 20:00):
@Garrick Tam has a question.

:customer:  Child Rescue Coalition

:facts-2: *Problem (symptom):*  
Customer deploys 150HA into 3 large nodes but many pods stuck in init or crashlooping.  Checking all the failing pods, there is one common dependency pod "suse-observability-hbase-hdfs-nn-0".  I can only see a warning in the pod log but it is restarting.
``` 2025-07-10 23:09:08,090 WARN server.AuthenticationFilter: Unable to initialize FileSignerSecretProvider, falling back to use random secrets. Reason: Could not read signature secret file: /nonexistent/hadoop-http-auth-signature-secret```
Can I get some help to understand this deployment is not progressing to healthy and how to fix?

Attached is the support logs.

---

**Garrick Tam** (2025-07-12 06:49):
Looks like the Readiness probe (/rs-scripts/check-status.sh) is not passing.
```% k -n suse-observability describe pod  suse-observability-hbase-hdfs-nn-0 
Name:             suse-observability-hbase-hdfs-nn-0 
Namespace:        suse-observability 
Priority:         0 
Service Account:  suse-observability-hbase-hdfs 
Node:             observe03/10.203.100.33 
Start Time:       Wed, 09 Jul 2025 15:59:11 -0400 
Labels:           app.kubernetes.io/component=hdfs-nn (http://app.kubernetes.io/component=hdfs-nn) 
                  app.kubernetes.io/instance=suse-observability (http://app.kubernetes.io/instance=suse-observability) 
                  app.kubernetes.io/name=hbase (http://app.kubernetes.io/name=hbase) 
                  app.kubernetes.io/part-of=suse-observability (http://app.kubernetes.io/part-of=suse-observability) 
                  apps.kubernetes.io/pod-index=0 (http://apps.kubernetes.io/pod-index=0) 
                  controller-revision-hash=suse-observability-hbase-hdfs-nn-777bf59468 
                  statefulset.kubernetes.io/pod-name=suse-observability-hbase-hdfs-nn-0 (http://statefulset.kubernetes.io/pod-name=suse-observability-hbase-hdfs-nn-0) 
Annotations:      ad.stackstate.com/namenode.check_names (http://ad.stackstate.com/namenode.check_names): ["openmetrics"] 
                  ad.stackstate.com/namenode.init_configs (http://ad.stackstate.com/namenode.init_configs): [{}] 
                  ad.stackstate.com/namenode.instances (http://ad.stackstate.com/namenode.instances): [ { "prometheus_url": "http://%%host%%:9404/metrics", "namespace": "stackstate", "metrics": ["*"] } ] 
                  cni.projectcalico.org/containerID (http://cni.projectcalico.org/containerID): c1352d6341975c77cd7d597c7e6af44696a8b1b3e7c2ba5af3256c45aa820c9e 
                  cni.projectcalico.org/podIP (http://cni.projectcalico.org/podIP): 10.42.58.59/32 
                  cni.projectcalico.org/podIPs (http://cni.projectcalico.org/podIPs): 10.42.58.59/32 
Status:           Running 
IP:               10.42.58.59 
IPs: 
  IP:           10.42.58.59 
Controlled By:  StatefulSet/suse-observability-hbase-hdfs-nn 
Init Containers: 
  namenode-init: 
    Container ID:  <containerd://17d8b18da1d6173d7a99b77582ab6e0e0b5aabc2f270893e155673b2253a5f7>0 
    Image:         registry.rancher.com/suse-observability/wait:1.0.11-04b49abf (http://registry.rancher.com/suse-observability/wait:1.0.11-04b49abf) 
    Image ID:      registry.rancher.com/suse-observability/wait@sha256:73d3ce2ecdcec8e8db82c3d3bd3c289a0ed57364e71ef912eb3fefbb12c594c3 (http://registry.rancher.com/suse-observability/wait@sha256:73d3ce2ecdcec8e8db82c3d3bd3c289a0ed57364e71ef912eb3fefbb12c594c3) 
    Port:          &lt;none&gt; 
    Host Port:     &lt;none&gt; 
    Command: 
      bash 
      -c 
      mkdir -p /hadoop-data/data 
      # migrate old data directory location 
      if [ -e /hadoop-data/current ]; then 
        GLOBIGNORE=data:lost+found 
        mv /hadoop-data/* /hadoop-data/data/ 
      fi 
      
    State:          Terminated 
      Reason:       Completed 
      Exit Code:    0 
      Started:      Wed, 09 Jul 2025 16:01:33 -0400 
      Finished:     Wed, 09 Jul 2025 16:01:33 -0400 
    Ready:          True 
    Restart Count:  0 
    Environment:    &lt;none&gt; 
    Mounts: 
      /hadoop-data from data (rw) 
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-cbllv (ro) 
Containers: 
  namenode: 
    Container ID:  <containerd://092b89370afd08c0ca76b3bf2a0588aa72362aa66cf1ee66b1de9db5a175105>b 
    Image:         registry.rancher.com/suse-observability/hadoop:3.4.1-java11-8-90a9d727 (http://registry.rancher.com/suse-observability/hadoop:3.4.1-java11-8-90a9d727) 
    Image ID:      registry.rancher.com/suse-observability/hadoop@sha256:ef80281a0c09a8ff499795a5db200a0bbc6c106aaff9dacd0d3fb7d0f835142d (http://registry.rancher.com/suse-observability/hadoop@sha256:ef80281a0c09a8ff499795a5db200a0bbc6c106aaff9dacd0d3fb7d0f835142d) 
    Ports:         9000/TCP, 50070/TCP, 9404/TCP 
    Host Ports:    0/TCP, 0/TCP, 0/TCP 
    Args: 
      /entrypoint.sh 
      /run.sh 
      namenode 
    State:          Waiting 
      Reason:       CrashLoopBackOff 
    Last State:     Terminated 
      Reason:       Error 
      Exit Code:    143 
      Started:      Fri, 11 Jul 2025 18:05:40 -0400 
      Finished:     Fri, 11 Jul 2025 18:06:38 -0400 
    Ready:          False 
    Restart Count:  856 
    Limits: 
      cpu:                400m 
      ephemeral-storage:  70Mi 
      memory:             1Gi 
    Requests: 
      cpu:                200m 
      ephemeral-storage:  1Mi 
      memory:             1Gi 
    Liveness:             http-get http://:nninfo/ delay=0s timeout=1s period=10s #success=1 #failure=3 
    Readiness:            http-get http://:nninfo/ delay=0s timeout=1s period=10s #success=1 #failure=3 
    Environment: 
      CORE_CONF_fs_defaultFS:                                                     <hdfs://suse-observability-hbase-hdfs-nn-headful:9000/> 
      HDFS_CONF_dfs_client_retry_policy_enabled:                                  true 
      HDFS_CONF_dfs_client_retry_policy_spec:                                     1000,6,2000,10 
      HDFS_CONF_dfs_datanode_data_dir:                                            /hadoop-data/data 
      HDFS_CONF_dfs_namenode_checkpoint_dir:                                      /hadoop-data/data 
      HDFS_CONF_dfs_namenode_name_dir:                                            /hadoop-data/data 
      HDFS_CONF_dfs_namenode_safemode_threshold___pct:                            0.9f 
      HDFS_CONF_dfs_namenode_http___address:                                      0.0.0.0:50070 
      HDFS_CONF_dfs_namenode_fs___limits_max___component___length:                0 
      HDFS_CONF_dfs_datanode_http_address:                                        0.0.0.0:50075 
      HDFS_CONF_dfs_datanode_address:                                             0.0.0.0:50010 
      HDFS_CONF_dfs_replication:                                                  2 
      HDFS_CONF_dfs_namenode_replication_min:                                     2 
      HDFS_CONF_dfs_client_block_write_replace___datanode___on___failure_enable:  true 
      HDFS_CONF_dfs_client_block_write_replace___datanode___on___failure_policy:  ALWAYS 
      HADOOP_USER_NAME:                                                           nobody 
    Mounts: 
      /hadoop-data from data (rw) 
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-cbllv (ro) 
Conditions: 
  Type                        Status 
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes: 
  data: 
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace) 
    ClaimName:  data-suse-observability-hbase-hdfs-nn-0 
    ReadOnly:   false 
  kube-api-access-cbllv: 
    Type:                    Projected (a volume that contains injected data from multiple sources) 
    TokenExpirationSeconds:  3607 
    ConfigMapName:           kube-root-ca.crt 
    Optional:                false 
    DownwardAPI:             true 
QoS Class:                   Burstable 
Node-Selectors:              &lt;none&gt; 
Tolerations:                 node.kubernetes.io/not-ready:NoExecute (http://node.kubernetes.io/not-ready:NoExecute) op=Exists for 300s 
                             node.kubernetes.io/unreachable:NoExecute (http://node.kubernetes.io/unreachable:NoExecute) op=Exists for 300s 
Events: 
  Type     Reason     Age                       From     Message 
  ----     ------     ----                      ----     ------- 
  Warning  Unhealthy  49m (x1114 over 2d1h)     kubelet  (combined from similar events): Readiness probe failed: Get "http://10.42.58.59:50070/": read tcp 10.203.100.33:55686-&gt;10.42.58.59:50070: read: connection reset by peer 
  Warning  Unhealthy  14m (x6826 over 2d2h)     kubelet  Readiness probe failed: Get "http://10.42.58.59:50070/": dial tcp 10.42.58.59:50070: connect: connection refused 
  Warning  BackOff    4m54s (x10777 over 2d1h)  kubelet  Back-off restarting failed container namenode in pod suse-observability-hbase-hdfs-nn-0_suse-observability(3ecfb7b2-cad9-47b7-93c6-e10883ed628c) ```

---

**Marc Rua Herrera** (2025-07-14 09:54):
Good morning,
Is it possible to use a custom Elasticsearch instance for SUSE OBS? This is about a customer who has all their data in a large, central Elasticsearch cluster, and they want to centralize SUSE OBS data there as well. So instead of the Elastic we deployed, use their existing one.

---

**Frank van Lankvelt** (2025-07-14 09:58):
we really don't want to go down that route, storing and retrieving data in storage beyond our control.

---

**Frank van Lankvelt** (2025-07-14 10:01):
while it technically might be possible, it's a support nightmare waiting to happen

---

**Marc Rua Herrera** (2025-07-14 10:01):
Okay! Thanks for the response Frank

---

**Paul Gonin** (2025-07-14 10:06):
Let’s not call Observability OBS

---

**Louis Lotter** (2025-07-14 10:39):
@Bram Schuur or @Alejandro Acevedo Osorio can you guys help out here ?

---

**Davide Rutigliano** (2025-07-14 10:44):
Hi @Remco Beckers, I am asking because in OpenPlatform use them together and we had 2 dedicated otel collectors to fetch metrics in SUSE Observability. With CA metrics integration we can remove autoscaling otel collector so I was wondering if you plan to do something similar with other kube-sig projects like descheduler

---

**Davide Rutigliano** (2025-07-14 10:45):
so it's more of a feature request to be evaluated / addressed as a separate task

---

**Remco Beckers** (2025-07-14 10:55):
We've put this ticket on hold while we're defining and implementing a preferred way of setting up the metrics collection for SUSE Observability for these use-cases. We want to provide an out-of-the-box solution (that can be disabled when not needed or vice-versa) to make it easy to setup metric collection from Open Metrics/Prometheus exporter endpoints via the OTel collector.

---

**Remco Beckers** (2025-07-14 10:55):
But why do you have 2 separate OTel collectors for scraping 2 applications? You could just install and configure 1 OTel collector to gather metrics for both.

---

**Alejandro Acevedo Osorio** (2025-07-14 10:59):
@Garrick Tam My hypothesis is that there's some throttling going on on he namenode and that slows down it's startup sequence.
You could try relaxing the probes (showing the current one)
```    Liveness:             http-get http://:nninfo/ delay=0s timeout=1s period=10s #success=1 #failure=3 
    Readiness:            http-get http://:nninfo/ delay=0s timeout=1s period=10s #success=1 #failure=3 ```
or probably give it more CPU (currently)
```    Limits: 
      cpu:                400m
    Requests: 
      cpu:                200m```

---

**Alejandro Acevedo Osorio** (2025-07-14 11:03):
You can see in the logs that the init sequence starts `2025-07-10 23:08:21,594` and the last log message `2025-07-10 23:09:08,090 WARN server.AuthenticationFilter: Unable to initialize FileSignerSecretProvider, falling back to use random secrets. Reason: Could not read signature secret file: /nonexistent/hadoop-http-auth-signature-secret` matches with the liveness probe settings.
BTW that last log line is benign and it's just part of the regular startup

---

**Jeroen van Erp** (2025-07-14 11:23):
Reason is, OBS = Open Build System

---

**Davide Rutigliano** (2025-07-14 12:24):
I meant 2 scraping jobs (we have single collector actually)

---

**Remco Beckers** (2025-07-14 13:29):
Aha ok. Thanks. That clarifies a lot.

---

**Stephen Mogg** (2025-07-14 14:06):
Hi - Quick question about our hosted SaaS offering on AWS.....

Encryption - Assume we use HTTPS for connectivity, but do we encrypt customer logs / Disks? on the back end?

Customer is wondering if we can Observe Fargate nodes and does it fall under the vCPU / RAM metics for billing?

---

**Stephen Mogg** (2025-07-14 14:07):
Appreciate any guidance.

---

**Vladimir Iliakov** (2025-07-14 14:23):
Hi Stephen, the data storing services use AWS EBS volumes and we do use standard AWS KMS service to encrypt them.

---

**Vladimir Iliakov** (2025-07-14 14:23):
The same for the backups stored in AWS S3

---

**Vladimir Iliakov** (2025-07-14 14:28):
&gt; Customer is wondering if we can Observe Fargate nodes and does it fall under the vCPU / RAM metics for billing?
This is for the Observability agent, right? I don't think the agent can be installed to Fargate nodes due to security limitations, <!subteam^S08HEN1JX50> correct me, if I am wrong.

---

**Bram Schuur** (2025-07-14 14:32):
I don't think we are officially supporting fargate right now

---

**Louis Parkin** (2025-07-14 14:33):
@Vladimir Iliakov Fargate is mentioned in the agent code in many places, whether it is to recover from error (because it is fargate), or to collect, process, and transmit metrics is impossible to say without reading the code, or running an agent on a Fargate node.

---

**Frank van Lankvelt** (2025-07-14 14:38):
AFAIK you would have to run the agent as a sidecar container, but doubt it would then even have all the access it needs.
I don't think the "number of hosts" pattern applies on a serverless platform - probably best to collect observability data with OpenTelemetry anyway

---

**Erico Mendonca** (2025-07-14 15:04):
Hi all, getting some timeout errors on Observability on the suse-observability-server pod... What is the corresponding timeout in the yaml?

---

**Erico Mendonca** (2025-07-14 15:05):
Also:
```2025-07-14 12:57:00,347 WARN  akka.kafka.internal.KafkaConsumerActor - [539d9] Partition assignment handler `onRevoke` took longer than `partition-handler-warning`: 15003 ms```

---

**Stephen Mogg** (2025-07-14 15:07):
OK - Thanks for the detail.  Much apprecaited.

---

**Erico Mendonca** (2025-07-14 15:24):
it looks like there is one node in this cluster that's way slower and causes this from time to time...

---

**Mark Bakker** (2025-07-14 17:27):
We will even remove Elasticsearch in the comming 6-18 months most likely

---

**Lisa Guerineau** (2025-07-14 17:40):
Hi Team!  I am looking to share some customer feedback on Observability. This customer is a huge promoter of SUSE and wanted to provide feedback for future consideration, noting they're enthusiastically supportive but are awaiting further maturity of the solution before fully adopting it.

Is this the correct place to post the feedback, or should I email it directly?  If so, who should it be addressed to?  Thank you!

---

**Manuel Recena** (2025-07-14 17:42):
I'm sure @Mark Bakker is eager to hear it.

---

**Mark Bakker** (2025-07-14 17:47):
Yes please, any feedback is always welcome

---

**Lisa Guerineau** (2025-07-14 17:54):
Perfect!  Thank you.

Here is some feedback from Fortinet.

Let me know if you have any questions or require further info. Happy to help!

• *Authentication:*
    ◦ Lack of 2FA support (SAML or Rancher authentication integration).
    ◦ Enabling LDAP authentication locks out local accounts, leading to complete lockout if the connection to the LDAP server is lost.
    ◦ Case #: 01583053 - RFE
    ◦ Case #: 01582891
• *Certificates:*
    ◦ Problems with SUSE Observability trusting certificates issued by the corporate CA. The software expects public certificates instead of corporate-signed certificates.
    ◦ Case #: 01580613
• *Stability:*
    ◦ Frequent crashes of the Observability tool.
    ◦ Case #: 01584807
• *Ops Genie Integration:*
    ◦ The integration is broken; the URL for sending alerts is incorrectly coded and cannot be changed, requiring a developer fix.
    ◦ Case #: 01583584
• *Future Adoption:*
    ◦ The team will hold back on adopting SUSE Observability due to instability and missing enterprise features, planning to revisit it in several months or a year. The team currently uses the standard Prometheus Grafana stack, which is a bit more mature and meets their needs.

---

**Garrick Tam** (2025-07-14 18:01):
I cannot figure out where the default resource values are coming from.

https://github.com/StackVista/helm-charts/blob/master/stable/hbase/templates/hdfs-nn-statefulset.yaml#L65 indicates resource from .Values.hdfs.namenaode.resources; but https://github.com/StackVista/helm-charts/blob/master/stable/hbase/values.yaml#L281 indicates the following:
```    resources:
      limits:
        memory: "1Gi"
      requests:
        memory: "1Gi"
        cpu: "50m"```

---

**Alejandro Acevedo Osorio** (2025-07-14 18:02):
They come from the generated `sizing_values` that correspond to the chosen profile

---

**Garrick Tam** (2025-07-14 18:06):
So I should find Values.hdfs.namenode.resources exists under the sizing_values, got it.  I'll check with customer.
Also, liveness probe changes wouldn't survive a redeploy, right?  Or is there a way to make it survive without changing the chart?

---

**Alejandro Acevedo Osorio** (2025-07-14 18:08):
Liveness probe changes won't survive a redeploy as we don't have a spot for them on the helm chart `values`

---

**Alejandro Acevedo Osorio** (2025-07-14 18:11):
@Bram Schuur We might need to introduce a `startupProbe` here, we use this on tephra as was getting throttled on smaller profiles. https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes Although the namenode is not usually such a slow starter but apparently in this setup it is

---

**IHAC** (2025-07-15 00:12):
@Garrick Tam has a question.

:customer:  NowCom Corporation

:facts-2: *Problem (symptom):*  
Customer sees the message "Something went wrong" in the UI when idle.  But after refreshing the page the UI loads fine.  Then after a while the same message appears.

I haven't try to correlate to pod errors yet.  Still waiting for support log bundle.

Anyone witnessed similar issues or have suggestions on possible cause?

TIA

---

**Garrick Tam** (2025-07-15 02:18):
Can I get some help to understand what is happening with the api pod?

---

**Mark Bakker** (2025-07-15 09:00):
@Lisa Guerineau do you also have the salesforce links to the support cases?

---

**Remco Beckers** (2025-07-15 09:47):
The errors in the screenshot are very unlikley to be related to the errors in the log (the latter would simply result in some empty charts).

---

**Remco Beckers** (2025-07-15 09:48):
It would help to click the `something went wrong` link in the UI to see what error the UI reports there. It apparently is an error that doesn't get logged in the server.

---

**Remco Beckers** (2025-07-15 09:55):
The typical case when this screen appears is when the connection to the server is interrupted and the HTTP calls to update the overview page fail

---

**Remco Beckers** (2025-07-15 09:55):
If that's the case it should automatically recover when the connectivity is restored

---

**Bram Schuur** (2025-07-15 10:58):
@Erico Mendonca does the timeout persist or does it stabilize over time? We typically do not offer these timeouts for tweaking, because if we hit them consistently something is off (we keep tuning the the real-time concerns of the platform a product concern).

Could you ship the logs surrounding these errors (maybe the entire log)? or run our support package? https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/install-stackstate/support-package-logs.html

Last question: which customer is this for?

---

**Erico Mendonca** (2025-07-15 14:46):
Thanks! Here are the logs. I started fiddling with the timeouts I found in the yaml but it didn't do any good. I also started scaling up each of the deployments to see if things would sort themselves out. So far, only the suse-observability-e2es benefited from that. The suse-observability-server still restarts continuosly.

---

**Lisa Guerineau** (2025-07-15 20:43):
@Mark Bakker Here you go!  Let me know if you need anything else.  Happy to help!

Case #: 01583053 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000bRq3gIAC/view) - RFE
Case #: 01582891 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000bKcwpIAC/view)
Case #: 01580613 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000ZlPA6IAN/view)
Case #: 01584807 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000cfAlYIAU/view)
Case #: 01583584 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000bqaenIAA/view)

---

**Garrick Tam** (2025-07-15 23:06):
Customer get 503 errors with the attached detail logs.

---

**Garrick Tam** (2025-07-15 23:38):
Can this be cause by short session timeout on their proxy/gateway?

---

**IHAC** (2025-07-16 02:55):
@Garrick Tam has a question.

:customer:  Disney Cruise Line Technology

:facts-2: *Problem (symptom):*  
This is the second customer reporting periodic UI throwing "Something went wrong".  A reload will successfully load the UI.  This customer exposes the UI behind NGINX ingress that sits behind an F5.

Customer try to click on the error message but only get a sidebar that says "Unknown error" "Load failed".

Can I please get more understand what cause the browser to throw this error?  Is there a persistence web socket connection established between browser and router? pod service or one of the observability service?

---

**David Noland** (2025-07-16 03:34):
Would getting a HAR file from the customer help diagnose the issue?

---

**Remco Beckers** (2025-07-16 10:14):
There is definitely a websocket. But as I mentioned here websocket  (https://suse.slack.com/archives/C079ANFDS2C/p1752653540385399?thread_ts=1752531133.834499&amp;cid=C079ANFDS2C)connectivity issues would show differently. The only way this specific error happens, that I know of, is when the browser is unable to connect to the server at all. Either because you're offline or because there are other network / proxy issues.

---

**Remco Beckers** (2025-07-16 10:16):
If this happens on, for example, an overview page I would expect the UI to recover when it tries to fetch the data again (after 30 seconds it will retry). A reload will indeed have the same effect.

Here also a HAR file with the network traffic would help to confirm this is the problem or troubleshoot further.

---

**Mark Bakker** (2025-07-16 14:59):
Hi Lisa some extra information around their feedback:

• *Authentication:*
    ◦ Lack of 2FA support (SAML or Rancher authentication integration).
        ▪︎ *Rancher SSO support will be released soon after Rancher 2.12*
    ◦ Enabling LDAP authentication locks out local accounts, leading to complete lockout if the connection to the LDAP server is lost.
    ◦ Case #: 01583053 - RFE, *currently we do not support this for safety reasons I can see the reason for the request. We will add this request and track it to see if we get more customers with this ask.*
    ◦ Case #: 01582891 - *I see this is resolved*
• *Certificates:*
    ◦ Problems with SUSE Observability trusting certificates issued by the corporate CA. The software expects public certificates instead of corporate-signed certificates.
    ◦ Case #: 01580613 - *we are working on support for this*
• *Stability:*
    ◦ Frequent crashes of the Observability tool.
    ◦ Case #: 01584807 - *the case is closed, it's not clear if there still is a problem?*
• *Ops Genie Integration:*
    ◦ The integration is broken; the URL for sending alerts is incorrectly coded and cannot be changed, requiring a developer fix.
    ◦ Case #: 01583584 - *the case is closed, it's not clear if there still is a problem?*
• *Future Adoption:*
    ◦ The team will hold back on adopting SUSE Observability due to instability and missing enterprise features, planning to revisit it in several months or a year. The team currently uses the standard Prometheus Grafana stack, which is a bit more mature and meets their needs.

---

**Tanuj Kohli** (2025-07-16 15:32):
Hi Team, Does StackState still has a limit of 500 Nodes of 16Gb/4vCPU or has it increased?

---

**Jeroen van Erp** (2025-07-16 15:36):
https://documentation.suse.com/cloudnative/suse-observability/next/en/k8s-suse-rancher-prime.html

---

**Jeroen van Erp** (2025-07-16 15:36):
Goes up to 4000 nodes in an HA setup now

---

**Mark Bakker** (2025-07-16 16:21):
No it's 4K at the moment

---

**Bram Schuur** (2025-07-16 16:31):
I took a brief look, i have not much time unfortunately:
• I see you scaled out the the stackstate-server, which is not a scalable pod, its supposed to run singleton.
•  I also see in those logs some data corruption. It is unclear to me how that happened (`java.lang.IllegalStateException: Cannot un-exist verified existing stackelement: v[76277401205890],{}, loaded=VERIFIED, existing=true,`), might be you tried to scale the stackgraph pod
I would recommend reinstalling and staying with the sizing guides we provide: https://documentation.suse.com/cloudnative/suse-observability/next/en/k8s-suse-rancher-prime.html#_requirements

---

**Erico Mendonca** (2025-07-16 16:44):
That's what's mysterious about this issue: it happened before, even without messing with scaling. *Something* gets corrupted after a while and it looks like it never can finish recovering due to fixed timeouts. The last clean install lasted for a little over a month (49 days) before it started crashing. I'll do another clean install, do you think I should try another profile? This one was installed as the "nonha-10" profile.

---

**Bram Schuur** (2025-07-16 16:47):
I am not sure how many nodes you are observing, you should calculate the required nodes based on the formula on the installation instructions, you can keep an eye on the system notification whether you are not overloading the system.

---

**Erico Mendonca** (2025-07-16 16:49):
It's just 3 nodes, but with quite a few workloads (including the entire SUSE AI stack + other internal partner's projects related to AI).

---

**Bram Schuur** (2025-07-16 16:57):
Gotcha, it could be that ai has an unexpected impact, what is the size of those nodes? Cpu/memory?

---

**Erico Mendonca** (2025-07-16 17:02):
2x 8vCPU 32GiB and 1x 16x vCPU 78GiB + L4 GPU

---

**Bram Schuur** (2025-07-16 17:07):
Gotcha, that would be 9 default nodes, you could go for 20-nonha to be a bit safer

---

**Garrick Tam** (2025-07-16 17:21):
I will work with customers to obtain a HAR for review.  Let's see how long this will take given the occurrence is random.

---

**Garrick Tam** (2025-07-16 17:23):
This is only a recent report from two customers.  These customers have been using Observability over several releases already and only recently report this issue.  Have there been any recent changes/upgrades to the websocket code base?

---

**Remco Beckers** (2025-07-16 17:48):
I would need to check that. Not that I'm aware of though. I've also checked with our frontend developers and the websocket connection is not the thing that would trigger these errors. I've also tried to reproduce it, but I only managed to get similar behavior by disconnecting from the internet (or by shutting down the `router` or `api`/`server` of the platform).

---

**Remco Beckers** (2025-07-16 17:59):
However if they have skipped a few version and recently upgraded to the latest version (at least NowCom was running the latest version) there may be a change in the websocket handling which was introduced in version 2.3.0 from the end of January (the latest version that NewCom is now on is 2.3.5). I've asked our frontend developers to have a closer look.

---

**Garrick Tam** (2025-07-16 18:06):
Disney is on 2.3.3.

---

**Garrick Tam** (2025-07-16 18:08):
I also check if the issue arise adjacent to upgrade of cluster hosting Observability.

---

**Brian Six** (2025-07-16 18:37):
IHAC wanting to forward logs from Splunk to Observability.  Will the Splunk stackpack help make this happen or is it all consulting?

---

**Mark Bakker** (2025-07-16 18:56):
Nope, the Splunk StackPack is mainly for some old customers and has the ability to send data to SUSE Observability based on Splunk queries. I would not recommend using it.
The agent automatically collects all Pod logs already.
For other types of log we have an epic to support OpenTelemetry logs, this will be in 2026.
Hope this helps?

---

**Garrick Tam** (2025-07-16 19:49):
Attached is the HAR captured during the issue.  There is a 504 at Wed, 16 Jul 2025 17:22:29 GMT.

Customer also states:
```1. I didn't noticed the same issues before.
2. Observability deployed to downstream cluster  version - v1.31.9+rke2r1```

---

**Brian Six** (2025-07-16 21:21):
So at this point we would tell a customer we can’t receive logs forwarded from splunk until OpenTelemetry Logs support ships next year.

---

**Erico Mendonca** (2025-07-17 02:03):
Where does the Observability UI Extension hold the service token? I had to reinstall Observability from scratch and when I uninstall/reinstall the UI extension it just logs me out of the Rancher UI when it tries to load the main panel. I *think* it's using an old service token (hasn't asked for a new one...)

---

**Amol Kharche** (2025-07-17 05:37):
Its under configuration.
Rancher UI -&gt; More Resources  -&gt; observability.rancher.io (http://observability.rancher.io) -&gt;Configurations
```$ kubectl get Configuration -n default suse-observability -o yaml```

---

**Amol Kharche** (2025-07-17 05:38):
We have a bug  (https://jira.suse.com/browse/SOBS-3)open for this.

---

**Marc Rua Herrera** (2025-07-17 10:31):
Hi team, I see a lot of warning messages in a customer environment. This message appears in agent-node-agent. Does that mean that some processes are being dropped? Can I unlock this limitation?

---

**Bram Schuur** (2025-07-17 10:55):
@Andrea Terzolo I think this message is benign, could you verify? And maybe also change it to info or drop it if it makes no sense

---

**Andrea Terzolo** (2025-07-17 10:58):
sure let me take a look!

---

**Andrea Terzolo** (2025-07-17 11:15):
I agree this shouldn't be a warning, i will open a MR
&gt; Does that mean that some processes are being dropped?
From a first quick look i would say no, it just means the agent will send more messages to the platform because it cannot fit all the processes in just one message

---

**Marc Rua Herrera** (2025-07-17 11:57):
I don't know if it is related, but we also saw a lot of OOM killed in the pods where these message appear. We have increase the memory for now. And we will be monitoring it.

Thanks for the response!

---

**Andrea Terzolo** (2025-07-17 12:20):
uhm that log means that for sure the node is doing more than usual so probably yes, the agent is under stress, not super easy to correlate that log with a OOM though

---

**Andrea Terzolo** (2025-07-17 12:28):
BTW this is the MR with the fix https://github.com/StackVista/stackstate-process-agent/pull/201

---

**Ala Eddin Eltai** (2025-07-17 14:43):
Hi @Mark Bakker
Do we have some timeline for that ? IHAC who keeps asking me on that one.
From what I see from SUSE Obs side we are almost done: https://stackstate.atlassian.net/browse/STAC-21788, and from Rancher side we have https://github.com/rancher/rancher/issues/49571 with the target version 2.12
So I assume that if Rancher 2.12 delivers the Rancher OIDC Feature we will have the SUSE Obs RBAC available for them ?
I cant find more stuff/tickets on that so Im wondering if 2.12 is really the version this will come.

---

**Mark Bakker** (2025-07-17 14:57):
We indeed we create a release of Observability shortly after Rancher 2.12 implementing this.

---

**Ala Eddin Eltai** (2025-07-17 14:59):
Alright ty!
besides the tickets i mentioned is there some infopage on confluence regarding that?

---

**Erico Mendonca** (2025-07-17 15:12):
Alright, there are no Configuration objects, even after installing the UI extension. No observability.rancher.io (http://observability.rancher.io) CRD either. This Observability has been recently uninstalled, all PVCs removed, then installed again. Shouldn't this CRD be installed with the extension helm chart?

---

**Amol Kharche** (2025-07-17 15:36):
What did you see when you click over Rancher UI-&gt; Extensions ? Did you see observability extension? What rancher version using ?

---

**Erico Mendonca** (2025-07-17 15:38):
Yes, I see the Observability extension version 2.1.4. I can install it, it asks me to reload and appears as installed. But when I click on the cluster link, it goes back to the authentication screen.

---

**Erico Mendonca** (2025-07-17 15:38):
No matter how many times I authenticate, it'll loop until I remove the extension.

---

**Erico Mendonca** (2025-07-17 15:38):
Running on Rancher 2.10.2.

---

**Amol Kharche** (2025-07-17 15:41):
This issue occurs when
1. Expired Token – When the access token has passed its expiration time and is no longer valid.
2. Missing Token – When the token is removed from stackstate.
3. Invalid Token – When an incorrect, malformed, or tampered token is used.

---

**Erico Mendonca** (2025-07-17 15:42):
The thing is, I uninstalled Observability completely yesterday and reinstalled it. I created a new service token, but it didn't present me with a way to enter it.

---

**Amol Kharche** (2025-07-17 15:45):
From my lab setup it looks like I have to reconfigure observability extension URL and token or edit configuration settings `kubectl get Configuration`

---

**Erico Mendonca** (2025-07-17 15:46):
since I uninstalled both the extension and Observability itself, shouldn't it present me with a link to enter the token again, like in the initial installation?

---

**Amol Kharche** (2025-07-17 15:55):
Well for me, It is taking old setting(Previously setup) and when I clicked edit configuration then I can able to put new values like URL and token.

---

**Erico Mendonca** (2025-07-17 15:57):
I don't have that resource...
```[root@rancher03 ~]# kubectl get Configuration -n default suse-observability -o yaml
error: the server doesn't have a resource type "Configuration"
[root@rancher03 ~]# kubectl get crd | grep -i observability
[root@rancher03 ~]# ```

---

**Remco Beckers** (2025-07-17 16:01):
We're trying to reproduce the behavior but haven't had much success yet. The reason for the 503 error is unclear but could be related to a very temporary problem of a reverse proxy or loadbalancer to connect to the upstream server (that's also the exact error message). For example a limit of maximum # of allowed TCP connections is reached.

We're looking into how this error resulted in the error page specifically, since it shouldn't (for the API call that we see failing here).

We didn't have any changes directly related to the error handling or the request processing (not in our backend nor in the frontend). There have been quite a lot of other changes though, they may indirectly contribute to small changes in behavior. I've logged a ticket for further investigation https://stackstate.atlassian.net/browse/STAC-23087.

---

**Remco Beckers** (2025-07-17 16:03):
I have one more question though: Does the UI automatically recover after  30 seconds (which is when the next update would happen)? Or do they have to reload the page? From the HAR file it looks like it indeed recovered.

---

**Bram Schuur** (2025-07-17 16:12):
approved @Andrea Terzolo

---

**Erico Mendonca** (2025-07-17 16:21):
So, it turns out the configuration resource is located in the local cluster. I was looking in the observed cluster. Maybe add a documentation note for that?
Also, the configuration should have been removed when the extension is uninstalled.

---

**Remco Beckers** (2025-07-17 16:53):
We've managed to get to the same result, at least in some cases: we end up on the "Something went wrong" error page even when just 1 request fails to produce a proper result.

I'll update the ticket and we'll start looking into a solution. I'm still not sure how this only appeared now though.

---

**Garrick Tam** (2025-07-17 18:19):
&gt; I have one more question though: Does the UI automatically recover after 30 seconds (which is when the next update would happen)? Or do they have to reload the page?
From Disney's description, it does sound like the page will automatically reload successfully.
```If I leave the observability window open, it will frequently present me with the attached "Something went wrong" screen. If I leave it alone, it will eventually reload the page that was being displayed before that appeared.```

---

**Remco Beckers** (2025-07-17 18:33):
Ok thanks.

---

**Garrick Tam** (2025-07-17 18:34):
I asked NowCom to confirm if waiting will reload successfully but customer is OOO so probably not going to get quick response.

---

**Garrick Tam** (2025-07-17 18:34):
Let me know if further information is needed from either customers' environment.

---

**Remco Beckers** (2025-07-17 18:53):
We still don't understand where these 503 errors are coming from. It would be helpful if they could check in their logs if they can see the 503 request. I don't see it in the SUSE Observability logs, but it turns out our router doesn't log these.

I noticed for Disney you mentioned:
&gt; This customer exposes the UI behind NGINX ingress that sits behind an F5.
So in that case they could check the NGINX logs for the requests that have a 503 response.

---

**Remco Beckers** (2025-07-17 18:53):
But I can understand if they don't have the time to search those logs.

---

**Garrick Tam** (2025-07-17 18:56):
I believe both customer are using Rancher and NowCom is likely exposing Observability UI with NGINX ingress as well.  Let me ask if they can search through their NGINX logs and see any 503 for Observability ingress.

---

**Garrick Tam** (2025-07-18 01:57):
Team, Here's an update.  The deployment still isn't up.  After fixing the hbase-hdfs-nn pod with more CPU, now api, checks, health-sync, notification, slicing, state, sync are crashlooping.  I see a common error except for initializer.  The common error is:
```2025-07-17 17:23:24,149 ERROR com.stackstate.servicemanager.StackStateServiceManagerImpl - Failed to start stackState
com.stackstate.services.ServiceException: Tenant Initialization: Retrying stopped, starting service failed.```
What else could be the problem here?  Attached is fresh support log bundle.

---

**Amol Kharche** (2025-07-18 06:20):
It should be in local cluster where you are configuring extension.

---

**Amol Kharche** (2025-07-18 06:21):
&gt; the configuration should have been removed when the extension is uninstalled.
@Bram Schuur Shall I raised ticket for this ? I saw that the configuration is still intact.

---

**Bram Schuur** (2025-07-18 07:33):
@Amol Kharche yes, thanks! Could you put it into the 'incoming' sprint? And link to this slack thread

---

**Amol Kharche** (2025-07-18 07:39):
By the way I just found the one which is raised by you https://stackstate.atlassian.net/browse/STAC-22825.

---

**Amol Kharche** (2025-07-18 07:57):
Raised new one :- https://stackstate.atlassian.net/browse/STAC-23090

---

**Remco Beckers** (2025-07-18 08:38):
If it keeps happening (seems like it), they can also enable access logs on the router that is part of SUSE Observability which should log 503 errors too when it is "generating" them. This can be done by adding an extra configuration to the helm installation:
```--set 'stackstate.components.router.accesslog.enabled=true'```
This will result in full access logs, so it's quite a lot of logging (which is why it is disabled by default) but will show us more clearly where the 503 is coming from.

---

**Alejandro Acevedo Osorio** (2025-07-18 09:16):
So you need to work out the license key issue

---

**Garrick Tam** (2025-07-18 16:22):
Thank you.  I should have caught that.

---

**Alejandro Acevedo Osorio** (2025-07-18 16:24):
No problem

---

**Garrick Tam** (2025-07-18 18:19):
I will try and see if it is reproducible in a lab.  If yes, then I can enable accesslog in the lab.

---

**Garrick Tam** (2025-07-18 18:19):
Also, NowCom also confirm that when the error page is left alone for 30s, it will automatically refresh and load successfully.

---

**Lisa Guerineau** (2025-07-18 19:05):
Thank you for this added feedback. I will share some of these updates with the team.
Regarding the cases that have been closed, yes, I believe it's still an issue (stability, ops genie), but I think they have just decided to stop using the observability tool for now and closed the conversations.
We will continue to communicate improvements and encourage them to continue testing it out.

---

**Garrick Tam** (2025-07-18 23:54):
I didn't see the error in the UI but I caught an HTTP 503 in the router.  Not sure if this is expected or the same as reported.
```&gt; k logs -f suse-observability-router-55d79c7598-9b8zf | grep 'HTTP/1.1" 503'
[2025-07-18T21:51:41.343Z] "GET /api/components/94971083769560/bindmetric?metricBindingIdentifier=urn%3Astackpack%3Akubernetes-v2%3Ashared%3Ametric-binding%3Aservice-http-response-status-percentage-summary HTTP/1.1" 503 UC 0 95 154 - "10.124.0.37" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36" "7d0c57491d37b32a9932a6a0742d50f2" "observability.146.190.1.213.sslip.io (http://observability.146.190.1.213.sslip.io)" "10.42.1.20:7070"```

---

**Marc Rua Herrera** (2025-07-21 11:29):
Good morning,
I'm seeing some strange behaviour in one of our customer environments. They encountered the known Tephra error. After restarting the Tephra pods, the environment turned green again. However, the components are not being updated.
There are no monitors in the pods that were just restarted, and no health checks are being performed on them (since no monitors are present).
What should I look into here? Which pod is responsible for assigning monitors to the components?
The logs I've reviewed so far look fine. We did see some errors in the sync pods earlier, but after a restart, those errors disappeared.

---

**Bram Schuur** (2025-07-21 11:38):
The 'checks' pod runs the monitors, the 'health-sync' pod puts those into stackgraph. The 'state' pod is responsible for creating a state on the component

---

**Bram Schuur** (2025-07-21 11:40):
We've written up a reference on that here: https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/install-stackstate/advanced-troubleshooting.html#_processing_and_serving

---

**Amol Kharche** (2025-07-21 12:03):
@Saurabh Sadhale *01587955* :point_up_2:

---

**Marc Rua Herrera** (2025-07-21 12:04):
Thanks Bram. Still no clue why is not updating the health. The only thing I see in the health-sync pod is that it cannot find the server-0 pod, which I understand is our classic api pod. Which is up and running:

---

**Amol Kharche** (2025-07-21 12:05):
@Marc Rua Herrera Is this Rabobank customer? We have received high severity case.

---

**Marc Rua Herrera** (2025-07-21 12:05):
Indeed. This is their prod environment

---

**Remco Beckers** (2025-07-21 13:05):
Thanks. I've managed to get a few reproductions as well (not as many as you have) in the router log. Seems like it occassionally gets triggered. I'll be reporting a bug  report for this specifically. Looks like it will take some time to figure this out though.

---

**Bram Schuur** (2025-07-21 14:12):
Okey, gotcha, thanks for that writeup:+1:. So no more crashloops but the states are missing. In what way can i help you further?

---

**Saurabh Sadhale** (2025-07-21 14:27):
How to get the health status to “CLEAR” ?

The customer is looking for an RCA as well. They will share their pre-restart logs from checks,notifications, state and tephra pods for analysis.

I will also take a look but I will need your help here.

---

**Bram Schuur** (2025-07-21 15:01):
Based on the chat with @Saurabh Sadhale we formulated the following things to check to make progress:
• Requets current status after the system has settled
• Investigate whether not only the component have no state but also there are no monitors
• See whether other pods have state and what state is on there
• Look at the monitors overview page and see whether the monitors have been disabled
• Look at the monitors overview page and see what components the pod related monitors do end up on ('Pod Waiting State' etc), maybe there are errors?

---

**Bram Schuur** (2025-07-21 15:02):
I also added a wild hypothesis: Wild Hypothesis: they bring in splunk data merging with the pod, which causes the labels to be replaced and the monitors to fail. This would (maybe? partially?) explain the messages in the checks pod.

---

**Saurabh Sadhale** (2025-07-21 16:13):
@Bram Schuur the customer returned back with the latest update.

• The pods which were earlier in Unknown state now are back to “CLEAR” health state. However, the customer is concerned that they deleted a pod “dynatrace” and the health state is not returning to “CLEAR” even after 8 mins. 
The question here is how much time does it take ? or is there a vector which we can take a look ?

About the monitors,
• They have a few monitors in disabled state but not the ones that give the pod health state. They have noticed that a of the monitors are in Error state. I am attaching screenshots for review.

---

**Remco Beckers** (2025-07-21 16:23):
https://stackstate.atlassian.net/browse/STAC-23097

---

**Bram Schuur** (2025-07-22 09:55):
1. For dynatrace i can't say, if it is using expiry-based removal removal can take quite a while. If it is snapshot based it should be a matter of minutes, depending on how often the python check runs.
2. To investigate why the monitors are in error, you can run `sts monitor status` command (with the monitor id) to figure out what the error is. We used to have a troubleshooting guide on this but i can't seem to find it now

---

**Saurabh Sadhale** (2025-07-22 10:32):
Thanks for updating @Marc Rua Herrera at this point I am on another customer call.

---

**Chris Riley** (2025-07-22 13:48):
@Bram Schuur @Marc Rua Herrera Just FYI that the customer escalated this case today.

I asked them about the impact of this issue, and below is their response (FYI for you both):

_The primary impact in our suseobs-pa environment is that there are no health updates visible on components._

_As mentioned yesterday, for pod restarts it may take tens of minutes to get any health state._
_And this morning I changed one of the signals flowing into the environment to be critical. Something that was updated promptly in other environments, but not in this one for at least 2 hours (by which time I ended the test)._
_Forced topology updates do seem to be reflected in suseobs-pa fairly quickly._

_We had a user acceptance test running to validate this suseobs-pa environment against our existing stackstate environment. After the test the suseobs environments were supposed to replace the stackstate ones._

_But the suseobs-pa environment is now broken (as in, running but not usable) and we don't know why._

---

**Marc Rua Herrera** (2025-07-22 14:50):
Hello, quick question. It's product-related:
Can we extract data from SUSE Observability? Also, is the OpenAPI specification available here: https://gitlab.com/stackvista/platform/stackstate-openapi/-/blob/master/spec/openapi.yaml ready to be consumed by our customers?

---

**Saurabh Sadhale** (2025-07-22 14:51):
@Bram Schuur thank you for your update. I am responding to your previous updates now.

1. For dynatrace i can’t say, if it is using expiry-based removal removal can take quite a while. If it is snapshot based it should be a matter of minutes, depending on how often the python check runs.
>>  Can you please help me understand how to find if this is expiry-based or snapshot based from the logs or any commands ?
>> 
The customer actually came back and mentions that the dynatrace pods that they used for example it took about 45 mins to go from Unknown to Clear status.

I had a look at the monitors in error state. The monitors that are in error state are complainnig about stale data and  no new monitor health states received in the configured ‘intervalSeconds’.

Looking at the health-sync pod, it has a high processing latency warning with a latency of 8 minutes.

And individual health streams:

```% sts health status -u urn:health:stackstate-process-agent:process_check
Stream consistency model: REPEAT_SNAPSHOTS

Aggregate metrics for the stream and all substreams:
METRIC        | 300S AGO    | 300-600S AGO | 600-900S AGO
latency seconds   | 480      | 480      | 480    
messages per seconds | 0.413333333333 | 0.823333333333 | 0.713333333333
creates per seconds | -       | -       | -
updates per seconds | -       | -       | -
deletes per seconds | -       | -       | -```
Errors for non-existing substreams:
```MESSAGE                                            | COUNT
substream with id `urn:host:/aks-suseobs2-12265403-vmss000004-suseobs-aks-pa-cluster` expired | 3
substream with id `urn:host:/aks-suseobs2-12265403-vmss000000-suseobs-aks-pa-cluster` expired | 9
substream with id `urn:host:/aks-system-11509349-vmss000002-suseobs-aks-pa-cluster` expired | 8
substream with id `urn:host:/aks-suseobs2-12265403-vmss000003-suseobs-aks-pa-cluster` expired | 9
substream with id `urn:host:/aks-suseobs1-83642241-vmss000003-suseobs-aks-pa-cluster` expired | 3```
Other health streams also have 480s latency. Bit strange that they all have a latency of exactly 8 minutes.

This doesn’t explain the slow appearance of a status on restarted pods (like dynatrace).

Customer has also tested with the splunk health searches where they forced a bunch of component to critical state and there the results are better.

We need your help for further troubleshooting.

---

**Bram Schuur** (2025-07-22 15:57):
That api is subject to change and not for public consumption, right now we do not offer a stable data api

---

**Bram Schuur** (2025-07-22 17:41):
i have time tomorrow to hop into a call, maybe 10:00?

in the meanwhile you can look how healthy the health-sync pod is, and kafka aswell. Whether they are maxing out their cpu/memory/disk. Might be good to check the receiver pod aswell

---

**Paul McKeith (m 248-761-6229 EDT)** (2025-07-23 04:50):
Hi Team. I have a prospect that wants Observability solution that scales. They have 5,000 stores each with a single 3 node cluster.  
I understand we are working on way to scale for Edge. 
What is our largest deployment to date? 
Any ETA for a large scale solution?
(Sorry for the cross post. Was not sure which channel I’d best for my Q).

---

**Louis Lotter** (2025-07-23 08:01):
@Bram Schuur may be able to give more accurate information.

---

**Louis Lotter** (2025-07-23 08:02):
It's about 4000 nodes atm.

---

**Louis Lotter** (2025-07-23 08:03):
We don't have any ETA's but we are currently looking at a customer with a bigger setup than this. If things go well in our efforts there the number may go up.

---

**Bram Schuur** (2025-07-23 08:05):
Indeed, you are right on the scaling @Louis Lotter. 

the edge use case itself is pretty far on the road map though, e.g. Supporting intermittent connectivity, and other edge specific uses

---

**Saurabh Sadhale** (2025-07-23 08:49):
@Bram Schuur should I schedule a call for 10:00 your time ? Would you be available to check with the customer ?

---

**Bram Schuur** (2025-07-23 08:54):
yes, i will be there

---

**Bram Schuur** (2025-07-23 08:54):
10:00 my time

---

**Saurabh Sadhale** (2025-07-23 08:55):
I am scheduling a call and you should soon see an invite.

---

**Dinesh Chandra** (2025-07-23 09:08):
Just noticed `rancher:` under authentication in observability values. Didnt find any documentation for same. Any details related to Rancher for Auth?

```  authentication:
    adminPassword: $2a$10$qokt6Nl2GE9tYSRsBe6rA.nWzkw/DaTfDD9HDhof7yw6gNrRmSPTu
    file: {}
    fromExternalSecret: null
    keycloak: {}
    ldap: {}
    oidc: {}
    rancher: {}```

---

**Bram Schuur** (2025-07-23 09:13):
@Alejandro Acevedo Osorio do you know more about that one?

---

**Amol Kharche** (2025-07-23 09:18):
On almost every nodes I can see CPU Limits crossed 180% to 248%.

---

**Marc Rua Herrera** (2025-07-23 09:19):
Thanks Bram. This includes the Analytics API we had before?

---

**Marc Rua Herrera** (2025-07-23 09:20):
I am free at 10. Add me in this call if you think I can be of any value there

---

**Saurabh Sadhale** (2025-07-23 09:25):
@Bram Schuur in the latest logs we can also see  OOM kills for one of the NODES.

```name: aks-suseobs1-83642241-vmss000002

Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests       Limits
  --------           --------       ------
  cpu                7475m (95%)    23215m (296%)
  memory             27746Mi (44%)  40966Mi (65%)
  ephemeral-storage  7Mi (0%)       3962Mi (2%)
  hugepages-1Gi      0 (0%)         0 (0%)
  hugepages-2Mi      0 (0%)         0 (0%)
Events:
  Type     Reason      Age   From            Message
  ----     ------      ----  ----            -------
  Warning  OOMKilling  26m   kernel-monitor  Memory cgroup out of memory: Killed process 1728678 (process-agent) total-vm:3414668kB, anon-rss:339876kB, file-rss:81008kB, shmem-rss:0kB, UID:0 pgtables:1152kB oom_score_adj:999
  Warning  OOMKilling  26m   kernel-monitor  Memory cgroup out of memory: Killed process 1728648 (init-process.sh) total-vm:4420kB, anon-rss:420kB, file-rss:2832kB, shmem-rss:0kB, UID:0 pgtables:44kB oom_score_adj:999
  Warning  OOMKilling  26m   kernel-monitor  Memory cgroup out of memory: Killed process 1728687 (process-agent) total-vm:3414668kB, anon-rss:342112kB, file-rss:81228kB, shmem-rss:0kB, UID:0 pgtables:1152kB oom_score_adj:999```

---

**Alejandro Acevedo Osorio** (2025-07-23 09:27):
That's a placeholder for the upcoming feature. Using `Rancher` as an OICD provider, still in `Coming soon` state

---

**Chris Riley** (2025-07-23 09:28):
Thanks all ... please let me know how the call goes today.

---

**Alejandro Acevedo Osorio** (2025-07-23 09:29):
I think the Rancher team will release the feature on the upcoming release, and we prepared for Observability for that

---

**Sanne Vloon** (2025-07-23 12:23):
@David Stauffer @David Noland @Louis Lotter This is one of the biggest customers in The Netherlands and our only FSI client. We're trying to position SUSE on a broader scale in this account, but with all the Stackstate issues over the last period, we're burning our relationship with them. They're paying $800k per year for the product. Can we please give this the highest priority.
The customer has escalated this officially with the local Account Team.

@Ton Musters @Kees van Bekkum for visibility.

---

**Louis Lotter** (2025-07-23 12:32):
@Sanne Vloon My team is quite aware about the importance of this customer. We were part of the effort in landing them in the first place. They have our focus. We have been meeting with them regularly and have made fixes for the issues as they come up. Some of the problems are not trivial to fix though.

---

**Sanne Vloon** (2025-07-23 12:34):
Thank you for the swift reply and happy to read you’re all on it.

---

**Chris Riley** (2025-07-23 12:39):
@Sanne Vloon I'm monitoring this from a support perspective as the customer escalated this (via support channels) yesterday. The support team, and product teams, are actively engaged on working through the current issue.

---

**Paul McKeith (m 248-761-6229 EDT)** (2025-07-23 13:08):
Thank you both!

---

**Bram Schuur** (2025-07-23 15:15):
indeed. analytics is being deprecated (we cannot support groovy due to the security risks). Our medium term goal is to offer a stable data api, but that is not available right now

---

**Bram Schuur** (2025-07-23 15:43):
The customer environment is functioning again. We did a write-up. Where can i find the customer case to put the report? (cc @Marc Rua Herrera do you know?)

---

**Chris Riley** (2025-07-23 15:45):
@Bram Schuur - that's great to hear. So it's fixed or workaround provided?

Case is here (https://suse.lightning.force.com/lightning/r/Case/500Tr00000eddP4IAI/view?ws=%2Flightning%2Fr%2FEscalation__c%2Fa3LTr00000XgIXgMAN%2Fview). If you cannot access, send everything to me and I will add it as an internal post.

---

**Marc Rua Herrera** (2025-07-23 15:55):
I think the case is opened in the new support platform. @Saurabh Sadhale do you know which case is it?

---

**Bram Schuur** (2025-07-23 16:00):
it seems i don't have access there, could one of you place the answer we put in this google doc there? https://docs.google.com/document/d/1Keltkd_As6PzKQtjMWmh9tbJ9nDi6QqiR4s5VYKok8A

---

**Bram Schuur** (2025-07-23 16:03):
@John Krug @Akash Raj somehow our docs are offline. This is not showing: https://documentation.suse.com/cloudnative/suse-observability/next/en/classic.html

this is for me:
https://documentation.suse.com/cloudnative/suse-observability/

---

**Bram Schuur** (2025-07-23 16:28):
cc @Louis Lotter not sure who to escalate to, it is not great having our docs offline

---