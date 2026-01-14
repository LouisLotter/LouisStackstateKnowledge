# Slack Channel: #prod-ranchersupport-suseobservability

Exported conversations for search and reference.

---

**David Noland** (2024-07-18 17:08):
@Mark Bakker when you have a chance, please loop in a few others in StackState that can help when you are on PTO between 5-AUG to 23-AUG. Thanks!

---

**Mark Bakker** (2024-07-22 14:05):
@Lukasz Marchewka @Vladimir Iliakov @Alejandro Acevedo Osorio @Bram Schuur @Frank van Lankvelt Please join this channel to help supporting David’s first and second line support team supporting StackState.

---

**Mark Bakker** (2024-07-22 14:05):
Especially during the transition and vacation period this is an efficient way to sync on support issues.

---

**David Noland** (2024-07-29 08:13):
Hi - bit of an urgent issue, we are having an outage of one of our Hosted Rancher customers and our SaaS StackState isn't showing any metrics when I go to Clusters:

---

**Frank van Lankvelt** (2024-07-29 08:18):
I'm seeing a lot of unauthorized requests coming in, is the API key on the agent correct?

---

**David Noland** (2024-07-29 08:20):
It was all working a few weeks back. This is the API key we are using `KCOU55s1bmMRbWVi45Z7kwd1f6LKWT` for all agents.

---

**Frank van Lankvelt** (2024-07-29 08:21):
yeah, that's apparently not accepted.  From the receiver logs:
```2024-07-27 08:17:41
	
2024-07-27 06:17:41,163 WARN com.stackstate.api.ReceiverRoutes - 10.0.0.76 - POST http://suseus-trial.app.stackstate.io/stsAgent/logs/k8s?api_key=KCOU55s1bmMRbWVi45Z7kwd1f6LKWT (2489): 401 Unauthorized Authentication is possible but has failed or not yet been provided.```

---

**David Noland** (2024-07-29 08:25):
Would someone be able to look into why it appears the API key changed?

---

**Vladimir Iliakov** (2024-07-29 08:26):
The correct key is `u9KCOU55s1bmMRbWVi45Z7kwd1f6LKWT`

---

**Vladimir Iliakov** (2024-07-29 08:26):
It hasn't been changed after creation.

---

**David Noland** (2024-07-29 08:27):
But all my clusters were working and now they are now not working.

---

**Frank van Lankvelt** (2024-07-29 08:27):
damn, you're fast.  Just found it myself

---

**Vladimir Iliakov** (2024-07-29 08:28):
&gt; But all my clusters were working and now they are now not working.
I can't explain that, I see the API key hasn't changed. Any chances the agent on your clusters was redeployed with the wrong key ? :thinking_face:

---

**David Noland** (2024-07-29 08:29):
No, all 20+ clusters were using the same key. Now they are all not working

---

**David Noland** (2024-07-29 08:29):
I have the YAML saved that was used to deploy each cluster.

---

**Vladimir Iliakov** (2024-07-29 08:30):
It has `KCOU55s1bmMRbWVi45Z7kwd1f6LKWT` and not `u9KCOU55s1bmMRbWVi45Z7kwd1f6LKWT`, right?

---

**David Noland** (2024-07-29 08:30):
Two examples:
```apiVersion: v1
kind: Namespace
metadata:
  name: stackstate
---
apiVersion: helm.cattle.io/v1 (http://helm.cattle.io/v1)
kind: HelmChart
metadata:
  name: stackstate-k8s-agent
  namespace: stackstate
spec:
  chart: stackstate-k8s-agent
  repo: https://helm.stackstate.io
  targetNamespace: stackstate
  valuesContent: |-
    stackstate:
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      cluster:
        name: abax
      url: https://suseus-trial.app.stackstate.io/receiver/stsAgent```
and this:
```apiVersion: v1
kind: Namespace
metadata:
  name: stackstate
---
apiVersion: helm.cattle.io/v1 (http://helm.cattle.io/v1)
kind: HelmChart
metadata:
  name: stackstate-k8s-agent
  namespace: stackstate
spec:
  chart: stackstate-k8s-agent
  repo: https://helm.stackstate.io
  targetNamespace: stackstate
  valuesContent: |-
    stackstate:
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      cluster:
        name: demo-hosted
      url: https://suseus-trial.app.stackstate.io/receiver/stsAgent```

---

**David Noland** (2024-07-29 08:30):
Key looks looks same, only now has a `u9` in front of it.

---

**Vladimir Iliakov** (2024-07-29 08:32):
Right, we store it encrypted in Git, that is why I am sure it hasn't been changed

---

**Vladimir Iliakov** (2024-07-29 08:32):
I can modify the the key in the tenant so you don't have to redeploy the agents

---

**David Noland** (2024-07-29 08:33):
ok, that might be easiest.

---

**David Noland** (2024-07-29 08:35):
Anyway, our customer outage is fixed for now. It's 2:30am, so going back to bed soon. But something weird happened with our API key. I deployed 20+ agents over a month ago with this api key and today noticed all metrics were gone (I've been on PTO for about 1 week)

---

**Frank van Lankvelt** (2024-07-29 08:36):
@Vladimir Iliakov: could it have been entered as a managed ingestion api key?

---

**David Noland** (2024-07-29 08:37):
Now getting this

---

**Vladimir Iliakov** (2024-07-29 08:37):
The API is being restarted

---

**David Noland** (2024-07-29 08:39):
alright. anyway, going offline now. I'll check again tomorrow (Monday) or Tuesday

---

**Vladimir Iliakov** (2024-07-29 08:41):
&gt; @Vladimir Iliakov: could it have been entered as a managed ingestion api key?
I barely know what it is and less how it is configured )))

---

**Vladimir Iliakov** (2024-07-29 08:42):
I still see the errors coming
```2024-07-29 06:41:15,144 WARN  com.stackstate.api.ReceiverRoutes - 10.0.0.66 - POST http://suseus-trial.app.stackstate.io/stsAgent/api/v1/series?api_key=KCOU55s1bmMRbWVi45Z7kwd1f6LKWT (1268): 401 Unauthorized
2024-07-29 06:41:15,201 WARN  com.stackstate.api.ReceiverRoutes - 10.0.0.70 - POST http://suseus-trial.app.stackstate.io/stsAgent/logs/k8s?api_key=KCOU55s1bmMRbWVi45Z7kwd1f6LKWT (1223): 401 Unauthorized Authentication is possible but has failed or not yet been provided.```

---

**Vladimir Iliakov** (2024-07-29 08:43):
Probably because I did base64 encoding of password wrong, let me check

---

**David Noland** (2024-07-29 08:45):
Showing this on StackPacks page:

---

**Vladimir Iliakov** (2024-07-29 08:46):
It shows this key, because I reconfigured API/Receiver deployments with this value.

---

**Bram Schuur** (2024-07-29 09:07):
Just spitballing: like @Frank van Lankvelt mentioned, could it be this is one of our new fancy generated ingest api keys? Do we have expiry on those?

---

**Vladimir Iliakov** (2024-07-29 09:11):
I don't know. It looks like they have to be created via cli https://docs.stackstate.com/security/k8s-ingestion-api-keys, whereas @David Noland got it from the Stackpack page, right @David Noland?

---

**Frank van Lankvelt** (2024-07-29 09:12):
I think he's getting a well-deserved rest.

---

**Vladimir Iliakov** (2024-07-29 09:15):
Another observation`KCOU55s1bmMRbWVi45Z7kwd1f6LKWT` is 30 symbols long, but we generate 32-symbols API keys, so the key encoded in repo matches the pattern. But still not clear how it worked with the incorrect API key :man-shrugging:

---

**Alejandro Acevedo Osorio** (2024-07-29 09:17):
Mmmm I think this was not an ingestion apiKey as those get prefixed with `iapikeyok-` and then the random 32 char token

---

**Alejandro Acevedo Osorio** (2024-07-29 09:19):
@Bram Schuur those do have an optional expiry date

---

**Vladimir Iliakov** (2024-07-29 09:52):
Some summary:
• the Suseus trial stopped receiving data after 23rd of July when the tenant was upgrade (not clear if it was upgrade or restart that triggered that)
• Today David reported the data is missing and we found authentication errors in the receiver logs.
• The API key in the logs (the agents were deployed with), and in the K8s secret (Stackstate was provisioned with) differed in two first letters.
    ◦ David said that about 20 clusters were deployed with the same key from the very start and haven't been changed.
    ◦ The receiver API key used by Stackstate also hasn't been changed, I checked git history and a hashsum of the Secret in Aegir.
• Suseus trial had been receiving data before 23rd of July: I checked the metrics of the receiver in the Aegir instance, I also found some logs before 23rd of July that the "incorrect" key was used.
• After manual change of the secret the trial started receiving data.
What are we going to/can  do with that?
@Mark Bakker FYI

---

**Mark Bakker** (2024-07-29 09:55):
@Vladimir Iliakov really good queston. When did we do the upgrade of this tenant is it closely related in time to this issue?

---

**Vladimir Iliakov** (2024-07-29 09:58):
Yes it is, within the same hour.

---

**Lukasz Marchewka** (2024-07-29 09:59):
we have to increase `max-open-requests` for the receiver, I'm going to create MR just now

---

**Lukasz Marchewka** (2024-07-29 10:06):
@Vladimir Iliakov can you review: https://gitlab.com/stackvista/devops/saas-tenants/-/merge_requests/951/diffs

---

**Vladimir Iliakov** (2024-07-29 10:08):
This one https://gitlab.com/stackvista/devops/saas-tenants/-/merge_requests/950 has to be merged first

---

**Mark Bakker** (2024-07-29 10:27):
Can the upgrade somehow influenced this? It does sound weird, but this is really strange.

---

**Lukasz Marchewka** (2024-07-29 10:28):
@Vladimir Iliakov can I merge my MR ?

---

**Vladimir Iliakov** (2024-07-29 10:29):
@Lukasz Marchewka yes go ahead

---

**Lukasz Marchewka** (2024-07-29 10:40):
I'm going to sync argcd now, any objections @Vladimir Iliakov ?

---

**Vladimir Iliakov** (2024-07-29 10:45):
> Can the upgrade somehow influenced this? It does sound weird, but this is really strange.
@Mark Bakker
I have only stupid ideas ))), like Stackstate used only the last 30 symbols for this certain receiver API key and the upgrade fixed it.

---

**Vladimir Iliakov** (2024-07-29 10:45):
@Lukasz Marchewka after the sync please check receiver logs for authentication errors.

---

**Vladimir Iliakov** (2024-07-29 10:53):
@David Noland may I create a user in suseus-trial, I would like to check the hashsums of the agent secrets just to exclude that the agents were deployed with the "incorrect" key?

---

**Lukasz Marchewka** (2024-07-29 11:52):
@Mark Bakker @Vladimir Iliakov @David Noland updated, I don't see any errors in the receiver

---

**Lukasz Marchewka** (2024-07-29 11:53):
and it receives data

---

**David Noland** (2024-07-29 14:23):
Vladimir, yes fine to create a user

---

**David Noland** (2024-07-29 14:24):
And regarding question above, yes I did originally get api key from StackPack UI

---

**Vladimir Iliakov** (2024-07-29 14:55):
I checked the hash sums for a number of agent secrets for different clusters monitored by suseus-trial and can confirm that the "incorrect" key was there from the very beginning.

---

**Vladimir Iliakov** (2024-07-29 14:58):
Taking into account that the platform key also hasn't changed left me with the idea that Stackstate accepted the incorrect key, which I find really difficult to believe.

---

**David Noland** (2024-07-30 23:07):
Hi Guys - I'm back from PTO today. First, I wanted to thank everyone for jumping on this quickly and helping to resolve the immediate issue. I checked today and I am seeing metrics for all my active clusters.

Do we know if other customers were impacted by this issue? If I understand correctly, it was triggered by a software update (or a restarted when software was updated)?

Any action item on my side? Should I continue to use the original (incorrect) API key or switch to the new (correct) one?

---

**David Noland** (2024-07-30 23:10):
I checked the apiKey in the HelmChart YAMLs I used to deploy StackState and they all appear to be this API key. I'm 99.9% sure this is what was used since the agent was deployed.
```$ cat */stackstate-helm-chart.yaml| grep apiKey
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT
      apiKey: KCOU55s1bmMRbWVi45Z7kwd1f6LKWT```

---

**David Noland** (2024-08-03 01:54):
Hi StackState team (@Alejandro Acevedo Osorio @Bram Schuur @Frank van Lankvelt @Lukasz Marchewka @Vladimir Iliakov @Louis Parkin) - during Mark's time off, I'm monitoring the Zendesk support ticket queue. The following cases are waiting for a response. Could someone have a look?
• 1422 (https://stackstate.zendesk.com/agent/tickets/1422) - new case from Smartest Energy. Are they a paid customer?
• 1421 (https://stackstate.zendesk.com/agent/tickets/1421) - Mark had requested a customer call next week. Might be good for somone on <!subteam^S04SHQYRTD0> to shadow.
• 1420 (https://stackstate.zendesk.com/agent/tickets/1420) - Has a first response, but requires a follow up
• 1417 (https://stackstate.zendesk.com/agent/tickets/1417) - @Frank van Lankvelt Looks like they have some additional questions
• 1416 (https://stackstate.zendesk.com/agent/tickets/1416) - Opened over a week ago, but doesn't appear to have a response yet.
• 1414 (https://stackstate.zendesk.com/agent/tickets/1414) - @Louis Parkin Did you meet with the customer on this one? What is the current status?

---

**Frank van Lankvelt** (2024-08-03 11:34):
@David Noland maybe someone else can take over?  I'm on leave next week.  Was looking into it and I think they're right - there will be retries, and with each of them being successful there will be a lot of messages coming in.  There's a fix in the stackstate master branch.  Afaics the old method of creating a webhook should still work, so they can use that in the meantime.

---

**David Noland** (2024-08-03 21:03):
Hi Frank - have a good time-off. Any recommendations on who would be best to have a look? Or any volunteers from the StackState team? Or if we don't think it's urgent, maybe can wait until you return from leave.

---

**Bram Schuur** (2024-08-05 09:01):
I will go through these tickets, cc @Louis Lotter

---

**Bram Schuur** (2024-08-05 09:02):
(The ones that do not yet have someone assigned)

---

**Louis Parkin** (2024-08-05 09:14):
@David Noland
&gt; • 1414 (https://stackstate.zendesk.com/agent/tickets/1414) - @Louis Parkin Did you meet with the customer on this one? What is the current status?
Not yet, the meeting is scheduled for 13:00 UTC+2 today

---

**Louis Parkin** (2024-08-05 09:25):
@David Noland
&gt; • 1421 (https://stackstate.zendesk.com/agent/tickets/1421) - Mark had requested a customer call next week. Might be good for somone on <!subteam^S04SHQYRTD0> to shadow.
@Mark Bakker also asked me to have a look at this one.  Initially the idea was to run profiling scripts in the customer's environment to see where the agent gets stuck, but it appears from the customer's response on Friday that they are not experiencing this issue on a production environment, it is with a new installation.  I have requested the software versions for the deployment.

---

**Bram Schuur** (2024-08-05 09:39):
@Mohamed Elnemr @Marc Rua Herrera hey guys, can you anser/deal with this question? Maybe you have an answer for this already. If not, we'll come up with something together: https://stackstate.zendesk.com/agent/tickets/1422

---

**Mohamed Elnemr** (2024-08-05 10:42):
Yes, this looks like a consultancy request.

---

**David Noland** (2024-08-05 17:03):
Thanks everyone for the above responses. I believe the six tickets above are now up to date and no new tickets today.

---

**Vladimir Iliakov** (2024-08-08 12:45):
@Bram Schuur I have enabled mail notifications for the Planon as requested in https://stackstate.atlassian.net/browse/STAC-21550 and replied to the Zendesk ticket, https://stackstate.zendesk.com/agent/tickets/1416, so the customer can use it.
The Zendesk ticket mentions the invalid link to the docs, but there are no docs for SMTP notifications. What we are going to do with that?

---

**Bram Schuur** (2024-08-08 12:51):
I made a ticket for lupulus on that one.

---

**Bram Schuur** (2024-08-08 12:51):
Thanks a bunch!

---

**David Noland** (2024-08-09 17:54):
I see a support ticket for 9th Bit (https://www.9thbit.co.za/), but don't see them in the StackState customer list. Are they the same or related to Steadybit (https://steadybit.com/)?

---

**Frank van Lankvelt** (2024-08-09 22:38):
They're a partner, handling MTN Nigeria afaik

---

**David Noland** (2024-08-09 22:40):
Ah, okay. Thanks for the clarification.

---

**Bram Schuur** (2024-08-12 08:38):
I have lowered the severity of the message to info level

---

**David Noland** (2024-08-13 07:20):
We received a new ticket today from KvK - 1424 (http://support.stackstate.com/hc/requests/1424) - `Question about releases / release notes`
Would be great if someone can have a look and respond. TIA!

---

**Louis Parkin** (2024-08-13 08:48):
I’ll have a look.

---

**David Noland** (2024-08-13 17:07):
We received a new ticket today from Rabobank - 1425 (http://support.stackstate.com/hc/requests/1425) - `Remediation markdown handling of spaces in urn`
Can someone have a look?

---

**Louis Lotter** (2024-08-14 09:24):
Created a bug ticket thanks David.

---

**David Noland** (2024-08-14 16:17):
Great, thanks

---

**David Noland** (2024-08-14 17:08):
We received a new ticket today from MTN / 9thbit - 1426 (http://support.stackstate.com/hc/requests/1426) - `Service ClusterIP identified as External HTTP API`
Can someone have a look?

---

**Louis Lotter** (2024-08-14 17:11):
@Bram Schuur this looks like a minor issue but probably best you respond.

---

**Vladimir Iliakov** (2024-08-14 17:39):
Hi @David Noland, do you still use/need https://suseus-trial.app.stackstate.io/#/ ?

---

**David Noland** (2024-08-14 17:44):
Yes, definitely. We are now using it for our production Rancher Hosted Prime and have removed our previous observability infrastructure (Opni)

---

**David Noland** (2024-08-14 17:45):
We have about 20 clusters we are monitoring

---

**Vladimir Iliakov** (2024-08-14 17:45):
Ok, I see. :thumbs-up:

---

**Bram Schuur** (2024-08-14 21:18):
Will do, yeah, I asked Hannes to file a zendesk ticket to have a more complete description of the case

---

**David Noland** (2024-08-15 16:52):
Another new ticket from Rabobank today - 1427 (http://support.stackstate.com/hc/requests/1427) - `Component data in remediation guide v6`
Looks like an RFE, could StackState team have a look?

---

**Bram Schuur** (2024-08-19 09:06):
I responded but left it open for now, there is no big urgency there. Thanks for notifying @David Noland

---

**David Noland** (2024-08-19 16:02):
No problem

---

**David Noland** (2024-08-19 17:26):
StackState team - the following new ticket came in today from KvK - 1428 (https://stackstate.zendesk.com/agent/tickets/1428) - `ExternalMonitors on Monitors UI page`

---

**David Noland** (2024-08-20 19:45):
StackState team - the following new ticket came in today from Nationale Nederlanden - 1429 (https://stackstate.zendesk.com/agent/tickets/1429) - `Metric Stream Interface doesn't draw a singular datapoint`

---

**Bram Schuur** (2024-08-21 09:55):
I deferred this one until mark is back

---

**Bram Schuur** (2024-08-21 11:40):
I added this to marks list of todos

---

**David Noland** (2024-08-21 16:27):
Great, thanks

---

**David Noland** (2024-08-21 16:28):
sounds good

---

**David Noland** (2024-08-26 07:20):
Looks like we got our first StackState support case filed on SCC:
case 01550675 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000Gk45qIAB/view) - T-Systems - "Assistance to install Stackstate"
&gt; We are exploring functionality to install the StackState in our environment, Hence need your expert assistance on this. We can arrange meeting for this if required.
Stalin from Rancher support is taking the case and going to redirect them to the Getting Help section of https://docs.stackstate.com/get-started/k8s-suse-rancher-prime

---

**Louis Lotter** (2024-08-26 07:38):
Awesome thanks Noland. Let me know if he needs support from the team.

---

**David Noland** (2024-08-26 07:39):
I'll watch the case, but we're going to encourage them to email <mailto:rancherobservability@suse.com|rancherobservability@suse.com>

---

**David Noland** (2024-08-26 18:26):
Now that @Mark Bakker is back from vacation, I'll assume he will be monitoring Zendesk for new support tickets.

---

**Vladimir Iliakov** (2024-08-27 10:31):
@David Noland we are seeing the logs rejected in suseus-trial tenant. We can either increase the disk space required to store logs or reduce the retention time for which logs are stored, right now it is 7 days, so the question is do you need logs for 7 days or we can reduce it to lets say 3 days?

---

**David Noland** (2024-08-27 17:32):
We are currently shipping most of our important logs to AWS CloudWatch, so I think it will be okay to reduce the StackState log retention from 7 days down to 3 days if storage is a bit tight.

---

**Louis Lotter** (2024-09-18 10:55):
@David Noland I discussed the next steps with the support enablement with @Mark Bakker and @Jeroen van Erp this morning. Jeroen already has some training prepared that I think you have been exposed too. We think the enablement should start with that and then we go deeper technically with the engineers after that.

---

**Louis Lotter** (2024-09-18 10:56):
please set up a call with us when it suits you.

---

**Louis Lotter** (2024-09-18 10:57):
In the meantime @Mark Bakker Does it make sense to create a Jira ticket for @Remco Beckers and/or @Vladimir Iliakov to start working on preparing for this ?

---

**Jeroen van Erp** (2024-09-18 10:58):
Isn’t this also something we should add Ravan to? I think the DSA’s are the ones usually doing this also

---

**Mark Bakker** (2024-09-18 10:58):
The ticket is already there on the Moersleutel board quite on top of the todo

---

**Louis Lotter** (2024-09-18 10:59):
@Ravan Naidoo would could really help here as well yeah

---

**David Noland** (2024-09-19 02:03):
Thanks @Louis Lotter. @Jeroen van Erp not sure if you have seen it, but this is guide we have https://docs.google.com/document/d/1s6PZjkfSUSSYR5jU1ElHUomLRZtaYAdHKPKqxmualRE/edit#heading=h.ckn5iumpp5cq

I've sent out a calendar invite for next ~Thursday~ Friday. Let me know if that works for you and I'll add others to the invite.

---

**Jeroen van Erp** (2024-09-19 08:46):
@David Noland Friday’s that late I cannot make it due to my son’s fencing practice. Can you reschedule to a different time/date

---

**Jeroen van Erp** (2024-09-19 08:48):
Also, given the content you sent, you’re aiming for a different session than what I presented at CFL. If so, I’d need some time to prep that given my other workloads

---

**David Noland** (2024-09-19 17:53):
@Jeroen van Erp ok, that's fine. Rescheduled for Wednesday Oct 2nd. Will that give you enough time to prepare and does that time work for you? If not, let me know a few alternatives that might work for you.

---

**David Noland** (2024-09-24 05:28):
@Jeroen van Erp didn't see a confirmation from you on this. Is the date/time okay with you?

---

**David Noland** (2024-09-25 16:32):
What versions of Rancher Manager are required to use SUSE Observability? And would it be possible to add that information to https://docs.stackstate.com/get-started/k8s-suse-rancher-prime?

---

**Jeroen van Erp** (2024-09-25 16:34):
Discussed with Mark and AP this morning, if it’s just a re-run that you need from my side on the CFL track, I can do it the 2nd EOD my day

---

**David Noland** (2024-09-25 18:24):
Great, I'll add others to the invite. We'll do the "intro" to StackState first, and have follow ups with engineering to get more into technical details and troubleshooting.

---

**David Noland** (2024-09-25 22:05):
Alright, invite is out!

---

**Louis Lotter** (2024-09-26 13:03):
@Mark Bakker Does this question make sense to you ?

---

**Mark Bakker** (2024-09-26 13:18):
Hi David, I don't think there is any specific Rancher Manager version needed.
If we get to the app-based install then we need to specify this.

---

**David Noland** (2024-09-26 16:59):
Ok, so it will work with any version of Rancher (assuming it's not an EOL version)?

---

**David Noland** (2024-09-26 18:22):
Great, thanks for confirming.

---

**Jeroen van Erp** (2024-09-27 15:53):
Hi David, I just learned that we cannot at this moment (next week) use the handson content that we used in CFL. The tool is now undergoing scrutiny internally before procurement, and the vendor does not want us to use it for training/events until we pay (makes sense)

---

**David Noland** (2024-09-27 16:22):
Hi Jeroen - I don't understand. What tool and vendor are you referring to? I've already invited 100+ people. Do we need to postpone the session? Does this mean you are also not presenting the session at next month's CFL tech summit?

---

**Jeroen van Erp** (2024-09-27 16:53):
The Instruqt tool we did the hands-on with. I can run through my presentation next week no problem, and give a demo. I just can’t have people go through the learning track that we did on CFL

---

**David Noland** (2024-09-27 17:07):
Oh, got it, the hands on lab. I think the presentation, demo, followed by Q&amp;A should be perfectly fine for the 2-OCT session.

---

**Jeroen van Erp** (2024-09-27 17:08):
:thumbs-up: Just wanted to inform you to prevent surprises

---

**David Noland** (2024-09-27 17:17):
thanks for the heads up

---

**Jeroen van Erp** (2024-09-27 17:28):
The ui extension does not work with any rancher btw

---

**David Noland** (2024-09-27 18:06):
What versions does it work with? Would be good to have that in the docs. We did have a support case that a customer was having an issue with the UI extension showing up in Rancher 2.8.x. They upgraded to 2.9.2 and that fixed it.

---

**Jeroen van Erp** (2024-09-27 18:06):
I'm not sure, would need to figure that out next week

---

**David Noland** (2024-09-27 18:08):
ok, sounds good.

---

**Devendra Kulkarni** (2024-10-07 08:08):
Hello Team,
We have got a case from INFOSYS LTD (https://suse.lightning.force.com/lightning/r/Account/0011i00000SJ3siAAD/view) where they are having some queries on installation on air-gapped cluster.
They are following - https://docs.stackstate.com/get-started/k8s-suse-rancher-prime and observed that the scripts mentioned under https://docs.stackstate.com/get-started/k8s-suse-rancher-prime/k8s-suse-rancher-prime-air-gapped and those scripts are having `docker`  commands although Stackstae is not supported on RKE1 and with RKE2 we do not have docker support.
So can we modify those scripts to point to containerd/crictl commands?

---

**Jeroen van Erp** (2024-10-07 09:07):
Hi Devendra, the `docker` commands are for the command line docker tool to pull and push images. These are executed on a machine that has internet access to push the images to their airgapped registry. These are separate from the container runtime of the cluster, where `containerd` is fully supported.

---

**Devendra Kulkarni** (2024-10-07 20:35):
Hello Team,
Customer Udviklings- og Forenklingsstyrelsen (https://suse.lightning.force.com/lightning/r/Account/0011i00000wxydbAAA/view) opened a case and is reporting an issue with using ExternalSecrets with helm chart values.yaml. 
But they are unable to login to stackstate UI if they use externelsecrets... And if they dont use externalsecrets everything works as expected. 

Do we have a known issue with external secrets? Or should I reproduce it locally and report here again so that a Jira/bug can be created?

---

**Mark Bakker** (2024-10-08 09:04):
We don't have a known issue with external secrets

---

**Mark Bakker** (2024-10-08 09:04):
If you can try to reproduce this would be best indeed @Devendra Kulkarni

---

**Amol Kharche** (2024-10-08 12:06):
Hello Team,
Any issue with the helm command. We have received the 01555862  (https://suse.lightning.force.com/lightning/r/Case/500Tr00000JvtJNIAZ/view?uid=172838153343840143), I am able to reproduced issue locally. It didn't create `baseConfig_values.yaml` and `sizing_values.yaml` . however it creates *valuegenerator.yaml* file.

root@jumpsrv:~/terraform/suse-observability# export VALUES_DIR=.
root@jumpsrv:~/terraform/suse-observability# helm template --set license='' --set baseUrl='http://localhost:8080' --set sizing.profile='10-nonha' suse-observability-values  suse-observability/suse-observability-values --output-dir $VALUES_DIR
wrote ./suse-observability-values/templates/valuegenerator.yaml
wrote ./suse-observability-values/templates/valuegenerator.yaml

root@jumpsrv:~/terraform/suse-observability#

---

**Amol Kharche** (2024-10-08 12:10):
root@jumpsrv:~/terraform/suse-observability/suse-observability-values/templates# ls -ltr
total 4
-rw-r--r-- 1 root root 625 Oct 8 04:59 valuegenerator.yaml

Content of the valuegenerator.yaml file.

```root@jumpsrv:~/terraform/suse-observability/suse-observability-values/templates# cat valuegenerator.yaml
---
# Source: suse-observability-values/templates/valuegenerator.yaml
global:
  receiverApiKey: "d5F8CMRHeWdwXUfEUoPh7jCwnS"

stackstate:
  baseUrl: "http://localhost:8080"
  admin:
    authentication:
      password: "b/I13DVCTuWtUfJTK0Ad//9GbpE3nMigm5arK"
  authentication:
    adminPassword: "$2a$10$fw.IBHT1ssOVywE/cijuMNHP6kepW."
  license:
    key: "4VRD5-A"
---
# Source: suse-observability-values/templates/valuegenerator.yaml
# Your SUSE Observability admin password is: hWeiICEmLxE
# Your SUSE Observability admin API password is: p9eW6vxy69
root@jumpsrv:~/terraform/suse-observability/suse-observability-values/templates#```

---

**Remco Beckers** (2024-10-08 14:30):
Hi, there was indeed an issue with publishing the latest version of the `suse-observability-values` helm chart. We've published the new version (version 2.0.2) now but it will take a while (at most 24 hours) before it is available from the Helm repository (due to a cache expiration, we don't have permissions to do that yet)

---

**Amol Kharche** (2024-10-08 14:35):
Thanks but which would be the correct output yaml file? *`valuegenerator.yaml` OR* `baseConfig_values.yaml` and `sizing_values.yaml ?`

---

**Remco Beckers** (2024-10-08 14:36):
The `baseconfig_values.yaml` and the `sizing_values.yaml` are the correct output. The `valuegenerator.yaml` is the old output of a previous version

---

**Garrick Tam** (2024-10-08 22:15):
~Is this the version that should have the corrections?~
```helm list -n suse-observability
NAME              NAMESPACE          REVISION UPDATED                              STATUS  CHART                    APP VERSION
suse-observability suse-observability 1        2024-10-08 10:59:43.411164 -0700 PDT deployed suse-observability-2.0.2 7.0.0-snapshot.20241001154902-master-e89f93c```

---

**Garrick Tam** (2024-10-08 22:15):
Another customer is reporting the same error but they are trying with the :point_up: helm chart version.

---

**Garrick Tam** (2024-10-09 02:44):
I just re-read and see the reference is against suse-observability-values.  So should we expected chart version 2.0.2 for suse-observability/suse-observability-values?

---

**Amol Kharche** (2024-10-09 05:57):
Customer question:- "If I want to install the previous version of stackstate, where can I get the credentials to pull the image?"

---

**Garrick Tam** (2024-10-09 06:01):
the customer's request should be moot once the fix becomes available

---

**Devendra Kulkarni** (2024-10-09 13:25):
Hello @Mark Bakker
We tried to reproduce the issue in our lab today... thanks to @Amol Kharche for helping out in replicating the issue.

---

**Devendra Kulkarni** (2024-10-09 13:25):
If you or someone else wants to have a look at the cluster configuration, we can share screen and then if needed we can create a JIRA for the same.

---

**Remco Beckers** (2024-10-09 14:48):
The suse-observability-values charts should have version 1.0.2. I just checked and that version is now available (after running a `helm repo update`) on the rancher helm repository

---

**Remco Beckers** (2024-10-09 14:49):
I erroneously said it should be 2.0.2, but that's the main suse-observability helm chart

---

**Remco Beckers** (2024-10-09 14:50):
Note that the previous version also didn't require credentials to pull the images

---

**Mark Bakker** (2024-10-09 15:00):
Hi @Devendra Kulkarni one thing is not fully clear, you mean we indeed have an issue With this?
If so can you create a Jira ticket and share it?

---

**Devendra Kulkarni** (2024-10-09 15:01):
Yes we have an issue but not sure if its due to helm or how stackstate processes the secrets

---

**IHAC** (2024-10-10 02:58):
@Garrick Tam has a question.

:customer:  NowCom Corporation

:facts-2: *Problem (symptom):*  
Customer reports the license key from their account subscription for SUSE Rancher Prime - Observability Tech Preview is not working.  I confirmed they are using the key found under their account subscriptions.  Below is what customer reports.  Any reason this is happening and what can be done to fix it?
```Please help in checking our SUSE Rancher Prime - Observability Tech Preview license key. When I try to use it, Im having "Your license key has expired!" error.```

---

**David Noland** (2024-10-10 07:53):
in case it's needed, this is the license key they are trying to use - `0AK3L-N4RLL-223FA`

---

**Jeroen van Erp** (2024-10-10 08:51):
@Mark Bakker see above!

---

**Mark Bakker** (2024-10-10 09:29):
@Frank van Lankvelt can you test this license code?

---

**Frank van Lankvelt** (2024-10-10 10:18):
the expiration date was the first of october (01-10-2024)

---

**David Noland** (2024-10-10 10:31):
SCC says 31-OCT

---

**David Noland** (2024-10-10 10:31):
Is it just this key, or everyone's keys expired on 1-OCT?

---

**Devendra Kulkarni** (2024-10-10 11:16):
@Mark Bakker Do you have a minute to have a look at the cluster?

---

**Devendra Kulkarni** (2024-10-10 11:17):
If you confirm the issue then I can create a JIRA

---

**Mark Bakker** (2024-10-10 11:32):
@Frank van Lankvelt can we have a chat about this?

---

**Mark Bakker** (2024-10-10 11:49):
Sorry I don't have time today. And only from next thursday I will have time, please proceed with a ticket.

---

**Devendra Kulkarni** (2024-10-10 11:49):
Can you just tell us which is the secret that stores admin password?

---

**Mark Bakker** (2024-10-10 12:00):
Can you ask this question in the <#C079ANFDS2C|> channel?

---

**Mark Bakker** (2024-10-10 12:00):
I don't know, there someone should know.

---

**Devendra Kulkarni** (2024-10-10 12:14):
https://stackstate.atlassian.net/browse/STSDEMO-17

---

**Garrick Tam** (2024-10-10 17:48):
Any update on this?

---

**Mark Bakker** (2024-10-10 17:52):
Yes tomorrow a new license will be available. If you look in <#C079ANFDS2C|> you see also a message from me and also a license key which can be user right away

---

**Garrick Tam** (2024-10-10 17:54):
Sorry, I haven't caught up to all the channels.  Thx.

---

**Devendra Kulkarni** (2024-10-11 08:41):
Hello Team,
Can someone please refer to this slack thread?
https://suse.slack.com/archives/C079ANFDS2C/p1728623241068829

---

**Devendra Kulkarni** (2024-10-11 08:41):
I will be adding further details here

---

**Devendra Kulkarni** (2024-10-11 11:26):
Attaching all pod logs...

---

**Devendra Kulkarni** (2024-10-11 11:29):
Can someone please help me debug this issue?

---

**Devendra Kulkarni** (2024-10-11 13:30):
@Alejandro Acevedo Osorio ^^

---

**Devendra Kulkarni** (2024-10-11 13:30):
Here are all the pod logs ^

---

**Alejandro Acevedo Osorio** (2024-10-11 13:40):
Well the `hbase-stackgraph` pod looks just fine. I guess we need to describe the tephra pod to see if it's failing the probes.

---

**Devendra Kulkarni** (2024-10-11 13:41):
Yes I checked during the remote call... The probes were failing

---

**Devendra Kulkarni** (2024-10-11 13:42):
What info do you need from the cluster? I can ask customer and get it for you

---

**Alejandro Acevedo Osorio** (2024-10-11 13:46):
We could try giving to `tephra` a little more CPU ... Currently for the trial we just request (and that's more than enough for what it uses)
```│     Limits:                                                                                                                                                                                                                              │       cpu:                100m                                                                                                                                                                                                           │       ephemeral-storage:  1Gi                                                                                                                                                                                                            
│       memory:             512Mi                                                                                                                                                                                                         
│     Requests:                                                                                                                                                                                                                            
│       cpu:                50m ```
If it's getting severely throttled then it might not even go through the init sequence. We could just raise the requests to `100m` or even give it `250m` so it goes through the initialization.
Other idea would be to relax the probes to give it more time to get up

---

**Devendra Kulkarni** (2024-10-11 13:50):
Ok will try that and get back here with the feedback

---

**Devendra Kulkarni** (2024-10-18 13:44):
Hello Team,
Europol (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMVL4AAO/view) has opened a case and asked us several questions on SUSE Observability:
```1. How mature is this product?
2. Where can I find an updated architectural diagram for SUSE observability in an self-hosted setup? I want to see details about the systems, data flows, what applications are used at each step, etc.
3. For SUSE observability in a self-hosted setup, what solution does SUSE provides for long term log storage?```

---

**Devendra Kulkarni** (2024-10-18 13:48):
Can I share them the architectural diagram that was shared in the support enablement session slide deck yesterday?

---

**Devendra Kulkarni** (2024-10-18 13:52):
@Lukasz Marchewka @Alejandro Acevedo Osorio ^

---

**Alejandro Acevedo Osorio** (2024-10-18 14:48):
I think this question is more for @Louis Lotter

---

**Remco Beckers** (2024-10-21 08:48):
That sounds indeed as the most likely cause. I would also make sure that they they configured the OpenTelemetry ingress: https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-fo[…]e-observability-helm-chart (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-for-open-telemetry-traces-via-the-suse-observability-helm-chart).

Without that still no data will be accepted.

---

**Surya Boorlu** (2024-10-21 08:50):
@Remco Beckers Got it. I will ask the customer to configure Ingress for OpenTelemetry. Thank you

---

**Surya Boorlu** (2024-10-21 08:52):
Customer says: I tried with this (&lt;otlp-stackstate-endpoint&gt;:443 ). Currently our LB is not supporting gRPC protocol, so I have switched to http, as per documentation.


https://docs.stackstate.com/open-telemetry/troubleshooting#some-proxies-and-firewalls-dont-work-well-with-grpc

---

**Remco Beckers** (2024-10-21 09:01):
Aha ok. That makes sense

---

**Remco Beckers** (2024-10-21 09:02):
Looking at our docs I think we don't document how to configure the ingress properly for that situation

---

**Surya Boorlu** (2024-10-21 09:03):
Customer is asking to  confirm, to which service open telemetry collector should send the traces to.

NAME                          TYPE    CLUSTER-IP   EXTERNAL-IP PORT(S)                                                                                                                                                                                            AGE
suse-observability-agent-cluster-agent         ClusterIP 10.43.56.92   &lt;none&gt;    5005/TCP                                                                                                                                                                                            3d19h
suse-observability-agent-node-agent          ClusterIP 10.43.157.44  &lt;none&gt;    8126/TCP                                                                                                                                                                                                                                                               3d19h
suse-observability-correlate              ClusterIP None      &lt;none&gt;    9404/TCP                                                                                                                                                                                           6d
suse-observability-e2es                ClusterIP None      &lt;none&gt;    9404/TCP                                                                                                                                                                                           6d
suse-observability-elasticsearch-master        ClusterIP 10.43.26.149  &lt;none&gt;    9200/TCP,9300/TCP                                                                                                                                                                                       6d
suse-observability-elasticsearch-master-headless    ClusterIP None      &lt;none&gt;    9200/TCP,9300/TCP                                                                                                                                                                                       6d
suse-observability-hbase-stackgraph          ClusterIP None      &lt;none&gt;    10125/TCP,10126/TCP,10127/TCP,10128/TCP,10129/TCP,10130/TCP,10131/TCP,10132/TCP,10133/TCP,10134/TCP,10135/TCP,10136/TCP,10137/TCP,10138/TCP,10139/TCP,10140/TCP,10141/TCP,10142/TCP,10143/TCP,10144/TCP,10145/TCP,10146/TCP,10147/TCP,10148/TCP,10149/TCP,10150/TCP,10151/TCP,10152/TCP,10153/TCP,10154/TCP,10155/TCP,10156/TCP,10157/TCP,10158/TCP,10159/TCP,10160/TCP,10161/TCP,10162/TCP,10163/TCP,10164/TCP,10165/TCP,10166/TCP,10167/TCP,10168/TCP,10169/TCP,10170/TCP,10171/TCP,10172/TCP,10173/TCP,10174/TCP,10175/TCP,10176/TCP,10177/TCP,10178/TCP,10179/TCP,10180/TCP,10181/TCP,10182/TCP,10183/TCP,10184/TCP,10185/TCP,10186/TCP,10187/TCP,10188/TCP,10189/TCP,10190/TCP,10191/TCP,10192/TCP,10193/TCP,10194/TCP,10195/TCP,10196/TCP,10197/TCP,10198/TCP,10199/TCP,10200/TCP,10201/TCP,10202/TCP,10203/TCP,10204/TCP,10205/TCP,10206/TCP,10207/TCP,10208/TCP,10209/TCP,10210/TCP,10211/TCP,10212/TCP,10213/TCP,10214/TCP,10215/TCP,10216/TCP,10217/TCP,10218/TCP,10219/TCP,10220/TCP,10221/TCP,10222/TCP,10223/TCP,10224/TCP,10021/TCP,2182/TCP,16021/TCP,16001/TCP,16010/TCP,9404/TCP 6d
suse-observability-hbase-tephra            ClusterIP None      &lt;none&gt;    15165/TCP,9404/TCP                                                                                                                                                                                                                                                         6d
suse-observability-kafka                ClusterIP 10.43.112.12  &lt;none&gt;    9092/TCP                                                                                                                                                                                           6d
suse-observability-kafka-headless           ClusterIP None      &lt;none&gt;    9092/TCP,9093/TCP                                                                                                                                                                                       6d
suse-observability-kafka-jmx-metrics          ClusterIP 10.43.63.112  &lt;none&gt;    5556/TCP                                                                                                                                                                                           6d
suse-observability-prometheus-elasticsearch-exporter ClusterIP 10.43.212.240 &lt;none&gt;    9108/TCP                                                                                                                                                                                                                                                               6d
suse-observability-receiver              ClusterIP 10.43.34.205  &lt;none&gt;    7077/TCP,9404/TCP                                                                                                                                                                                       6d
suse-observability-router               NodePort  10.43.163.205 &lt;none&gt;    8080:30180/TCP,8001:30181/TCP                                                                                                                                                                                  6d
suse-observability-server-headless           ClusterIP None      &lt;none&gt;    7070/TCP,7071/TCP,9404/TCP                                                                                                                                                                                  6d
suse-observability-ui                 ClusterIP 10.43.162.84  &lt;none&gt;    8080/TCP,9113/TCP

---

**Surya Boorlu** (2024-10-21 09:03):
Sorry for the format of the data.

---

**Devendra Kulkarni** (2024-10-21 09:04):
@Louis Lotter Can you please let me know if we can share above image with customer?

---

**Remco Beckers** (2024-10-21 09:04):
It needs to go to the `suse-observability-otel-collector` service. But that looks like it is also not installed (it doesn't get installed by default)

---

**Remco Beckers** (2024-10-21 09:06):
I also don't see in our docs how to enable that.

---

**Remco Beckers** (2024-10-21 09:07):
@Mark Bakker How should users know how to enable Open Telemetry support? Can we enable it by default maybe?

---

**Remco Beckers** (2024-10-21 09:13):
It looks like in the latest version it will indeed be enabled by default, I'm still checking if that has been released already or not yet

---

**Remco Beckers** (2024-10-21 09:18):
It's not yet released :disappointed:

---

**Surya Boorlu** (2024-10-21 09:18):
Oh okay. So, what would be the best solution now?

---

**Remco Beckers** (2024-10-21 09:20):
We can tell them which values they need to add to enable it themselves, and how to configure the ingress properly (the one in the documentation only supports GRPC, for HTTP a slightly different setup is needed)

---

**Remco Beckers** (2024-10-21 09:24):
Ok. It is pretty simple actually. To enable opentelemetry support they need to install/update SUSE Obsevability with these 2 extra values: `opentelemetry.enabled: true` and `clickhouse.enabled: true` .

Then to allow for HTTP insteadof GRPC traffic they can modify the ingress from the docs I linked earlier to remove the GRPC hint (`nginx.ingress.kubernetes.io/backend-protocol (http://nginx.ingress.kubernetes.io/backend-protocol): GRPC` ) and route traffic to port `4318` instead of `4317` of the otel-collector service. So the ingress sectionin the values yaml would look like this  (a copy from the docs with the changes I just mentioned):
```opentelemetry-collector:
  ingress:
    enabled: true
    annotations:
      nginx.ingress.kubernetes.io/proxy-body-size (http://nginx.ingress.kubernetes.io/proxy-body-size): "50m"
    hosts:
      - host: otlp-stackstate.MY_DOMAIN
        paths:
          - path: /
            pathType: Prefix
            port: 4318
    tls:
      - hosts:
          - otlp-stackstate.MY_DOMAIN
        secretName: otlp-tls-secret```

---

**Remco Beckers** (2024-10-21 09:25):
The configuration for otel collectors in the cluster needs to be like this then:
```    otlp-http/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: otlp-stackstate.MY_DOMAIN:443```

---

**Remco Beckers** (2024-10-21 09:27):
The only change being that `otlp-http` is used instead of `otlp` , the port change has been handled in the ingress

---

**Surya Boorlu** (2024-10-21 10:10):
Got it. I will update the customer and get back here.

---

**Louis Lotter** (2024-10-21 12:01):
@Devendra Kulkarni feel free to share but note this is a very high level diagram

---

**Louis Lotter** (2024-10-21 12:02):
for them to really understand this may require some extra effort

---

**Devendra Kulkarni** (2024-10-22 09:49):
Hi Team,
Infosys is unable to deploy the SUSE Observability agent in their air-gapped setup and is failing with the below error:

---

**Devendra Kulkarni** (2024-10-22 09:50):
Can someone help on what needs to be checked? Is it the stackstate URL the culprit here?

---

**Vladimir Iliakov** (2024-10-22 09:53):
`helm upgrade/install` might fail with the timeout error if the deployed resources aren't in "ready/healthy" state.

---

**Vladimir Iliakov** (2024-10-22 09:53):
So the list of the pods/pvc-s might give some clue about what has happened...

---

**Devendra Kulkarni** (2024-10-22 11:51):
the culprit was `all.image.registry` , as it was pulling image from a different repository and customer pushed images into a different repository...
After configuring the registry and repo name correctly, the command succeeded and all pods were up and running.

---

**Devendra Kulkarni** (2024-10-23 07:18):
Follow up question from the customer:
```for logs, will we be able to store logs for long term in Elasticsearch? Do you use the opensource or the licensed version?```

---

**Louis Lotter** (2024-10-23 09:04):
@Mark Bakker @Andreas Prins this question keeps coming up. Maybe our position on this should be reconsidered ?

---

**Mark Bakker** (2024-10-23 09:24):
Hi @Devendra Kulkarni we are not able store logs long term no'r do we plan to at the moment.

In the near future we most likely abandon the use of Elasticsearch for Logs and Events, with the move to different storage for those we will reconsider longer term storage. The question I have back to this customer is what is there exact use-case and how long do they want to store the logs? We do use the open-source version.

---

**Mark Bakker** (2024-10-23 09:27):
@Devendra Kulkarni the product is mature, but there are limitations. As described on the docs.
The main limitation ATM is scale where we currently support up to 500 standard nodes (16GB/4 cores) per installation. Which soon will become 2.500 standard nodes under observation. And will increase further in the near future.

---

**David Noland** (2024-10-23 18:25):
<!subteam^S04SHQYRTD0> First, I wanted to thank @Louis Lotter @Remco Beckers @Alejandro Acevedo Osorio @Lukasz Marchewka and @Vladimir Iliakov from the StackState engineering team for the preparation and delivery of our first support enablement session on 17-October. We are planning to have our second session sometime in November. To help prepare, please provide feedback and asks in the thread. Thanks!

---

**David Noland** (2024-10-23 18:25):
Feedback from @Garrick Tam :
&gt; _definitely another session that focuses more in depth on common issues and what if scenarios_
&gt; _like what happens when both master and standby both go down at the same time_
&gt; _will it recover on its own and how lone approximately or does it need manual intervention_
&gt; _also, tying the blocks from the diagrams to actual k8s objects_

---

**Amol Kharche** (2024-10-24 12:57):
Hi Team,
Question from customer.
In sender what we need to specify ?
In the server host we can specify the smtp hostname. In sender what must be given? Pls let me know.
         CONFIG_FORCE_stackstate_email_sender: "<mailto:stackstate@example.com|stackstate@example.com>"
         CONFIG_FORCE_stackstate_email_server_host: "&lt;smtp.example.com (http://smtp.example.com)&gt;"

---

**Vladimir Iliakov** (2024-10-24 13:02):
email_sender is used in the email headers MAIL FROM/REPLY TO.
So the email address of the smtp username, `CONFIG_FORCE_stackstate_email_server_username` , can be used.
Or something like no-reply@&lt;your-domain&gt;, but it implies that smtp server allows the smtp user to use this email address.

---

**Vladimir Iliakov** (2024-10-24 13:03):
For example, for Suse Cloud Observability we use `<mailto:no-reply@suse.com|no-reply@suse.com>`, but we configured our smtp to allow that.

---

**Vladimir Iliakov** (2024-10-24 13:06):
To make it short: tell the customer to use any of email addresses assigned to the smtp user, the one they configure `CONFIG_FORCE_stackstate_email_server_username` with.

---

**Amol Kharche** (2024-10-24 13:30):
So my customer name is Infosys , so values should be like below right?
`CONFIG_FORCE_stackstate_email_sender: "<mailto:Suse-Observability@infosys.com|Suse-Observability@infosys.com>"`
`CONFIG_FORCE_stackstate_email_server_username="Suse Observability"`

---

**Amol Kharche** (2024-10-24 13:31):
Is there any specific configuration require that smtp server allows the smtp user to use this email address ?

---

**Vladimir Iliakov** (2024-10-24 13:34):
`CONFIG_FORCE_stackstate_email_server_username` and `CONFIG_FORCE_stackstate_email_server_password` must be valid mail (SMTP) credentials. The customer can request it from their OPS team who manages the customer email's system.

---

**Vladimir Iliakov** (2024-10-24 13:37):
`CONFIG_FORCE_stackstate_email_server_username="Suse Observability"` I doubt this is valid username. Usually it is in form of email address, like &lt;account&gt;@&lt;domain&gt; or just &lt;account&gt;. Basically, they are the same parameters as to configure a mail client.

---

**Amol Kharche** (2024-10-24 13:48):
Thank you so much, I will inform to customer and let you know.

---

**Amol Kharche** (2024-10-24 14:49):
Hi Team,
Customer Dienst ICT Uitvoering (https://suse.lightning.force.com/lightning/r/Account/0011i00000wkkUAAAY/view) has done monthly patching of the OS (with cordoning and draining per node)  and after that observability cluster is unstable.
The router pod is still working, but they getting a "Something went wrong" message.
Do we have any logs collector script which can only get the observability logs.
They have uploaded rancher logs.

---

**Amol Kharche** (2024-10-24 15:37):
Do we need to allocate more CPU to suse-observability-server pod here?

---

**Louis Lotter** (2024-10-24 17:04):
@Alejandro Acevedo Osorio @Lukasz Marchewka can one of you guys help out here ?

---

**Amol Kharche** (2024-10-24 17:13):
Customer removed the non working configuration and reinstalled everything.
The new environment is working fine now.

---

**Louis Lotter** (2024-10-24 17:16):
Ok thanks Amol

---

**Alejandro Acevedo Osorio** (2024-10-24 17:49):
Sorry for the late reaction. I was about to ask the logs of that server pod. But good to hear that the environment is up and running. Thanks Amol

---

**Amol Kharche** (2024-10-29 10:59):
Hi Team,
Do we have any logs and config collection script for troubleshooting purpose?

---

**Remco Beckers** (2024-10-29 11:02):
No, not yet. But we have a ticket high on the backlog to create it since we get a lot of question about it

---

**Amol Kharche** (2024-10-29 11:09):
Thanks for update. Any deadline we set from now like a week or 2 week ?

---

**Remco Beckers** (2024-10-29 11:09):
I don't know. @Mark Bakker?

---

**Bruno Bernardi** (2024-10-29 18:15):
Hi Team,

We received a case from customer Corning Inc (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTYfAAN/view), reporting that Stackstate is not starting correctly after the installation. The customer is using the Small Profile Setup (https://docs.stackstate.com/6.0/self-hosted-setup/install-stackstate/kubernetes_openshift/small_profile_setup) [3 nodes: 8 VCPUs, 16 GB, 230 GB].

I saw in the support bundle that the pods *suse-observability-hbase-tephra-0* and *suse-observability-server-dd47d89b9-jbqmr* are in CrashLoopBackOff/Unhealthy and with the following error in the Kubernetes events:
```Liveness probe failed: Get "http://10.42.0.32:1618/liveness": dial tcp 10.42.0.32:1618: connect: connection refused ```
I can see in the Java process that port 1618 is being used as the receiver observability API:
```opt/java/openjdk/bin/java -XX:MaxDirectMemorySize=257m -Xmx477m -Xms477m -XX:+ExitOnOutOfMemoryError -server -DconsoleLogging=true -Dconfig.override_with_env_vars=true -Dstackstate.receiver.observabilityApi.metricsPort=9404 -Dstackstate.receiver.observabilityApi.healthPort=1618```
I collected the Support Bundle of the 3 nodes that compose the cluster, the pod logs, and the implementation YAMLs from the customer. In the logs, some Java dumps indicate that the environment is facing some timeouts in the probes or would need more memory resources for the JVMs. However, I'd like your help in understanding the relationship between these failing components/pods and Java in StackState.


Can you please take a look?

Thanks in advance!

---

**Alejandro Acevedo Osorio** (2024-10-29 19:12):
I think tephra is running into this issue https://suse.slack.com/archives/C079ANFDS2C/p1728913905534809 (https://suse.slack.com/archives/C079ANFDS2C/p1728913905534809)

---

**Alejandro Acevedo Osorio** (2024-10-29 19:13):
Tomorrow a new version 2.1.0 will be released which contains a fix for this issue

---

**Bruno Bernardi** (2024-10-29 19:23):
Thanks @Alejandro Acevedo Osorio. I'll let the customer know about that.

---

**Mark Bakker** (2024-10-30 07:40):
@Amol Kharche this depends a little bit, but the story is top of backlog for next Sprint so I do expect in a few weeks indeed.

---

**Bruno Bernardi** (2024-10-30 16:09):
Hi @Alejandro Acevedo Osorio,

While the customer is waiting to upgrade his environment, he would like to validate a sizing question to prevent possible issues in the future and take this opportunity to get the machines sized properly.

The customer cluster has 3 nodes, with 8 VCPUs, 16 GB, and 230 GB. He is using the 10 non-HA setups mentioned in this (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#requirements) documentation. In my understanding, the StackState cluster should have the sum of available resources on all schedulable nodes to work as expected.

So, I understand that the sum of the requirements that the customer has allocated to the StackState cluster is sufficient for this type of implementation, and the VMs are sized properly (3 VMs, totaling 48 GB &amp; 24 VCPUs).

 Thanks!

---

**Alejandro Acevedo Osorio** (2024-10-30 16:17):
Hi @Bruno Bernardi,
So for my understanding `(3 VMs, totaling 48 GB & 24 VCPUs)` are the resources available to install StackState using the `10 non-HA` profile?

---

**Alejandro Acevedo Osorio** (2024-10-30 16:23):
If the answer is yes then I can confirm that those resources are enough for such a profile. Where we would be a little on the low side is the disk space. For the `10 non-HA` profile we suggest `280GB`  for the default `30 day` retention of the data. But of course the disk usage will depend on the workloads that you are observing and whether or not you are using some of the features.

---

**Bruno Bernardi** (2024-10-30 16:32):
Thanks for the quick reply, Alejandro.

Looking at the Support Bundles and the YAMLs files that the customer sent, this is a new cluster with only Rancher, Longhorn, and StackState installed. So, I believe that a large part of the VMs' resources will be allocated to Stackstate, but I'll highlight this with the customer. I'll also emphasize the disk and data retention point you mentioned.

---

**Bruno Bernardi** (2024-10-31 16:43):
Hi, @Alejandro Acevedo Osorio, sorry to bother you again about this case.

The customer has updated to version 2.10 and the previous issue has been resolved. However, he sent an additional detail that we believe is implicating 2 certificate-related issues in his environment.

In their environment, all traffic to the Kubernetes clusters (including the Rancher Manager, the Suse Observability, and the downstream RKE2 clusters such as SCKEQA) must terminate at the HAProxy reverse proxy load balancers. They use the Load Balancers for TLS termination, and the clusters have responded to this very nicely until now.

About the current issues:

1. The observability agent installed on the SCKEQA cannot pass data to the URL for the Observability deployment. I suspect it needs a secret with the signing cert in it. Throws exactly the error message: `x509: certificate signed by unknown authority`. (I wonder if we can disable the `--set-string 'global.skipSslValidation'=true` option in the helm chart values.)
2. The Rancher UI Extension for Observability fails to connect with the Observability URL, complaining simply that it cannot connect. (I suspect there will need to be a similar secret created in the Rancher Manager cluster)
When feasible for you, can you please take a look? I've searched and haven't found any documentation on this and would appreciate it if you could send some guidance.

Thanks!

---

**Bruno Bernardi** (2024-10-31 19:18):
I found this documentation that may help the customer -&gt; https://docs.stackstate.com/agent/k8s-network-configuration-saas/k8s-network-configuration-proxy

---

**Alejandro Acevedo Osorio** (2024-10-31 19:25):
Indeed I think that will fix the issue for the agent. But I’m not sure about the ui extension.

---

**Alejandro Acevedo Osorio** (2024-10-31 19:33):
For the ui extension you for sure will need a certificate (not a self signed one) see https://suse.slack.com/archives/C079ANFDS2C/p1724447098877199?thread_ts=1724161914.763179&amp;cid=C079ANFDS2C

---

**Bruno Bernardi** (2024-10-31 19:39):
Appreciate your answer, Alejandro. We'll check that.

---

**Garrick Tam** (2024-10-31 23:12):
Here are the logs.

---

**Jeroen van Erp** (2024-11-01 09:10):
@Mark Bakker :point_up:

---

**Mark Bakker** (2024-11-01 09:34):
@Alejandro Acevedo Osorio or @Remco Beckers can one of you have a look?

---

**Alejandro Acevedo Osorio** (2024-11-01 09:47):
@Garrick Tam From the logs it seems that the stackgraph pod had some issues on the last startup where some of the database regions are not accessible  (Region not open in Hbase terms)
I'd try:
• Restart the `hbase-stackgraph` pod
• If that does not help with the exceptions (and on the understanding that is a new/clean installation) I'd downscale `hbase-stackgraph`  ... delete the associated pvc  `data-suse-observability-hbase-stackgraph-0` and scale it up again.

---

**Garrick Tam** (2024-11-01 21:06):
Customer have tried restarting the hbase-stackgraph pod before and it didn't help.

---

**Garrick Tam** (2024-11-01 21:11):
When customer scaled down stackgraph and removing the PVC: The server pod goes into a crash loop. I have attached the logs for the server pod.

Any insights on why this is happening?

---

**Alejandro Acevedo Osorio** (2024-11-02 09:31):
Probable tephra needs a restart

---

**Garrick Tam** (2024-11-02 16:54):
any particular reasoning behind the suggestion and what's the lists of healthy services/pods for the server pod to startup and stay running?

---

**Garrick Tam** (2024-11-02 16:55):
I can assume the answer to the second part of all other services/pods but just wanted your confirmation.

---

**Garrick Tam** (2024-11-03 01:41):
Also, any ideas why these issues are happening?  The nodes does not appear burdened.

---

**Alejandro Acevedo Osorio** (2024-11-03 19:43):
The reasoning is that after wiping the stack graph pvc tephra will benefit from a clean start given that on that pvc there was some zookeeper state that plays a part. The list is:
• stack graph 
• tephra
• Elasticsearch
• Victoria metrics
• Clickhouse
Usually the server pod logs show with which one is having an issue just like the very first logs you attached.

---

**Garrick Tam** (2024-11-03 20:07):
Besides the hbase-stackgraph, which other service/pod would benefit from deleting the persistent storage when that service/pod is unhealthy and needs a restart (perform during initial deployment only to not cause data loss).

---

**Alejandro Acevedo Osorio** (2024-11-04 09:18):
In the nonHa setup it's only the stackgraph one.

---

**Bruno Bernardi** (2024-11-04 18:22):
Hi @Alejandro Acevedo Osorio,

Feedback regarding this issue. The customer is still having problems with the UI integration. He said he rebuilt his Rancher using the following parameters:

```1. Rebuilt the Rancher release using the following values
privateCA: true  # This has been in place for quite some time
tls: external         # Also in place for quite some time
additionalTrustedCAs: true # Added for this testing

2. The two secrets were recreated/created as follows
kc -n cattle-system create secret generic tls-ca  --from-file=cacerts.pem=./cacerts.pem
kc -n cattle-system create secret generic tls-ca-additional --from-file=cacerts.pem=./cacerts.pem

3. The Rancher Deployment was issued a rollout restart

4. In a debug container on the Rancher Manager cluster in the Cattle-System namespace. A dig on the name "observability.apps.scke.corning.com (http://observability.apps.scke.corning.com)" resolves to the load balancer from within the container as it should. Indicating that the CA Certificate placed in both secrets above applies to all of the certificates served by the load balancer.```
After that, he still saw `bad handshake` and `certificate signed by unknown authority` errors in the rancher pods. I asked him again to validate that all the certificates in the chain are correct, but he said they are. I also asked for a new support bundle and complete logs of the Rancher pods.

Do you have any recommendations or ideas about this? It's currently the latest issue affecting the customer, the others have been resolved.

Thanks!

---

**Alejandro Acevedo Osorio** (2024-11-04 18:50):
I think the best would be to post the question on the <#C079ANFDS2C|> channel. I have seen some similar issues with the UI Extension.

---

**Bruno Bernardi** (2024-11-04 19:32):
Thanks @Alejandro Acevedo Osorio. We managed to resolve the issue. The problem was with the certificate. We created the certificate chain correctly (with CA, intermediate, and URL), and the issue was resolved.

We used the command `openssl s_client -showcerts -connect <observability.url>:443` to debug and identify what was incorrect and create a new secret. Everything is fine now, and the customer is using StackState safely.

---

**Bruno Bernardi** (2024-11-04 19:35):
If you think it would be interesting to share or document in detail the steps we took to solve this, just let me know.

---

**Alejandro Acevedo Osorio** (2024-11-05 07:56):
Great to here that you resolved it. I think it would be interesting, if you browse/search for a bit in that <#C079ANFDS2C|> channel this seems to be a fairly common issue while so probably we would benefit from having the clear steps to troubleshoot it. And I’m not sure what are the mechanisms in place but sharing it with other support engineers would be great.

---

**Bruno Bernardi** (2024-11-06 20:34):
Hi Team,

The customer Corning Inc (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTYfAAN/view) is facing an issue when adding a downstream cluster into Suse-Observability. He is using Rancher Manager 2.9.3, and the Kubernetes version of the downstream cluster is 1.25.16+rke2r1. The Observability cluster is using Kubernetes version 1.28.14+rke2r1.

Rancher UI Extensions into Suse-Observability have been configured, and one downstream cluster has been added to Suse-Observability using the name of the cluster as shown in the Rancher UI. Rancher UI for the cluster (SCKEQA) shows the error *"Cluster is not observed by Rancher Prime Observability. Please install the agent."*

I've been trying to simulate the issue in my lab, but at the moment, I haven't succeeded. I would like to ask for additional help from Engineering on this or if we have any active issue/bug that could justify this behavior in the versions mentioned above. I'll post the details of the troubleshooting already done in the comments of this thread.

Thanks!

---

**Bruno Bernardi** (2024-11-06 20:41):
Please see the support bundle and agent logs below:

---

**David Noland** (2024-11-07 03:18):
For one of our Rancher Hosted customers (Southeastern Grocers), we're doing a root cause analysis of an outage and trying to get more metrics from StackState. When trying to load the page - https://suseus-trial.app.stackstate.io/#/components/urn:cluster:%2Fkubernetes:segrocers-retail?timeRange=1727870400130 we just get a spinner and then an error about the page being unresponsive. Could someone help us out?

---

**David Noland** (2024-11-07 03:23):
Sorry, the URL got chopped, its https://suseus-trial.app.stackstate.io/#/components/urn:cluster:%2Fkubernetes:segrocers-retail?timeRange=1727870400130_1727881200791 The page does load now, but when I click on the pods link to try to get pod metrics, I get this

---

**Ankush Mistry** (2024-11-07 07:58):
Hello Team, we have a customer who is trying to install observability v2.1.0 on their cluster, but unfortunately, the following pods are not coming up (server, correlate, e2es). We have gathered logs from the customer and attaching them here. Could you please help with this?

---

**David Noland** (2024-11-07 08:12):
Are these logs? It appears to just be output from `kubectl describe pod` and `kubectl get events`. I'm guessing engineering team is going to need output from `kubectl logs`. Who is the customer?

---

**David Noland** (2024-11-07 08:14):
Ultimately, was able to get pod metrics directly from the metrics explorer using this (https://suseus-trial.app.stackstate.io/#/metrics?alias=%24%7Bpod_name%7D&promql=container_cpu_usage%7Bcluster_name%3D%22segrocers-retail%22%2C%20namespace%3D%22cattle-system%22%2C%20container%3D%22rancher%22%2C%20pod_name%3D~%22rancher-.%2A%22%7D%20%2F%201000000000&timeRange=1728354032680_1728440432680&timestamp=1728440432680&unit=short). In general, UI is showing a fair number of "Something went wrong" messages, so would be good if someone could have a look

---

**Ankush Mistry** (2024-11-07 08:29):
Yes, these are the describe output for pods are not coming up and the namespace events

---

**Ankush Mistry** (2024-11-07 08:42):
And yes the customer is Infosys Ltd.

---

**Ankush Mistry** (2024-11-07 09:13):
Yes, I will get them.

---

**Alejandro Acevedo Osorio** (2024-11-07 09:45):
@David Noland Could it be possible to gather the reason by clicking in the `something` link ? Seeing the screenshot seems related to fetching the `related` namespaces from this cluster

---

**Louis Lotter** (2024-11-07 12:20):
@Louis Parkin Do you have any idea what could cause the agent here to fall back to hostname-based identification instead of using the configured cluster name ?

---

**Louis Parkin** (2024-11-07 12:24):
To my knowledge, the agent will use the cluster name provided by kubeapi to the cluster agent.  Without checking the code it's not easy to speculate.  If you want urgent attention, best to ask @Bram Schuur as I am off this afternoon.

---

**Louis Parkin** (2024-11-07 12:25):
But more questions are pending. Which agent's logs are we looking at here? Cluster, checks, node, or process?

---

**Louis Parkin** (2024-11-07 12:26):
Also, can we please have the values file used for deploying the agent (if no values file, then the command).

---

**Bram Schuur** (2024-11-07 12:40):
the last two lerror loglines indicate that the node agent is trying to reach out but can't,

```2024-11-04 20:29:31 UTC | CORE | ERROR | (pkg/autodiscovery/config_poller.go:211 in collect) | Unable to collect configurations from provider cluster-checks: "https://10.43.46.37:5005/api/v1/clusterchecks/configs/sckeqa-compute-57b98d448bxhdg96-fvxvl-sckeqa" is unavailable: 500 Internal Server Error```
Is the node registring to the cluster agent.
```2024-11-05 06:57:18 UTC | CORE | ERROR | (comp/forwarder/defaultforwarder/worker.go:191 in process) | Error while processing transaction: error while sending transaction, rescheduling it: Post "https://observability.apps.scke.corning.com/receiver/stsAgent/api/v1/series": read tcp 10.42.12.37:47888-&gt;10.180.105.165:443: read: connection reset by peer```

---

**Bram Schuur** (2024-11-07 12:41):
Is trying to reach stackstate but can't

---

**Bram Schuur** (2024-11-07 12:41):
My guess is something is blocking outgoing traffic therte

---

**Daniel Murga** (2024-11-07 13:05):
Hello folks! I'm monitoring this case as my colleague @Bruno Bernardi is based in Brazil. Is there anything we should ask the customer to provide to continue troubleshooting?

---

**Bruno Bernardi** (2024-11-07 16:32):
Please, can you inform us if there is any documentation that mentions which ports should be allowed on the firewall to communicate successfully between StackState Agent and downstream clusters? I think this could be useful if the issue is related to that. Thanks.

---

**Bram Schuur** (2024-11-07 16:35):
@Bruno Bernardi Right now we do not have that documented afaik (cc @Mark Bakker would be good to document this). The node agent will connect to the cluster agent on port 5005 (see the logs). All agent will try to reach the stackstate instance at 443 for https (so outbound), also see logs.

---

**Bram Schuur** (2024-11-07 19:37):
The ntp error is not pretty but benign, from what I see the agent is now functioning well. Could you see whether there is any data in the suse observability instance? Is that looking OK?

---

**Bram Schuur** (2024-11-07 19:38):
BTW I am pto tomorrow so someone else will have to continue with this @Louis Lotter

---

**Louis Parkin** (2024-11-07 19:55):
I’m back and back to normal tomorrow…

---

**Bruno Bernardi** (2024-11-07 20:02):
Thanks to everyone for your contributions. I'm waiting for the customer to describe better the current situation of his environment. At the moment, he is focusing on upgrading his Rancher to a certified Kubernetes version. I'll keep you posted.

---

**Bruno Bernardi** (2024-11-07 20:05):
The latest customer's feedback:

```1. They have upgraded the downstream cluster k8s version to 1.28

2. They removed the suse observability instance on the sckeob cluster, reinstalled it to 20-nonha, and added an additional node to the SCKEOB cluster, thereby supplying the required storage.

3. They reinstalled the SCKEQA cluster Observability agent and are seeing data in the Observability UI. However, the Rancher UI is still reporting not-observed.

4. They opened a support request asking for support instructions for upgrading the Kubernetes version on the Rancher Manager instance.```

---

**Bruno Bernardi** (2024-11-07 20:06):
It seems like the SUSE observability instance is looking OK, but the Rancher UI is still facing "cluster not-observed" issues.

---

**Bram Schuur** (2024-11-07 20:39):
Maybe @Anton Ovechkin can weigh in tomorrow, there were some issues with the extension there I believe. What version of the ui extension is installed? Are pods/nodes showing the clear/warning state that the extension is supposed to add?

---

**Bruno Bernardi** (2024-11-07 21:18):
Regarding the UI extension, the customer found that (a) the extensions were at v 0.5 and (b) the update to v 1.0 was available. He updated and then proceeded to 2.

Regarding the second question, clear or Warning states on the Pods and Nodes are not present, and the UI still reports unobserved.

---

**David Noland** (2024-11-08 02:30):
something is...

---

**David Noland** (2024-11-08 02:32):
and same thing for namespaces. There are 2052 namespaces in this cluster:
```17:30 ~/Devel/customers/segrocers-retail $ kubectl get ns --no-headers | wc -l
    2052```

---

**Mark Bakker** (2024-11-08 08:56):
@Bram Schuur lets indeed document the port issue!

---

**Alejandro Acevedo Osorio** (2024-11-08 09:17):
@Louis Lotter @Mark Bakker Shall we increase the limit of components for this trial?

---

**Ankush Mistry** (2024-11-08 09:19):
I have got the attached logs from the customer, kafka pod logs to follow.

---

**Alejandro Acevedo Osorio** (2024-11-08 14:24):
@David Noland I increased the limit to 3k elements.

---

**Louis Lotter** (2024-11-08 14:31):
Yeah we need a trial or 2 to go smoothly :sweat_smile:

---

**Louis Lotter** (2024-11-08 14:32):
why would they have so many namespaces :mindblown:

---

**David Noland** (2024-11-08 17:55):
Thanks for bumping up the limit to 3K. Getting this now:

---

**David Noland** (2024-11-08 17:58):
&gt; _why would they have so many namespaces_
This is a Rancher cluster. The customer has an edge use case and has 384 downstream clusters managed by Rancher. Each cluster requires a namespace. Each project also requires a namespace and there at least two of these per cluster. Each user also has their own namespace. It adds up fast!

---

**Alejandro Acevedo Osorio** (2024-11-08 18:56):
Well, it seems that such load for a `trial` setup is a little too much (That's why the 1k limit was set). We would need to scale up some of StackGraph resources. But I guess that'll have to wait until Monday

---

**David Noland** (2024-11-08 21:37):
ok, thanks

---

**Vladimir Iliakov** (2024-11-11 11:28):
Hi Amol, why I don't see `ERROR [KafkaServer id=0] Fatal error during KafkaServer startup` in the Kafka logs you attached?

---

**Louis Lotter** (2024-11-11 11:29):
@David Noland @Andreas Prins @Jeroen van Erp @Mark Bakker @Ravan Naidoo We are not clear on the strategy here and how to respond to cases like this. How are we onboarding customers, setting expectations etc ? And on the engineering side do we just scale up based on the customer load if they have more data than we were expecting ?

---

**Amol Kharche** (2024-11-11 11:29):
May be its old log, Currently I'm in call with customer. Now we are getting this error,

---

**Amol Kharche** (2024-11-11 11:31):
Other container(jmx-exporter) in kafka is running fine

---

**Vladimir Iliakov** (2024-11-11 11:32):
Just in case: they don't use NFS for the persistent volumes?

---

**Amol Kharche** (2024-11-11 11:33):
They used NFS

---

**Vladimir Iliakov** (2024-11-11 11:34):
I may speculate that the volume is/was mounted from the several pods as the error message suggests `org.apache.kafka.common.KafkaException: Failed to acquire lock on file .lock in /bitnami/kafka/data. A Kafka instance in another process or thread is using this directory.`

---

**Amol Kharche** (2024-11-11 11:35):
Hmm, But how to remove lock for now. I tried with going inside jmx-exporter but that wont help

---

**Vladimir Iliakov** (2024-11-11 11:37):
Either by mount the volume to some debug pod and delete the file manually
or if the NFS filesystem is accessible by any nfs client

---

**Vladimir Iliakov** (2024-11-11 11:39):
But there is a chance of data corruption if the volumes was accessed by multiple pods, so I would delete the volume and create it from scratch

---

**Amol Kharche** (2024-11-11 11:40):
This is fresh installation

---

**Vladimir Iliakov** (2024-11-11 11:40):
Then delete the volume and try again.

---

**Amol Kharche** (2024-11-11 11:43):
This is external nfs provisioner
```root@hrke2stckstatem01:~# kubectl get storageclass
NAME                   PROVISIONER                                     RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs-client (default)   cluster.local/nfs-subdir-external-provisioner   Delete          Immediate           true                   38d```

---

**Amol Kharche** (2024-11-11 11:45):
So plan is now.
1: Make the statefulstate replicas=0
2: Remove the PV
3: Try making repliacas=1

Is this plan fine or anything to add ?

---

**Vladimir Iliakov** (2024-11-11 11:45):
Maybe we should stop here. We, Suse Observability, don't recommend to use NFS for persistence volumes, especially in prodiction

---

**Vladimir Iliakov** (2024-11-11 11:45):
So is it a production setup?

---

**Amol Kharche** (2024-11-11 11:45):
Not production

---

**Vladimir Iliakov** (2024-11-11 11:46):
1: Make the statefulstate replicas=0
2: Remove the PV
3: Try making repliacas=1

Sounds good

---

**Vladimir Iliakov** (2024-11-11 11:47):
Also make sure that underlying directory on NFS is removed

---

**Amol Kharche** (2024-11-11 11:49):
Sorry I dont know How to remove the underlying directory on NFS

---

**Vladimir Iliakov** (2024-11-11 11:53):
I assume the NFS volume is on one of the cluster nodes. If so it is possible to access the directory by SSH-ing into the node.

---

**Amol Kharche** (2024-11-11 13:07):
We made changes at Clickhouse statefulset and manually deleted PV and it resolved kafka issue. Now dashboard working fine.

---

**Amol Kharche** (2024-11-11 13:07):
Thanks for your support...

---

**David Noland** (2024-11-11 19:55):
For Rancher Prime Hosted, we have decided that StackState (SUSE Observability) is our monitoring/alerting/observability solution. We have completely moved off of Opni and have the Stackstate agent running on all our hosted Rancher clusters, which I believe currently stands at 23 production clusters and 2 testing clusters. If this is set up as a "trial" configuration or setup, we should consider moving it to a production-grade configuration. In terms of customer onboarding, we expect to only add 1-2 customers per quarter at least until our L1 decides our SaaS strategy for Hosted Rancher.

Let me know if you need more information or have more questions. We can have a quick call if that will help and can also get Jeff Hobbs more in the loop if that's needed.

---

**Jeroen van Erp** (2024-11-11 20:04):
Yes, we need to upgrade that into a full instance

---

**Garrick Tam** (2024-11-12 01:30):
Unfortunately, this customer is still having problems.  They tried restarting tephra pod but it is just stuck in restart loop.  Is there a process by which we can scale specific sts/deploments to zero replicas and start them one at a time; ensure they are healthy before moving to the next pod in order to get the deployment working?

---

**Louis Lotter** (2024-11-12 07:59):
@Vladimir Iliakov @Alejandro Acevedo Osorio can you guys let me know exactly what the setup is that we have for David ? Is it HA ?

---

**Vladimir Iliakov** (2024-11-12 08:36):
It is old Stackstate 6.x tenant based on `k8s-trial` (nonHa) profile with some resource customizations.

---

**Alejandro Acevedo Osorio** (2024-11-12 09:14):
Hi, this time I see it's more about tephra not passing the readiness probe timely. If you are not on the latest version
```suse-observability/suse-observability       	2.1.0```
I'd recommend doing a `helm repo update` and installing that one. There's a fix for this issue where tephra gets throttled heavily and does not pass the readiness probe.
And alternative if for some reason you could not update to the latest version `2.1.0` is to relax the readiness and liveness probe yourself.

---

**Louis Lotter** (2024-11-12 09:15):
:neutral_face:. @David Noland I think we should migrate you to Suse Observability and give you a proper HA setup

---

**Louis Lotter** (2024-11-12 09:17):
Do you mind losing your historical data ?

---

**David Noland** (2024-11-12 17:34):
We are currently doing some fairly important RCAs for customers, so we need the data right now. Is there a way to copy it over? If not, we'd need to carefully plan the move if we'll lose all data.

---

**Louis Lotter** (2024-11-12 18:13):
@Alejandro Acevedo Osorio @Lukasz Marchewka what are the possibilities hete ?

---

**Garrick Tam** (2024-11-13 18:25):
Customer confirmed upgrading to chart 2.1.0 addressed the issue.

---

**Alejandro Acevedo Osorio** (2024-11-13 19:50):
Awesome. Thanks for the help @Garrick Tam !!!

---

**Garrick Tam** (2024-11-13 20:00):
Thank you for your help and patience.

---

**Amol Kharche** (2024-11-14 09:38):
Hi Team,
One of our customer(Infosys) facing issue in Suse-Observability, Correlate pod and server pod is restarting multiple times.
Attaching logs.

---

**Ankush Mistry** (2024-11-14 11:37):
Hi Team,
I have a customer Child Rescue Coalition (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMEIIAA4/view), who wants to do a free tier of the Stackstate SAAS service set-up, the customer mentioned that they had a demo from Alejandro Bonilla on Nov 1st, where he mentioned it would be possible to set up a free account with the StackState SAAS site. So how can this be achieved?

---

**Andreas Prins** (2024-11-14 12:04):
Hi Ankush, it looks like they are referring to SUSE Cloud Observability. There is the early access program of 6 months for free.

https://more.suse.com/SUSE_Cloud_Observability_Early_Access_Program.html (https://more.suse.com/SUSE_Cloud_Observability_Early_Access_Program.html)

---

**Andreas Prins** (2024-11-14 12:05):
He or she can go to the page, fill
In the details and get started.

---

**Andreas Prins** (2024-11-14 12:05):
The provision of the tenant will happen by us and they get user name and password

---

**Ankush Mistry** (2024-11-14 12:05):
Thank you so much Andreas!

---

**Amol Kharche** (2024-11-14 13:59):
@Mark Bakker I have added comment in STAC-21890 (https://stackstate.atlassian.net/browse/STAC-21890). I mean created script.

---

**Jeroen van Erp** (2024-11-14 17:13):
Be aware that there is no free tier. This will convert into a paid subscription after the evaluation time

---

**Andreas Prins** (2024-11-14 17:24):
Good addition

---

**Amol Kharche** (2024-11-18 07:34):
Hi Team,
Can someone please check and help with this issue.

---

**Louis Lotter** (2024-11-18 08:37):
@Louis Parkin could you take a first look ?

---

**Louis Parkin** (2024-11-18 09:10):
Although, it appears to be platform side, not agent, so not making early promises :wink:

---

**Louis Lotter** (2024-11-18 09:57):
any extra information we should ask for ? or will one of the other guys be able to puzzle this out from this data ?

---

**Louis Parkin** (2024-11-18 09:58):
The correlator log has a lot of kafka-related errors from the akka client, these are words I've heard @Alejandro Acevedo Osorio say :wink:

---

**Alejandro Acevedo Osorio** (2024-11-18 15:52):
The only obvious part to address is the errors on the server pod due to a misconfigured Notification which is failing over and over again. For the correlator I think you need to dig deeper @Louis Parkin ... perhaps check how kafka behaving at the time of the correlator crashes.

---

**Louis Parkin** (2024-11-18 15:57):
I don't have those data points @Alejandro Acevedo Osorio

---

**Louis Parkin** (2024-11-18 15:58):
@Amol Kharche is this a Saas, self-hosted, or on-prem instance?

---

**Amol Kharche** (2024-11-18 16:29):
Not sure exactly , Let me ask to customer

---

**Amol Kharche** (2024-11-22 08:07):
Hi Team,
We have received case 01561255 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000NU31eIAD/view?uid=173224380383038897) (Internal case ) where user already set up a air-gap environment for observability cluster and worker cluster.
it's work properly, but user can't collect application traces data, is there have simple demo setup docs for this?

---

**Amol Kharche** (2024-11-22 08:12):
Also I am trying to setup otel-collector using https://docs.stackstate.com/open-telemetry/collector. I am accessing observability UI through http://143.110.185.83:31925
So what can be put in endpoint ?
```    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: &lt;otlp-stackstate-endpoint&gt;:443```

---

**Alejandro Acevedo Osorio** (2024-11-22 11:16):
@Amol Kharche the `&lt;otlp-stackstate-endpoint&gt;:443` refers to an endpoint you configue via an otlp ingress https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-fo[…]e-observability-helm-chart (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-for-open-telemetry-traces-via-the-suse-observability-helm-chart)

---

**Amol Kharche** (2024-11-22 12:28):
It is not possible without ingress?  What is difference between https://docs.stackstate.com/open-telemetry/collector#kubernetes-configuration-and-deployment and https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-fo[…]e-observability-helm-chart (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-for-open-telemetry-traces-via-the-suse-observability-helm-chart) ? Can you please explain use of pod *suse-observability-otel-collector-0* in  our helm deployment ?

---

**Alejandro Acevedo Osorio** (2024-11-22 12:34):
This entry https://docs.stackstate.com/open-telemetry/collector#kubernetes-configuration-and-deployment refers to the otel collector (client otelcollector) running on the client cluster (where the apps we are trying to observe run)

*`suse-observability-otel-collector-0`* is a second otel collector (server otel collector) deployed on the suse-observability installation that helps receive and process the otel data from the client otel collector and needs to be exposed via a dedidcated otlp ingress because it works with GRPC so it needs some special config, and that otlp ingress is https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-fo[…]e-observability-helm-chart (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-for-open-telemetry-traces-via-the-suse-observability-helm-chart)

---

**Amol Kharche** (2024-11-22 13:16):
This is on-prem instances

---

**Amol Kharche** (2024-11-22 14:35):
I will try to configure them with ingress

---

**Alejandro Acevedo Osorio** (2024-11-26 09:41):
Yes both collectors can be on the same cluster. The logs you paste look quite Ok. Metrics being exported. :+1:

---

**Amol Kharche** (2024-11-26 10:03):
I still unable to figure out traces. Do you have any link to refer ?

---

**Alejandro Acevedo Osorio** (2024-11-26 10:08):
Mmm well the configuration of the server otel collector is important https://docs.stackstate.com/open-telemetry/collector#configure-the-collector

---

**Amol Kharche** (2024-11-26 10:51):
Seems I configured it correctly.
Here is my otel-collector look like.
```root@jumpsrv:~/terraform/suse-observability# cat otel-collector.yaml
extraEnvsFrom:
  - secretRef:
      name: open-telemetry-collector
mode: deployment
ports:
  metrics:
    enabled: true
presets:
  kubernetesAttributes:
    enabled: true
    extractAllPodLabels: true
config:
  extensions:
    bearertokenauth:
      scheme: SUSEObservability
      token: "${env:API_KEY}"
  exporters:
    otlp/stackstate:
      auth:
        authenticator: bearertokenauth
      endpoint: otlp-stackstate.144.126.253.65.nip.io:443 (http://otlp-stackstate.144.126.253.65.nip.io:443)
  processors:
    tail_sampling:
      decision_wait: 10s
      policies:
      - name: rate-limited-composite
        type: composite
        composite:
          max_total_spans_per_second: 500
          policy_order: [errors, slow-traces, rest]
          composite_sub_policy:
          - name: errors
            type: status_code
            status_code:
              status_codes: [ ERROR ]
          - name: slow-traces
            type: latency
            latency:
              threshold_ms: 1000
          - name: rest
            type: always_sample
          rate_allocation:
          - policy: errors
            percent: 33
          - policy: slow-traces
            percent: 33
          - policy: rest
            percent: 34
    resource:
      attributes:
      - key: k8s.cluster.name
        action: upsert
        value: do-blr1-amol-k8s-cluster
      - key: service.instance.id
        from_attribute: k8s.pod.uid
        action: insert
    filter/dropMissingK8sAttributes:
      error_mode: ignore
      traces:
        span:
          - resource.attributes["k8s.node.name"] == nil
          - resource.attributes["k8s.pod.uid"] == nil
          - resource.attributes["k8s.namespace.name"] == nil
          - resource.attributes["k8s.pod.name"] == nil
  connectors:
    spanmetrics:
      metrics_expiration: 5m
      namespace: otel_span
    routing/traces:
      error_mode: ignore
      match_once: false
      table:
      - statement: route()
        pipelines: [traces/sampling, traces/spanmetrics]
  service:
    extensions:
      - health_check
      - bearertokenauth
    pipelines:
      traces:
        receivers: [otlp]
        processors: [filter/dropMissingK8sAttributes, memory_limiter, resource]
        exporters: [routing/traces]
      traces/spanmetrics:
        receivers: [routing/traces]
        processors: []
        exporters: [spanmetrics]
      traces/sampling:
        receivers: [routing/traces]
        processors: [tail_sampling, batch]
        exporters: [debug, otlp/stackstate]
      metrics:
        receivers: [otlp, spanmetrics, prometheus]
        processors: [memory_limiter, resource, batch]
        exporters: [debug, otlp/stackstate]
root@jumpsrv:~/terraform/suse-observability#```

---

**Alejandro Acevedo Osorio** (2024-11-26 10:54):
and then the other part is to be sure that you have an application running instrumented to report open telemetry traces

---

**Alejandro Acevedo Osorio** (2024-11-26 10:55):
This one for example https://github.com/open-telemetry/opentelemetry-demo

---

**Alejandro Acevedo Osorio** (2024-11-26 10:55):
https://github.com/open-telemetry/opentelemetry-demo/blob/main/kubernetes/opentelemetry-demo.yaml

---

**Amol Kharche** (2024-11-26 10:57):
Let me try it

---

**Amol Kharche** (2024-11-26 11:38):
I have deployed that app but still dont see any traces.

---

**Alejandro Acevedo Osorio** (2024-11-26 11:42):
do you see any errors in any of both otel collectors?

---

**Alejandro Acevedo Osorio** (2024-11-26 11:55):
Both look good, but indeed *`opentelemetry-collector-dd4b78c5-m4nw8` does not get any traces*

---

**Alejandro Acevedo Osorio** (2024-11-26 11:59):
@Ravan Naidoo do you know what could be missing over here?

---

**Ravan Naidoo** (2024-11-26 12:25):
Try adding the `service.namespace`  attribute, as this is required by the server and should get rid of the “Skipping resource without necessary attribute” error.

```resource:
        attributes:
          - key: k8s.cluster.name
            action: upsert
            value: 'do-blr1-amol-k8s-cluster'
          - key: service.instance.id
            from_attribute: k8s.pod.uid
            action: insert
          - key: service.namespace
            from_attribute: k8s.namespace.name
            action: insert```
Although the collector is set to debug for traces, I don’t see any traces being logged.  This suggests that the instrumented application (demo application) is not configured to send traces to the collector that we configured.  Looking at https://github.com/open-telemetry/opentelemetry-demo/blob/main/kubernetes/opentelemetry-demo.yaml, this seems to be a self contained demo using its own collector and exporters.  So you would need to change all of that to use our collector.

Just to check if things are working, I would suggest deploying a simple application.  Try helm install of https://github.com/ravan/observability-hands-on/tree/main/charts/dino-diner  and change the values.yaml   `otelHttpEndpoint:` attribute to point to your collector.   Remember the format is `&lt;service-name&gt;.&lt;namespace&gt;.svc.cluster.local:4318`

---

**Alejandro Acevedo Osorio** (2024-11-26 12:28):
:facepalm:  Ouch forgot that part about the default config of  https://github.com/open-telemetry/opentelemetry-demo/blob/main/kubernetes/opentelemetry-demo.yaml  ... Thanks a lot @Ravan Naidoo!!

---

**Amol Kharche** (2024-11-26 13:42):
Its working with dino-diner (https://github.com/ravan/observability-hands-on/tree/main/charts/dino-diner) app. I am able to see traces. Thanks @Alejandro Acevedo Osorio @Ravan Naidoo

---

**Surya Boorlu** (2024-11-28 19:04):
Hi Team, Customer iFAST Singapore (https://suse.lightning.force.com/lightning/r/Account/001Tr000009LCCJIA4/view) is using SUSE observability 1.0. The namespace section, most of the namespace are showing unknown, instead of healthy or other state

All the agents are healthy.

Also, customer stated that it is showing active till this morning. Looks like the agent pods got restarted.

Can we do anything to set the status on track?

---

**Giovanni Lo Vecchio** (2024-11-29 10:08):
Hey Team!
Could you take a look at the STAC-21765 (https://stackstate.atlassian.net/browse/STAC-21765) case?

TIA!
GL

---

**Bram Schuur** (2024-11-29 10:57):
Thanks for bringing to our attention again @Giovanni Lo Vecchio, i missed that there was a follow-up issue on the ticket. I will make it a separate ticket.

---

**Giovanni Lo Vecchio** (2024-11-29 11:00):
Ok @Bram Schuur 
Thanks a lot!

---

**Giovanni Lo Vecchio** (2024-11-29 11:00):
Ok @Bram Schuur 
Thanks a lot!

---

**Bram Schuur** (2024-11-29 12:14):
@Mark Bakker I filed the following ticket: https://stackstate.atlassian.net/browse/STAC-22092, put it in next up

---

**Amol Kharche** (2024-11-29 12:58):
Hi Team,
The customer is facing an issue with SUSE Observability, where multiple pods are not coming up. Their infrastructure (entire cluster) was down for several days but is now up and running. However, the SUSE Observability pods are still not starting.
We attempted to increase the CPU/memory limits, but that didn't resolve the issue. We also tried reinstalling SUSE Observability, but that didn't help either.
Can you help here.

---

**Amol Kharche** (2024-12-02 09:02):
Hello Team, Can someone please check and help with this issue.

---

**Bram Schuur** (2024-12-02 09:04):
Dear @Amol Kharche, i am taking a look:+1:

---

**Bram Schuur** (2024-12-02 09:06):
So far i am a bit puzzled, i see no errors from the sus obesrvability related pods in the logs that were shipped, I do see the logs being abruptly terminated, like a node going down or k8s killing it.
In the events i see a couple of old killed events, but no crashloopbackoffs as in the image you sent

---

**Bram Schuur** (2024-12-02 09:08):
could you take a look why pods are being restarted? e.g. do a describe on the restarting pods and look at events/termination reasons?

---

**Amol Kharche** (2024-12-02 09:11):
We tried by rebooting both worker node but pods going in same status Init error.

---

**Bruno Bernardi** (2024-12-04 21:17):
Hi Team,

I've opened a case in Jira with some issues and possible suggestions for documentation related to OIDC (https://docs.stackstate.com/self-hosted-setup/security/authentication/oidc).

Could you please take a look at the STAC-22124 (https://stackstate.atlassian.net/browse/STAC-22124) case?

Thanks in advance.

---

**Louis Lotter** (2024-12-05 16:17):
@Amol Kharche I see you created this ticket https://stackstate.atlassian.net/browse/STAC-22124. While it's great that you took the initiative to create this ticket I encourage you to engage and highlight it in this channel so it can be discussed and prioritised accordingly.
We do not use Jira quite the same way as Jira SD works at Suse. So if you just create the ticket and hope it gets acted on you will be dissappointed.

---

**Amol Kharche** (2024-12-05 16:26):
Oh I see only name when creating ticket. Its originally created by @Bruno Bernardi .
Is it possible to change the name ?

---

**Bruno Bernardi** (2024-12-05 16:28):
Hi @Louis Lotter,

Thanks for clarifying. I was the one who opened that Jira using the shared account. I sent a message to the group yesterday in the thread (https://suse.slack.com/archives/C07CF9770R3/p1733343440168309) above, and I opened Jira with an issue and some suggestions for optimizing the OIDC documentation.

I'll be describing and clarifying the topics in the thread shortly.

---

**Louis Lotter** (2024-12-05 16:35):
ahh I forgot you guys are sharing the account apologies

---

**Louis Lotter** (2024-12-05 16:36):
@Deon Taljaard :point_up:

---

**Louis Lotter** (2024-12-05 16:38):
completely missed your message Bruno. I suggest you still give an overview of what its about in addition to the ticket here in the channel. But it's mostly my bad.

---

**Louis Lotter** (2024-12-05 16:40):
@Mark Bakker not sure about the next steps here. Will you deal with prioritising tickets like these ?

---

**Bruno Bernardi** (2024-12-05 16:41):
No problem, Louis. Thanks for reporting on the Jiras process, too. I'll keep that in mind for future cases. I'll send you an overview of the current case soon.

---

**Mark Bakker** (2024-12-05 16:43):
It seems to a clear support case to me, not a bug or feature

---

**Bruno Bernardi** (2024-12-05 16:46):
Hi Team,

This case is basically about an issue the customer is facing with the OIDC and some possible suggestions for optimizing the OIDC documentation.

So far, I've been able to support the customer and resolve a few issues, but we haven't yet resolved an issue regarding the inability to find a proper way how to map users to groups.

I would like the team's assistance in evaluating the customer's OIDC setup and seeing if StackState is interpreting this correctly.

Thanks!

---

**Louis Lotter** (2024-12-05 16:51):
Is it ok if we get back to you tomorrow on this one Bruno ?

---

**Bruno Bernardi** (2024-12-05 16:53):
Yes, no problem Louis. This case was opened as a sev4/low and is not urgent. Thanks for your help and attention.

---

**Amol Kharche** (2024-12-06 08:49):
There was some issue with *hrke2stckstatew01* , migrating the pod from *hrke2stckstatew01* to *hrke2stckstatew02*, the pods successfully came up

---

**Amol Kharche** (2024-12-06 09:31):
When we clicked on email button, its taking so long time, and never complete.

---

**Louis Lotter** (2024-12-06 14:12):
@Daniel Barra

---

**Rajesh Kumar** (2024-12-09 08:50):
I am not sure what I did, but one of my cluster nodes was down, so I replaced it with another, and since then I have been seeing this error. Any idea, how to fix it?

---

**Louis Parkin** (2024-12-09 10:08):
@Remco Beckers is this something you can assist with? Or do we need @Lukasz Marchewka?

---

**Lukasz Marchewka** (2024-12-09 10:10):
@Rajesh Kumar I know the problem, there are few possible reasons. We can have a meeting to fix it together, I'm available after 12:00, if it is critical we can do it before

---

**Rajesh Kumar** (2024-12-09 10:12):
It's my lab cluster so nothing urgent or critical. I can even uninstall and reinstall but I just wanted to know and investigate what to do if this happens on customer cluster

---

**Lukasz Marchewka** (2024-12-09 10:14):
I will ping you later so we can investigate it together :slightly_smiling_face:

---

**Bruno Bernardi** (2024-12-09 20:27):
Hi Team,

Sorry for mentioning you at this time, but I'd like to share a few more points about this case. This can be seen the next day without any problems.

I've been able to make progress with the analysis with the customer, and at the moment, we're missing some information about the OIDC integration.


Does the team have some working examples for Azure Entra ID? Because the customer is unable to see the JWT token received by Observability and unable to judge what subjects I’ve received. Any way to enable some verbosity to be able to see such token-related metadata in Server logs?

Maybe it can also help us if the team can share how we can set App registration because the customer tried to specify a group name as well as a group ID but had no luck at all. When logging in, we can only see Views, so I guess that the customer role is not properly mapped to Observability. Please see the attached files.

@Louis Lotter - Tomorrow, can you please check this with someone from the team? I looked for some guidance on this setting in the documentation and Slack channels, but unfortunately, I couldn't find anything about it.

Thanks in advance.

---

**Amol Kharche** (2024-12-10 08:49):
Hi Team,
Child Rescue Coalition (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMEIIAA4/view) customer not using an on-prem observability server, but are on a 6-month trial of your observability SAAS service. They are having some of the graphs in the UI show a lock symbol on them, and when they hover over it presented with a message indicating that we need to upgrade to Rancher Prime (see attachment). When they click on the Learn More link it takes to an error page that states "Link does not exist." The same thing happens when they click on the "Upgrade to Rancher Prime" link at the top of the main page.

---

**Bram Schuur** (2024-12-10 09:11):
Cc @Mark Bakker

---

**Mark Bakker** (2024-12-10 09:13):
Thanks for noting! @Anton Ovechkin which url's are these?
They should link to: https://www.suse.com/products/rancher/ for now (via short.io (http://short.io)).

---

**Mark Bakker** (2024-12-10 09:14):
Can you add them to short.io (http://short.io), or inform me about the links, I will add them then.

---

**Mark Bakker** (2024-12-10 09:15):
@Amol Kharche is Child Rescue Coalition specifically interested in running Observability as a SaaS and are they Prime customer?

---

**Amol Kharche** (2024-12-10 09:20):
They are a prime customer according to SCC. I will reach out to them to see if they are interested in running Observability as a SaaS.
Rancher Prime 16-50 Nodes, per Node, with 2 Rancher Prime Management Servers, Priority Subscription, 1 Year (https://scc.suse.com/organizations/716857/subscriptions/4985372)

---

**Mark Bakker** (2024-12-10 09:48):
Please make sure that at this moment we do not (yet) accommodate for this. We only have a community SaaS edition and a full fledged Prime on-prem edition at the moment. You can however tell them that we are investigating if there is a need for a SaaS version of the full fledged Prime edition where they run Rancher Prime themself and use the Observability Prime version as a SaaS service.

---

**Louis Lotter** (2024-12-10 14:11):
@Remco Beckers who knows most about how our OIDC systems work ?

---

**Remco Beckers** (2024-12-10 14:14):
I don't know who knows more about it, I have some experience there. Jeroen van Erp knows a lot about it I think, but maybe also @Bram Schuur or @Alejandro Acevedo Osorio. Not sure who touched this exactly.

---

**Remco Beckers** (2024-12-10 14:15):
I think this setting to enable more logging should still work: https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/auth-demo/auth-debug.yaml

---

**Remco Beckers** (2024-12-10 14:15):
Be aware that it will also log secrets with this enabled iirc

---

**Remco Beckers** (2024-12-10 14:21):
We don't have any working examples for Entrata (we haven't used that ourselves)

---

**Remco Beckers** (2024-12-10 14:22):
With logging enabled Suse observabilty should log the groups it receives from the OIDC provider

---

**Louis Lotter** (2024-12-10 14:31):
Thanks Remco

---

**Remco Beckers** (2024-12-10 14:33):
I also see that the documentation is incomplete and incorrect. The supported default roles are:
```roles:
  guest: []
  powerUser: []
  admin: []
  k8sTroubleshooter: []```
Where admin gives permissions to manage everything and k8sTroubleshooter is the one most users that are using SUSE Observability for troubleshooting need.

The entries in these lists are expected to match the values that are present in the oidc attribute that is configured in the `jwtClaims.groupsField` . In the example in the docs the field used is `groups` .

---

**Louis Lotter** (2024-12-10 14:35):
can we add fixing this to https://stackstate.atlassian.net/browse/STAC-22124 and then push it up in priority ?

---

**Remco Beckers** (2024-12-10 14:36):
So if we take the admin role in the docs as an example: All users with `oidc-admin-role-for-stackstate`  in the value of the `groups`  attribute (SUSE Observability must be allowed to receive this attribute, possibly this requires extra scopes) will get the permissions of the admin user. It could very well be Entrata doesn't have a `groups` attribute. What I can see from the screenshot in the ticket it does look like the `groups`  attribute should be provided, but given my lack of knowledge on Entrata I don't know what its value will be (if any).

---

**Remco Beckers** (2024-12-10 14:39):
To answer the questions in the ticket comment, there will be no `logins` section in the configuration. There will be an `oidc` section and a `staticSubjects` section, the latter is a translation of the role mapping to permissions.

---

**Bruno Bernardi** (2024-12-10 16:53):
Many thanks for your support and help, @Louis Lotter @Remco Beckers.

I'll test this debugging option in my lab and also the other options sent in Remco's feedback. After that, I will send some orientations to the customer so that he can better understand and have a status on the case. I'll keep you posted.

---

**Bruno Bernardi** (2024-12-10 18:39):
Hey team,

I've tested the debug option, and the short answer is that there is no new “debug” data in the Server visible.

This is how I’ve applied it:
```helm upgrade --install  \
  --namespace suse-observability \
  --create-namespace \
  --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/authentication.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/auth-debug.yaml \
  suse-observability \
  suse-observability/suse-observability```
Can you please let me know if any further action is required?

Thanks in advance.

---

**Bruno Bernardi** (2024-12-10 18:39):
Logs during the “login” phase (Just Info):

---

**Remco Beckers** (2024-12-10 20:12):
Oh. I see you're running the nonha setup, that makes total sense. But I didn't think of that. In that case the `api` section in the tank file does not apply, you can rename it or duplicate it under the `server` key at the same level.

---

**Remco Beckers** (2024-12-10 20:12):
I'm on the phone, so I can't easily give an example now

---

**Bruno Bernardi** (2024-12-11 03:19):
Thanks, Remco. I'll test it here, but it would be good if you could send us an example as soon as it's feasible for you.

---

**Remco Beckers** (2024-12-11 13:57):
Hi all, we've just released version 2.2.0 and 2.2.1 of SUSE Observability with a number of new features and bug fixes. Most of them are related to installation and configuration of SUSE Observability. For detailed release notes see
• https://docs.stackstate.com/self-hosted-setup/release-notes/v2.2.0
• https://docs.stackstate.com/self-hosted-setup/release-notes/v2.2.1
Note that the 2.2.0 version should not be used, right after releasing we found an issue that is fixed in the 2.2.1 version.

---

**Bruno Bernardi** (2024-12-11 15:51):
Thanks, Remco. Yesterday, we managed to enable the debug mode with the customer.

The configuration expects `groupsField: groups`, and the customer is mapping this group as admin: ["486abe9d-7590-4802-958f-38f38e669076"].

This is what’s received from the ID Provider via id_token. And for that group, the customer would like to map their nicely visible (*"486abe9d-7590-4802-958f-38f38e669076").* Please see the screenshots below to see the configuration and what the customer sees when they log in to StackState.

```groups=[
"f3c1a30e-345f-4dd1-98f2-eec4bdeec301"
"a0703c17-ecc6-4bdc-bcca-84ba2c7f31fa"
"78e35e1f-253e-4610-b220-d5ea62ead51a"
"486abe9d-7590-4802-958f-38f38e669076"
"e0d719cd-7271-47b3-bc60-c969632e948e"
"afee53df-fb6d-4819-822f-d4437b2ba762"
]```
Do you have any idea why he is not “Admin” then? It seems that the configuration is correct, but the users of this group can't log in as Admin. I asked for the partial debug log and also thought about the possibility of this being a bug. I'd appreciate your further comments on this.

---

**Amol Kharche** (2024-12-12 12:36):
Customer said they will eventually install the observability server on-prem but just wanted to try it out to evaluate whether it would be a suitable replacement for Rancher's Prometheus/Grafana monitoring application.

---

**Mark Bakker** (2024-12-12 12:54):
Hi Amol, thanks for the context!

---

**Remco Beckers** (2024-12-12 16:40):
I have no idea why he is not admin, given the information you provided it looks like the user should have admin permissions, the configuration looks to be correct.

But to troubleshoot that it would be really helpful to get the logs around the time of a login (with the secrets removed).

---

**Bruno Bernardi** (2024-12-12 16:56):
Thanks, Remco. I asked for the logs yesterday and I’m currently waiting for the customer's response.

---

**Remco Beckers** (2024-12-12 17:36):
You mention that the groups are listed in the `id_token`, but that is not where SUSE Observability needs them to be. Instead they are expected to be in the userProfile that is retrieved as part of getting the access token.

The only way to check if the groups are present there is via the debug logging.

---

**Remco Beckers** (2024-12-13 09:15):
I've just tried to set this up myself using the new Azure Entra Admin center and it works fine for me. There are 2 things I made sure I paid attention to.

Firstly, SUSE Observability used the authorization code flow, so there is no need for the authorization endpoint to return id or access tokens (also note that the callback url needs to include the query parameters, but given that the customer is authenticated I'm sure they figured that out already)

---

**Remco Beckers** (2024-12-13 09:16):
Secondly, I added the groups in the `Token configuration` by adding the `groups` claim (I also added the `preferred_username` but you could just use email instead). I also used the guid so am getting a similar group name as the customer:

---

**Remco Beckers** (2024-12-13 09:19):
I also added a secret but given that authentication seems to work I didn't make a screenshot.

Finally I used this configuration for SUSE Observability:
```stackstate:
  authentication:
    oidc:
      clientId: "<the-client-id>"
      secret: "<the-secret>"
      # The id is the Directory (Tenant) ID on the overview page of the App registration
      discoveryUri: "https://login.microsoftonline.com/<the Directory (tenant) ID>/v2.0/.well-known/openid-configuration"
      jwsAlgorithm: RS256
      scope: ["openid", "email", "profile", "offline_access"]
      jwtClaims:
        usernameField: "email"
        groupsField: groups
    roles:
      admin: [ "df71ff63-6526-4994-9473-e8e9c2d57fb6" ]```
Here `df71ff63-6526-4994-9473-e8e9c2d57fb6` is the group id of a group I created it Azure Entra ID. That final line in the config gives all users in that Entra ID group admin permissions

---

**Remco Beckers** (2024-12-13 09:34):
I followed this guide for setting up the Application (the Web applicaiton type, using a client secret) https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret
This guide for the groups claim https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret
And finally this one for finding out how to configure OIDC correctly https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc

I must say the documentation contains all the information needed but it is hard to find.

---

**Bruno Bernardi** (2024-12-13 14:26):
Thanks a lot for your feedback, Remco. I'll reproduce your setup in my lab and see if I can get the same result, too.

---

**Amol Kharche** (2024-12-13 14:33):
Hi Team,
If you're tired of manual installation and prefer a streamlined approach, check out the following repository. With just one script, you can install SUSE Observability in a few steps.
Your valuable feedback is greatly appreciated !!!
https://github.com/amolkharche13/suse-observability-scripts/tree/main/Installation

---

**David Noland** (2024-12-14 03:28):
I tried the directions, it didn't work:
```18:25 ~/Devel/terraform/k8s-cluster $ wget https://github.com/amolkharche13/suse-observability-scripts/blob/main/Installation/SOinstallation.sh
--2024-12-13 18:25:54--  https://github.com/amolkharche13/suse-observability-scripts/blob/main/Installation/SOinstallation.sh
Resolving github.com (http://github.com) (github.com (http://github.com))... 140.82.116.4
Connecting to github.com (http://github.com) (github.com (http://github.com))|140.82.116.4|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: 'SOinstallation.sh'

SOinstallation.sh                 [ &lt;=&gt;                                              ] 176.79K  --.-KB/s    in 0.1s

2024-12-13 18:25:55 (1.24 MB/s) - 'SOinstallation.sh' saved [181029]

18:26 ~/Devel/terraform/k8s-cluster $ bash SOinstallation.sh
SOinstallation.sh: line 7: syntax error near unexpected token `newline'
SOinstallation.sh: line 7: `<!DOCTYPE html>'```
The wget gives me the attached HTML file and not a shell script.

---

**David Noland** (2024-12-14 03:29):
And same issue with curl command.

---

**David Noland** (2024-12-14 03:31):
Got the shell script by doing a cut on web browser and pasted into file.

---

**Amol Kharche** (2024-12-14 03:46):
Thanks for pointing out,
Now it should work. I missed the `raw` keywords.
```amol@jumpsrv:~$ wget https://raw.githubusercontent.com/amolkharche13/suse-observability-scripts/refs/heads/main/Installation/SOinstallation.sh
--2024-12-14 02:43:11--  https://raw.githubusercontent.com/amolkharche13/suse-observability-scripts/refs/heads/main/Installation/SOinstallation.sh
Resolving raw.githubusercontent.com (http://raw.githubusercontent.com) (raw.githubusercontent.com (http://raw.githubusercontent.com))... 185.199.111.133, 185.199.108.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (http://raw.githubusercontent.com) (raw.githubusercontent.com (http://raw.githubusercontent.com))|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4544 (4.4K) [text/plain]
Saving to: 'SOinstallation.sh'

SOinstallation.sh                                               100%[====================================================================================================================================================&gt;]   4.44K  --.-KB/s    in 0s

2024-12-14 02:43:11 (9.21 MB/s) - 'SOinstallation.sh' saved [4544/4544]

amol@jumpsrv:~$ l```

---

**Amol Kharche** (2024-12-14 03:48):
This was happens due the URL provided is for the web interface and not the raw file content.

---

**David Noland** (2024-12-14 03:50):
great, works now

---

**Amol Kharche** (2024-12-16 11:43):
Hi Team,
In the SUSE Observability documentation, the version is not visible in the dropdown list(I mean the latest is just SUSE Observability).
When we log in to the SUSE Observability Dashboard,(Using latest chart 2.2.1) the version displayed is `v7.0.0+db9515b`. However, while opening a support case, the version appears as "SUSE Observability 1.0".
Could we streamline this and use a single version format across all platforms for consistency?
Thank you!

---

**Louis Parkin** (2024-12-16 11:52):
Hi @Amol Kharche, please note that the chart and the app versions may indeed be different.

---

**Louis Parkin** (2024-12-16 11:52):
`v7.0.0+db9515b` is the application version

---

**Louis Parkin** (2024-12-16 11:52):
And as you rightly referenced, `2.2.1` is the version of the helm chart.

---

**Louis Parkin** (2024-12-16 11:53):
Listing either of these on a support case should be fine, as the chart version is locked to an app version

---

**Louis Parkin** (2024-12-16 11:55):
The reason for this discrepancy is a result of these two entities in fact being versionable separately.  If we make an update to the helm chart, for example to change the default deployment behavior, that will cause the chart version to update, but the app version won't.

---

**Louis Parkin** (2024-12-16 11:56):
cc @Remco Beckers @Mark Bakker @Louis Lotter @Bram Schuur

---

**Amol Kharche** (2024-12-16 12:01):
Yes, the chart versions are indeed different, but we still have varying versions in use.

---

**Amol Kharche** (2024-12-16 12:01):
Typically, for NeuVector and Harvester, we maintain the same version across all areas except for the chart version. These areas include:
1. Documentation
2. Application version displayed in the UI
3. Version used for support cases in the SCC portal

---

**Louis Parkin** (2024-12-16 12:01):
I think I might have misunderstood

---

**Louis Parkin** (2024-12-16 12:02):
Are you then referring to the difference between v7.0.0 and SUSE Observability 1.0?

---

**Louis Parkin** (2024-12-16 12:03):
Okay, so it's a documentation issue.

---

**Louis Parkin** (2024-12-16 12:04):
@Mark Bakker do we re-version the platform (not version 7, but 1)? Or do we update the docs(version 7 and not version 1)?

---

**Amol Kharche** (2024-12-16 12:12):
Also Is it really necessary to display the build version(guessing)in the UI after v7.0.0?
For example: v7.0.0*+db9515b*
Just sharing my thoughts on this from customer point of view.

---

**Louis Parkin** (2024-12-16 12:13):
In `released` versions, no, I don't think so.  This is more useful for the nightly builds and for the `master` branch which have live applications running 24/7

---

**Louis Parkin** (2024-12-16 12:14):
If a person detected an issue on either of these two, it would help internally to find the version of the code that suffers from it.

---

**Louis Parkin** (2024-12-16 12:14):
Again, cc @Mark Bakker :point_up::skin-tone-3:

---

**Mark Bakker** (2024-12-16 13:46):
Let me write this down. Its something we need to think trough indeed.

---

**Bruno Bernardi** (2024-12-16 16:04):
Nice, Amol! I was able to test it now, and the script worked fine. Also installed StackState very quickly. :thankyou:

---

**David Noland** (2024-12-16 23:43):
Let's also take into consideration the UI Extension version too. Will that have it's own versioning or be aligned with the app/chart or something else? Agree we need a clear strategy on versioning otherwise customers will be confused and reporting/metrics in SFDC will be a mess.

---

**Mark Bakker** (2024-12-17 08:49):
This is tracked internally here: https://stackstate.atlassian.net/browse/STAC-22163

---

**Remco Beckers** (2024-12-17 12:18):
@Bruno Bernardi Did you here anything back from the customer or did you try it for yourself? I've made a docs update that includes instructions for Entra specifically and tries to clarify the original docs a bit further. It still needs a review and ideally I wait for confirmation that the customer got it to work.

You can already view it here https://stackstate.gitbook.io/stackstate-docs-development/untitled/self-hosted-setup/security/authentication/oidc#configure-the-oidc-provider and the Entra ID specific part https://stackstate.gitbook.io/stackstate-docs-development/untitled/self-hosted-setup/security/authentication/oidc/microsoft-entra-id.

---

**Bruno Bernardi** (2024-12-17 15:02):
Hi @Remco Beckers,

Thanks for your update and for publishing the documentation. I read them, and they were very good and descriptive.

Yes, I did some tests in my lab and managed to configure it correctly using the flow you sent on Friday. However, I have an important point to report.

The customer was using version 2.1.0 of StackState and the latest certified versions (https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-9-3/) of Kubernetes for Rancher Manager and downstream clusters. Considering the new version 2.2.1 of StackState released last week, I also asked the customer to upgrade to keep his environment up to date and with the new features/corrections of this version. The point is that version 2.2.1 made the customer's old setup work without any changes.

I tested the setup you sent on Friday and the customer's old setup in version 2.1.0, and neither worked. However, both worked correctly in version 2.2.1. So, I believe that version 2.2.1 also included a fix for this. I'm not sure if you want to try testing this, too, but that would be the point of attention I wanted to communicate to the team.

I've now shared the new documentation with the customer, and I expect he'll be very satisfied, as the points he requested have been included. Considering this time of year, customers take longer to update support cases, and I've been waiting since yesterday for new feedback from the customer to see if we can close the case. I'll keep you updated on this.

Thanks for all your help!

---

**Remco Beckers** (2024-12-17 15:05):
I'm not aware of any changes to authentication/authorization in the 2.2.x releases

---

**Remco Beckers** (2024-12-17 15:07):
But, overall, that's great news! :smile:

---

**Remco Beckers** (2024-12-17 15:38):
I've tried to reproduce the authorization not working for 2.1.0 but didn't get any issues. It just works for me on that version too. Maybe it was simply the extra helm update and/or restart of pods that triggered it to work?

---

**Bruno Bernardi** (2024-12-17 15:44):
Thanks for testing, Remco. I also suspect that the restarting of the pods may influenced. Or maybe the version of Kubernetes, in the customer's case, was version 1.27. I've seen a few cases where the Kubernetes version also had an influence on some random behaviors.

An update on the case. The customer has now replied, saying that everything is fine and he really appreciates the new documentation. Thanks!

---

**Remco Beckers** (2024-12-17 15:57):
:thumbs-up:

---

**Louis Lotter** (2024-12-18 07:53):
@Gaurav Mehta

---

**Amol Kharche** (2024-12-18 09:12):
Hi Team,
I have documented my observations in the Air Gapped environment when pulling Docker images while executing the command `./o11y-save-images.sh -i o11y-images.txt -f o11y-images.tar.gz`.
My analysis can be found at https://github.com/amolkharche13/Airgapped-images-pull.
I have modified the potential workaround to make the script run faster. So just want to know if really helpful

---

**Vladimir Iliakov** (2024-12-18 10:17):
I can't say if the time is really critical for this operation, but looks like a nice improvement :thumbs-up:
A potential issue I see is the parallel processes cluttering the output.

---

**Amol Kharche** (2024-12-18 12:54):
@Vladimir Iliakov Is it mandatary to put username/password while configuring email notification ? We have customer and their smtp team said we do not have any username/password for anyone in Organization to connect to smtp server.

---

**Amol Kharche** (2024-12-18 13:30):
As per documents it said.
```SUSE Observability needs to be configured with credentials to connect to the SMTP server. ```

---

**Vladimir Iliakov** (2024-12-18 13:39):
https://docs.stackstate.com/self-hosted-setup/configure-stackstate/email-notifications
```stackstate:
  email:
    additionalProperties: 
      # Add needed Java email properties for your mail server (use string values), defaults are: 
      "mail.smtp.auth": "true"
      "mail.smtp.starttls.enable": "true"
    server:
      protocol: smtp
      port: 587```
Maybe `"mail.smtp.auth": "false"` will work. I haven't used it. <!subteam^S07AVPGFY0Y> can you confirm?

---

**Remco Beckers** (2024-12-18 17:24):
I'm not 100% sure that `"mail.smtp.auth": "false"` would be sufficient, because the code still adds a username/password . I haven't found documentation that is super clear on that. If that is not sufficient you can try to set the username/password to `null` or we need to change the code.

---

**Remco Beckers** (2024-12-18 17:25):
I don't have something available to properly test this at the moment

---

**Gaurav Mehta** (2024-12-18 22:59):
Hi Team, a Harvester customer while performing an upgrade ran into an issue while extracting the new images packaged in the upgrade iso. The errors noticed were same as https://github.com/containerd/containerd/issues/10239 and we eventually found out the customer was running stackstate on Harvester. Once we got the customer to disable stackstate their upgrade completed smoothly

---

**Gaurav Mehta** (2024-12-18 23:00):
I am trying to find out if we can get access to stackstate so we can try and add more scenarios to our QA plans where statestack is installed to a cluster

---

**Gaurav Mehta** (2024-12-18 23:01):
I am also keen to hear if any other customers/ users may have reported a similar issue

---

**Jeroen van Erp** (2024-12-18 23:06):
Gaurav, were they running StackState in the harvester cluster, or in a VM running a cluster?

---

**Gaurav Mehta** (2024-12-18 23:06):
on the harvester cluster itself

---

**Gaurav Mehta** (2024-12-18 23:07):
which is what brought me here :smile:

---

**Jeroen van Erp** (2024-12-18 23:07):
The agent or the full platform?

---

**Gaurav Mehta** (2024-12-18 23:07):
i believe just the agent.. i saw the cluster agent and logging daemonset in the support bundle

---

**Gaurav Mehta** (2024-12-18 23:08):
sorry i am not even sure of what all components are there

---

**Gaurav Mehta** (2024-12-18 23:08):
is there a StackState for dummies guide to help get started

---

**Gaurav Mehta** (2024-12-18 23:09):
```suse-observability-agent          suse-observability-checks-agent-5b5c7849fd-m7k78                  1/1     Running     0               15d
suse-observability-agent          suse-observability-cluster-agent-645657b648-dssfr                 1/1     Running     1 (3d15h ago)   15d
suse-observability-agent          suse-observability-logs-agent-4bjrz                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-bvvk9                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-gl4xg                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-mkxb8                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-s996j                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-sds64                               1/1     Running     0               15d
suse-observability-agent          suse-observability-logs-agent-wbkz7                               1/1     Running     0               15d
suse-observability-agent          suse-observability-node-agent-2bc9m                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-7748x                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-bk5gp                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-pkrmf                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-qh7qm                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-st2gf                               2/2     Running     0               15d
suse-observability-agent          suse-observability-node-agent-wmzvv                               2/2     Running     0               15d```

---

**David Noland** (2024-12-19 01:39):
If you want to get a really quick start, I can give you YAML that will deploy the agent and talk to my StackStack SaaS.

---

**Gaurav Mehta** (2024-12-19 01:46):
i would like a better option so i can get it added to QA :smile:

---

**Gaurav Mehta** (2024-12-19 01:46):
but thanks for the offer

---

**Gaurav Mehta** (2024-12-19 01:46):
i am also hoping someone can answer if this may be a known issue or what to check when this happens so we can get this fixed

---

**Remco Beckers** (2024-12-19 08:33):
@Bram Schuur I think you've seen something like this as well recently or am I mistaken?

---

**Bram Schuur** (2024-12-19 09:07):
yes, i filed this ticket, i put it top of next up: https://stackstate.atlassian.net/browse/STAC-22168

---

**Bram Schuur** (2024-12-19 09:10):
I have added this thread to the ticket, i think this should get prio (cc @Mark Bakker)

---

**Gaurav Mehta** (2024-12-19 09:22):
is there an easier work around than uninstalling the agent?

---

**Bram Schuur** (2024-12-19 09:23):
in the case i filed restarting the node-agent daemonset was sufficient, but i cannot say for sure that will be the case always

---

**Bram Schuur** (2024-12-19 10:54):
I found the following existing issue on the datadog upstream, i will be porting this patch: https://github.com/DataDog/datadog-agent/pull/26404
I found the following pre-existing ticket that i will use to track this issue: https://stackstate.atlassian.net/browse/STAC-21183

---

**Louis Lotter** (2024-12-19 10:57):
Thanks Bram

---

**Bram Schuur** (2024-12-19 16:40):
The issue has been fixed, it will be released with a new agent release on tuesday

---

**Gaurav Mehta** (2024-12-20 01:26):
is there a GH issue or anything else that we can provide to our customer

---

**Amol Kharche** (2024-12-20 10:48):
I just tried in customer environment by setting `"mail.smtp.auth": "false"` but it is not working. Is there any other way we can try now?
```stackstate:
  email:
    enabled: true
    sender: "<mailto:KaaSalerts@infosys.com|KaaSalerts@infosys.com>"
    server:
      host: "BLRKECSMTP01.ad.infosys.com (http://BLRKECSMTP01.ad.infosys.com)"
      port: 25
      protocol: smtp
      auth:
        username: ""
        password: ""
    additionalProperties:
      "mail.smtp.auth": "false"```

---

**Remco Beckers** (2024-12-20 10:50):
You can try by also setting `username` and `password` to `null` (not quoted), but tbh I am not very confident that will work

---

**Amol Kharche** (2024-12-20 13:16):
I am able to test successfully in my environment by setting the username and password to null. I'll ask the customer to try this as well.

```stackstate:
  email:
    enabled: true
    sender: "root@stackstate.rancher.com"
    server:
      host: "stackstate.rancher.com"
      port: 25
      protocol: smtp
      auth:
        username: "null"
        password: "null"```

---

**Remco Beckers** (2024-12-20 13:45):
Wow, call me surprised

---

**Rodolfo de Almeida** (2024-12-20 21:28):
Hello Team, Could you please help me with a customer problem?
The customer is complaining that they are unable to configure Observability extension after install in Rancher. The error is in the attached image.
They are using the following versions:
```rancher prime version 2.9.2
observability extension version 1.0.0 (also tried v0.5.0)```
I suggested the customer to test the skip ssl verification but even using this option they are still with the same problem.
```helm upgrade --install \
--namespace suse-observability \
--create-namespace \
--set-string 'stackstate.apiKey'='8dWnMzY0LbKYyoWfxSDn3haLdzCrj0nJ' \
--set-string 'stackstate.cluster.name'='azure-aks-ccoe-tst-northcentralus-01' \
--set-string 'stackstate.url'='https://default.aks-ccoe-tst.azure.corp.intranet/receiver/stsAgent' \
--set 'nodeAgent.skipKubeletTLSVerify'=true \
--set 'global.skipSslValidation'=true \
suse-observability-agent suse-observability/suse-observability-agent```
Any idea what else should we check?

---

**Jeroen van Erp** (2024-12-20 23:41):
Is the ingress to StackState protected by a valid ssl certificate? The extension will only work with a valid https connection

---

**Amol Kharche** (2024-12-23 11:21):
Hi Team,
I’ve just written a Terraform script to quickly deploy a SUSE Observability cluster.
Please feel free to review it and share any suggestions/feedback.  https://github.com/amolkharche13/terraform-suse-observability

---

**Rodolfo de Almeida** (2024-12-27 17:46):
Thanks @Jeroen van Erp I tested that in my lab environment with a valid ssl certificate and ti worked.
I am still waiting customer response on that.

---

**Rodolfo de Almeida** (2024-12-27 17:51):
Hi all,
Are there any plans to integrate Rancher SSO for accessing StackState?
Currently, we can access applications like NeuVector, Longhorn, or Harvester by logging into the Rancher UI and using the provided links. Rancher users can seamlessly access these applications through the Rancher UI, where they are automatically logged into the respective application interfaces.
Have you already received a similar request to allow users to launch and log in automatically via the Rancher UI?

---

**Rodolfo de Almeida** (2024-12-27 17:54):
I have another question regarding the agent:
Does it make sense to install the agent in the Kubernetes cluster where StackState is deployed? It is like StackState monitoring itself.
I did not received that question yet, but I probably will....

---

**Mark Bakker** (2024-12-30 09:44):
Yes, this is planned, it will be build in the coming months.

---

**Mark Bakker** (2024-12-30 09:44):
It's one of our top prio's

---

**Rodolfo de Almeida** (2024-12-30 13:00):
ok thanks @Mark Bakker

---

**Louis Lotter** (2024-12-30 15:13):
Hi. we already do this to monitor stackstate. eating our own dogfood so to speak.

---

**Louis Lotter** (2024-12-30 15:13):
its our primary way of monitoring out saas instances.

---

**Rodolfo de Almeida** (2024-12-30 17:04):
awesome.... Thanks for sharing that.

---

**Rodolfo de Almeida** (2025-01-03 14:11):
Hello everyone,
The customer is trying to use a certificate signed by and internal CA. Is there a way to make it work? I believe this is something similar when using a self-signed certificate, correct?

---

**Remco Beckers** (2025-01-03 15:06):
The extension uses Ranchers `/meta/proxy` to connect to SUSE Observabilty. So Rancher will need to accept the Interal CA as a valid CA.

I've never done that or tested it but it looks like you can include custom CA's in Rancher: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/custom-ca-root-certificates

---

**Remco Beckers** (2025-01-03 15:07):
For the agent I think the setting you already included ( `--set 'global.skipSslValidation'=true` ) should be enough

---

**Rodolfo de Almeida** (2025-01-03 15:13):
Ok Thanks @Remco Beckers
Is this also applicable to self-signed certificates?

---

**Remco Beckers** (2025-01-03 16:03):
Yes, also for self-signed

---

**Remco Beckers** (2025-01-03 16:04):
I don't know Rancher very well, so there could be other options too

---

**Rodolfo de Almeida** (2025-01-03 16:13):
I will test it in my lab environment as well... Thanks

---

**Bruno Bernardi** (2025-01-06 16:25):
Hi @Remco Beckers,

Hope you're doing well and had a good start to the year.

Sorry for revisiting this topic, but I've received feedback from some members of the support team about the documentation.

Do you think it would be interesting if we included some screenshots of the OIDC configuration in the published documentation? I understand that the documentation redirects to other good Microsoft documentation that has screenshots, but as customers really appreciate screenshots in our official documentation, I'd like to validate with you if we can include them.

These screenshots would basically be the ones we talked about in this thread about configuring the OIDC provider in Azure. If it's possible for me to access the StackState documentation repository to generate a PR, I can help.

Thanks!

---

**Remco Beckers** (2025-01-07 08:30):
We could, but the Microsoft documentation is pretty complicated to be honest. That's why I didn't want to reproduce it, also with the risk that we are out-of-date later. But if you think screenshots will help there you're welcome to add them. The docs are in this public Github repository https://github.com/StackVista/stackstate-docs/.

You can simply make a fork, add your changes and make a pull request (just make sure to create your branch from the `suse-observability` branch). The Microsoft OIDC docs are here: https://github.com/StackVista/stackstate-docs/blob/suse-observability/setup/security/authentication/oidc/microsoft-entra-id.md

---

**Vladimir Iliakov** (2025-01-09 11:24):
Hi @David Noland, I am going to do some maintenance on the cluster hosting suseus-trial today. The tenant will be unavailable for 10-20 minutes.

---

**David Noland** (2025-01-09 17:01):
@Vladimir Iliakov that's fine. If possible, can you not do the maintenance today between 17:00 - 18:00 UTC. We have a planned maintenance work for Hosted Rancher and I rely on the metrics to determine the health of the environments. Anytime outside that window is fine.

---

**Vladimir Iliakov** (2025-01-09 17:03):
Cool. It was done a few hours ago. No more work is planned on our side.

---

**Ankush Mistry** (2025-01-15 14:13):
Hello Team,
IHAC ASML Netherlands (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaSbsAAF/view), They installed Observability last week and want to use a test application using OTEL, as per the document they used the environment variables: https://docs.stackstate.com/open-telemetry/languages/sdk-exporter-config
```[otel.javaagent 2025-01-15 08:21:28:885 +0000] [OkHttp http://suse-observability-otel-collector.suse-observability.svc.cluster.local:4317/...] WARN io.opentelemetry.exporter.internal.grpc.OkHttpGrpcExporter - Failed to export spans. Server responded with gRPC status code 2. Error message: missing Authorization header```
As per the document, https://docs.stackstate.com/open-telemetry/troubleshooting#suse-observabilitys-otlp-endpoint-and-api-key-are-misconfigured, it seems that it is an authorization error, could you please suggest on this?

---

**Frank van Lankvelt** (2025-01-15 14:19):
did they set the authorization header section in the otel collector config?  https://docs.stackstate.com/security/k8s-ingestion-api-keys#otel-collector

---

**Ankush Mistry** (2025-01-15 14:56):
This was deployed via helm, so the customer is asking if the collector has a separate helm config as it gets configured during the installation.

---

**Frank van Lankvelt** (2025-01-15 16:19):
do I understand correctly that they are sending data directly to the suse-observability collector from their containers?  The recommended setup is to run an otel-collector in the same cluster as the application and let that take care of authentication - see https://docs.stackstate.com/open-telemetry/collector.

---

**Rodolfo de Almeida** (2025-01-16 04:43):
Hello @Remco Beckers could you please help me with another issue related to this case.
The customer successfully configured Rancher to truste their internal CA and applied the setting `--set 'global.skipSslValidation'=true` . The customer said that now the add-on has been sucessfully configured.
They installed the agent in the downstream cluster, they can see an active status and a green check mark in the StackPacks section and they can monitor the downstream cluster. However they cannot see the cluster status using the add-on inside Rancher UI.
They still see the status `Cluster is not observed by rancher Prime Observability. Please Install the agent.`
Any idea why is this happening?

---

**Jeroen van Erp** (2025-01-16 08:13):
Is the cluster name in observability the same as the cluster name in rancher, if there's a mismatch it will not be recognized

---

**Rodolfo de Almeida** (2025-01-16 16:32):
I will double check with the customer.

---

**Mark Bakker** (2025-01-21 08:53):
@Bram Schuur on which Agent version is this fixed?

---

**Bram Schuur** (2025-01-21 11:26):
It was release with version 1.0.15

---

**Bram Schuur** (2025-01-21 11:26):
Of the agent

---

**Rodolfo de Almeida** (2025-01-22 12:34):
Hi team,
The customer Warba Bank is trying to enable the Stackstate Add-on in Rancher but the it is stuck in downloading.
The screenshot show Rancher v2.9.5 but the customer mentioned they are using Rancher v2.10.1.
Have you ever seen this problem before?

---

**Amol Kharche** (2025-01-22 13:10):
https://suse.slack.com/archives/C07DUPSJUPM/p1728574671370509

---

**Rodolfo de Almeida** (2025-01-22 13:27):
I am not sure if I understood it correctly.
As I understand they are discussing why a nodedriver is being used to communicate StackState and Rancher correct?

---

**Rodolfo de Almeida** (2025-01-23 02:58):
Hello @Jeroen van Erp
I confirmed that the customer configured the name correctly. Please check the screenshot collected from the customer environment.
You can also see that in the Observability UI the cluster is showing `Active` state but in the Rancher UI it is still showing the pending agent installation.
What else can we check?

---

**Amol Kharche** (2025-01-27 08:10):
Hi Team,
We have customer and would like to monitor inbound/outbound traffic for a specific VM in harvester cluster and also would like to receive an alert if the VM traffic stops.
Can SUSE Observability be used here? The agent could be installed in the harvester cluster. Do you have any suggestion? [cc: @Rodolfo de Almeida @David Noland]

---

**Louis Lotter** (2025-01-27 10:34):
@Mark Bakker Has harvester integration been discussed ?

---

**Mark Bakker** (2025-01-27 13:23):
The agent should work with harvester workloads in the cluster and this data should also be available.
Creating a monitor should be possible as well. I suggest to connect with @Ravan Naidoo as the DSA on Observability.

---

**Ravan Naidoo** (2025-01-27 13:55):
Attached is an example of a VM from Havester in SUSE Observability.

@Mark Bakker I get that the HTTP-like metrics are not present on an observed VM.  But why is the Network throughput for pod empty?

---

**Ravan Naidoo** (2025-01-27 14:02):
I see kubevirt exposes metrics about the VM.  So in addition to the defaults picked up by the SUSE Observability agent, we could also scrape the kubevirt metrics and project those onto the VM pod.

https://kubevirt.io/monitoring/metrics.html

---

**Rodolfo de Almeida** (2025-01-27 14:03):
Hello @Jeroen van Erp
Could you please help us clarify this question? Is it normal for the Node Driver to be stuck in the Downloading state?

---

**Mark Bakker** (2025-01-27 14:04):
@Ravan Naidoo that sounds strange. Let me make a bugticket out of that. Don't know why that is.

---

**Mark Bakker** (2025-01-27 14:06):
@Ravan Naidoo do you see the relations between vm's and is there traffic?

---

**Mark Bakker** (2025-01-27 14:07):
Created this ticket to track it:
https://stackstate.atlassian.net/browse/STAC-22299

---

**Mark Bakker** (2025-01-27 14:08):
If you have any comments how you tested it feel free to comment

---

**Jeroen van Erp** (2025-01-27 14:12):
Yes, It’s something in Rancher that I’m unsure of why… Maybe @Alexandre Alves can explain why that happens. We do know an alternative route to forego the NodeDriver, yet no bandwidth to implement

---

**Rodolfo de Almeida** (2025-01-27 14:15):
Ok, thanks for confirming. Will the integration between Rancher and StackState work even if the Node Driver is still in the downloading state?

---

**Rodolfo de Almeida** (2025-01-27 14:49):
@Ravan Naidoo
I am planning to install and also test it.
When working with Harvester, where should I install StackState? Should I install it directly to Harvester or should I create a downstream cluster to install stackstate and only install the agent in the Harvester cluster?

---

**Ravan Naidoo** (2025-01-27 14:50):
You should indeed only install the agent in the Harvester cluster .

---

**Rodolfo de Almeida** (2025-01-27 15:13):
Hello @Remco Beckers
Could you please help with this issue? Any idea what we should check on this?

---

**Remco Beckers** (2025-01-27 16:00):
The check for `unobserved` looks like it doesn't connect with SUSE Observability at all, it simply verifies there are at least 2 deployments in the cluster with the label  `app.kubernetes.io/name (http://app.kubernetes.io/name) == suse-observability-agent`

---

**Remco Beckers** (2025-01-27 16:03):
So you could check that there are indeed 2 deployments for the agent present (one is a `suse-observability-agent-checks-agent`, the other the `suse-observability-agent-cluster-agent` ). The name doesn't matter and can be a bit different though.

This does look very fragile to me though. For exampe, I can imagine the user doesn't have permission to see the namespace/project where the agents are running, then I would expect this check to fail.

---

**Remco Beckers** (2025-01-27 16:04):
They can also check if they see pods, deployments etc in SUSE Observability. Those should be there given the green checkmark on the stackpack

---

**Rodolfo de Almeida** (2025-01-27 17:04):
Ok got it… thanks

---

**Jeroen van Erp** (2025-01-27 17:11):
Yes, it should definitely work, regardless of the state.

---

**Rodolfo de Almeida** (2025-01-27 19:30):
Thank you!

---

**Rodolfo de Almeida** (2025-01-28 19:34):
Hello @Ravan Naidoo
I saw you comment regarding the virtlauncher pod and in my lab I have the same behavior.
For VM network traffic we should monitor the VMI, which is the Virtual Machine Instance. The virtlauncher pods manages the VM lifecycle and allocate the resources required by the VM.
Can we add this to the feature request?

The customer is also asking if it is possible to send alerts if the network traffic stops.

---

**Rodolfo de Almeida** (2025-01-28 21:19):
@Remco Beckers
I can confirm that the agents running inside the downstream cluster have that specific annotation.
```    labels:
      app.kubernetes.io/component (http://app.kubernetes.io/component): checks-agent
      app.kubernetes.io/instance (http://app.kubernetes.io/instance): suse-observability
      app.kubernetes.io/name (http://app.kubernetes.io/name): suse-observability-agent
      pod-template-hash: 76c5b655dc
    name: suse-observability-checks-agent-76c5b655dc-gwlzd
    namespace: suse-observability```
```    labels:
      app.kubernetes.io/component (http://app.kubernetes.io/component): cluster-agent
      app.kubernetes.io/instance (http://app.kubernetes.io/instance): suse-observability
      app.kubernetes.io/name (http://app.kubernetes.io/name): suse-observability-agent
      pod-template-hash: 775fcfcf86
    name: suse-observability-cluster-agent-775fcfcf86-7g5rm
    namespace: suse-observability```
This is the pods they can see in the `suse-observability`  namespaces.
```NAME                                                READY   STATUS    RESTARTS        AGE    IP                NODE               NOMINATED NODE   READINESS GATES
suse-observability-checks-agent-76c5b655dc-gwlzd    1/1     Running   0               3d9h   10.42.91.35       rnchwrkodc02-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-cluster-agent-775fcfcf86-7g5rm   1/1     Running   7 (18h ago)     3d9h   10.42.60.204      rnchwrkodc03-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-59vdj                 1/1     Running   0               3d9h   10.42.205.187     kubeodc01-test5    &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-lfrj9                 1/1     Running   0               3d9h   10.42.140.244     kubeodc01-test4    &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-nj2w7                 1/1     Running   0               3d9h   10.42.91.43       rnchwrkodc02-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-nm8q8                 1/1     Running   0               3d9h   10.42.170.189     kubeodc01-test6    &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-qh75r                 1/1     Running   0               3d9h   10.42.5.176       rnchwrkodc01-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-logs-agent-sqqpb                 1/1     Running   0               3d9h   10.42.60.235      rnchwrkodc03-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-48rcg                 2/2     Running   4 (3h49m ago)   3d9h   151.117.200.88    rnchwrkodc02-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-5zfcv                 2/2     Running   0               3d9h   151.117.117.159   kubeodc01-test4    &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-6mw2t                 2/2     Running   8 (21h ago)     3d9h   151.117.117.162   kubeodc01-test5    &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-c5rgn                 2/2     Running   2 (18h ago)     3d9h   151.117.200.90    rnchwrkodc01-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-lwbsr                 2/2     Running   1 (33h ago)     3d9h   151.117.200.89    rnchwrkodc03-sbx   &lt;none&gt;           &lt;none&gt;
suse-observability-node-agent-thgwn                 2/2     Running   24 (18h ago)    3d9h   151.117.117.161   kubeodc01-test6    &lt;none&gt;           &lt;none&gt;```
They have a green check mark on the StackPack, please see the picture attached.

The main problem is that the integration is still showing as `Cluster not Observed` in the Rancher UI. The customer also confirmed that they can monitor the cluster inside Observability UI.

Any other idea?

---

**Jeroen van Erp** (2025-01-28 22:41):
Is the downstream cluster named the same in both observability and Rancher? If the names are not a match, the extension will not recognize the cluster as being observed

---

**Rodolfo de Almeida** (2025-01-28 22:58):
Yes the name are exactly the same

---

**Rodolfo de Almeida** (2025-01-28 22:59):
The customer shared some screenshots showing that the names are the same.
https://suse.slack.com/archives/C07CF9770R3/p1737597485615959?thread_ts=1734726499.071049&amp;channel=C07CF9770R3&amp;message_ts=1737597485.615959 (https://suse.slack.com/archives/C07CF9770R3/p1737597485615959?thread_ts=1734726499.071049&amp;channel=C07CF9770R3&amp;message_ts=1737597485.615959)

---

**Jeroen van Erp** (2025-01-28 23:20):
Which version of the extension is installed?

---

**Remco Beckers** (2025-01-29 08:59):
I'm out of ideas now. Though I did create a bug ticket to make these checks a lot more robust and not be so dependent on user permissions

---

**Remco Beckers** (2025-01-29 08:59):
I'm not sure anymore that's the problem here though

---

**Rodolfo de Almeida** (2025-01-29 13:18):
They are using the observability extension version 1.0.0 (also tried v0.5.0)

---

**Remco Beckers** (2025-01-29 13:31):
I don't think that should break this specifically.  Did you check if there are pods, services, etc in SUSE Observability? That will tell us if the problem is with the extension only (which was my assumption until now) or with getting data from the agent to SUSE Observability

---

**Remco Beckers** (2025-01-29 13:32):
So I'm not interested in the green checkmark on the stackpack (that only shows that some data came in, but could be from one of the other agents), but to see that there really is data like topology and metrics

---

**Rodolfo de Almeida** (2025-01-29 13:50):
According to the customer they can see the metrics for pods and services in the SUSE Observability UI.
The problem is only related to the extension.

This is the customer message confirming it.
```I do see the agent status of the downstream cluster from the suse observability UI and i'm able to monitor pods deployed there.```

---

**Remco Beckers** (2025-01-29 13:51):
That looks ok indeed

---

**Remco Beckers** (2025-01-29 13:51):
So the agent warnings are indeed (as I expected) only warnings

---

**Remco Beckers** (2025-01-29 13:52):
I don't know what @Jeroen van Erp thinks why the extension version matters or what to check based on that.

---

**Rodolfo de Almeida** (2025-01-29 13:59):
I do see in my Rancher that the extension version is 2.0.0 and I am using Rancher 2.10.1, the customer  extension is 1.0.0 and the Rancher version is 2.9.2
Is the extension version related to the Rancher version?

---

**Remco Beckers** (2025-01-29 14:25):
Yes. Rancher had breaking changes for the extensions between versions

---

**Remco Beckers** (2025-01-29 14:25):
So we had to release a new version of the extension for 2.10

---

**Jeroen van Erp** (2025-01-29 14:26):
The 1.0.0 version is compatible with old StackState agent, it only checks the stackstate namespace

---

**Rodolfo de Almeida** (2025-01-29 14:35):
would you think reinstalling the agent and the extension would be a good test to resolve this issue?

---

**Jeroen van Erp** (2025-01-29 14:36):
Only the extension needs to be upgraded. Which repo is the customer pulling it from?

---

**Rodolfo de Almeida** (2025-01-29 14:36):
I am not sure, but I can check with them

---

**Rodolfo de Almeida** (2025-01-29 14:37):
Are there logs from the extension that we can check?

---

**Remco Beckers** (2025-01-29 14:46):
@Anton Ovechkin Can you help us with those extension versions? I thought version 1 was the one for Rancher 2.9

---

**Anton Ovechkin** (2025-01-29 14:52):
we have 3 extension version available
1. `0.x*.x*` supports rancher 2.8
2. `1.x.x` supports rancher 2.9
3. `2.x.x` supports rancher 2.10

---

**David Noland** (2025-01-29 23:19):
We getting quite a few - "My key expires on 2025-01-31, can I get a new key?" requests. Any way to proactively and programmatically address these?

---

**David Noland** (2025-01-29 23:51):
Guess this (https://suse.slack.com/archives/C02AYV7UJSD/p1738154465205899?thread_ts=1738154375.433649&amp;cid=C02AYV7UJSD) means it is being worked on.

---

**Rodolfo de Almeida** (2025-01-31 15:28):
Hi Team,
I am working with the customer Belastingdienst and they are complaining about NTP errors in airgap environment.
The `suse-observability-agent-node-agent`  shows NTP errors because the agent tries to connect to host 0.stackstate.pool.ntp.org (http://0.stackstate.pool.ntp.org) which is blocked in the customer environment.
Is it possible to configure and internal NTP server for SUSE Observability?

---

**Alejandro Acevedo Osorio** (2025-01-31 15:43):
@Louis Parkin do you know if that's possible?

---

**Vladimir Iliakov** (2025-01-31 15:45):
There is no such host
```dig 0.stackstate.pool.ntp.org (http://0.stackstate.pool.ntp.org)

; &lt;&lt;&gt;&gt; DiG 9.10.6 &lt;&lt;&gt;&gt; 0.stackstate.pool.ntp.org (http://0.stackstate.pool.ntp.org)
;; global options: +cmd
;; Got answer:
;; -&gt;&gt;HEADER&lt;&lt;- opcode: QUERY, status: NXDOMAIN, id: 50762
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;0.stackstate.pool.ntp.org.	IN	A

;; AUTHORITY SECTION:
pool.ntp.org (http://pool.ntp.org).		600	IN	SOA	d.ntpns.org (http://d.ntpns.org). hostmaster.pool.ntp.org (http://hostmaster.pool.ntp.org). 1738334615 5400 5400 1209600 3600

;; Query time: 47 msec
;; SERVER: 2001:b88:1002::10#53(2001:b88:1002::10)
;; WHEN: Fri Jan 31 15:44:46 CET 2025
;; MSG SIZE  rcvd: 109```

---

**Vladimir Iliakov** (2025-01-31 15:47):
@Rodolfo de Almeidacan we get a log of the node-agent?

---

**Remco Beckers** (2025-01-31 15:55):
On our node agents we get a log message that it uses the cloud providers ntp servers. For example on AWS
```Using NTP servers from AWS cloud provider: ["169.254.169.123"]```
I guess there could be a fallback that ends up constructing an ntp url like that (`0.stackstate.pool.ntp.org (http://0.stackstate.pool.ntp.org)`)

---

**Rodolfo de Almeida** (2025-01-31 15:56):
I will ask the customer to send the full logs

---

**Rodolfo de Almeida** (2025-01-31 16:02):
In case this an airgap environment and they have a local NTP server, what is the recommendation?

---

**Vladimir Iliakov** (2025-01-31 16:03):
@Remco Beckers yeah it fallbacks to hard-coded ntp hosts, which we overrided

```	defaultHosts := cloudproviders.GetCloudProviderNTPHosts(context.TODO())

	// Default to our domains on pool.ntp.org (http://pool.ntp.org) if no cloud provider detected
	if defaultHosts == nil {
		log.Debug("No cloud provider detected, using default ntp pool.")
		defaultHosts = []string{"0.datadog.pool.ntp.org (http://0.datadog.pool.ntp.org)", "1.datadog.pool.ntp.org (http://1.datadog.pool.ntp.org)", "2.datadog.pool.ntp.org (http://2.datadog.pool.ntp.org)", "3.datadog.pool.ntp.org (http://3.datadog.pool.ntp.org)"}
	}```
I wonder why we haven't got it before.

---

**Vladimir Iliakov** (2025-01-31 16:07):
I don't see how agent can be configured with custom ntp servers, but better ask @Bram Schuur or @Louis Parkin. The log still might be useful.

---

**Remco Beckers** (2025-01-31 16:08):
datadog in our code, but that gets renamed to stackstate when building

---

**Remco Beckers** (2025-01-31 16:10):
It looks like it is configurable as well

---

**Ravan Naidoo** (2025-01-31 16:16):
Hi @Rodolfo de Almeida,

I have written a Monitoring Your SUSE Virtualization Environment (https://github.com/ravan/suse-observability-guides/blob/main/guides/suse/virtualization/metrics/README.md) guide that explains the setup and provides the custom dashboards for SUSE Observability. You and your customers can follow this guide to configure their instance of SUSE Observability.   Attached the metrics you can see for the vert-controller and the virtual machine information you can see for the virt-launcher.

---

**Rodolfo de Almeida** (2025-01-31 16:23):
Hello @Ravan Naidoo
Thanks a lot for sharing that doc.
I will try it and also will share with the customer who requested it.
Is there a way to generate alerts if the Virtual Machine communication reaches some threshold?

---

**Ravan Naidoo** (2025-01-31 16:38):
With regards to creating a threshold monitor for the Virtual Machine, I don’t think that will work without writing a custom monitor function.

For custom charts, we start at the component and use the properties on the component to find the associated metrics (promql).

For monitors, we start with the promql and use the metrcis tags to build up unique identifiers to find the component.
In this case, we can’t create an indetifier for the virt-laucher pod.

Example metric:

```kubevirt_vmi_vcpu_seconds_total{app_kubernetes_io_component="kubevirt",app_kubernetes_io_managed_by="virt-operator",app_kubernetes_io_version="1.2.2-150500.8.21.1",controller_revision_hash="5ff8c7cb84",http_scheme="https",id="0",instance="10.52.2.20:8443",job="harvester-system/kubevirt-metrics",k8s_cluster_name="retail-store",k8s_container_name="virt-handler",k8s_daemonset_name="virt-handler",k8s_namespace_name="harvester-system",k8s_node_name="gr6-1",k8s_pod_name="virt-handler-b6j7r",k8s_pod_start_time="2024-12-09T15:29:47Z",k8s_pod_uid="65377ef1-3588-4ff6-904e-26e583cc20b0",kubernetes_vmi_label_harvesterhci_io_vmName="rhel9-clone",kubernetes_vmi_label_kubevirt_io_nodeName="gr6-1",kubevirt_io="virt-handler",name="rhel9-clone",namespace="default",net_host_name="10.52.2.20",net_host_port="8443",node="gr6-1",pod_template_generation="4",prometheus_kubevirt_io="true",server_address="10.52.2.20",server_port="8443",service_instance_id="10.52.2.20:8443",service_name="kubevirt-metrics",service_namespace="harvester-system",state="running",url_scheme="https"}```

---

**Remco Beckers** (2025-02-03 08:49):
There are no server-side logs, this happens all in the browser

---

**Remco Beckers** (2025-02-03 08:49):
If they're still having issues there are a few things we can still try to check. We can also join a call with them to speed things up if you want @Rodolfo de Almeida?

---

**Remco Beckers** (2025-02-03 08:58):
If they open the Observabillity extension from the Rancher side bar (in the same section as cluster-management), does it say it is connected or not? If it is not connected try updating the configuration and test again.
If it then still doesn't work try uninstalling/reinstalling

---

**Anton Ovechkin** (2025-02-03 09:00):
Thank you for jumping in Remco :bow:
@Daniel Barra let’s follow the thread and jump in the call if it happens

---

**Anton Ovechkin** (2025-02-03 09:01):
there are no yet any logs in the extension besides a few `console.log` statements during installation process in the client web app

---

**Remco Beckers** (2025-02-03 09:01):
If the previous doesn't apply or still doesn't work there is this thing we can check to find out why it is not working:
1. Open the developer extensions of the browser -> network tab. 
2. Now open the cluster dashboard (the one that shows that the cluster is unobserved). 
3. Set the `Filter URLs` at the top of the network tab to filter for `snapshot` 
4. This should reveal a few request that go to SUSE Observability. Are they present? What's the status code? Is there an error message in the response
5. If they are not present:
    a. Set the `Filter URLs` at the top of the network tab to filter for `apps.deployments` instead
    b. Usually a few requests appear, there should be 1 for a URL with the path `/k8s/clusters/<cluster-name>/v1/apps.deployments` with the name of the cluster for this dashboard. It should have a `200` response
    c. open the response by clicking on the request and selecting the `response` tab on the right pane. Filter for `suse-observability-agent`, there should be 2 entries.
Things that can go wrong here:
1. the call to SUSE Observability fails 
2. the status code for `apps.deployments` is not 200, next steps depend on status code (can be permissions)
3. the agent is not in the list of deployments (can be permissions, but could also be if there are 100 entries in the deployment response)

---

**Remco Beckers** (2025-02-03 09:04):
~Oh dang. I'm checking the code and the screenshot again. It looks like I'm on the wrong track now. Before trying all of the above let me first check again~ :facepalm:

---

**Remco Beckers** (2025-02-03 09:10):
Updated above message with the steps to troubleshoot further

---

**Bram Schuur** (2025-02-03 10:21):
Thanks for filing @Rodolfo de Almeida. I filed a ticket for this, because there are quite some things askew here (https://stackstate.atlassian.net/browse/STAC-22332). The good (and bad?) news is that missing the NTP information will not impact the functioning of the platform or the data. The ticket I filed will make us either productize the NTP feature such that it also works airgapped or see it be dropped altogether. (cc @Mark Bakker)

---

**Rodolfo de Almeida** (2025-02-03 13:46):
Hello @Remco Beckers,
First of all thanks for all your messages.
I can confirm that Rancher shows that it is connected to StackState. Please see the attached picture.

---

**Rodolfo de Almeida** (2025-02-03 13:47):
I will have a meeting with this customer in 15 min to check this case

---

**Rodolfo de Almeida** (2025-02-03 13:47):
If you are available to join, it will be really helpfull

---

**Remco Beckers** (2025-02-03 13:48):
I already have meeting planned in 15 minutes :disappointed:

---

**Remco Beckers** (2025-02-03 13:48):
I'd rather not move that, there are quite a few people in it

---

**Rodolfo de Almeida** (2025-02-03 13:49):
ok no problem.
I will try to follow the steps you shared and also was planning to reinstall the agent.

---

**Rodolfo de Almeida** (2025-02-03 13:49):
If nothing works I will try to collect as much as information I can and we can schedule a new meeting another day

---

**Remco Beckers** (2025-02-03 13:56):
I highly doubt re-installing the agent will help (because the data is in SUSE Observability there is not really much that seems broken there), but maybe as a last resort.

Re-installing the extension would maybe be also a good double-check in that case

---

**Rodolfo de Almeida** (2025-02-03 13:58):
The only thing different in this case is that the customer is using a certificate trusted by an internal CA.
To make it work the customer added their internal CA to the Rancher configuration by following this instructions.
https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-references/helm-chart-options#additional-trusted-cas

---

**Rodolfo de Almeida** (2025-02-03 13:59):
Do you believe this is a possible problem?
The extension shows that it is connected, so I am not sure if this is a concern.

---

**Remco Beckers** (2025-02-03 14:00):
I realized that today yeah. If there is an issue it should show up when communicating with SUSE Observability

---

**Jeroen van Erp** (2025-02-03 14:01):
Just checking, I haven’t read back the thread… The old version of the extension will actually not recognize that the suse-observability-agent is deployed but it only the recognizes the stackstate-agent

---

**Anton Ovechkin** (2025-02-03 14:02):
@Rodolfo de Almeida do you mind if I join the call?

---

**Rodolfo de Almeida** (2025-02-03 14:04):
Hello @Anton Ovechkin
Sure... I really appreciate that.
To join the video meeting, click this link: https://meet.google.com/rsy-ptcm-shk

---

**Rodolfo de Almeida** (2025-02-03 14:04):
Here is the link

---

**Anton Ovechkin** (2025-02-03 14:32):
here is the call recap
- rancher 2.9.2 but extension is 0.5.0, upgraded to 1.0.1
- /api/snapshot returns 402 - payment required
- checked the StackState instance and license expired popup shows up

Aparantly the license has expired 31 January 2025, but it’s been communicated that the license will prolong until some time in 2026. @Rodolfo de Almeida is going to check where that process went wrong.
---

Note for SUSE Observability team:
SUSE Obs extension should gracefully handle 402 and show a message inside Rancher UI. FYI @Mark Bakker

---

**Remco Beckers** (2025-02-03 14:33):
That should also pop up in SUSE Observability UI though. So it can't have been the problem that was breaking it last week either

---

**Remco Beckers** (2025-02-03 14:34):
That they were now using version 0.5.0 is problematic indeed. They previously said they were running version 1.x

---

**Anton Ovechkin** (2025-02-03 14:34):
that’s right, but it was also using the old incopatible extension version

---

**Anton Ovechkin** (2025-02-03 14:35):
we’ll iterate further once they got the license fixed

---

**Remco Beckers** (2025-02-03 14:35):
Yeah, maybe it's the combination of the license + the right version that makes it work now :shrug:

---

**Rodolfo de Almeida** (2025-02-03 14:35):
The customer confirmed in an e-mail that they tested both version 0.0.5 and 1.0.0. Today we saw a new version 1.0.1 and that is the one installed now.

---

**Anton Ovechkin** (2025-02-03 14:38):
the 1.0.1 is out there since end of December, so it is likely they didn’t see it

---

**Rodolfo de Almeida** (2025-02-03 14:38):
Yeah I agree

---

**Rodolfo de Almeida** (2025-02-03 14:40):
It looks like the customer Rancher Prime license also expired on Jan 31st and this is why they don't have a new Observability License

---

**Rodolfo de Almeida** (2025-02-03 14:51):
Thanks a lot @Anton Ovechkin for joining the call today!

---

**Javier Lagos** (2025-02-04 17:03):
Hello team,
I'm currently working in a customer case Nationwide Mutual Insurance Company (https://suse.lightning.force.com/lightning/r/Case/500Tr00000Sls6UIAR/view?uid=173868047798580848) in which we have seen that when enabling header injection sidecar https://docs.stackstate.com/agent/k8sts-agent-request-tracing#enabling-the-trace-header-injection-sidecar with a default configuration the job that generates the self signed cert fails:

Helm command used to deploy agent with sidecar:
```helm upgrade --install \
--namespace suse-observability \
--create-namespace \
--set-string 'stackstate.apiKey'='XXX' \
--set-string 'stackstate.cluster.name'='local-cluster' \
--set-string 'stackstate.url'='https://observability.138.68.125.46.sslip.io/receiver/stsAgent' \
--set 'global.skipSslValidation=true' \
--set httpHeaderInjectorWebhook.enabled=true \
suse-observability-agent suse-observability/suse-observability-agent```
Here I leave the pod logs from sidecar job that generates cert. It seems that the Common name used to create cert is longer than expected:
```k get pod -n suse-observability suse-observability-agent-header-injector-generate-cert-l8n5w
NAME                                                           READY   STATUS   RESTARTS   AGE
suse-observability-agent-header-injector-generate-cert-l8n5w   0/1     Error    0          4m32s

k logs -n suse-observability suse-observability-agent-header-injector-generate-cert-l8n5w
+ SCRIPTDIR=/scripts
++ mktemp -d
+ DIR=/tmp/tmp.xIpk7zfxHM
+ cd /tmp/tmp.xIpk7zfxHM
+ echo 'Chart enabled, creating secret and webhook'
Chart enabled, creating secret and webhook
+ openssl genrsa -out ca.key 2048
+ openssl req -x509 -new -nodes -key ca.key -subj /CN=suse-observability-agent-http-header-injector.suse-observability.svc -days 10000 -out ca.crt
40B77BCC437F0000:error:06800097:asn1 encoding routines:ASN1_mbstring_ncopy:string too long:../crypto/asn1/a_mbstr.c:106:maxsize=64
req: Error adding subject name attribute "/CN=suse-observability-agent-http-header-injector.suse-observability.svc"```
The customer has commented to me in the case that they have switched the cert creation to cert-manager instead of using default self-signed cert successfully. However, they would like to have this fixed in future releases. I have already reproduced customer issue which makes me think that this is a bug.

Therefore, Can someone please help me with this topic?

Thanks in advance!

---

**Rodolfo de Almeida** (2025-02-04 17:44):
Hello Team,
The same customer mentioned above (Nationwide Mutual Insurance Company (https://suse.lightning.force.com/lightning/r/Case/500Tr00000Sls6UIAR/view?uid=173868047798580848)) raised another case asking about the `httpHeaderInjectorWebhook` and its dependency on privileged resources, specifically `NET_ADMIN` and `NET_RAW`. Their Pod Security Admission (PSA) policies are blocking pods that require header injection due to these capabilities.
The customer needs a solution that avoids the use of `NET_ADMIN` and `NET_RAW` for the application containers. They are asking if there is any work being done to not require this kind of privileged containers as these capabilities should not be used for most containers.

---

**Bram Schuur** (2025-02-05 09:17):
Thanks for reporting @Javier Lagos, and good to hear you wroked around this by using your own certificate. I made a ticket and put it on our backlog for the bug you found: https://stackstate.atlassian.net/browse/STAC-22342

---

**Bram Schuur** (2025-02-05 09:21):
Heyhey, for the header injector we currently cannot do without the permissions you describe, there are other options though to get the request headers in:
• By modifying an existing proxy: https://docs.stackstate.com/agent/k8sts-agent-request-tracing#add-the-trace-header-id-to-an-existing-proxy 
• Or changing the actual application: https://docs.stackstate.com/agent/k8sts-agent-request-tracing#add-the-trace-header-id-to-an-existing-proxy 
We have ideas to make the header injection without the permissions you mentioned, but using eBPF, those plans are on the long-term roadmap however, so at this point there is no timeframe we can commit to. @Mark Bakker feel free to weigh in on this

---

**Javier Lagos** (2025-02-05 09:22):
Thanks @Bram Schuur for creating the ticket and put it on your backlog. I will check the ticket from time to time to see when this issue is expected to be fixed.

---

**Javier Lagos** (2025-02-05 10:03):
Hello team, I have another case in which I have been working Dienst ICT Uitvoering (https://suse.lightning.force.com/lightning/r/Case/500Tr00000SlgyMIAR/view) where the customer is trying to send notifications from Suse Observability to Mattermost by setting up a webhook configuration in the Suse Observability UI -&gt; https://docs.stackstate.com/monitors-and-alerts/notifications/channels/webhook

Unfortunately, The customer and me have not been able to make it work as it seems that Mattermost expects the field "text: &lt;message&gt;" in the json loaded which is not present in the json generated by Suse Observability. Here is the documentation from Mattermost about the expected json. https://developers.mattermost.com/integrate/webhooks/incoming/#use-an-incoming-webhook.

So far, based on all the tests I have done, the only customization we can make in our Json sent is to add Key/Value pairs at the metadata section which in customer's case seems to be not enough. We have already tested to add in the metadata the key/value pair "text=test-message" but it didn't work either since the Key/value pairs are added at the metadata section and not as a field.

When we try to configure the WebHook in the Suse Observability UI we can see the following error in the Mattermost logs showing that there is no text field specified.
```{"timestamp":"2025-02-04 15:42:06.314 Z","level":"debug","msg":"No text specified.","caller":"web/context.go:120","path":"/hooks/jmfuki7fci83d83mnwydfykjfr","request_id":"nwwoh3ba5pb1fpn4zyknq5mwua","ip_addr":"192.168.5.241","user_id":"","method":"POST","err_where":"HandleIncomingWebhook","http_code":400,"error":"HandleIncomingWebhook: No text specified."}```
On the other hand, If we execute the following command within the Suse Observability server pod the notification is received correctly by Mattermost which rules out possible network problems.
```curl -i -k -X POST -H 'Content-Type: application/json' -d '{"text": "Test message"}' https://rocket-dev.dictu.intern/hooks/jmfuki7fci83d83mnwydfykjfr```
Therefore, I have a couple of questions that I need your help with

1. Do we have a workaround to make this integration work? Is this integration supported?
2. If not, Can we expect to have this integration enabled and supported on future releases? 
Thanks in advance!

---

**Remco Beckers** (2025-02-05 10:09):
Hi, the idea behind the generic webhook is that you write a little bit of glue-code that you run as a small pod, process or a Lambda function. It can take the payload provided by SUSE Observability and convert it into the required format for the third-party app, Mattermost in this case.

There is a small Python example in the docs (https://docs.stackstate.com/monitors-and-alerts/notifications/channels/webhook#example-webhook) that can be used as a starting point, instead of printing the output you'd make a HTTP call to Mattermost.

---

**Remco Beckers** (2025-02-05 10:11):
There is no first-class support for Mattermost in SUSE Observability and I'm not sure it is on our roadmap.

Maybe @Mark Bakker can clarify that.

---

**Javier Lagos** (2025-02-05 11:11):
Thanks @Remco Beckers for the clarification.

---

**Mark Bakker** (2025-02-05 11:29):
@Javier Lagos mattermost is not yet on the roadmap, I would indeed take the suggestion from @Remco Beckers and also would love to see a blog if you can make that about the integration. Would good to publish to Rancher Blogs, @Andreas Prins can guide that

---

**Rodolfo de Almeida** (2025-02-05 14:04):
Hello @Bram Schuur
Thanks for your quick answer.
The links you shared points to the same Jira, is that correct?

---

**Bram Schuur** (2025-02-05 14:52):
Whoops i pasted the wrong links, i updated the message with the proper links to the docs

---

**Remco Beckers** (2025-02-07 08:18):
The webhook notification expect a 200 or  202 status code as the response, so it is correct that you see an error.
It seems like a good idea to extend this to support all 2xx status codes, because 204 seems also completely valid.

---

**Remco Beckers** (2025-02-07 08:20):
I do wonder if this would work even if the status code would be accepted. SUSE Observability sends the data in a JSON format that is not tailored to Netcool, unless Netcool has a way to accept any format and transform them that would result in a parse failure as well.

---

**Remco Beckers** (2025-02-07 08:20):
See my message from Wednesday here (https://suse.slack.com/archives/C07CF9770R3/p1738746565343299?thread_ts=1738746232.337879&amp;cid=C07CF9770R3) on how we expect the webhook notification is used

---

**Bram Schuur** (2025-02-07 09:09):
@Remco Beckers I would say we file a bug for this, we should indeed accept 204 as a response

---

**Remco Beckers** (2025-02-07 09:13):
Yeah, I was doing that

---

**Amol Kharche** (2025-02-07 11:48):
I am not in call with customer, Do we have any temporary workaround to accept 204 ?

---

**Remco Beckers** (2025-02-07 11:49):
The only way is to implement an intermediate process that translates the status code. But you might need that anyway to translate the payload as well

---

**Remco Beckers** (2025-02-07 11:49):
(see my second remark above)

---

**Amol Kharche** (2025-02-07 11:51):
Customer confirmed Netcool prefer to accept data in JSON format.

---

**Remco Beckers** (2025-02-07 11:51):
I understand, but maybe they want it in a very specific format (usually they do).

---

**Amol Kharche** (2025-02-07 12:31):
Customer agreed to check from Netcool side.

---

**Louis Lotter** (2025-02-10 11:10):
@Louis Parkin

---

**Louis Parkin** (2025-02-10 11:44):
@Amol Kharche this is a super low resolution screenshot, I'm not able to make out much of what is going on there.  Could you perhaps source a better quality one, or a text dump of what the image is about?

---

**Louis Parkin** (2025-02-10 11:45):
My message was in relation to the first screenshot

---

**Louis Parkin** (2025-02-10 11:45):
Not the ones you posted virtually at the same time I sent my message

---

**Amol Kharche** (2025-02-10 11:47):
I got it, I have asked support logs and they will upload soon, these screenshot taken during call.
Do we need any other additional logs apart from suse observability namespace?

---

**Louis Parkin** (2025-02-10 11:51):
@Amol Kharche from the kubelet log, I assess the following: `It would appear to me that the kubelet is trying to call xfs_growfs, and it is unable to find the binary.  Given that, would it not imply that xfs_growfs should be installed or the PATH variable updated?`
LLM output based on my assumption:
```Your assessment is correct; the warning from Kubelet suggests that it is attempting to call `xfs_growfs` but is unable to locate the binary. Given this, there are a few areas you can investigate to resolve the issue:

1. **Confirm Installation**: Although you mentioned that `xfsprogs` is installed and `xfs_growfs` resides in `/usr/sbin`, double-check that this binary is present on all nodes in the cluster. Running `which xfs_growfs` or checking the output of `echo $PATH` in a similar environment to where Kubelet operates could help verify this.

2. **Ensure PATH Configuration**: The environment variables, including `$PATH`, might differ for system services like Kubelet compared to an interactive shell. You could check this by verifying how Kubelet is configured to start. If it uses systemd, review the service unit file (typically found in `/etc/systemd/system/kubelet.service`) and confirm if it correctly references `/usr/sbin` in its `Environment` or PATH settings.

3. **System Permissions**: Validate that the Kubelet user (often `root`) has the necessary permissions to execute binaries in `/usr/sbin`. It could also be useful to check if there are any specific access controls (like AppArmor or SELinux) that might be interfering with execution.

4. **Unexpected PATH Modification**: There may be scripts or configurations that temporarily modify the `$PATH` for tasks associated with Kubelet. Check for any potential overrides or changes that could be stripping `/usr/sbin` from the PATH.

5. **Systemd Environment File**: If running on a systemd-based environment, you can define or modify the environment file referenced by the Kubelet service to explicitly add `/usr/sbin` to the PATH. You can specify within the `[Service]` section of the unit file:
   ```ini
   [Service]
   Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
   ```

After making any changes, make sure to restart the Kubelet service to apply the updates:
```bash
systemctl daemon-reload
systemctl restart kubelet
```

By addressing these areas, you can help Kubelet locate and execute `xfs_growfs` as needed, potentially resolving the warning even if no explicit volume expansion operations are currently planned.```

---

**Louis Parkin** (2025-02-10 11:52):
I will also dig a bit more once I have the logs you mentioned.

---

**Amol Kharche** (2025-02-10 11:55):
In the screenshot `Screenshot from 2025-02-10 15-18-28` you can see that path is exported. $PATH on all nodes.

---

**Vladimir Iliakov** (2025-02-10 12:08):
The warnings are inevitable due to Kubernetes reconciliation nature. So far there is nothing to fix.

---

**Vladimir Iliakov** (2025-02-10 12:11):
We can probably try to reproduce the issue with using the environment similar to the Customer's and find the reason, and may be get rid of this particular warning, but it won't have any real value, except of course, we will have fun while investigating...

---

**Amol Kharche** (2025-02-10 12:27):
Customer just now confirmed that they have other pods in other namespace that uses the block storage and those as well throw the exact same exception.
I will ask customer to discuss with storage class vendor.
Thanks for your support...

---

**Louis Lotter** (2025-02-10 13:09):
@Vladimir Iliakov @Louis Parkin @Amol Kharche thanks for digging into this so effectively.

---

**Rodolfo de Almeida** (2025-02-10 18:36):
Hi team,
I have a case from the customer Corning Inc, where they sent a log message like below.
```java.lang.RuntimeException: Script runner errors executing function. Script threw exception: com.stackvista.graph.common.MaxLoadedElementsException: Maximum amount of loaded components exceeded the requested limit of 1000```
What does it means?
Is this related to the amount of objects monitored?

---

**Rodolfo de Almeida** (2025-02-10 19:06):
@Remco Beckers I found this https://stackstate.atlassian.net/issues/STAC-22148?jql=textfields%20~%20%22Maximum%20amou[…]%20components%20exceeded%20the%20requested%20limit%2A%22 (https://stackstate.atlassian.net/issues/STAC-22148?jql=textfields%20~%20%22Maximum%20amount%20of%20loaded%20components%20exceeded%20the%20requested%20limit%2A%22)

---

**Rodolfo de Almeida** (2025-02-10 19:07):
But it looks like there is not fix yet for this issue.
Have you go any recommendations to address this issue?

---

**Frank van Lankvelt** (2025-02-10 21:31):
This is probably a monitor that indeed matches too many components.  Maybe you can find that?

---

**Rodolfo de Almeida** (2025-02-10 21:32):
Hello @Frank van Lankvelt that is correct.
```2025-02-10 13:31:04,469 ERROR com.stackstate.monitors.service.MonitorRunnerImpl - Monitor runner[name: Aggregated health state of a Namespace, id: 179984887462876] crashed due to com.stackstate.monitors.domain.script.MonitorFunctionExecutionError: Script runner errors executing function. Script threw exception: com.stackvista.graph.common.MaxLoadedElementsException: Maximum amount of loaded components exceeded the requested limit of 1000```

---

**Rodolfo de Almeida** (2025-02-10 21:33):
The monitor name is `Aggregated health state of a Namespace` .
How ca we fix it?

---

**Frank van Lankvelt** (2025-02-10 22:09):
I think going for a bigger profile will bump the component limits, I think otherwise the best thing to do is to disable the monitor

---

**Rodolfo de Almeida** (2025-02-10 22:12):
They have tried to run the `helm upgrade --install` from 20 non-HA to 50 non-HA, but it did not resolve the problem. So the current size is 50 non-HA.
I will check in my lab how to disable it and then guide the customer through it.

---

**Rodolfo de Almeida** (2025-02-11 01:11):
I am still waiting for the customer response. I am not sure if they still have access to the UI or CLI.
I suggested to disable the monitor and as the workaround suggested in the JIra, to remove the  configmap from monitoring and check if the issue will happen again.

---

**Frank van Lankvelt** (2025-02-11 07:52):
If you keep it below 10000 then I think it should be fine.  I haven't seen higher values, but @Bram Schuur or @Alejandro Acevedo Osorio are the experts here

---

**Bram Schuur** (2025-02-11 08:48):
10000 is a bit high for a non-ha instance, but i think the setting is now too restrictive for the 50/100 sizes. The real solution would be the ticket you found (https://stackstate.atlassian.net/issues/STAC-22148?jql=textfields%20~%20%22Maximum%20amou[…]%20components%20exceeded%20the%20requested%20limit%2A%22 (https://stackstate.atlassian.net/issues/STAC-22148?jql=textfields%20~%20%22Maximum%20amount%20of%20loaded%20components%20exceeded%20the%20requested%20limit%2A%22)), I also filed a smaller ticket to tweak those values in our 50/100 profiles https://stackstate.atlassian.net/browse/STAC-22372.

Be advised tweaking these values yourself can cause the system to become unstable (memory pressure etc). If 1500 works for you now you can use that as a temporary solution until we solved one of those tickets

---

**Rodolfo de Almeida** (2025-02-11 15:29):
Thanks @Amol Kharche @Frank van Lankvelt  @Bram Schuur
I am working with the customer to increase the variable `CONFIG_FORCE_stackstate_topologyQueryService_maxStackElementsPerQuery`  slowly to not cause any other problems to their environment.

In my recommendation I asked the customer to add that variable to the `sizing_values.yaml` file and run the `helm upgrade --install ...`  again.
```server:
  extraEnv:
    open: CONFIG_FORCE_stackstate_topologyQueryService_maxStackElementsPerQuery: "1200"```

---

**Rodolfo de Almeida** (2025-02-14 15:08):
Hello everyone,
I am working with Corning Inc to install SUSE Observablility in on-premise environment. This is their production environment and they are asking if there are any storage recommendations for deploying an HA instance. Are there any recommendations related to disks (nvme, ssd), IOPS, Bandwidth?

---

**Vladimir Iliakov** (2025-02-14 15:23):
I am not sure we have performance recommendations for the storage. We use AWS EBS (gp3) block storage volumes with 3000iops and 125MB/s of throughput and it seems to be enough for our scale...

---

**Louis Lotter** (2025-02-17 10:40):
@Hugo de Vries

---

**Hugo de Vries** (2025-02-17 11:00):
Hi folks, I have 2 tickets that NN is chasing me on for a reply, can someone have a look?
1. *Open for 1 week: https://stackstate.zendesk.com/agent/tickets/1474*
2. Created January 9th, no reply from us yet: https://stackstate.zendesk.com/agent/tickets/1466

---

**Remco Beckers** (2025-02-17 12:06):
I answered the old one from 9th of January.

For the other one I am not sure, I think @Bram Schuur and @Alejandro Acevedo Osoriowere looking into a related ticket already with them.

The question in the ticket for completeness:
> Currently the existing Monitor Functions do not show their source code.
> We have been able to make the aggregation monitor work, but only by making a monitor for each item we want to attach it to. This is not ideal for various reasons.
> 
> For this reason we would prefer to write a custom monitor function.
> Documentation on this is currently lacking.
> 
> Could we receive examples on how monitor functions should be written?
> Preferably the actual current Aggregation Monitor, as it seems close to what we want to do.

---

**Hugo de Vries** (2025-02-17 12:10):
I think it would be good to have a design / feedback session on our solution that replaced health propagation. Both NN and Rabobank are struggling with our new health aggregation monitors. The need scripts to generate the monitors for all components and performance is bad. 5+ minutes of latency for all the layers to adjust their state.

---

**Remco Beckers** (2025-02-17 12:11):
That's exactly what Bram and Alex would be looking into, Mark shared a query they did that was doing `withNeighboursOf` up to 15 levels in both directions. There is no way that will ever be performant

---

**Hugo de Vries** (2025-02-17 12:20):
Ah yeah that explains some performance impact. We have some steps to make here to deliver improved functionality over the deprecated propagated state, it's more of a janky workaround at the moment and it's key to their No. 1 use case; chain monitoring. @Alejandro Acevedo Osorio @Bram Schuur both Dirkjan from Rabo and Erik / Yolan from NN would be open to a feedback / design session, let me know if you need me to coordinate.

---

**Bram Schuur** (2025-02-17 12:41):
@Hugo de Vries would be great if you set this up with both customers, we'll take a look at the use cases and what we can do there.

---

**Hugo de Vries** (2025-02-17 12:51):
Great, will do!

---

**Ankush Mistry** (2025-02-19 08:18):
Hello Team,
I am working with LIEBHERR-IT SERVICES GMBH on a case where the customer wants an OIDC group iD to be added to a custom role/scope, whereas in the docs (https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_roles#custom-roles-with-custom-scopes-and-permissions-via-the-configuration-file) it only shows with the predefined roles. How to configure this with the OIDC group ID?

---

**Remco Beckers** (2025-02-19 09:51):
The matching between oidc group and role is based on the role name in the configuration. So in the example you linked the role name is `development-troubleshooter` which matches an OIDC group with the same name.

If you want to assign the same set of permissions to multiple OIDC groups the only way to do that right now is to copy the custom role in the configuration, making a copy for every Group

---

**Ankush Mistry** (2025-02-19 10:02):
Thank you!

---

**Hugo de Vries** (2025-02-19 13:05):
I've proposed this session to NN and Rabobank, stay tuned,

---

**Hugo de Vries** (2025-02-19 13:07):
Rabobank team reported that most links to documentation are dead. Most of them are located in the settings menu, but also on the playground you can see the link from the timeline tooltip is dead:
https://play.stackstate.com/#/components/urn:opentelemetry:namespace%2Fdefault:service%[…]tachedFilters=namespace%3Aotel-demo&timeRange=LAST_6_HOURS (https://play.stackstate.com/#/components/urn:opentelemetry:namespace%2Fdefault:service%2Fmr-greens-survival-in-the-conservatory?detachedFilters=namespace%3Aotel-demo&timeRange=LAST_6_HOURS)

---

**Louis Lotter** (2025-02-19 13:07):
@Anton Ovechkin

---

**Louis Lotter** (2025-02-19 13:10):
@Mark Bakker Anton thinks this may be an issue is Short.io (http://Short.io). Who manages short.io (http://short.io) and the links in there ?

---

**Mark Bakker** (2025-02-19 15:09):
@Louis Lotter I was under the impression the engineering team, but now I wonder...

---

**Louis Lotter** (2025-02-19 16:00):
Anton does not know. I've never touched it :shrug:.

---

**Louis Lotter** (2025-02-19 16:00):
Let me ask

---

**Anton Ovechkin** (2025-02-19 16:02):
when I came to stackstate we had technical writer who was creating those links on our request
I have no idea how we handle it atm

---

**Hugo de Vries** (2025-02-21 13:13):
Bosch has deployed Observability air gapped but is getting an error when loading the UI. Sometimes the webuiconfig call results in a 404, other times it gets a 200 OK. All pods are running without errors or restarts. BaseURL has been validated, TLS certificate is valid. Using a proxy or ingress to the router service gives the same result. Any clues where to look next?

---

**Louis Lotter** (2025-02-21 13:21):
@Anton Ovechkin can you tell something from this error ?

---

**Anton Ovechkin** (2025-02-21 13:26):
only the fact that it cannot be found
it’s not 5** status so the server is up

we do not send any payload with the request, but we attach CSRF token from cookies to all request headers, so maybe some cookie issue?

---

**Remco Beckers** (2025-02-21 13:29):
That should result in a `403 Forbidden` error

---

**Remco Beckers** (2025-02-21 13:30):
It looks as if they are accessing SUSE Observability through the rancher proxy though. That could cause a whole lot of shenanigans.

I tried that before and it doesn't work because the StackState UI doesn't understand the proxied URL and tries to access `/api` on Rancher

---

**Remco Beckers** (2025-02-21 13:31):
Can they try to access it directly on its own URL, at least not proxied through Rancher?

---

**Remco Beckers** (2025-02-21 13:34):
I've checked just now and the error response is the error response format of Rancher. So this request never reaches the StackState api but directly hits Rancher. If you look at the URL for the request that shows this error you probably see something like this:

```https://rb-dcs.../api/server/webuiconfig```
But it should be
```https://rb-dcs.../k8s/cluster/c-m-qmc4k../api/v1/namespaces/suse-observability/http:suse-observability-router:8080/proxy/api/server/webuiconfig```

---

**Remco Beckers** (2025-02-21 13:35):
The only fix at the moment is to use a direct URL for SUSE Observability (or a proxy that doesn't rewrite the entire URL)

---

**Hugo de Vries** (2025-02-21 13:47):
Great, thank you. I'll relay it to the Bosch team

---

**Amol Kharche** (2025-02-21 14:26):
Looking from the screenshot it looks like customer trying to access Observability through Rancher-&gt; service Discovery- &gt; suse-observability-router.
I believed It won't work like that if you have too many redirect URLs, You can curl the service from a pod but cannot do it from outside.
Can you paste the same result from Rancher-&gt; service Discovery- &gt; Ingresses -&gt; SO URL?

---

**Hugo de Vries** (2025-02-21 14:28):
Both NN and Rabo team are open to do this together. I will suggest our office as the location and send out a few timeslots to them with an agenda. How much time shall I allocate? 2 to 3 hours? I’d like them both to share their experience and demo it on their environemnt. Then brainstorm on possible solutions and vote on priority on items that come out of it? Open to your suggestions on structuring such a session

---

**Hugo de Vries** (2025-02-21 14:35):
Thanks Amol, I’ll ask them.

---

**Hugo de Vries** (2025-02-21 14:38):
They tried with ingress and now get this:

---

**Remco Beckers** (2025-02-21 14:39):
That URL in the browser still shows that they are proxying through Rancher

---

**Hugo de Vries** (2025-02-21 14:39):
The proxy in the url suspicious right?

---

**Hugo de Vries** (2025-02-21 14:40):
Ah yes @Remco Beckers

---

**Bram Schuur** (2025-02-21 14:56):
nice! Yeah would be great to do this in-person. I agree with your agenda, including a brainstorm (for solutions), but i think we'll not be on the spot be able to prioritize those. We can prioritize problems but not solutions there i think.

After the demo we should include a question round to get in-depth with the use-case before brainstorming i think.

---

**Alejandro Acevedo Osorio** (2025-02-21 14:57):
Indeed as it sounded like they were trying to "port" use-cases from `5.1` (Propagation) that are trickier on the new setup

---

**Bram Schuur** (2025-02-24 08:25):
Would be great to organise this on a Wednesday when we are in office.

---

**Devendra Kulkarni** (2025-02-24 12:21):
Hello Team,
I was trying to setup SUSE Observability and tweaked admin password using externalsecrets as per - https://docs.stackstate.com/self-hosted-setup/security/external-secrets#getting-authentication-data-from-an-external-secret but upon `helm upgrade` the server pod does not come up and is stuck in `CreateContainerConfigError` and below is the output of describe pod:

```Events:
  Type     Reason     Age                 From               Message
  ----     ------     ----                ----               -------
  Normal   Scheduled  4m32s               default-scheduler  Successfully assigned suse-observability/suse-observability-server-54b8cf4d77-gvtms to devendra-tf-k8s-worker-pool-apsoy
  Normal   Pulling    4m32s               kubelet            Pulling image "registry.rancher.com/suse-observability/stackpacks:20250122132516-master-7fe7386-prime-selfhosted"
  Normal   Pulled     4m29s               kubelet            Successfully pulled image "registry.rancher.com/suse-observability/stackpacks:20250122132516-master-7fe7386-prime-selfhosted" in 3.187s (3.187s including waiting). Image size: 6433037 bytes.
  Normal   Created    4m29s               kubelet            Created container init-stackpacks
  Normal   Started    4m29s               kubelet            Started container init-stackpacks
  Normal   Pulled     4m28s               kubelet            Container image "registry.rancher.com/suse-observability/wait:1.0.11-04b49abf" already present on machine
  Normal   Created    4m28s               kubelet            Created container server-init
  Normal   Started    4m28s               kubelet            Started container server-init
  Normal   Pulling    3m11s               kubelet            Pulling image "registry.rancher.com/suse-observability/container-tools:1.5.1"
  Normal   Pulled     2m19s               kubelet            Successfully pulled image "registry.rancher.com/suse-observability/container-tools:1.5.1" in 52.193s (52.193s including waiting). Image size: 1056323341 bytes.
  Normal   Created    2m19s               kubelet            Created container ensure-no-server-statefulset-pods-are-running
  Normal   Started    2m19s               kubelet            Started container ensure-no-server-statefulset-pods-are-running
  Normal   Pulling    2m16s               kubelet            Pulling image "registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250124171607-master-8a3bd61-2.5"
  Normal   Pulled     2m6s                kubelet            Successfully pulled image "registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250124171607-master-8a3bd61-2.5" in 10.077s (10.077s including waiting). Image size: 624392598 bytes.
  Warning  Failed     66s (x6 over 2m6s)  kubelet            Error: secret "suse-observability-license" not found
  Normal   Pulled     54s (x6 over 115s)  kubelet            Container image "registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250124171607-master-8a3bd61-2.5" already present on machine```
Observations:

[1] The error in the event seems vague as it is pointing to `suse-observability-license`  secret not found. Upon checking it seems this secret is deleted causing issues.
[2] Login does not work either with the new password

Command to upgrade:
```# helm upgrade --install --namespace suse-observability --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml --set 'stackstate.authentication.fromExternalSecret'='my-custom-auth-secret' suse-observability suse-observability/suse-observability```

---

**Bram Schuur** (2025-02-24 18:52):
Thanks for reporting, I will investigate this first thing in the morning

---

**Amol Kharche** (2025-02-25 08:00):
I encountered the same error as well. We're using an external secret, and for the backend, we utilize Vault to store the secret.

---

**Devendra Kulkarni** (2025-02-25 08:31):
@Remco Beckers @Bram Schuur I just submitted a PR for correcting a typo in the documentation - https://github.com/StackVista/stackstate-docs/pull/1584
Can you have a look and review it?

---

**Rajesh Kumar** (2025-02-25 08:36):
https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/templates/secret-license-key.yaml#L8 This should be  `.Values.stackstate.license.fromExternalSecret`

---

**Bram Schuur** (2025-02-25 08:37):
Thanks yeah:+1:, i just found it aswell, I am making a fix as we speak.

---

**Bram Schuur** (2025-02-25 08:39):
I filed this ticket that can be used to track resolution/release of the fix: https://stackstate.atlassian.net/browse/STAC-22411

---

**Rajesh Kumar** (2025-02-25 08:40):
The workaround is to delete and recreate the secret named `suse-observability-auth`  through the external-secrets.

---

**Bram Schuur** (2025-02-25 08:49):
thanks! we require our commits to be signed, could you setup commit signing and resubmit? (If that is too much of a hassle for a typo i'll cherry-pick it, might be useful for you to setup commit siging anyway)

---

**Bram Schuur** (2025-02-25 08:50):
https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits

---

**Devendra Kulkarni** (2025-02-25 11:45):
@Bram Schuur Can you now review the PR? I just resubmitted after adding gPG key and verifying the commit

---

**Bram Schuur** (2025-02-25 11:47):
weridly engough it still says the commit is unverified

---

**Devendra Kulkarni** (2025-02-25 11:47):
:thinking_face: Let me check again

---

**Devendra Kulkarni** (2025-02-25 11:57):
I see my github uses SUSE email address as well as my personal email address.. now I fixed it

---

**Devendra Kulkarni** (2025-02-25 11:57):
should I resubmit?

---

**Devendra Kulkarni** (2025-02-25 13:01):
Now commit is verified!

---

**Bram Schuur** (2025-02-25 13:02):
merged, thanks a bunch:+1:

---

**Garrick Tam** (2025-02-28 00:13):
Hello All.   I have a customer case reporting the same issue as https://stackstate.atlassian.net/browse/STAC-21878.  The customer tried the suggested workaround by setting CONFIG_FORCE_stackstate_topologyQueryService_maxStackElementsPerQuery to a higher value.  However; they need to raise the value to 2500 before STS stops crashing.  Should I tied https://stackstate.atlassian.net/browse/STAC-21878 to the customer case and add the observations to it or should I open a new STAC ticket.  I seem to also remember reading some where we shouldn't open STAC tickets for all customer issues.  Please advise.

---

**Remco Beckers** (2025-02-28 08:05):
The STAC-21878 ticket is not about Unknown vs Clear states for the topology aggregator monitor.
There is no mention of anything crashing and increasing the maxStackElementsPerQuery will not help for that issue.

There is the possiblity that the aggregator monitor hits the query limit as well indeed (but that's not in that ticket), which would cause the monitor to fail/crash. Increasing the limit would work for that situation.

Can you clarify if that's indeed the problem? And maybe also what is crashing (which pod if it is a pod) and what profile the customer is using.

---

**Garrick Tam** (2025-02-28 18:23):
Your question regarding the profile in use is an interesting one as I didn't question that believing the 1000 limit is hard set regardless of profile in use.  Are you saying this limit is not the same across different profiles?

---

**Remco Beckers** (2025-03-03 08:15):
Aha ok. I see, no application crashed just the monitor itself. We do have a ticket for that one as well, it is https://stackstate.atlassian.net/browse/STAC-22148. The work-around is to increase the limit indeed like you already did.

---

**Remco Beckers** (2025-03-03 08:20):
The small non-ha profiles (up to, including, 50-nonha) have a limit of 1000, the bigger profiles use a limit of 10000 (10x as big). The limit mainly exists to ensure that services don't go out of memory and produce relatively fast responses.

---

**Remco Beckers** (2025-03-03 08:21):
You can link the 22148 Jira ticket, but I don't think we can see that in our Jira. Can you share the customer name so I can put it as a reference on the ticket (it helps prioritizing)

---

**Remco Beckers** (2025-03-03 09:58):
@Mark Bakker I've moved the ticket 22148 higher up the backlog

---

**Hugo de Vries** (2025-03-03 14:55):
Edeka is rolling out SUSE Observability. The server is deployed on a cluster, the agent is rolled out on the same cluster and on one additional cluster, but stackpack page stays stuck on Waiting for data for both clusters.
• The agents are deployed with `nodeAgent.skipKubeletTLSVerify'=true` and `--set-string 'global.skipSslValidation'=true`
• The agents deploy without errors. 
• The node agent logs also show "successful sent payload" messages, no strange errors. 
• Cluster names in rancher match with the cluster names in the agent deployment
• CURL from node agent pod shell to /receiver/Stsagent URL is succesfull
• Checked URL/api/topic and also see the agent payloads in those topics like Sts process agent topology.

---

**Hugo de Vries** (2025-03-03 14:57):
Where to look next?

---

**Louis Lotter** (2025-03-03 15:13):
@Lukasz Marchewka hi can you help out here ?

---

**Lukasz Marchewka** (2025-03-03 15:15):
@Hugo de Vries can you fetch logs from `receiver` pods ?

---

**Garrick Tam** (2025-03-03 22:25):
I commented to the Jira with customer name (DR Horton) using 50 node non-ha profile.

---

**Garrick Tam** (2025-03-03 22:26):
Any timeline or targeted version I can share with the customer on the expected fix?

---

**Hugo de Vries** (2025-03-04 08:19):
Uli got it working by adding a skipSSL setting for every agent (node, cluster and log) like this:
helm upgrade --install \

--namespace suse-observability \

--create-namespace \

--set-string 'stackstate.apiKey'='xxx' \

--set-string 'stackstate.cluster.name'='k8srzsprod03' \

--set-string 'stackstate.url'='https://observ.rs.edeka.net/receiver/stsAgent (https://observ.rs.edeka.net/receiver/stsAgent)' \

--set 'nodeAgent.skipSslValidation'=true \

--set 'clusterAgent.skipSslValidation'=true \

--set 'checksAgent.skipSslValidation'=true \

suse-observability-agent suse-observability/suse-observability-agent

---

**Hugo de Vries** (2025-03-04 13:26):
What is the name of the permission for the Metric Explorer? I don’t see that one mentioned in our RBAC docs, I think the last update to those docs was before we released the Metric explorer. Bosch is configuring RBAC and wants to limit access to a cluster per custom role.

---

**Mark Bakker** (2025-03-04 16:38):
Limiting access to a cluster per custom role is not yet available that's currently being build

---

**Hugo de Vries** (2025-03-05 09:49):
Question from Accenture NL:

I'm Mohamed Bejja, working for Team Red at Accenture. We use your product *SUSE Observability*, and at the moment, we are experiencing an issue with the *suse-observability-agent*.
Hopefully, you can help us or point us to someone who can.
We conducted an investigation and concluded the following:

*Issue Summary*
We see that all pods for the suse-observability-agent-node-agent DaemonSet are regularly restarting unexpectedly across all clusters.

*Root Cause*
• This was triggered by a change in the *checksum/secret annotation* within the DaemonSet spec:
_checksum/secret: ab3ea389b5831836765b7114778de05099ead5b3a7de1f9c06c211b1830f325b_
• As a result, *Kubernetes automatically rolled out all DaemonSet pods*.
*Impact*
• The new Secret appears to contain incorrect values, leading to liveness and readiness probe failures on the agent pods:
    ◦ *Liveness Probe Failed:* HTTP probe failed with status code 500
    ◦ *Readiness Probe Failed:* HTTP probe failed with status code 500
    ◦ *Connection Refused Errors:* dial tcp 10.213.2.10:5555 (http://10.213.2.10:5555/): connect: connection refused
• The repeated restarts trigger the notification:
• _"Topicus - NN - P1 - No Replica’s - App"_
• which monitors desired replicas, including DaemonSet replicas.
• We see this happening on all clusters.
*Request for Clarification*
• Was this change intentional, or is there an issue with suse-observability-agent?
• If intentional, could you confirm what modifications were made to the Secret?
• If unintentional, can we work together to identify the root cause and resolve the issue?
Looking forward to your response.

---

**Hugo de Vries** (2025-03-05 09:51):
Yeah so that is why Bosch is looking into hiding the Metrics Explorer from the main menu. The custom role is using a label with clustername as the filter/scope for now as a workaround, but as you know that does not stop a user from querying metrics from other clusters it does not supposed to have access to.

---

**Mark Bakker** (2025-03-05 09:59):
Indeed, you can tell them we are working on that :slightly_smiling_face:

---

**Jeroen van Erp** (2025-03-05 11:12):
That checksum changes because they rolled out a new secret I think… It’s not something we do, it’s part of the Helm chart. Have them check what they changed when would be my suggestion.

Did they upgrade recently?

---

**Amol Kharche** (2025-03-06 10:08):
Hi Team,
One of our customer ( *Warba Bank (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMTe4AAG/view)* ) reported that the span attributes doesn't show the exception.message and exception.stacktrace, even though the otel collector is capturing these attributes. I have attached a screen shot for your reference. Kindly advise does it required any addition setting to make these attributes visible .
Customer are running three replicas of otel-collector statefulset. Attaching logs from opentelemetry-collector pod as well.
```suse-observability-otel-collector-0                               1/1     Running   0               29d   10.42.4.67    dcuknpsw1    &lt;none&gt;           &lt;none&gt;
suse-observability-otel-collector-1                               1/1     Running   0               29d   10.42.3.220   dcuknpsw0    &lt;none&gt;           &lt;none&gt;
suse-observability-otel-collector-2                               1/1     Running   0               29d   10.42.5.232   dcuknpsw2    &lt;none&gt;           &lt;none&gt;```
In the pod suse-observability-otel-collector-0-1-2 logs we are keep getting.
```2025/03/06 08:28:51 Sending authorization request for ...2VuQ
2025/03/06 08:28:51 Result for ...2VuQ: 204
2025/03/06 08:33:51 Sending authorization request for ...2VuQ
2025/03/06 08:33:51 Result for ...2VuQ: 204```

---

**Remco Beckers** (2025-03-06 10:17):
Those otel collector logs are fine (they're expected info logs)

---

**Remco Beckers** (2025-03-06 10:27):
How are they sure there is an exception that  is added as an attribute to the spans?

In the provided otel collector log I see only 1 occurrence of an exception and that is in a log line.

The span in the screenshot very likely got labeled as an error by the (auto-)instrumentation because it represents an HTTP request that returned a 400 status code. There likely was no exception at all from the looks of the attributes this is on the client side of an http connection which is unlikely to trigger an exception for a 400 status code unless the code making the HTTP call handles the 400 status by throwing an exception. But apparently the calling code simply deals with the 400 status because the trace seems to continue without further errors.

---

**Amol Kharche** (2025-03-06 11:36):
I will confirm with customer.

---

**Louis Lotter** (2025-03-07 08:44):
@Vladimir Iliakov do you have insight here ? I think from these logs it's clear we probably don't support this but has this come up before ? @Mark Bakker @Sheng Yang is this something we should support ?

---

**Vladimir Iliakov** (2025-03-07 08:56):
No, I don't. It has to he investigated what we can do with that...

---

**Mark Bakker** (2025-03-07 09:01):
The ask is can we set these permissions and does everything than stil work:

---

**Mark Bakker** (2025-03-07 09:02):
I would expect this is possible but we don't set it by default. @Remco Beckers and @Vladimir Iliakov do you see any issue in changing these defaults?

---

**Mark Bakker** (2025-03-07 09:03):
Ps the table is an AI summary, so no guarantee its correct but it seems so.

---

**Remco Beckers** (2025-03-07 09:06):
There could be issues indeed. For one the elasticsearch init container needs to have privileges (the alternative is a manual setup to change settings).

Also, I was under the impression all of our containers were already running with `runAsNonRoot=true`, at least that's how they run on our clusters I think.

---

**Remco Beckers** (2025-03-07 09:10):
I'm not sure what's special about Rancher's PodSecurity, it is a standard Kubernetes security mechanism.

Is this setup a Rancher standard setup or is this all customized by the customer to have these specific rules? Put differently, can we make a version that works for all Rancher installations with extra security enabled or is this a one-off setup?

---

**Remco Beckers** (2025-03-07 09:10):
I guess the names suggest it is a Rancher provided set of defaults:
&gt; "rancher-privileged" or "rancher-retricted"

---

**Hugo de Vries** (2025-03-07 11:38):
Thanks Jeroen I’ll relay it to the Accenture team

---

**Sheng Yang** (2025-03-07 19:20):
Reading the doc (https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/psa-config-templates), you might just ask the namespace to be excluded as a simple way out. Though, it seems elastic no longer require running as root since 8.0 (https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-security-context.html).

---

**Garrick Tam** (2025-03-08 00:52):
Well, this is interesting.  I must not be exempting the namespace correctly in my lab.  Here's the response from the customer.  @Louis Lotter I will open a Jira to request this should work out of the box?
```We have a work around in place for it now by removing the restriction for this namespace, but that isn't optimal. I would expect a product that we are being asked to install on our RKE2 cluster to actually be installable if security is enabled in that cluster as per kubernetes best practices.```

---

**Garrick Tam** (2025-03-08 00:59):
@Mark Bakker Do you want me to create the jira item under the StackState Backlog project?

---

**Mark Bakker** (2025-03-08 08:17):
@Remco Beckers can you make a ticket for this?

---

**Amol Kharche** (2025-03-10 06:35):
Hi Team,
We have a case from *Disney* customer where SUSE Observability not accepting license. They are using 2Z65T-83Q02-PEW6A key.
When they install SUSE Observability it is refusing the license key and prompting for a new one. The message it delivers is "_Your license key has expired! Please enter a valid license key or contact us to continue_:" This is just repeated when they copy and paste the license key from subscriptions which is set to expire on March 31st, 2025.

---

**Amol Kharche** (2025-03-10 06:35):
I used the same license key and I don't see any such message, I am able to access UI without issue.

---

**Remco Beckers** (2025-03-10 09:58):
https://stackstate.atlassian.net/browse/STAC-22461

---

**Louis Lotter** (2025-03-10 10:39):
mm what version are they using ?

---

**Amol Kharche** (2025-03-10 10:53):
I am sure they are using latest version `2.3.0` but let me again confirm with them.

---

**Louis Lotter** (2025-03-10 11:32):
@Frank van Lankvelt can you help out here if they are using the latest version please.

---

**Frank van Lankvelt** (2025-03-10 13:17):
I'll take a look.  Confirmation of the version would be appreciated

---

**Frank van Lankvelt** (2025-03-10 13:59):
the expiration date in the license is `2025-03-01` - so I think the license was off-by-one-month

---

**Frank van Lankvelt** (2025-03-10 14:28):
difference in behavior might be the "grace period", that's 14 days in recent/new SUSE Observability IIRC

---

**Amol Kharche** (2025-03-11 04:59):
They are using `suse-observability-2.3.0`  and they are keep getting below error in server pod logs.
```2025-03-10 19:05:47,818 ERROR com.stackstate.tenant.TenantInitializationService - The subscription for this instance expired on '2025-03-02T00:00:00Z'```

---

**Amol Kharche** (2025-03-11 05:00):
We have provided new key `77PS2-W687H-3256A`  which is set to expire on Mar 31 2025, But by using this key also got the same error.

---

**IHAC** (2025-03-11 07:55):
@Ankush Mistry has a question.

:customer:  Jemena Ltd

:facts-2: *Problem (symptom):*  
Hi Team,
The customer had container images scanned with Crowdstrike to check any vulnerabilities, the images scanned were a part of the Suse-Observability stack and have come back with some critical vulnerabilities:
CVE-2024-37371 - elasticsearch
CVE-2022-1471 - jmx-exporter, hbase-regionserver, hbase-master
CVE-2024-5535 - container-tools, elasticsearch, clickhouse, clickhouse-backup
CVE-2024-3596 - multiple images (9)
CVE-2023-44487 - elasticsearch
CVE-2025-0840 - container-tools
I am sure that we are aware of this vulnerabilities, just need to know that when this will be fixed or have any timelines to address the CVE’s?
Please let me know if you need the list of images or the JSON report of the container image from the customer.

---

**Frank van Lankvelt** (2025-03-11 08:17):
Experation is per the first of every month, so I expect the same issue

---

**Amol Kharche** (2025-03-11 08:19):
@Frank van Lankvelt What we can do now? How to resolve this? Do we need to generate new key with 1st Apr expiration date ?

---

**Louis Lotter** (2025-03-11 09:02):
I can do that but we need to get the SCC to do this properly

---

**Amol Kharche** (2025-03-11 09:06):
SSC team again generated new key but the expiration date is set to 31st Mar only.

---

**Alejandro Acevedo Osorio** (2025-03-11 09:25):
Hi @Ankush Mistry It would be nice to get their Json report for sure so we know which version (of some) images are we talking about. And to contrast with our own internal reports, for example I just searched in our reports from the elasticsearch image and `CVE-2024-37371` has a severity `Medium` ...

---

**Frank van Lankvelt** (2025-03-11 09:44):
license key `04TZZ-VE6X1-CEC6A` does have expiration date April 1st, so I think it'll work

---

**Ankush Mistry** (2025-03-11 09:55):
CVE-2024-5535 This is the critical CVE and attached the JSON reports. Also as reference from the customer the elasticsearch used (8.11.4) was released in January 2024 and the current supported version is 8.16.5.

---

**Ankush Mistry** (2025-03-11 09:57):
Following are the images scanned, let me know if you need the reports for all.
```- registry.rancher.com/suse-observability/container-tools:1.4.0 (http://registry.rancher.com/suse-observability/container-tools:1.4.0)
- registry.rancher.com/suse-observability/generic-sidecar-injector:sha-5678567f (http://registry.rancher.com/suse-observability/generic-sidecar-injector:sha-5678567f)
- registry.rancher.com/suse-observability/http-header-injector-proxy-init:sha-5ff79451 (http://registry.rancher.com/suse-observability/http-header-injector-proxy-init:sha-5ff79451)
- registry.rancher.com/suse-observability/http-header-injector-proxy:sha-5ff79451 (http://registry.rancher.com/suse-observability/http-header-injector-proxy:sha-5ff79451)
- registry.rancher.com/suse-observability/promtail:2.9.10-5400572f (http://registry.rancher.com/suse-observability/promtail:2.9.10-5400572f)
- registry.rancher.com/suse-observability/stackstate-k8s-agent:6943bf8c (http://registry.rancher.com/suse-observability/stackstate-k8s-agent:6943bf8c)
- registry.rancher.com/suse-observability/stackstate-k8s-cluster-agent:6943bf8c (http://registry.rancher.com/suse-observability/stackstate-k8s-cluster-agent:6943bf8c)
- registry.rancher.com/suse-observability/stackstate-k8s-process-agent:6bf354da (http://registry.rancher.com/suse-observability/stackstate-k8s-process-agent:6bf354da)
- registry.rancher.com/suse-observability/clickhouse-backup:2.5.20-2b2c95ed (http://registry.rancher.com/suse-observability/clickhouse-backup:2.5.20-2b2c95ed)
- registry.rancher.com/suse-observability/clickhouse:23.8.13-debian-12-r0-b9530c97 (http://registry.rancher.com/suse-observability/clickhouse:23.8.13-debian-12-r0-b9530c97)
- registry.rancher.com/suse-observability/container-tools:1.5.1 (http://registry.rancher.com/suse-observability/container-tools:1.5.1)
- registry.rancher.com/suse-observability/elasticsearch-exporter:v1.8.0-1cd10cfa (http://registry.rancher.com/suse-observability/elasticsearch-exporter:v1.8.0-1cd10cfa)
- registry.rancher.com/suse-observability/elasticsearch:8.11.4-cf68e2fa (http://registry.rancher.com/suse-observability/elasticsearch:8.11.4-cf68e2fa)
- registry.rancher.com/suse-observability/envoy:v1.31.1-e94598da (http://registry.rancher.com/suse-observability/envoy:v1.31.1-e94598da)
- registry.rancher.com/suse-observability/hadoop:3.4.1-java11-8-90a9d727 (http://registry.rancher.com/suse-observability/hadoop:3.4.1-java11-8-90a9d727)
- registry.rancher.com/suse-observability/hbase-master:2.5-7.9.0 (http://registry.rancher.com/suse-observability/hbase-master:2.5-7.9.0)
- registry.rancher.com/suse-observability/hbase-regionserver:2.5-7.9.0 (http://registry.rancher.com/suse-observability/hbase-regionserver:2.5-7.9.0)
- registry.rancher.com/suse-observability/jmx-exporter:0.17.0-129c430a (http://registry.rancher.com/suse-observability/jmx-exporter:0.17.0-129c430a)
- registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402 (http://registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402)
- registry.rancher.com/suse-observability/kafkaup-operator:0.0.4 (http://registry.rancher.com/suse-observability/kafkaup-operator:0.0.4)
- registry.rancher.com/suse-observability/minio:RELEASE.2025-01-13T16-22-00Z-4ae4220f (http://registry.rancher.com/suse-observability/minio:RELEASE.2025-01-13T16-22-00Z-4ae4220f)
- registry.rancher.com/suse-observability/nginx-prometheus-exporter:1.4.0-8685055728 (http://registry.rancher.com/suse-observability/nginx-prometheus-exporter:1.4.0-8685055728)
- registry.rancher.com/suse-observability/spotlight:5.2.0-snapshot.146 (http://registry.rancher.com/suse-observability/spotlight:5.2.0-snapshot.146)
- registry.rancher.com/suse-observability/stackgraph-console:2.5-7.9.0 (http://registry.rancher.com/suse-observability/stackgraph-console:2.5-7.9.0)
- registry.rancher.com/suse-observability/stackgraph-hbase:2.5-7.9.0 (http://registry.rancher.com/suse-observability/stackgraph-hbase:2.5-7.9.0)
- registry.rancher.com/suse-observability/stackpacks:20250122132516-master-7fe7386-prime-selfhosted (http://registry.rancher.com/suse-observability/stackpacks:20250122132516-master-7fe7386-prime-selfhosted)
- registry.rancher.com/suse-observability/stackstate-correlate:7.0.0-snapshot.20250124171607-master-8a3bd61 (http://registry.rancher.com/suse-observability/stackstate-correlate:7.0.0-snapshot.20250124171607-master-8a3bd61)
- registry.rancher.com/suse-observability/stackstate-kafka-to-es:7.0.0-snapshot.20250124171607-master-8a3bd61 (http://registry.rancher.com/suse-observability/stackstate-kafka-to-es:7.0.0-snapshot.20250124171607-master-8a3bd61)
- registry.rancher.com/suse-observability/stackstate-receiver:7.0.0-snapshot.20250124171607-master-8a3bd61 (http://registry.rancher.com/suse-observability/stackstate-receiver:7.0.0-snapshot.20250124171607-master-8a3bd61)
- registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250124171607-master-8a3bd61-2.5 (http://registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20250124171607-master-8a3bd61-2.5)
- registry.rancher.com/suse-observability/stackstate-ui:7.0.0-snapshot.20250124171607-master-8a3bd61 (http://registry.rancher.com/suse-observability/stackstate-ui:7.0.0-snapshot.20250124171607-master-8a3bd61)
- registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.17 (http://registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.17)
- registry.rancher.com/suse-observability/tephra-server:2.5-7.9.0 (http://registry.rancher.com/suse-observability/tephra-server:2.5-7.9.0)
- registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-fe577cd2 (http://registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-fe577cd2)
- registry.rancher.com/suse-observability/vmagent:v1.109.0-ad5fe3d4 (http://registry.rancher.com/suse-observability/vmagent:v1.109.0-ad5fe3d4)
- registry.rancher.com/suse-observability/vmbackup:v1.109.0-a8104dee (http://registry.rancher.com/suse-observability/vmbackup:v1.109.0-a8104dee)
- registry.rancher.com/suse-observability/vmrestore:v1.109.0-219ea492 (http://registry.rancher.com/suse-observability/vmrestore:v1.109.0-219ea492)
- registry.rancher.com/suse-observability/wait:1.0.11-04b49abf (http://registry.rancher.com/suse-observability/wait:1.0.11-04b49abf)
- registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7 (http://registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7)```

---

**Alejandro Acevedo Osorio** (2025-03-11 10:01):
I think that's enough for now to compare and contrast.

---

**Alejandro Acevedo Osorio** (2025-03-11 10:04):
Mmmm perhaps it would be nice to check this 2 as well  `hbase-regionserver, hbase-master`

---

**Alejandro Acevedo Osorio** (2025-03-11 10:06):
@Louis Lotter @Louis Parkin we have a case here where the customer scan shows really different results than our scan. I cross checked elasticsearch:8.11.4-cf68e2fa (http://registry.rancher.com/suse-observability/elasticsearch:8.11.4-cf68e2fa) - on our scans comes without any `CRITICAL` as `CVE-2024-5535` is flagged as `Medium`

---

**Louis Lotter** (2025-03-11 10:07):
Are they using the same scanning software ?

---

**Alejandro Acevedo Osorio** (2025-03-11 10:07):
Not at all ... so I'm wondering what's wise over here. To share our own reports?

---

**Louis Lotter** (2025-03-11 10:09):
Not sure at all I think we need to ask for some advice from @Sheng Yang etc. January 2024 is not that old for us. So if we need to update faster than that it's a big change how we work.

---

**Louis Lotter** (2025-03-11 10:09):
Is crowdstrike the preferred scanning tool ? etc.

---

**Louis Lotter** (2025-03-11 10:10):
@Mark Bakker :point_up:

---

**Louis Parkin** (2025-03-11 10:13):
@Louis Lotter this is an age-old debate, one that now suddenly has 10 answers instead of 3.  TLDR; we can deal with it, but it takes man hours away from developers, or we can get our images into the AppCo, then it becomes someone else's problem.

---

**Louis Parkin** (2025-03-11 10:14):
&gt; @Louis Lotter @Louis Parkin we have a case here where the customer scan shows really different results than our scan. I cross checked elasticsearch:8.11.4-cf68e2fa (http://registry.rancher.com/suse-observability/elasticsearch:8.11.4-cf68e2fa) - on our scans comes without any `CRITICAL` as `CVE-2024-5535` is flagged as `Medium`
@Alejandro Acevedo Osorio the scanner does not determine the severity, it just reports it.  If they report it different to how we report it, then we must look it up on opencve.io (http://opencve.io) because someone has to be wrong.

---

**Louis Parkin** (2025-03-11 10:16):
@Alejandro Acevedo Osorio this is an odd one.  It is both.

---

**Louis Parkin** (2025-03-11 10:17):
The issue is the scoring that you look at - CVSS V2 and V3 were standard back in the day when I started managing the security of our images.

---

**Louis Parkin** (2025-03-11 10:17):
Now there is a CVSS V3.1 and a V4

---

**Louis Parkin** (2025-03-11 10:18):
And for this CVE, the v3 score is 5.9/10 (Medium), and the v3.1 score is 9.1/10 (Critical)

---

**Louis Parkin** (2025-03-11 10:18):
This makes it MUCH harder, as we don't pick which score we use, the scanner does.

---

**Louis Parkin** (2025-03-11 10:19):
@Alejandro Acevedo Osorio for reference: https://app.opencve.io/cve/CVE-2024-5535

---

**Alejandro Acevedo Osorio** (2025-03-11 10:20):
So in the end the scanner does determine/influence the severity

---

**Louis Parkin** (2025-03-11 10:20):
@Alejandro Acevedo Osorio
&gt; for example I just searched in our reports from the elasticsearch image and `CVE-2024-37371` has a severity `Medium` ...
Can you show me this :point_up::skin-tone-3: ?

---

**Louis Parkin** (2025-03-11 10:20):
It only has 1 score, and that is NOT Medium -&gt; https://app.opencve.io/cve/CVE-2024-37371

---

**Amol Kharche** (2025-03-11 10:21):
Let me ask customer to try this.

---

**Alejandro Acevedo Osorio** (2025-03-11 10:23):
This is the from the last run ... from this morning

---

**Louis Parkin** (2025-03-11 10:24):
Just give me the whole file please

---

**Louis Parkin** (2025-03-11 10:25):
@Alejandro Acevedo Osorio
&gt; So in the end the scanner does determine/influence the severity
It shouldn't...

---

**Louis Parkin** (2025-03-11 10:26):
I usually (when parsing the JSON) just extract the high-level field named `Severity`, and that's what I work with.

---

**Louis Parkin** (2025-03-11 10:27):
So, if the `severity` is given as `Medium` for a CVE that has a v3 score of Medium and a v3.1 score of Critical, then I believe the scanner made a mistake.

---

**Louis Parkin** (2025-03-11 10:28):
But I need to check the json for CVE-2024-37371 (https://app.opencve.io/cve/CVE-2024-37371) to see what actually went wrong there.

---

**Louis Parkin** (2025-03-11 10:29):
@Alejandro Acevedo Osorio
```{
          "VulnerabilityID": "CVE-2024-37371",
          "PkgID": "libgssapi-krb5-2@1.17-6ubuntu4.4",
          "PkgName": "libgssapi-krb5-2",
          "PkgIdentifier": {
            "PURL": "pkg:deb/ubuntu/libgssapi-krb5-2@1.17-6ubuntu4.4?arch=amd64\u0026distro=ubuntu-20.04",
            "UID": "9a18416c793c7907"
          },
          "InstalledVersion": "1.17-6ubuntu4.4",
          "FixedVersion": "1.17-6ubuntu4.6",
          "Status": "fixed",
          "Layer": {
            "DiffID": "sha256:2666ed0277803b0f83678d509c0eb1d6787c1bb97c13eba378f6cbe291e7cca5"
          },
          "SeveritySource": "ubuntu",
          "PrimaryURL": "https://avd.aquasec.com/nvd/cve-2024-37371",
          "DataSource": {
            "ID": "ubuntu",
            "Name": "Ubuntu CVE Tracker",
            "URL": "https://git.launchpad.net/ubuntu-cve-tracker"
          },
          "Title": "krb5: GSS message token handling",
          "Description": "In MIT Kerberos 5 (aka krb5) before 1.21.3, an attacker can cause invalid memory reads during GSS message token handling by sending message tokens with invalid length fields.",
          "Severity": "MEDIUM",
          "VendorSeverity": {
            "alma": 3,
            "amazon": 2,
            "azure": 4,
            "cbl-mariner": 4,
            "nvd": 4,
            "oracle-oval": 3,
            "photon": 4,
            "redhat": 2,
            "ubuntu": 2
          },
          "CVSS": {
            "nvd": {
              "V3Vector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:H",
              "V3Score": 9.1
            },
            "redhat": {
              "V3Vector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:N/I:N/A:H",
              "V3Score": 6.5
            }
          },
          "References": [
            "https://access.redhat.com/errata/RHSA-2025:1673",
            "https://access.redhat.com/security/cve/CVE-2024-37371",
            "https://bugzilla.redhat.com/2294581",
            "https://bugzilla.redhat.com/2294676",
            "https://bugzilla.redhat.com/2301888",
            "https://bugzilla.redhat.com/2318857",
            "https://bugzilla.redhat.com/2318858",
            "https://bugzilla.redhat.com/2318870",
            "https://bugzilla.redhat.com/2318873",
            "https://bugzilla.redhat.com/2318874",
            "https://bugzilla.redhat.com/2318876",
            "https://bugzilla.redhat.com/2318882",
            "https://bugzilla.redhat.com/2318883",
            "https://bugzilla.redhat.com/2318884",
            "https://bugzilla.redhat.com/2318885",
            "https://bugzilla.redhat.com/2318886",
            "https://bugzilla.redhat.com/2318897",
            "https://bugzilla.redhat.com/2318900",
            "https://bugzilla.redhat.com/2318905",
            "https://bugzilla.redhat.com/2318914",
            "https://bugzilla.redhat.com/2318922",
            "https://bugzilla.redhat.com/2318923",
            "https://bugzilla.redhat.com/2318925",
            "https://bugzilla.redhat.com/2318926",
            "https://bugzilla.redhat.com/2318927",
            "https://bugzilla.redhat.com/2331191",
            "https://bugzilla.redhat.com/2339218",
            "https://bugzilla.redhat.com/2339220",
            "https://bugzilla.redhat.com/2339221",
            "https://bugzilla.redhat.com/2339226",
            "https://bugzilla.redhat.com/2339231",
            "https://bugzilla.redhat.com/2339236",
            "https://bugzilla.redhat.com/2339238",
            "https://bugzilla.redhat.com/2339243",
            "https://bugzilla.redhat.com/2339247",
            "https://bugzilla.redhat.com/2339252",
            "https://bugzilla.redhat.com/2339259",
            "https://bugzilla.redhat.com/2339266",
            "https://bugzilla.redhat.com/2339270",
            "https://bugzilla.redhat.com/2339271",
            "https://bugzilla.redhat.com/2339275",
            "https://bugzilla.redhat.com/2339277",
            "https://bugzilla.redhat.com/2339281",
            "https://bugzilla.redhat.com/2339284",
            "https://bugzilla.redhat.com/2339291",
            "https://bugzilla.redhat.com/2339293",
            "https://bugzilla.redhat.com/2339295",
            "https://bugzilla.redhat.com/2339299",
            "https://bugzilla.redhat.com/2339300",
            "https://bugzilla.redhat.com/2339304",
            "https://bugzilla.redhat.com/2339305",
            "https://errata.almalinux.org/8/ALSA-2025-1673.html",
            "https://github.com/krb5/krb5/commit/55fbf435edbe2e92dd8101669b1ce7144bc96fef",
            "https://linux.oracle.com/cve/CVE-2024-37371.html",
            "https://linux.oracle.com/errata/ELSA-2025-1673.html",
            "https://nvd.nist.gov/vuln/detail/CVE-2024-37371",
            "https://security.netapp.com/advisory/ntap-20241108-0009/",
            "https://ubuntu.com/security/notices/USN-6947-1",
            "https://web.mit.edu/kerberos/www/advisories/",
            "https://web.mit.edu/kerberos/www/krb5-1.21/",
            "https://www.cve.org/CVERecord?id=CVE-2024-37371",
            "https://www.oracle.com/security-alerts/cpujan2025.html#AppendixMSQL"
          ],
          "PublishedDate": "2024-06-28T23:15:11.603Z",
          "LastModifiedDate": "2024-11-21T09:23:43.74Z"
        },```

---

**Amol Kharche** (2025-03-11 11:44):
From neuvector side it reported `CVE-2024-5535`  and `CVE-2024-37371`  as `HIGH severity`

---

**IHAC** (2025-03-11 11:56):
@Devendra Kulkarni has a question.

:customer:  LIEBHERR-IT SERVICES GMBH

:facts-2: *Problem (symptom):*  
Hello Team,
Customer reported that they recently patched/updated their host OS and rebooted them, after that their suse-observability pods aren't coming up.

I am attaching the log bundle as I would need further help to debug these logs.
What I saw from a quick review is that the suse-observability-initializer, api, checks and tephra pod are not coming up and continously crashing.

Initializer is unable to come up as tephra is not started, health-sync shows its is unable to resolve zookeeper headleass svc.

Can someone look into the logs and let me know how to debug further?

---

**Alejandro Acevedo Osorio** (2025-03-11 14:55):
On the `namenode` logs I see `2025-03-10 19:14:48,967 INFO blockmanagement.BlockPlacementPolicy: Not enough replicas was chosen. Reason: {NOT_ENOUGH_STORAGE_SPACE=1, NO_REQUIRED_STORAGE_TYPE=1}`

---

**Alejandro Acevedo Osorio** (2025-03-11 14:55):
`NOT_ENOUGH_STORAGE_SPACE`

---

**Alejandro Acevedo Osorio** (2025-03-11 14:56):
We need to check the disk space on the datanodes pvc's

---

**Sheng Yang** (2025-03-11 18:00):
What are we using for our own scanning? customers are usually using Trivy so we need to standardize on that.

---

**Louis Parkin** (2025-03-11 18:01):
Hey Sheng, we scan with with Trivy and with Grype in an attempt to get wider coverage.

---

**Sheng Yang** (2025-03-11 18:02):
That should work then…

---

**Louis Parkin** (2025-03-11 18:02):
We discovered an issue with the scan output from both earlier today.

---

**Louis Parkin** (2025-03-11 18:03):
It’s not a train smash, but it did highlight an issue where a customer scanning with CrowdStrike might get a different, more accurate result than we do.

---

**Sheng Yang** (2025-03-11 18:08):
It won’t be possible for us to use all the scanner in the market. I would treat this more in a case by case way, as long as our scanner are also up to date.
I do wonder why NeuVector also reports it but both Trivy and Grype missed.

---

**Louis Parkin** (2025-03-11 18:09):
No, I agree. I think Trivy and Grype give us a good picture. I might report our findings to them as bugs, or we can mitigate on our side. I think it needs some more thought.

---

**Sheng Yang** (2025-03-11 18:09):
Maybe Rancher Security Team can lend a hand to evaluate in this case. Let me check

---

**Louis Parkin** (2025-03-11 18:11):
The issue we uncovered is that a CVE has two different CVSS v3.1 scores, and the scanners don’t report the most severe of the two.

---

**Louis Parkin** (2025-03-11 18:12):
So we have it as Medium severity and the customer has it as Critical.

---

**Amol Kharche** (2025-03-12 09:12):
`04TZZ-VE6X1-CEC6A`  works well. Thanks for your support @Frank van Lankvelt @Louis Lotter

---

**Louis Parkin** (2025-03-12 10:54):
@Alejandro Acevedo Osorio @Louis Lotter the context on the CVE questions from yesterday are as follows:
• There is no one right answer (vendors score and re-score CVEs as time goes by).
• The scanners are set to use a specific data source, or attach more value to one than another.
    ◦ This means that the CrowdStrike scanner is likely set to value data from NVD higher than other sources.
• We trust our own scores more than others (We, SUSE, also score CVEs).  
The scoring system is set up as follows:
```Base Score Range 	Severity
0.1-3.9 	Low
4.0-6.9 	Medium
7.0-8.9 	High
9.0-10.0 	Critical```
For the CVEs discussed yesterday, our scores are as follows:
```Medium - 6.5 - CVE-2024-37371 - elasticsearch                                                ------ https://www.suse.com/security/cve/CVE-2024-37371.html
High   - 8.8 - CVE-2022-1471 - jmx-exporter, hbase-regionserver, hbase-master                ------ https://www.suse.com/security/cve/CVE-2022-1471.html
Medium - 5.9 - CVE-2024-5535 - container-tools, elasticsearch, clickhouse, clickhouse-backup ------ https://www.suse.com/security/cve/CVE-2024-5535.html
High   - 7.3 - CVE-2024-3596 - multiple images (9)                                           ------ https://www.suse.com/security/cve/CVE-2024-3596.html
High   - 7.5 - CVE-2023-44487 - elasticsearch                                                ------ https://www.suse.com/security/cve/CVE-2023-44487.html
Medium - 5.0 - CVE-2025-0840 - container-tools                                               ------ https://www.suse.com/security/cve/CVE-2025-0840.html```

---

**Louis Parkin** (2025-03-12 10:55):
cc @Ankush Mistry

---

**Ankush Mistry** (2025-03-12 11:02):
@Louis Parkin any timelines for this to get fixed?

---

**Louis Parkin** (2025-03-12 11:16):
@Alejandro Acevedo Osorio are we logging tickets to get these CVEs resolved?

---

**Louis Parkin** (2025-03-12 11:17):
cc @Bram Schuur @Mark Bakker

---

**Louis Lotter** (2025-03-12 11:38):
@Louis Parkin please log the tickets and share them

---

**Louis Lotter** (2025-03-12 11:39):
prioritization will come after that. So no timelines yet @Ankush Mistry.

---

**Louis Lotter** (2025-03-12 11:40):
@Louis Parkin please add to the tickets that we should let Ankush know once we have some plans for these tickets.

---

**Louis Parkin** (2025-03-12 16:13):
@Louis Lotter I will address your last request in a moment.  Tickets logged -&gt; https://stackstate.atlassian.net/issues/?jql=issueKey%20in%20%28STAC-22492%2CSTAC-22493%2[…]5%2CSTAC-22496%2CSTAC-22507%2CSTAC-22508%2CSTAC-22509%29 (https://stackstate.atlassian.net/issues/?jql=issueKey%20in%20%28STAC-22492%2CSTAC-22493%2CSTAC-22494%2CSTAC-22495%2CSTAC-22496%2CSTAC-22507%2CSTAC-22508%2CSTAC-22509%29)

It was a bit tedious due to actual scanner output.  I hope I didn't miss anything.

---

**Louis Parkin** (2025-03-12 16:17):
Actually, I think I did miss one, MINIO, but it wasn't on the reported list I think...

---

**Javier Lagos** (2025-03-13 12:24):
Hello team, I'm currently working in a customer case 01570273 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000TiCRSIA3/view) where the customer is complaining about the Suse Observability login page when authentication provider, like KeyCloak, has been configured.

Basically, when you access Suse Observability webUI and there is an external authentication configured ( have only tested and confirmed this with KeyCloak but I assume the behavior will be the same with the rest of valid authentication providers) the console loading page is redirected directly to the Authentication provider URL without being able to access Suse Observability with local admin user and password.

This console behavior is creating some issues when the authentication provider is not available/running or even not well configured as there is no possibility (Maybe I have not found yet how) to access Suse Observability successfully as when accessing Suse Observability it is automatically redirected to the authentication provider.

I honestly believe that a menu, in the Suse Observability webUI, where you can choose between entering username/password or selecting the configured authentication method would be a valuable feature to add to the component that customers will appreciate. It would be even better if multiple authentication providers could be configured at the same time.

Can we expect to have this implemented in the future?

If this feature is not expected to be implemented, Is there another way to access Suse Observability other than re-applying helm chart without the auth provider part?

Thanks in advance,

---

**Louis Lotter** (2025-03-13 13:21):
@Mark Bakker I guess this one is for you and/or @Ovidiu Boc

---

**Ovidiu Boc** (2025-03-13 14:08):
@Mark Bakker for sure

---

**Javier Lagos** (2025-03-14 16:18):
Hello @Mark Bakker, Can you please check the message I have posted based on a customer request once you are available? Thanks!

---

**Louis Lotter** (2025-03-14 16:46):
He was at Susecon this week

---

**Javier Lagos** (2025-03-14 16:50):
Thanks for letting me know @Louis Lotter. I will wait until he is available and back :slightly_smiling_face:

---

**Vladimir Iliakov** (2025-03-18 11:08):
Hi @David Noland, I am planning to migrate suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) from Stackstate chart to the latest Observability chart. We can't save the data: topology, metrics, logs, but the configuration, Stackpacks, Monitors, Notifications can be migrated via export/import.
There is a great opportunity to change the tenant url to something more relevant. Let me know *if you want the new url*? The changing of the url implies reconfiguring the agents, but you can do it when it more convenient for your team. We will keep `suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) ` as a secondary url as long as needed.
I am planning to redeploy the tenant this Wednesday 10:00 AM CET, I guess, it is 02:00 PDT. Let me know if that time is ok with you?

---

**Vladimir Iliakov** (2025-03-18 11:45):
And one more thing. The users of the tenants will be created. They will get a new welcome email with the sign-up link they have to follow.

---

**David Noland** (2025-03-18 16:36):
Hi Vladimir - the timing sounds fine. Yes, a new URL would be great. How about rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io)?

---

**Vladimir Iliakov** (2025-03-18 16:37):
Yes, sounds good :thumbs-up:.

---

**Vladimir Iliakov** (2025-03-18 16:38):
So tomorrow, I will redeploy the tenant and inform you when it is done.

---

**David Noland** (2025-03-18 16:44):
Sounds good, thanks

---

**Vladimir Iliakov** (2025-03-19 12:43):
~The tenant has been recreated with the configuration restored. I have re-created users, they should have welcome message in their mailboxes, which contains sign-up links. I created a user for myself and I see requests are coming from the agents (There are no data from a few clusters, please check https://rancher-hosted.app.stackstate.io/#/stackpacks/kubernetes-v2, if that is not expected please restart the agents there).~

~The main ingresses are~
• ~rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io)~
• ~otlp-rancher-hosted.app.stackstate.io (http://otlp-rancher-hosted.app.stackstate.io)~
• ~otlp-http-rancher-hosted.app.stackstate.io (http://otlp-http-rancher-hosted.app.stackstate.io)~
~The old ones are still working and serve the same endpoints as~ :point_up:
• ~suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io)~
• ~otlp-suseus-trial.app.stackstate.io (http://otlp-suseus-trial.app.stackstate.io)~
• ~otlp-http-suseus-trial.app.stackstate.io (http://otlp-http-suseus-trial.app.stackstate.io)~
~P.S. The ip addresses for the olds ones have been changed.~

~*There is a problem with using suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) in browser:* it redirects to rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io) and after that it throws 403 Forbidden while trying to observe pods/services. The workaround is to clean the cookies and never go to suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) again. I am looking for a permanent fix.~

MOVED here https://suse.slack.com/archives/C07CF9770R3/p1742384621937839

---

**Vladimir Iliakov** (2025-03-19 12:43):
The tenant (suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io)) has been recreated with the configuration restored. I have re-created users, they should have welcome message in their mailboxes, which contains sign-up links. I created a user for myself and I see requests are coming from the agents (There are no data from a few clusters, please check https://rancher-hosted.app.stackstate.io/#/stackpacks/kubernetes-v2, if that is not expected please restart the agents there).

The new ingresses are
• rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io)
• otlp-rancher-hosted.app.stackstate.io (http://otlp-rancher-hosted.app.stackstate.io)
• otlp-http-rancher-hosted.app.stackstate.io (http://otlp-http-rancher-hosted.app.stackstate.io)
The old ones are still working and serve the same endpoints as :point_up:
• suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io)
• otlp-suseus-trial.app.stackstate.io (http://otlp-suseus-trial.app.stackstate.io)
• otlp-http-suseus-trial.app.stackstate.io (http://otlp-http-suseus-trial.app.stackstate.io)
P.S. The ip addresses for the olds ones have been changed.
*There is a problem with using suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) in browser:* it redirects to rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io) and after that it throws 403 Forbidden while trying to observe pods/services. The workaround is to clean the cookies and never go to suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) again. I am looking for a permanent fix.

---

**Vladimir Iliakov** (2025-03-19 13:32):
I have applied a permanent fix for the redirect thing. It is a bit tricky and so I am not 100% confident. You may need to cleanup sessions/cookies for suseus-trial.app.stackstate.io (http://suseus-trial.app.stackstate.io) at least once.

---

**David Noland** (2025-03-20 00:54):
Thanks for upgrading the environment. So far everything looks okay. We'll work on updating all our agents with the new endpoint.

---

**Devendra Kulkarni** (2025-03-20 06:48):
Hello @Alejandro Acevedo Osorio,
The customer redeployed the suse-observability stack but is still facing issue with mulitple pods crashing and checking events I see readiness/liveness probe failing.

Could you please check the latest log bundle again?

---

**Vladimir Iliakov** (2025-03-20 08:05):
Thank you. Please let me know when the old endpoints are no longer needed. :thumbs-up:

---

**Alejandro Acevedo Osorio** (2025-03-20 09:43):
Sure @Devendra Kulkarni ... I'll check the logs

---

**Devendra Kulkarni** (2025-03-20 10:22):
I will now schedule a call with customer to check the environment and storage correctly, thanks for your help

---

**Devendra Kulkarni** (2025-03-20 10:22):
I had alreadu informed them about the out of space logs yesterday only, but the customer mentioned that PV PVC are bound and no issues with storage

---

**Alejandro Acevedo Osorio** (2025-03-20 10:36):
Might be that they already fixed it an all is needed is a restart of those pods so they ack they extra disk space

---

**Devendra Kulkarni** (2025-03-20 10:37):
No they didn't mention that they increase disk size... They just mentioned they redeployed the setup

---

**Devendra Kulkarni** (2025-03-20 10:38):
I will anyway schedule a call and confirm

---

**Garrick Tam** (2025-03-20 22:15):
Hello.  Customer "DR Horton" is requesting an update for https://stackstate.atlassian.net/browse/STAC-22148.  Can someone please provide an estimate or timeline?  TIA

---

**David Noland** (2025-03-21 00:03):
ok, will likely need the old endpoint to work for about a month to move all our tenants' agents over.

---

**Vladimir Iliakov** (2025-03-21 08:27):
That is fine. Thank you.

---

**Louis Lotter** (2025-03-21 08:45):
Hi Garrick. The solution to this issue is not yet clear to us so this first ticket that should be worked on in the next 4 weeks is not guaranteed so solve the issue yet.
We can keep you updated on how it evolves but it would be very hard to predict when this will be resolved fully.

---

**IHAC** (2025-03-21 18:18):
@Rodolfo de Almeida has a question.

:customer:  Corning Inc

:facts-2: *Problem (symptom):*  
Hello everyone, the customer stores the StackState license in a secret and uses the following setting to point to the secret during installation.
```--set 'stackstate.license.fromExternalSecret'='suse-observability-sckeconfig'```
The key point is that the customer encrypts the secret using kubeseal. After a successful installation, the customer cannot use StackState. We found the following log.
```2025-03-21 13:06:02,660 INFO  com.stackstate.tenant.TenantSubscriptionServiceImpl - Initializing TenantSubscription for tenant configuration 'None' and license key 'Some(  1JL8C-V0X02-UY64A

)'.

2025-03-21 13:06:02,661 WARN  com.stackstate.api.tenantapi.SubscriptionDirectives - StackState is unlicensed: InvalidLicenseKey.```
Is kubeseal supported for use with StackState in this case? I've tested the customer's license manually and with a non-encrypted Kubernetes secret, and it works.
Encrypting the secret is a customer requirement. I'm trying to reproduce the problem in a lab, but it's strange that according to the customer this used to work without any problems.

---

**Rodolfo de Almeida** (2025-03-21 18:19):
I have verified with Will Stephenson that the customer license is valid and it is not expired.

---

**Jeroen van Erp** (2025-03-21 19:27):
It looks like there's spacing and new lines added to the licensekey

---

**Jeroen van Erp** (2025-03-21 19:27):
See the log line.

---

**Jeroen van Erp** (2025-03-21 19:27):
I think they need to check how they seal and unseal the secret. Might be that this is accidentally added in that process

---

**Rodolfo de Almeida** (2025-03-21 19:30):
Hello @Jeroen van Erp
We noticed that but look at this.
# echo it wrapped with pipe characters to verify no errant special or non-printables in the string
suse-observability]$ VALUE=$(kubectl get secret suse-observability-sckeconfig -o jsonpath='{.data.LICENSE_KEY}' | base64 -d); echo "|$VALUE|"
|1JL8C-V0X02-UY64A|

---

**Rodolfo de Almeida** (2025-03-21 19:59):
@Jeroen van Erp
The customer sent me this message.
```Please ask documentation group to consider adding a note to the effect that the name of the secret is an imperative and using an opaque with a different name will have negative results.

The issue was resolved by breaking the LICENSE_KEY key out of the secret (sealed-secret) and putting it in a sealed secret by the name of suse-observability-license```
Does it make sense?

---

**Jeroen van Erp** (2025-03-21 20:01):
Not really, we'd need to look at the helm Chart to verify why that would be. Is it exactly the same contents?

---

**Rodolfo de Almeida** (2025-03-21 20:12):
This is the command used to install SUSE Observability.
```  export VALUES_DIR=~/Projects/sckeob/suse-observability/values
  helm upgrade \
    --install \
    --namespace "suse-observability" \
    --create-namespace \
    --set 'stackstate.authentication.fromExternalSecret'=suse-observability-sckeconfig \
    --set 'stackstate.java.trustStoreBase64Encoded'=$(cat $VALUES_DIR/[REDACTED] | base64) \
    --set 'stackstate.java.trustStorePassword'=[REDACTED] \
    --set 'stackstate.license.fromExternalSecret'='suse-observability-sckeconfig' \
    --values $VALUES_DIR/authentication.yaml \
    --values $VALUES_DIR/baseConfig_values.yaml \
    --values $VALUES_DIR/ingress_values.yaml \
    --values $VALUES_DIR/sizing_values.yaml \
    suse-observability suse-observability/suse-observability```
I am trying to reproduce the problem in my lab

---

**Rodolfo de Almeida** (2025-03-21 20:15):
I installed SUSE Observability in my lab using the same name as the customer and it worked without encryption.
```helm upgrade --install suse-observability suse-observability/suse-observability \
  --namespace "suse-observability" \
  --create-namespace \
  --set 'stackstate.license.fromExternalSecret'='suse-observability-sckeconfig' \
  --values ingress.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
  --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml```

---

**Devendra Kulkarni** (2025-03-25 10:15):
When can we expect the 2.3.1 release?

---

**Daniel Barra** (2025-03-25 11:14):
Hello, we already did 2.3.1! :slightly_smiling_face:
https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.1

---

**Devendra Kulkarni** (2025-03-25 11:17):
I was checking https://github.com/StackVista/helm-charts (https://github.com/StackVista/helm-charts) releases

---

**Daniel Barra** (2025-03-25 11:18):
yes, you can see the tags there!

---

**Daniel Barra** (2025-03-25 11:19):
*We are pleased to announce the release of 2.3.1, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.1).*

---

**Devendra Kulkarni** (2025-03-25 11:19):
Yes thanks

---

**Devendra Kulkarni** (2025-03-27 09:52):
Hello Team,
We received another case where customer - Adenza (https://suse.lightning.force.com/lightning/r/Account/0015q000008jkNsAAI/view) is trying to setup SUSE Observability with Longhorn CSI. Currently, the pods are failing due to some misconfiguration with LH as I can see from logs. But I found that there are compatibility issues with Longhorn - https://stackstate.atlassian.net/browse/STAC-22428 and https://stackstate.atlassian.net/browse/STAC-22429.

I just wanted to highlight this here to ensure that we are aligned with the tests ^ and customers are trying to use LH

---

**Devendra Kulkarni** (2025-03-27 09:53):
I will check with customer if fixing the current issue with longhorn CSI and check if we are able to deploy Observability.

---

**Devendra Kulkarni** (2025-03-28 11:43):
Hi @Alejandro Acevedo Osorio, Customer tried deleting the hbase-hdfs-nn-0 pod but it didnt help

---

**Devendra Kulkarni** (2025-03-28 11:44):
I am proposing a call to customer, will you be able to join and check whats wrong?

---

**Alejandro Acevedo Osorio** (2025-03-28 11:44):
well we needed to restart the datanodes at least as well

---

**Alejandro Acevedo Osorio** (2025-03-28 11:45):
I can join you but it all depends at what time is the call. I'm in Amsterdam UTC+1

---

**Devendra Kulkarni** (2025-03-28 11:47):
okay, I ll let you know once I get confirmation from the customer

---

**Devendra Kulkarni** (2025-04-01 10:43):
@Alejandro Acevedo Osorio Customer is on-call.
Would you be able to join?

---

**Devendra Kulkarni** (2025-04-01 10:47):
https://meet.google.com/aor-vrwr-eps?authuser=2

---

**Devendra Kulkarni** (2025-04-01 10:47):
Please join

---

**Alejandro Acevedo Osorio** (2025-04-01 11:32):
@Devendra Kulkarni @Amol Kharche found another entry for the NFS not supported https://suse.slack.com/archives/C07CF9770R3/p1730962730143879

---

**Devendra Kulkarni** (2025-04-01 11:33):
Yes, I found this too while we were on-call.

---

**Devendra Kulkarni** (2025-04-01 11:33):
I see https://stackstate.atlassian.net/browse/STAC-21073 as well

---

**Alejandro Acevedo Osorio** (2025-04-01 11:34):
Indeed the ticket to document it ...

---

**Devendra Kulkarni** (2025-04-01 11:34):
But nothing in docs, I'll try to add a line in our doc that we are currently not supporting NFS as a storage provisioner for SUSE Observability pods

---

**Devendra Kulkarni** (2025-04-01 11:35):
till the time we figure out the compatibility with NFS

---

**Devendra Kulkarni** (2025-04-01 11:35):
I will create a doc PR and share the link here!

---

**Amol Kharche** (2025-04-01 11:36):
Better to say like `not recommended in production` ?

---

**Alejandro Acevedo Osorio** (2025-04-01 11:36):
Might be that @Remco Beckers and @Vladimir Iliakov have some ideas on how to phrase it as well

---

**Devendra Kulkarni** (2025-04-01 11:39):
`For production environments, NFS is not recommended and supported for storage provisioning in SUSE Observability due to the potential risk of data corruption.`

---

**Devendra Kulkarni** (2025-04-01 11:39):
How about this? ^

---

**Devendra Kulkarni** (2025-04-01 11:41):
@Alejandro Acevedo Osorio For reference, adding the message we saw in namenode pods here:
``` Name Node detected blocks with generation stamps in future```

---

**Alejandro Acevedo Osorio** (2025-04-01 11:41):
let's add the other one as well....
```Not enough replicas was chosen. Reason: {NO_REQUIRED_STORAGE_TYPE=1}```

---

**Devendra Kulkarni** (2025-04-01 11:42):
I will submit a doc PR and share link here in some time

---

**Devendra Kulkarni** (2025-04-01 12:52):
https://github.com/StackVista/stackstate-docs/pull/1594/files

---

**Devendra Kulkarni** (2025-04-01 12:52):
@Alejandro Acevedo Osorio Can you review?

---

**Alejandro Acevedo Osorio** (2025-04-01 16:16):
@Devendra Kulkarni perhaps something similar on this page? https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/storage#storage-defaults

---

**Devendra Kulkarni** (2025-04-01 16:32):
Okay, will add same info on this page too

---

**Remco Beckers** (2025-04-01 16:41):
This is a different issue I think. The agent cannot be installed now because there are Pod Security policies that do not allow privileged pods, nor do they allow pods to use the host network or host paths.

To get the functionality of the node and logs agents these permissions are required.

For the node-agent see also https://docs.stackstate.com/get-started/k8s-quick-start-guide#prerequisites-for-kubernetes (the last bullet point):
• process-agent needs privileged to collect network connectivity functionality
• node-agent needs host access to collect host metrics 
The logs agent needs to access the hostPaths to be able to read the log files from the containers.

The only work-around is to not install these agents, but that will significantly reduce functionality.

---

**Amol Kharche** (2025-04-01 17:41):
Thank you for detailed explanation. :salute_canada_intensifies:, I will inform this to customer.

---

**Devendra Kulkarni** (2025-04-02 11:32):
@Alejandro Acevedo Osorio Done!
https://github.com/StackVista/stackstate-docs/pull/1594

---

**Alejandro Acevedo Osorio** (2025-04-02 12:59):
Thank you!!!

---

**Surya Boorlu** (2025-04-07 09:16):
The request if CPU is only 1 core while the limit is 8 cores. 30 nodes are being monitored with this cluster.

---

**Amol Kharche** (2025-04-07 09:28):
What is the node size of monitored cluster ?
An observed node is taken to be 4 vCPUs and 16GB of memory, default node size. If nodes in your observed cluster are bigger, they can count for multiple default nodes, so a node of 12vCPU and 48GB counts as 3 default nodes under observation when picking a profile.

---

**Surya Boorlu** (2025-04-07 09:40):
I will check once.

---

**Alejandro Acevedo Osorio** (2025-04-07 10:21):
I was indeed curious what profile is the customer using as I don't recognise the `request: 1 and limit:8` for CPU

---

**Alejandro Acevedo Osorio** (2025-04-07 10:24):
While inspecting the logs of the server I notice some log lines that look pretty bad such as
```java.util.NoSuchElementException: Element does not exist 17402879042484```
that usually means that some data might have gotten corrupted

---

**Surya Boorlu** (2025-04-07 10:25):
I guess they tweaked something. I will check which profile they are using.

---

**Alejandro Acevedo Osorio** (2025-04-07 10:26):
sure, and perhaps check if they tweaked something on the stackgraph or tephra pods, but from the looks of those logs the easiest would be to make a reinstall

---

**Surya Boorlu** (2025-04-07 10:27):
Totally understood. I will check with the customer.

---

**Surya Boorlu** (2025-04-08 08:00):
@Alejandro Acevedo Osorio Attached is their fleet.yaml.

---

**Amol Kharche** (2025-04-08 08:04):
Based on the `node describe` output, it appears the customer has only 24 CPUs available to run SUSE Observability. However, to run a 100-node non-HA profile, a minimum of 25 CPUs is required, with a maximum of 50 CPUs.
```  Hostname:    dcvrssmw0
Capacity:
  cpu:                8
  Hostname:    dcvrssmw1
Capacity:
  cpu:                8  
  Hostname:    dcvrssmw2
Capacity:
  cpu:                8```

---

**Surya Boorlu** (2025-04-08 08:06):
Correct. I am also concerned about the other components cpu limits and requests. Are those the default ones?

---

**Amol Kharche** (2025-04-08 08:15):
No, it doesn’t seem to be the default setting. For example, the server pod—according to the default size for a 100 non-HA profile—should be as shown below
```    server:
      resources:
        limits:
          ephemeral-storage: 5Gi
          cpu: 8000m
          memory: 8Gi
        requests:
          cpu: 4000m
          memory: 8Gi```
However, in the customer's environment, the server pod looks like this:"
```      resources:
            limits:
              cpu: "8"
              ephemeral-storage: 10Gi
              memory: 8Gi
            requests:
              cpu: "1"
              ephemeral-storage: 1Mi
              memory: 8Gi```

---

**Surya Boorlu** (2025-04-08 08:25):
I guess they tweaked. Let me suggest the same.

---

**Devendra Kulkarni** (2025-04-08 09:25):
Hello Team,
Customer  Jemena Ltd (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTRqAAN/view) configured the OTEL Collector and have asked a question for the OTEL reciever statefulset on the server side by sharing below screenshot.
They are asking why the grpc protocol on the receiver otel collector is not using TLS? it is just using the pod ip and port. its basically connecting to self but don't see any insecure flag or tls config as well.

This is the output from *suse-observability-otel-collector-statefulset*

---

**Remco Beckers** (2025-04-08 09:47):
The receiver configuration only sets up the server-side for receiving OTLP data. So this sets ups a grpc server listening on the pod ip on port 4317 (without TLS indeed).
We recommend in our docs (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-rule-for-open-telemetry-traces-via-the-suse-observability-helm-chart) to setup an ingress for the OTLP protocols that sets up TLS so that the telemetry sources use secure communication.

From within the same cluster as SUSE Observability it will remain possible to access the collector without TLS, which is similar to all of SUSE Observabilities other APIs,

---

**Amol Kharche** (2025-04-08 10:03):
@Remco Beckers  Will otel work without having otel ingress in suse Observability? 
This is question from same customer.

---

**Remco Beckers** (2025-04-08 10:11):
For otel to "work" you need to be able to send data to SUSE Observability in otlp format. So without an ingress this is only possible from within the same cluster. You then need to send the data to the `suse-observability-otel-collector` service. If you are using the otlp grpc exporter you'll also need to configure it to allow for an insecure connection (the snippet is for the otel collector you run for your own processing, SDKs are by default ok with using an insecure grpc endpoint):
```  exporters:
    otlp/suse-observability:
      auth:
        authenticator: bearertokenauth
      # Put in your own otlp endpoint
      endpoint: <fqdn-for-otel-collector>:4317
      tls:
        insecure: true```

---

**Remco Beckers** (2025-04-08 15:30):
The easiest way to avoid the issues with grpc (though I don't understand the error right now, I've used it in this kind of setup) is to not use the grpc protocol and instead use the http version.

Looking at their config I see they are configuring both exporters in the pipelines which makes no sense. It will send the data twice to SUSE Observability, doubling the traffic volume. So it is even very undesirable.

I would suggest to completely remove the `otlp/suse-observability` configuration since they already have the `otlphttp/stackstate` setup correctly. So it (`otlp/suse-observability` ) can be removed from the pipelines and from the `exporters` section.

---

**Devendra Kulkarni** (2025-04-08 15:54):
Ok thanks for the feedback

---

**IHAC** (2025-04-09 01:16):
@Garrick Tam has a question.

:customer:  Lumen Technologies (CenturyLink)

:facts-2: *Problem (symptom):*  
(I hope this hasn't been asked as I found too many hits with notifications but many seemed like configuration types of questions.)

Customer configured a notification to alert on Aggregated health state of a Cluster, Node Readiness, Node Disk Pressure, Unschedulable Node, Node PID Pressure, Node Memory Pressure, and Certification Expiration.

The channel appears to be working as other notifications are getting through.

Although the node is in NotReady state, the StackState status for the node is CLEAR.  The node in question is mchcpddc02-test.corp.intranet and there's some error in the api pod log "Metric store query failed. ..." that references this node.

Is this a case if the metrics stopped flowing, some of the monitors will not deviate because no data points equals to no change?  Is the "Node Readiness" monitor one of these types of monitors?  Is there another monitor the customer should use to trigger a notification when the node is in a bad/down state?

---

**Garrick Tam** (2025-04-09 01:17):
Screenshots and api log.

---

**Garrick Tam** (2025-04-09 16:10):
@Remco Beckers can you please take a look?

---

**Garrick Tam** (2025-04-09 17:22):
@here, Anyone from STS engineering able to give this some time and provider pointers?

---

**Mark Bakker** (2025-04-09 19:03):
@Remco Beckers @Bram Schuur can you ask someone to look into this?

---

**Bram Schuur** (2025-04-09 19:12):
On first sight it sounds like a case the node readiness monitor should cover, so it sounds like a bug. @Alejandro Acevedo Osorio or @Frank van Lankvelt could you do an initial investigation tomorrow and create a ticket?

---

**Bram Schuur** (2025-04-09 19:14):
I'm asking someone from team marvin to do a first triage here (Marvin is supposed to do k8s integration)

---

**Alejandro Acevedo Osorio** (2025-04-10 09:37):
I’m starting to take a look … seems related to this other one reported yesterday https://suse.slack.com/archives/C079ANFDS2C/p1744226572661549 (https://suse.slack.com/archives/C079ANFDS2C/p1744226572661549) where the issue seems to be that the node is actually Ready and with workloads scheduled but we have the status lingering

---

**Alejandro Acevedo Osorio** (2025-04-10 10:38):
@Bram Schuur @Mark Bakker The root cause of this bug is the same as https://stackstate.atlassian.net/browse/STAC-22603 ... where the `nodeStatus` column is derived from the `element.sourceProperties?.status?.conditions` for the `Node` ... and those as the ticket describes a lot of time arrive incorrectly.

---

**Alejandro Acevedo Osorio** (2025-04-10 10:39):
So @Garrick Tam in this case is correct that the monitor does not trigger, the monitor relies on metrics (`kubernetes_state_node_by_condition{condition="Ready"}`) and those are correct, it's just that the `node.status` column is getting out of sync and we already have a bug ticket to track it

---

**IHAC** (2025-04-11 18:24):
@Bruno Bernardi has a question.

:customer:  Lumen Technologies (CenturyLink)

:facts-2: *Problem (symptom):*  
We'd like to know if it's possible for SUSE Observability to send data/metrics outside of the Rancher/Kubernetes cluster through an ingress.

Meaning, can we send data/metrics to the SUSE Observability cluster from a bare metal server running on-premises or a VM running in VMware?

I found this (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/ingress#configure-ingress-via-the-suse-observability-helm-chart) documentation which seems to have good explanations, but I couldn't find a direct answer to the Customer's use case.

---

**IHAC** (2025-04-14 13:58):
@Ankush Mistry has a question.

:customer:  LINUX POLSKA SP. Z O.O.

:facts-2: *Problem (symptom):*  
This customer is facing the problem with the license key as invalid, where as when checked in the portal, the key is still valid and the expiry date is 18Dec2025. I will attach the screenshots from the customer.

---

**Frank van Lankvelt** (2025-04-14 14:06):
have you tried the key with dashes or only without?  (i.e. use the format XXXXX-XXXXX-XXXXX, not XXXXXXXXXXXXXXX)

---

**Ankush Mistry** (2025-04-14 14:08):
The license key appears without dashes in the portal, however I will check this with the customer again, thanks!

---

**Ankush Mistry** (2025-04-14 14:40):
The license key here is of 16 characters as given in the portal and the key input as in the screenshot is of the 15 characters, will this make a difference?
84314-3C07D-DCF610

---

**Frank van Lankvelt** (2025-04-14 14:43):
don't know where the last character comes from, but it will/should be ignored

---

**IHAC** (2025-04-18 03:45):
@Garrick Tam has a question.

:customer:  NowCOM

:facts-2: *Problem (symptom):*  
Topology relationship lines missing for hic-gpudev01 cluster.  What can be the reason?  Please see screenshot and agent pod logs from hic-gpudev01 cluster.

---

**Garrick Tam** (2025-04-18 03:46):
Here's the screenshot of the issue and the agent pod logs.  The server log includes the error from STAC-22148 but customer raised the limit from 1000 to 1200 to overcome the error.

---

**Garrick Tam** (2025-04-18 18:23):
@here bump, Anyone available to take a look at this for me?

---

**IHAC** (2025-04-21 18:45):
@Rodolfo de Almeida has a question.

:customer:  Jemena Ltd

:facts-2: *Problem (symptom):*  
The customer is attempting to use the Rancher proxy to access the SUSE Observability UI. Their teams log in to Rancher to manage their respective clutsters, and they would like to enable them to monitor these clusters through SUSE Observability, ideally via Rancher.
I found a slack thread and believe this is not able yet. https://suse.slack.com/archives/C07CF9770R3/p1740139984335789

At the moment, when the user clicks the `suse-observability-router` service's router link, it takes them to -&gt; `https://&lt;rancher_load_balancer&gt;/k8s/clusters/c-m-94q84sll/api/v1/namespaces/suse-observability/services/http:suse-observability-router:8080/proxy/#/`, however they just get the;

```"Something went wrong
Whoops, it looks like we are having trouble receiving data.
Please contact your administrator or wait a few minutes and try to reload the page..."```
Is there any workaround to achieve it?
Do we have an expected version to deliver this integration?

---

**Garrick Tam** (2025-04-21 23:59):
Here's the log bundles from both the Observability cluster and the agent cluster (hic-gpudev01) where topology is not working.  The agent on hic-gpudev01 cluster is installed into the default namespace and not suse-observability.

---

**Garrick Tam** (2025-04-22 00:02):
Really appreciate someone's assistance and pointer.  TIA

---

**Vladimir Iliakov** (2025-04-22 08:37):
Yes, it is exactly what Ingress Controller is used for. There is more on this topic https://kubernetes.io/docs/concepts/services-networking/ingress/

---

**Bram Schuur** (2025-04-22 09:35):
Dear Garrick, the ntp issue is almost certain an unrelated issue, we have story on the backlog to fix that one.
The behavior you describe (not seeing topology) aswell as the unauthorized give me two hypotheses:
• The wrong api key was put in for the nodes you are observing (please check, less likely).
• You are sending more data than the instance is configured. If you open the platform and look at the system  notifications menu top-right, you might see that the data is being limited. This means a bigger profile should be chosen.

---

**Bruno Bernardi** (2025-04-22 15:48):
Thanks @Vladimir Iliakov. I tested this configuration with the customer and also in my lab and it seems to work very well.

---

**Rodolfo de Almeida** (2025-04-22 15:50):
@Amol Kharche Have you already received a request like this?

---

**Garrick Tam** (2025-04-22 23:09):
The customer confirmed she is aware of the fact she did not correct the API key in two of her clusters so point 1 is moot.  I asked the customer to check on point 2 but in my lab even though I reached the node limit, I can still see topology for new clusters I'm adding.  The topology relationships hints at a node within a cluster or pod within a node.  We are not seeing any of this on the hic-gpudev01 cluster.  Can we please have someone dig deeper into the logs and see why this is?

---

**Garrick Tam** (2025-04-22 23:39):
Customer confirmed she see a node limit error from Saturday.  She uninstall agent from two clusters and now left with below two clusters:
- hic-gpudev01 - 3 nodes
- hellotest - 1 node

---

**IHAC** (2025-04-22 23:44):
@Garrick Tam has a question.

:customer:  Lumen Technologies (Centurylink)

:facts-2: *Problem (symptom):*  
Observability Dashboard is slow to load and sometimes throws the error "something went wrong".  See https://suse.slack.com/archives/C079ANFDS2C/p1745016287421319 for history of how customer got into this situation.

---

**Garrick Tam** (2025-04-23 00:01):
Can someone please help me identify what went wrong and how to recover?

---

**Garrick Tam** (2025-04-23 00:03):
Here's a screenshot of the issue and logs bundle.

---

**Amol Kharche** (2025-04-23 05:18):
I did not , but suse-observability-router is an internal service and cannot directly expose to outside to access suse observability UI, Is customer not using ingress here? What is in the `baseurl`?

---

**Amol Kharche** (2025-04-23 06:18):
Looking at the logs , Looks like customer using `150-ha` profile and The node is heavily utilized, particularly memory is almost maxed out, and CPU is overcommitted. and can see some probes failed in HBase as well.
```Node:- rnchobsddc01-prod
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests       Limits
  --------           --------       ------
  cpu                21380m (76%)   37420m (133%)
  memory             44868Mi (89%)  49412Mi (98%)

Node: rnchobsddc02-prod
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests       Limits
  --------           --------       ------
  cpu                19210m (68%)   32450m (115%)
  memory             42154Mi (83%)  43360Mi (86%)

Node: rnchobsddc03-prod
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests       Limits
  --------           --------       ------
  cpu                20685m (73%)   35410m (126%)
  memory             44456Mi (88%)  45294Mi (90%)

-------------------------------------------------------------------------------------------------------------------------------------------------
LAST SEEN   TYPE      REASON      OBJECT                                    MESSAGE
9m10s       Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-1   Liveness probe failed: command "/rs-scripts/check-status.sh" timed out
9m10s       Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-1   Readiness probe failed: command "/rs-scripts/check-status.sh" timed out
9m10s       Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-2   Liveness probe failed: command "/rs-scripts/check-status.sh" timed out
9m10s       Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-2   Readiness probe failed: command "/rs-scripts/check-status.sh" timed out
43s         Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-0   Liveness probe failed: command "/rs-scripts/check-status.sh" timed out
43s         Warning   Unhealthy   pod/suse-observability-hbase-hbase-rs-0   Readiness probe failed: command "/rs-scripts/check-status.sh" timed out```
Do you know how many clusters(nodes) customer currently observing in stackstate cluster?
Cc: @Bram Schuur

---

**Louis Lotter** (2025-04-23 09:34):
@Bram Schuur Do we need to advise them to move to a bigger profile ?

---

**Bram Schuur** (2025-04-23 09:38):
@Louis Lotter yes, this is the most likely outcome. But I'd like to know first how many 'default nodes' are being observed. We might be looking at some other performance issue, also, knowing the amount of 'default nodes' will tell us which profile to pick. @Garrick Tam could you ask the customer how many 'default nodes' are observed now? (https://stackstate.atlassian.net/browse/STAC-22682).

---

**Bram Schuur** (2025-04-23 09:53):
@Garrick Tam I have taken a look at the logs. The server log is a bit spammy with warning but those should not be related to what you are seeing. A couple of questions to further the investigation:
• Could you, instead of looking at the overview, investigate a single pod to see whether connectivity is there? I ask this, because our overview page has a cutoff, so the data could be there, but we do not have time to process the view (especially since the maxElements was upped, this can be an issue).
• Could you get not only the 'node-agent' container logs from the cluster that shows no connection, but also the 'process agent' logs, this is a separate container in the node agent.

---

**Rodolfo de Almeida** (2025-04-23 16:36):
@Amol Kharche
The customer does not want to use ingress in this case.
 They would like to access SUSE Observability in the same way they currently access tools like NeuVector and Longhorn—when those are installed in a downstream cluster managed by Rancher. I am attaching a screenshot to make it more clear.
*Use case summary:*
• Rancher authentication is enabled, and users log in to the Rancher UI using this method.
• Access to tools and applications is managed via Rancher RBAC.
• They want to provide users access to SUSE Observability directly through the Rancher UI.
For now the icon is not required, but if we have a manual method to do that would be great.
Is this possible?

---

**Garrick Tam** (2025-04-23 18:36):
@Bram Schuur The process-agent.log is part of the log collection bundle here --&gt; https://suse.slack.com/files/U02L471680K/F08P66DQ45A/hic-gpudev01-default_logs_20250421092823.tar.gz.

---

**Garrick Tam** (2025-04-23 18:45):
~What is 'default nodes'?  Is that the total number of k8s nodes from all clusters where the agents are deployed?~  I found the definition https://docs.stackstate.com/self-hosted-setup/install-stackstate/requirements#resource-requirements.

---

**Garrick Tam** (2025-04-23 18:57):
Is there a process for the customer to migrate to a higher profile without reinstallation/data loss?

---

**Garrick Tam** (2025-04-23 18:59):
Also, please keep in mind this symptom started after we we troubleshooting authentication and enable debug logging.  I still suspect there's some internal report generation that failed due to debug logging resource contention and/or troubleshooting api pod restart that landed this deployment in this broken state.  Anyway to recover?

---

**Garrick Tam** (2025-04-23 19:25):
@Amol Kharche how did you come to determine the profile is 150-HA?

---

**Garrick Tam** (2025-04-23 20:14):
Here's the `kubectl top nodes` output which list 68 physical nodes.  Rounding the millicores to thousand and summing the Mi to GB, we get 358CPU/7150GB total cores and GB or memory.

---

**Garrick Tam** (2025-04-23 20:40):
Customer confirmed she is able to only select on fleet agent and see connections.
Is this caused by what you stated where the view generation timed out?  Anyway to fix this and have connection build for all objects?

---

**Amol Kharche** (2025-04-24 05:05):
&gt; how did you come to determine the profile is 150-HA?
From environment variable set in `checks, notifications, api, etc` pods which is basically comes from `sizing_values.yaml`
```- name: CONFIG_FORCE_stackstate_agents_agentLimit
  value: "150"```

---

**Amol Kharche** (2025-04-24 05:16):
Our `default node` configuration is *4 vCPUs* and *16 GB* of memory. Based on the customer's environment, if we calculate the number of required nodes using their available memory (7150 GB), it comes out to approximately `7150 / 16 = 446 nodes` .
This exceeds the limit (2400 GB) set by the `150ha`profile, which means the 150ha profile is not suitable for this scenario. To support this number of nodes, they would need at least a `500ha` profile.
@Bram Schuur please correct me if I've miscalculated anything here.

---

**Garrick Tam** (2025-04-24 05:41):
How does the formula work?

---

**Garrick Tam** (2025-04-24 05:42):
I guessed when I asked for kubectl top nodes.   What values should be used for calculating?

---

**Garrick Tam** (2025-04-24 05:44):
This day gap between our correspondent is not working and will certainly result with customer frustration

---

**Amol Kharche** (2025-04-24 05:45):
I did not check `kubectl top nodes` output , I assumed you had already calculated the total CPU and memory, which came out to 7150 GB of memory. So I just divided 7150 by 16 directly.

---

**Garrick Tam** (2025-04-24 05:46):
What is the formula and with what values from where?

---

**Garrick Tam** (2025-04-24 05:49):
Top output is not the same as describe node capacity values

---

**Amol Kharche** (2025-04-24 05:52):
Correct, I assumed you already know customer environment about total cpu/memory and shared information here. So I directly divided with default node size.
https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#requirements
```If nodes in your observed cluster are bigger, they can count for multiple default nodes, so a node of 12vCPU and 48GB counts as 3 default nodes under observation when picking a profile.```

---

**Amol Kharche** (2025-04-24 05:57):
Can we first gather the total CPU and memory for the observed clusters/nodes from customer, and then determine which profiles are most appropriate?
If it doesn’t appear to be a profile-related issue, we can investigate further.

---

**Garrick Tam** (2025-04-24 06:03):
Which values equal to total values?   Capacity from node describe or some other value in another place?

---

**Garrick Tam** (2025-04-24 06:05):
And what is the formula?   How do you calculate a node with 4vCPU/48GB memory?   Or 16vCPU/12GB memory?  Are both these one observed node or both 3 observed node or neither?

---

**Amol Kharche** (2025-04-24 06:09):
So basically customer need to tell us total node size and calculate it by dividing our default size. As I mentioned earlier I thought you already knew this information and pasted here https://suse.slack.com/archives/C07CF9770R3/p1745432078453569?thread_ts=1745358258.303199&amp;cid=C07CF9770R3

Lets have a call ?

---

**Garrick Tam** (2025-04-24 06:12):
Thanks for the offer but my day is done and I'm only on my phone.  I hope you or someone else can reply to my other questions on this thread?

---

**Amol Kharche** (2025-04-24 06:33):
That's an interesting to watch engineering reply.
https://suse.slack.com/archives/C07CF9770R3/p1745467523091599?thread_ts=1745358258.303199&amp;cid=C07CF9770R3

---

**Amol Kharche** (2025-04-24 07:38):
I believe this method of accessing SUSE Observability in Rancher isn't available yet. Currently, we only have the extension, but it requires an HTTPS URL rather than a router service.
 @Bram Schuur do you know if there's a way to achieve this?

---

**Amol Kharche** (2025-04-24 08:12):
Hi Team,
One of the customer(Jemena) has done pentest where socket exposure was picked up by the SUSE Observability node agent. See attached report.
Is there anything we can do about this?

---

**Louis Lotter** (2025-04-24 08:59):
@Louis Parkin can you take a look ?

---

**Louis Lotter** (2025-04-24 09:34):
You need to remember that this is all just our best attempt at predicting load generated. Do your best to convert smaller or larger nodes to our default nodes and then try to predict what size cluster they need. But at the end of the day they will have to check how well it works in terms of scaling and may have to go up or down depending on the actual load generated.

---

**Louis Lotter** (2025-04-24 09:35):
Every customer is different. some generates a lot more load just due to the work being done on these nodes

---

**Louis Lotter** (2025-04-24 09:35):
I know it would be better to have exact answers but that's simply not possible.

---

**Bram Schuur** (2025-04-24 09:37):
On first read-through of this seems like another instance where we need access to system-wide information that is regarded as a 'security breach'. I already wrote a story for Marc last week around this: https://stackstate.atlassian.net/browse/STAC-22672

I would propose to put this on that pile and look through that in the context of this tory. E.g. properly document all right the agent needs and thus allowances that are needed in security scanners

---

**Bram Schuur** (2025-04-24 09:38):
While at the same time investigating whether we can drop some of those permissions (in which case it would be hard to explain why we need them obviously)

---

**Louis Parkin** (2025-04-24 09:41):
I think this is indeed confusing desired behaviour with a CVE. We mount the containerd socket intentionally. I think we need it for container discovery.

---

**Bram Schuur** (2025-04-24 09:41):
The formula is as follows: Per node, devide both cpu and memory by the default node values, pick the max of those two. `max(node_cpu/default_node_cpu, node_memory/default_node_memory)`

---

**Louis Parkin** (2025-04-24 09:42):
We can remove the mount and see, but my guess is we will lose functionality.

---

**Bram Schuur** (2025-04-24 09:42):
yeah exactly, that is why i wrote the earlier story, we should do the experiment you describe and document what we find or indeed rmeove it

---

**Bram Schuur** (2025-04-24 09:47):
@Amol Kharche Based on you calculation the 500ha profile seems the right one to pick indeed

---

**Bram Schuur** (2025-04-24 13:07):
I do not know of one, I am sure we did not productize one.

---

**Bram Schuur** (2025-04-24 13:07):
I will write a story for this

---

**Bram Schuur** (2025-04-24 13:11):
https://stackstate.atlassian.net/browse/STAC-22690

---

**Bram Schuur** (2025-04-24 13:25):
Dear Garrick I dug deeper into into the process agent logs and conclude that indeed 'node limiting' is being applied. See the image below.

The reason you are able to see topology from the nodes that are limited, is that limiting is only applied to the 'network connection' part of our topology (processes, http/tcp traffic), the kubernetes part of the topology will never be limited. This is also why you see some of the pod topology in the image you posted (but no tcp connectivity there, which is vital for inter-pod connectivity).

For this reason, please make sure the node limiting is gone from the system tray, either, by removing some nodes, or moving to a bigger profile. This should bring the tcp connectivity and connect the services overview picture.

---

**Bram Schuur** (2025-04-24 13:26):
There is no process to move to a higher profile without dataloss right now.

---

**Louis Lotter** (2025-04-24 13:27):
Thanks Bram and Louis.

---

**Amol Kharche** (2025-04-24 13:34):
What should I inform to customer?  I am confused and I didn't get the final outcome here.

---

**Louis Parkin** (2025-04-24 13:36):
@Amol Kharche we have a ticket to investigate whether or not mounting the containerd socket is a hard requirement for us.  Both myself and @Bram Schuur think it is (required for the node-agent to collect containers).

Tell the customer it is not a CVE, it is required for the agent to do it's job of collecting container information.

---

**Louis Parkin** (2025-04-24 13:37):
In other words, we know about it because we do it on purpose.

---

**Amol Kharche** (2025-04-24 13:41):
Cool, Thanks.

---

**Amol Kharche** (2025-04-24 13:41):
By the way I already informed to customer that it required to collect logs saying.
```For the node-agent see also https://docs.stackstate.com/get-started/k8s-quick-start-guide#prerequisites-for-kubernetes (the last bullet point):

process-agent needs privileged to collect network connectivity functionality
node-agent needs host access to collect host metrics

The logs agent needs to access the hostPaths to be able to read the log files from the containers.```

---

**Rodolfo de Almeida** (2025-04-24 14:52):
Thanks @Amol Kharche and @Bram Schuur
That feature request will be really helpfull.
Today we can access NeuVector and Longhorn as soon as they are installed using the Rancher Apps and it is not required user configurations to achieve it.
We also have lots of customers using Rancher as an authentication and authorization tool to give users access to applications.

---

**Garrick Tam** (2025-04-24 19:19):
Thank you for clarifying the default node calculations and recommendation.  I have the following questions:
1. Why did this began to happy only after we enabled debug logging?  The observed nodes did not change.
2. Can the system recover if we reduce the observed nodes by removing kubernetes instances?
3. In practice, is it better to select a profile one larger than anticipate given there is no way to up the profile without data loss?

---

**Garrick Tam** (2025-04-24 19:50):
Thank you, @Bram Schuur Your analysis will help me handle similar cases in the future.

---

**Daniel Barra** (2025-04-24 19:57):
*We are pleased to announce the release of 2.3.2, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.2).*

---

**Bram Schuur** (2025-04-28 09:32):
Dear Garrick,
Trying to answer as best i can:
1. Debug logging can slow the system down, but the moment debug logging is disabled the system should be at full speed again. I have no other explanation here, we might be looking at a correlation/causation mixup? (E.g. the system became slow due to ingesting ~500 default nodes worth of data into a 150-ha instance, at the same time as enabling debug logging?).
2. Yes, if you install a `150-ha` profile and bring down the load to 150 default nodes, the system should recover. 
3. Yes, it is for sure smart to install with final sizing in mind, and always round up the profile (e.g. using a 500-ha for a 300 default node environment). Lossless upgrading is a feature that we would like to make, but is not on the immediate roadmap.

---

**Devendra Kulkarni** (2025-04-28 14:55):
Hello Team,
One of the customers Jemena Ltd (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTRqAAN/view) is asking if they can utilise ArgoCD by some means to deploy MetricBinding resources? As per the docs, currently it needs STS cli.

They also asked if there is a way to create a long-lived service-token on bootstrap? As they want to use it for all API operations.

---

**Louis Lotter** (2025-04-28 15:20):
Would it be possible for them to  configure an ArgoCD hook to run a Job or script that executes the necessary `sts metric-binding apply` command ?
@Vladimir Iliakov @Bram Schuur would this be what you would suggest here ?

---

**Bram Schuur** (2025-04-28 15:22):
I'm not devops savvy enough to say what is the best practice here.

---

**Louis Lotter** (2025-04-28 15:23):
the long lived token should also be possible but sounds a bit sketchy.

---

**Vladimir Iliakov** (2025-04-28 15:28):
As long as STS can't be managed via K8s CRD I wouldn't do that via ArgoCD.

---

**Vladimir Iliakov** (2025-04-28 15:31):
But yeah, it is possible to create a Docker image with sts-cli and Bash wrapper over it and use it in the Kubrnetes job that can be deployed with ArgoCD

---

**Garrick Tam** (2025-04-28 16:45):
Thank you for your answers.

---

**David Noland** (2025-04-28 18:12):
I get this when I go to secrets (https://rancher-hosted.app.stackstate.io/#/views/urn:stackpack:kubernetes-v2:shared:query-view:secrets?timeRange=LAST_3_HOURS):

---

**Vladimir Iliakov** (2025-04-28 19:52):
There are few endpoints returning 403. The tenant was updated to `suse-observability-2.3.2-pre.54`. @Bram Schuur might it be somehow related to RBAC work, just speculating.... ?

---

**Vladimir Iliakov** (2025-04-28 19:53):
The tenant was updated 5 days ago. @David Noland when was the last time it worked as expected?

---

**David Noland** (2025-04-28 19:54):
Not sure, haven't tried in probably over a month, maybe longer

---

**Vladimir Iliakov** (2025-04-28 19:57):
Configmaps are broken in the same way. The rest of the views are ok.

---

**Bram Schuur** (2025-04-28 20:25):
@Vladimir Iliakov could be rbac, could be something else. I will file a ticket first thing in the morning.

---

**Vladimir Iliakov** (2025-04-28 20:27):
I just checked the other similar tenant rancher-pasture it has the same version and configuration: it works fine. Lets return to it tomorrow...

---

**David Noland** (2025-04-28 21:43):
ok, thanks for having a look. Not urgent, so fine if you guys investigate further tomorrow. No reason to stay up late

---

**Amol Kharche** (2025-04-29 09:19):
Hey team,
quick question — does anyone know why we’re seeing the message _"No monitors found for this component."_ under the *SUSE Observability* section for deployments and pods?
Curious what the expected use cases are for this. Thanks!

---

**Bram Schuur** (2025-04-29 09:39):
I wrote the ticket to keep track of this: https://stackstate.atlassian.net/browse/STAC-22700

---

**Bram Schuur** (2025-04-29 09:41):
@Vladimir Iliakov could you give me access to the rancher-hosted instance to also investigate this issue?

---

**Vladimir Iliakov** (2025-04-29 09:48):
@Bram Schuur you should have an invite in your mailbox

---

**Bram Schuur** (2025-04-29 09:55):
thanks! I updated the ticket, i think it is related to an existing issue. I'll see whether we can squeeze in a fix there shortly

---

**Daniel Barra** (2025-04-29 12:12):
Hello Amol, there is a bug open to fix that issue!

---

**Amol Kharche** (2025-04-29 12:49):
Can you share ticket number.

---

**Daniel Barra** (2025-04-29 14:04):
https://stackstate.atlassian.net/browse/STAC-22595

---

**David Noland** (2025-04-29 16:39):
thanks for having a look

---

**Remco Beckers** (2025-04-30 09:06):
A bootstrap service token can be setup: https://docs.stackstate.com/self-hosted-setup/security/authentication/service_tokens#set-up-a-bootstrap-service-token. The ttl is optional so it can be left out to get an indefinitely valid token. Alternatively you can set a long ttl.

The more secure option would be to set up some automation after installing SUSE observability that uses the bootstrap token with a short ttl to create a new service token using the sts cli or api.

---

**Amol Kharche** (2025-05-02 08:15):
Hi Team,
One of the customer National University of Singapore (https://suse.lightning.force.com/lightning/r/Account/001Tr000005e1nKIAQ/view) recently applied an OS patch (RHEL 9 update) and rebooted the node. Since then, the `suse-observability-elasticsearch-master-0` pod has not been coming up.
The customer attempted to redeploy through helm, but the it is failing. Could you please assist us in investigating and resolving this issue?

---

**Vladimir Iliakov** (2025-05-02 08:37):
It is not able to start within livenessProbe time...

---

**Vladimir Iliakov** (2025-05-02 08:38):
Let me find a value to increase the limit

---

**Vladimir Iliakov** (2025-05-02 08:44):
The can redeploy Suse Observability Chart with
```--set elasticsearch.livenessProbe.initialDelaySeconds: 170```
adding to the end of the `helm upgrade ...` command.
It will give it two minutes to start...

---

**Amol Kharche** (2025-05-02 08:45):
I will ask them to try it out. Thanks.

---

**Vladimir Iliakov** (2025-05-02 08:49):
Maybe the node Elasticsearch is running on has some performance issues: high CPU load or high Load Average, which slows down ES

---

**Vladimir Iliakov** (2025-05-02 08:50):
The node is quite big 32vCPUs, though most of the pods don't have requests/limits set, which might affect the node and its pods performance
```  Namespace                   Name                                                               CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                                               ------------  ----------  ---------------  -------------  ---
  argo-cd                     argo-cd-7-1735029407-argocd-application-controller-0               0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d10h
  argo-cd                     argo-cd-7-1735029407-argocd-dex-server-7bddbdf49d-j56dq            0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d10h
  argo-cd                     argo-cd-7-1735029407-redis-ha-haproxy-68c759854-qgd26              0 (0%)        0 (0%)      0 (0%)           0 (0%)         26d
  argo-cd                     argo-cd-7-1735029407-redis-ha-server-1                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         26d
  calico-system               calico-node-bsq2l                                                  0 (0%)        0 (0%)      0 (0%)           0 (0%)         27d
  calico-system               calico-typha-7b699b8c58-r2g5k                                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         27d
  cattle-neuvector-system     neuvector-controller-pod-857c578f7b-cr4s2                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         34d
  cattle-neuvector-system     neuvector-enforcer-pod-2gsjc                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         35d
  cattle-neuvector-system     neuvector-scanner-pod-7668ffdccd-tcccx                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         5h44m
  iperf3                      iperf3-tq6n2                                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         93d
  isilon                      isilon-controller-6f96cf7f68-q6qnt                                 0 (0%)        0 (0%)      0 (0%)           0 (0%)         2d21h
  isilon                      isilon-node-kw7b9                                                  0 (0%)        0 (0%)      0 (0%)           0 (0%)         66d
  kube-system                 kube-proxy-vrntwkprd101.nus.edu.sg (http://kube-proxy-vrntwkprd101.nus.edu.sg)                                 250m (0%)     0 (0%)      128Mi (0%)       0 (0%)         3d16h
  kube-system                 rke2-coredns-rke2-coredns-797bf7dd6-8fz8c                          100m (0%)     100m (0%)   128Mi (0%)       128Mi (0%)     27d
  kube-system                 rke2-ingress-nginx-controller-qf7n5                                100m (0%)     0 (0%)      90Mi (0%)        0 (0%)         27d
  kube-system                 vsphere-csi-node-6929k                                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         27d
  loki                        loki-canary-mkzbz                                                  0 (0%)        0 (0%)      0 (0%)           0 (0%)         64d
  loki                        loki-distributor-55f46c6c-vrt7c                                    0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-index-gateway-2                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-index-gateway-3                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-index-gateway-4                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-index-gateway-5                                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-ingester-zone-c-0                                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         9d
  loki                        loki-ingester-zone-c-1                                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         9d
  loki                        loki-querier-6898fff45b-5xpdw                                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d11h
  loki                        loki-querier-6898fff45b-kvc8k                                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d11h
  loki                        loki-query-frontend-55c5d6ff8d-svzmm                               0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-query-scheduler-55c7ffc745-cgv5z                              0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-query-scheduler-55c7ffc745-fgx9m                              0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-query-scheduler-55c7ffc745-kgkrc                              0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        loki-query-scheduler-55c7ffc745-vzsrg                              0 (0%)        0 (0%)      0 (0%)           0 (0%)         8d
  loki                        promtail-dvdvn                                                     0 (0%)        0 (0%)      0 (0%)           0 (0%)         147d
  promstack                   promstack-prometheus-node-exporter-j22hp                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         4d10h
  suse-observability          suse-observability-agent-logs-agent-tqtbr                          20m (0%)      1300m (4%)  100Mi (0%)       192Mi (0%)     13d
  suse-observability          suse-observability-agent-node-agent-c8r2x                          45m (0%)      395m (1%)   308Mi (0%)       820Mi (1%)     13d
  suse-observability          suse-observability-correlate-84fcb897cb-fklg7                      5 (15%)       10 (31%)    4000Mi (6%)      4000Mi (6%)    4d10h
  suse-observability          suse-observability-elasticsearch-master-0                          750m (2%)     1500m (4%)  7Gi (11%)        7Gi (11%)      167m
  suse-observability          suse-observability-prometheus-elasticsearch-exporter-7fc977srmx    100m (0%)     100m (0%)   100Mi (0%)       100Mi (0%)     49d
  suse-observability          suse-observability-victoria-metrics-0-0                            1500m (4%)    3 (9%)      8Gi (12%)        8Gi (12%)      35d
  vault                       vault-2                                                            0 (0%)        0 (0%)      0 (0%)           0 (0%)         25d```

---

**Amol Kharche** (2025-05-02 08:53):
Yeah,Might be

---

**Amol Kharche** (2025-05-02 08:56):
I can see some load on server but from Memory and CPU perspective its seems to idle.
``` 10:52:39 up 3 days, 13:36,  2 users,  load average: 6.56, 6.17, 6.14```
```top - 10:52:44 up 3 days, 13:37,  2 users,  load average: 6.68, 6.20, 6.15
Tasks: 987 total,   2 running, 985 sleeping,   0 stopped,   0 zombie
%Cpu(s): 10.4 us,  7.5 sy,  0.3 ni, 73.3 id,  6.0 wa,  0.9 hi,  1.6 si,  0.0 st
MiB Mem :  63759.4 total,  17390.6 free,  22361.2 used,  24726.6 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.  41398.2 avail Mem 


               total        used        free      shared  buff/cache   available
Mem:           63759       22225       17527          10       24722       41533
Swap:              0           0           0```

---

**Vladimir Iliakov** (2025-05-02 08:59):
Yes, it looks ok

---

**Vladimir Iliakov** (2025-05-02 09:14):
Right :thumbs-up:

---

**Amol Kharche** (2025-05-05 09:48):
Hi Team,
Customer Ministere de l'Agriculture (https://suse.lightning.force.com/lightning/r/Account/0011i00000MplwIAAR/view) would like to create many views in suse observability but the documentation don't mention any information's to create view programmatically (API or cli).
Is it possible to do this?

---

**Frank van Lankvelt** (2025-05-05 13:42):
With the cli it certainly is possible to import settings files (`.sty`) that define views.  This also allows updates.

---

**Amol Kharche** (2025-05-05 13:48):
Any command reference?  So then it should to be present in earlier settings? Right
And how to create views through cli/API if it not in settings file(New views).

---

**Frank van Lankvelt** (2025-05-05 14:42):
From the top of my head it's `sts settings apply`, but the cli provides help that should get you going

---

**Amol Kharche** (2025-05-05 17:06):
`sts settings apply`  help to import settings, What If I want to create multiple views from command line?
```Usage:
  sts settings apply --file FILE [flags]```

---

**Amol Kharche** (2025-05-08 09:06):
Then we manually edited sts `suse-observability-elasticsearch-master`  but still failing.

---

**Amol Kharche** (2025-05-08 09:11):
Ingnore above message, Its running now

---

**Amol Kharche** (2025-05-08 09:56):
This is the helm upgrade output

---

**Amol Kharche** (2025-05-08 09:57):
We are in a call with customer

---

**Vladimir Iliakov** (2025-05-08 10:02):
Were there any changes in the values?

---

**Amol Kharche** (2025-05-08 10:03):
They have 2.3.0 and they mistakenly upgraded to v.2.3.2 and they again installed v2.3.0

---

**Amol Kharche** (2025-05-08 10:04):
All messed up

---

**Amol Kharche** (2025-05-08 10:04):
Now they want to install SUSE Observability any version.

---

**Vladimir Iliakov** (2025-05-08 10:05):
I can't say why it tries to update the immutable fields: lets collect some info:
1 - the current version
`helm status suse-observability`
`helm history suse-observability`
`helm get values suse-observability`

---

**Vladimir Iliakov** (2025-05-08 10:07):
They can try to delete the statefulsets and run `helm upgrade/install` again

---

**Vladimir Iliakov** (2025-05-08 10:08):
&gt; They have 2.3.0 and they mistakenly upgraded to v.2.3.2 and they again installed v2.3.0
I don't see how it might be reasons for the errors.

---

**Amol Kharche** (2025-05-08 10:08):
Let me give output of helm 3 commands

---

**Vladimir Iliakov** (2025-05-08 10:10):
<!subteam^S08HHSW67FE> <!subteam^S08HEN1JX50> can you think of any changes that were added recently ~2.3.x that might cause these update errors https://suse.slack.com/archives/C07CF9770R3/p1746690915549039?thread_ts=1746166551.138639&amp;cid=C07CF9770R3?

---

**Vladimir Iliakov** (2025-05-08 10:12):
@Amol Kharche it is either a breaking changes between versions, but most likely that would have been caught in our own environments. Or they messes up the installation.

---

**Amol Kharche** (2025-05-08 10:16):
I am also thinking they messed with installation

---

**Bram Schuur** (2025-05-08 10:18):
part of the errors is about the svc ports, i reordered them here: https://gitlab.com/stackvista/devops/helm-charts/-/merge_requests/1472/diffs#diff-content-f8daaf65d7198458dbf34b7f89e457ff7e79c0a1, but this upgraded fine everywhere, so i am very doubtful this change somehow would break things. To me it looks like a botched installation

---

**Vladimir Iliakov** (2025-05-08 10:36):
BTW, what version of helm do they use?

---

**Amol Kharche** (2025-05-08 10:37):
Its fixed now after after deleting stss and redeploying with v2.3.2

---

**Hugo de Vries** (2025-05-08 14:51):
Hi team, Rabobank just escalated ticket *1483* with me, they have an issue that started on may 4th and they need to have it resolved asap. Marc Rue Herrera is on PTO so would be great to get your support asap.

---

**Bram Schuur** (2025-05-08 15:00):
i will get in contact

---

**Bram Schuur** (2025-05-08 15:00):
(heads up to @Alejandro Acevedo Osorio if i do not resolve this today i might have to hand over to you for tomorrow

---

**Bram Schuur** (2025-05-08 15:01):
@Hugo de Vries i sent mitesh a meeting invite, could you le thim know i am available?

---

**Alejandro Acevedo Osorio** (2025-05-08 15:14):
@Bram Schuur let me know if we need to sync up on it

---

**Bram Schuur** (2025-05-08 15:19):
gotcha, we're looking at an 'vertex/element missing exception' form the sync service and the pod blocking.

---

**Alejandro Acevedo Osorio** (2025-05-08 15:21):
Want me to join you already? Although that symptom sounds like we don't have that many options

---

**Bram Schuur** (2025-05-08 15:28):
yes please, it seems to be stackgraph unfortunately:

To join the video meeting, click this link: https://meet.google.com/dbx-vogr-bee
Otherwise, to join by phone, dial <tel:+31202575180|+31 20 257 5180> and enter this PIN: 467 462 179#
To view more phone numbers, click this link: https://tel.meet/dbx-vogr-bee?hs=5

---

**Daniel Barra** (2025-05-08 18:42):
*We are pleased to announce the release of 2.3.3, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.3).*

---

**Garrick Tam** (2025-05-08 19:05):
Hello.  I see https://stackstate.atlassian.net/browse/STAC-22148 is marked as Resolved.  How can I find out if the code fix is part of a specific release?  Can someone teach me how to discern such information from the Jira or some where?

---

**Garrick Tam** (2025-05-08 19:19):
Same question for https://stackstate.atlassian.net/browse/STAC-22603.

---

**Daniel Barra** (2025-05-08 19:57):
Since the "Release notes" field wasn't completed on the ticket, it wasn't included in the notes. I've confirmed that the associated Merge Request (MR) was merged into the master branch before the release freeze. I'll double-check with the team, but it appears the change is already present in the release.

---

**Hugo de Vries** (2025-05-09 12:53):
Nice work getting them back up an running! :pray:

---

**Garrick Tam** (2025-05-09 18:57):
Can you please confirm which Jira to which Release?
STAC-22148 (https://stackstate.atlassian.net/browse/STAC-22148) --&gt; Release?
STAC-22603 (https://stackstate.atlassian.net/browse/STAC-22603). --&gt; Release?

---

**Daniel Barra** (2025-05-12 12:42):
@Garrick Tam sorry about the delay;
"they were both released with 2.3.2"
We updated the ticket to have fixed version info! :slightly_smiling_face:

---

**Javier Lagos** (2025-05-12 16:27):
Hello team! I have been working in a customer case 01580210 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000ZVN18IAH/view?ws=%2Flightning%2Fr%2FEmailMessage%2F02sTr00000Y02BCIAZ%2Fview) where the customer is asking for some help configuring environments on SUSE Observability. The customer wants to configure a new environment called test and associate all from a specific cluster to this new test environment. I have been trying on my lab by creating a new SUSE Observability server and by adding a new monitored cluster through a stackpack called "test" and it seems that by default the objects and cluster are assigned automatically with the environment=production label (please see attached screenshot) .
I have configured a new environment within Settings -> Environment called test to help the customer but even after pointing to the cluster ID correctly the cluster's properties are still pointing to environment prod (Please see attached screenshot)

Is there any way to achieve this custom configuration by splitting the objects across environments? How can we do it?

TIA!

---

**Garrick Tam** (2025-05-12 19:41):
Thank you.

---

**Javier Lagos** (2025-05-13 13:17):
Can you please help me here @Remco Beckers? Is what the customer is trying to configure possible? I have not been able to separate the objects on the UI on different environments as they always get created with "Production" label.

---

**Louis Lotter** (2025-05-13 14:09):
@Alejandro Acevedo Osorio can you take a look here maybe. Or who else could help here ?

---

**Alejandro Acevedo Osorio** (2025-05-13 14:21):
@Javier Lagos currently is pretty hard to configure that `environment` label (is pretty much considered obsolete and probably about to be deprecated), we would need to modify more than a couple of stackpacks settings that belong to the K8s stackpack. So I'd treat it as non configurable. @Remco Beckers @Bram Schuur do you have a different opinion on this one?

---

**Remco Beckers** (2025-05-13 14:42):
The `labels` function as the alternative and are more flexible

---

**Javier Lagos** (2025-05-13 15:06):
@Alejandro Acevedo Osorio Thanks a lot for your answer. Does it mean that we can expect to have this environment production by default decommissioned and deleted in future versions? I think that putting by default environment=Production by default is creating some confusions already to some customers. Do we have any expected ETA or release version where this is gonna be deleted?

@Remco Beckers Thanks a lot as well! Can you please elaborate a bit more about this `labels` functions? Lets imagine a situation where the customer wants to monitor 4 clusters called prod1,prod2, test1 and test2 and they want to group prod1,prod2 under prod environment/labels and test1,test2 under test environment/Labels. Is there any easy way to achieve this? Have we considered to add this as a RFE in a future version?

TIA!

---

**Louis Lotter** (2025-05-13 15:41):
@Alessio Biancalana @Andrea Terzolo

---

**Alejandro Acevedo Osorio** (2025-05-13 15:47):
I don't think there's already a target release version where this is decommissioned as the value is not used at all but probably for the screen where the customer found it. I can imagine the confusion on the use case you presented.

---

**Remco Beckers** (2025-05-13 15:55):
The `labels` is not a function itself. They are visible in the first screenshot you shared and also in the side panel and main screen for a component. They are simply key/value pairs that are mostly generated automatically.

Kubernetes labels are automatically included as well, so if you want to add a label for an environment you could do that by adding labels in Kubernetes. The disadvantage is that you'll need to add it to every k8s resource separately. I don't know of a way to globally add a label for the entire cluster.

Tbh, I thought it was possible using the `STS_TAG` environment variable on the agent installation, but that only gets applied to metrics, not to components. Any agent experts have a suggestion? @Bram Schuur @Andrea Terzolo @Alessio Biancalana?

For reference, to add a label to all metrics add this extra value to the `helm install` command for the agent: `--set global.extraEnv.open.STS_TAGS='environment:test'`

---

**Louis Lotter** (2025-05-15 11:19):
@Rajukumar Macha

---

**Saurabh Sadhale** (2025-05-16 10:30):
<#C07CF9770R3|> can someone help in this ?

---

**Amol Kharche** (2025-05-16 12:24):
Hi Team,
Customer facing issue while configuring Rancher UI extension it said can't connect to SUSE Observability.
Rancher :- v2.9.6
Observability extension: v1.0.1
From rancher-pod, can reach it:
```
$ kubectl exec -it rancher-7dd9b9fd6c-q2fd2 -n cattle-system -- bash
bash-4.4#
bash-4.4# curl -kv https://web.fks-obs-stg.corp.fortinet.com
* Host web.fks-obs-stg.corp.fortinet.com:443 (http://web.fks-obs-stg.corp.fortinet.com:443) was resolved.
* IPv6: (none)
* IPv4: 10.125.15.135
* Trying 10.125.15.135:443...
* Connected to web.fks-obs-stg.corp.fortinet.com (http://web.fks-obs-stg.corp.fortinet.com) (10.125.15.135) port 443
* ALPN: curl offers h2,http/1.1```
Is there anything we can check further?
cc: @Garrick Tam

---

**Garrick Tam** (2025-05-20 01:55):
Here's the support logs.

---

**Bram Schuur** (2025-05-20 09:08):
Dear Garrick, thanks for reporting! I filed a ticket and will take a look asap: https://stackstate.atlassian.net/browse/STAC-22769

---

**Bram Schuur** (2025-05-20 09:29):
Dear Garrick,

the `java.lang.NoSuchMethodException: org.apache.hadoop.hdfs.DFSClient.beginFileLease` error is a red herring (it is benign, but logged at the wrong level by upstream hbase). I'll see if we can somehow can get rid of that

The real cause is the regionservers getting OOMKilled (see the pod status). An immediate fix is to bump the request/limit for that pod (lets say to 5G, maybe more if needed), we will also make a more permanent fix for this by adapting the 150-ha profile to give more memory or avoid OOMKilled, I'll keep you posted on that.

Keys to patch:
`hbase.hbase.regionserver.resources.requests.memory="5G"`
`hbase.hbase.regionserver.resources.limits.memory="5G"`
Reference: https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/values.yaml#L1765

Could you communicate back to me how much memory was needed to get the system running?

Kind regards,

Bram Schuur

---

**Amol Kharche** (2025-05-20 11:21):
Currently *suse-observability-hbase-hbase-rs* statefulset has request/limit set to 3Gi.
All 3 worker nodes experiencing high consumption of resources.
*rnchobsddc01-prod*
```management.cattle.io/pod-limits (http://management.cattle.io/pod-limits): {"cpu":"33150m","ephemeral-storage":"6584Mi","memory":"44556Mi"}
management.cattle.io/pod-requests (http://management.cattle.io/pod-requests): {"cpu":"20360m","ephemeral-storage":"70Mi","memory":"41200Mi","pods":"37"}
  Resource           Requests       Limits
  --------           --------       ------
  cpu                20360m (72%)   33150m (118%)
  memory             41200Mi (81%)  44556Mi (88%)```
*rnchobsddc02-prod*
```management.cattle.io/pod-limits (http://management.cattle.io/pod-limits): {"cpu":"30720m","ephemeral-storage":"9068Mi","memory":"43860Mi"}
management.cattle.io/pod-requests (http://management.cattle.io/pod-requests): {"cpu":"17230m","ephemeral-storage":"75Mi","memory":"41466Mi","pods":"36"}
  Resource           Requests       Limits
  --------           --------       ------
  cpu                17230m (61%)   30720m (109%)
  memory             41466Mi (82%)  43860Mi (87%)```
*rnchobsddc03-prod*
```management.cattle.io/pod-limits (http://management.cattle.io/pod-limits): {"cpu":"41410m","ephemeral-storage":"11606Mi","memory":"49650Mi"}
management.cattle.io/pod-requests (http://management.cattle.io/pod-requests): {"cpu":"23685m","ephemeral-storage":"76Mi","memory":"48812Mi","pods":"28"}
  Resource           Requests       Limits
  --------           --------       ------
  cpu                23685m (84%)   41410m (147%)
  memory             48812Mi (97%)  49650Mi (98%)```
@Bram Schuur Do you think it could impact SUSE Observability in future? could be slowness in application.

---

**Amol Kharche** (2025-05-20 11:21):
Also most of the pods don't have requests/limits set, which might affect the node and its pods performance.
```  Namespace                   Name                                                               CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                                               ------------  ----------  ---------------  -------------  ---
  calico-system               calico-node-gw2w4                                                  0 (0%)        0 (0%)      0 (0%)           0 (0%)         93d
  cattle-monitoring-system    prometheus-rancher-monitoring-prometheus-0                         750m (2%)     1 (3%)      750Mi (1%)       3000Mi (5%)    85d
  cattle-monitoring-system    pushprox-kube-controller-manager-proxy-c8bb7f747-g8nth             0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  cattle-monitoring-system    pushprox-kube-etcd-proxy-889c559bc-lgp5t                           0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  cattle-monitoring-system    pushprox-kube-proxy-client-xkg7q                                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  cattle-monitoring-system    pushprox-kube-scheduler-proxy-58b9f6557-kkqdq                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  cattle-monitoring-system    rancher-monitoring-grafana-5f4fd77cf4-ggkj8                        100m (0%)     200m (0%)   100Mi (0%)       200Mi (0%)     50d
  cattle-monitoring-system    rancher-monitoring-kube-state-metrics-559bbfb984-lzcxj             0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  cattle-monitoring-system    rancher-monitoring-operator-588c7c8587-xhsrn                       100m (0%)     200m (0%)   100Mi (0%)       500Mi (0%)     85d
  cattle-monitoring-system    rancher-monitoring-prometheus-node-exporter-6khnr                  0 (0%)        0 (0%)      0 (0%)           0 (0%)         85d
  kube-system                 kube-proxy-rnchobsddc01-prod                                       250m (0%)     0 (0%)      128Mi (0%)       0 (0%)         93d
  kube-system                 rke2-ingress-nginx-controller-jc5j8                                100m (0%)     0 (0%)      90Mi (0%)        0 (0%)         93d
  kube-system                 rke2-metrics-server-75866c5bb5-4nmrt                               100m (0%)     0 (0%)      200Mi (0%)       0 (0%)         50d
  longhorn-system             csi-attacher-6468dd6488-7tdc8                                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             csi-attacher-6468dd6488-cchkj                                      0 (0%)        0 (0%)      0 (0%)           0 (0%)         50d
  longhorn-system             csi-provisioner-676cd99bc8-k987k                                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             csi-provisioner-676cd99bc8-wqnk4                                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         50d
  longhorn-system             csi-resizer-6b859895c4-cwvqk                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             csi-resizer-6b859895c4-cxpxb                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         50d
  longhorn-system             csi-snapshotter-5d47c94f45-rp4vt                                   0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             engine-image-ei-02372f4e-nnmvk                                     0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             instance-manager-186260d09d88e0fcb559bdbbe825836f                  3360m (12%)   0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             longhorn-csi-plugin-lk8tz                                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             longhorn-manager-gv2jj                                             0 (0%)        0 (0%)      0 (0%)           0 (0%)         74d
  longhorn-system             longhorn-ui-75d7f77cc6-hgsxj                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         50d
  suse-observability          suse-observability-correlate-9b675dd99-qb7gz                       3 (10%)       6 (21%)     3500Mi (6%)      3500Mi (6%)    7h50m
  suse-observability          suse-observability-elasticsearch-master-0                          1 (3%)        2 (7%)      4Gi (8%)         4Gi (8%)       24d
  suse-observability          suse-observability-hbase-hbase-rs-0                                2 (7%)        4 (14%)     3Gi (6%)         3Gi (6%)       7h49m
  suse-observability          suse-observability-hbase-hbase-rs-1                                2 (7%)        4 (14%)     3Gi (6%)         3Gi (6%)       7h50m
  suse-observability          suse-observability-hbase-hdfs-nn-0                                 200m (0%)     400m (1%)   1Gi (2%)         1Gi (2%)       24d
  suse-observability          suse-observability-hbase-tephra-1                                  500m (1%)     1 (3%)      1Gi (2%)         1Gi (2%)       7h50m
  suse-observability          suse-observability-kafka-2                                         1200m (4%)    3 (10%)     3372Mi (6%)      4396Mi (8%)    24d
  suse-observability          suse-observability-prometheus-elasticsearch-exporter-844977zqzl    100m (0%)     100m (0%)   100Mi (0%)       100Mi (0%)     24d
  suse-observability          suse-observability-victoria-metrics-0-0                            2 (7%)        4 (14%)     9Gi (18%)        9Gi (18%)      24d
  suse-observability          suse-observability-victoria-metrics-1-0                            2 (7%)        4 (14%)     9Gi (18%)        9Gi (18%)      24d
  suse-observability          suse-observability-vmagent-0                                       1500m (5%)    3 (10%)     1500Mi (2%)      1500Mi (2%)    7h50m
  suse-observability          suse-observability-zookeeper-1                                     100m (0%)     250m (0%)   640Mi (1%)       640Mi (1%)     24d```

---

**Bram Schuur** (2025-05-20 11:25):
My working hypothesis is we need to tweak -Xmx (there is no GC pressure there, so 3Gi should be enough), this is something we'll have to do on our chart though. High resource usage is expected suring startup/crashloopbackoff

---

**Ankush Mistry** (2025-05-20 15:36):
The collector configuration file looks like this:
```apiVersion: opentelemetry.io/v1beta1 (http://opentelemetry.io/v1beta1)
kind: OpenTelemetryCollector
metadata:
  name: otel-collector
  namespace: open-telemetry
spec:
  mode: deployment
  envFrom:
  - secretRef:
      name: open-telemetry-collector
  # optional service-account for pulling the collector image from a private registries
  # serviceAccount: otel-collector
  config:
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      # Scrape the collectors own metrics
      prometheus:
        config:
          scrape_configs:
          - job_name: opentelemetry-collector
            scrape_interval: 10s
            static_configs:
            - targets:
              - ${env:MY_POD_IP}:8888
    extensions:
      health_check:
        endpoint: ${env:MY_POD_IP}:13133
      # Use the API key from the env for authentication
      bearertokenauth:
        scheme: SUSEObservability
        token: "${env:API_KEY}"
    exporters:
      debug:
        verbosity: detailed
      nop: {}
      otlp/suse-observability:
      # otlphttp/suse-observability:
        auth:
          authenticator: bearertokenauth
        endpoint: "https://{{ suse_observability_otel_fqdn }}:443"
        # endpoint: "https://{{ suse_observability_otel_http_fqdn }}"
        tls:
            insecure: false
            insecure_skip_verify: true
        compression: snappy
    processors:
      memory_limiter:
        check_interval: 5s
        limit_percentage: 80
        spike_limit_percentage: 25
      batch: {}
      resource:
        attributes:
        - key: k8s.cluster.name
          action: upsert
          # Insert your own cluster name
          value: "{{ cluster }}"
        - key: service.instance.id
          from_attribute: k8s.pod.uid
          action: insert
          # Use the k8s namespace also as the open telemetry namespace
        - key: service.namespace
          from_attribute: k8s.namespace.name
          action: insert
    connectors:
      # Generate metrics for spans
      spanmetrics:
        metrics_expiration: 5m
        namespace: otel_span
    service:
      extensions: [ health_check,  bearertokenauth ]
      pipelines:
        traces:
          receivers: [otlp]
          processors: [memory_limiter, resource, batch]
          exporters: [debug, spanmetrics, otlp/suse-observability]
          # exporters: [debug, spanmetrics, otlphttp/suse-observability]
        metrics:
          receivers: [otlp, spanmetrics, prometheus]
          processors: [memory_limiter, resource, batch]
          exporters: [debug, otlp/suse-observability]
          # exporters: [debug, otlphttp/suse-observability]
        logs:
          receivers: [otlp]
          processors: []
          exporters: [nop]
      telemetry:
        metrics:
          address: ${env:MY_POD_IP}:8888```

---

**IHAC** (2025-05-20 16:46):
@Bruno Bernardi has a question.

:customer:  SUSE Observability 2.3.3 Installation issues in a CIS secure environment

:facts-2: *Problem (symptom):*  
In order to resolve another support case, it was recommended that the customer upgrade to 2.3.3. The customer cannot successfully install this in their environment, at least one of the pods has a hard-coded securityContext that will not work in a CIS 1.23 compatible environment.

```4m46s Warning FailedCreate statefulset/suse-observability-elasticsearch-master create Pod suse-observability-elasticsearch-master-0 in StatefulSet suse-observability-elasticsearch-master failed error: pods "suse-observability-elasticsearch-master-0" is forbidden: violates PodSecurity "baseline:latest": privileged (container "configure-sysctl" must not set securityContext.privileged=true)```
We tried to have CIS disabled for this namespace, and the customer removed all of the security context settings from his helm chart values. Yet Elasticsearch still fails to start with the same error. Looking at the statefulset, I see the container securityContext is being set to:

```        securityContext:
          privileged: true
          runAsUser: 0```
Can you please help with this issue, and if any additional action is needed in v2.3.3? Does it also need to have allowPrivilegeEscalation=true. ?

---

**Bram Schuur** (2025-05-20 17:54):
The team is having a meetup this week. I will keep track of this question and reais eit with the right people on monday.

---

**Bram Schuur** (2025-05-20 17:59):
The team is on a yearly meetup right now, so we cannot investigate immediately. I filed a ticket and put this on my list, I'll make sure we look at this on monday.

TickeT: https://stackstate.atlassian.net/browse/STAC-22772

---

**Bruno Bernardi** (2025-05-20 18:03):
OK. Many thanks for your response, @Bram Schuur.

---

**Hugo de Vries** (2025-05-21 00:20):
Under exporters, the http exporter is commented out, but both errors that the customer shared are from the http endpoint, not the grpc endpoint, those need to match.

---

**Garrick Tam** (2025-05-21 04:37):
Here's the new support log collection.

---

**IHAC** (2025-05-21 16:35):
@Rodolfo de Almeida has a question.

:customer:  The Commonwell Mutual Insurance Group

:facts-2: *Problem (symptom):*  
The customer installed SUSE Observability and the pods  `elasticsearch-master` and `e2es` are are failing due to a *CrashLoopBackOff.*

*e2es* pod shows this error.
```Events:
  Type     Reason     Age                     From     Message
  ----     ------     ----                    ----     -------
  Warning  BackOff    8m26s (x4716 over 19h)  kubelet  Back-off restarting failed container e2es in pod suse-observability-e2es-6c58d7c795-s4qsk_suse-observability(41a52d01-7036-4e8c-a0d4-389b43897545)
  Warning  Unhealthy  3m22s (x583 over 19h)   kubelet  Readiness probe failed: Get "http://10.244.7.7:1618/readiness": dial tcp 10.244.7.7:1618: connect: connection refused```
*elasticsearch_master*  shows the erro
```Events:
  Type     Reason     Age                   From     Message
  ----     ------     ----                  ----     -------
  Warning  Unhealthy  15m (x1391 over 19h)  kubelet  Liveness probe failed: Waiting for elasticsearch cluster to become ready (request params: "wait_for_status=yellow&amp;timeout=1s" )
Cluster is not yet ready (request params: "wait_for_status=yellow&amp;timeout=1s" )
  Warning  Unhealthy  5m4s (x3096 over 19h)  kubelet  Readiness probe failed: Waiting for elasticsearch cluster to become ready (request params: "wait_for_status=yellow&amp;timeout=1s" )
Cluster is not yet ready (request params: "wait_for_status=yellow&amp;timeout=1s" )
  Warning  BackOff  4s (x3404 over 19h)  kubelet  Back-off restarting failed container elasticsearch in pod suse-observability-elasticsearch-master-0_suse-observability(96ec07e5-78d2-4caa-97be-351d5625e71a)```
Both pods failing its liveness and readiness probes repeatedly.

Can someone please help me to identify what is causing this issue?

---

**Rodolfo de Almeida** (2025-05-21 16:41):
Here is all information shared by the customer until now.

---

**Bram Schuur** (2025-05-22 11:10):
Dear @Rodolfo de Almeida from the logs it is unclear to me exactly why the elasticsearch pod is breaking, it exited with error but i do not see the logs. Could you run the entire support package (which should include the --previous logs). https://docs.stackstate.com/self-hosted-setup/install-stackstate/troubleshooting/support-package-logs

---

**Garrick Tam** (2025-05-22 16:31):
@Bram Schuur any thoughts on this? :arrow_up:

---

**Rodolfo de Almeida** (2025-05-22 16:39):
@Bram Schuur Thanks for your response.
I have asked the customer to collect the logs and will past it here as soon as I receive it.

---

**Rodolfo de Almeida** (2025-05-22 16:49):
The customer asked in the case on how to load the following into the values for the helm chart, but I am not sure if that is the correct procedure for this problem.

config.receivers.otlp.protocols.grpc.enpoint.tls.cert_file :
and
config.receivers.otlp.protocols.grpc.enpoint.tls.key_file :

---

**IHAC** (2025-05-22 17:27):
@Javier Lagos has a question.

:customer:  BÁCS-KISKUN MEGYEI KORMÁNYHIVATAL

:facts-2: *Problem (symptom):*  
Customer is asking about VSphere stackpack which can be found on previous StackState 5.1 documentation https://docs.stackstate.com/5.1/stackpacks/integrations/vsphere

The issue is that the customer wants to use some of the community StackPacks that are in the old documentation but no longer in the new one which belongs to SUSE observability .

On the other side, Inside the SUSE Observability latest version it seems that the mentioned StackPacks are not on the official image anymore.

```sts stackpack list
NAME | DISPLAY NAME | INSTALLED VERSION | NEXT VERSION | LATEST VERSION | INSTANCE COUNT
aad-v2 | Autonomous Anomaly Detector | 1.0.1-master-10461-7fe7386e-SNAPSHOT | - | 1.0.1-master-10461-7fe7386e-SNAPSHOT | 0
dynatrace-v2 | Dynatrace | 1.0.2-master-10461-7fe7386e-SNAPSHOT | - | 1.0.2-master-10461-7fe7386e-SNAPSHOT | 0
kubernetes-v2 | Kubernetes | 1.0.18-master-10461-7fe7386e-SNAPSHOT | - | 1.0.18-master-10461-7fe7386e-SNAPSHOT | 3
open-telemetry | Open Telemetry | 0.0.4-master-10461-7fe7386e-SNAPSHOT | - | 0.0.4-master-10461-7fe7386e-SNAPSHOT | 1
prime-kubernetes | Kubernetes add-on | 0.0.1-master-10461-7fe7386e-SNAPSHOT | - | 0.0.1-master-10461-7fe7386e-SNAPSHOT | 1
stackstate | SUSE Observability | 0.0.2-master-10461-7fe7386e-SNAPSHOT | - | 0.0.2-master-10461-7fe7386e-SNAPSHOT | 1
stackstate-k8s-agent-v2 | Agent V2 | 1.0.2-master-10461-7fe7386e-SNAPSHOT | - | 1.0.2-master-10461-7fe7386e-SNAPSHOT | 1```
Is it because we no longer support those StackPacks? What happened to them?

---

**Garrick Tam** (2025-05-22 18:10):
@here It looks like max_memory_usage is the parameter to adjust.  Is giving more memory the right approach and is the key to increase the pod resource memory limit first; then raise the max_memory_usage?

---

**Rodolfo de Almeida** (2025-05-22 20:21):
Here are the logs

---

**Rodolfo de Almeida** (2025-05-22 21:49):
This resolved the SSL related issues

```extraEnvs:
 - name: "GRPC_ENFORCE_ALPN_ENABLED"
   value: "false"
extraVolumes:
 - name: "corningca"
   defaultMode: 420
   secret:
     secretName: ca-secret

extraVolumeMounts:
 - name: "corningca"
   readOnly: true
   mountPath: "/etc/ssl/certs/corningca.crt"
   subPath: "corningca.crt"```
I cannot remove this message from this channel, and the issue has been successfully resolved with the customer.

Thanks!

---

**Remco Beckers** (2025-05-23 08:45):
Hi, can you share how they solved the issue now? What was the final setup.  It looks like they ended up:
• *Not* disabling the tls verification 
• Mounting their own certificate in the otel collector and configuring it to use that, with it fixing the invalid certificate errors
• Then apparently it was also, still, needed to set `GRPC_ENFORCE_ALPN_ENABLED` to `false`.

---

**Remco Beckers** (2025-05-23 09:20):
The first error seems to happen when using the `otlp-http` endpoint with the `otlp` configuration. I can't get the second error to reproduce exactly but, assuming the `otlphttp` setup was used and the configuration was as shown above I think there are a few things to check:

• Check the `opentelemetry-collector` configmap and make sure that all variables (like `{{ cluster }}` and `{{ suse_observability_otel_fqdn }}` are interpreted correctly. Given that this configuration is used with the otel operator I expected no Helm templating is executed, so I'm not sure how these helm templates would be filled in. Maybe try the to create it without any templating.
• Make sure the referenced secret, `open-telemetry-collector`, has been created in the same namespace where the collector is created and contains an entry named `API_KEY` that has a base64 encoded representation of the api key. As a test you could also put the api key directly in the `token` field in the configuration instead of getting it from an env var.
• Make sure that in the configuration the right combination is used, `otlp` exporter uses the `otlp` endpoint or `otlphttp` exporter uses the `otlp-http` endpoint.

---

**Remco Beckers** (2025-05-23 10:03):
I notice they are using `curl -k` which disables TLS verification. The extension (actually Rancher) does TLS verification and expects the TLS certificate to be valid

---

**Remco Beckers** (2025-05-23 10:07):
If they are using certificates signed by their own certificate authority they can configure Rancher to accept those certificates: https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/resources/custom-ca-root-certificates

---

**IHAC** (2025-05-23 17:44):
@Javier Lagos has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Hello Team!

Is it possible to configure SUSE Observability Prometheus endpoint to only share metrics of specific monitored cluster and not all the metrics? https://docs.stackstate.com/metrics/advanced-metrics/k8s-stackstate-grafana-datasource . It seems that when you configure SUSE Observability Prometheus endpoint as a datasource in Grafana you get access to all the clusters being monitored by SUSE Observability server.

The customer which has created one case to us is monitoring multiple clusters where only specific users that belongs to the monitored cluster can access and see on SUSE Observability IU the cluster where they belong but now they want to leverage that by giving them the Prometheus endpoint details so that they can configure Prometheus endpoint into their Grafana but due to fact that all the metrics are being displayed they cannot do it due to security reasons.

I have been able to reproduce the same behavior. I just created one SUSE Observability instance which is monitoring 2 clusters. Then I have configured following the steps here https://docs.stackstate.com/metrics/advanced-metrics/k8s-stackstate-grafana-datasource the Prometheus endpoint as Grafana datasource and I can access metrics from both clusters. I was unable to create a token with only specific permissions from a specific cluster.

Is this configuration even possible? Can we expose and configure prometheus endpoint so it only grants access to specific cluster metrics? If that's not possible yet, can you please analyze if this feature can be added on future versions?

Thanks in advance!!

---

**Rodolfo de Almeida** (2025-05-23 20:14):
We have tried to increase the resource limits for  `elasticsearch-master` pod but we are still facing the same issue.
Any idea why the Readiness Probe is failing?

---

**Frank van Lankvelt** (2025-05-24 15:43):
this is indeed not possible with the current release.  But as it happens we are working on RBAC, limiting access to clusters or namespaces for users.  We're initially targeting Rancher integration, where configuration of subjects happens on the basis of Kubernetes resources.

---

**Frank van Lankvelt** (2025-05-24 16:17):
with the work that's now under way, I think it should be possible to set up a service-token bound to a subject (user or group) defined in a K8s RoleBinding.  That should make it possible to limit metrics to those of particular cluster(s) or namespace(s).

---

**Bram Schuur** (2025-05-26 08:40):
@Lukasz Marchewka @Frank van Lankvelt could you weigh in here? i don't know clickhouse very well

---

**Lukasz Marchewka** (2025-05-26 08:55):
@Garrick Tam you have to increase memory for the database
```clickhouse.resources.requests.memory="5G"
clickhouse.resources.limits.memory="5G"```
you shouldn't change extra params

---

**Lukasz Marchewka** (2025-05-26 08:57):
last time we have introduced some configuration for low memory setups, I have review these changes and it shouldn't cause your problem. Please let me know if this helps.

---

**Frank van Lankvelt** (2025-05-26 08:59):
@Garrick Tam: increasnig memory is indeed the only solution for this.  ClickHouse will keep on trying to merge.  AFAIK it will continue to function, though.

---

**Bram Schuur** (2025-05-26 09:00):
@Bruno Bernardi did you go through all the steps in the documentation? https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/required_permissions#disable-the-privile[…]arch-init-container (https://docs.stackstate.com/self-hosted-setup/install-stackstate/kubernetes_openshift/required_permissions#disable-the-privileged-elasticsearch-init-container)

---

**Javier Lagos** (2025-05-26 09:12):
Thanks for your answer @Frank van Lankvelt! I really appreciate it.  Just a couple of questions.

Does that mean that in a future version of SUSE Observability, RBAC will be managed through Kubernetes-native objects similar to how it's done with SUSE Security or SUSE Virtualization on rancher and that it will be possible to generate a token with permissions scoped to a specific cluster from a user or group, allowing access only to that cluster's metrics?

Do we have an estimated ETA or release date of this feature?

---

**Bram Schuur** (2025-05-26 09:14):
Dear @Rodolfo de Almeida, looking at the logs, it seems startup speed is the issue here. The container does not get live before its timeout. You can either increase resources more, or it might be running on a slow disk, given the consistency of the issue.

Increasing liveness/readiness probes can be done through these settings: https://gitlab.com/stackvista/devops/helm-charts/-/blob/master/stable/elasticsearch/values.yaml#L210 (prefixed with `elasticsearch.`, so `elasticsearch.livenessProbe.initialDelaySeconds=300` for example.

---

**Bram Schuur** (2025-05-26 09:16):
I think the vsphere stackpack was deprecated and not supported anymore, am i correct @Mark Bakker?

---

**Frank van Lankvelt** (2025-05-26 09:31):
RBAC will indeed be implemented that way.  The observability extension will also ship a number of RoleTemplates to make this easy to setup.  I would have to validate that these can indeed be used with a service token; it would probably be better to use a K8s serviceaccount rather than a user or a group.  @Bram Schuur, do you agree?

---

**Bram Schuur** (2025-05-26 10:26):
We are working in the direction that you are describing @Javier Lagos, indeed our first version of K8s-RBAC will allow data permissions per cluster/namespace, for interaction with rancher. Your use-case with servicetokens and grafana is not our primary focus for the first release, so i will put it on the roadmap for right after. @Frank van Lankvelt is on the money with how that will work. We do need to validate interaction of service tokens with k8s-based rbac and see whether service tokens or k8s-serviceaccounts are the way to go in your use-case. We also would like to document that flow proper.

---

**Rodolfo de Almeida** (2025-05-26 14:26):
Hello @Bram Schuur
I cannot access the link you shared.
I created a copy of the StackState values.yaml file in my computer but couldn't find the setting `elasticsearch.livenessProbe.initialDelaySeconds=300`

---

**Bram Schuur** (2025-05-26 14:27):
whoops, should have sent this one: https://github.com/StackVista/helm-charts/blob/master/stable/elasticsearch/values.yaml#L210

---

**Rodolfo de Almeida** (2025-05-26 15:28):
@Bram Schuur
This variable doesn't exist in the suse observability values.yaml.
https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/values.yaml
Should I add it manually?
```elasticsearch:
  readinessProbe:
    initialDelaySeconds: 300```

---

**Vladimir Iliakov** (2025-05-26 15:43):
Hi Rodolfo, this value is defined at the sub-chart level (the Elasticsearch chart) and can be override at the "parent" chart (Suse Observability) level.
You need to override the livenessProbe, not readinessProbe.
You can update your existing values file with
```elasticsearch:
  livenessProbe:
    initialDelaySeconds: 300```

---

**Vladimir Iliakov** (2025-05-27 12:52):
Hi @Rodolfo de Almeida, have you been able to check if the increased livenessProbe timeout fixes the issue?
We want to change it in the chart and would like to get a confirmation that it was the case with a Customer.

---

**Chris Riley** (2025-05-27 12:54):
@Mark Bakker - do we have any timeframe for the above that we can share with the customer? I have received some comments, via the support survey, from this particular customer asking for RBAC in Observability.

If you would like to reach out directly to the customer yourself, I can provide their contact details. Just let me know.

---

**Frank van Lankvelt** (2025-05-27 14:54):
AFAIK the aim is to ship RBAC support with the Rancher OIDC work, which will land in 2.12.

---

**Rodolfo de Almeida** (2025-05-27 15:08):
Hi @Vladimir Iliakov sorry for not answering you.
Yes the procedure is clear and I also reproduced in my lab.
I am still waiting for customer feedback.

---

**Vladimir Iliakov** (2025-05-27 15:24):
Ok, thanks :thumbs-up:

---

**Bruno Bernardi** (2025-05-28 17:11):
Thanks for your response, @Bram Schuur. I sent this question to the customer on Monday, and I'm waiting for his confirmation. I'll update you as soon as I have feedback.

Just to let you know, this is the same customer (Disney Cruise Line Technology) who the Team has already worked on similar permissions issues in the past. In case that helps, this (https://suse.slack.com/archives/C07CF9770R3/p1741309643136429) is the slack thread.

---

**Garrick Tam** (2025-05-29 18:33):
This is the sync pod logs with the "Java heap space error".

---

**IHAC** (2025-05-29 20:44):
@Bruno Bernardi has a question.

:customer:  The Commonwell Mutual Insurance Group

:facts-2: *Problem (symptom):*  
The customer is reporting that they're using MS Teams notifications in their Observability for notifications and used the guide that is in the documentation.

However, we found a small problem with the implementation. When the post comes through, the button that is supposed to take you to the active incident doesn't include the `https://` part of the link. As a result, clicking on the link in the notification doesn't do anything. Please refer to the attached screenshot.

We understand that the expected behavior is that it takes you to the SUSE Observability Domain and references the active incident.

Can you please take a look to see if this may be a bug? The customer is using SUSE Observability version 2.3.3.

---

**Remco Beckers** (2025-05-30 08:49):
The URL that is used is configured via the `baseUrl` setting when installing SUSE Observability (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#installation). It is expected to contain the URL scheme (i.e. `https://` or `http://`). It seems like it was configured without the scheme, because the Teams notifications use the URL as-is without modification.

It is easy to verify and fix by inspecting the generated
```suse-observability-values/templates/baseConfig_values.yaml```
file. If the URL is missing the `https://` part simply add it and rerun the `helm upgrade` command to update the configuration.

---

**Lukasz Marchewka** (2025-05-30 11:17):
@Alejandro Acevedo Osorio @Bram Schuur I see a lot of errors in stackgraph like this one
```2025-05-29 15:53:55,499 ERROR com.stackstate.domainactors.DomainActorPoolActor - DomainActorPool failed because of error java.lang.IllegalStateException: Cannot un-exist verified existing stackelement: v[56369219847737],{}, loaded=VERIFIED, existing=true, verifiedAtTxId=1745339374045000000, lastUpdateTransactionId=null, label=Synced, edgesIn={}, edgesOut={}, loadTransactionId=1748534028832000000. The DomainActorPool will not restart.
2025-05-29 15:53:55,506 WARN  com.stackstate.domainactors.DomainStreamActor - Restarting stream actor task SettingId(126281021294882,Sync) due to exception Cannot un-exist verified existing stackelement: v[56369219847737],{}, loaded=VERIFIED, existing=true, verifiedAtTxId=1745339374045000000, lastUpdateTransactionId=null, label=Synced, edgesIn={}, edgesOut={}, loadTransactionId=1748534028832000000. StackTrace: java.lang.IllegalStateException: Cannot un-exist verified existing stackelement: v[56369219847737],{}, loaded=VERIFIED, existing=true, verifiedAtTxId=1745339374045000000, lastUpdateTransactionId=null, label=Synced, edgesIn={}, edgesOut={}, loadTransactionId=1748534028832000000```
Do you know the reason ?

---

**Bram Schuur** (2025-05-30 11:32):
Hmm that is not looking fresh, this is typically some form of data corruption. @Garrick Tam would it be possible to get into a call with this customer?
Both the issue that @Lukasz Marchewka found aswell as the memory issues with the topology sync are issues we would like to investigate together. Could you invite me and @Alejandro Acevedo Osorio to that call?

---

**Garrick Tam** (2025-05-30 16:52):
Hi @Bram Schuur @Alejandro Acevedo Osorio Customer is in US Central timezone.  I will try to coordinate a call for customer's morning and forward you the invite. For your reference, the name of the invite will reference "01580903 (https://suse.lightning.force.com/lightning/r/500Tr00000ZwgsLIAR/view)".

---

**Bruno Bernardi** (2025-05-30 17:21):
Thanks @Remco Beckers. I'll review this with the customer and let you know after that.

---

**Bruno Bernardi** (2025-05-30 19:47):
Worked. Thanks, Remco!

---

**Amol Kharche** (2025-06-02 11:02):
Hi Team,
Customer would like to run `suse-observability-backup-conf--xxx` pod on specific node only. Do we know how to do that ? Do we support `nodeSelector` while running cronjobs ?
e.g.
```suse-observability-backup-conf:
  nodeSelector:
    kubernetes.io/hostname (http://kubernetes.io/hostname): HOSTNAME```

---

**Remco Beckers** (2025-06-02 11:09):
Our helm chart doesn't support node selectors nor affinity for the backup cron jobs. So at the moment it is only possible by patching the cronjob after installation (and redoing this everytime a `helm upgrade` command is executed).
One way to do this automatic (but really only in a CI/CD setup) is to use the `--post-renderer` option of helm to run `kustomize`. An example of that is here https://github.com/thomastaylor312/advanced-helm-demos/tree/master/post-render

---

**Remco Beckers** (2025-06-02 11:10):
To be honest, that's not a great solution but a work-around

---

**Amol Kharche** (2025-06-02 11:11):
Thanks @Remco Beckers

---

**Saurabh Sadhale** (2025-06-02 11:48):
Hey @Remco Beckers thank you for your updates.

The customer has now re-configured and now the errors do not appear but their Traces Dashboards are grayed out.

I am attaching the screenshot and logs. I have checked the logs however there is no error in the logs at least.

---

**Remco Beckers** (2025-06-02 11:51):
Can you check the `Traces` tab at the top? That's where the traces should appear.

But it looks like there are no traces reported for this service (otherwise there would at least be some data for  `span duration`  and `span rate`).

Either only metrics are reported for the service instance OR the service instance only receives very occasional calls resulting in very few traces.

---

**Remco Beckers** (2025-06-02 11:52):
By the name of the service it looks like this is the otel collector itself that you're looking at. It only reports metrics, no traces

---

**Saurabh Sadhale** (2025-06-02 11:52):
Ack thanks for pointing those checks. I will have this checked with the customer once. Thanks a lot.

---

**Remco Beckers** (2025-06-02 11:54):
If they want to have data on their own applications they'll need to instrument them or otherwise scrape data for their apps.

Since you mentioned the otel operator they could rely on the auto-instrumentation but need to configure which pods should be auto-instrumented (see the otel operator docs on our docs site on how to do that).

---

**Bruno Bernardi** (2025-06-03 00:33):
Hi @Bram Schuur,

The customer updated the case and mentioned that he followed all the steps in the above documentation. However, the same error is still being displayed.

```Events:
  Type     Reason        Age                      From                    Message
  ----     ------        ----                     ----                    -------
  Warning  FailedCreate  2m18s (x271 over 2d21h)  statefulset-controller  create Pod suse-observability-elasticsearch-master-0 in StatefulSet suse-observability-elasticsearch-master failed error: pods "suse-observability-elasticsearch-master-0" is forbidden: violates PodSecurity "baseline:latest": privileged (container "configure-sysctl" must not set securityContext.privileged=true)```
Can you please take a look? I believe that the Slack thread I shared before may be related to this behavior.

Thanks in advance.

---

**Bram Schuur** (2025-06-03 10:25):
@Remco Beckers could you pick this up in your team? (maybe @Vladimir Iliakov / @Fedor Zhdanov?) this ticket wads filed: https://stackstate.atlassian.net/browse/STAC-22772

---

**Vladimir Iliakov** (2025-06-03 12:47):
I have taken it into work

---

**Vladimir Iliakov** (2025-06-03 16:21):
@Bram Schuur the CIS 1.23 you mentioned in the ticket seems to be the oldest one, are you sure we want to check the platform installation against it?

---

**Vladimir Iliakov** (2025-06-03 16:22):
Ah  I see now the version comes from the Slack topic

---

**Vladimir Iliakov** (2025-06-03 16:36):
Hi @Bruno Bernardi , I need more input for this task. From the support bundle I learn't that the version of RKE2 is `v1.31.7+rke2r1` , however CIS guide is `1.23` . According to this doc https://docs.rke2.io/security/hardening_guide for `v1.31.7+rke2r1` version of RKE2 it should be v1.8 version of CIS Framework.
I am new to RKE2 and CIS and might be missing something here. Can you  please clarify that so I can reproduce the issue on a similar environment?

---

**Bruno Bernardi** (2025-06-03 16:46):
Hi @Vladimir Iliakov. Sure, please allow me some time to double-check this, and I'll update you as soon as possible. Thanks!

---

**Vladimir Iliakov** (2025-06-03 17:06):
Thank you.

---

**Bruno Bernardi** (2025-06-04 00:07):
Hi @Vladimir Iliakov,

The customer mentioned that CIS has been disabled since their initial install. CIS is disabled in the cluster, and there is no longer a `profile: cis` setting in the rke2 config.yaml. The RKE2 version is v1.31.7+rke2r1, and the Rancher version is v2.10.4.

He also mentioned that CIS is disabled for this namespace, and he removed all of the security context settings from his helm chart values, and the upgrade still fails. Yet Elasticsearch still fails to start with the same error. It seems that the CIS environment references are still in the environment location.

Looking at the statefulset, we see the container securityContext is being set to:
```        securityContext:
          privileged: true
          runAsUser: 0```
Does it also need to have allowPrivilegeEscalation=true?

---

**IHAC** (2025-06-04 01:07):
@Garrick Tam has a question.

:customer:  Fortinet

:facts-2: *Problem (symptom):*  
Is this section true? --&gt; https://docs.stackstate.com/self-hosted-setup/security/rbac/role_based_access_control#what-can-i-do-with-rbac. I thought RBAC and RBAC integration with Rancher is still under development.

---

**Garrick Tam** (2025-06-04 01:08):
IIRC from previous discussions, the only possibility is  with scopes but limited to topology.

---

**Garrick Tam** (2025-06-04 01:08):
Appreciate if someone can confirm if that RBAC section is misleading.

---

**Jeroen van Erp** (2025-06-04 08:10):
This is our “separate” RBAC, i.e. not integrated with Rancher.

---

**Louis Lotter** (2025-06-04 09:33):
@Remco Beckers @Bram Schuur Maybe we should update this documentation to make this clear ?

---

**Bram Schuur** (2025-06-04 09:38):
Part of the work @Frank van Lankvelt is doing will make that more clear

---

**Vladimir Iliakov** (2025-06-04 10:55):
You mentioned that the customer had disabled CIS profile for the RKE2. Disabling it is not enough for PodSecurity to stop tracking the namespace. Also  the namespace's labels have to be deleted. It can be done with the following commands:
```kubectl label ns suse-observability pod-security.kubernetes.io/enforce-
kubectl label ns suse-observability pod-security.kubernetes.io/audit-
kubectl label ns suse-observability pod-security.kubernetes.io/warn-```

---

**Vladimir Iliakov** (2025-06-04 11:24):
@Fedor Zhdanov @Bram Schuur Updating the installation docs with the note regarding Pod Security Standards  https://github.com/StackVista/stackstate-docs/pull/1623

---

**Bram Schuur** (2025-06-04 11:57):
Approved, thanks for diving into this @Vladimir Iliakov

---

**Bram Schuur** (2025-06-04 16:21):
Just to summarize our call (@Rodolfo de Almeida correct me if i am wrong):
• We observed corruption of the topology data (hbase).
• We weren't able to pinpoint a moment when exactly this happened, what might have caused this was:
    ◦ Repeated OOM by the region server that was happening earlier
    ◦ Out of discspace issue that happened before that
    ◦ (Less likely) I am now doing inquiries what the status is about SUSE Observablity on longhorn, there were issues there in the past, I will get back on that.
• Action points for lumen:
    ◦ Reinstall the instance, clearing PVCs
    ◦ Make sure the instance is rightly sized (e.g. do not run over the agent limit). Either by choosing a bigger instance or reducing input data.

---

**Bram Schuur** (2025-06-04 16:33):
About longhorn: What i got back from our QA is that SUSE Observability is stable on longhorn, except when longhorn gets starved for resources (cpu/memory), at that point there can be issues with the disks. I will raise an internal ticket for us to document what resources are required for longhorn to avoid starvation.

---

**Bruno Bernardi** (2025-06-04 17:22):
Thanks a lot for your detailed feedback and tests, @Vladimir Iliakov. I'll try this procedure in my lab and also review with the customer and update here as soon as I've any feedback.

---

**Garrick Tam** (2025-06-04 17:53):
Thank you for the update.  I am still waiting on customer's reply to the last meeting recommendations.

---

**Amol Kharche** (2025-06-05 10:52):
Hi Team,
Customer (*Nemzeti Adó- és Vámhivatal*) facing issue when upgrading stackpacks. They were upgrading Stackpacks, but got stuck in the process:
```sts stackpack list-instances --name kubernetes-v2 --api-token --url http://stackstate.trke.intranet.nav.gov.hu
ID | STATUS | VERSION | LAST UPDATED
160480552840989 | UPGRADING | 1.0.18-master-10654-a407dff8-SNAPSHOT | Wed May 21 11:36:50 2025 CEST
94990240917949 | UPGRADING | 1.0.18-master-10654-a407dff8-SNAPSHOT | Wed May 21 11:36:50 2025 CEST
53520118041  | UPGRADING | 1.0.18-master-10654-a407dff8-SNAPSHOT | Wed May 21 11:36:50 2025 CEST```
Can you help in this case? How can they set the upgrade or how can they retry this process?
```helm -n suse-observability list 
NAME                            NAMESPACE               REVISION        UPDATED                                 STATUS          CHART                            APP VERSION 
grafana2                        suse-observability      18              2025-06-03 12:57:54.178343828 +0000 UTC deployed        grafana-9.2.2                    12.0.1 
suse-observability              suse-observability      1               2025-05-13 08:26:04.971975723 +0000 UTC deployed        suse-observability-2.3.3         7.0.0-snapshot.20250430171416-master-f683b3c 
suse-observability-agent        suse-observability      3               2025-06-04 08:08:57.260694291 +0000 UTC deployed        suse-observability-agent-1.0.36  3.0.0 

$ sts stackpack list --api-token  --url http://stackstate.trke.intranet.nav.gov.hu 
NAME                   | DISPLAY NAME           | INSTALLED VERSION      | NEXT VERSION | LATEST VERSION         | INSTANCE COUNT 
aad-v2                 | Autonomous Anomaly Det | 1.0.1-master-10666-a40 | -            | 1.0.1-master-10666-a40 | 0 
                       | ector                  | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         | 
dynatrace-v2           | Dynatrace              | 1.0.2-master-10666-a40 | -            | 1.0.2-master-10666-a40 | 0 
                       |                        | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         |
kubernetes-v2          | Kubernetes             | 1.0.18-master-10654-a4 | -            | 1.0.18-master-10666-a4 | 3 
                       |                        | 07dff8-SNAPSHOT        |              | 07dff8-SNAPSHOT        | 
open-telemetry         | Open Telemetry         | 0.0.4-master-10666-a40 | -            | 0.0.4-master-10666-a40 | 1 
                       |                        | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         |
prime-kubernetes       | Kubernetes add-on      | 0.0.1-master-10666-a40 | -            | 0.0.1-master-10666-a40 | 1 
                       |                        | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         | 
stackstate             | SUSE Observability     | 0.0.2-master-10666-a40 | -            | 0.0.2-master-10666-a40 | 1 
                       |                        | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         |
stackstate-k8s-agent-v | Agent V2               | 1.0.2-master-10666-a40 | -            | 1.0.2-master-10666-a40 | 1 
2                      |                        | 7dff8-SNAPSHOT         |              | 7dff8-SNAPSHOT         | ```

---

**Bram Schuur** (2025-06-05 10:59):
@Deon Taljaard i think you are now the resident expert on this issue. Was there a trick to pull to get out of this one?

---

**Deon Taljaard** (2025-06-05 11:17):
Ouch. They've encountered another bug a layer deeper than the changes/fix we've previously made for StackPack lifecycle management. Bug ticket: https://stackstate.atlassian.net/browse/STAC-22843 (currently in review)

TL;DR: multiple instances/configurations of a stackpack race against each other during an upgrade - this results in a transaction conflict and aborts the process. But due to improper failure handling, the state of the configs don't get reset for the system to retry.

The options I can think of aren't great (since the bug is still there - the likelihood is that he system will land in this stuck state again):
• restart the server/api pod (which will trigger the stackpack mangement service to attempt the upgrade again)
• if that's not an option and the customer doesn't like seeing the spinning/stuck state, would be to manually modify the states of those configs (but this is going to far I assume)
In any case, I reckon we need to schedule another release with the bug fix.

---

**Amol Kharche** (2025-06-05 11:41):
So to fix it we need to restart server pod?

---

**Deon Taljaard** (2025-06-05 11:47):
As I tried to describe above, a restart won't necessarily fix it (the race condition makes it indeterministic).

As far as I can tell, a restart of the server/api pod triggers the underlying stackpack manager process and will attempt to upgrade the stuck configs.

(Using the API to trigger an upgrade will fail because it checks that there aren't an existing upgrade in progress)

---

**Amol Kharche** (2025-06-05 11:50):
I can ask customer to try that if not then we need to edit respective configMap?

---

**Amol Kharche** (2025-06-05 11:52):
Customer would like to fix it

---

**Deon Taljaard** (2025-06-05 11:54):
I understand.

No, you'd need to modify the states of the stackpack configurations persisted in stackgraph - but I don't feel comfortable pursuing this option (I'm not sure what our policy is here regarding making manual data changes in a self-hosted SO instance - @Bram Schuur is this a no go?).

---

**Bram Schuur** (2025-06-05 12:46):
@Deon Taljaard that is not supported no

---

**Deon Taljaard** (2025-06-05 12:49):
Clear, thanks.

@Amol Kharche the unfortunate news for the time being: the option that remains is to restart the server/api pod until it's fixed. The prospective good news: the bug fix is on its way to being merged and will be in the next release.

---

**Amol Kharche** (2025-06-05 12:52):
Cool Thanks, I will inform customer to try out server/api pod restart.

---

**IHAC** (2025-06-05 13:31):
@Rodolfo de Almeida has a question.

:customer:  Fortinet Technologies (Canada) ULC

:facts-2: *Problem (symptom):*  
A customer sent a screenshot from SUSE Observability agent installation in Rancher UI and asking for more information about each Agent present in the screenshot.
Node Agent
Process Agent
Cluster Agent
Logs Agent
RBAC Agent

I couldn't find this information in the SUSE Observability docs.
Is this still in use or should we follow only the agent installation procedure described here (https://docs.stackstate.com/get-started/k8s-suse-rancher-prime#installing-the-suse-observability-agent)?

---

**Rodolfo de Almeida** (2025-06-05 13:33):
This is the screenshot sent by the customer.
I also couldn't find this Agent app in my Rancher Prime Server.
@Alejandro Acevedo Osorio Could you please take a look at this customer request?

---

**Amol Kharche** (2025-06-05 13:58):
Customer confirmed that problem has been solved by the SUSE Observability 2.3.4 upgrade. Now there is no stucked Stackpack.

---

**Deon Taljaard** (2025-06-05 14:15):
Good to hear that StackPacks are no longer stuck.

For clarification: the bug fix will be in the next release, i.e. 2.3.5 - it just missed the cut for 2.3.4.

---

**Alejandro Acevedo Osorio** (2025-06-05 14:20):
This Agent app is based on the default Agent chart that we offer basically the same that you would get by following the instructions in the docs via the Stackpack page.

---

**Alejandro Acevedo Osorio** (2025-06-05 14:21):
I wonder why you can't find it on your Rancher Primer Server, do you have the UI Extension installed? I think the UI Extension was creating the repo so you can have access to the app

---

**Alejandro Acevedo Osorio** (2025-06-05 14:29):
So the customer can follow both paths of installation, in the app we make evident some of the configuration (disable TLS etc) ... but the most important part is to apply the config for
```Deploy the SUSE Observability Agent and Cluster Agent
Instance credentials
Cluster Name: **********
StackState Ingest URL: https://*****.*****.stackstate.io/receiver/stsAgent (http://stackstate.io/receiver/stsAgent)
Api Key: ***********```

---

**Alejandro Acevedo Osorio** (2025-06-05 14:34):
```1. **Cluster Agent**
    - **Role:** Serves as the central data collector for cluster-level information. It gathers data about the Kubernetes cluster's state, configurations, and overall health.
    - **Dependencies:** Communicates with Kubernetes API Server and coordinates with other agents (Node Agent, Process Agent, Logs Agent, Checks Agent).
2. **Node**
    - **Node Agent**
        - **Role:** Collects node-level metrics such as CPU usage, memory consumption, disk I/O, and network statistics. Runs on each Kubernetes node.
        - **Dependencies:** Relies on the node's operating system metrics and communicates with the Cluster Agent.
    - **Process Agent**
        - **Role:** Uses eBPF (extended Berkeley Packet Filter) to monitor system calls and process-level data for detailed performance insights.
        - **Dependencies:** Requires eBPF capabilities in the Linux kernel; depends on Node Agent for context.
    - **Logs Agent**
        - **Role:** Collects pod logs from applications.
        - **Dependencies:** Accesses log files or logging frameworks; communicates with the Cluster Agent.```
BTW the `Rbac Agent` is still in progress, but it's duty will be to report RBAC resources to SUSE Observability so it can integrate with the Rancher RBAC model

---

**Rodolfo de Almeida** (2025-06-05 14:37):
Thanks a lot for all information, it is now clear for me.
Still trying to see the SUSE Observability Agent App in my Rancher cluster. I have installed the Observability extension but still cannot see anything in the  Apps/Charts.

---

**Rodolfo de Almeida** (2025-06-05 14:37):
Do we have plans to add this information to the SUSE Observability docs?

---

**Rodolfo de Almeida** (2025-06-05 14:38):
Is this APP only available in a specific Rancher version, like v2.11.1?

---

**Alejandro Acevedo Osorio** (2025-06-05 14:48):
Can you check your configured repositories ... what you got there?

---

**Alejandro Acevedo Osorio** (2025-06-05 14:50):
So it's not via the extension that you get the repo ... it's on our own Stackpack installation page where you get the instructions

---

**Alejandro Acevedo Osorio** (2025-06-05 14:52):
So the docs tell you to follow the instructions of the stackpacks and then the stackpacks offer you as a `Supported Distribution` `SUSE Rancher UI` ...

---

**Rodolfo de Almeida** (2025-06-05 14:53):
Got it... Now I can see it... Thank you!

---

**Daniel Barra** (2025-06-05 15:17):
*We are pleased to announce the release of 2.3.4, featuring bug fixes and enhancements. For details, please review the release notes (https://docs.stackstate.com/self-hosted-setup/release-notes/v2.3.4).*

---

**Rodolfo de Almeida** (2025-06-06 01:34):
@Alejandro Acevedo Osorio
The customer sent this question. Do we have an ETA or estimated release for RBAC Agent?
```Regarding the RBAC Agent which is currently still in development, do you have an ETA or know which release version will include this feature? ```

---

**Alejandro Acevedo Osorio** (2025-06-06 09:28):
@Louis Lotter do we have an ETA?

---

**Louis Lotter** (2025-06-06 09:36):
@Rodolfo de Almeida we are aiming to release this a few weeks after the Rancher release containing the OIDC features we need If I remember correctly its the 2.12 release sometime in august.

---

**Louis Lotter** (2025-06-06 09:36):
@Mark Bakker could add more maybe.

---

**Devendra Kulkarni** (2025-06-06 11:23):
Hello Team,
Fortinet Technologies (Canada) ULC (https://suse.lightning.force.com/lightning/r/Account/0015q000008jRSxAAM/view) wants to file a feature request for having two authentication mechanism for accessing SUSE Observability.
For example, currently if LDAP authentication is setup, it replaces the default admin user/password as well.
Customer is requesting to keep the default admin user as is and add other authentication method along with it.

As in Rancher or NeuVector we have a default admin password, and other users through LDAP, Keycloak, OIDC can access using their authentication method.

---

**Devendra Kulkarni** (2025-06-06 11:24):
LMK if this is already in the roadmap or I should create a FR for it

---

**Devendra Kulkarni** (2025-06-06 11:25):
One more issue that I see is that when LDAP is configured as an authentication method for SUSE Observability, upon successful authentication, the observability server pod does not log anything.

but if the authentication fails, lets say due to invalid credentials, the log is reported.

It would be great if we also log for successful authentication.

---

**Javier Lagos** (2025-06-06 11:34):
I think that to be able to see error messages when doing authentication it is required to enable debug mode on the SUSE Observability API and server pod https://docs.stackstate.com/self-hosted-setup/security/authentication/troubleshooting

---

**Devendra Kulkarni** (2025-06-06 13:26):
For wrong authenticaion I am getting logs without enabling debug logging, I am expecting a 200OK user "xxx" logged in successfully using LDAP authentication .

---

**Devendra Kulkarni** (2025-06-10 13:13):
@Remco Beckers @Bram Schuur @Louis Lotter

---

**Devendra Kulkarni** (2025-06-10 13:43):
https://stackstate.atlassian.net/browse/STAC-22886

---

**Bram Schuur** (2025-06-10 13:45):
Sorry for the late response @Devendra Kulkarni, and thanks fort filing the ticket! We have a backlog prio meeting on thursday, we'll get back to you then on where this lands on the backlog

---

**Devendra Kulkarni** (2025-06-10 13:47):
Thanks @Bram Schuur

---

**Javier Lagos** (2025-06-11 12:28):
Hello Team,

The customer HOKKAIDO UNIVERSITY (https://suse.lightning.force.com/lightning/r/Case/500Tr00000aggxYIAQ/view)  wants to use the operator "AND"  when defining resource tags on the notifications. Based on the documentation it seems that this operator works as "OR" which means that whether we define 2 resource tags like "cluster-name: local" and "namespace: suse-observability" we will receive notifications of the name SUSE observability and the cluster local instead of just the namespace SUSE observability within the local cluster. https://docs.stackstate.com/monitors-and-alerts/notifications/configure#scope
```Component tags: Select 1 or more component tags. Notifications will only be sent for health states of components that have at least one of the selected tags.```
Is there a way to achieve this "AND" operator when defining resource tags on the notifications? If not, can we implement this feature on future versions? I think that having a more flexible notification configuration could be interesting for the product.

Thanks!

---

**Frank van Lankvelt** (2025-06-11 12:31):
this functionality is indeed on our short-term backlog.  The idea is now to AND tags with different prefixes, while OR-ing those with the same prefix.

---

**Javier Lagos** (2025-06-11 12:32):
Thanks @Frank van Lankvelt. Do we have any expected ETA for this implementation or release version that will contain this feature?

---

**Frank van Lankvelt** (2025-06-11 14:24):
maybe @Bram Schuur or @Mark Bakker can say something about that

---

**Bram Schuur** (2025-06-11 14:26):
It is on the short-term backlog, I'd say months rather than weeks. Thats as specific as i can be with a delivery estimate

---

**Bram Schuur** (2025-06-11 14:27):
@Javier Lagos this is the existing story: https://stackstate.atlassian.net/browse/STAC-22716

---

**Amol Kharche** (2025-06-12 07:58):
Hello Team,
The customer Fortinet technologies (https://suse.lightning.force.com/lightning/r/Account/0015q000008jRSxAAM/view) trying to configure Opsgenie notification and encountered an error during setup: '*Error while calling the Opsgenie API*.
I am unable to create account on Opsgenie(Looks like no option to when clicking signup ) to replicate issue.
For now I have asked them to double check API key and share the support bundle logs.
They are using v2.3.4.  Could you please advise? Thank you.

---

**Vladimir Iliakov** (2025-06-12 08:08):
We do use OpsGenie notification, it works on with 2.3.4

---

**Vladimir Iliakov** (2025-06-12 08:09):
The nonexistent API key throws this error

---

**Vladimir Iliakov** (2025-06-12 08:11):
Is it possible that the traffic from the instance to Opsgenier is "firewall"-ed in any way?

---

**Amol Kharche** (2025-06-12 08:14):
I will confirm with customer.

---

**Bruno Bernardi** (2025-06-12 18:55):
Hi @Vladimir Iliakov. Sorry for the delay in getting back to you. I performed the procedure together with the customer yesterday, and we could fix it. The environment is up and running. Thanks to all for your support!

---

**IHAC** (2025-06-12 19:26):
@Bruno Bernardi has a question.

:customer:  Fortinet Technologies (Canada) ULC

:facts-2: *Problem (symptom):*  
Hi Team,

The customer is looking to use the RBAC Agent feature, which I understand is still in the development stage. The use case is that the customer would like to use the RBAC Agent properly with a self-signed CA and also use the RBAC definitions configured in Rancher.

The main question here is whether the RBAC agent will be able to work with a self-signed certificate, and if we could provide documentation for that once the feature is released.

Thanks in advance.

---

**Vladimir Iliakov** (2025-06-12 20:21):
I am glad to hear it. Thanks :thumbs-up: !!!

---

**Amol Kharche** (2025-06-14 07:45):
Customer said the API key is correct.
From SUSE OBS nodes, the Opsginie server is reachable:
```curl -kv https://api.opsgenie.com
*   Trying 99.86.38.111:443...
* Connected to api.opsgenie.com (http://api.opsgenie.com) (99.86.38.111) port 443 (#0)```

---

**Amol Kharche** (2025-06-14 07:46):
Also they want to point out that these 2 Opsgenie server URLs appear to be incorrect, outdated:
• US region: https://api.opsgenie.com
• EU region: https://api.eu.opsgenie.com
Could you please confirm whether these are still in use by SUSE OBS?
And are these links embedded in the SUSE OBS code?
Let us know if there is any fix or conf available.

---

**IHAC** (2025-06-16 06:35):
@Garrick Tam has a question.

:customer:  Fortinet Technologies

:facts-2: *Problem (symptom):*  
Customer logged in with customer role with topologyScope (see below), but the UI returns "No components found" message even though agents are deployed to the topologyScoped cluster.
```stackstate:
  authentication:
    file:
      logins:
        - username: tzhou
          roles: [ admin-obs ]
          passwordHash: 
    roles:
      custom:
        admin-obs:
          systemPermissions:
          - access-cli
          - access-explore
          - access-log-data
          - access-synchronization-data
          - access-topic-data
          - create-dashboards
          - create-favorite-dashboards
          - create-views
          - delete-dashboards
          - delete-favorite-dashboards
          - execute-component-actions
          - execute-component-templates
          - execute-node-sync
          - execute-restricted-scripts
          - export-settings
          - import-settings
          - manage-annotations
          - manage-ingestion-api-keys
          - manage-metric-bindings
          - manage-monitors
          - manage-notifications
          - manage-service-tokens
          - manage-stackpacks
          - manage-star-view
          - manage-telemetry-streams
          - manage-topology-elements
          - perform-custom-query
          - read-agents
          - read-metrics
          - read-permissions
          - read-settings
          - read-stackpacks
          - read-system-notifications
          - read-telemetry-streams
          - read-traces
          - run-monitors
          - update-dashboards
          - update-permissions
          - update-settings
          - update-visualization
          - upload-stackpacks
          - view-dashboards
          - view-metric-bindings
          - view-monitors
          - view-notifications
          viewPermissions:
          - access-view
          - save-view
          - delete-view
          topologyScope: "label = 'kube_cluster_name:stg-bby2-st-rh-04-ran-suse-obs'"```
What can be the reason for this?  Which component might recording a log event that returns the "No components found" message?

---

**Frank van Lankvelt** (2025-06-16 08:35):
Are you sure the label is present on those components?  The kube_cluster_name label is not one we put on components

---

**Bram Schuur** (2025-06-16 09:53):
We are not immediately planning self-signed certificate, but i write a story for it and see whether we will pick that up.

---

**Bram Schuur** (2025-06-16 09:56):
Dear @Devendra Kulkarni this for now got pushed to our medium-term backlog due to the workload we have on the team. Thanks for reporting:+1:

---

**Devendra Kulkarni** (2025-06-16 09:56):
okay, thanks for the update!

---

**Bram Schuur** (2025-06-16 09:59):
As a side-note: it seems the customer is trying to do kubernetes RBAC on the current RBAC system, which is being overhauled as we speak. Strong advise is to wait for that to be released. The current system is limited in many ways (hence the big update), would all-in-all be a better experience to strat with the proper system.

---

**Amol Kharche** (2025-06-16 10:12):
@Louis Lotter As Vladimir on leave till 22nd Jun ,Can someone please help me here.

---

**Louis Lotter** (2025-06-16 10:13):
@Fedor Zhdanov can you take a look ?

---

**Bram Schuur** (2025-06-16 10:32):
https://stackstate.atlassian.net/browse/STAC-22901

---

**Fedor Zhdanov** (2025-06-16 11:25):
https://docs.opsgenie.com/docs/api-overview And given its reaching end of support, I see the proposed options to migrate the accounts to either Jira Service Management (https://developer.atlassian.com/cloud/jira/service-desk-ops/rest/v2/intro/#jira-cloud-platform-apis) or Compass (https://developer.atlassian.com/cloud/compass/rest/v1/intro/#about). I don't really know how backwards compatible are these APIs, but Opsgenie claims the process is largely automated for most customers.

And I also have a (might be wrong one, though) feeling the API endpoints were finally deprecated. @Remco Beckers @Louis Lotter what was the path forward we agreed upon? Also, @Deon Taljaard. I don't have much experience with OpsGenie, so a second pair of eyes would be nice to have here.

---

**Deon Taljaard** (2025-06-16 11:39):
Hello, @Amol Kharche the OpsGenie URLs are hardcoded for the respective regions in the stackstate backend.

Good to know (according to this Atlassian post (https://www.atlassian.com/blog/announcements/evolution-of-it-operations)): the above mentioned OpsGenie URLs should still be functioning until April 4th, 2027. But, like Fedor mentioned, we'll want to do the compat. assessment, consider migration options, etc.

---

**Deon Taljaard** (2025-06-16 12:17):
Quickly checked the compatibility between OpsGenie and Jira service management (broadly speaking):
• api version in resource paths are different (minor) 
• the shape of the request/response bodies are largely the same (minor)
• users/team management is done through the Jira/atlassian platform - so different APIs and signatures compared to opsgenie (more involved - need to integrate with additional atlassian APIs)
• different auth mechanism: OpsGenie uses API keys, Jira svc management uses Oath (access/refresh tokens) and api keys for simple API operations (more involved)
So for our current OpsGenie flows, we won't be able to swap them out without a bit of planning and effort to support Jira mgmt service.

---

**Amol Kharche** (2025-06-16 12:21):
Thanks , But I'm little but confused how can we resolve issue for now as the above mentioned OpsGenie URLs still functioning.

---

**Amol Kharche** (2025-06-16 12:22):
Have we ever seen this error '*Error while calling the Opsgenie API*.'?

---

**Deon Taljaard** (2025-06-16 13:06):
It could basically be any non-2xx status code.

One hunch I have is about access permissions granted to the api key - could you ask them to check the access permissions for their api key (at least `read` , `create and update` and `configuration access`)?

I did some quick testing with the following script (the same APIs queried by the backend):
```#!/bin/bash

OPSGENIE_API_KEY="&lt;GENIE_KEY_GOES_HERE&gt;"
OPSGENIE_BASE_URL="https://api.opsgenie.com/v2"

# List of resources to query (like SUSE Observability would do)
resources=("users" "teams" "escalations" "schedules")

for resource in "${resources[@]}"; do
  echo "Checking $resource..."

  response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET "$OPSGENIE_BASE_URL/$resource" \
    -H "Authorization: GenieKey $OPSGENIE_API_KEY")

  body=$(echo "$response" | sed -e 's/HTTPSTATUS\:.*//g')
  status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

  if [[ "$status" -eq 200 ]]; then
    echo "✅ Success: $resource"
  else
    echo "❌ Error: $resource (HTTP $status)"
    echo "Response: $body"
  fi

  echo
done```

---

**Amol Kharche** (2025-06-16 13:24):
Thanks I will ask customer.

---

**Amol Kharche** (2025-06-16 13:47):
I am guessing the above script should run from any of the SUSE Observability node Right?

---

**Deon Taljaard** (2025-06-16 13:52):
It won't hurt, but this is just to check the permissions on the api key, so any host will do.

---

**Amol Kharche** (2025-06-16 15:16):
@Garrick Tam Just to give clear picture on topolocyScope parameter.
I created 2 roles `admin-obs`  and `development-troubleshooter` , 4 users [ `amol, devendra, rajesh, ankush`] .
Here is my authentication.yaml file used when deploying stackstate. I manually applied labels to component like nodes, svc on one of my `rancher`cluster.
```$ kubectl get nodes -L kube_cluster_name
NAME     STATUS   ROLES                  AGE     VERSION        KUBE_CLUSTER_NAME
amolk1   Ready    control-plane,master   4h23m   v1.32.5+k3s1   dev-test

$  kubectl get svc -L  kube_cluster_name
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE     KUBE_CLUSTER_NAME
kubernetes   ClusterIP   10.43.0.1    &lt;none&gt;        443/TCP   4h24m   dev-test

$ kubectl get svc -n cattle-system -L  kube_cluster_name
NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE     KUBE_CLUSTER_NAME
imperative-api-extension   ClusterIP   10.43.97.105    &lt;none&gt;        6666/TCP         4h23m   dev-test
rancher                    ClusterIP   10.43.158.189   &lt;none&gt;        80/TCP,443/TCP   4h24m   dev-test
rancher-webhook            ClusterIP   10.43.131.161   &lt;none&gt;        443/TCP          4h21m   dev-test```
I logged with the rajesh user with `development-troubleshooter`  role and I can only see the the components which has `kube_cluster_name:dev-test`  labels.

---

**Bruno Bernardi** (2025-06-16 16:44):
Thanks, @Bram Schuur. I'll monitor the ticket.

---

**Garrick Tam** (2025-06-16 18:18):
Wow, so topologyScope: "label = 'kube_cluster_name:dev-test'" is based on K8S object labels?  The documentation is wrong and misleading --&gt; https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_roles#custom-roles-with-custom-scopes-and-permissions-via-the-configuration-file

"To set up a new role called `development-troubleshooter`, which will allow the same permissions as the predefined troubleshooter role, but only for the `dev-test` cluster"

---

**Garrick Tam** (2025-06-16 18:18):
Note the wording "but only for the dev-test cluster".

---

**Amol Kharche** (2025-06-16 18:24):
Yes, they are Kubernetes object labels. Earlier, I assumed it was the cluster name (like installing slackpack), but I don't think that's the case.

---

**Garrick Tam** (2025-06-16 18:25):
Does "topologyScope: "label = 'kube_cluster_name:dev-test'"" mean k8s object with label dev-test from all k8s instances?

---

**Amol Kharche** (2025-06-16 18:31):
Yes, based on my testing in the lab, these are Kubernetes objects (Pods, Deployments, CronJobs, Services, Nodes, etc.) that have labels, regardless of the cluster they belong to.

---

**Garrick Tam** (2025-06-16 18:47):
Thank you, @Amol Kharche

---

**Amol Kharche** (2025-06-16 18:48):
Just in case if you want to exclude some objects then `topologyScope: "label != 'kube_cluster_name:dev-test'"`  can be used.

---

**Garrick Tam** (2025-06-16 18:49):
good to know

---

**Frank van Lankvelt** (2025-06-16 19:59):
There is a label automagically generated with "key" `cluster-name`.  So you may be able to use `topologyScope: "label = 'cluster-name:dev-test'"` without too much effort

---

**Garrick Tam** (2025-06-16 20:00):
thank you.  That will work better.

---

**Bram Schuur** (2025-06-18 09:06):
@Devendra Kulkarni sorry for the late response. What is your use-case for wanting to log succesful login attempts? Is it auditing or something else?

---

**Devendra Kulkarni** (2025-06-18 09:25):
After logging in to SUSE Observability, there is no log reported.
There should be a log line, simply stating:
"User - &lt;username&gt; logged in successfully using &lt;authentication method&gt;"

---

**Devendra Kulkarni** (2025-06-18 09:26):
current behavior is that after successful login, no log is reported, but for a unsuccessful login attempt, the log is reported.
For example, invalid credentials

---

**Devendra Kulkarni** (2025-06-18 09:28):
Use case would definitely be auditing

---

**Frank van Lankvelt** (2025-06-19 11:37):
as a workaround, could you see what happens if you increase (say, double) the interval for that monitor?

---

**Frank van Lankvelt** (2025-06-19 11:39):
the error indeed indicates that the monitor function is not able to load all components within the allotted time - so HBase performance is indeed likely the issue

---

**Saurabh Sadhale** (2025-06-19 13:57):
@Frank van Lankvelt I will check with Thomas once.

Thank you for the confirmation about the Hbase.

---

**Bram Schuur** (2025-06-23 08:59):
@Devendra Kulkarni filed the following tickeT: https://stackstate.atlassian.net/browse/STAC-22946 it will be prioritized next thursday, but I think it will land quite low on the backlog, this being the first official request and the workload currently of the teams.

---

**Devendra Kulkarni** (2025-06-23 10:39):
Thanks @Bram Schuur

---

**Bruno Bernardi** (2025-06-23 17:09):
Hi @Bram Schuur @Louis Lotter @Mark Bakker,

Hope you're doing well.

The customer *Fortinet Technologies (Canada) ULC* has  reported to me on the support case that the RBAC Agent with a self-signed certificate is a really important feature for them to follow their security practices:
```Given the importance of this feature for our use case — where SUSE OBS will be deployed in an enterprise environment (not accessible to the public) — using our company's internal self-signed CA makes the most sense. We wanted to check if there is an opportunity to prioritize support for self-signed CA certificates, particularly for environments with an internal PKI.```
Based on that, their Manager kindly asked on the support case if it is possible for us to prioritize this feature. This feature will be a key factor for Fortinet's decision regarding the use of SUSE Observability. They'd appreciate any insight into how this might be prioritized in the roadmap.

IMO, this could be a great opportunity with this customer, and I understand that they can use SUSE observability for many of their environments.

Thanks, and look forward to your feedback.

---

**IHAC** (2025-06-24 16:24):
@Rodolfo de Almeida has a question.

:customer:  Fortinet Technologies (Canada) ULC

:facts-2: *Problem (symptom):*  
Customer found that SUSE Observability UI stopped responding on Monday, June 23rd.
On Friday, June 20th, the UI was working without issues.
It looks like the issue has occurred repeatedly and after the service has been running for 2 or 3 days the UI shows an error.
```No components found```
I am attaching the logs from SUSE Observability.
I can only see errors in the server pod. The server_previous.log shows logs only from June 21st and the server.log shows logs from June 23rd after a complete restart of the environment.

Could you please help me to identify what is causing the UI problem?

---

**Frank van Lankvelt** (2025-06-24 17:01):
there are many Unauthorized errors in the receiver logs.  Was the agent perhaps deployed with the wrong key?

---

**Rodolfo de Almeida** (2025-06-24 17:15):
I can double-check it.
I am trying to schedule a meeting with the customer to collect more information.
Is this agent issue contributing to the UI stopping working?

---

**Frank van Lankvelt** (2025-06-24 22:22):
Well if the agent cannot send any data, then there is no data in SUSE Observability.  And the UI cannot show anything.

---

**Rodolfo de Almeida** (2025-06-24 23:05):
ok thanks for confirming. I am still waiting the customer to accept my meeting invitation

---

**Rodolfo de Almeida** (2025-06-25 13:27):
This is the current role created by the customer.
``````
roles:
admin: ["grp-arcus-cdp-cdp-all-admin"]
custom:
grp-suse_observability-reader:
systemPermissions:
- execute-component-actions
- export-settings
- manage-monitors
- manage-notifications
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
topologyScope: "label = 'agriculture.gouv.fr/qsi:cdp (http://agriculture.gouv.fr/qsi:cdp)' and label = 'agriculture.gouv.fr/tenant:cdp (http://agriculture.gouv.fr/tenant:cdp)'"
``````

---

**Rodolfo de Almeida** (2025-06-25 13:29):
The customer found this setting in the values.yaml which generate a permission to access views on all resources:
```roles: 
 custom: 
   grp-suse_observability-reader: 
     viewPermissions: 
      - access-view ```
They have tried to set a specific view called `my_view`
``` roles: 
 custom: 
   grp-suse_observability-reader: 
     viewPermissions: 
      - access-view:my_view```
But it doesn't work.

---

**Frank van Lankvelt** (2025-06-25 13:37):
a headsup first: we're currently reworking this part in an effort to have a smooth RBAC integratoin with Rancher, so there quite some changes upcoming - including the possibility of granting access to a view with helm chart values.

Having said that, with the currently released helm chart this is not possible.  It IS possible to do this with a subject that is created with the CLI.  See https://docs.stackstate.com/self-hosted-setup/security/rbac/rbac_permissions#allow-a-user-to-open-a-view for details on that.

---

**Rodolfo de Almeida** (2025-06-25 13:57):
Ok got it. 
Thanks Frank. I will talk and explain that to the customer

---

**Bram Schuur** (2025-06-25 13:59):
Dear bruno, thanks for relaying this to us. After discussing the ticket indeed our initial plan is to more clearly document the skipSSLVerify  flag. Given that the customer fotinet is looking for the properyl secured PKI solution I will update the ticket with that wish and re-submit the ticket for prioritization. Stay tuned

---

**Bruno Bernardi** (2025-06-25 14:53):
Great. Thanks for your attention and feedback, @Bram Schuur. Please keep me posted. I'll stay tuned.

---

**IHAC** (2025-06-25 15:07):
@Bruno Bernardi has a question.

:customer:  Hokkaido University

:facts-2: *Problem (symptom):*  
The customer, Hokkaido University, is asking if SUSE Observability has any resources/templates to monitor the GPU Metrics and Performance(e.g., in conjunction with Nvidia DCGM Exporter).

I've evaluated the official documentation and previous Slack threads, and it looks like this feature is not covered at the moment. Can you please confirm if this is correct and if we've any plans for this in the future?

Thanks in advance.

---

**Mark Bakker** (2025-06-25 19:09):
SUSE AI has this as an extension for SUSE Observability

---

**Bram Schuur** (2025-06-26 16:41):
To confirm: the ticket did end up low on our backlog (our requested features), due to this being a first request so far.

---

**IHAC** (2025-07-03 01:54):
@Rodolfo de Almeida has a question.

:customer:  LCA Vision

:facts-2: *Problem (symptom):*  
The customer is implementing SUSE Observability and sent the following message.

Is this something possible to do or planned for a future release?

Customer question:
```We'd like to request enhanced support for querying logs across multiple pods within SUSE Observability. Currently, it appears that logs can only be accessed at the individual pod level, which limits cross-pod visibility during debugging and incident response.
Specifically, we're looking for the ability to:
- Query all logs for a given application service across multiple pods
- Search for log entries containing a specific value (e.g., a CorrelationID) across multiple services and pods
This type of unified log view would bring logging in line with the streamlined, cross-component visibility already offered for metrics and traces.
We'd appreciate any guidance on whether this functionality is currently available or planned for a future release.```

---

**Remco Beckers** (2025-07-03 08:44):
This is on the roadmap, I've added LCA Visions request to that roadmap item. There is no hard date planned for this either, current thinking is somewhere in 2026 but this may still still move

---

**Rodolfo de Almeida** (2025-07-03 16:08):
ok thanks a lot @Remco Beckers
Is there a way the customer can track when this feature will be available?
Is there a Github feature request or something that may help the customer tracking it?

---

**Remco Beckers** (2025-07-03 16:13):
Not that I know. @Mark Bakker is there a way for customers to track this?

---

**Mark Bakker** (2025-07-03 16:30):
We don't support customer tracking of feature development

---

**Rodolfo de Almeida** (2025-07-03 16:45):
Ok thansk for confirming

---

**IHAC** (2025-07-04 19:56):
@Rodolfo de Almeida has a question.

:customer:  LCA VIsion

:facts-2: *Problem (symptom):*  
We’ve received a request from a customer who is currently installing and testing SUSE Observability (v2.3.5). They are looking to implement a feature that they rely on heavily in tools like Splunk and Grafana/Loki.

*Customer Requirement*
They need the ability to trigger an *email alert* whenever a log entry contains a specific string, namely `!ERROR!`. The alert must include the *full log line* that triggered it.
This marker is deliberately inserted by their software to indicate conditions that require immediate operational attention. Their goal is to alert their Operations team before customer impact occurs.

I couldn't find an option to attend customer request.
Is this possible to achieve in the current version?
If not, are you planning to include this feature in a furutre version?

---

**Rodolfo de Almeida** (2025-07-04 19:57):
@Mark Bakker Is there a Jira ticket that I can follow for this new feature? The customer asked me to keep the case open and provide an update as soon as this feature is implemented.

---

**Mark Bakker** (2025-07-07 09:35):
@Rodolfo de Almeida we don't have tickets for this epic yet. Those will be created shortly before we start executing on this epic.

---

**Bram Schuur** (2025-07-07 09:43):
I added this to the feature request backlog.

I think for now this is not on the roadmap yet, given it is a first request. Agreed @Mark Bakker?

---

**Mark Bakker** (2025-07-07 10:07):
It is indeed not yet. When we start with our enhanced log epic we will add a feature to convert logs into metrics and with that you can alert.

---

**Bram Schuur** (2025-07-07 10:09):
Gotcha, one thing to note here: the request here is to include the log line in the final notification. To make that happen going through metrics might make that tricky, but we'll cross that bridge when we get there.

---

**IHAC** (2025-07-08 09:33):
@Saurabh Sadhale has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
I am working with Dienst ICT Uitvoering (https://suse.lightning.force.com/lightning/r/Account/0011i00000wkkUAAAY/view) and they are interested to know release schedule for the on-going efforts of RBAC.

Do we have any tentative schedule that we can share with the customer ?

---

**Frank van Lankvelt** (2025-07-08 09:39):
this will be part of the upcoming release.  It is dependent on the Rancher 2.12 - which will feature the OIDC provider.  AFAIK that's going to be released in August.

---

**Bram Schuur** (2025-07-08 11:27):
@Bruno Bernardi This ended up on our medium-term backlog for now, so this will be months rather than weeks until picked up: https://stackstate.atlassian.net/browse/STAC-22970

---

**Rodolfo de Almeida** (2025-07-08 17:03):
ok thanks Mark!

---

**IHAC** (2025-07-09 07:18):
@Devendra Kulkarni has a question.

:customer:  Solidigm

:facts-2: *Problem (symptom):*  
[1] Please confirm if the licence key is only required for self-hosted setups and not for SUSE observability Cloud offering?

[2] If a customer is using both, self hosted and cloud offering, whats the support offered?

I referred to a slide deck and it mentioned we only provide L1 support for SUSE Observability Cloud, need confirmation on support  structure for the cloud offering

---

**Louis Lotter** (2025-07-09 09:50):
1 Is correct. Only self hosted setups need a license key

---

**Louis Lotter** (2025-07-09 09:52):
2.

I do not believe we have discussed this scenario so the support should be considered separately.

@Mark Bakker Do you know more about this ?
@Amol Kharche maybe you know more

---

**Mark Bakker** (2025-07-09 12:03):
We don't offer support for the current cloud offering, it's community support

---

**Devendra Kulkarni** (2025-07-09 12:04):
So for self-hosted clusters, regular support that we offer.
For Saas offering, community support.

---

**Devendra Kulkarni** (2025-07-09 12:04):
When you mention current cloud offering, are we planning to offer support at later point in time?

---

**Mark Bakker** (2025-07-09 15:07):
There are indeed plans to make a change in our offerings.

---

**Amol Kharche** (2025-07-10 05:46):
The customer is already paying for the use of SUSE Observability Cloud and I think we should provide support just as we do for self-hosted.

---

**Mark Bakker** (2025-07-10 08:07):
The EULA for Cloud Observability does only include support by SUSE. This might change later but currently they can get community support by joining our slack channel observability on the rancher users slack (https://slack.rancher.com/).

---

**Saurabh Sadhale** (2025-07-10 13:19):
@Frank van Lankvelt

@Thomas Muntaner has successfully increased the interval for the monitor and also removed the biggest OTEL project but the problem still persists.

---

**Frank van Lankvelt** (2025-07-10 13:44):
it does now seem to be an other monitor that's running out of time (HTTP - 5xx error ratio) - but that in itself should also not cause the checks pod to crash.
Is it perhaps running out of memory?  You can increase memory limit by setting `stackstate.components.checks.resources.limits.memory=10Gi`, for instance.
Maybe you can find the error that caused the crash in Kubernetes; there may be a clue there.

---

**Bruno Bernardi** (2025-07-10 17:20):
Thanks, @Bram Schuur. I'll send this feedback to the customer and set some expectations with them. I'll keep monitoring the Jira. Please let me know if anything has changed on the plans.

---

**Amol Kharche** (2025-07-15 13:44):
Hi Team,
One of customer (Tieto) facing issue when updating license key. They are using fleet for automatic deployment.
The key is reflecting correctly in `suse-observability-license`  secret and can be view the same from server pod environment variable.
However the suse-observability UI still prompting to enter new license key.
1. We attempted to redeploy the server pod, but the UI continues to prompt for a license key.
2. We also tried reconfiguring the setup without SAML authentication, but the issue persists.
Customer prefer not to manually enter the license key via the UI since they are using Fleet for automation.
Can you please help here
cc: @Ankush Mistry

---

**Remco Beckers** (2025-07-15 13:53):
It is not possible at the moment to update the license key via the values or the secret. That secret is only used for bootstrapping on installation, after which the active key is stored in the database.

To update the key either:
• Use the UI
• Use the cli: `sts license update --key "the-new-key"`
In case of a reinstall it can be useful to still update the installation values.

---

**Amol Kharche** (2025-07-15 14:51):
&gt; That secret is only used for bootstrapping on installation, after which the active key is stored in the database
Where is actually stored? in which database?

---

**Remco Beckers** (2025-07-15 14:52):
In stackgraph, where all our configuration is stored

---

**Amol Kharche** (2025-07-15 14:52):
Okay, Thank you

---

**Ankush Mistry** (2025-07-15 17:01):
Can this be considered an enhancement request as the customer is asking for the consideration?

---

**Remco Beckers** (2025-07-15 18:40):
I've logged it as an enhancement request. We'll still need to prioritize it though

---

**Ankush Mistry** (2025-07-15 19:01):
Thank you!

---

**Bram Schuur** (2025-07-17 18:44):
I can confirm this feature will land with our rbac release which will released right after rancher 2.12

---

**Devendra Kulkarni** (2025-07-18 10:53):
Hi Team,
A customer Jemena Ltd (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTRqAAN/view) is installing stackpack on clusters using their CICD pipeline.
The issue they reported is that for the first time execution of their pipeline the stackpack is installed correctly and is visible in the observability server correctly. But on subsquent execution of pipeline, it creates a duplicate entry for same cluster.

Customer is asking if this can be handled internally by STS CLI or the only way for now is to add a logic to their pipeline to check if cluster is already added or not

---

**Devendra Kulkarni** (2025-07-18 10:54):
Adding their CICD pipeline for reference:
```suse-observability:
stage: .pre
image: alpine:latest
before_script:
- apk add --no-cache curl bash ca-certificates
- cp "$X1_PEM" /usr/local/share/ca-certificates/suse-observability-ca.crt
- update-ca-certificates
script:
- echo "Joining cluster $CI_PROJECT_NAME to SUSE Observability"
- curl -o- https://dl.stackstate.com/stackstate-cli/install.sh | STS_URL="$SOBS_URL" STS_API_TOKEN="$SOBS_TOKEN" bash
- export PATH=$PATH:/usr/local/bin
- sts context save default --url "$SOBS_URL" --api-token "$SOBS_TOKEN"
- sts stackpack install -n kubernetes-v2 -p kubernetes_cluster_name=$CI_PROJECT_NAME
- echo "SUSE Observability stackpack installed successfully"
rules:
- if: $CI_COMMIT_REF_NAME == "main"
when: manual```

---

**Jeroen van Erp** (2025-07-18 11:21):
In my scripts I use the following:

```  stackpacks=$(/usr/local/bin/sts stackpack list-instances --name kubernetes-v2 -o json --url $url --service-token $service_token)
  if [[ $(echo $stackpacks | jq -r '.instances[] | select(.config.kubernetes_cluster_name == "'$cluster_name'") | .id') ]]; then
    echo "&gt;&gt;&gt; StackPack for cluster '${cluster_name}' already exists"
  else
    /usr/local/bin/sts stackpack install --name kubernetes-v2 --url $url --service-token $service_token -p "kubernetes_cluster_name=$cluster_name" --unlocked-strategy fail
    echo "&gt;&gt;&gt; StackPack for cluster '${cluster_name}' installed"
  fi```

---

**Devendra Kulkarni** (2025-07-18 11:30):
Is there a possibility to add similar logic in the STS CLI -> stackpack installation cmd in future releases? If yes, LMK and I can open a JIRA for the same

[+] https://github.com/StackVista/stackstate-cli/blob/caf654ab5cf1180b5fbbd2d4594af5593cfb8488/cmd/stackpack/stackpack_install.go

---

**Jeroen van Erp** (2025-07-18 12:20):
I don’t know what the Engineering team thinks of that… Being the original author of this, I’m doubting whether we should do that in the CLI. Problem is, is that the CLI can install _any_ stackpack, the logic is agnostic of which stackpack it’s installing. Other StackPacks have different ways of identifying multiple instances (and some can only be installed once). If anywhere, we maybe should add this on the backend as a validation.

---

**Devendra Kulkarni** (2025-07-18 12:22):
@Louis Lotter your thoughts on this?

---

**Louis Lotter** (2025-07-18 12:40):
I'm not sure. Of course we should make the cli idempotent here if it's plausible.
@Remco Beckers how hard would that be to do considering what Jeroen mentioned.

---

**Remco Beckers** (2025-07-18 15:15):
We're working on a big epic to improve the way stackpacks work. I can add this as a problem that we want to solve to that work, but we aren't at the point. It relates to some other issues we have gathered (identifying/recognizing a stackpack instance is not very easy using only the numeric id). If we solve that first this should be simple after that.

---

**Saurabh Sadhale** (2025-07-22 08:08):
Hello Team,

I am working with Volvo Lastvagnar AB and they are facing a strange issue.

 As per the sizing profile they have set to 4000 HA but when they login to their SUSE Observability UI they are presented with a message “SUSE Observability has been configured to monitor a maximum of 250 nodes” and “ou have reached the maximum nodes limit”

After installing SUSE Observability agent on only two of the cluster which is ( 15 + 59 ) nodes they are receiving this notification.

Customers  worker nodes range from 32 cores with 186 GB RAM all the way to 196 cores and 3 TB RAM and some workers also have GPUs.

Helm repository: https://charts.rancher.com/server-charts/prime/suse-observability
Chart version: 2.3.5

---

**Bram Schuur** (2025-07-22 08:48):
We have a known issue that for the 4000-ha profile the reported amount is 250. This will be fixed in th next release, which should come out end of the week/start of next week.

---

**Saurabh Sadhale** (2025-07-22 08:51):
Awesome !! Can you share the issue number ?

---

**Bram Schuur** (2025-07-22 08:53):
https://stackstate.atlassian.net/browse/STAC-23099

---

**Alejandro Acevedo Osorio** (2025-07-22 09:25):
on the region server snippet I see
```ocal,16020,1753166095432. Name node is in safe mode. ```

---

**Alejandro Acevedo Osorio** (2025-07-22 09:25):
Check the Namenode to see why is in safe mode,

---

**Amol Kharche** (2025-07-22 09:31):
Hmm, Before that I see
```2025-07-22 06:26:16,506 WARN BlockStateChange: BLOCK* processIncrementalBlockReport is received from dead or unregistered node DatanodeRegistration(10.21.35.105:50010, datanodeUuid=3e296a2a-d65e-4d3d-851b-1dace180f6f3, infoPort=50075, infoSecurePort=0, ipcPort=9867, storageInfo=lv=-57;cid=CID-99e4b6f3-0211-45dd-9528-424d59e72d3b;nsid=420579009;c=1744200171299)
2025-07-22 06:26:16,601 ERROR BlockStateChange: *BLOCK* NameNode.blockReceivedAndDeleted: failed from DatanodeRegistration(10.21.35.105:50010, datanodeUuid=3e296a2a-d65e-4d3d-851b-1dace180f6f3, infoPort=50075, infoSecurePort=0, ipcPort=9867, storageInfo=lv=-57;cid=CID-99e4b6f3-0211-45dd-9528-424d59e72d3b;nsid=420579009;c=1744200171299): Got incremental block report from unregistered or dead node
2025-07-22 06:26:16,602 WARN BlockStateChange: BLOCK* processIncrementalBlockReport is received from dead or unregistered node DatanodeRegistration(10.21.35.70:50010, datanodeUuid=cfba8da2-f5a1-4c1f-9e52-83c404a8e7f2, infoPort=50075, infoSecurePort=0, ipcPort=9867, storageInfo=lv=-57;cid=CID-99e4b6f3-0211-45dd-9528-424d59e72d3b;nsid=420579009;c=1744200171299)
2025-07-22 06:26:16,602 ERROR BlockStateChange: *BLOCK* NameNode.blockReceivedAndDeleted: failed from DatanodeRegistration(10.21.35.70:50010, datanodeUuid=cfba8da2-f5a1-4c1f-9e52-83c404a8e7f2, infoPort=50075, infoSecurePort=0, ipcPort=9867, storageInfo=lv=-57;cid=CID-99e4b6f3-0211-45dd-9528-424d59e72d3b;nsid=420579009;c=1744200171299): Got incremental block report from unregistered or dead node```

---

**Alejandro Acevedo Osorio** (2025-07-22 09:31):
Yup `DatanodeRegistration` failed

---

**Alejandro Acevedo Osorio** (2025-07-22 09:32):
So probably a restart on the namenode or event both namenode and datanodes should help

---

**Amol Kharche** (2025-07-22 09:34):
Is there any dependency to restart? like namenode should restart before datanodes or can be restart independently ?

---

**Alejandro Acevedo Osorio** (2025-07-22 09:36):
They should reconcile no matter what you restart first. You could even just try the datanodes first so they communicate back to the namenode their registration

---

**Amol Kharche** (2025-07-22 09:38):
Okay,
Once the datanode and nodenode restarted should suse-observability-hbase-hbase-rs-0 come up automatically?

---

**Alejandro Acevedo Osorio** (2025-07-22 09:39):
I think so. Just make sure that you see on the namenode logs that the SAFE MODE is OFF.

---

**Alejandro Acevedo Osorio** (2025-07-22 09:40):
But just take a look at the logs of the RS and see it it resumes operation, otherwise a restart is Ok. and same with tephra ... they go cascading. After tephra then is already the different pod services turn

---

**Amol Kharche** (2025-07-22 09:40):
Cool, Thanks

---

**Amol Kharche** (2025-07-22 09:47):
Sorry I forgot to ask one more thing , As this is statefulset ,Do we just need to restart `-0` pod or scale down statefulset to 0 and then scale up?

---

**Alejandro Acevedo Osorio** (2025-07-22 09:56):
all of them are statefulsets. Can scale to 0 and then up ... or just delete the pods although there are 3 datanodes, 3 region servers, 2 tephra ...

---

**Ankush Mistry** (2025-07-22 12:35):
Hi Team,
A customer (Jemena Ltd (https://suse.lightning.force.com/lightning/r/Account/0011i00000KaTRqAAN/view)) is trying to configure notifications to the team’s channel they get the error:
```Unknown server error

Error Data
...{"_type":"NotificationChannelError","channelId":"219378381965601","message":"Sending test message failed: Error while calling the Teams."}```
I asked the customer to curl the webhook url from inside pod and here is the output:
```nobody@suse-observability-api-576b66c5fd-4x4jh:~$ curl https://prod-40.australiasoutheast.logic.azure.com -v
* Host prod-40.australiasoutheast.logic.azure.com:443 was resolved.
* IPv6: (none)
* IPv4: 20.211.194.165
*   Trying 20.211.194.165:443...
* Connected to prod-40.australiasoutheast.logic.azure.com (20.211.194.165) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (OUT), TLS alert, unknown CA (560):
* SSL certificate problem: self-signed certificate in certificate chain
* Closing connection
curl: (60) SSL certificate problem: self-signed certificate in certificate chain
More details here: https://curl.se/docs/sslcerts.html```
The customer has a firewall that inspects outbound traffic is possibly being intercepted by this.
They are asking if they can include the proxy CA cert as a trusted cert in the SUSE Observability deployment and how to fix this?

---

**Vladimir Iliakov** (2025-07-22 12:49):
Hi Ankush, here is explained how to inject certificates into SUSE Observability pods https://documentation.suse.com/cloudnative/suse-observability/next/en/setup/security/self-signed-certificates.html

---

**Vladimir Iliakov** (2025-07-22 12:54):
Be aware that the provided instructions is only for SUSE Observability application that uses a custom Java keystore, and not for `curl` that uses the system certificate store.

---

**Daniel Barra** (2025-07-24 14:49):
*We are pleased to announce the release of 2.3.6, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.3.6.html).*

---

**Bram Schuur** (2025-07-30 14:09):
*SUSE Observability 2.3.7 has been released which fixes a blocking migration issue in 2.3.6. For details, see the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.3.7.html).*

---

**Marc Rua Herrera** (2025-07-31 10:25):
Hey Bram. I am updating the helm repo, but still got 2.3.6 as the latest version:

Rabobank has the same in their environment. It is not public yet?

---

**Bram Schuur** (2025-07-31 10:27):
lemme check

---

**Bram Schuur** (2025-07-31 10:27):
it seems the pipeline failed, gonna try again

---

**Bram Schuur** (2025-07-31 10:55):
it succeeded now, it is in my repo, can you also see it?&gt;

---

**Marc Rua Herrera** (2025-07-31 11:53):
It is there. Thanks Bram!

---

**Devendra Kulkarni** (2025-08-01 05:51):
Hello Team,
Customer - Blue Cross Blue Shield of Arizona (https://suse.lightning.force.com/lightning/r/Account/0011i00000J9UpTAAV/view) has sent us a detailed email on the issue they observed while setting up SUSE observability on EKS cluster.
They have provided us with the solution they implemented and want us to:

• *Create an EKS Deployment Guide similar to what we have for ACK.*
• *Add Pre-flight Checks* 
• *and some helm related configurations.*
Attaching the detailed email here:

Appreciate if someone can go through it and let me know if specific issues need to be opened on JIRA.

---

**Vladimir Iliakov** (2025-08-01 09:02):
&gt; #1: EBS CSI Driver Authentication Failure 
The EBS CSI Driver is not part of SUSE Observability Helm chart and must be configured and installed separately at the cluster level. The chart has no control over or responsibility for EBS CSI Driver authentication - this is entirely a cluster infrastructure concern that needs to be resolved independently. There are multiple ways to install EKS and storage providers I am not sure the observability docs should cover that. In the ACK doc we only explain the Helm values specific to ACK and not giving any advice on the cluster configuration...

---

**Vladimir Iliakov** (2025-08-01 09:07):
BTW, do they install EKS with Rancher?

---

**Devendra Kulkarni** (2025-08-01 09:07):
Not sure, I will ask

---

**Devendra Kulkarni** (2025-08-01 09:07):
Looking at the above doc, I think they use terraform for spinning up EKS though

---

**Vladimir Iliakov** (2025-08-01 09:13):
Right, AWS recommends to install EBS CSI addon https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html#add-ons-aws-ebs-csi-driver, not sure if it can be done with Terraform though...

---

**Vladimir Iliakov** (2025-08-01 09:14):
Actually there is a Terraform resource for that https://registry.terraform.io/providers/hashicorp/aws/6.7.0/docs/resources/eks_addon

---

**Devendra Kulkarni** (2025-08-01 09:57):
Yes, customer has used that

---

**Remco Beckers** (2025-08-01 11:11):
The PVCs that are mentioned are all present in our Helm chart and are needed for proper functioning of the Helm chart.

Could it be that the PVCs didn't get created due to the EBS errors and that's why they had to manually create it afterwards? I can't reproduce the issue here at least

---

**Devendra Kulkarni** (2025-08-06 07:05):
sizing_values.yaml:
```---
# Source: suse-observability-values/templates/sizing_values.yaml
# profile 10-nonha
clickhouse:
  replicaCount: 1
  persistence:
    size: 50Gi

elasticsearch:
  prometheus-elasticsearch-exporter:
    resources:
      limits:
        cpu: "50m"
        memory: "50Mi"
      requests:
        cpu: "50m"
        memory: "50Mi"
  minimumMasterNodes: 1
  replicas: 1
  # Only overriding memory settings
  esJavaOpts: "-Xmx1500m -Xms1500m -Des.allow_insecure_settings=true -Xlog:disable -Xlog:gc*,gc+age=trace,safepoint:file=logs/gc.log:utctime,pid,tags:filecount=8,filesize=16m"
  resources:
    requests:
      cpu: 500m
      memory: 2500Mi
    limits:
      cpu: 1000m
      memory: 2500Mi
  volumeClaimTemplate:
    resources:
      requests:
        storage: 50Gi
hbase:
  version: "2.5"
  deployment:
    mode: "Mono"
  stackgraph:
    persistence:
      size: 50Gi
    resources:
      requests:
        memory: "2250Mi"
        cpu: "500m"
      limits:
        cpu: "1500m"
        memory: "2250Mi"
  tephra:
    resources:
      limits:
        cpu: "100m"
        memory: "512Mi"
      requests:
        memory: "512Mi"
        cpu: "50m"
    replicaCount: 1
kafka:
  defaultReplicationFactor: 1
  offsetsTopicReplicationFactor: 1
  replicaCount: 1
  transactionStateLogReplicationFactor: 1
  resources:
    requests:
      cpu: "800m"
      memory: "2048Mi"
    limits:
      memory: "2048Mi"
      cpu: "1600m"
  persistence:
    size: 60Gi
stackstate:
  experimental:
    server:
      split: false

  components:
    server:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_topologyQueryService_maxStackElementsPerQuery: "1000"
          CONFIG_FORCE_stackstate_topologyQueryService_maxLoadedElementsPerQuery: "1000"
          CONFIG_FORCE_stackstate_agents_agentLimit: "10"
          CONFIG_FORCE_stackstate_sync_initializationBatchParallelism: "1"
          CONFIG_FORCE_stackstate_healthSync_initialLoadParallelism: "1"
          CONFIG_FORCE_stackstate_stateService_initializationParallelism: "1"
          CONFIG_FORCE_stackstate_stateService_initialLoadTransactionSize: "2500"
      resources:
        limits:
          ephemeral-storage: 5Gi
          cpu: 3000m
          memory: 5Gi
        requests:
          cpu: 1500m
          memory: 5Gi
    e2es:
      resources:
        requests:
          memory: "512Mi"
          cpu: "50m"
        limits:
          memory: "512Mi"
    correlate:
      resources:
        requests:
          memory: "1250Mi"
          cpu: "500m"
        limits:
          cpu: "1000m"
          memory: "1250Mi"
    receiver:
      split:
        enabled: false
      extraEnv:
        open:
          CONFIG_FORCE_akka_http_host__connection__pool_max__open__requests: "256"
      resources:
        requests:
          memory: "1000Mi"
          cpu: "1000m"
        limits:
          memory: "1000Mi"
          cpu: "2000m"
    vmagent:
      resources:
        limits:
          memory: "640Mi"
        requests:
          memory: "384Mi"
    ui:
      replicaCount: 1
victoria-metrics-0:
  server:
    resources:
      requests:
        cpu: "500m"
        memory: 1500Mi
      limits:
        cpu: "1000m"
        memory: 1750Mi
    persistentVolume:
      size: 50Gi
  backup:
    vmbackup:
      resources:
        requests:
          memory: 256Mi
        limits:
          memory: 256Mi
victoria-metrics-1:
  enabled: false
  server:
    persistentVolume:
      size: 50Gi

zookeeper:
  replicaCount: 1```

---

**Devendra Kulkarni** (2025-08-06 07:06):
helm get values:

```NAME: suse-observability
LAST DEPLOYED: Wed Jul 30 17:23:08 2025
NAMESPACE: suse-observability
STATUS: deployed
REVISION: 5
TEST SUITE: None

USER-SUPPLIED VALUES:
clickhouse:
  persistence:
    size: 50Gi
  replicaCount: 1
elasticsearch:
  esJavaOpts: -Xmx1500m -Xms1500m -Des.allow_insecure_settings=true -Xlog:disable
    -Xlog:gc*,gc+age=trace,safepoint:file=logs/gc.log:utctime,pid,tags:filecount=8,filesize=16m
  minimumMasterNodes: 1
  prometheus-elasticsearch-exporter:
    resources:
      limits:
        cpu: 50m
        memory: 50Mi
      requests:
        cpu: 50m
        memory: 50Mi
  replicas: 1
  resources:
    limits:
      cpu: 1000m
      memory: 2500Mi
    requests:
      cpu: 500m
      memory: 2500Mi
  volumeClaimTemplate:
    resources:
      requests:
        storage: 50Gi
global:
  imageRegistry: registry.rancher.com (http://registry.rancher.com)
hbase:
  deployment:
    mode: Mono
  stackgraph:
    persistence:
      size: 50Gi
    resources:
      limits:
        cpu: 1500m
        memory: 2250Mi
      requests:
        cpu: 500m
        memory: 2250Mi
  tephra:
    replicaCount: 1
    resources:
      limits:
        cpu: 100m
        memory: 512Mi
      requests:
        cpu: 50m
        memory: 512Mi
  version: "2.5"
ingress:
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size (http://nginx.ingress.kubernetes.io/proxy-body-size): 50m
  enabled: true
  hosts:
  - host: insight.azblue.com (http://insight.azblue.com)
  ingressClassName: nginx
  tls:
  - hosts:
    - insight.azblue.com (http://insight.azblue.com)
    secretName: insight-ingress
kafka:
  defaultReplicationFactor: 1
  offsetsTopicReplicationFactor: 1
  persistence:
    size: 60Gi
  replicaCount: 1
  resources:
    limits:
      cpu: 1600m
      memory: 2048Mi
    requests:
      cpu: 800m
      memory: 2048Mi
  transactionStateLogReplicationFactor: 1
stackstate:
  apiKey:
    key: xxx
  authentication:
    adminPassword: xxxx
  baseUrl: https://insight.azblue.dev
  components:
    correlate:
      resources:
        limits:
          cpu: 1000m
          memory: 1250Mi
        requests:
          cpu: 500m
          memory: 1250Mi
    e2es:
      resources:
        limits:
          memory: 512Mi
        requests:
          cpu: 50m
          memory: 512Mi
    receiver:
      extraEnv:
        open:
          CONFIG_FORCE_akka_http_host__connection__pool_max__open__requests: "256"
      resources:
        limits:
          cpu: 2000m
          memory: 1000Mi
        requests:
          cpu: 1000m
          memory: 1000Mi
      split:
        enabled: false
    server:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_agents_agentLimit: "10"
          CONFIG_FORCE_stackstate_healthSync_initialLoadParallelism: "1"
          CONFIG_FORCE_stackstate_stateService_initialLoadTransactionSize: "2500"
          CONFIG_FORCE_stackstate_stateService_initializationParallelism: "1"
          CONFIG_FORCE_stackstate_sync_initializationBatchParallelism: "1"
          CONFIG_FORCE_stackstate_topologyQueryService_maxLoadedElementsPerQuery: "1000"
          CONFIG_FORCE_stackstate_topologyQueryService_maxStackElementsPerQuery: "1000"
      resources:
        limits:
          cpu: 3000m
          ephemeral-storage: 5Gi
          memory: 5Gi
        requests:
          cpu: 1500m
          memory: 5Gi
    ui:
      replicaCount: 1
    vmagent:
      resources:
        limits:
          memory: 640Mi
        requests:
          memory: 384Mi
  experimental:
    server:
      split: false
  license:
    key: xxxx
victoria-metrics-0:
  backup:
    vmbackup:
      resources:
        limits:
          memory: 256Mi
        requests:
          memory: 256Mi
  server:
    persistentVolume:
      size: 50Gi
    resources:
      limits:
        cpu: 1000m
        memory: 1750Mi
      requests:
        cpu: 500m
        memory: 1500Mi
victoria-metrics-1:
  enabled: false
  server:
    persistentVolume:
      size: 50Gi
zookeeper:
  replicaCount: 1```

---

**Vladimir Iliakov** (2025-08-06 08:41):
What the version of the Chart the use?

---

**Devendra Kulkarni** (2025-08-06 08:41):
Yes, I did check this as well and have already informed customer to re-try deployment as the EBS authentication issue is resolved

---

**Devendra Kulkarni** (2025-08-06 08:42):
I dont know what version they are using, I will confirm that

---

**Devendra Kulkarni** (2025-08-06 08:42):
Which version was this introduced?

---

**Vladimir Iliakov** (2025-08-06 08:49):
&gt; The SUSE Observability Helm chart failed to create several required PVCs, causing application pods to remain in `Pending` state.
I guess it possible that `helm install` failed to create PVC-s, but then it should throw the error message with the reason...

---

**Devendra Kulkarni** (2025-08-06 08:51):
Yes, and thats where I believe they also had EBS authentication issue, so these PVCs were not created and they ended up creating them manually.

---

**Devendra Kulkarni** (2025-08-06 08:51):
I have asked them above command outputs and also asked them to reproduce the issue in another env. I am sure they wont be able to reproduce as they have now resolved the EBS issue

---

**Chris Riley** (2025-08-06 12:09):
Hi @Remco Beckers (directing this to you since I see that Louis is on PTO)
Is it possible to get some movement for STAC-22509 (https://stackstate.atlassian.net/browse/STAC-22509)? The account team for Jemena (customer that raised this) have flagged this since it has been pending for several months now ... it would be good to know what the plans are.
:thankyou:

cc @Ankush Mistry

---

**Remco Beckers** (2025-08-06 13:33):
I've moved it up for prioritization in our next meeting (tomorrow or otherwise next week).

---

**Remco Beckers** (2025-08-06 13:33):
cc @Bram Schuur

---

**Chris Riley** (2025-08-06 13:38):
Thanks, Remco

---

**Devendra Kulkarni** (2025-08-08 10:32):
Hello Team,
Customer Solidigm (https://suse.lightning.force.com/lightning/r/Account/0011i00001Q8nVRAAZ/view) report a issue when using the commonLabels with their values.yaml while deploying SUSE-Observability.
There admission controller wants the resources to be labelled with some content and they tried using commonLabels as mentioned at - https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/values.yaml#L12

But only some of the components were deployed with the labels defined in commonLabels, other resources were not deployed with the label specified.

I was able to reproduce the issue locally and also found that kafka, zookeeper, elasticsearch and hbase have their own `elasticsearch.commonLabels` , `kafka.Labels`  fields but using them also does not work as expected.

---

**Devendra Kulkarni** (2025-08-08 10:33):
Is this something known?
Also whats the use of global commonLabels if it cannot apply labels on all resources, and one needs to specify labels on elasticsearch/zookeeper/kafka/hbase separately.

---

**Devendra Kulkarni** (2025-08-08 10:33):
There requirement to set these labels is due to admission controller settings and they need to have certain labels on all resources

---

**Devendra Kulkarni** (2025-08-08 10:34):
@Vladimir Iliakov @Remco Beckers Are you guys aware of any such issue? Do you think a JIRA will be helpful?
Any workaround for now? Manually editing the STS also isnt helping

---

**Vladimir Iliakov** (2025-08-08 10:36):
&gt; I was able to reproduce the issue locally and also found that kafka, zookeeper, elasticsearch and hbase have their own `elasticsearch.commonLabels` , `kafka.Labels`  fields but using them also does not work as expected.
If these labels don't work as expected then it might a bug.

---

**Devendra Kulkarni** (2025-08-08 10:41):
Adding labels manually to the statefulsets like zookeeper, kafka, etc works, but the pod does not inherit the labels in sts resources even after restarting the pods

---

**Devendra Kulkarni** (2025-08-08 10:41):
this is a blocker for customer... I will open a JIRA ticket and share here

---

**Vladimir Iliakov** (2025-08-08 10:48):
&gt; There requirement to set these labels is due to admission controller settings and they need to have certain labels on all resources
It would really help and speed up the  ticket resolution  if "all resources" can be reduced to a limited set of the resource types.

---

**Devendra Kulkarni** (2025-08-08 10:52):
Here's the JIRA - https://stackstate.atlassian.net/browse/STAC-23204

---

**Vladimir Iliakov** (2025-08-08 11:53):
@Remco Beckers something for refinement :point_up:

---

**Vladimir Iliakov** (2025-08-08 11:53):
Would be fun ))))

---

**Remco Beckers** (2025-08-08 11:55):
@Devendra Kulkarni Is your intention that this should apply the labels to literally all resources? Including (just to name a few), configmaps, secrets, poddisruptionbudgets, jobs, cronjobs, servcieaccount, role, clusterrole, etc..

---

**Remco Beckers** (2025-08-08 11:57):
In other words, what is the requirement from the adminssion controller here?

---

**Devendra Kulkarni** (2025-08-08 12:05):
I have asked the requirement to the customer, but I see below event from their support logs:

```4m24s       Warning   FailedCreate             job/suse-observability-topic-create-08t151836                                Error creating: admission webhook "validation.gatekeeper.sh" denied the request: [sd-require-labels] All Pods must have the labels: `sd/applicationName`, `sd/businessUnit`, `sd/criticality`, `sd/dataClassification`, `sd/deploymentMode`, `sd/environment`, `sd/opsTeam`, `sd/requestor````
So I assume, customer is requesting labels only on pods, sts, deployment, replicaset, job, cronjob, the resources which create a pod

---

**Remco Beckers** (2025-08-08 12:20):
Looks like it even is only the pods (judging from that error), but it does make sense do cover all workloads then as well

---

**Devendra Kulkarni** (2025-08-08 12:22):
hmm, but Only assigning labels to pod will be possible?
I am assuming a condition if for any reason pod fails, then it is the replicaset/deployment/cronjob/sts who will create replacement pod and that will fail if they dont have the needed label

---

**Remco Beckers** (2025-08-08 12:46):
Pods don't inherit the labels from workloads. The pod spec in the workload defines the labels for the pod

---

**Remco Beckers** (2025-08-08 12:46):
But like I said: it makes sense to also label the workloads themselves for reference and consistency

---

**Devendra Kulkarni** (2025-08-11 06:51):
Is there a way a customer can get access to the full access to the SAAS - playground.stackstate.com (http://playground.stackstate.com)? IHAC Solidigm (https://suse.lightning.force.com/lightning/r/Account/0011i00001Q8nVRAAZ/view) who wants to explore RBAC and other aspects during their POC tests and are facing issues while setting up their own Stackstate instance, where i am helping them.

But meanwhile they want to complete the POC and requesting full access to the Saas environment.

---

**Bram Schuur** (2025-08-11 09:12):
We cannot give full acccess to playground.stackstate.com (http://playground.stackstate.com), it is a public instance so needs to be proper secure.

I created a ticket to include RBAC into the playground, to be able to showcase the feature there (without requiring full access): https://stackstate.atlassian.net/browse/STAC-23205

@Louis Lotter @Mark Bakker not sure what else we can do here, do we hand out trial SaaS instances that the customer could play with? I know we did in the past, not sure what we do with that now.

Also, K8s RBAC (a major revamp of the RBAC system) is of yet unreleased, the current RBAC that is there is pretty basic.

---

**Louis Lotter** (2025-08-11 11:25):
Can we not create an instance with the latest version and some data for them ?

---

**Louis Lotter** (2025-08-11 11:25):
with RBAC turned on etc.

---

**Bram Schuur** (2025-08-11 11:35):
We could I guess, we have to make sure it is clear it goes away

We also get a prospective customer work with an unreleased feature (e.G. no docs yet).

Also, new RBAC is meant to run from rancher, not SaaS.

So i think it's a no

---

**Bram Schuur** (2025-08-11 13:00):
Getting a poc SaaS without rbac can be done ofcourse

---

**Louis Lotter** (2025-08-11 13:01):
mm yeah not a good idea. @Devendra Kulkarni we are only launching RBAC next month so it won't even be on the playground yet.

---

**Mark Bakker** (2025-08-11 13:15):
Hi all, I am just back from vacation. I am happy to have a session with the customer to explain what is coming but a pre-release is not something I am aiming for.

---

**Devendra Kulkarni** (2025-08-11 14:13):
thank you for the updates! we managed to fix the issue and customer has his own observability deployed in a test env

---

**Amol Kharche** (2025-08-12 09:14):
Hi @Vladimir Iliakov,
We are getting error "*Conflict detected while committing*" in Kubernetes stackpacks  at our rancher-hosted stackstate instance (https://rancher-hosted.app.stackstate.io/) and even we don't see any data from any of the cluster which is healthy :white_check_mark:.
Can you please help.
cc: @David Noland

---

**Vladimir Iliakov** (2025-08-12 12:53):
It doesnt make any sense to me, <!subteam^S08HHSW67FE> <!subteam^S08HEN1JX50> does it to you?

There multiple instances of Stackpaks failing with the same error
          "message": "Conflict detected while committing ArgumentBooleanVal,ArgumentComparatorWithoutEqualityVal,ArgumentDoubleVal,ArgumentFailingHealthStateVal,ArgumentLongVal,ArgumentPromQLMetricVal,ArgumentStringVal,ArgumentTimeWindowVal,ArgumentTopologyPromQLMetricVal,ArgumentTopologyQueryVal,HAS_ARGUMENTS,HAS_PROMQL_METRIC,HAS_QUERIES,HAS_SYNC_COMPONENT_ACTIONS,HAS_TRAINING_PERIODICITY,IS_PARAMETER_FOR,MetricBinding,MetricBindingQuery,Monitor,Parameter,PromQLMetric,StackPackConfiguration,Sync,SyncActionCreateOnMerge,TopologyPromQLMetric. { table = vertex, conflicting *id = 110642438594785*, conflicting label = StackPackConfiguration, conflicting client = StackPackConfigTx.UpdateConfig, changes = SetVertexProperty{property=stackPackVersion, value=1.0.18-master-10824-845061c6-SNAPSHOT, elementId=110642438594785}, SetVertexProperty{property=lastUpdateTimestamp, value=1750766694552, elementId=110642438594785}, SetVertexProperty{property=status, value=WAITING_FOR_DATA, elementId=110642438594785} } StackTephraTransaction{ id: Optional[TransactionId(id=1750766694552000000)], name: StackPacks.Upgrading configurations, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.empty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1750766694584, threadName=StackStateGlobalActorSystem-stackstate.dispatchers.stackgraphWrapper-36, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional.empty }"
        },




This is the instance with conflicting id *`110642438594785`*
    {
      "config": {
        "kubernetes_cluster_name": "solera"
      },
      "error": {
        "action": "UPGRADE",
        "error": {
          "_type": "InternalServerError",
          "errorCode": 9999,
          "message": "Conflict detected while committing ArgumentBooleanVal,ArgumentComparatorWithoutEqualityVal,ArgumentDoubleVal,ArgumentFailingHealthStateVal,ArgumentLongVal,ArgumentPromQLMetricVal,ArgumentStringVal,ArgumentTimeWindowVal,ArgumentTopologyPromQLMetricVal,ArgumentTopologyQueryVal,HAS_ARGUMENT
S,HAS_PROMQL_METRIC,HAS_QUERIES,HAS_SYNC_COMPONENT_ACTIONS,HAS_TRAINING_PERIODICITY,IS_PARAMETER_FOR,MetricBinding,MetricBindingQuery,Monitor,Parameter,PromQLMetric,StackPackConfiguration,Sync,SyncActionCreateOnMerge,TopologyPromQLMetric. { table = vertex, conflicting id = 110642438594785, conflicting label =
 StackPackConfiguration, conflicting client = StackPackConfigTx.UpdateConfig, changes = SetVertexProperty{property=stackPackVersion, value=1.0.18-master-10824-845061c6-SNAPSHOT, elementId=110642438594785}, SetVertexProperty{property=lastUpdateTimestamp, value=1750766694552, elementId=110642438594785}, SetVert
exProperty{property=status, value=WAITING_FOR_DATA, elementId=110642438594785} } StackTephraTransaction{ id: Optional[TransactionId(id=1750766694552000000)], name: StackPacks.Upgrading configurations, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.emp
ty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1750766694584, threadName=StackStateGlobalActorSystem-stackstate.dispatchers.stackgraphWrapper-36, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional.empty }"
        },
        "retryable": false
      },
      "id": *110642438594785*,
      "lastUpdateTimestamp": 1750766802704,
      "stackPackVersion": "1.0.18-master-10755-3ddb2208-SNAPSHOT",
      "status": "ERROR"
    },

---

**Vladimir Iliakov** (2025-08-12 12:55):
~Looks like the tenant failed to upgrade Stackpack on start, can it be reason for the error?~
NVM, I think it failed to upgrade due to error.

---

**Remco Beckers** (2025-08-12 13:25):
If you try to upgrade it still fails like this?

---

**Vladimir Iliakov** (2025-08-12 13:33):
Let me try. I wanted to check with you first...

---

**Vladimir Iliakov** (2025-08-12 13:36):
The error is gone
Now it looks better
```❯ sts stackpack list-instances --name kubernetes-v2
ID              | STATUS           | VERSION                               | LAST UPDATED
262860479008458 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:35:04 2025 CEST
82145646248093  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:41 2025 CEST
124126210085585 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:35 2025 CEST
136640809682069 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:32 2025 CEST
249273104394385 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:29 2025 CEST
13349729040193  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:27 2025 CEST
216246396837930 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:23 2025 CEST
18527063551783  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:22 2025 CEST
6064685794303   | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:21 2025 CEST
110642438594785 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:34:14 2025 CEST
40155909676090  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:59 2025 CEST
74756055258233  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:57 2025 CEST
66291800086976  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:56 2025 CEST
247852409212121 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:54 2025 CEST
95435002736446  | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:47 2025 CEST
240567427113702 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:45 2025 CEST
131881536172803 | INSTALLED        | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:44 2025 CEST
152335136500821 | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
43049347744643  | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
237602686084127 | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
108412151488691 | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
51326978713125  | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
4155782028097   | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
37342280121524  | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
73074380546170  | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
115528820717180 | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST
244385433215822 | WAITING_FOR_DATA | 1.0.18-master-10924-98ca6654-SNAPSHOT | Tue Aug 12 13:33:01 2025 CEST```

---

**Remco Beckers** (2025-08-12 13:36):
Yeah. With that Waiting for data they are likely hitting the bug I have now an MR for open: https://stackstate.atlassian.net/browse/STAC-23110

---

**Remco Beckers** (2025-08-12 13:36):
About the no data: that is an unrelated issue I think.

---

**Remco Beckers** (2025-08-12 13:37):
Although I don't see any change in data volume coming in the volume is very low

---

**Remco Beckers** (2025-08-12 13:37):
But it has been like that for the last 30 days

---

**Remco Beckers** (2025-08-12 13:39):
I also don't see any errors where data is rejected due to invalid api keys etc.

---

**Remco Beckers** (2025-08-12 13:39):
Can you check whether the agents in the clusters for which you don't see any data are reporting errors in their logs?

---

**Amol Kharche** (2025-08-12 14:13):
I am checking "*centene-east*" cluster. Here is the logs from agent cluster.

---

**Remco Beckers** (2025-08-12 15:09):
There are no errors in those logs. They are sending data just fine (I just can't see where it's going, but I assume to the `rancher-hosted` address)

---

**Vladimir Iliakov** (2025-08-12 15:18):
I see the logs and metrics for this cluster in https://rancher-hosted.app.stackstate.io/ . But on the stackpack page it is in "waiting for data" state

---

**Remco Beckers** (2025-08-12 15:18):
Yes. That's the bug I mentioned https://stackstate.atlassian.net/browse/STAC-23110

---

**Remco Beckers** (2025-08-12 15:19):
Maybe we can check one of the clusters for which you don't see any data?

---

**IHAC** (2025-08-12 15:25):
@Javier Lagos has a question.

:customer:  DR Horton

:facts-2: *Problem (symptom):*  
The customer has opened a case to us because he noticed that after upgrading from version 2.3.5 to 2.3.7, the memory usage is now displayed in bytes, while in the previous version 2.3.5 it was displayed in MB/GB, so it is now less readable than before.

I have confirmed this behavior on my lab on both versions so what the customer is experiencing is reproducible.

On the other hand, I have not found  anything related to that change on the release notes yet.

Is this the expected behavior? Do we expect to have memory usage on bytes instead of MB or GB? May I know the reason of this change?

---

**Javier Lagos** (2025-08-12 15:25):
2.3.5 memory usage metric

---

**Vladimir Iliakov** (2025-08-12 15:25):
I don't see these clusters: noland-industries, david-corp, abax, testnv, macu on the cluster overview page. @Amol Kharche can you check the agents installed to these clusters?

---

**Javier Lagos** (2025-08-12 15:25):
2.3.7 memory usage metric

---

**Remco Beckers** (2025-08-12 15:46):
I've created a ticket for this problem this morning. https://stackstate.atlassian.net/browse/STAC-23223.

This was not an intentional change.

---

**Javier Lagos** (2025-08-12 15:49):
Thanks @Remco Beckers for sharing the jira case for the bug. Are we expecting to have this resolved on the next release version?

---

**Remco Beckers** (2025-08-12 15:50):
I'm not sure, because it will go out very soon.

---

**Amol Kharche** (2025-08-12 16:08):
`testnv` uninstalled because it is not present at all.

---

**Amol Kharche** (2025-08-12 16:08):
@David Noland I am unable to find out `noland-industries`, `david-corp`, `abax`, `macu` clusters, Somehow my login SSO not working for EMEA region. Can you please check if you can see in EMEA region? I dont see these cluster in US region.

---

**IHAC** (2025-08-12 16:10):
@Saurabh Sadhale has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
I am working with Dienst ICT Uitvoering (https://suse.lightning.force.com/lightning/r/Account/0011i00000wkkUAAAY/view) and there are facing a sync error.

Environment: Observability v2.3.7

Cluster: production cluster.

Summary:
They have deployed SUSE Obs  in production cluster and are running into a sync error. This sync error won’t resolve itself after some time, even if all pods are redeployed. The GUI is not available.

The issue will be resolved when all the data is deleted. They are not looking for fix the issue by doing that. Using the CLI it could be fixed however to access the sts cli they would need to be signed in to the GUI to use the CLI.

While accessing the CLI they are getting:

```Could not connect to https://dcmp-3000-observability.dictu.intern/api (undefined response type). ```
What is the best option to get rid of this sync error?

---

**Vladimir Iliakov** (2025-08-12 16:43):
Seems they use Keycloak for authentication, is it exposed with a self-signed certifucate?

---

**David Noland** (2025-08-12 17:51):
Abax and MACU churned and their rancher environments have been shut down. The other two are my test instances and are not always up (currently they are shut down)

---

**IHAC** (2025-08-13 04:39):
@Garrick Tam has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
Customer redeployed with help upgrade in order to address the ingress lost.  Afterwards, the UI does not show any data.  (See attached.).

The customer uses fleet to deploy agents to the 99 downstream clusters but only 16 of them have stackpack instances created.  This results in many receiver-process-agent HTTP 500 from IP belonging to the other agent nodes without stackpack instances that shouldn't be a concern.
To troubleshoot this, customer have uninstall agents with fleet from all downstream clusters and manually deployed to one of the 16 downstream clusters that has stackstack instances configured.
`victoria-metrics` is throwing a warning but I think it is from the downstream clusters that stopped reporting from the agents uninstall.  `state` pod is reporting a confleict detected while committing StatElementState.  Aside from these, all other pods seems to be without warning and error.

Customer is running v2.3.7.  Can I get some help to try and figure out why no data is showing in UI?

---

**Garrick Tam** (2025-08-13 04:41):
This is urgent for the customer.  Here's the support-log bundle from platform and the one downstream cluster where the agent is installed and stackpack instanced configured.

---

**Remco Beckers** (2025-08-13 08:16):
The login is failing because SUSE Observability cannot connect to the Keycloak server that is configured. It cannot connect because it can't validate the certificate that is used by Keycloak (that's the first exception).

A custom Java trust store is configured, but maybe it doesn't contain the certificate for the Keycloak server? Can you check that the CA certificate for Keycloak is included? See also the docs related to this (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/security/self-signed-certificates.html#_create_a_custom_trust_store) for the list command.

---

**Remco Beckers** (2025-08-13 08:17):
I'm not sure why you think the synchronization (I'm assuming topology synchronization) is related but the errors I saw for topology synchronization are entirely unrelated to the login problem and they look like a one-of that was recovered.

---

**Remco Beckers** (2025-08-13 09:28):
From the log files I see that the agents are sending data for the `testautomation-atom-01` cluster.
In the sync pod logs I also see that there should be 9038 components present for this cluster. So it looks like the data is coming in and is processed correctly.

I'm not sure what resource type we're looking at for which there are no components in the screenshot (the header is hidden by the menu bar). Trying another resource (pods or Kubernetes services should usually be present). A hard refresh in the browser can help to force a full reload can help as well. I didn't see an otel collector on the cluster so there will not be any OTel services, etc., only Kubernetes components.

Another explanation can be that custom roles and users have been defined using scopes. It can be the current user/role does not have the scope to view the components. In the configuration I did see several custom roles, but they all have the permission to view topology and are not limited via a scope query.

The VictoriaMetrics warning is no problem, the state service error is automatically retried and indeed didn't reappear (it is an hour old).

@Frank van Lankvelt @Bram Schuur Do you have any other suggestions.

---

**Bram Schuur** (2025-08-13 09:39):
I don't see anything obvious in the logs, it may be https://stackstate.atlassian.net/browse/STAC-23216 has influence on this (failing to upgrade permissions).

There is also this one that alex found at a different customer https://gitlab.com/stackvista/devops/helm-charts/-/merge_requests/1572.

Since i go on holiday tomorrow i don't think it is wise for me to engage with the customer, could one of you (@Remco Beckers @Frank van Lankvelt) and figure out what is going on?

---

**Frank van Lankvelt** (2025-08-13 09:59):
the sync service is full of these messages:
```2025-08-12 22:59:24,486 WARN  sync.Kubernetes - local - There were 1 errors while processing mapping functions, among which an error for ExternalId 'urn:kubernetes:external-volume:hostpath/surge-rancher-1/opt/cni/bin': Synchronization error: Illegal object for template: 'Generic Cluster Component Template'
for component with external id (urn:kubernetes:external-volume:hostpath/surge-rancher-1/opt/cni/bin) of type 'volume'
with error: Object Component{id=null} failed validation on fields: [layerIdentifier: Invalid identifier: .]```
but I've no idea what the impact is

---

**Bram Schuur** (2025-08-13 10:03):
hmm now i see, was the kubernetes stackpack updated to the latest version?

---

**Javier Lagos** (2025-08-13 10:20):
Looks like the customer has not updated Kubernetes StackPack to the latest version.

Just one question before updating StackPack... Since the upgrade button is available on the console I think that we can just click on it as it is considered minor upgrade version, right?

https://documentation.suse.com/cloudnative/suse-observability/latest/en/stackpacks/about-stackpacks.html#_new_minor_stackpack_version

---

**Frank van Lankvelt** (2025-08-13 10:29):
yeah, you can just click it - the upgrade will install a stackpack version that's compatible with the new (more loosely coupled) component types.

---

**Javier Lagos** (2025-08-13 10:30):
Just curious... Do we have any compatibility matrix between SUSE Observability versions and Stackpacks versions that I can share with customer?

---

**Bram Schuur** (2025-08-13 10:36):
We now have a pretty simplistic matrix where we say latest version of the platform uses the latest version of the stackpack. I will file a ticket to actually make the upgrade go automatic for our out of the box stackpacks so we do not run into this situation.

---

**Bram Schuur** (2025-08-13 10:43):
Ticket filed: https://stackstate.atlassian.net/browse/STAC-23236

---

**Garrick Tam** (2025-08-13 20:37):
Thank you.  The stackpacks upgrade worked.

---

**Garrick Tam** (2025-08-13 23:17):
got a follow-up question:
```Why it caused issue where I have been seeing that "Update" notice for a while and my cluster was not having problems until I redeployed to rectify the ingress loss?```

---

**Saurabh Sadhale** (2025-08-14 10:00):
Issue solved after the certificate truststore issue was resolved.

---

**Remco Beckers** (2025-08-14 10:24):
They mentioned running an upgrade of SUSE Observability, also there there were some errors relating to the synchronization in the log and the stackpack was not upgraded.

Even though we make changes in the APIs used by stackpacks backward compatible with older stackpack versions we do expect the default stackpacks  (Kubernetes, Open Telemetry) get upgraded. So a logical first step for us is to make sure all stackpacks are upgraded (that's also why we created now a ticket to automate that).

I could start searching for the exact cause in this case but that's not trivial with just the error message we got in the log, and likely time-consuming.

---

**Saurabh Sadhale** (2025-08-14 11:07):
Thank you for the help everyone :slightly_smiling_face:

---

**Remco Beckers** (2025-08-14 11:14):
Your welcome

---

**Ankush Mistry** (2025-08-14 11:32):
Hello Team, The same customer is asking if it is possible to isolate data view as project in rancher. Can RBAC agent do this?
Does that require every project with agent installed or just one agent in the cluster for all projects?

---

**Ankush Mistry** (2025-08-14 11:36):
I see the docs have this: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/role_based_access_control.html#_what_can_i_do_with_rbac

---

**Frank van Lankvelt** (2025-08-14 12:43):
We're in the process of releasing a new version of SUSE Observability that changes the RBAC quite a bit.  It will be possible to give access per project, with a single agent installation per cluster.

---

**Frank van Lankvelt** (2025-08-14 12:50):
You could take a look at the documentation branch staging-2.12 for guidance.  https://github.com/rancher/stackstate-product-docs/blob/staging-2.12/docs%2Fnext%2Fmodules%2Fen%2Fpages%2Fsetup%2Fsecurity%2Frbac%2FREADME.adoc (https://github.com/rancher/stackstate-product-docs/blob/staging-2.12/docs%2Fnext%2Fmodules%2Fen%2Fpages%2Fsetup%2Fsecurity%2Frbac%2FREADME.adoc)

---

**Garrick Tam** (2025-08-14 16:20):
I scheduled a call with customer.   Let’s wait until after the call to see if a root cause is needed to satisfy the customers concern.

---

**Garrick Tam** (2025-08-14 23:41):
Here's the support-log bundle.

---

**Garrick Tam** (2025-08-15 01:56):
Here's the support-log bundle.

---

**Garrick Tam** (2025-08-15 06:52):
Here's a screenshot of the kafka-0 df -h output from inside the pod.  The /bitnami/kafka is only using 16G/99G.  I couldn't do the same check against kafka-1 and kafka-2 because they are not running.

---

**Remco Beckers** (2025-08-15 08:24):
The quick fix now is to reduce the number of clusters sending data to SUSE Observability and to resize the PVCs for Kafka to make them bigger

---

**Remco Beckers** (2025-08-15 15:45):
In the logs I see only that a bootstrap token has accessed the API a few times.
Then also a failed attempt with a service token being used as Personal Token.

But then that's all. I would expect either a Successful or unsucessful authentication in the logs of the server pod for the service token and I don't even see that.

Can you try using the service token that you entered in the extension configuration from the cli to test that it works at all by creating a test context?

``` sts context save --url https://<your-instance> --service-token <the-token> --name test-token```

---

**Remco Beckers** (2025-08-15 15:53):
Some other potential causes that we can check if the token works ok:
• The URL that is provided in the extension configuration includes `https` or `http`
• SUSE Observability is installed with a custom root certificate. The proxy in Rancher doesn't, by default, know about the custom Root certificate so it will refuse the connection (though I'm not sure what the status code would be). We have a bit of documentation on our doc site (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/security/self-signed-certificates.html#_rancher_ui_extension_for_suse_observability) that refers to the Rancher docs to add the custom CA.

---

**Remco Beckers** (2025-08-15 16:14):
It's now almost at the top of the backlog, but we're very much focussed on releasing RBAC and some high and critical bug fixes (and lots of vacations at the moment). So I can't promise any timing yet. Also because the solution to this ticket is sadly not just a simple version bump but a lot more involved.

---

**Garrick Tam** (2025-08-15 18:44):
@Remco Beckers Looks like the kafka PVC is hard set to 100G.  What should the customer increase this to overcome the issue and potentially align with 500HA profile?

---

**Remco Beckers** (2025-08-18 08:33):
Answered here to keep the threads complete: https://suse.slack.com/archives/C07CF9770R3/p1755498994895459?thread_ts=1755215725.515129&cid=C07CF9770R3

---

**Remco Beckers** (2025-08-18 08:36):
Looks like the Kafka PVC question belongs to another thread though.

---

**Remco Beckers** (2025-08-18 08:36):
If the cluster, specifically the CSI storage driver, supports resizing volumes they can simply edit the PVCs `requests.storage` field of the PVC and it should be resized. We have documented the details of this here (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/data_retention.html#_resizing_storage).

---

**Remco Beckers** (2025-08-18 08:51):
I'm also happy to join a call with the customer to help them out.

---

**IHAC** (2025-08-21 10:41):
@Saurabh Sadhale has a question.

:customer:  Solidigm

:facts-2: *Problem (symptom):*  
Hello Team,

I am working with Solidigm customer who is trying to configure OTEL where they have their Self-Hosted SUSE Observability. They have configured the following

OTLP:

```exporters:
    otlp/suse-observability:
       auth:
           authenticator: bearertokenauth 
       endpoint: http://suse-observability-otel-collector.suse-observability.svc.cluster.local:4317
       tls:
          insecure: true
          insecure_skip_verify: true
       compression: snappy```
Error:
```2025-08-19T07:30:56.073Z warn grpc@v1.71.0/clientconn.go:1406 [core] [Channel #5 SubChannel #6]grpc: addrConn.createTransport failed to connect to {Addr: "suse-observability-otel-collector.suse-observability.svc.cluster.local:4317", ServerName:  "suse-observability-otel-collector.suse-observability.svc.cluster.local:4317", }.  Err: connection error: desc = "transport: authentication handshake failed: tls: first record does not look like a TLS handshake" {"grpc_log": true}```
OTLP over HTTP

```  otlphttp/suse-observability:
       auth:
           authenticator: bearertokenauth
       endpoint: http://suse-observability-otel-collector.suse-observability.svc.cluster.local:4318
       tls:
          insecure: true
          insecure_skip_verify: true
       compression: snappy```
Error:
```Error: invalid configuration: service::pipelines::metrics: references exporter "otlp/suse-observability" which is not configured
2025/08/19 07:36:51 collector server run finished with error: 
invalid configuration: service::pipelines::metrics: references exporter "otlp/suse-observability" which is not configured```
As per the documentation the endpoints are correctly configured:
https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/otlp-apis.html#_self_hosted_suse_observability

What else needs to be checked ?

---

**Hugo de Vries** (2025-08-21 14:15):
I have a very important demo coming up on teusday related to APM at customer Nationale Nederlanden. Looking at the traces on the playground I noticed they are displayed in a weird way. Doesnt seem to matter if trace is 10ms or 2minutes long. I have tried it in Incognito to exclude a cookie / cache issue. Any ideas whats happening and how to fix it?

---

**Hugo de Vries** (2025-08-21 14:26):
@Anton Ovechkin @Remco Beckers do you maybe know more? It's displayed like all spans have the same starting time &amp; parent

---

**Remco Beckers** (2025-08-21 14:27):
The rendering is correct. The `orders publish` span really takes more than a minute

---

**Remco Beckers** (2025-08-21 14:29):
You can also see the span duration monitor is deviating for the Checkout service

---

**Remco Beckers** (2025-08-21 14:29):
But I can't see a reason yet why that takes so long

---

**Remco Beckers** (2025-08-21 14:30):
Unless someone configured a very long delay in the feature flags for the demo

---

**Remco Beckers** (2025-08-21 14:32):
That's not the case though

---

**Remco Beckers** (2025-08-21 14:40):
Restarting the checkout service seems to have resolved the behavior.

---

**Remco Beckers** (2025-08-21 14:41):
The only reason I can think of why it would act like that is that it couldn't reach Kafka anymore after a bunch of pods got redeployed half a month ago

---

**Remco Beckers** (2025-08-21 14:44):
The error on the pipeline happens because only the `exporter` entry has been updated from `otlp/suse-observability` to `otlphttp/suse-observability`.

In the `pipeline` section all occurences of `otlp/suse-observability` also need to be replaced with `otlphttp/suse-observabilty`

---

**Remco Beckers** (2025-08-21 14:48):
For the first error, when using OTLP with `insecure: true`, it seems that GRPC simply refuses to send credentials over an insecure connection:
```grpc: the credentials require transport level security```

---

**Hugo de Vries** (2025-08-21 15:06):
ahh there you go, nice @Remco Beckers!

---

**Javier Lagos** (2025-08-21 15:08):
Thanks @Remco Beckers! After modifying pipeline section from otlp to otlphttp it worked on both methods (through insecure communication via internal service and Ingress with TLS certificate)

Regarding GRPC, In our documentation we mention that for self hosted installations we can use GRPC internal svc by configuring insecure=true  on the open telemetry collector config but it actually does not work as it looks like GRPC refuses to send credentials when the communication is not secure.

Therefore, should we modify the documentation pointing out that GRPC requires TLS communication and that it can be achieved through secure ingress? https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/otlp-apis.html#_self_hosted_suse_observability

---

**Hugo de Vries** (2025-08-21 15:09):
never fails

---

**Saurabh Sadhale** (2025-08-21 15:24):
@Javier Lagos  Can you please paste your latest working configurations ? I can share it with the customer.

• For OTLP and OTLP over HTTPS  both, it is mandatory to configure a Ingress with TLS certificate. Is that right ? 
• Also the Ingress service should be pointing to k8s serrvice _*suse-observability-otel-collector*_

---

**Remco Beckers** (2025-08-21 15:31):
I've made a small docs PR to remove the incorrect suggestion indeed and also to hopefully clarify that the pipelines section must also be edited: https://github.com/rancher/stackstate-product-docs/pull/70

---

**Javier Lagos** (2025-08-21 15:50):
Hey @Saurabh Sadhale, I have just updated pipeline configuration and modified everything that matches otlp/suse-observability to otlphttp/suse-observability.

For GRPC it is mandatory to access through a secure communication through TLS but for http you can configure both (internal svc with insecure=true or via ingress with a TLS certificate without insecure parameter)

---

**Hugo de Vries** (2025-08-22 12:37):
Another question from NN that we need to handle urgently. We are prepping the Go / No Go demo for coming teusday:
"After the upgrade to 2.3.7 (not yet on prod), I noticed that the domains of components suddenly pick up the wrong URN.

We created several domains under *“urn:system:auto”* to keep order and readability intact, but now it seems to ignore that and instead attaches them under *“urn:stackpack:agent-common”*.
Strangely enough, I also don’t see those domains under *“urn:stackpack:agent-common”* in the domain list, so is there actually a second hidden list of domains??

This is the relevant line from the component template: `"domain": {{ getOrCreate (identifier "urn:stackpack:agent-common" "Domain" element.data.domain) (identifier "urn:system:auto" "Domain" element.data.domain) (concat "Type=Domain;Name=" element.data.domain) }},`

Component templates now seem to have *domainName* and *domainIdentifier* instead of just a *domain* object, but I haven’t yet gotten the sync to accept that."

---

**Mark Bakker** (2025-08-22 14:29):
@Remco Beckers do you know?

---

**Remco Beckers** (2025-08-22 14:35):
I think this is related to the change Bram made for decoupling the settings.

While reading the name (for domain, layer and type) is used first to do a lookup in the available domains. Then, if there are multiple domains with the same name, the identifier is used for disambiguation. There is no requirement anymore to actually have an identifier or a Domain defined in the settings at all, but if you care about the order that is still needed indeed.

I'm not sure how the `getOrCreate` calls that are used in the component templates have been modified to support this change. I thought it should keep the existing behavior as it was.

---

**Remco Beckers** (2025-08-22 14:38):
Looking at the `getOrCreate` call you have though it is a bit confusing to me, it seems to say:
1. Use the `urn:stackpack:agent-common`  domain if it exists
2. If that doesn't exist create a domain in `urn:system:auto`
I'll need to check what getOrCreate does again and how it is intended to be used, because this usage seems a bit odd. So either I'm misunderstanding it or it is indeed part of the cause.

---

**Remco Beckers** (2025-08-22 14:41):
Aha ok. According to the 5.1 docs this is how it is supposed to be used.

---

**Remco Beckers** (2025-08-22 14:44):
@Hugo de Vries How did you come to the conclusion it attaches them under *“urn:stackpack:agent-common”*? Where did you find that?

---

**Hugo de Vries** (2025-08-22 14:45):
I quoted this all from Yolan from NN.

---

**Hugo de Vries** (2025-08-22 14:53):
I have asked him now what lead him to that assumption

---

**Remco Beckers** (2025-08-22 15:52):
I'm trying to look a bit further but will need to hand this over to someone else, next week I'm on vacation

---

**Frank van Lankvelt** (2025-08-22 15:53):
am also taking a look, but this is a piece of logic I'm thoroughly unfamiliar with

---

**Frank van Lankvelt** (2025-08-22 15:54):
next week @Alejandro Acevedo Osorio will be back, I hope he knows more about this

---

**Remco Beckers** (2025-08-22 15:54):
I think the trick is in the way this gets resolved to a domain name and identifier in the synchronization

---

**Remco Beckers** (2025-08-22 15:54):
But now I need to find where that is again :grimacing:

---

**Frank van Lankvelt** (2025-08-22 15:56):
in our own stackpacks, I only see hardcoded domainIdentifiers - or they're absent

---

**Remco Beckers** (2025-08-22 15:56):
Yeah. I think Bram updated our own stackpacks

---

**Frank van Lankvelt** (2025-08-22 15:56):
I think the safe thing to do for now is to just set the `domainName` to the domain that's received and continue

---

**Frank van Lankvelt** (2025-08-22 15:57):
without the `domain` and `domainIdentifier` fieldss that is

---

**Frank van Lankvelt** (2025-08-22 15:57):
I've not triaged the code yet that does actual auto-create

---

**Remco Beckers** (2025-08-22 15:58):
If there is only one domain with that name that should work I think. But I also thought that would even work when an identifier was present

---

**Hugo de Vries** (2025-08-22 16:16):
Thanks gents!

---

**Remco Beckers** (2025-08-22 16:20):
@Frank van Lankvelt Can you still tyr to figure out, or ask Alex to figure out, why this didn't keep working without a change? It seems like somehting we tried to prevent from happening but somehow didn't fully succeed.

---

**Frank van Lankvelt** (2025-08-22 16:26):
yeah, it certainly looks like it should still work

---

**Frank van Lankvelt** (2025-08-22 17:01):
hmm, maybe not.  The "suspended resolutions" don't make it out of the mapper.  So they can never be materialized as domain objects.  @Alejandro Acevedo Osorio: do you know the reasonnig behind this?

---

**Amol Kharche** (2025-08-23 09:10):
Hi Team,
Looks like there is something wrong with https://rancher-hosted.app.stackstate.io/ instance , We don't see any any data, Metrics looks good but when we click on pods, services, secrets .etc. its not going forward. Can you please help.
We recently upgraded agent from v1.0.46 to v1.0.61 on our observed clusters.

---

**David Noland** (2025-08-24 03:33):
This is what I see

---

**Alejandro Acevedo Osorio** (2025-08-25 09:20):
I think the reasoning behind is that there's nothing to resolve anymore as `domainName` `domainIdentifier` and the rest are loosely couple and with late binding/resolution ... so there's no need that the `SyncService` creates `domains` or other objects any more, the whole main idea was to detach settings from data

---

**Vladimir Iliakov** (2025-08-25 11:00):
@David Noland is it still the case?
I have the same permissions as your user, but it works fine for me

---

**Vladimir Iliakov** (2025-08-25 11:01):
Can you try the "incognito" mode to exclude or confirm cache/cookie/browser session  issues?

---

**Vladimir Iliakov** (2025-08-25 11:03):
@Amol Kharche
&gt;  We don't see any any data, Metrics looks good but when we click on pods, services, secrets .etc. its not going forward.
Can you be more specific?

---

**Vladimir Iliakov** (2025-08-25 11:03):
Your user is also similar to mine...

---

**Amol Kharche** (2025-08-25 11:06):
@Vladimir Iliakov Seems its working now,.
Earlier, when we navigated to *Clusters → [Cluster Name]* and clicked on any component like *Pods*, *Services*, or *Deployments*, the page would not proceed—it would get stuck with no error.

---

**Vladimir Iliakov** (2025-08-25 11:11):
I think, I saw it today myself, but I didn't pay attention, I just reloaded the page...

---

**Vladimir Iliakov** (2025-08-25 11:14):
@Alejandro Acevedo Osorio @Frank van Lankvelt @Deon Taljaard
I saw the error in API logs that might be related, about that time I was checking the tenant.
```2025-08-25 08:54:19,885 ERROR com.stackstate.api.streamapi.ViewSnapshotDiffStream - Cancelling stream because a StreamFailed was sent: ViewSnapshotDiffStream failed with exception class java.util.concurrent.TimeoutException: 'Timeout in StackGraph while getting work for stream. Timeout was Some(15 seconds)'.. ```
Any thoughts?

---

**Frank van Lankvelt** (2025-08-25 11:36):
is hbase perhaps under (very) heavy load?

---

**Deon Taljaard** (2025-08-25 11:40):
Sorry for the noob question, but what credentials do we use to log in to this instance?

---

**Alejandro Acevedo Osorio** (2025-08-25 11:42):
Is this a tenant we can observe via the Aegir instance?

---

**Vladimir Iliakov** (2025-08-25 11:47):
Yes, this is the link to aegir https://aegir.prod.stackstate.io/#/views/urn:stackpack:kubernetes-v2:shared:query-view:po[…]space%3Astackstate-rancher-hosted&amp;timeRange=LAST_3_HOURS (https://aegir.prod.stackstate.io/#/views/urn:stackpack:kubernetes-v2:shared:query-view:pods?detachedFilters=cluster-name%3Aprod-useast-1.prod.stackstate.io%2Cnamespace%3Astackstate-rancher-hosted&amp;timeRange=LAST_3_HOURS)

---

**Alejandro Acevedo Osorio** (2025-08-25 11:48):
https://aegir.prod.stackstate.io/#/components/urn:kubernetes:%2Fprod-useast-1.prod.stacks[…]-76d66995df-wdsks/metrics?metricTab=SUSE%20Observability (https://aegir.prod.stackstate.io/#/components/urn:kubernetes:%2Fprod-useast-1.prod.stackstate.io:stackstate-rancher-hosted:pod%2Francher-hosted-suse-observability-api-76d66995df-wdsks/metrics?metricTab=SUSE%20Observability) From the api pod transactions I see that in general are behaving Ok. Regions servers don't look under stress

---

**Vladimir Iliakov** (2025-08-25 11:48):
I checked CPU and JVM metrics of Hbase components, as far as I can tell they are ok.

---

**Alejandro Acevedo Osorio** (2025-08-25 11:50):
I agree, the logs look clean but for the single `Timeout` entry you already highlighted. As far I can tell the instance is Ok

---

**Frank van Lankvelt** (2025-08-25 11:51):
authentication is with some keycloak instance?

---

**Vladimir Iliakov** (2025-08-25 11:51):
I can create a user for you to troubleshot

---

**Vladimir Iliakov** (2025-08-25 11:58):
Yeah Keycloak did have some problems

---

**Frank van Lankvelt** (2025-08-25 12:00):
that would be my guess as well now.  Would certainly explain the "Forbidden" response

---

**Vladimir Iliakov** (2025-08-25 12:03):
Right, but it happened on 24th, whereas @Amol Kharche experienced problems a day before that. I don't see anything wrong on that day...

---

**IHAC** (2025-08-25 16:48):
@Rodolfo de Almeida has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
The customer has successfully integrated and is running Rancher with Observability. Administrator-level users are able to view all Observability-related data directly within the Rancher UI without any issues.
However, the problem arises with lower-privileged users. These users do not have access to the Rancher local (upstream) cluster and are only granted access to a specific downstream cluster, where they are assigned the "cluster member" role.

When one of these users attempts to view the Observability content in the Rancher UI, they encounter an error message such as:
```The SUSE Observability is not fully installed yet. Please install it in order to proceed to configuration:

AND

SUSE Observability is not enabled for this cluster.```
Is there a way to allow those users with less privilege to see the Observability integration?

---

**Rodolfo de Almeida** (2025-08-25 16:49):
What non-admin users are seeing in the Rancher UI.

---

**Rodolfo de Almeida** (2025-08-25 16:50):
This is what admin users are currently seeing. In this case everything working as expected.

---

**David Noland** (2025-08-25 16:53):
It's working fine now for me. Was getting the forbidden issues Friday, Saturday, and Sunday.

---

**Frank van Lankvelt** (2025-08-25 16:59):
hi @Rodolfo de Almeida - to be honest we hadn't considered this case yet.  The configuration necessary to fetch health data from SUSE Observability is persisted in the local cluster - so if a user is not able to access that, you'll get this behavior.
You may be able to get things working by granting access to at least some resources in the local  cluster, but I'm afraid I don't have an inventory of those.

---

**Rodolfo de Almeida** (2025-08-25 17:15):
Thanks Frank,
I am creating a lab environment and will do some tests and see if I can make it work,

---

**David Noland** (2025-08-25 17:47):
In the cluster view, the label used for Memory Capacity seems odd. For example, ops-prod has 32 GB, but reads "32.9 Bil". Is this by design?

---

**Javier Lagos** (2025-08-25 17:51):
I think that this is bug of 2.3.7 version. You can take a look at my message here https://suse.slack.com/archives/C07CF9770R3/p1755005120591499. @Remco Beckers created the following Jira ticket for this issue https://stackstate.atlassian.net/browse/STAC-23223

---

**David Noland** (2025-08-25 20:51):
ok, thanks for the info

---

**Surya Boorlu** (2025-08-26 10:21):
*Hello Team,*
We’ve received a customer case regarding *RBAC scoping in SUSE Observability v2.3.7*, and after analyzing their support bundle and server logs, we observed the following:
1.Customer roles use `topologyScope: "label = 'cluster-name:&lt;cluster&gt;'"` (and `sts rbac create-subject --scope ...`).
In v2.3.7(observability-server pod) the logs report:
_“Using queries for subject scoping is deprecated, but usr-rh-1001 still uses it (with query: label = 'cluster-name:usr-rh-1001').”_

As a result, these scoping rules are no longer being enforced, and users can see *all clusters* instead of being restricted to a single one.

Do we have any workaround for this? Also. any documentation available regarding the changes in the scoping model?

---

**Surya Boorlu** (2025-08-26 10:22):
cc: @Frank van Lankvelt

---

**Frank van Lankvelt** (2025-08-26 10:37):
hi Surya.  The behavior you're describing is unexpected.  Topology scopes are deprecated, but they should still work like before on 2.3.7.

You might want to try out upgrading to the new way of configuring RBAC anyway, see our preview docs at https://deploy-preview-41--suse-obs.netlify.app/suse-observability/next/en/setup/security/rbac/readme

---

**Surya Boorlu** (2025-08-26 10:41):
@Frank van Lankvelt Customer did mention they are following the same document.

---

**Surya Boorlu** (2025-08-26 10:42):
Oh okay, this document is not yet published.

---

**Surya Boorlu** (2025-08-26 10:44):
Is this the only difference:

---

**Frank van Lankvelt** (2025-08-26 10:47):
maybe good to realize that the permissions are only additive, so if the end-user is included in a group that CAN see all clusters then they will be able to.

---

**Surya Boorlu** (2025-08-26 10:56):
Sorry for the confusion, I didn't get it. So the old doc should work from 2.3.7 even it is deprecated. But, you are saying that the user might be in a group which has View clusters permissions?

---

**Frank van Lankvelt** (2025-08-26 11:00):
the new name would be `get-topology`, but yes that's my suspicion

---

**Surya Boorlu** (2025-08-26 11:21):
Got it. Thank you,

---

**Daniel Barra** (2025-08-26 12:13):
*We are pleased to announce the release of 2.4.0, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.4.0.html).*

---

**Surya Boorlu** (2025-08-27 12:53):
@Frank van Lankvelt Customer is using the below values


```roles:
   custom:
    usr-rh-1001:
     systemPermissions:
     - get-agents
     - create-favorite-views
     - delete-favorite-views
     - get-topic-messages
     - get-metrics
     - get-permissions
     - get-settings
     - get-metrics
     - update-metrics
     - get-traces
     - update-visualization
     - get-metric-bindings
     - get-notifications
     - create-notifications
     - update-notifications
     - delete-notifications
     - get-system-notifications
     - get-dashboards
     - create-dashboards
     - update-dashboards
     - delete-dashboards
     - create-favorite-dashboards
     - delete-favorite-dashboards
     - get-monitors
     - create-monitors
     - update-monitors
     - delete-monitors
     - execute-monitors
     - get-stackpacks
     - get-topology
     viewPermissions:
     - get-views
     - create-views
     - update-views
     - delete-views
     topologyScope: "label = 'cluster-name:usr-rh-1001'"```

---

**Frank van Lankvelt** (2025-08-27 15:04):
there's a `get-topology` under `systemPermissions`, that grants the role access to every component in the system

---

**Frank van Lankvelt** (2025-08-27 15:14):
if you look at https://deploy-preview-41--suse-obs.netlify.app/suse-observability/next/en/setup/security/rbac/rbac_roles#_custom_roles_via_the_configuration_file, you can also see the new way to configure this - without the `topologyScope`.  The equivalent would be
```roles:
  custom:
    usr-rh-1001:
     systemPermissions:
      - get-agents
          .... [ but no get-topology ]
     resourcePermissions:
       get-topology:
       - "cluster-name:usr-rh-1001"```
if you're feeling adventurous, you could also scope the access to metrics and traces:
```...
     resourcePermissions:
       get-topology:
         - "cluster-name:usr-rh-1001"
       get-metrics:
         - "k8s:usr-rh-1001:__any__"
       get-traces:
         - "k8s.cluster.name:usr-rh-1001"```

---

**Amol Kharche** (2025-08-28 07:04):
Hi Team,
We seen that the Kubernetes stackpacks is upgrading since long time and its stuck at our rancher-hosted stackstate  https://rancher-hosted.app.stackstate.io/. Can you please help.
```#  sts stackpack list-instances --name kubernetes-v2
ID              | STATUS    | VERSION                               | LAST UPDATED
51326978713125  | INSTALLED | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:52:08 2025 IST
152335136500821 | INSTALLED | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:19 2025 IST
131881536172803 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
43049347744643  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
66291800086976  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
237602686084127 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
108412151488691 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
18527063551783  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
124126210085585 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
79801207037544  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
216246396837930 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
6064685794303   | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
110642438594785 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
240567427113702 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
13349729040193  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
247852409212121 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
249273104394385 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
40155909676090  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
74756055258233  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
95435002736446  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
82145646248093  | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
136640809682069 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST
262860479008458 | UPGRADING | 1.0.18-master-10924-98ca6654-SNAPSHOT | Mon Aug 25 16:51:13 2025 IST```
cc: @David Noland

---

**Amol Kharche** (2025-08-28 07:06):
Do we need to upgrade stackpack to latest version  1.0.18-master-11059-38124ea1-SNAPSHOT ?
```$ sts stackpack list
NAME                    | DISPLAY NAME                | INSTALLED VERSION                     | NEXT VERSION | LATEST VERSION                        | INSTANCE COUNT
aad-v2                  | Autonomous Anomaly Detector | 1.0.1-master-11059-38124ea1-SNAPSHOT  | -            | 1.0.1-master-11059-38124ea1-SNAPSHOT  | 0
kubernetes-v2           | Kubernetes                  | 1.0.18-master-10924-98ca6654-SNAPSHOT | -            | 1.0.18-master-11059-38124ea1-SNAPSHOT | 23```

---

**Vladimir Iliakov** (2025-08-28 09:26):
I restarted an API pod and upgraded the Stackpack. It is "green" now.

---

**Amol Kharche** (2025-08-28 09:39):
If we came across such situation in customer environment then only option is to restart API pod right?

---

**Amol Kharche** (2025-08-28 09:41):
I am just curious why this is happened at initial stage :wink:

---

**Vladimir Iliakov** (2025-08-28 09:44):
I have no ideas :man-shrugging:

---

**Amol Kharche** (2025-08-28 09:46):
Can you let us know how you upgraded stackpack ? From sts cli ?

---

**Vladimir Iliakov** (2025-08-28 09:48):
From UI, after I restarted API, all stackpacks became green and the "upgrade" button appeared.

---

**Surya Boorlu** (2025-08-28 20:51):
Thanks Frank.

---

**Javier Lagos** (2025-08-29 11:26):
cc @Frank van Lankvelt

---

**Vladimir Iliakov** (2025-08-29 11:29):
The more reliable test would be to run a pod with nslookup/dig and check how resolution work from inside a pod.

---

**Javier Lagos** (2025-08-29 11:30):
We have done that already. Please take a look at it here

```kubectl run -it --rm --restart=Never --image=rancherlabs/swiss-army-knife dns-test-$i --overrides='{"spec": {"nodeSelector": {"kubernetes.io/hostname (http://kubernetes.io/hostname)": "nocloudprovider-worker-rhs9x-mj5rf"}}}' -- dig +short observability-rancher.nocloudprovider.acerta.io (http://observability-rancher.nocloudprovider.acerta.io)
10.30.80.246
pod "dns-test-nocloudprovider-worker-rhs9x-nzzdf" delete```

---

**Vladimir Iliakov** (2025-08-29 11:31):
can you do `cat /etc/resolv.conf` in both `swiss-army-knife` and router pod?

---

**Javier Lagos** (2025-08-29 11:31):
I will request customer to do that. Thanks @Vladimir Iliakov

---

**Vladimir Iliakov** (2025-08-29 11:37):
And please request the content of two configmaps used by router
`suse-observability-router` and `suse-observability-router-active`

---

**Vladimir Iliakov** (2025-08-29 11:45):
I checked the log formats and configuration and I think `"[::ffff:146.112.61.104]:8080"` in the rputer lofs is the `suse-observability-ui` K8s service for the ui pod. Can you also request/check the logs of the UI pod?

---

**Javier Lagos** (2025-08-29 11:49):
This is customer's statement regarding IP 146.112.61.104

`the external address is our enforcing security at the DNS layer tool but will only be used if dns adress cannot be resolved from inside the cluster.`

---

**Vladimir Iliakov** (2025-08-29 11:52):
And please these two configmaps
suse-observability            suse-observability-router                                       1      4h27m
suse-observability            suse-observability-router-active                                2      4h27m

and cat /etc/resolv.conf from the router pod

---

**Javier Lagos** (2025-08-29 11:52):
Those 3 outputs have been requested to the customer but no answer yet! will ping you once I have got configmaps and resolv.conf output

---

**Vladimir Iliakov** (2025-08-29 11:56):
Ok, will be waiting for the customer reply.

In the meantime
The router is configured with a "short" name for UI service
```        cluster_name: "suse-observability-api-ui"
        endpoints:
        - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  address: "suse-observability-ui"
                  port_value: 8080```
The expected configuration of resolv.conf is, the critical part here is `search ....svc.cluster.local` , which makes possible to interact with the services by their short names.
```k exec -ti suse-observability-router-575b5b5997-dmnnb cat /etc/resolv.conf
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
search stac-22609.svc.cluster.local svc.cluster.local cluster.local eu-west-1.compute.internal
nameserver 169.254.20.10
options ndots:5```
My best guess is something not right with `resolv.conf` , but lets wait till we get all the information...

---

**Javier Lagos** (2025-08-29 13:00):
Hey @Vladimir Iliakov Here you have the requested outputs

```kubectl run -it --rm --restart=Never --image=rancherlabs/swiss-army-knife dns-test-nocloudprovider-worker-rhs9x-mj5rf --overrides='{"spec": {"nodeSelector": {"kubernetes.io/hostname (http://kubernetes.io/hostname)": "nocloudprovider-worker-rhs9x-mj5rf"}}}' -- cat /etc/resolv.conf

search default.svc.cluster.local svc.cluster.local cluster.local acerta.be (http://acerta.be)
nameserver 10.43.0.10
options ndots:5
pod "dns-test-nocloudprovider-worker-rhs9x-mj5rf" deleted```
```kubectl exec -n suse-observability suse-observability-router-695cdd46cb-25jrv -it -- cat /etc/resolv.conf                                                                         ✔  nocloudprovider 󱃾  12:15:10 
search suse-observability.svc.cluster.local svc.cluster.local cluster.local acerta.be (http://acerta.be)
nameserver 10.43.0.10
options ndots:5```

---

**Vladimir Iliakov** (2025-08-29 13:05):
That looks ok, still waiting for configmaps.

---

**Javier Lagos** (2025-08-29 13:07):
Sorry! I forgot to add the ConfigMaps!

---

**Javier Lagos** (2025-08-29 13:07):
They look fine for me

---

**Vladimir Iliakov** (2025-08-29 13:43):
Yes, it looks ok.
```                socket_address:
                  address: "suse-observability-ui"
                  port_value: 8080```
For whatever reason `suse-observability-ui` gets resolved into `[::ffff:146.112.61.104]`. There is not many tooling in router to troubleshoot DNS

---

**Vladimir Iliakov** (2025-08-29 13:54):
Btw, I assume you have tried to restart the pod?

I found that Perl is shipped with router, it can be used to check DNS resolving from the router pod.
Something like,
```kubectl exec -ti suse-observability-router-575b5b5997-dmnnb -- perl -MSocket -e 'print inet_ntoa(inet_aton($ARGV[0])) . "\n"' suse-observability-ui
10.0.244.100```
And maybe try to resolve `suse-observability-ui` from the `swiss-army-knife` pod?

---

**Vladimir Iliakov** (2025-08-29 14:11):
Regarding `the external address is our enforcing security at the DNS layer tool but will only be used if dns adress cannot be resolved from inside the cluster.`

What is the TTL for the records returned by that tool in case the original dns address can't be resolved. Router is smart with caching DNS records, I wonder if that might be the cause...

---

**Javier Lagos** (2025-08-29 14:15):
We haven't tried yet to restart the router pod but I will ask customer to do that. We were focused on the networking side.

---

**Javier Lagos** (2025-08-29 14:16):
I am going to request to the customer to execute perl command and the DNS resolution on the swiss army knife to the suse observability ui

---

**Javier Lagos** (2025-08-29 14:17):
I don't know what is the TTL for the records returned by the tool. I will add this question to my next update in the case

---

**Javier Lagos** (2025-08-29 14:17):
I will keep you updated

---

**Javier Lagos** (2025-08-29 14:17):
Thanks @Vladimir Iliakov

---

**Vladimir Iliakov** (2025-08-29 14:40):
I was talking about a TTL time-to-live parameter used by all sorts of caching, including DNS, which defines for how long the DNS record can be used before renewing again.
For this case, I can speculate, the router pod was trying to resolve `suse-observability-ui` address, which might be unavailable due UI wasn't ready yet. The fallback address of the external DNS tool was cached by the router pod and hasn't been renewed again. But this is just my speculation based on the available information.

---

**Javier Lagos** (2025-08-29 15:00):
```kubectl run -it --rm --restart=Never --image=rancherlabs/swiss-army-knife dns-test --overrides='{"spec": {"nodeSelector": {"kubernetes.io/hostname (http://kubernetes.io/hostname)": "nocloudprovider-worker-rhs9x-mj5rf"}}}' -- dig +short suse-observability-ui.suse-observability.svc.cluster.local
10.43.32.136
pod "dns-test" deleted


kubectl exec -ti suse-observability-router-695cdd46cb-25jrv -n suse-observability -- perl -MSocket -e 'print inet_ntoa(inet_aton($ARGV[0])) . "\n"' suse-observability-ui
10.43.32.136```
Thanks @Vladimir Iliakov, Yeah I've got your point. Basically if the router tried to reach UI before the UI was resolvable it could have obtained the record from the external tool which is still active in the cache. Customer has not answered me this question yet but that's indeed a good point.

---

**Javier Lagos** (2025-08-29 15:01):
It looks like suse observability ui is resolvable from within router pod and swiss army knife suse pod

---

**Javier Lagos** (2025-08-29 15:02):
Just received the feedback from customer -

```The tool we use is cisco umbrella and if the dns adress is not trusted it is blocked and then redirect to 146.112.61.104 the, i asked our internal network team for more clarification around the record```
The restart didn't work either

---

**Javier Lagos** (2025-08-29 15:05):
maybe router pod is trying to resolve SUSE Observability ui svc in a way that is not allowed by cisco umbrella? Do we know the real steps performed by the router pod to resolve UI?

---

**Vladimir Iliakov** (2025-08-29 15:09):
The router is basically Envoy Http proxy https://www.envoyproxy.io/. There is a note on DNS resolution https://www.envoyproxy.io/docs/envoy/v1.31.10/intro/arch_overview/upstream/dns_resolution.html.
I don't remember DNS issues with router (envoy), and I need to think what would be the best way to resolve the issue.

---

**Vladimir Iliakov** (2025-08-29 15:10):
If only I knew how to reproduce it in my environment )))

---

**Vladimir Iliakov** (2025-08-29 15:12):
I wonder if the customer or their IT team have any knowledge specific to this cisco umbrella, any ideas or hints are welcome.

---

**Javier Lagos** (2025-08-29 15:17):
Yeah. Based on customer statement whether we see this IP on the logs that's because the router got an unauthorized DNS resolution so it received the external IP which means that somewhere they should see this unauthorized message that can help us identify the issue here

---

**Javier Lagos** (2025-08-29 15:17):
I have asked that to the customer

---

**David Noland** (2025-08-30 01:32):
has renamed the channel from "team-stackstate-supportbackend" to "prod-ranchersupport-suseobservability"

---

**Surya Boorlu** (2025-09-01 06:04):
@Frank van Lankvelt Can I share this developer preview with the customer?

---

**Surya Boorlu** (2025-09-01 06:11):
Hi Team,

Customer Dienst ICT Uitvoering (https://suse.lightning.force.com/lightning/r/Account/0011i00000wkkUAAAY/view) has opened a case for SUSE Observability 2.3.5 where it might be a OpenTelemetry ALPN bug&gt;

Description:
 Previously, with older versions of Observability and OpenTelemetry I got the traces working, to the point where they would show up in Observability under the Open Telemetry stackpack &gt; services.
Now with the current versions: Observability v2.3.5 and Opentelemetry v.0.131.0 I am getting the following error in the opentelemetry collector pod:

warn <mailto:grpc@v1.74.2|grpc@v1.74.2>/clientconn.go:1414 [core] [Channel #1 SubChannel #2]grpc: addrConn.createTransport failed to connect to {Addr: "otlp-dcmp-1000-observability.dictu.intern:443", ServerName: "otlp-dcmp-1000-observability.dictu.intern:443", }. Err: connection error: desc = "transport: authentication handshake failed: credentials: cannot check peer: missing selected ALPN property. If you upgraded from a grpc-go version earlier than 1.67, your TLS connections may have stopped working due to ALPN enforcement. For more details, see: https://github.com/grpc/grpc-go/issues/434" {"resource": {"service.instance.id (https://service.instance.id/)": "f125d18f-f81a-4bfb-bf8f-853bb4c8f856", "service.name (https://service.name/)": "otelcol-k8s", "service.version": "0.131.0"}, "grpc_log": true}

Any clue to what this could be? The opentelemetry API_KEY is correct.

Thanks in advance.

---

**Surya Boorlu** (2025-09-01 06:15):
PFA supported logs and yamls.

---

**Frank van Lankvelt** (2025-09-01 08:00):
It's public, so yes - the link may not be very stable, but we'll be releasing soon now anyway

---

**Surya Boorlu** (2025-09-01 08:01):
Got it. Thanks.

---

**Vladimir Iliakov** (2025-09-01 10:45):
~So far it seems to be incompatible versions of SUSE Observability's (lower) and the client's  (one of the latest) OpenTelemetry collectors.~

---

**Vladimir Iliakov** (2025-09-01 10:46):
~I guess the most obvious fix is to update SUSE Observability collector.~

---

**Surya Boorlu** (2025-09-01 11:16):
Okay. So the issue is not with the version incompatibility?

---

**Vladimir Iliakov** (2025-09-01 11:19):
Right, the problem is that the https endpoint otlp-dcmp-1000-observability.dictu.intern:443 doesn't support ALPN, which is a requirement for the recent OpenTelemetry Collectors.

---

**Vladimir Iliakov** (2025-09-01 11:21):
So whatever service terminates TLS for otlp-dcmp-1000-observability.dictu.intern:443 it must support ALPN in order for OpenTelemetry Collector to work...

---

**Surya Boorlu** (2025-09-01 11:23):
I see. Understood. I will check with the Customer and ask them to add the requirment.

---

**Vladimir Iliakov** (2025-09-01 11:26):
Whether https endpoint supports ALPN can be checked with `openssl`, for example:
```&gt; openssl s_client -connect otlp-stac-22609.sandbox-main.sandbox.stackstate.io:443 (http://otlp-stac-22609.sandbox-main.sandbox.stackstate.io:443)  -alpn h2,http/1.1
...
ALPN protocol: h2
...```

---

**Surya Boorlu** (2025-09-01 11:27):
I will ask the customer to check and get back to you. Thank you.

---

**Daniel Murga** (2025-09-02 07:52):
Hi Team! Customer Warba Bank K.S.C.P. (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMTe4AAG/view) opened a case yesterday reporting a weird license behaviour. They're getting a message that "Your license key will expire in 1 day!" while seems the license should be valid until the end of the present month (september):

_Registration code: xxxxxxxxxxxxxxxxx_
_Start date: Jan 31 2025_
_Expiry date: Sep 30 2025_

Attached 2 screenshots provided by customer. Thanks!

---

**Bram Schuur** (2025-09-02 08:31):
@Frank van Lankvelt could you look into this when you are starting your day?

---

**Frank van Lankvelt** (2025-09-02 09:49):
seems to be the age-old problem that the month is off by one

---

**Daniel Murga** (2025-09-02 09:49):
Any suggestion?

---

**Frank van Lankvelt** (2025-09-02 09:50):
I think the team handling licenses (don't know what acronym they go by) has the tools to hand out a new license key and make the whole administration in order

---

**Louis Lotter** (2025-09-02 12:11):
If you want a 30 September expiry you should set the expire date to 1 October.

---

**Daniel Murga** (2025-09-02 14:07):
But they're getting an expired license message even is supposed to be valid until 30th of Sept.

---

**Frank van Lankvelt** (2025-09-02 14:19):
then something is wrong in SCC - as @Louis Lotter said, the wrong date has been used to generate the license key

---

**Javier Lagos** (2025-09-02 14:22):
Hey @Daniel Murga. This case looks like really similar to one I have managed before. I had to create a sd jira case to solve the issue as the key needs to be re-generated. Do you have access to my request? https://sd.suse.com/servicedesk/customer/portal/1/SD-193823

Edit: I have just granted access to your user. You might want to follow the same structure and create a new case

---

**Daniel Murga** (2025-09-02 15:40):
Indeed @Javier Lagos is exactly the same! Thanks a lot, I will follow the same approach!

---

**Alejandro Acevedo Osorio** (2025-09-04 10:51):
I can't see why the `namenode` pod restarted (or got redeployed?) the `2025-08-29 07:37:02` as its previous logs are empty. But I get the impression that the system might have gotten stable after the `namenode` made it through. Is this the case @Saurabh Sadhale or does the customer still has an issue?

---

**IHAC** (2025-09-04 11:45):
@Amol Kharche has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Hello Team,

The customer is currently using a Prometheus Service Monitor to collect JVM metrics and visualize them in Prometheus/Grafana. They now want to forward or integrate these same JVM metrics into SUSE Observability.
Is there a supported or recommended way to achieve this, and what are the available options for sending these metrics to SUSE Observability?

---

**Vladimir Iliakov** (2025-09-04 11:55):
It is possible to collect metrics from Prometheus exporters via open-metrics https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/metrics/open-metrics.html.
Basically they need to assign proper pod ~labels~ annotations, which SUSE Observability agent uses to discover and collect metrics.

---

**Amol Kharche** (2025-09-04 12:04):
Cool, Thanks you so much @Vladimir Iliakov :celebrate-all:

---

**Vladimir Iliakov** (2025-09-04 12:16):
This is how we collect certain metrics from Kafka pod for example.
```apiVersion: v1
kind: Pod
metadata:
  annotations:
    ad.stackstate.com/api.check_names (http://ad.stackstate.com/api.check_names): '["openmetrics"]'
    ad.stackstate.com/api.init_configs (http://ad.stackstate.com/api.init_configs): '[{}]'
    ad.stackstate.com/api.instances (http://ad.stackstate.com/api.instances): '[ { "prometheus_url": "http://%%host%%:9404/metrics",
      "namespace": "stackstate", "metrics": ["kafka_consumer_consumer_fetch_manager_metrics*",
      "kafka_producer_producer_topic_metrics*", "jvm*", "akka_http_requests_active",
      "stackstate*", "receiver*", "stackgraph*", "caffeine*"] } ]'```
Be aware that a container name `api` and an exporter endpoint `"http://%%host%%:9404/metrics"` will be different for other pods.

---

**Amol Kharche** (2025-09-04 12:18):
Yes, I did it many time for fleet controller and gitjob pod but got confused about JVM.

---

**Amol Kharche** (2025-09-04 12:20):
https://confluence.suse.com/spaces/Hosted/pages/1722679325/Send+fleet-controller+and+gitjob+pod+metrics+to+SUSE+Observability

---

**Saurabh Sadhale** (2025-09-04 14:25):
I will need to check @Alejandro Acevedo Osorio i will ping back soon

---

**Saurabh Sadhale** (2025-09-05 13:04):
@Alejandro Acevedo Osorio the customer confirmed that all other pods are started. Now only the e2es pods are restarting.

The errors traces are indicating issues with  ES. Here is the latest log.

---

**Alejandro Acevedo Osorio** (2025-09-05 13:06):
Gotcha, that's great news @Saurabh Sadhale ... the e2es pod is unrelated to the previous issue. I'll take a look at the new logs

---

**IHAC** (2025-09-08 12:24):
@Javier Lagos has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Hello team! Thanks for your support.

I'm currently managing a case where the customer is asking about creating custom roles to just allow specific users to see only the notifications configuration of specific clusters.

So, basically, they would like to split the roles so that customers can configure and manage only their notification settings.

I have been playing around this topic and I realized that the users can see or manage all the notifications as soon as view-notifications or manage-notifications role is added to them.

I assume that this is the expected behavior as notifications can be considered "system settings" that should only be managed by the administrators of the platform but I would prefer to get the confirmation about that this cannot be achieved before confirming to the customer.

Is this configuration something that can be done? Otherwise, Is it possible to add/change somehow this to the product?

Thanks!

---

**Alejandro Acevedo Osorio** (2025-09-08 12:26):
And on e`lasticsearch-master-2` itself
```java.nio.file.FileSystemException: /usr/share/elasticsearch/data/indices/dV9g_cOzQVCUBC2w1CW_nQ/2/_state/retention-leases-3.st.tmp: Read-only file system\n\tat java.base/sun.nio.fs.UnixException.translateToIOException(UnixException.java:100)\n\tat java.base/sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:106)\n\tat java.base/sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:111)\n\tat java.base/sun.nio.fs.UnixFileSystemProvider.newByteChannel(UnixFileSystemProvider.java:261)\n\tat java.base/java.nio.file.spi.FileSystemProvider.newOutputStream(FileSystemProvider.java:482)\n\tat java.base/java.nio.file.Files.newOutputStream(Files.java:227)\n\tat org.apache.lucene.core@9.8.0/org.apache.lucene.store.FSDirectory$FSIndexOutput.<init>(FSDirectory.java:394)\n\tat org.apache.lucene.core@9.8.0/org.apache.lucene.store.FSDirectory$FSIndexOutput.<init>(FSDirectory.java:387)\n\tat org.apache.lucene.core@9.8.0/org.apache.lucene.store.FSDirectory.createOutput(FSDirectory.java:220)\n\tat org.elasticsearch.server@8.11.4/org.elasticsearch.gateway.MetadataStateFormat.doWriteToFirstLocation(MetadataStateFormat.java:119)\n\tat org.elasticsearch.server@8.11.4/org.elasticsearch.gateway.MetadataStateFormat.writeStateToFirstLocation(MetadataStateFormat.java:104)\n\t... 29 more\n"}```
Not sure what happened  over there flagging a read only file system. Is the issue ongoing as well, or was it transient?
Do you know what kind of storage they use for the PVC's?

---

**Javier Lagos** (2025-09-08 12:39):
cc - @Frank van Lankvelt

---

**Frank van Lankvelt** (2025-09-08 13:34):
it is indeed currently not possible to do fine-grained authorization on notifications.

---

**Frank van Lankvelt** (2025-09-08 13:35):
we have some ideas on adding such functionality, as for instance also scoping on monitors, but these still need to be worked out and are not on the short-term horizon

---

**Javier Lagos** (2025-09-08 14:51):
Thanks a lot!!

---

**Saurabh Sadhale** (2025-09-09 14:10):
Longhorn storage class.

---

**Saurabh Sadhale** (2025-09-09 14:10):
The issue is still present,

---

**Vladimir Iliakov** (2025-09-09 16:02):
Well, it seems that filesystem on the pvc was switched to read-only when IO error occured. I suspect to switch it back they have to run
something like `e2fsck` to fix the fs and mark the filesystem as clean.

---

**Vladimir Iliakov** (2025-09-09 16:12):
Maybe it would be enough just to restart the pod https://longhorn.io/kb/troubleshooting-volume-readonly-or-io-error/
Have they tried it?

---

**IHAC** (2025-09-10 15:10):
@Javier Lagos has a question.

:customer:  MERCK KGAA DARMSTADT

:facts-2: *Problem (symptom):*  
Hello team.

I need your help to recover one SUSE Observability instance that I'm currently working on.

The customer has opened a case because they have seen that SUSE Observability is not working properly. At first I saw a lot of pods on CrashLoopBackOff but everything started by one Elasticsearch going into non-ready status.

```LAST SEEN   TYPE      REASON                 OBJECT                                                MESSAGE
44m         Warning   Unhealthy              pod/suse-observability-elasticsearch-master-1         Readiness probe failed: Waiting for elasticsearch cluster to become ready (request params: "wait_for_status=yellow&amp;timeout=1s" )...
30m         Warning   BackOff                pod/suse-observability-e2es-7596f5d48b-9lkjf          Back-off restarting failed container e2es in pod suse-observability-e2es-7596f5d48b-9lkjf_suse-observability(15b21b55-85e1-46d8-90af-b7747d99ca96)
34m         Warning   BackOff                pod/suse-observability-elasticsearch-master-0         Back-off restarting failed container elasticsearch in pod suse-observability-elasticsearch-master-0_suse-observability(a538463f-1383-4501-b85f-5fd3b33b81de)
34m         Warning   BackOff                pod/suse-observability-elasticsearch-master-1         Back-off restarting failed container elasticsearch in pod suse-observability-elasticsearch-master-1_suse-observability(940bea55-1ed4-4e3a-be33-2f5f64a75753)
34m         Warning   BackOff                pod/suse-observability-elasticsearch-master-2         Back-off restarting failed container elasticsearch in pod suse-observability-elasticsearch-master-2_suse-observability(ec4bd166-c99d-41f2-8a6a-7fabd399b1a5)```
After this problem, the elasticsearch pods were not able to start again due to the LivenessProbe configuration on the statefulset that I fixed increasing the delay parameter by executing the following commands:
```1 - kubectl scale sts -n suse-observability suse-observability-elasticsearch-master --replicas=0
2 - kubectl patch sts suse-observability-elasticsearch-master -n suse-observability --patch '{"spec": {"template": {"spec": {"containers": [{"name": "elasticsearch","livenessProbe":{"initialDelaySeconds": 300}}]}}}}' 
3 - kubectl scale sts -n suse-observability suse-observability-elasticsearch-master --replicas=3```
As I said, this commands fixed the issue on elasticsearch as we can see now that the pods are running without issues. But, the component is still not working properly and I can still see some pods in CrashLoopBackOff status.

```suse-observability-sync-6bff79675b-xg4k6                          0/1     CrashLoopBackOff
suse-observability-notification-7dfb7fc9-fjgxf                    0/1     CrashLoopBackOff
suse-observability-checks-658bddf466-sg52h                        0/1     CrashLoopBackOff ```
Can please someone help me to resolve this issue?

Thanks!

---

**Alejandro Acevedo Osorio** (2025-09-10 15:17):
I see in both `tephra-0` and `hbase-rs-*`  this kind of exceptions
```msg=org.apache.hadoop.hbase.NotServingRegionException: hbase:meta,,1 is not online on suse-observability-hbase-hbase-rs-2.suse-observability-hbase-hbase```
Can you please restart `hbase-hbase-rs-` and `hbase-hbase-master` pods

---

**Javier Lagos** (2025-09-10 15:21):
Thanks!! I will update customer with this suggestion.

---

**Alejandro Acevedo Osorio** (2025-09-10 15:27):
BTW @Javier Lagos we are already running an investigation related to the `NotServingRegionException` issue  https://stackstate.atlassian.net/browse/STAC-23279

---

**Javier Lagos** (2025-09-10 15:29):
Thanks for letting me know @Alejandro Acevedo Osorio. I wasn't aware about this bug on the product.

Hopefully the restart of the hbase component will recover the cluster

---

**Bruno Bernardi** (2025-09-10 20:51):
Hi @Bram Schuur and team,

For your information, we have received a new report about this from another customer.

In addition to the improvements that you mentioned on Jira, this customer asked if it is possible to check to include the following functionality:

```Implement a method to use NTP servers from the cluster node configuration as the default. Also, if needed, introduce a parameter to use some custom.```
Thanks in advance.

---

**IHAC** (2025-09-11 17:08):
@Giovanni Lo Vecchio has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Hello!
The customer installed SUSE Observability with HA sizing HA150, but is wondering why some services have a single replica.

The list is as follows:
suse-observability-api
suse-observability-checks
suse-observability-e2es
suse-observability-health-sync
suse-observability-initializer
suse-observability-notification
suse-observability-receiver-base
suse-observability-receiver-logs
suse-observability-receiver-process-agent
suse-observability-router
suse-observability-slicing
suse-observability-state
suse-observability-sync

They would like to be sure that if something happens to one of these services, it will not cause problems in the application’s functioning.

Can you help me respond to the customer?
TIA!

---

**Vladimir Iliakov** (2025-09-11 17:20):
The HA mode here means running data storing services, like Stackgraph (Hbase), Elasticsearch, VictoriaMetrics, Clickhouse, Kafka, Zookeeper, in multiple replicas to ensure data availability. This increases overall HA for the application.
The mentioned servieces are "self-healing", if any of them fails it will be restarted by Kubernetes.

---

**Giovanni Lo Vecchio** (2025-09-11 17:44):
Hi Vladimir,
Thank you so much for your reply!
I wrote something similar to the customer, but I wanted your confirmation.
Now I’ll tell them I’ve received confirmation, so they can rest assured.

---

**Amol Kharche** (2025-09-12 07:39):
@Vladimir Iliakov
```Customer asking if they can we use basic auth as an header ? Do we have an example for me for use with basic auth.?
They tried implementing the open metrics solution but our endpoint use's basic auth security.

With the following annotation's (the env is the base 64 encrypted value of the username and password)

    ad.stackstate.com/blueriq-runtime-vanilla.check_names (http://ad.stackstate.com/blueriq-runtime-vanilla.check_names): '["openmetrics"]'
    ad.stackstate.com/blueriq-runtime-vanilla.init_configs (http://ad.stackstate.com/blueriq-runtime-vanilla.init_configs): '[{}]'
    ad.stackstate.com/blueriq-runtime-vanilla.instances (http://ad.stackstate.com/blueriq-runtime-vanilla.instances): |
       [
         {
           "prometheus_url": "http://%%host%%:8080/runtime/actuator/prometheus",
           "namespace": "namespace-name",
           "metrics": ["*"],
           "extra_headers": "Authorization: Basic %%env_SECRET_B64%%"
         }
       ]

they wanted to know if this is the correct implementation.```

---

**Vladimir Iliakov** (2025-09-12 09:20):
Looks correct to me :thumbs-up:

---

**Vladimir Iliakov** (2025-09-12 09:29):
Wait, extra_headers has to be dictionary

---

**Vladimir Iliakov** (2025-09-12 09:30):
Here is the working example
```  annotations:
    ad.stackstate.com/router.check_names (http://ad.stackstate.com/router.check_names): '["openmetrics"]'
    ad.stackstate.com/router.init_configs (http://ad.stackstate.com/router.init_configs): '[{}]'
    ad.stackstate.com/router.instances (http://ad.stackstate.com/router.instances): |
      [
        {
        "prometheus_url": "http://%%host%%:8082/artifactory/api/v1/metrics",
        "namespace": "artifactory",
        "metrics": ["*"],
        "extra_headers": {"Authorization": "Basic %%env_ARTIFACTORY_METRICS_BASIC_AUTH%%"}
        }
      ]```

---

**Saurabh Sadhale** (2025-09-12 10:23):
They tried it and e2es is back up again. However, now the current situation is returned back to the original problem of initializer pod failing. :disappointed:

I was wondering if we could set up a google meet with the customer in the upcoming week. Could you share your availability for the same ?

---

**Vladimir Iliakov** (2025-09-12 10:37):
First we need to learn how to fix filesystem on a Longhorn volume, is there any runbook for that?

---

**Saurabh Sadhale** (2025-09-15 08:45):
I am not very confident on this part.

I found this https://longhorn.io/kb/troubleshooting-volume-readonly-or-io-error/

---

**Vladimir Iliakov** (2025-09-15 09:25):
According to this guide the restart of the pod should fix the filesystem, can you check if the read-only issue with Elasticsearh is gone. We can go and investigate/fix SUSE Observability issues, but first lets make sure we are good with infrastructure. Can you collect the log bundle again, please?
If the filesystem issue is not gone, is there any environment to check Longhorn volumes?

---

**Amol Kharche** (2025-09-15 12:15):
Customer configured but they dont see metrics data. I am going to ask support bundle logs. Do we need to ask any specific here ?
Here is the customer response.
```We see no error's in the node agent logs.
We looked over the configuration and it matches your expamle.
we do have a question in the documentation there is a note over the V2 agent is this something we need  to change to our suse observability agent?
and is there  away to check if the metrics are being recieved by the suse observabilty server? we tried looking ad the metrics explore but couldn't find our jvm metrics?
and can you share what you put in your basic auth env variable? is this base 64 or not ```

---

**Vladimir Iliakov** (2025-09-15 12:19):
&gt; we do have a question in the documentation there is a note over the V2 agent is this something we need  to change to our suse observability agent?
May I have a link to this documentation?

---

**Amol Kharche** (2025-09-15 12:20):
This was the one which we have shared with customer.
OpenMetrics :: Rancher product documentation (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/metrics/open-metrics.html#_overview)

---

**Amol Kharche** (2025-09-15 12:20):
&gt; Installation
&gt; The OpenMetrics check is included in the [*Agent V2 StackPack*].
&gt; Configuration
&gt; To enable the OpenMetrics integration and begin collecting metrics data from an OpenMetrics endpoint, the OpenMetrics check must be configured on *SUSE Observability Agent V2.* The check configuration provides all details required for the Agent to connect to your OpenMetrics endpoint and retrieve the available metrics.

---

**Vladimir Iliakov** (2025-09-15 12:21):
I meant, which note do they refer to?

---

**Vladimir Iliakov** (2025-09-15 12:22):
&gt; note over the V2 agent is this something we need  to change to our suse observability agen

---

**Amol Kharche** (2025-09-15 12:23):
I think this one.
&gt; To enable the OpenMetrics integration and begin collecting metrics data from an OpenMetrics endpoint, the OpenMetrics check must be configured on SUSE Observability Agent V2. The check configuration provides all details required for the Agent to connect to your OpenMetrics endpoint and retrieve the available metrics.

---

**Vladimir Iliakov** (2025-09-15 12:26):
<!subteam^S08HEN1JX50> <!subteam^S08HHSW67FE> do we have a doc explaining how to configure extra environment variables for the node agent?

---

**Vladimir Iliakov** (2025-09-15 12:30):
@Remco Beckers I created a ticket to improve documentation https://stackstate.atlassian.net/browse/STAC-23375.

---

**Vladimir Iliakov** (2025-09-15 12:35):
@Amol Kharche Customer has to inject an env variable into the node agent pod

They have to redeploy agent with an extra value:
global:
    extraEnv:
        secret:
             SECRET_B64: &lt;base64 encode value&gt;

---

**Amol Kharche** (2025-09-15 12:38):
Thanks ,I will ask customer to redeploy node-agent with these values.

---

**Amol Kharche** (2025-09-15 13:05):
So If we pass base64 values under SECRET_B64, It again encrypt that value to base64, Is this expected ?
```# echo AmolKharche | base64
QW1vbEtoYXJjaGUK
# cat values.yaml
global:
  extraEnv:
    secret:
      SECRET_B64: QW1vbEtoYXJjaGUK
# helm upgrade --install --namespace suse-observability --create-namespace --set-string 'stackstate.apiKey'=svctok-d0lmZQ4WgdJZnZ67m2lOOCe1JXlS_MX7 --set-string 'stackstate.cluster.name'='dns' --set-string 'stackstate.url'='https://stackstate.lab/receiver/stsAgent' --set-string 'global.skipSslValidation'=true  --values values.yaml suse-observability-agent suse-observability/suse-observability-agent

# kubectl get secret suse-observability-agent-secrets -n suse-observability -o yaml | grep -i SECRET_B64
  SECRET_B64: UVcxdmJFdG9ZWEpqYUdVSw==

# echo UVcxdmJFdG9ZWEpqYUdVSw== | base64 -d
QW1vbEtoYXJjaGUK
# echo QW1vbEtoYXJjaGUK | base64 -d
AmolKharche```

---

**Saurabh Sadhale** (2025-09-15 13:05):
The latest logs were collected. I missed to share them here.

---

**Alessio Biancalana** (2025-09-15 13:52):
if you pass a base64 string to a base64() function it's expected to have it re-encrypted as b64

---

**Vladimir Iliakov** (2025-09-15 14:11):
@Amol Kharche, sorry for confusion, I meant `user:password` encoded with base64
```global:
    extraEnv:
        secret:
             SECRET_B64: <base64 encoded value of user:password string>```

---

**Amol Kharche** (2025-09-15 15:04):
Got further question from customer that.
```I don't understand do i need to add the secret of my basic Auth to the agent as well as to the Pod?
and correct  me if i am wrong the annotation is only needed on the pod with the metrics?```

---

**Vladimir Iliakov** (2025-09-15 15:06):
As far as I can tell, the basic auth has to be added to the agent only

---

**Vladimir Iliakov** (2025-09-15 15:06):
Annotation to the pod to collect metrics from

---

**Fedor Zhdanov** (2025-09-15 15:12):
Annotations to the pod to collect the metrics from use (reference) the env secret for scrapping. This secret needs to be known to the agent to do the scrapping, so the secret needs to be added to the agent.

---

**Amol Kharche** (2025-09-15 16:12):
Customer would like to know Is it possible to add the basic auth secret from an secret object and not put it in to an value file.
This because they don't want any secrets in value files.

---

**Amol Kharche** (2025-09-15 16:18):
This should work right ?
```kind: Secret
metadata:
   name: "&lt;custom-secret-name&gt;"
type: Opaque
data:
  SECRET_B64: "&lt;base64 encoded"```
Add the following to your helm install command to use the secret:
```  --set-string 'global.extraEnv.fromExternalSecret'='&lt;custom-secret-name&gt;'```

---

**Amol Kharche** (2025-09-15 16:51):
Looks like `fromExternalSecret` doesn't supported in agent chart.

---

**Vladimir Iliakov** (2025-09-15 16:59):
I don't see that agent supports sourcing environment variables from the existing secret https://github.com/StackVista/helm-charts/blob/master/stable/stackstate-k8s-agent/templates/_container-agent.yaml

---

**Frank van Lankvelt** (2025-09-15 16:59):
looking at the logs, it appears you ran into https://issues.apache.org/jira/browse/HBASE-27508 - the meta table is being split and hbase master crashed.  We'll need to investigate why the meta table grew big enough to be split anyway, I think.  Don't have a workaround apart from restarting  the hbase pods as @Alejandro Acevedo Osorio suggested

---

**Amol Kharche** (2025-09-15 18:16):
Ohk, https://stackstate.atlassian.net/browse/STAC-23379 raised for enhancement,

---

**Surya Boorlu** (2025-09-16 06:13):
@Frank van Lankvelt The link https://deploy-preview-41--suse-obs.netlify.app/suse-observability/next/en/setup/security/rbac/rbac_roles#_custom_roles_via_the_configuration_file

is not working now. I guess it has been moved to production? Any chance you have the link?

Customer is asking: Do you by any chance know if with the new RBAC it is possible to scope projects or namespaces? Or instead of that scope it per cluster and exclude projects or namespaces?

---

**Frank van Lankvelt** (2025-09-16 08:40):
the docs have indeed been promoted to https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_roles.html
It is indeed possible to limit access to clusters or projects.  The Rancher UI Extension comes with a set of predefined Role Templates that allow you to grant read access to components, metrics, traces, logs in SUSE Observability.

---

**Surya Boorlu** (2025-09-16 08:47):
Thank you @Frank van Lankvelt

---

**Alejandro Acevedo Osorio** (2025-09-16 10:59):
@Bram Schuur or @Frank van Lankvelt can you scan quickly the `tephra` logs to see if you come to the same conclusion?

---

**Alejandro Acevedo Osorio** (2025-09-16 10:59):
@Saurabh Sadhale what version of Suse Obs are they running?

---

**Saurabh Sadhale** (2025-09-16 11:00):
@Alejandro Acevedo Osorio i have scheduled a call with the customer today in another 30 mins.

2.3.5 version.

---

**Saurabh Sadhale** (2025-09-16 11:01):
You are welcome if you want to get more information from the cluster.

---

**Alejandro Acevedo Osorio** (2025-09-16 11:08):
Ohh @Saurabh Sadhale we really need to upgrade the customer. Their database (StackGraph, tephra) is on version
```registry.rancher.com/suse-observability/tephra-server:2.5-7.9.10 (http://registry.rancher.com/suse-observability/tephra-server:2.5-7.9.10)```

---

**Alejandro Acevedo Osorio** (2025-09-16 11:08):
And they are missing all this fixes to the `tephra` init sequence
```chore(release): 7.10.3 [skip ci]
## [7.10.3](v7.10.2...v7.10.3) (2025-07-10)

### Bug Fixes

* **tephra:** STAC-22954 | Add extra logging and some comments ([b07e46d7](b07e46d7))
* **tephra:** STAC-22954 | Add test for all permutations of startup shutdown failure ([58358379](58358379))
* **tephra:** STAC-22954 | Avoid n^2 retries instead of n retries, by using tableList instead of tableExists ([e61a87d5](e61a87d5))
* **tephra:** STAC-22954 | Don't block the leaderLatch becomeLeader method by waiting for initialization ([ea3fab32](ea3fab32))
* **build:** STAC-22954 | Expire artifacts a bit later ([c823a7fb](c823a7fb))
* **tephra:** STAC-22954 | Fix hanging server for startup - shutdown in quick succession ([3284821b](3284821b))
* **tephra:** STAC-22954 | Fix stopping behavior of TransactionService when hdfs is in safe mode ([eb31143b](eb31143b))
* **tephra:** STAC-22954 | Fixing shutdown behavior further ([8334158e](8334158e))
* **tephra:** STAC-22954 | Initial test setup ([3a76b013](3a76b013))
* **tephra:** STAC-22954 | Properly handle stop errors for failed services. ([223ec243](223ec243))
* **tephra:** STAC-22954 | Reduce the number of retries on HBase connection issues in pruning and retention service ([85934d6b](85934d6b))
* **tephra:** STAC-22954 | Small tweaks ([f8c401cb](f8c401cb))
* **tephra:** STAC-22954 | Tweaking settings a bit further ([1c30ae91](1c30ae91))
* **tephra:** STAC-22954 Remove system.out ([cfaee4ce](cfaee4ce))
* **build:** STAC-22994 | Publish to snapshot repository from branches ([1b4d8cbd](1b4d8cbd))```

---

**Alejandro Acevedo Osorio** (2025-09-16 11:10):
Basically the tephra half init as I saw in the logs it was the bug that lead to the package of fixes I just listed

---

**Alejandro Acevedo Osorio** (2025-09-16 11:11):
Unfortunately I can't join the meeting but I think you need to ask them to upgrade to one of the latest versions

---

**Saurabh Sadhale** (2025-09-16 11:12):
Ack no worries. I think I can check with them to upgrade first and then see if there is an improvement.

---

**Alejandro Acevedo Osorio** (2025-09-16 11:12):
Indeed, I think that is the first move as we know that version had those init issues

---

**Amol Kharche** (2025-09-16 11:14):
Hi Team,
Customer Caprocorn group (https://suse.lightning.force.com/lightning/r/Account/0011i000018E7APAA0/view) facing issue with observability extension. Recently suse observability components have been updated to the latest versions — the Observability instance to *v2.5.0* and the agent to *v1.0.65*.
As per the customer since the update, the observability extension has stopped functioning. We attempted to reconfigure it using a fresh token and the updated extension, but the issue persists.

---

**Frank van Lankvelt** (2025-09-16 13:11):
was the rancher origin `https://bwagabpdcrke01.bwa.cgp.local` added as allowed origin in the SUSE Observability instance?  (e.g. specifying the rancherUrl when rendering the suse-observability-values chart achieves this)

---

**Frank van Lankvelt** (2025-09-16 13:13):
the url of the observability instance does not appear to have been updated - it does not have a scheme.

---

**Frank van Lankvelt** (2025-09-16 13:37):
is the customer running the 2.5.0 as-is, or are they overriding e.g. the stackstate image tag?  The response I see suggests an older version of the API pod running.

---

**Amol Kharche** (2025-09-16 13:51):
I am not sure about rancher origin.  I will ask customer.
&gt; the url of the observability instance does not appear to have been updated - it does not have a scheme.
you mean it does not have `https` or `http` ? Is it required in v2.5.0?
Yes customer running observability instance on v2.5.0. I will confirm with customer.

---

**Frank van Lankvelt** (2025-09-16 13:57):
the scheme (http or https) is indeed required.  If not specified, `https` is automatically prefixed

---

**Amol Kharche** (2025-09-16 13:59):
What logs we can expect when troubleshooting observability extension?

---

**Frank van Lankvelt** (2025-09-16 14:03):
in the logs zip I see the base url to be `https://k8-observability.nam.cgp.local`, while the har file suggests https://k8-observability.bwa.cgp.local

---

**Amol Kharche** (2025-09-16 14:04):
Yes, seems they have shared the logs from different site. There are two site they have configured observability instance, I will ask customer to share the correct file.

---

**Frank van Lankvelt** (2025-09-16 14:09):
the suse-observability-server configmap doesn't appear to have the allowed origins set - so if the same thing applies to the other environment I would certainly expect CORS errors

---

**Frank van Lankvelt** (2025-09-16 14:10):
&gt; What logs we can expect when troubleshooting observability extension?
I think starting out with the request log like you did is a very useful starting point

---

**Amol Kharche** (2025-09-16 14:18):
I was able to replicate the issue. I installed version 2.5.0 without specifying the `rancherUrl`, and the extension configuration didn't work. After updating the Helm template to include the `rancherUrl`, the observability extension worked as expected.

---

**Amol Kharche** (2025-09-16 14:19):
So does mean we need `rancherUrl` when configuring observability extension?

---

**Frank van Lankvelt** (2025-09-16 14:22):
yep.  It depends on CORS (cross-origin request headers) since the extension now sends requests directly to SUSE Observability

---

**Marc Rua Herrera** (2025-09-16 23:46):
I this Capricorn? Is this solved now?

What is the process to update the extension to the latest version then?

---

**Amol Kharche** (2025-09-17 05:09):
This is for Caprocorn and not yet resolved.

---

**Marc Rua Herrera** (2025-09-17 09:05):
Is it the same capricorn and caprocorn? Or are they jsust 2 different customers.

I am asking as I was in a call with them last Fridy and we run into a similar issue, which I stll need to digure out what happened

---

**Amol Kharche** (2025-09-17 09:19):
Sorry , Its for *Capricorn Group*

---

**Amol Kharche** (2025-09-17 09:27):
I mistakenly missed out correct spelling , Sorry about confusion.

---

**Javier Lagos** (2025-09-17 13:03):
cc @Alejandro Acevedo Osorio

---

**Javier Lagos** (2025-09-17 13:08):
I can see the following Jira case https://stackstate.atlassian.net/browse/STAC-23312 that is exactly what the customer is facing. How can we resolve this issue?

---

**Frank van Lankvelt** (2025-09-17 13:08):
we have a fix for this ready and are working to release it soon.

---

**Alejandro Acevedo Osorio** (2025-09-17 13:15):
Although you"ll have to restore a settings backup or start a new instance from scratch as it's not that simple to get the instance out of the `Multiple edges can not be placed on a optional property` state

---

**Javier Lagos** (2025-09-17 13:37):
Thanks for your help as always!

Therefore, we have 2 workarounds:

• Re-deploy SUSE Observability from scratch
• Restore settings backup -&gt; Here I see one problem. Customer does not really know when the issue started to happen but we can suggest him to restore the day that he remember that the component was working fine before holidays. Is this the correct documentation that we need to follow to restore the backup? https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html

---

**Alejandro Acevedo Osorio** (2025-09-17 13:47):
They can use the last configuration backup as the only part that gets restored with that is their settings (like notifications, custom monitors, stackpack configurations)  and then the data can start flowing again

---

**Javier Lagos** (2025-09-17 14:46):
Thanks @Alejandro Acevedo Osorio! When are we planning to release the new version that includes the fix? Customer is asking about this as this is not the first time they have this issue as they have had to re-install the product a few times due to the same problem and would like to avoid it in the future and I would like to have something specific to share with him.

I have recommended in the meantime to test the configuration restore process instead of uninstalling and installing the complete product.

---

**Alejandro Acevedo Osorio** (2025-09-17 15:00):
The release process is starting today or tomorrow, so I guess should be in about a week. Probably next Wed. In the meantime I think it's a great suggestion that they try the restore settings process

---

**Javier Lagos** (2025-09-17 15:01):
Thanks a lot!!

---

**Andrea Terzolo** (2025-09-17 16:53):
it seems the nodeAgent is not able to communicate with the clusterAgent...not an expert here maybe @Louis Parkin could give us more context  (?)

---

**Louis Parkin** (2025-09-17 16:55):
I've never seen this error before @Andrea Terzolo

---

**Louis Parkin** (2025-09-17 16:57):
@Andrea Terzolo this is a very suspicious IP address for a kubernetes deployment:
```2025-09-17 12:32:29 UTC | CORE | ERROR | (comp/core/workloadmeta/collectors/internal/kubemetadata/kubemetadata.go:86 in Start) | Could not initialise the communication with the cluster agent: temporary failure in clusterAgentClient, will retry later: "https://192.168.193.45:5005/version" is unavailable: timeout calling "https://192.168.193.45:5005/version": Get "https://192.168.193.45:5005/version": dial tcp 192.168.193.45:5005: i/o timeout
2025-09-17 12:32:29 UTC | CORE | ERROR | (comp/core/workloadmeta/collectors/internal/kubemetadata/kubemetadata.go:86 in Start) | Could not initialise the communication with the cluster agent: temporary failure in clusterAgentClient, will retry later: try delay not elapsed yet
2025-09-17 12:32:30 UTC | CORE | WARN | (pkg/autodiscovery/providers/endpointschecks.go:54 in NewEndpointsChecksConfigProvider) | Cannot get dca client: temporary failure in clusterAgentClient, will retry later: "https://192.168.193.45:5005/version" is unavailable: timeout calling "https://192.168.193.45:5005/version": Get "https://192.168.193.45:5005/version": dial tcp 192.168.193.45:5005: i/o timeout```

---

**Louis Parkin** (2025-09-17 16:59):
So, the question is why can't the node-agent communicate with the cluster-agent.  Could be network policies, firewall policies, the log is not detailed enough for us to get that information.  cc @Bram Schuur

---

**Louis Parkin** (2025-09-17 17:00):
Pretty sure it's not an agent issue

---

**Louis Parkin** (2025-09-17 17:00):
it will be environmental

---

**Andrea Terzolo** (2025-09-17 17:02):
this command should tell us if  `192.168.193.45` is the ip of the cluster-agent service
```kubectl get services -A -o wide | grep 'cluster-agent'```
the port matches the port of the service we expose in the chart
```| clusterAgent.service.port | int | `5005` | Change the Cluster Agent service port |
| clusterAgent.service.targetPort | int | `5005` | Change the Cluster Agent service targetPort |```

---

**Andrea Terzolo** (2025-09-17 17:04):
the timeout suggests a possible net policy issue but the nodeAgent should be deployed in hostNetwork by default so it sounds strange that a policy is blocking the traffic

---

**Louis Parkin** (2025-09-17 17:05):
I agree, but we have this software running in too many places successfully for this to be an agent issue. It has to be environmental.

---

**Louis Parkin** (2025-09-17 17:06):
Policies are low-hanging fruit, things we could accurately speculate without having access to debug it ourselves.

---

**Amol Kharche** (2025-09-17 17:07):
Customer have an host based firewall and openend port 5005 and port 8126 for the services and port 443 is open as well. Are there any other ports needed for the agent's?

---

**Louis Parkin** (2025-09-17 17:08):
@Andrea Terzolo could you check? I am AFK already

---

**Vladimir Iliakov** (2025-09-17 17:11):
How can a host-based firewall be used for Kubernetes traffic?

---

**Andrea Terzolo** (2025-09-17 17:11):
i can check, but here the issue is on port `5005` that should be opened :thinking_face:

---

**Andrea Terzolo** (2025-09-17 17:16):
BTW yes i agree with Vladimir the network configuration is not clear to me. Probably the best way they have to debug is to try `curl https://192.168.193.45:5005/version` from different places and understand where the traffic is blocked

---

**Vladimir Iliakov** (2025-09-17 17:19):
Was it broken at some point, or didn't work from the very beginning?

---

**Amol Kharche** (2025-09-17 17:20):
Customer said The agent was working before.

---

**Amol Kharche** (2025-09-17 17:21):
Let me know what logs/test we need to ask customer.

---

**Andrea Terzolo** (2025-09-17 17:34):
What i would do is to check the ip address of the clusterIP service
```kubectl get services -A -o wide | grep 'cluster-agent'```
just to be sure the configuration is correct. According to the logs it should be `192.168.193.45`
And then there is not so much we can do, i would probably enter the node agent pod and try to curl that address
```kubectl exec -n monitoring suse-observability-dev-agent-node-agent-... -it -- bash
curl https://192.168.193.45:5005/version```
if curl doesn't work it means that very likely there is a networking issue on their side. They could try to come back to the time the agent stopped to work and see if they have deployed something in the cluster that altered the network configuration

---

**Vladimir Iliakov** (2025-09-17 17:56):
also the endpoints can be checked with
```kubectl get endpoints -A -o wide | grep 'cluster-agent'```
the ip should match ip of the cluster agent pod `kubectl get pod -A -o wide | grep cluster-agent`
please try to curl this ip as well `curl https://<ip>:5005/version`

---

**Vladimir Iliakov** (2025-09-17 18:04):
There few components responsible for the network traffic within cluster: CNI control plane, network policies, kube-proxy, kubedns/coredns, host-based firewall is an extra challenge. Maybe there have been some changes related to these components?

---

**Amol Kharche** (2025-09-18 06:21):
I already asked them if they have done any network level changes but not changes

---

**Amol Kharche** (2025-09-18 06:32):
Recently they upgraded agent 1.0.56 &gt; 1.0.61 &gt; 1.065 .

---

**Amol Kharche** (2025-09-18 06:57):
What is the procedure to add `rancherUrl`  of already running instance ? Generate template with `helm template` command and then again run `helm upgrade install` ?
Or do we need to add `stackstate.web.origins`  in server ConfigMap ?

---

**Surya Boorlu** (2025-09-18 07:56):
@Frank van Lankvelt Last question from customer.

Is this possible without the Rancher UI extension and without the new Rancher RBAC model? We are scoping on the cluster level at the moment by creating a custom role and scoping like this:

resourcePermissions:
      get-topology:
      - "cluster-name:usr-rh-3002"
      get-metrics:
      - "k8s:usr-rh-3002:__any__"
      get-traces:
      - "k8s.cluster.name:usr-rh-3002"

how is this done on the project level? Thanks!

---

**Frank van Lankvelt** (2025-09-18 07:57):
You can specify `stackstate.allowedOrigins` in the values, then they will end up in the configmap

---

**Frank van Lankvelt** (2025-09-18 08:06):
You can use the 'k8s-scope:CLUSTER/NAMESPACE' for topology, 'k8s.scope:CLUSTER/NAMESPACE' for traces and (just like above) 'k8s:CLUSTER:NAMESPACE' for metrics.

---

**Surya Boorlu** (2025-09-18 08:08):
This is for Namespace level or Project level?

---

**Surya Boorlu** (2025-09-18 08:18):
@Frank van Lankvelt Also, their first question
Is this possible without the Rancher UI extension and without the new Rancher RBAC model?

---

**Amol Kharche** (2025-09-18 08:36):
I wondering how it will be load automatically without applying helm upgrade install command :thinking_face:

---

**Frank van Lankvelt** (2025-09-18 10:09):
Am not sure why you would want that.  Only alternative for now is manual runtime patching.  There have been more suggestions to make it more dynamic, but afaics that would be quite some effort for a marginal win.

---

**Frank van Lankvelt** (2025-09-18 10:10):
It is on namespace level - a Project is not a Kubernetes concept, only a Rancher one.

---

**Vladimir Iliakov** (2025-09-18 10:13):
I don't have many ideas, but to do `kubectl port-forward &lt;clusterpod&gt; 5005:5005` with the following curl to check whether is a network connectivity issue.

---

**Vladimir Iliakov** (2025-09-18 10:15):
If it is a network issue, I would start checking all these components: `CNI control plane, network policies, kube-proxy, kubedns/coredns, host-based firewall`

---

**Frank van Lankvelt** (2025-09-18 10:16):
It is possible to implement rbac without the extension, but you'll have to provision the roles and role bindings yourself.

We're focussing on providing a good integration with Rancher.  Can I ask why you don't want to use the extension?

---

**Vladimir Iliakov** (2025-09-18 10:17):
It also might be something wrong with the host on which pod is scheduled to.

---

**Surya Boorlu** (2025-09-18 10:33):
I will check with the customer and get back to you on this. Thank you.

---

**Amol Kharche** (2025-09-18 11:59):
you mean below right ? below is my local setup.
```# kubectl port-forward suse-observability-agent-cluster-agent-75b7949857-h97l5 -n suse-observability 5005:5005
Forwarding from 127.0.0.1:5005 -&gt; 5005
Forwarding from [::1]:5005 -&gt; 5005

Exec into node-agent pod and run curl.
# kubectl exec -it suse-observability-agent-node-agent-bmwv8 -n suse-observability -- sh
Defaulted container "node-agent" out of: node-agent, process-agent
sh-4.4$ curl https://10.42.0.41:5005/version```

---

**Amol Kharche** (2025-09-18 12:03):
~I tried to just add `stackstate.allowedOrigins` in the values file but it did not appear in configmap.~

---

**Vladimir Iliakov** (2025-09-18 12:09):
That proves that cluster-agent is listening on 5005
```k port-forward suse-observabilty-dev-agent-cluster-agent-5fb9c5ff8b-j967f 5005:5005
Forwarding from 127.0.0.1:5005 -&gt; 5005
Forwarding from [::1]:5005 -&gt; 5005
Handling connection for 5005```
```❯ curl -k https://127.0.0.1:5005
404 page not found```
This one proves that node-agent can access cluster agent via a service name (In your case the name will be different)
```❯ k exec -ti suse-observabilty-dev-agent-node-agent-qpwll -- curl -k https://suse-observabilty-dev-agent-cluster-agent:5005
Defaulted container "node-agent" out of: node-agent, process-agent
404 page not found```
I just check that cluster agent image doesn't have `curl` so it is impossible to run from its pod...

---

**Amol Kharche** (2025-09-18 12:10):
Can you please share procedure how to add it ? I still didn't get it.

---

**Amol Kharche** (2025-09-18 12:26):
Is there any logs we need other that this ?

---

**Amol Kharche** (2025-09-18 12:29):
&gt; If it is a network issue, I would start checking all these components: `CNI control plane, network policies, kube-proxy, kubedns/coredns, host-based firewall`
Any particular logs/cmd output we need from above ?

---

**Vladimir Iliakov** (2025-09-18 13:40):
If this is environment specific issue, we can't efficiently troubleshot it via Slack.

---

**Amol Kharche** (2025-09-18 15:46):
Customer replied now :face_with_rolling_eyes:
```We upgraded to the new version but there were still issue's default the agent roll out deploys network policy's for the node agent, but there is one missing we needed to add one for the cluster agent otherwise the issue are still persistent. We have added the following:

apiVersion: networking.k8s.io/v1 (http://networking.k8s.io/v1)
kind: NetworkPolicy
metadata:
  name: hp-suse-observability-agent-cluster-agent
  namespace: suse-observability-agent
spec:
  ingress:
    - ports:
        - port: 5005
          protocol: TCP
  podSelector:
    matchExpressions:
      - key: app.kubernetes.io/component (http://app.kubernetes.io/component)
        operator: In
        values:
          - cluster-agent
    matchLabels:
      app.kubernetes.io/component (http://app.kubernetes.io/component): cluster-agent
  policyTypes:
    - Ingress

We hope you will fix this because this is a breaking change!!!!!```

---

**Andrea Terzolo** (2025-09-18 16:12):
well this is pretty weird... if you still have access to their setup can you check the node-agent yaml?
```kubectl get pod -n suse-observability-agent &lt;node-agent&gt; -o yaml | grep hostNetwork```
it should be deployed in host Network so `hostNetwork: true`

---

**Amol Kharche** (2025-09-18 17:14):
Here is the all logs with yaml.

---

**Amol Kharche** (2025-09-18 17:19):
I asked few question to customer.
```Do you mean agent working fine now and able to send data to observability instance ?
-&gt; yes the node agent errors are gone.
By the way we have do not see any issue with the agent on other clusters. Might be issue specific to your environment because of network policy ?
-&gt; could be but there is a default poliy for the node agents
Do you have default network policy which deny any traffic ? 
-&gt; we have network isolation between project's 
these are attached default policys we are running```

---

**Andrea Terzolo** (2025-09-18 17:45):
thank you! I checked and the node-agent is deployed in hostNetwork as expected so i don't get their comment on the "breaking change". AFAIK we don't ship any network policy

---

**Andrea Terzolo** (2025-09-18 17:51):
or at least not in the agent helm chart. Not sure about the platform but i don't think so

---

**Surya Boorlu** (2025-09-19 07:35):
@Frank van Lankvelt Customer responded on why they are not using extension&gt;

```Our next step will be to test the Rancher UI extension, because in the past our root CA wasn't implemented in Rancher and thas was needed for validation. We are currently testing a way to make this work. 
One last question: Is it also possible to exclude namespaces with the current setup? This was working in the past```

---

**Frank van Lankvelt** (2025-09-19 08:05):
The new version of the extension does http calls directly from the ui, not proxied by rancher.  So they could just give it a try instead of trying with the root certificate.

---

**Frank van Lankvelt** (2025-09-19 08:39):
There is no mechanism to exclude access - it can only be granted.  But as mentioned above, it can be granted per namespace.  If you use the Rancher extension, then all namespaces in a project will get the necessary rolebindings if the roletemplates are assigned.

---

**Frank van Lankvelt** (2025-09-19 08:42):
if you add
```stackstate.allowedOrigins:
  - https://<YOUR_RANCHER_URL>```
to the SUSE Observability values and redeploy using `helm upgrade`, it will appear in the correct configmap

---

**Surya Boorlu** (2025-09-19 08:51):
Got it Frank. Thank you

---

**Surya Boorlu** (2025-09-19 08:51):
@Vladimir Iliakov Just a gentle reminder in case you missed the previous one.

---

**Vladimir Iliakov** (2025-09-19 09:18):
<!subteam^S08HHSW67FE> <!subteam^S08HEN1JX50> can anyone have a look please?

---

**Bram Schuur** (2025-09-19 09:22):
@Remco Beckers ideally someone from team borg takes this (being OTEL), but if you are overrbooked someone form marvin could look

---

**Alessio Biancalana** (2025-09-19 09:25):
@Surya Boorlu is the customer using Kubernetes on AWS? What kind of ingress are they using and what version of the ingress?

---

**Surya Boorlu** (2025-09-19 09:31):
@Alessio Biancalana I am writing the customer about this question. Do you need any additional information?

---

**Surya Boorlu** (2025-09-19 09:31):
So that we can send it at once.

---

**Alessio Biancalana** (2025-09-19 09:34):
not at the moment, this is where I'm coming from

https://github.com/kubernetes/ingress-nginx/issues/2963

since a lot of people some time ago complained about gRPC and TLS termination/ALB downgrades I was wondering if we could know the architecture adopted by the customer

---

**Surya Boorlu** (2025-09-19 09:35):
Got it. Let me check the customer.

---

**Remco Beckers** (2025-09-19 10:01):
I've seen the "not sending trailers" error when NGINX ingress is not configured specifically to support gRPC on the collector. See the Ingress example here (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/install-stackstate/kubernetes_openshift/ingress.html#_configure_ingress_rule_for_open_telemetry), the relevant line is in the annotations:
```      nginx.ingress.kubernetes.io/backend-protocol (http://nginx.ingress.kubernetes.io/backend-protocol): GRPC```
If there are other or more loadbalancers or reverse proxies between the collector and SUSE Observability I can imagine some might need a similar configuration.

---

**Surya Boorlu** (2025-09-19 10:02):
Customer responded:
No we don't use kubernetes on AWS. We are using NGINX as the ingress controller. We are using version 4.12.1 and app version 1.12.1. I got the error message to dissappear by removing the metrics pipeline from the opentelemetry-collector values, but this of course is not the satisfactory solution. We are using the following values: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s.html.

---

**Remco Beckers** (2025-09-19 10:03):
If they've removed the metrics pipeline it is likely simply no data is sent and that's the reason why the error disappeared. Unless they are already shipping traces themselves.

---

**Alessio Biancalana** (2025-09-19 10:04):
yes. @Remco Beckers already pointed you to a potential fix, exactly.

---

**Surya Boorlu** (2025-09-19 10:08):
Got it. Will try it and share with the customer. Thank you all.

---

**Remco Beckers** (2025-09-19 10:09):
If the gRPC protocol keeps giving problems, an alternative is to switch to the HTTP based protocol. See the troubleshooting section (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/collector.html#_exporters) (it links to a section that describes how to modify it) and also a more complete example of the collector configuration here https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/otlp-apis.html#_collector_configuration.

---

**IHAC** (2025-09-19 21:46):
@Rodolfo de Almeida has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
I believe this is a Feature Request
Cluster Filter for OpenTelemetry Services in SUSE Observability UI

*Description:*
Currently, the SUSE Observability UI provides a cluster filter for Kubernetes services and pods, allowing users to filter metrics and views by cluster. However, there is no equivalent cluster filter available for OpenTelemetry services.

*Request:*
We would like to request the addition of a cluster filter for OpenTelemetry services in the SUSE Observability UI. This filter should provide the same functionality as the existing Kubernetes cluster filter, enabling users to view OpenTelemetry metrics and data scoped to a specific cluster.

---

**Rodolfo de Almeida** (2025-09-19 21:47):
This is the existing Cluster Filter for kubernetes

---

**Rodolfo de Almeida** (2025-09-19 21:48):
the customer wants to add something similar to Open Telemetry

---

**IHAC** (2025-09-20 00:34):
@Garrick Tam has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
:: FEATURE REQUEST ::
Customer wants to take advantage of the log collection into Elastic Search and make all logs accessible.

== CURRENT BEHAVIOR ==
UI is only able to display logs on a per pod basis given the product focus is to rely on monitors from telemetry data.

== USE CASE ==
So in our case as we are troubleshooting sometimes the issue is at the application level where the pod doesn't crash and doesn't cause a health check issue. For this type of event we look through logs....usually at Ingress controller level or between multiple logs of pods that in a replicaset for the service. In Observability we can drill down to each individual pod and see the logs but once we want to look at different logs all together it becomes cumbersome. Usually need open multiple tabs and drill down to each specific log on each pod.

Since the backend of this is elastic search. Could we just not open up ES to allow us to query against it all the logs. Probably attach kibana to do this for us? Before we had observability we shipping our logs into a dedicated elasticsearch cluster to query against all the logs. Since Observability is already gathering all those logs and is in a elastic search cluster its kind of silly to use up more storage and compute to have two elastic search clusters just because of this limitation on Observability side.

---

**Garrick Tam** (2025-09-20 00:35):
Please reply with Jira ticket is feature request is accepted for triage or reply with explanation on why this is not a feature we want to implement.

---

**IHAC** (2025-09-20 05:43):
@Garrick Tam has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
Customer would like a Monitor for the otel collector service.  Is the following Monitor valid to return the correct Health state of the service?
```
_version: 1.0.90
nodes:
- _type: Monitor
  arguments:
    comparator: LTE
    failureState: DEVIATING
    metric:
      aliasTemplate: ''
      query: otelcol_process_uptime_seconds_total &gt; 0
      unit: ms
    threshold: 0.0
    urnTemplate: urn:opentelemetry:namespace/default:service/otelcol-k8s
  function: {{ get "urn:stackpack:common:monitor-function:threshold"  }}
  id: -13
  identifier: urn:custom:monitor:span-otel-collector
  intervalSeconds: 10
  name: Otel Collector
  status: ENABLED
  tags:
  - service
timestamp: 2025-09-20T03:40:44.676953696Z[Etc/UTC]```

---

**Garrick Tam** (2025-09-20 05:44):
Please let me know if there is a better/easier Monitor to capture the correct state of the Otel collector service?  TIA

---

**Garrick Tam** (2025-09-20 06:11):
Given this another thought and believe _total in the metric suggest the aggregate which will be greater than 0 for a long time.  Can someone please help me with a better query to check the health of the otel collector service?  Thanks.

---

**Amol Kharche** (2025-09-22 10:37):
Thank you team. The issue was with the network policy, which was blocking communication between the agents.

---

**Alessio Biancalana** (2025-09-22 11:13):
We will look into it, thanks for reporting it, at the moment we are focusing on stability rather than adding feature so it will have to be matched against existing priorities. This is indeed a feature request :slightly_smiling_face:

---

**Alessio Biancalana** (2025-09-22 11:15):
I don't think this is a feature we want to implement at the moment, if the customer wants to do that they are very welcome to deploy a kibana instance to browse the logs collected into elasticsearch but at the moment we are not interested into enhancing any logs browsing capabilities as it would be a completely new domain for a software that is tailored to do something else. Of course it can be evaluated by the product team in the future and prioritized accordingly.

---

**Louis Lotter** (2025-09-22 11:16):
@Mark Bakker can weigh in here maybe.

---

**Alessio Biancalana** (2025-09-22 11:16):
We will look into it, thanks

---

**Jeroen van Erp** (2025-09-22 11:20):
I remember a more generic log explorer was once on the backlog...

---

**Remco Beckers** (2025-09-22 11:29):
We have a new version of logging on the roadmap that will make logs available much broader, with a log explorer indeed, but also exposing logs on the deployment level, etc.
At the same time we are very likely to move logs away from Elasticsearch as part of that work, so if they are going to build anything on top of Elasticsearch they should be aware that it is not a supported API, and we are likely to remove it in the future.

Finally, the work is on the roadmap, but our roadmap is getting a significant overhaul at the moment. So it is hard to say when we will be making these changes. In a week or so this should become more clear I think.

---

**Frank van Lankvelt** (2025-09-22 11:51):
what kind of storage is used?  I see some very slow writes to HDFS in the logs

---

**Louis Lotter** (2025-09-22 11:51):
@Amol Kharche @David Noland is it customary to use channels like these for feature requests ? I'm asking as my team is treating this channel as high priority support requests. Would <#C079ANFDS2C|> not be more applicable for feature requests ? This is a question not a statement. I don't know the wider practices in Suse.

---

**Remco Beckers** (2025-09-22 11:53):
It depends on what you want to reflect in the monitor, i.e. what do you mean with "the health of the service".

Do you simply want to check if it is running? Or do you want to go into more depth?

For the former you can do it like this:
```_version: 1.0.90
nodes:
- _type: Monitor
  arguments:
    comparator: LT
    failureState: DEVIATING
    metric:
      aliasTemplate: ''
      query: present_over_time(otelcol_process_uptime_total[2m])
      unit: ms
    threshold: 1
    urnTemplate: urn:opentelemetry:namespace/default:service/otelcol-k8s
  function: {{ get "urn:stackpack:common:monitor-function:threshold"  }}
  id: -13
  identifier: urn:custom:monitor:span-otel-collector
  intervalSeconds: 10
  name: Otel Collector
  status: ENABLED
  tags:
  - service```
It will go to deviating when the metric disappears. This metric will be there when the collector is running and will be gone when it is not running. The aggregation over `2m` takes care that it doesn't immediately trigger when there is a missing data point or some data is slow.

Be aware however that if the collector is down for a longer time it will disappear entirely from the topology and you will not see the health state on it.

---

**Amol Kharche** (2025-09-22 12:09):
Yes , We mainly used channel like this for feature requests from customer.
@Chris Riley If you want to add anything here.

---

**Amol Kharche** (2025-09-22 12:13):
More specifically This is an IBM flash storage connected to esxi hosts .

---

**Frank van Lankvelt** (2025-09-22 12:17):
but something is slowing it down - can't imagine an SSD taking multiple seconds for writing 40Kb files

---

**Louis Lotter** (2025-09-22 12:19):
what are the expectations regarding response times to feature requests ? We would normally need a product owner to weigh in to give a good answer.

---

**Chris Riley** (2025-09-22 12:31):
@Louis Lotter agree with Amol that we should use this channel for issues/bugs/feature requests coming from customers (via support).
In terms of response times, I would say that feature requests are typically less urgent than issues/bugs being reported by customers. I think it would be helpful to at least get an initial response within 24-48 hours, if that is feasible?

---

**Louis Lotter** (2025-09-22 12:34):
That should be fine excluding weekends.

---

**Mark Bakker** (2025-09-22 12:38):
The above is indeed correct. And more updated on roadmap will follow.

---

**Chris Riley** (2025-09-22 12:40):
Oh yeah, no need to worry about weekends for feature requests.

---

**Amol Kharche** (2025-09-22 12:45):
Can you please share the logs which showing it take multiple seconds for writing 40kb files. I need to show to customer :sweat_smile:

---

**Amol Kharche** (2025-09-22 12:54):
Hi Team,
the customer Dienst ICT Uitvoering  (https://suse.lightning.force.com/lightning/r/Account/0011i00000wkkUAAAY/view) facing issue with the cluster and pod metrics.
They  were looking at the cluster dashboard in observability and observed that only one cluster show's the memory and cpu usage of the cluster( included some screenshots).
The cluster we see metrics of is the cluster were suse observability is installed. Further more they see no cpu and memory data of the pods that are not running on the suse observability cluster also shown in the one of the screenshots. I have included agent logs from one of the clusters that is not showing any data and the logs from suse observability.

---

**Amol Kharche** (2025-09-22 12:55):
I could see error in API pods.
```2025-09-19 08:41:59,584 ERROR akka.actor.ActorSystemImpl - Error during processing of request: 'Failed to connect to metric store'. Completing with 500 Internal Server Error response. To change default exception handling behavior, provide a custom ExceptionHandler.
com.stackstate.metrics.api.package$ServiceUnavailable: Failed to connect to metric store```

---

**Remco Beckers** (2025-09-22 13:12):
I'm missing the logs for the process-agent which should be part of the node-agent logs (the node-agent runs 2 containers: node-agent and process-agent). Did they get excluded or is the process-agent container not running at all?

The process-agent is responsible for most of the container/process level usage metrics.

---

**Amol Kharche** (2025-09-22 13:18):
Looks like they have manually downloaded without process-agent, Let me ask them

---

**Frank van Lankvelt** (2025-09-22 13:18):
from `suse-observability-hbase-hdfs-dn-2/datanode.log`:
```2025-09-22 07:44:43,844 INFO DataNode.clienttrace: src: /10.21.94.12:55528, dest: /10.21.35.78:50010, volume: /hadoop-data/data, bytes: 40597, op: HDFS_WRITE, cliID: DFSClient_NONMAPREDUCE_1314523097_1, offset: 0, srvID: 3e296a2a-d65e-4d3d-851b-1dace180f6f3, blockid: BP-2136076581-10.21.26.68-1744200171299:blk_1074113961_378112, duration(ns): 1997124872```

---

**Remco Beckers** (2025-09-22 13:19):
The cpu/memory requests and limits are coming from the kubernetes state however and that's collected by the cluster agent. I can see that running ok in the cluster-agent log.

---

**Remco Beckers** (2025-09-22 13:20):
Or maybe they haven't set request and limits on those pods we see here

---

**Remco Beckers** (2025-09-22 13:21):
In the screenshot it also looks like there is at least one pod that was scrolled almost out of view does have some metrics. I'd be curious what the difference is

---

**Amol Kharche** (2025-09-22 13:22):
Clusters should show the stat right

---

**Frank van Lankvelt** (2025-09-22 13:22):
though this might be a red herring - I now also see a lot of variation in the reference system I'm looking at

---

**Remco Beckers** (2025-09-22 13:24):
They should, but that relies on 2 different metrics. One coming from the process-agent and another from the kubernetes state

---

**Remco Beckers** (2025-09-22 13:24):
If either one is missing there will be no data

---

**Amol Kharche** (2025-09-22 13:46):
Here is the process-agent logs

---

**Remco Beckers** (2025-09-22 14:08):
@Andrea Terzolo @Alessio Biancalana Can you take a look at this? Especially when we know some of the details of the environment there?

---

**Alessio Biancalana** (2025-09-22 14:10):
I can try, yes

---

**Amol Kharche** (2025-09-22 14:13):
I can ask customer if there are any issue at storage end.

---

**Rodolfo de Almeida** (2025-09-22 14:24):
Hello @Alessio Biancalana
Thanks for your response. Should I create a Jira ticket?

---

**Alessio Biancalana** (2025-09-22 14:25):
more than creating a Jira ticket I think you want to speak to @Mark Bakker about this :slightly_smiling_face:

---

**Amol Kharche** (2025-09-22 14:26):
Customer said
```We are running rancher RKE2 clusters V2.11.3
Most of them running kubernetes version v1.32.5+rke2r1
We are using containerd version <containerd://2.0.5-k3s1>```

---

**Rodolfo de Almeida** (2025-09-22 14:29):
Thank you!

---

**Remco Beckers** (2025-09-22 14:32):
Mmm ok. So for some reason containerd is not detected on those clusters :disappointed:

---

**Alessio Biancalana** (2025-09-22 14:41):
it looks like that, I hoped in a more clear statement

---

**Remco Beckers** (2025-09-22 14:42):
Yeah me too :disappointed: . Could be related to Kubernetes 1.32 maybe?

---

**Alessio Biancalana** (2025-09-22 14:43):
that's what I thought, and another thing I would look at is how is the agent deployed because since containerd _is_ running on the node it's very strange we don't manage to connect to it

---

**Alessio Biancalana** (2025-09-22 14:43):
maybe they didn't give the agent the proper set of permissions

---

**Remco Beckers** (2025-09-22 14:44):
Indeed, but that would have to be an override or some restriction applied via Pod Security Admission

---

**Alessio Biancalana** (2025-09-22 14:54):
yeah exactly

---

**Amol Kharche** (2025-09-22 14:59):
I believed they used ArgoCD to deploy agent.

---

**Amol Kharche** (2025-09-22 15:02):
Let me double confirm with customer. Anything apart from this need to confirm with customer?

---

**Alessio Biancalana** (2025-09-22 15:19):
Not at the moment, thank you

---

**Andrea Terzolo** (2025-09-22 15:21):
maybe they can check what is the path of the containerd socket on the node. Looking at our helm chart we search it under `/var/run/containerd/containerd.sock`

---

**Amol Kharche** (2025-09-22 16:14):
Got the reply from customer.
```Hello Amol,
the path to the containerd socket is /run/k3s/containerd/containerd.sock
We use Pod security admission but he have it set to privilliged for the agent namespace i have included a screenshot.
the only other thing i can think of is that we use project network isolation and we use selinux.```

---

**Andrea Terzolo** (2025-09-22 16:21):
uhm i'm under the impression they should specify this custom path in the agent helm chart https://gitlab.com/stackvista/devops/helm-charts/-/blob/master/stable/suse-observability-agent/values.yaml?ref_type=heads#L99 `nodeAgent.containerRuntime.customSocketPath`

---

**Andrea Terzolo** (2025-09-22 16:22):
what puzzles me is that all RKE2 clusters should probably have the socket under that path is it possible that we never noticed that? :thinking_face:

---

**Alessio Biancalana** (2025-09-22 16:22):
yes, @Amol Kharche could you tell them to update that option accordingly and let us know?

---

**Remco Beckers** (2025-09-22 16:23):
That would be weird. It stands out quite obviously that there are no cpu usage metrics for example

---

**Amol Kharche** (2025-09-22 16:27):
So customer have to set containerRuntime path to `/run/k3s/containerd/containerd.sock`  amd try Right

---

**Frank van Lankvelt** (2025-09-22 16:38):
did you specify the `rancherUrl` when rendering the values template?  (or specify `stackstate.allowedOrigins` in the values file with the Rancher URL)

---

**Alejandro Acevedo Osorio** (2025-09-22 16:38):
@Bruno Bernardi the issue is the `baseUrl` they configured .. I see in the configmaps
```      stackstate.web.origins = [
          "https://rancher.pro.identrust.com"
        ]```

---

**Alejandro Acevedo Osorio** (2025-09-22 16:39):
the `stackstate.baseUrl` needs to match with the `ingress` host which is configured as `stackstate.k8s-observability.pro.identrust.com (http://stackstate.k8s-observability.pro.identrust.com)`

---

**Frank van Lankvelt** (2025-09-22 16:44):
either the `baseUrl` or one of the `stackstate.web.origins` must indeed match on CORS requests.  The origins in the ConfigMap are generated by the helm template based on the `stackstate.allowedOrigins` value.

---

**Bruno Bernardi** (2025-09-22 16:50):
Thanks for your prompt responses, @Alejandro Acevedo Osorio @Frank van Lankvelt.

It seems that the customer was not specifying the correct `baseUrl` in the values template. I'll review this with them and let you know as soon as I have any updates. Also, thanks for the information about `stackstate.web.origins`, I wasn't aware of that.

---

**Garrick Tam** (2025-09-22 18:43):
Where can I find the roadmap once it get updated and published?

---

**Garrick Tam** (2025-09-22 18:44):
Thank you.

---

**David Noland** (2025-09-22 22:05):
For some products, we'll just put the feature requests directly into Jira. It would make sense to post them here in a Slack channel if we feel they need some discussion

---

**Amol Kharche** (2025-09-23 05:41):
Customer changed it but getting error in node-agent logs.

---

**Alessio Biancalana** (2025-09-23 08:51):
the strange thing is, the process agent successfully connects to containerd/cri while the node agent doesn't

---

**Remco Beckers** (2025-09-23 08:52):
We don't know for sure unless you can infer it from the process agent log. We haven't seen data on containers in the screenshots

---

**Alessio Biancalana** (2025-09-23 09:01):
process agent logs:

```2025-09-22 15:25:48 INFO (containerd_util.go:181) - Connected to containerd - Version v2.0.5-k3s1/```

---

**Amol Kharche** (2025-09-23 09:04):
Does it mean process-agent runs as root inside its container and can talk to /run/k3s/containerd/containerd.sock where node-agent may be running as restricted user and thus gets permission denied ?

---

**Amol Kharche** (2025-09-23 09:21):
@Frank van Lankvelt I have a call with customer in next 2 hours, Do you have any steps to troubleshoot/resolved this? May be increase Memory as customer getting OOMkilled?

---

**Frank van Lankvelt** (2025-09-23 09:41):
that is certainly a good idea.  It may be just needed for startup, there may be a number of compactions and/or region splits that take up too much memory.  But then it should settle for a lower value later.

---

**Frank van Lankvelt** (2025-09-23 09:43):
can you also get the specs - number of nodes (may be also pods/containers/other resources).  Maybe they need to upgrade to a bigger profile?

---

**Andrea Terzolo** (2025-09-23 10:09):
it could be, they have different privileges, but this would mean this is the first time we deploy the node agent on an RKE2 cluster because otherwise we would have faced this error before... and this seems strange. Let me try to investigate it... I don't even since a config in the helm chart to turn the node-agent into a privileged container

---

**Amol Kharche** (2025-09-23 10:24):
Sure, I will ask them

---

**Amol Kharche** (2025-09-23 11:31):
Currently the hbase-rs has 3gb(Both requests and limits) memory. How much we need to increase 6gb?
```          resources:
            limits:
              cpu: "4"
              ephemeral-storage: 100Mi
              memory: 3Gi
            requests:
              cpu: "2"
              ephemeral-storage: 1Mi
              memory: 3Gi```

---

**Frank van Lankvelt** (2025-09-23 11:33):
yeah let's try that.  If the issue is something else then available memory then we'll find out.

---

**Andrea Terzolo** (2025-09-23 12:02):
i'm looking into this and i replicated a scenario in which the node-agent is not able to scrape data from the container runtime socket but i still see CPU and memory metrics for pods...i'm not familiar with the node-agent logic @Remco Beckers @Louis Parkin are we sure CPU and memory metrics for pods are collected by the node agent with the container runtime check?

---

**Frank van Lankvelt** (2025-09-23 12:08):
could you get a complete log from the state pod?

---

**Amol Kharche** (2025-09-23 12:13):
As soon as I get support logs , I will share here.  btw what is the procedure to upgrade profile from 150ha to 250ha?

---

**Frank van Lankvelt** (2025-09-23 12:28):
that would be to re-render the suse-observability-values chart and use the resulting values files to redeploy

---

**Remco Beckers** (2025-09-23 12:54):
I thought so tbh. Though the process agent can also be reporting them (they report very similar metrics actually. I did a check on the DataDog documentation where I thought the `container.cpu.usage` metric comes from the node agent.

I can take a look at the code (in the receiver) to be 100% sure. I am disappearing in a meeting in 5 minutes again though

---

**Remco Beckers** (2025-09-23 13:03):
It was not as easy to check as I thought. Now I'm in a meeting again

---

**Daniel Murga** (2025-09-23 14:14):
Hi <#C07CF9770R3|>! Can someone please take a look at this Jira STAC-23279? I don't understand if it's fixed... so I need to communicate to customer accordingly. TIA

---

**Chris Riley** (2025-09-23 14:36):
@Frank van Lankvelt can you advise here please?

---

**Andrea Terzolo** (2025-09-23 15:00):
i'm under the impression that these metrics are taken from the `kubelet` check and so from cAdvisor. That would also be the more natural choice, but the kubelet check seems to run correctly from the logs

---

**Rodolfo de Almeida** (2025-09-23 15:01):
Hello @Frank van Lankvelt
I am taking over this case as soon as Amol's shift has ended.
The customer is asking for a call to check the issue. Are you available to join a call with us to check this problem or should I ask for the full logs to investigate the logs first?

---

**Frank van Lankvelt** (2025-09-23 15:03):
we looked into the issue and found it to be purely hbase and hdfs.  So the resolution was to bump hbase.  We're running the updated version now internally to see if there are other issues that might be triggered.  But if all goes well the upgrade should be available soon in a new release.

---

**Frank van Lankvelt** (2025-09-23 15:05):
please ask for logs first.  It seems like some initialization code is fetching too much data from hbase at once, the logs should help narrow down the list of suspects

---

**Remco Beckers** (2025-09-23 15:19):
That could indeed be the case. I guess that leaves these possibilities:
• Something is dropping metrics on the platform side
• The data in the node-agent needs the extra information from containerd to add all required labels
• Something else...
The only thing that seems to be strange on the agent side is the containerd connectivity error I guess. We can check the logs ffor platform side to see if we can rule that out entirely if that would help.

---

**Remco Beckers** (2025-09-23 15:22):
Actually, I remember we got the cpu_usage metrics from several different sources at one point: the node-agent reporting `container_*` metrics, the node agent reporting `docker_*`  or `containerd_*` metrics and the process agent also reporting the same metrics (but I don't remember the name, could be that is `container_*` and the other one is slightly different). But this was several agent version ago.

---

**Rodolfo de Almeida** (2025-09-23 15:25):
Ok... I have already asked them to send the logs. Thanks Frank...

---

**Rodolfo de Almeida** (2025-09-23 15:25):
@Frank van Lankvelt The customer just sent the logs

---

**Remco Beckers** (2025-09-23 15:25):
Oh. I found something helpful in the Datadog docs that seems to say this is still the case:
• The kubelet check gets the `kubernetes.cpu.*` metrics: https://docs.datadoghq.com/containers/kubernetes/data_collected/#kubernetes
• The container check gets the `container.cpu.*` metrics: https://docs.datadoghq.com/integrations/container/#metrics
And there can be slight differences: https://docs.datadoghq.com/containers/faq/cpu-usage-metrics/

---

**Rodolfo de Almeida** (2025-09-23 15:26):
They also mentioned that they changed the sizing values and tried to redeploy the SO again but Elastic search is not coming up.

---

**Remco Beckers** (2025-09-23 15:26):
But we don't store the `kubernetes.cpu.*` metrics afaict

---

**Andrea Terzolo** (2025-09-23 15:27):
&gt; The only thing that seems to be strange on the agent side is the containerd connectivity error I guess. We can check the logs ffor platform side to see if we can rule that out entirely if that would help.
I think that today we don't support socket scraping if the socket is not in the default path... we have the customPath field in the chart but we don't give to the nodeAgent the right privileges to scrape from the alternative path... so this is for sure a first issue, but i'm not 100% sure it is related to what we are seeing here. In my local cluster i moved the containerd socket under a custom path to reproduce the error but i can still see the CPU and memory metrics, i only have the `kubelet` check running

---

**Rodolfo de Almeida** (2025-09-23 15:31):
The customer has increased the severity of this case. Could we prioritize this issue?
 I understand you are busy, but the customer is increasing the severity as time goes on.

---

**Remco Beckers** (2025-09-23 15:33):
That's hard to explain :shrug:

---

**Remco Beckers** (2025-09-23 15:36):
Are you sure you are also seeing the cpu and memory usage and not just the request and limits? Checking the obvious here to find an explanation...

---

**Andrea Terzolo** (2025-09-23 15:39):
yep, https://stac-23286.dev.stackstate.io/#/views/urn:stackpack:kubernetes-v2:shared:query-view:[…]dFilters=cluster-name%3Alocal-setup&amp;rightPane=hidden-0 (https://stac-23286.dev.stackstate.io/#/views/urn:stackpack:kubernetes-v2:shared:query-view:pods/overview?detachedFilters=cluster-name%3Alocal-setup&amp;rightPane=hidden-0) now i uninstalled the agent but they should be still visible

---

**Frank van Lankvelt** (2025-09-23 15:40):
these logs seem to be before the state, health-sync and other services are starting up.  So I'm not able to learn anything from them.

---

**Frank van Lankvelt** (2025-09-23 15:41):
I'm not sure what you expect from me in terms of prioritization.  If the customer feels my time isn't good enough, let them  bring in their own hbase experts

---

**Remco Beckers** (2025-09-23 15:42):
Mmm, I see

---

**Rodolfo de Almeida** (2025-09-23 15:42):
Sorry, I just wanted to share that the customer is escalating the case and asking us to check the logs as soon as possible.
 They are eager to get this fixed quickly.
You’ve been very helpful, and I really appreciate your support.

---

**Rodolfo de Almeida** (2025-09-23 15:43):
I will join a call with the customer and will make sure to collect the logs when the problem is happening.

---

**Andrea Terzolo** (2025-09-23 15:46):
saying the obvious:
1. we should try to understand the exact metrics used to produce CPU and Memory in the UI
2. we should try to understand if the agent is producing these metrics (worst case, sniffing the traffic that goes out)
On point 1 i have no idea at the moment on how to do it :confused:

---

**Remco Beckers** (2025-09-23 15:48):
The exact metric I just pulled from the metric inspector: `sum by (cluster_name, namespace, pod_name) (container_cpu_usage{cluster_name="local-setup", namespace="kube-system", pod_name="coredns-674b8bbfcf-lv4k4"}) / 1000000000`. But I already knew that, that's why I keep referring to `container_cpu_usage`.  You can click on the `&lt;&gt;` icon on the cpu usage chart to open the inspector here: https://stac-23286.dev.stackstate.io/#/components/urn:kubernetes:%2Flocal-setup%2Fpod%2F696[…]active_tab-selection__chain-component%3A23338655857295 (https://stac-23286.dev.stackstate.io/#/components/urn:kubernetes:%2Flocal-setup%2Fpod%2F6968b2d9-ee98-4da8-a6b7-f0ebeffac154?detachedFilters=cluster-name%3Alocal-setup&amp;rightPane=hidden-0__active_tab-selection__chain-component%3A23338655857295)

---

**Frank van Lankvelt** (2025-09-23 15:50):
I think  we need to bring down the batch size that's used on initialization of the services.  Apparently the components are too big to load at once

---

**Andrea Terzolo** (2025-09-23 15:51):
yep i saw that but i'm not sure i should expect a metric called exactly `container_cpu_usage` going out from the node-agent, do we use some alias or this is the name of the original metric i should expect?

---

**Remco Beckers** (2025-09-23 15:52):
The only transformation I can find / know about is that we rename some labels and we replace `.` and other unsupported characters with `_`. So most metrics start with a name like `container.cpu.usage` and get renamed to `container_cpu_usage`.

---

**Frank van Lankvelt** (2025-09-23 15:52):
with the environment variable `CONFIG_FORCE_stackstate_stateService_initialLoadTransactionSize` set to `5000`, I expect things to work out.  (the default is `10000`)

---

**Andrea Terzolo** (2025-09-23 15:54):
ok let me try to dump the node-agent metrics

---

**Remco Beckers** (2025-09-23 15:54):
Aha. If you can access the node-agent pod you can manually run the separate checks from the command line and dump them to a file (or just the console)

---

**Andrea Terzolo** (2025-09-23 15:55):
oh really? is the command documented somewhere?

---

**Remco Beckers** (2025-09-23 15:55):
I don't know.

---

**Remco Beckers** (2025-09-23 15:56):
I usually just get a shell in the container via `k9s` (or via `kubectl exec` ) and then run `agent` and follow the help I get then

---

**Remco Beckers** (2025-09-23 15:56):
Trying it again on the preprod cluster now

---

**Remco Beckers** (2025-09-23 15:56):
`agent status` gives a check status summary (including metric counts)

---

**Frank van Lankvelt** (2025-09-23 15:57):
this should be possible with a values yaml
```stackstate:
  components:
    all:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_stateService_initialLoadTransactionSize: "5000"
          CONFIG_FORCE_stackstate_notifications_init_initialLoadTransactionSize: "5000"
          CONFIG_FORCE_stackstate_healthSync_initialLoadTransactionSize: "5000"```

---

**Remco Beckers** (2025-09-23 15:58):
There is more, but running the container check manually reports no metrics at all :shrug::
`agent check container`  or `agent check container --check-rate`

---

**Andrea Terzolo** (2025-09-23 15:59):
i see, i'm now looking at `agent check kubelet`

---

**Remco Beckers** (2025-09-23 15:59):
:thumbs-up:

---

**Remco Beckers** (2025-09-23 15:59):
`agent configcheck` is also helpful when troubleshooting a check iirc

---

**Remco Beckers** (2025-09-23 16:00):
It mostly gives more details than the `status` command

---

**Remco Beckers** (2025-09-23 16:04):
I got lucky with a `container` check run on our preprod cluster and found the `container.memory.usage` metric in its output.

---

**Mark Bakker** (2025-09-23 16:06):
I will update:
https://docs.google.com/presentation/d/1DDeAUn65YOfHJDxsTDCzYwSDGvL_CUPnrDWhWElGdo4/edit?slide=id.g381c455e269_0_80#slide=id.g381c455e269_0_80

---

**Andrea Terzolo** (2025-09-23 16:06):
yeah in the kubelet one i can only see `kubernetes.cpu.requests`

---

**Andrea Terzolo** (2025-09-23 16:06):
and the limit one

---

**Daniel Murga** (2025-09-23 16:28):
Thanks a lot @Chris Riley @Frank van Lankvelt

---

**Rodolfo de Almeida** (2025-09-23 16:40):
great... I am on a call with the customer trying to uninstall the application and re-install using those settings.
Something that was strange for was that those values doesn't exist....
The person on the call with me is not aware on how they generated the installation files.

---

**Andrea Terzolo** (2025-09-23 17:03):
uhm from what i can see the check that is generating the metric `container.cpu.usage` for each container is the `container` check. This doesn't seem related to the container runtime but it seems to use directly the linux cgroup to take CPU/Memory metrics. This would explain why in my local setup i can receive these metrics even if all specific container runtime collectors are disabled.
Looking at the initial logs posted by Amol in this thread i can see  `check:container | Running check...` so metrics should be produced as well. We could dump the output of `agent check container --check-rate &gt; /tmp/container_check.json` just to be sure, but since the agent is not posting error i believe we should find the metrics here.
The next thing to investigate is where these metrics are sent and how we can check if they can reach that endpoint. Looking at the node agent logs, this seems the endpoint `https://dcmp-1000-observability.dictu.intern/receiver/stsAgent/intake/"`... is there an easy way we can check metrics reaching this point?

---

**Chris Riley** (2025-09-23 17:30):
@Louis Lotter @Frank van Lankvelt @Marc Rua Herrera @Bram Schuur
As discussed, Rabobank have opened a new case (https://suse.lightning.force.com/lightning/r/Case/500Tr00000jNi51IAC/view) via SCC. This is a continuation of Stackstate ticket 1494.

@Rodolfo de Almeida owns the new support case. Can you please advise Rodolfo of the current status, any associated Jira's, and what the next steps are? Thanks.

---

**Javier Lagos** (2025-09-23 18:05):
Here I leave the support package logs and 2 screenshots. One from SUSE Observability UI showing the old pod and another from AKS console showing the new pod

---

**Javier Lagos** (2025-09-23 18:05):
Is it safe to restart health-sync pod?

---

**Alessio Biancalana** (2025-09-23 18:13):
did they manually restart just the sync pod or was there some reason that led them to restart the sync pod?

---

**Javier Lagos** (2025-09-23 18:15):
They did restart the sync pod manually because they saw some pods not being updated on console to try to fix this issue. Now they see that the sync pod is not being updated

---

**Bruno Bernardi** (2025-09-23 18:16):
After adjusting the URL, everything worked correctly. Many thanks for your help, @Alejandro Acevedo Osorio @Frank van Lankvelt.

---

**Javier Lagos** (2025-09-23 18:28):
Hey @Rodolfo de Almeida! I fixed some time ago an issue with elasticsearch as it requires more time to start sometimes.

```kubectl patch sts suse-observability-elasticsearch-master -n suse-observability --patch '{"spec": {"template": {"spec": {"containers": [{"name": "elasticsearch","livenessProbe":{"initialDelaySeconds": 300}}]}}}}' ```
I fixed it manually but they can also modify the helm values to increase the initial delay Seconds parameter

---

**Javier Lagos** (2025-09-23 18:29):
this is the process I followed with the customer to be able to start elasticsearch pods.

```1 - kubectl scale sts -n suse-observability suse-observability-elasticsearch-master --replicas=0
2 - kubectl patch sts suse-observability-elasticsearch-master -n suse-observability --patch '{"spec": {"template": {"spec": {"containers": [{"name": "elasticsearch","livenessProbe":{"initialDelaySeconds": 300}}]}}}}' 
3 - kubectl scale sts -n suse-observability suse-observability-elasticsearch-master --replicas=3```

---

**Rodolfo de Almeida** (2025-09-23 18:35):
Thanks @Javier Lagos, but it looks like elastic search is failing due to a DNS issue...
```"log.level": "WARN", "message":"failed to resolve host [suse-observability-elasticsearch-master-headless]", "ecs.version": "1.2.0","service.name":"ES_ECS","event.dataset":"elasticsearch.server"```

---

**Rodolfo de Almeida** (2025-09-23 18:41):
The pods are starting.
```suse-observability-elasticsearch-master-0                         0/1     Running            2 (7s ago)      5m47s   10.21.94.26    deda1x100424   &lt;none&gt;           &lt;none&gt;
suse-observability-elasticsearch-master-1                         0/1     Running            1 (2m37s ago)   5m37s   10.21.35.118   deda1x100420   &lt;none&gt;           &lt;none&gt;
suse-observability-elasticsearch-master-2                         0/1     Running            2 (4s ago)      5m37s   10.21.26.74    deda1x100421   &lt;none&gt;           &lt;none&gt;```
But when you describe the pod and check the logs there are still errors ike I shared in my previous message

---

**Rodolfo de Almeida** (2025-09-23 18:52):
Hey @Javier Lagos
I think your suggestion makes sense in this case... now analyzing the logs carefully this is really a good try...
Will check if the customer can test  your suggestion... many thanks!

---

**Rodolfo de Almeida** (2025-09-23 21:13):
Hello @Mark Bakker
Can we consider this feature request for future releases? Do you want me to open a Jira ticket for it?

---

**David Noland** (2025-09-23 23:59):
Today I noticed one of our Hosted Rancher customers (Taxhawk) had over 2 million open files from the StackState process-agent (see PID 12012). Is this normal? Attached is dump of lsof -Pn . I checked another customer and it was about 240K. I've killed the pods and let them respawn to clean it up.

---

**Amol Kharche** (2025-09-24 07:59):
Hi Team,
I had a call with the customer _*Capricorn Group*_ yesterday and encountered a strange issue with the UI extension.
They have two admin users (User1 and User2), both part of the same admin group. However, when they log into Rancher they see different cluster health statuses:
*User1:* "Cluster health: observed"
*User2:* "Cluster health: unobserved"

I tried replicating the issue in my local environment using the same admin account. Interestingly, I logged into Rancher using two different browsers and observed the same inconsistency:
*Microsoft Edge:* "Cluster health: observed"
*Firefox:* "Cluster health: unobserved"
Is there a way to make this status consistent across users and browsers? Attaching screenshot from my local environment.

---

**Andrea Terzolo** (2025-09-24 08:41):
it sounds pretty strange, let me check!

---

**Remco Beckers** (2025-09-24 09:00):
The easiest way to verify is to use the metric explorer and query for the metric `container_cpu_usage` for the specific cluster: `container_cpu_usage{cluster_name="dcmp-tooling-1000"}`. But that's very similar to what the UI already does, so it likely will give no results. If it does give results it would be very helpful to get a snippet from the JSON response allowing us to check if labels are missing to describe the pod, container, etc.

Missing labels could be a cause for the issue, depending how the agent enriches the metrics from cAdvisor with all the Kubernetes labels (I suspect this is done based on container id and data retrieved from the Kubernetes api, so not super likely)

The other thing we can check is that there are no errors in the metric processing (receiver, vmagent, victoria metrics specifically), for that we will need a support bundle for the platform.

---

**Alejandro Acevedo Osorio** (2025-09-24 09:00):
Seems `tephra` was restarted around `13:40` and that should have unblocked the `health-sync`  (or due to that restart of tephra is why the `health-sync` couldn't connect)

---

**Amol Kharche** (2025-09-24 09:01):
@Frank van Lankvelt Looks like all messed up. They have upgraded profile to 250 and again they now make profile 150, Deleted pvc as well.

---

**Frank van Lankvelt** (2025-09-24 09:04):
so it ran fine with 250 and they're trying to downscale?

---

**Amol Kharche** (2025-09-24 09:06):
No, Issue was with 250 profile as well. They already downgraded 150.

---

**Javier Lagos** (2025-09-24 09:06):
Hmmmm. that's indeed weird because customer has commented on the case that the issue is still present. Do we need to restart tephra and health sync pods?

---

**Alejandro Acevedo Osorio** (2025-09-24 09:07):
Well I think the issue is still present, but it's about the `sync` pod being blocked. Not sure why the restarts are not helping it.

---

**Amol Kharche** (2025-09-24 09:09):
Customer are requesting engineering to join call to fix issue ,Is you or anyone can help here ?

---

**Javier Lagos** (2025-09-24 09:13):
I have checked almost all the components logs and I was only able to see consistent errors on Health sync and sync pods. If there is anything else I can do please let me know

---

**Frank van Lankvelt** (2025-09-24 09:14):
this is one of the issues in the UI I'm trying to track down.  I think it may be dependent on the order of clicking through the interface - that some frontend caches may not have been properly filled yet.

---

**Alejandro Acevedo Osorio** (2025-09-24 09:20):
The customer mentions that they have restarted several times the `sync` pod  and that they endup in the same situation. Perhaps we can ask them to do one more restart and share the logs again. I'd like to compare if they run into the issue even with the very same database elements `Vertex with id=28887470107634 does not exist`

---

**Javier Lagos** (2025-09-24 09:20):
Perfect. I will do that and let you know the results.

---

**Alessio Biancalana** (2025-09-24 09:24):
&gt; logged into Rancher using two different browsers and observed the same inconsistency
with the same user?

yeah @Frank van Lankvelt it looks like some caching thing or some state still not being populated

---

**Amol Kharche** (2025-09-24 09:28):
yes, with the same user.

---

**Frank van Lankvelt** (2025-09-24 09:29):
yeah let's do that.  Can you schedule one this morning (CEST)?

---

**Amol Kharche** (2025-09-24 09:29):
Sure, At what time ?

---

**Frank van Lankvelt** (2025-09-24 09:30):
me &amp; Alex are available now, through 11AM

---

**Amol Kharche** (2025-09-24 09:31):
Cool, Thanks

---

**Amol Kharche** (2025-09-24 09:33):
Sent invite, Thanks @Frank van Lankvelt @Alejandro Acevedo Osorio

---

**Javier Lagos** (2025-09-24 10:08):
Hello @Alejandro Acevedo Osorio. You were right. Customer has restarted sync pod and Vertex with id=28887470107634 does not exist is still present.

```suse-observability-sync-7f98c94d88-6v8kh                          1/1     Running   0               23m     10.3.1.214   aks-suseobs2-22999411-vmss000004   &lt;none&gt;           &lt;none&gt;```
```2025-09-24 07:30:58,825 WARN  com.stackstate.sync.syncservice.SyncServiceImpl - 'ProcessSyncBatch' split due to exception com.stackstate.sync.syncservice.exception.SyncAllowRetryException: java.util.NoSuchElementException: Vertex with id=28887470107634 does not exist. on {syncServiceWorkerComponentState-0}, batchDetails=HashMap(ComponentWorkerChange -&gt; 493)```

---

**Andrea Terzolo** (2025-09-24 10:12):
i can reproduce the issue! thank you for reporting, i will work on a fix

---

**Alejandro Acevedo Osorio** (2025-09-24 10:22):
Clear ... the issue is persistent on that specific database vertexId. I'm trying to get some instructions to  try to find out what kind of vertex is that one ... although they might be a little complex to execute

---

**Alejandro Acevedo Osorio** (2025-09-24 10:33):
It's something like:
• scaleup the  `suse-observability-hbase-console` to 1 replica
• get a shell into the `suse-observability-hbase-console-??????` pod
• run `stackgraph-console`
• wait until the console is completely loaded and run the command
```import org.apache.hadoop.hbase.client.*
import org.apache.hadoop.hbase.util.*
getRequest = new Get(Bytes.toBytes(28887470107634))
getRequest.setMaxVersions(1000)
graph.repository.tableProvider.vertexHTable.get(getRequest) ```
• collect the output
The whole issue occurs when the `sync` is trying to delete  the component  `58163659989376` so an idea as well is to navigate in the browser to the path `../#/components/58163659989376` to at least understand what element is the one tried to be deleted. And from there collect the whole `json` payload from the component which can be found on the `About` section under the `...` menu

---

**Amol Kharche** (2025-09-24 10:33):
&gt; 3. Check there are no errors in the metric processing (receiver, vmagent, victoria metrics specifically).
@Andrea Terzolo Do we need fresh logs from observability instance?

---

**Alejandro Acevedo Osorio** (2025-09-24 10:34):
The other option would be to setup a call with the customer, but I already have one lined up for this morning https://suse.slack.com/archives/C07CF9770R3/p1758699228040109?thread_ts=1758529684.094989&amp;cid=C07CF9770R3

---

**Andrea Terzolo** (2025-09-24 10:40):
you are right, we probably already have these logs since you posted all the logs in this thread, i believe Remco is in meetings almost all the day (maybe someone else with that knowledge can take a look into the logs we already have, but not sure who is the right guy for this task, i will try with a random ping @Alejandro Acevedo Osorio)

---

**Javier Lagos** (2025-09-24 10:41):
Amazing Alejandro! Thanks a lot. Lets try to follow the steps and in case we need to debug it further I can ask the customer to schedule a call for tomorrow if that's fine for you.

---

**Amol Kharche** (2025-09-24 10:41):
Yes, The logs already shared in thread here (https://suse.slack.com/archives/C07CF9770R3/p1758538552497499?thread_ts=1758538457.626149&amp;cid=C07CF9770R3)

---

**Alejandro Acevedo Osorio** (2025-09-24 10:43):
I added a couple of extra steps in my previous comment. Might be that we could arrange something for this afternoon. Let me check how the other call goes.

---

**Alejandro Acevedo Osorio** (2025-09-24 10:48):
@Andrea Terzolo Did a quick scan of the `receiver, vmagent, victoria-metrics` logs and nothing suggest there are issues with the metrics processing over there

---

**Andrea Terzolo** (2025-09-24 10:51):
thank you Alex! ok, so I would proceed just with point 1 and 2

---

**Javier Lagos** (2025-09-24 10:53):
Perfect. I will ask the customer for availability this afternoon or tomorrow morning then but waiting for your confirmation as well to confirm and schedule the call. Please let me know how the other call goes. Thanks!

---

**Javier Lagos** (2025-09-24 11:07):
He is mostly available until 4PM so please let me know if you are available to schedule a call with customer!

---

**Andrea Terzolo** (2025-09-24 11:32):
ticket for track this issue https://stackstate.atlassian.net/browse/STAC-23434

---

**Andrea Terzolo** (2025-09-24 11:32):
ticket to track this issue https://stackstate.atlassian.net/browse/STAC-23435

---

**Andrea Terzolo** (2025-09-24 11:50):
thank you! that's interesting the `container_check.json` seems empty! so the agent is not producing the metrics we need :thinking_face:
```=========
Collector
=========

  Running Checks
  ==============
    
    container
    ---------
      Instance ID: container [OK]
      Configuration Source: file:/etc/stackstate-agent/conf.d/container.d/conf.yaml.default
      Total Runs: 2
      Metric Samples: Last Run: 0, Total: 0
      Events: Last Run: 0, Total: 0
      Service Checks: Last Run: 0, Total: 0
      Average Execution Time : 38ms
      Last Execution Date : 2025-09-24 08:49:51 UTC (1758703791000)
      Last Successful Execution Date : 2025-09-24 08:49:51 UTC (1758703791000)
      

  Metadata
  ========
    config.hash: container
    config.provider: file```

---

**Andrea Terzolo** (2025-09-24 11:57):
@Louis Parkin have we ever seen something similar? No errors on the node-agent but the container check produces nothing

---

**Louis Parkin** (2025-09-24 12:08):
No, I haven’t seen this before.

---

**Chris Riley** (2025-09-24 12:28):
@Louis Lotter @Frank van Lankvelt ^^ appreciate your input here - thanks.

---

**Frank van Lankvelt** (2025-09-24 13:01):
I don't have access to SalesForce so am not able to see the case - could you share the content here?

---

**Chris Riley** (2025-09-24 13:02):
It's a continuation of ticket 1494 from Zendesk, assume you have access to that? The new case just has this:

_Please see case in old system: [StackState Ticket #1494]_

_But this was the original text:_

_Dear Reader,_

_We have an issue with the “Health Bar Timeline” for monitors._
_As you can see in the attached screenshots. When we move around on the “Health Timeline” on the bottom of the interface the “Monitor Health Bar” Is not completely updating._
_Only a small part of the data is shown. When you click to a different time only that part is shown and the data previously shown is gone again. Its inconsistent and unreliable._
_This is just an example of a component; we see this behaviour with all components and Monitor Health Bar’s._

_Can you investigate what is going wrong and how it can be solved?_

_Best Regards_
_Frank van de Pol_

---

**Alejandro Acevedo Osorio** (2025-09-24 13:04):
Javier, I can join Mitesh on a call at 2:00/3:00 pm whatever he prefers

---

**Remco Beckers** (2025-09-24 13:05):
I've had that 2 out of 3 times I ran the check manually. But in the agent  status I could see the check was producing metrics anyway

---

**Remco Beckers** (2025-09-24 13:05):
The 3rd time it worked fine for me

---

**Frank van Lankvelt** (2025-09-24 13:17):
TBH I cannot access that either.  But we have a JIRA ticket https://stackstate.atlassian.net/browse/STAC-23039 that seems to cover the remaining issue.
@Bram Schuur can you comment on prioritization?

---

**Frank van Lankvelt** (2025-09-24 13:18):
IIRC the health timeline on the bottom has been fixed, but for individual monitors the issue is still occurring.

---

**Frank van Lankvelt** (2025-09-24 13:20):
Back in july the underlying issue (health states disappearing &amp; reappearing) was identified to be splunk queries that sometimes only had partial results.
There was a setting that caused those partial results to be used and that resulted in all monitors that were not in the query result to be removed.  Only to reappear a small time later when the query did include them.

---

**Javier Lagos** (2025-09-24 13:20):
Let me ask the customer to see if he is able to join at 3PM

---

**Chris Riley** (2025-09-24 13:24):
Thanks, Frank. FYI - Louis provided this from the Zendesk ticket :point_down:

---

**Frank van Lankvelt** (2025-09-24 13:33):
ah, I now see there was a response that we missed.
The recommendation is to keep the setting for the ignore_saved_search_errors - so to NOT ignore the errors.  But that the problem persists indicates that we should pick up the JIRA.
I've looked at the issue in the past and found that the assumption that a health state doesn't pop in and out of existence is pretty deep.  So it will require some planning to address it.  But I certainly agree that this is incorrect behavior and must be fixed.

---

**Chris Riley** (2025-09-24 13:38):
^^ @Rodolfo de Almeida

Yeah, the missed response I believe was a reason why they ended up opening a Salesforce case for this. If you or @Bram Schuur can please keep us updated on this as it seems to be an important one for Rabobank and the CSM has already flagged this with us. It would be good if I can update the CSM with what the plans are to address it. We'll also need to keep the customer informed of progress/plans.

---

**Andrea Terzolo** (2025-09-24 13:44):
oh really? uhm ok, at this point we can try also with the status
```kubectl exec -n <namespace> <node-agent-pod> -- agent status > ~/status.json```

---

**Amol Kharche** (2025-09-24 14:06):
Shall I create ticket for this ?

---

**Frank van Lankvelt** (2025-09-24 14:19):
please do.  And if you can reliably reproduce it that would be even more awesome!

---

**Amol Kharche** (2025-09-24 14:31):
https://stackstate.atlassian.net/browse/STAC-23436

---

**Javier Lagos** (2025-09-24 14:32):
Customer has confirmed. I have just sent an invitation to you @Alejandro Acevedo Osorio and @Bram Schuur. Thanks.

---

**Remco Beckers** (2025-09-24 14:35):
I don't know why that was though, other checks didn't seem to have that issue.

---

**Amol Kharche** (2025-09-24 15:27):
I asked customer clear all browsing data in the settings and after that, the “Observed” status is displayed now.
This is only true for Admin users in Rancher.
If the user is a non-Admin, then they get the below and they cannot find a way to display the status: Is this expected ?

---

**Frank van Lankvelt** (2025-09-24 16:00):
I'm working on the non-admin access, see https://stackstate.atlassian.net/browse/STAC-23274

---

**Amol Kharche** (2025-09-24 16:06):
Oh , this is for same customer. _*Capricorn Group*_

---

**Giovanni Lo Vecchio** (2025-09-24 16:54):
Hey Team,
I have a problem with the customer Nationwide Mutual Insurance Company.

Essentially, they are attempting to configure email sending from SUSE Observability to their SMTP server, but are experiencing issues.

The first problem seemed to me to be the one described here:
https://suse.slack.com/archives/C079ANFDS2C/p1758636184815109?thread_ts=1741591011.510869&cid=C079ANFDS2C

The proposed solution, however, wasn’t enough to resolve the issue.

They had to add:
```stackstate:
  components:
    authorizationSync:
      envsFromExistingSecrets:
        - name: SMTP_PASSWORD
          secretName: suse-observability-email
          secretKey: SMTP_PASSWORD
        - name: SMTP_USER_NAME
          secretName: suse-observability-email
          secretKey: SMTP_USER_NAME ```
SUSE-OBSERVABILITY Helm Chart 2.5.0

Do you have any ideas what this might be?

---

**Andrea Terzolo** (2025-09-24 17:01):
i would say that the next steps here are:
1. Catch the output of this `kubectl exec -n &lt;namespace&gt; &lt;node-agent-pod&gt; -- agent status &gt; ~/status.json`
2. Enable debug logs for the node agent in the agent helm chart `--set-string 'nodeAgent.logLevel'='DEBUG'` 
If we don't find any clue with this, probably the unique left option is to build a custom node agent image with additional logs and try to understand what is going on. Unless we have other ideas

---

**Giovanni Lo Vecchio** (2025-09-24 17:05):
Fixed the content

---

**Saurabh Sadhale** (2025-09-24 17:06):
I am also facing a similar issue. I asked the customer to apply the yaml as described here

https://suse.slack.com/archives/C079ANFDS2C/p1741681943961849?thread_ts=1741591011.510869&channel=C079ANFDS2C&message_ts=1741681943.961849 (https://suse.slack.com/archives/C079ANFDS2C/p1741681943961849?thread_ts=1741591011.510869&channel=C079ANFDS2C&message_ts=1741681943.961849)


But it was not successful for the customer. They indicated that may be as it is not a complete reinstallation this could be the problem. In their case the secret gets updated but the pod does not restart. Even if they scale up and down it doesn't resolve the problem

---

**Giovanni Lo Vecchio** (2025-09-24 17:07):
Ciao Saurabh!
In my comment on the shared link, I had identified what the problem could be... However, it seems that it is also necessary to identify the parameters of the secret.

---

**Rodolfo de Almeida** (2025-09-24 18:45):
@Chris Riley, Thanks for the update. I've updated the case and let the customer know that we're currently working on the issue. Since it looks like a complex problem, it may take some time to investigate.

@Frank van Lankvelt and @Bram Schuur please keep us updated on your progress. If you need any more information from the customer, just let me know.

---

**IHAC** (2025-09-24 18:46):
@Garrick Tam has a question.

:customer:  Disney Cruise Line Technology

:facts-2: *Problem (symptom):*  
Customer upgraded to 2.5.0 but the server pod keeps restarting due to the following error.
```2025-09-24 14:34:03,740 ERROR com.stackvista.graph.transaction.StackTransactionManager - Got error on transaction StackTephraTransaction{ id: Optional[TransactionId(id=1758724443634000000)], name: StackStateGlobalActorSystem-akka.actor.default-dispatcher-5, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.empty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1758724443638, threadName=StackStateGlobalActorSystem-akka.actor.default-dispatcher-5, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional[Transaction{, transactionId: 1758724443634000000, invalids: [], inProgress: [], retentionEpochTx: 1756132393523000000, type: SHORT, visibilityLevel: SNAPSHOT}] }: Not all edges were removed for type: class com.stackstate.domain.layer.Layer, java.base/java.lang.Thread.getStackTrace(Thread.java:2451)
com.stackvista.graph.transaction.StackTransactionManager.runTx(StackTransactionManager.java:268)
com.stackvista.graph.transaction.StackTransactionManager.runReadOnly(StackTransactionManager.java:181)
com.stackvista.graph.stackobject.StackObject.readOnly(StackObject.java:167)
com.stackstate.migrations.MigrateDecoupleSettings$.validateNoEdges(MigrateDecoupleSettings.scala:291)
com.stackstate.migrations.MigrateDecoupleSettings$.run(MigrateDecoupleSettings.scala:39)
com.stackstate.migrations.MigrateDecoupleSettings$.run(MigrateDecoupleSettings.scala:20)
com.stackstate.domain.migration.Migration$.execute(Migration.scala:16)
com.stackstate.migrations.MigrationService.$anonfun$runMigrations$2(MigrationService.scala:73)
com.stackstate.migrations.MigrationService.$anonfun$runMigrations$2$adapted(MigrationService.scala:73)
scala.collection.immutable.List.foreach(List.scala:334)
com.stackstate.migrations.MigrationService.$anonfun$runMigrations$1(MigrationService.scala:73)
scala.concurrent.Future$.$anonfun$apply$1(Future.scala:687)
scala.concurrent.impl.Promise$Transformation.run(Promise.scala:467)
akka.dispatch.BatchingExecutor$AbstractBatch.processBatch(BatchingExecutor.scala:63)
akka.dispatch.BatchingExecutor$BlockableBatch.$anonfun$run$1(BatchingExecutor.scala:100)
scala.runtime.java8.JFunction0$mcV$sp.apply(JFunction0$mcV$sp.scala:18)
scala.concurrent.BlockContext$.withBlockContext(BlockContext.scala:94)
akka.dispatch.BatchingExecutor$BlockableBatch.run(BatchingExecutor.scala:100)
akka.dispatch.TaskInvocation.run(AbstractDispatcher.scala:49)
akka.dispatch.ForkJoinExecutorConfigurator$AkkaForkJoinTask.exec(ForkJoinExecutorConfigurator.scala:48)
java.base/java.util.concurrent.ForkJoinTask.doExec(ForkJoinTask.java:387)
java.base/java.util.concurrent.ForkJoinPool$WorkQueue.topLevelExec(ForkJoinPool.java:1312)
java.base/java.util.concurrent.ForkJoinPool.scan(ForkJoinPool.java:1843)
java.base/java.util.concurrent.ForkJoinPool.runWorker(ForkJoinPool.java:1808)
java.base/java.util.concurrent.ForkJoinWorkerThread.run(ForkJoinWorkerThread.java:188)```
Can I get help to determine why and how to help the custoomer recover?

---

**Garrick Tam** (2025-09-24 18:46):
Attached is the log bundle.

---

**Garrick Tam** (2025-09-24 18:52):
Customer indicated they upgraded from v2.3.6.

---

**David Noland** (2025-09-24 19:10):
Thanks for having a look. Saw we have a PR too, which is great. Once we have a new agent release, I can roll it out to our hosted customers.

---

**David Noland** (2025-09-24 20:41):
In metrics explorer, sorting values seems to do an alpha sort and not a numeric sort. Can this be fixed:

---

**Bram Schuur** (2025-09-24 20:57):
Thanks for picking this up @Andrea Terzolo

---

**David Noland** (2025-09-24 20:59):
JFYI - graph of open file descriptors for our environments

---

**Bram Schuur** (2025-09-24 21:03):
Approved your mr

---

**Bram Schuur** (2025-09-24 21:08):
Thanks for reporting, I filed the following ticket: https://stackstate.atlassian.net/browse/STAC-23437 (https://stackstate.atlassian.net/browse/STAC-23437)

---

**Bram Schuur** (2025-09-24 21:16):
@Rodolfo de Almeida I filed a placeholder ticket and put it up for backlog prioritization. I'll keep you posted. https://stackstate.atlassian.net/browse/STAC-23438 (https://stackstate.atlassian.net/browse/STAC-23438)

---

**Bram Schuur** (2025-09-24 21:16):
Meeting is tomorrow

---

**Rodolfo de Almeida** (2025-09-24 21:17):
Thanks a lot @Bram Schuur

---

**Andrea Terzolo** (2025-09-25 08:09):
merged :slightly_smiling_face:

---

**Daniel Murga** (2025-09-25 08:37):
Hey @Frank van Lankvelt the Jira is status = "resolved"...  How can I track when the fix will be included so I can communicate to customer accordingly? thanks a lot

---

**Remco Beckers** (2025-09-25 08:40):
Sounds like a good approach. Ideally, if the container check is producing metrics according to the status output we try to capture them by running the container check manually several times until it has actually produced the results (I still don't get why the manual run does not always give results)

---

**Bram Schuur** (2025-09-25 08:43):
I brought up https://stackstate.atlassian.net/browse/STAC-23039 for the prioritization meeting this afternoon. I do not have an account on scc but will give an update here.

---

**Chris Riley** (2025-09-25 09:50):
Thanks @Bram Schuur. Please keep us posted ... @Rodolfo de Almeida can help with communication to the customer.

---

**Frank van Lankvelt** (2025-09-25 10:04):
In the release notes there will be a mentioning of the version bump.  Don't know if we make the list of Jira tickets available explicitly, maybe @Daniel Barra knows?

---

**Bram Schuur** (2025-09-25 10:22):
Unfortunately this customer triggered a data consistency issue which we observed and will be fixed in  an upcoming release: https://stackstate.atlassian.net/browse/STAC-23312. Even with that release, the current system is corrupted so we advise restoring a backup (or configuration backup) https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_rest[…]ackup (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_restore_a_backup). If not backup is present, the system can be reinstalled.

---

**Saurabh Sadhale** (2025-09-25 11:18):
@Giovanni Lo Vecchio i just finished up a call with a customer where I was facing this issue.

We configured the following and it has worked for me. We also tested the email configuration and the customer received an email as well.

```stackstate:
  components:
    authorizationSync:
      envsFromExistingSecrets:
        - name: SMTP_PASSWORD
          secretName: suse-observability-email
          secretKey: SMTP_PASSWORD
        - name: SMTP_USER_NAME
          secretName: suse-observability-email
          secretKey: SMTP_USER_NAME
  email:
    enabled: true
    server:
      host: "stackstate.rancher.com (http://stackstate.rancher.com)"
      port: 25
      protocol: smtp
      auth:
        username: "null"
        password: "null"```

---

**Giovanni Lo Vecchio** (2025-09-25 11:22):
Hey @Saurabh Sadhale! Thanks a lot for the suggestion!
The point is that they’ve now managed to get the configuration itself working, but they’re getting errors when sending emails.
I’ve asked them to run two reachability tests from the worker nodes in the meantime.

```nc -v -w1 mail-gw.ent.nwie.net (http://mail-gw.ent.nwie.net) 25
OR
telnet mail-gw.ent.nwie.net (http://mail-gw.ent.nwie.net) 25```

---

**Javier Lagos** (2025-09-25 11:40):
Hello @Alejandro Acevedo Osorio and @Bram Schuur. It looks like that the customer is now facing the issue on PROD. I have asked him to upload the logs so we can confirm that the same issue is happening on their environment.

Customer's update.

```I just wanted to add that this morning we are noticing similar behavior on our PROD environment, sync pod has restarted 3 times.

however; having seen the above, at this moment the sync pod does seem to have recovered, but we are unable to see or the topology view, it does not load for our business chains.```

---

**Javier Lagos** (2025-09-25 11:57):
Will you be available to jump into a call? Customer wants to increase severity to 2 and I think that the best way to proceed is to schedule a call with customer. Let me know your thoughts.
Thanks.

---

**Javier Lagos** (2025-09-25 11:59):
Latest information provided by customer. It sounds like a similar issue than on dev then

```Just to add, This morning there was a AKS node image update on our PRD Cluster, and on Tuesday we have node image updated on the PA cluster. the 16th was also Tuesday which when we started seeing issues on PA - this all seems very similar again to the issue we had prior to the node affinity settings but just wanted to let you know.```

---

**Javier Lagos** (2025-09-25 12:00):
Edit: It was not a node image update. It was an AKS update 1.32.7 where new nodes have been provisioned

---

**Alejandro Acevedo Osorio** (2025-09-25 12:09):
I just quickly scanned the logs and I see some `ConlictExceptions` and some transient
```2025-09-25 07:23:20,962 WARN  org.apache.kafka.clients.NetworkClient - [Consumer clientId=kafka-sts_topo_manual-itsm_http___manual-itsm-plugin-2bf0be42-0ec4-437e-bae6-4f2725aea320, groupId=unknown-client-22c5e62d-2597-43d0-a649-2d4fdd035fb1] Error connecting to node suse-observability-kafka-0.suse-observability-kafka-headless.suse-observability.svc.cluster.local:9092 (id: 0 rack: null)```
issues connecting to Kafka but don't see any signs of a similar issue as the one we were/are investigating (data corruption)

---

**Javier Lagos** (2025-09-25 12:10):
That's exactly what I was starting to think while reviewing the logs. It looks like that this is a different issue. Let me create a new case for them to continue working on that to separate the topics

---

**Alejandro Acevedo Osorio** (2025-09-25 12:13):
Ohhh wait ... I see some issues on the api pod
```java.lang.IllegalStateException: Cannot un-exist verified existing stackelement: v[266238001893798],{}, loaded=VERIFIED, existing=true, verifiedAtTxId=1758784997944000001, lastUpdateTransactionId=null, label=OneWayRelation, edgesIn={}, edgesOut={}, loadTransactionId=1758791310000999999```

---

**Javier Lagos** (2025-09-25 12:14):
I will ask the customer for his availability so we can discuss it there the origin of the issue

---

**Javier Lagos** (2025-09-25 12:14):
IF you are available as well

---

**Daniel Barra** (2025-09-25 12:15):
Yes, the https://stackstate.atlassian.net/browse/STAC-23279 has a release note, so that will appears on release notes, I'm working on it, soon I open the MR I share with you! :slightly_smiling_face:

---

**Chris Riley** (2025-09-25 12:28):
@Frank van Lankvelt I see that we have 'fix versions' and 'affects versions' on the right-hand side in the Jira.

I'm assuming (please correct me if I'm wrong here), that 'fix versions' means - this is the version of Observability where the fix will be included. If so, can we start using this field as it will help support to understand what the plans are, and we can then communicate this to the customer. This, I think, is what Daniel is asking for.

---

**Daniel Barra** (2025-09-25 13:30):
When we make the release, that fix version will be fulfill

---

**Hugo de Vries** (2025-09-25 14:10):
Is it possible to use Rancher based RBAC on Suse observability with both SSO and local Rancher users at the same time? MoD is testing this now, since acquiring test accounts for SSO takes a few months. SSO works fine, logging in with a local users gives an empty UI so no permissions. Is there a way to map roles in Suse Observability to local Rancher accounts?

---

**Bram Schuur** (2025-09-25 14:15):
@Alejandro Acevedo Osorio @Frank van Lankvelt please correct me if i am wrong here, but i think this is the case:
• We use rancher as auth provider, so we intend that both local rancher users and rancher SSO users can be used in the rbac system
• It should be possible to add the role templates to rancher local users and have the whole thing work
• IIRC local rancher user do not support groups, so being able to assign templates to entire groups of local users is not an option
This is in theory as i recall it. The feature is fresh, so it could be there is something askew or an oversight there somehow that affects you in the setup you are doing

---

**Alejandro Acevedo Osorio** (2025-09-25 14:26):
Exactly, you can add for a particular cluster or project memberships. So for example in the screenshot I'm adding cluster membership of the test user (local rancher user)

---

**Alejandro Acevedo Osorio** (2025-09-25 14:26):
`SUSE Observability Cluster Observer` is the ClusterRoleTemplate that defines the `Cluster Observer` permissions

---

**Chris Riley** (2025-09-25 14:33):
@Daniel Barra understood, but that is after the event. What we (support) are looking for, is to have some understanding of which version will have the fix - ahead of time (so that we can keep customers informed). Do you think that this is possible?

---

**Hugo de Vries** (2025-09-25 14:42):
Okay sounds good, thanks gents! I've shared the info with the MoD team.

---

**Daniel Murga** (2025-09-25 14:43):
Thanks @Chris Riley! Mainly... the most information we've got... the better we can manage customer expectations

---

**Javier Lagos** (2025-09-25 15:06):
Hey team. Unfortunately the restore didn't work. I'm going to create another call. Are you guys available to join? @Alejandro Acevedo Osorio @Bram Schuur

---

**Javier Lagos** (2025-09-25 15:06):
Let me share the details

---

**Javier Lagos** (2025-09-25 15:06):
Thanks a lot

---

**Javier Lagos** (2025-09-25 15:07):
https://meet.google.com/rvi-ogfz-ado

---

**Daniel Barra** (2025-09-25 15:21):
We always take priority to solve bugs, so the tech leads, will make that bug fixed faster as possible, but only him can tell you about when that will be done, because depends on the complexity of it.
From my side, we do a release at least once peer month, but is that also flexible, we can start it  any time as required.
what I can do, soon we have plan to make the release, to send msg to support channel talking about our process, and usually the Jira card has all related tickets on it.. if that can help I can share that with you, but important the date we put on card is a goal, some cases we found issues/changes and we can delay it couple days.
@Louis Lotter, @Bram Schuur, @Remco Beckers is that OK to share on channel about our plans/dates for releases?

---

**Bram Schuur** (2025-09-25 15:22):
@Daniel Barra yeah that is perfect, feel free to add a step to the release procedure to give that outlook once we freeze the version

---

**Louis Lotter** (2025-09-25 15:25):
@Daniel Barra yeah this is the best we can do at the moment. @Chris Riley if you want to discuss this further we can set up a meeting sometime.

---

**Chris Riley** (2025-09-25 15:27):
That would be helpful, thanks guys. And yes, support never commit to anything when communicating to customers about fixes etc ('subject to change' is something we mention a lot).

---

**Louis Lotter** (2025-09-25 15:30):
I set up a meeting for tomorrow. Let me know if anyone else should be in it.

---

**Chris Riley** (2025-09-25 15:31):
@Daniel Murga want to join the call tomorrow morning?

---

**Daniel Murga** (2025-09-25 17:15):
sure! I just accepted.

---

**Garrick Tam** (2025-09-25 17:20):
Thank you for the confirmation.

---

**Bram Schuur** (2025-09-25 17:24):
This ticket is being brought up for refinement, it will depend on the sizing during refinement how quick we can pick this up and how fats the fix will arrive.

---

**Chris Riley** (2025-09-25 18:09):
Appreciate the update, Bram.

---

**Rodolfo de Almeida** (2025-09-25 18:13):
Thank you Bram!

---

**Andrea Terzolo** (2025-09-26 09:34):
thank you for the logs! so now it's clear that the container check is not producing metrics and i found the debug log i was looking for
```2025-09-25 08:42:34 UTC | CORE | DEBUG | (pkg/collector/corechecks/containers/generic/processor.go:94 in Run) | Container stats for: &amp;{{container f9d2ad25243cae0eccd8caec3c508d5e736a3052e7afceb2d4c6bfdb40bca9fe} {server  map[] map[io.kubernetes.pod.namespace:argocd]} map[]  {dcmp-1000-harbor.dictu.intern/quay_io/argoproj/argocd@sha256:8c2303d097da9ff265f46c00b53507212c341b1c97517faede3f1d9e12156432 dcmp-1000-harbor.dictu.intern/quay_io/argoproj/argocd:v3.1.5 dcmp-1000-harbor.dictu.intern/quay_io/argoproj/argocd dcmp-1000-harbor.dictu.intern argocd v3.1.5} map[] 0 [{server 8080 TCP} {metrics 8083 TCP}] containerd  {true running  2025-09-16 07:38:55 +0000 UTC 2025-09-16 07:38:55 +0000 UTC 0001-01-01 00:00:00 +0000 UTC &lt;nil&gt;} [] 0xc000926a20 0xc000f87ec0 {0xc000fddd10 0xc000fddd20}} not available, err: containerdID not found and unable to refresh cgroups, err: open /host/sys/fs/cgroup/ensl_tp_ods: permission denied```
this is in the path of the metrics collection https://github.com/DataDog/datadog-agent/blob/25b3df4250ccf281fd3fce3c1bfb28b6d8912898/pkg/collector/corechecks/containers/generic/processor.go#L100. Now i need to understand if it is the cause and why it is happening

---

**Remco Beckers** (2025-09-26 09:44):
Nice. Progress!

---

**Javier Lagos** (2025-09-26 09:55):
Hello @Alejandro Acevedo Osorio! Customer was expecting to have the new release version published on the current week. Do we know when are we going to have the new version released so they can upgrade to prevent this `Multiple edges can not be placed on a optional property` issue to happen again?

Thanks!!

---

**Alejandro Acevedo Osorio** (2025-09-26 09:56):
The release process is currently in progress, most probably could be Monday or Tuesday.. @Daniel Barra do you have an estimate for @Javier Lagos?

---

**Hugo de Vries** (2025-09-26 11:24):
They are not able to find this ClusterRoleTemplate in their instance. How do we ship this? They are running Rancher 2.12.1 and Observability 2.5.0

---

**Alejandro Acevedo Osorio** (2025-09-26 11:26):
The role templates are bundled with the `UI Extension` , that's how we distribute them

---

**Hugo de Vries** (2025-09-26 11:28):
Ah yes, on that topic. They can only find UI Extension 2.2.2 in the catalog, but this needs 2.2.3 I believe?

---

**Alejandro Acevedo Osorio** (2025-09-26 11:28):
Mmmmmm might be that from this page is not completely clear that the UI Extension must be installed https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_rancher.html#_observer_role @Frank van Lankvelt do we have in some other page the requirement about the extension being installed?

---

**Frank van Lankvelt** (2025-09-26 11:32):
I don't think so.  But even if we do, it would be good to include that on the Rancher RBAC page

---

**Alejandro Acevedo Osorio** (2025-09-26 11:34):
Can you help @Hugo de Vries https://suse.slack.com/archives/C07CF9770R3/p1758878894865419?thread_ts=1758802207.776869&amp;cid=C07CF9770R3 with the right version of the extension they need?

---

**Frank van Lankvelt** (2025-09-26 11:44):
the extension/plugin is available in the https://github.com/rancher/ui-plugin-charts repository (main branch) that comes with Rancher by default.

---

**Frank van Lankvelt** (2025-09-26 11:45):
I don't know how this works in an airgapped environment though - they probably need to update their own catalog first?

---

**Hugo de Vries** (2025-09-26 11:54):
That make a lot of sense, thanks gents! I also see the templates in 2.2.2 but yeah pretty sure they need to update their mirror / local repo because it's an airgapped deployment indeed.

---

**Frank van Lankvelt** (2025-09-26 11:56):
probably good to do that.  The 2.2.2 had a bug on clean install

---

**Daniel Barra** (2025-09-26 12:16):
It's ongoing, Monday is the plan! :slightly_smiling_face:

---

**Javier Lagos** (2025-09-26 12:19):
Thanks a lot @Daniel Barra. However, I think that I will say next week to the customer so we can be flexible in case of any problem.

---

**Andrea Terzolo** (2025-09-26 15:40):
before collecting the outputs let the agent run for at least 4/5 min

---

**Bruno Bernardi** (2025-09-26 19:21):
Hi Team,

I'll add our colleagues that will be on call over the weekend to this thread so we can follow up here if needed.

Thanks!

cc @Ankush Mistry @Daniel Murga @Rajesh Kumar @Rodolfo de Almeida

---

**Bruno Bernardi** (2025-09-26 19:57):
The customer mentioned that they have a standard retention period of 30 days.

I've had no lab experience restoring StackGraph backups, but should they retrieve all of this 30-day topologies data? Maybe a different StackGraph backup could have this data before September 17th, in case some data is corrupted? (I really apologize if I have missed any data or information from the history.)

The list of the available StackGraph backups:
```=== Listing StackGraph backups in bucket "sts-stackgraph-backup"...
sts-backup-20250828-0300.graph
sts-backup-20250829-0300.graph
sts-backup-20250830-0300.graph
sts-backup-20250831-0300.graph
sts-backup-20250901-0300.graph
sts-backup-20250903-0300.graph
sts-backup-20250904-0300.graph
sts-backup-20250905-0300.graph
sts-backup-20250906-0300.graph
sts-backup-20250907-0300.graph
sts-backup-20250908-0300.graph
sts-backup-20250909-0301.graph
sts-backup-20250910-0300.graph
sts-backup-20250911-0300.graph
sts-backup-20250912-0300.graph
sts-backup-20250913-0300.graph
sts-backup-20250914-0300.graph
sts-backup-20250915-0300.graph
sts-backup-20250916-0300.graph
sts-backup-20250917-0300.graph
sts-backup-20250918-0300.graph
sts-backup-20250919-0304.graph
sts-backup-20250920-0300.graph
sts-backup-20250921-0300.graph
sts-backup-20250922-0300.graph
sts-backup-20250923-0300.graph
sts-backup-20250924-0300.graph
sts-backup-20250925-0300.graph
sts-backup-20250926-0300.graph```

---

**Bruno Bernardi** (2025-09-26 21:47):
I reviewed the logs the customer sent and the previous information you discussed in this case. Besides the error Javier sent earlier, I'm only seeing this error in the sync pods, but I think is benign:
```2025-09-26 15:21:23,943 INFO  c.stackstate.stackgraph.StackGraphStackObjectImplementation - Rolling back transaction. Cause: com.stackvista.graph.transaction.StackTransactionConflictException: Conflict detected while committing Component,ExtCheckState,ExtHealthPartition,ExtHealthSubStream,HAS_SYNCED_CHECK_STATE,HealthSyncSubStream,IN_HEALTH_SUBSTREAM,IN_HEALTH_SUB_STREAM,SyncedCheckState. { table = edge, conflicting id = 275490610353312, conflicting label = edge not found in transaction cache, conflicting client = SyncServiceWorker.ProcessSyncComponentBatch, changes = DeleteEdge{elementId=275490610353312} } StackTephraTransaction{ id: Optional[TransactionId(id=1758900083298000000)], name: HealthSynchronization.FlushPartition, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.empty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1758900083326, threadName=StackStateGlobalActorSystem-stackstate.dispatchers.stackgraphWrapper-223237, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional.empty } Root cause: Conflict detected while committing Component,ExtCheckState,ExtHealthPartition,ExtHealthSubStream,HAS_SYNCED_CHECK_STATE,HealthSyncSubStream,IN_HEALTH_SUBSTREAM,IN_HEALTH_SUB_STREAM,SyncedCheckState. { table = edge, conflicting id = 275490610353312, conflicting label = edge not found in transaction cache, conflicting client = SyncServiceWorker.ProcessSyncComponentBatch, changes = DeleteEdge{elementId=275490610353312} } StackTephraTransaction{ id: Optional[TransactionId(id=1758900083298000000)], name: HealthSynchronization.FlushPartition, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.empty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1758900083326, threadName=StackStateGlobalActorSystem-stackstate.dispatchers.stackgraphWrapper-223237, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional.empty }
2025-09-26 15:21:23,943 INFO  com.stackstate.health.HealthSyncFlowState$ - HealthSyncFlowState got a conflict while processing (-1 attempts left): Conflict detected while committing Component,ExtCheckState,ExtHealthPartition,ExtHealthSubStream,HAS_SYNCED_CHECK_STATE,HealthSyncSubStream,IN_HEALTH_SUBSTREAM,IN_HEALTH_SUB_STREAM,SyncedCheckState. { table = edge, conflicting id = 275490610353312, conflicting label = edge not found in transaction cache, conflicting client = SyncServiceWorker.ProcessSyncComponentBatch, changes = DeleteEdge{elementId=275490610353312} } StackTephraTransaction{ id: Optional[TransactionId(id=1758900083298000000)], name: HealthSynchronization.FlushPartition, state: OPEN, vertexTableState: ObservableSlice: Optional.empty, edgeTableState: ObservableSlice: Optional.empty, auditLog: [StackTephraTransaction.AuditRecord(timestamp=1758900083326, threadName=StackStateGlobalActorSystem-stackstate.dispatchers.stackgraphWrapper-223237, fromState=INITIALIZED, toState=OPEN)], onReadWriteBehaviour: MANUAL, onCloseBehaviour: COMMIT, tephra-tx: Optional.empty }```

---

**Ankush Mistry** (2025-09-27 09:37):
The customer says he has checked the indiviudally for the spanned days and has also attached some files,
```- name: BACKUP_STACKGRAPH_SCHEDULED_BACKUP_RETENTION_TIME_DELTA
                  value: 30 days ago ```
There are events for the previous days but selecting a particular date gives error “Something went wrong”

---

**Bram Schuur** (2025-09-27 09:44):
Writing from my phone due to afk, the backup retention is different than the data retention configuration, see https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/data_retention.html (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/data_retention.html) topology can have a different retention period than logs. Default is 7 days I think

---

**Daniel Murga** (2025-09-27 13:58):
Hi I will follow up the case... Ankush requested the following information:
_"Hi Mitesh,_
 
_As the backup retention differs from data retention configuration, Can you please check the data retention value set during the installation as topology can have a different retention period than logs and default is 7 days as per the documentation (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/data_retention.html)?_
 
_Do let us know if you have any more concerns."_

Customer just answered the following:
_"I checked the default values file for version 2.3.7, and 2.5.0 - the setting for topology retention is undefined:_

 _topology:_
  _# stackstate.topology.retentionHours -- (integer) Number of hours topology will be retained._
  _retentionHours:_

_so where can I see this to confirm what our actual retention is ?"_

Attaching YAML file provided.

---

**Daniel Murga** (2025-09-27 17:38):
Maybe I'm missing something but I can see in the documentation that topology graph data retention is `By default, topology graph data will be retained for 30 days.`

---

**Daniel Murga** (2025-09-27 17:49):
but I can find this in the tephra logs --&gt; ./pods/suse-observability-hbase-tephra-0/tephra.log
```2025-09-25 13:29:24,713 [RetentionService STARTING] INFO  co.cask.tephra.hbase25.retention.RetentionService - Initialized retention window to default of 691200seconds.```
691200seconds = 8 days
Maybe that explains why they can't see data older than this...

---

**Daniel Murga** (2025-09-27 17:57):
If there's someone available to double-check this hypothesis would be appreciated, if that's true... we need to communicate to customer that data is not there because this default setting and teach them how to change this value based on their needs

---

**Bram Schuur** (2025-09-27 21:07):
I took a look, you are on it @Daniel Murga. The default should indeed be 30 days i now see, however, it seems to have defaulted to an 8 day now instead. The situation is a little tricky, I'll try to detail the steps that is think lead to this (TLDR i think its a bug):
*Possible reconstruction of problem*
• [13:28] SUSE Observability gets a fresh install at rabo after incident
• [13:29] Tephra initializing the retention based on this setting during first startup:
    ◦ https://gitlab.com/stackvista/stackgraph/-/blob/master/server-docker-images-2.5/shared/config/tephra-core.xml#L77
    ◦ Leading to 
```2025-09-25 13:29:24,713 [RetentionService STARTING] INFO  co.cask.tephra.hbase25.retention.RetentionService - Initialized retention window to default of 691200seconds.```
• This causes the retention epoch (data horizon) to be 8 days form the start
• [13:??] The main service starts, setting the retention window to 30 days through:
    ◦ default config: https://gitlab.com/stackvista/stackstate/-/blob/master/stackstate-configuration/src/main/resources/application.conf#L1461
    ◦ routine: https://gitlab.com/stackvista/stackstate/-/blob/master/stackstate-core-domain/src/main/scala/com/stackstate/domain/StackGraphContext.scala#L205
    ◦ The logs for this are not there, due the system having scaled down and up for the restore (this is an assumption of mine, can't verify without the logs, see for verification below)
    ◦ Changing the window will not change the epoch (the apoch can only be shortened, so stays at 8 days).
• [13:??]-[14:50] A restore operation is ran by customer. I checked the code there, the retention window is not restored from the backup (it is not stored in the backup), so the system keeps running with the initial value.
• Resulting state:
    ◦ A restored database with the data epoch (horizon) 8 days ago, but the window at 30 days.
*Verify current retention window and epoch on the deployment*
• Scale up the `hbase-console` deployment
• Shell into the hbase`-console` pod
• Execute the `stackgraph-console` on the shell
• Execute `retention.getWindow()` for the window, `retention.getCurrentEpoch()` for the epoch
*Possible options*
• To get 30 days data back in this stage, i only see one option, which is to rerun the restore, while adding an additional helm config: `--set-string hbase.tephra.extraEnv.open.HBASE_CONF_data_tx_retention_default_window="2592000000"` which will make sure the default is set to 30 days immediately. I would *not* recommend this necessarily though, because they will lose a lot of recent data when restoring a backup, which is i think more valuable than old data.
• Leave the system as is. The history should build up as time passes (keeping 17th sept as the epoch), until the 17th of okt when the window will start moving again.
I filed a bugticket with critical priority: https://stackstate.atlassian.net/browse/STAC-23459

---

**Daniel Murga** (2025-09-27 21:17):
Thanks for taking a look @Bram Schuur!

---

**Rodolfo de Almeida** (2025-09-27 21:18):
@Daniel Murga do we have access the gitlab link shared by Bram?

---

**Daniel Murga** (2025-09-27 21:22):
I can't access

---

**Rodolfo de Almeida** (2025-09-27 21:23):
thanks for confirming

---

**Rodolfo de Almeida** (2025-09-27 21:23):
I am summarizing it to send an update to the customer

---

**Javier Lagos** (2025-09-29 08:38):
Hey @Bram Schuur, Thanks for your analysis during the weekend.

Is it possible to change the current behavior to start storing 30 days of data again without losing the current data? I mean, is it possible to re-run the helm command by adding the parameter --set-string hbase.tephra.extraEnv.open.HBASE_CONF_data_tx_retention_default_window="2592000000" so that we can have 30 days of topology eventually without losing the actual data?

---

**Bram Schuur** (2025-09-29 08:47):
thank you for helping the customer with this:+1:

es, for sure adding that parameter now will make sure that during a possible system restore in the future we will stay on 30 days retention (we will also make a bugfix, which should make the setting obsolete). To be clear: currently there is already 30 days retention, save for the fluke that happened during the restore procedure.

---

**Javier Lagos** (2025-09-29 08:50):
Ok! Got it then. Thanks Bram

---

**Bram Schuur** (2025-09-29 08:53):
One correction:
• it should be `--set-string hbase.tephra.extraEnv.open.HBASE_CONF_data_tx_retention_default_window="2592000"` (seconds instead of millis)

---

**Giovanni Lo Vecchio** (2025-09-29 09:27):
FYI - The problem was on the SMTP server side; they fixed it on the customer side.

Thanks everyone for the brainstorming.

---

**Javier Lagos** (2025-09-29 09:39):
Hey @Bram Schuur @Alejandro Acevedo Osorio.Are you guys available today for a 30 minutes call? Customer wants to discuss about this topic and agree on next steps. Please let me know your availability so I can schedule the call.

---

**Bram Schuur** (2025-09-29 10:01):
I am available any moment today

---

**Marc Rua Herrera** (2025-09-29 10:01):
Hi @Amol Kharche, is this fixed in capricorn?

---

**Amol Kharche** (2025-09-29 10:04):
Yes , Its fixed, Now they have different issue here  (https://suse.slack.com/archives/C07CF9770R3/p1758693561444359)

---

**Amol Kharche** (2025-09-29 10:05):
I think this will be fixed in new extension release as well

---

**Marc Rua Herrera** (2025-09-29 10:05):
ah yes, this is a known bug

---

**Javier Lagos** (2025-09-29 10:39):
Invitation sent. Thanks a lot guys

---

**Amol Kharche** (2025-09-29 11:44):
I got the response from customer and here is some of the interesting things customer found.
```Hi Amol,

Thanks for investigating, we are right now collecting logs in the way you suggested. What is already interesting is the following:
Some daemonsets over all clusters are not showing metrics, for example the daemonset pushprox-kube-etcd-client is not showing metrics on any of the clusters. While for example pushprox-kube-proxy-client is showing CPU usage (but not RAM usage) on all the clusters.
pushprox-kube-proxy-client is visible in the logs of the process-agent, while the pushprox-kube-etcd-client is not.
Now this is also true for some deployments, where the same deployment over multiple clusters don't show any metrics and other deployments show everything.

It looks a lot better with hardening enabled here are the logs.

cat /proc/mounts | grep cgroup 
cgroup2 /sys/fs/cgroup cgroup2 rw,seclabel,nosuid,nodev,noexec,relatime 0 0
none /run/cilium/cgroupv2 cgroup2 rw,seclabel,relatime 0 0

Point 5 returns nothing```

---

**Andrea Terzolo** (2025-09-29 11:50):
ok thank you for the feedback! So if i understand it well, now with hardening enabled they see some metrics but only for some deployment/daemonset and not for others

---

**Andrea Terzolo** (2025-09-29 15:04):
Ok what i would do now is to get the name of one of the pods for which they don't see metrics
• look into the metrics explorer in the UI `container_cpu_usage{pod_name="&lt;replace-with-pod-name&gt;"}` and see if there is something here
• enter the node-agent on the node where the above pod is deployed and get the output of `kubectl exec -n &lt;namespace&gt; &lt;node-agent&gt; -- agent check container --check-rate &gt; ~/container_check.json`. if the `container_check.json` file is empty, try again.

---

**Andrea Terzolo** (2025-09-29 15:14):
and
• take the name of the pods running on that node with this command `kubectl get pods -A --field-selector spec.nodeName=<node-name> -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[0].containerID}{"\n"}{end}'`

---

**Andrea Terzolo** (2025-09-29 15:35):
Please double check that these pod are really alive in the cluster, it seems that the UI sometimes represents some terminated pods as Running

---

**Daniel Barra** (2025-09-29 16:44):
*We are pleased to announce the release of 2.6.0, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.0.html).*

---

**Amol Kharche** (2025-09-30 11:12):
Waiting for customer response.

---

**Amol Kharche** (2025-09-30 11:14):
The issue was with the calico network and that was fixed and stable now. Customer asked to closed case. Thank you All

---

**Amol Kharche** (2025-09-30 13:37):
Got the response from customer.
```Hello Amol,

We realised that the pods we couldn't see the metrics of are running on the control planes, which of course makes sense. I think the hardening option fixed the issues we experienced with the worker nodes. 
Is it advisable to also run the node agent on control planes using an annotation(Instead of annotations I meant labels and taints.)? Because we would like to also receive the metrics of them. 
Thanks!```

---

**Andrea Terzolo** (2025-09-30 13:48):
oh this explains a lot! Yes if they want metrics for all the pods on all the nodes the only way is to install the agent on each node, so yes using tolerations seems correct!

---

**Jeroen van Erp** (2025-09-30 15:06):
https://rancher-users.slack.com/archives/C07HH46ALBD/p1757631479299749 @Mark Bakker Could you respond to this?

---

**Rajesh Kumar** (2025-09-30 17:11):
Hi Team
We have received a question from Capricorn group. So they have an application that logs out 'error' text but that's normal for it. Attached is the sample log. As per them Observability is looking at these 'error' text and putting the cluster under CRITICAL with a high error log count because, unfortunately these messages occur very frequently.Is (http://frequently.Is) there a way to reduce these noises?

---

**Alessio Biancalana** (2025-09-30 17:21):
is this application developed and maintained in-house? Do they have access to the code?

---

**Rajesh Kumar** (2025-09-30 17:22):
Thank you for answering @Alessio Biancalana. The monitoring team won't have. They are checking if anything can be done from our side. What are you looking for?

---

**Rajesh Kumar** (2025-09-30 17:23):
As per them the observability is not 'context' aware as it is just looking at the error text instead of checking the overall health of pods and cluster

---

**Alessio Biancalana** (2025-09-30 17:23):
I was trying to advice for the development team of this application to stop logging evidently non-error messages as error messages, since observability tooling is usually meant not to alter this kind of reporting

---

**Alessio Biancalana** (2025-09-30 17:24):
&gt; not 'context' aware
the lines they see come from STDERR, so they are accounted as errors

---

**Rajesh Kumar** (2025-09-30 17:24):
I told them this "SUSE Observability is context-aware, but the word 'error' is something that cannot be ignored.". But checking if there is any way to reduce the noise

---

**Alessio Biancalana** (2025-09-30 17:27):
I'll discuss that with the team and let you know, I don't think there's something  they can do on the product side but maybe I miss something

---

**Rajesh Kumar** (2025-09-30 17:28):
Yeah.. Please let me know if you find anything.

---

**Bruno Bernardi** (2025-09-30 18:06):
Hi Team,

I've some feedback from the customer *Tietoevry Tech Services Finland* related to RBAC via Rancher OIDC (https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-admin/users/authn-and-authz/configure-oidc-provider.html). I'll describe it below, and appreciate it if you could look it over.

The use case:
```Keycloak is an auth provider for Rancher, and then Rancher is configured to be an auth provider for SUSE Observability. Then, we assign a role "SUSE Observability Instance Recommended Access" to a group under one project. We expect users from that group to be able to see logs/metrics in Suse observability for their namespaces.

But when users try to log in, the portal is loaded, but the information keeps loading. We know the user is logged in, as there is a "logout" option, which means OIDC works, but the user can't see anything.```
How we fixed:
```The customer has been trying to use an Instance role on a project they want monitored rather than Observer. We configured the Observed referenced in this documentation, which gives "Read-only access to project data."

Referenced: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_rancher.html ```
The post feedback from the customer related to this Feature:
```1. Expect a similar role to that which allows creating dashboards and even notifications. It's unrealistic for an admin to create those for all teams in the company - or even external customers.

2. We understand that documentation is new and lacking since it's a new feature, but I'd like some explanation of a statement from the docs:

"To use these observer roles, it is recommended that the following role be granted on the Project running SUSE Observability itself: * Recommended Access - has recommended permissions for using SUSE Observability."

=> Does this mean we should add group lccp_owner to the project where I installed Suse Observability? Tried it, and got the same thing - forever loading. Suggestion: Since you have the Recommended role, for instance, it would be good to have it for Observer as well.```
I ran some tests in my lab and experienced the same behavior that the customer reported. I believe this could be an area for improvement in future versions, and the documentation might also be updated to include this. I've got more info, logs, and screenshots, and I can send them over if it helps. Also, I can volunteer to help with creating a PR for the documentation, if needed.

Thanks in advance.

---

**Alessio Biancalana** (2025-09-30 18:27):
I have some news.

1. we are applying categorization to logs, so yes, the `Error: null`  line triggers this kind of behavior making the log line end up in the errors count
2. this, tho, doesn't alter the cluster's health. The `CRITICAL` state must be coming from somewhere else. Any number of erroring logs shouldn't have an impact on the actual component's health.

---

**Alejandro Acevedo Osorio** (2025-09-30 19:06):
Thanks for the feedback
• Indeed for the access to a particular project/cluster the `(Cluster)Oserver` role  needs to be there as that gives the relevant permissions on data. The `Instance Recommended Access` is just a base of permissions the users need to access the Observability instance (and use some of the basic features such as cli, favorite views, ...)  but they don't have any effect on the data you are entitled to access. That's what the phrase `"To use these observer roles, it is recommended that the following role be granted on the Project running SUSE Observability itself: * Recommended Access - has recommended permissions for using SUSE Observability."`  means.

---

**Rajesh Kumar** (2025-09-30 19:38):
can we find out how and aht's causing it by the logs? What will we need?

---

**Alejandro Acevedo Osorio** (2025-10-01 09:13):
I think the feedback related to
```1. Expect a similar role to that which allows creating dashboards and even notifications. It's unrealistic for an admin to create those for all teams in the company - or even external customers.```
is relevant for product. @Mark Bakker @Bram Schuur @Louis Lotter

---

**Mark Bakker** (2025-10-01 09:20):
@Bruno Bernardi thanks for the feedback. We have seen this feedback more common and need to see how and when we can support this.

---

**Mark Bakker** (2025-10-01 09:26):
I created an Epic (https://stackstate.atlassian.net/browse/STAC-23473) to track this.

---

**Rajesh Kumar** (2025-10-01 10:23):
Let me know if you find any answers.

---

**Bruno Bernardi** (2025-10-01 15:05):
Thanks for your feedback and attention, @Alejandro Acevedo Osorio and @Mark Bakker.

---

**Garrick Tam** (2025-10-01 19:46):
Hello Engineering.  What release is https://stackstate.atlassian.net/browse/STAC-23087 fix part of?

---

**Alessio Biancalana** (2025-10-02 09:01):
hello :slightly_smiling_face: most likely v2.4.0

---

**Louis Lotter** (2025-10-02 09:29):
yeah it's 2.4.0

---

**Alessio Biancalana** (2025-10-02 10:54):
not that I know, this is basically asking to debug the customer's cluster which we don't have access to

---

**Chris Riley** (2025-10-02 16:36):
@Bram Schuur - do you have any updates to share please?

---

**Bram Schuur** (2025-10-02 18:08):
We have refined the ticket and we'll pick it up next sprint.

---

**Andrea Terzolo** (2025-10-03 09:18):
Let me take a look :slightly_smiling_face:!

---

**Alessio Biancalana** (2025-10-03 09:19):
@Andrea Terzolo I was taking a look myself, can you confirm if we are actually using the environment variable to initialize conntrack in the node agent? Because I don't see that leveraged

---

**Andrea Terzolo** (2025-10-03 09:23):
this is an env variable for the process agent to disable the connection check

---

**Andrea Terzolo** (2025-10-03 09:25):
i need to double check but i think the issue here is `--set-string` (`--set-string 'nodeAgent.networkTracing.enabled'='false'` ), you should use instead `--set nodeAgent.networkTracing.enabled=false`  otherwise 'false' will be interpreted as a string and not as a boolean value

---

**Alessio Biancalana** (2025-10-03 09:26):
true that, @Garrick Tam can you try again with just `--set` ?

---

**Chris Riley** (2025-10-03 10:49):
Thanks, Bram. Out of interest, when is the next sprint?

---

**Bruno Bernardi** (2025-10-03 18:24):
Hi @Alejandro Acevedo Osorio,

I'd just like to send you some more details and use cases about this same customer. Please take a look:

```- Cluster wide role has only "SUSE Observability Cluster Observer" - Please see attachment cluster_wide_role.png

- Project wide roles has only "SUSE Observability Observer" that is project scoped - using "scope.observability.cattle.io (http://scope.observability.cattle.io)" API group

- The customer can't add lccp_owner on a cluster level, as the members are not cluster admins - they would get access to all cluster metrics, which they don't need and shouldn't see.```
We created a custom cluster role that adds creation of notifications for users, but that had to be on the whole instance using "instance.observability.cattle.io (http://instance.observability.cattle.io)" API group. That means that ALL users have access to all notifications which is something that the customer wants to avoid. This case is partially solved as the users now have read-only access to metrics/traces/logs.

Our follow-up question is: The customer needs to be able to create monitors and notifications per team. Is that possible?
Is it in the roadmap perhaps?

Thanks in advance.

---

**Garrick Tam** (2025-10-03 19:05):
Customer tried --set nodeAgent.networkTracing.enabled=false but unfortunately the node-agent still throws the same error and exits.  Here's the full node-agent log for one of them.  How to overcome this error condition?

---

**Andrea Terzolo** (2025-10-03 19:28):
can you try this one `--set global.extraEnv.open.STS_DISABLED_PROTOCOLS="http2"` ?

---

**Andrea Terzolo** (2025-10-03 19:29):
it should disable http2 protocol

---

**Andrea Terzolo** (2025-10-03 19:29):
BTW can you check the kernel version of the customer setup with `uname -a`

---

**Andrea Terzolo** (2025-10-03 19:32):
if even `--set global.extraEnv.open.STS_DISABLED_PROTOCOLS="http2"` doesn't work, i would suggest to disable the process-agent directly for now `--set nodeAgent.containers.processAgent.enabled=false` . With it disabled no topology will be created in the platform but at least the error should disappear

---

**Garrick Tam** (2025-10-03 19:35):
The OS is RHEL 8 with kernel 4.18.

---

**Garrick Tam** (2025-10-03 19:41):
Get the following warning when I tried  --set global.extraEnv.open.STS_DISABLED_PROTOCOLS="http2" in my lab.
```2025-10-03 17:39:16 UTC | CORE | WARN | (pkg/util/log/log.go:693 in func1) | Unknown environment variable: STS_DISABLED_PROTOCOLS```

---

**Andrea Terzolo** (2025-10-03 19:42):
yep that's fine. The failing agent is `process-agent` so you should check its logs
```k logs -n monitoring suse-observability-agent-node-agent-... -c process-agent```

---

**Andrea Terzolo** (2025-10-03 19:43):
the node-agent has 2 containers inside, and the failing one is the one called `process-agent`

---

**Andrea Terzolo** (2025-10-03 19:52):
Actually you can avoid the warning on the node agent using this `--set nodeAgent.containers.processAgent.env.STS_DISABLED_PROTOCOLS="http2"` .
The above command sets the env variable just for the process-agent and not for all agent containers.

---

**Garrick Tam** (2025-10-03 19:54):
Thank you very much.  I shared the parameter with the customer.

---

**Garrick Tam** (2025-10-03 20:34):
Customer confirmed .STS_DISABLED_PROTOCOLS="http2" works.

---

**Garrick Tam** (2025-10-03 20:35):
Here's a follow-up question.  I don't think I could have figured out this parameter nodeAgent.containers.processAgent.env.STS_DISABLED_PROTOCOLS="http2" from the helm chart git repo or docs.  How and where would someone go to figure out how to compose these parameters?

---

**Andrea Terzolo** (2025-10-06 09:28):
that's a good point! actually the existence of some env variables is only documented in the process-agent code (the ones we usually use just for debug and that are not thought to be stable APIs). In this case i believe that `STS_DISABLED_PROTOCOLS` is important enough to be explicitly documented and supported in the helm chart as a field so i opened a MR to support exactly this https://gitlab.com/stackvista/devops/helm-charts/-/merge_requests/1649. From the next release you should find it in the agent helm chart as `processAgent.disabledProtocols`

---

**Andrea Terzolo** (2025-10-06 09:32):
BTW this issue highlighted that the env variable `STS_NETWORK_TRACING_ENABLED` is not correctly parsed by the process-agent, i will open a separate ticket for this

---

**Frank van Lankvelt** (2025-10-06 11:20):
did you try setting the env variable STS_NETWORK_TRACING_ENABLED to false (in the extraEnv values for the agent)

---

**Ankush Mistry** (2025-10-06 11:23):
I will need to check this with the customer.

---

**Frank van Lankvelt** (2025-10-06 11:26):
RHEL 8 uses kernel 4.18.x, which does not support the ebpf filter we use for tracing network calls.  @Andrea Terzolo: do you know more about this, or maybe have a workaround?

---

**Andrea Terzolo** (2025-10-06 11:29):
sure! this is the same issue reported above in this channel https://suse.slack.com/archives/C07CF9770R3/p1759450585638599. @Ankush Mistry TL;DR; the current workaround is to set `--set nodeAgent.containers.processAgent.env.STS_DISABLED_PROTOCOLS="http2"` in the agent helm chart

---

**Ankush Mistry** (2025-10-06 11:32):
Thank you for the help, I referred to the above thread as well!

---

**Rajesh Kumar** (2025-10-06 11:46):
Thank you! Can we take it as an RFE, may be?

---

**Frank van Lankvelt** (2025-10-06 14:00):
the suggestion  by @Andrea Terzolo was to use
```processAgent:
   enabled: true
   env:
      STS_DISABLED_PROTOCOLS: http2```
 in the values yaml.  Did you try that?

---

**Ankush Mistry** (2025-10-06 14:01):
yes they have tried it

---

**Frank van Lankvelt** (2025-10-06 14:22):
can you get the yaml for the node-agent daemonset with the environment variable set?

---

**Andrea Terzolo** (2025-10-06 14:31):
well, i'm pretty sure there is an error in helm syntax, why are they doing that manually and not using the command line `--set nodeAgent.containers.processAgent.env.STS_DISABLED_PROTOCOLS="http2"`?

---

**Andrea Terzolo** (2025-10-06 14:36):
The right syntax is this one
```      env:
        STS_DISABLED_PROTOCOLS: "http2"```
not this one
```  env:
    - name: STS_DISABLED_PROTOCOLS
     value: http2```

---

**Andrea Terzolo** (2025-10-06 14:39):
`nodeAgent.containers.processAgent.env` is an `object` not a `list` , the syntax they are using is the list one
```| nodeAgent.containers.processAgent.env | object | `{}` | Additional environment variables for the process-agent container |```

---

**Frank van Lankvelt** (2025-10-06 14:42):
there may be some confusion if they're editing the daemonset manually as well - the `env` there IS a list of objects with name/value keys.  But it's probably better to just redeploy using helm.

---

**Andrea Terzolo** (2025-10-06 14:43):
BTW setting `STS_NETWORK_TRACING_ENABLED` is not necessary, `STS_DISABLED_PROTOCOLS` should do the job

---

**Ankush Mistry** (2025-10-06 14:44):
yes, thanks again!

---

**Mark Bakker** (2025-10-06 16:27):
Creating monitors and notifications per team is a valid feature request. It is however not part of the short term roadmap due too capacity constraints.

---

**Bruno Bernardi** (2025-10-06 17:43):
Thanks, @Mark Bakker.

---

**IHAC** (2025-10-07 16:27):
@Bruno Bernardi has a question.

:customer:  Tietoevry Tech Services Finland

:facts-2: *Problem (symptom):*  
The customer has an otel-collector in the namespace `carekube-otel`. It discovers all cnpg (postgres) clusters, and starts automatically scraping them. For example, one of the clusters is in the namespace `lopdev-iam-dev-karolinska`. As admin, we can see those metrics, but users that own the namespace `opdev-iam-dev-karolinska` via project can't see it.

*Question:* How is mapping to a RBAC namespace done for metrics in this case? Is this currently supported?

I was hoping this would do the trick:
```        - key: service.namespace
          from_attribute: k8s.namespace.name
          action: insert```
For metrics, we can see that it comes from the correct namespace, but users owning that namespace can't see it. Please see the metrics screenshot from the perspective as admin.

Can you please take a look?

Thanks in advance.

---

**Frank van Lankvelt** (2025-10-07 16:35):
for RBAC to work, the RBAC Agent needs to be deployed to the cluster.  Did you do this?

---

**Bruno Bernardi** (2025-10-07 16:57):
Thanks for your response, Frank. As far as I remember, the customer already has RBAC Agent installed. I can see the RBAC Agent pod running fine on the latest Support Package.

By the way, we have already resolved some RBAC issues for this same customer, but now they have brought up this additional question about OTEL. Here (https://suse.slack.com/archives/C07CF9770R3/p1759248382376579) is the thread of what was done previously.

---

**IHAC** (2025-10-07 17:40):
@Javier Lagos has a question.

:customer:  The Commonwell Mutual Insurance Group

:facts-2: *Problem (symptom):*  
Hello team,

The customer is asking us through a case about the supportability matrix of SUSE Observability in their environment.

They are currently running an old 2.3.4 SUSE Observability version in a AKS 1.31 version that will be out of support by the end of the month so they need to upgrade minimum to AKS 1.32.
They are wondering about the impact of SUSE Observability on the new version.

As far as I have been able to check we don't have any support matrix for SUSE observabilty but maybe I'm wrong. Do we have any support matrix similar to what we have with Rancher/NeuVector/Harvester? https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-12-2/

On the other hand, Is there any consideration we need to have in mind for this upgrade apart from telling the customer to upgrade from 2.3.4 to 2.6.0 SUSE observability version?

TIA!

---

**Alessio Biancalana** (2025-10-07 17:46):
https://documentation.suse.com/cloudnative/suse-observability/latest/en/k8s-quick-start-guide.html#_amazon_eks

---

**Javier Lagos** (2025-10-07 17:47):
I saw this table too. but this applies to all SUSE observability versions?

---

**Javier Lagos** (2025-10-07 17:47):
normally we have something like X k8s version with X component version

---

**Alessio Biancalana** (2025-10-07 17:48):
I understand what you mean and I don't think we have that kind of documentation at the moment, we can create that tho, as far as I know SUSE Observability doesn't have _strict_ compatibility between k8s versions, the most impacted component is always the agent

---

**Alessio Biancalana** (2025-10-07 17:50):
@Louis Parkin I remember you mentioning EKS 1.32 some days ago but my memory is foggy atm, does the agent support and was it just a matter of testing with Beest?

---

**Louis Parkin** (2025-10-07 17:52):
The agent is, at present, compatible with all versions in the EKS window (1.31 to 1.33), assumed backwards compatibility with all versions prior to 1.31

Currently working on adapting for kubelet metrics ingestion for k8s 1.34+

---

**Alessio Biancalana** (2025-10-07 17:53):
thanks, sorry for the abrupt ping

---

**Louis Parkin** (2025-10-07 17:53):
@Vladimir Iliakov what k8s version are our kops, tooling and aegir clusters on?

---

**Javier Lagos** (2025-10-07 17:56):
Thanks for the support @Alessio Biancalana and @Louis Parkin!! I really appreciate your thoughts on that.

So basically, I understand that, we can go ahead and update AKS version from 1.31 to 1.32 without any expect issue with the product.

Should we recommend to the customer to upgrade SUSE Observability server and agent from the current version to the latest version before upgrading? After? What is the recommended procedure, before or after upgrading the k8s environment? Does it actually matter? First the server and then the agent or viceversa?

I have not confirmed that with customer but as they are running 2.3.4 SUSE observability server version I think they should have also old agent versions too.

I just want to confirm the procedure and avoid a possible downtime.

---

**Vladimir Iliakov** (2025-10-07 18:46):
@Louis Parkin 1.30

---

**Louis Parkin** (2025-10-07 19:31):
@Vladimir Iliakov have we tested the platform on 1.32 yet?

---

**Vladimir Iliakov** (2025-10-07 19:37):
@Louis Parkin as far as I know, we haven't.

---

**IHAC** (2025-10-08 01:28):
@Garrick Tam has a question.

:customer:  NowCom

:facts-2: *Problem (symptom):*  
Customer states they are not able to accessing the observability ui/portal.  I reviewed the log bundle and see some errors during pod startups but the same error conditions does not seem to be occurring any longer.

Can I get help to check and see if there is any reason why the customer is reporting unable to accessing the ui?

Attached is the log bundle.  TIA

---

**Frank van Lankvelt** (2025-10-08 08:20):
was this after an upgrade or a clean install?  An upgrade might take some time to run migration scripts

---

**Louis Parkin** (2025-10-08 10:05):
@Javier Lagos the agent has been confirmed to be compatible with 1.32 since at least the 4th of February 2025, no explicit need to upgrade to the latest agent version, they can if they want to.

---

**Louis Parkin** (2025-10-08 10:07):
We have a platform release scheduled for some time in the next two weeks, so, if they can delay the upgrade for two weeks, they'd get the latest version of the server then.

---

**Javier Lagos** (2025-10-08 11:03):
Thanks for the support @Louis Parkin! I will let the customer know about this.

---

**Javier Lagos** (2025-10-08 15:18):
FYI - I have tested already to restart stackgraph, tephra and server pods and it didn't work

---

**Javier Lagos** (2025-10-08 15:19):
I suspect the only way to get rid of this issue is to perform a restore or a complete reinstall?

---

**Alejandro Acevedo Osorio** (2025-10-08 16:37):
Mmmm this is a new one ... I wonder how's the disk space of the stackgraph pvc?

---

**Javier Lagos** (2025-10-08 16:41):
Thanks for the support @Alejandro Acevedo Osorio! Unfortunately we don't have those details on the support package. I can see a 20GB PVC for StackGraph but without the actual usage of it.

```persistentvolumeclaim/data-suse-observability-hbase-stackgraph-0              Bound    pvc-7a8732d5-8081-4105-bb4d-0e52f5d1d641   20Gi       RWO            basf-secured-private-managed-disk   &lt;unset&gt;                 44d   Filesystem```
I will ask the customer to provide the details and let you know

---

**Alejandro Acevedo Osorio** (2025-10-08 16:42):
yup, wondering if the issues we see are due to lack of disk space. Not sure

---

**Javier Lagos** (2025-10-08 16:46):
Yeah I also thought on that possibility like what we saw here https://suse.slack.com/archives/C079ANFDS2C/p1735295023653799?thread_ts=1735294445.472839&amp;cid=C079ANFDS2C but I didn't see any "no space left on device" on the logs. However, I think its better if we are 100% sure that this is not a space problem within StackGraph pod.

---

**Alejandro Acevedo Osorio** (2025-10-08 16:48):
gotcha ... well let's ask them to just verify the different pvc's

---

**Javier Lagos** (2025-10-08 16:48):
Totally agree. I have just asked the customer to provide StorageClass details and StackGraph PVC usage!

---

**Bruno Bernardi** (2025-10-08 21:25):
Hi @Frank van Lankvelt,

When feasible for you, can you please help me to validate this scenario?

We’re able to achieve many of the customer goals with RBAC, but we cannot make it work for the scenario that I presented here. So, I’m not sure if it is supported or if we are forgetting any key for this trick on the RBAC or Observer section.

Thanks in advance.

---

**Rodolfo de Almeida** (2025-10-09 03:36):
I was able to reproduce the customer’s environment, although not in a high-availability (HA) setup due to lab limitations. In my lab, using the _10-nonha_ configuration, everything worked as expected. However, I noticed an important detail that might be relevant.
Initially, I had configured an incorrect secret in the `authentication.yaml` file and the Observability UI was in a loop showing `loading` message on the UI. After correcting the secret, the server pod automatically restarted, but was still the same pod and the issue persisted. It looks like the incorrect secret was still being used, but checking the secret I saw it was fixed in the suse-observability namespace. Simply restarting the pod was not sufficient to apply the fix.
To resolve the issue, it was necessary to manually delete the server pod. Once the new pod was created, the UI loaded correctly.
This is why we have tried to manually delete the api and router pods.

---

**Amol Kharche** (2025-10-09 05:31):
Can you please try removing `redirectUri: "https://els-atlantis-observa01.tridentcloud.io/loginCallback?client_name=StsOidcClient"`  entry from authentication.yaml file and then reapply?
https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/authentication/oidc.html#_rancher_2

---

**Javier Lagos** (2025-10-09 08:42):
I think that Amol's message is correct. redirectUri must be defined on the OIDC object created on rancher not on the authentication.yaml SUSE Observability values.

Here are my values that are working fine.
```stackstate:
  authentication:
    rancher:
      clientId: "XXXX"
      secret: "XXXX"
      baseUrl: "https://rancher.174.138.103.184.sslip.io"```
and here is the OIDC rancher object where I defined the redirectURI parameter.
```k apply -f - &lt;&lt;EOF      
apiVersion: management.cattle.io/v3 (http://management.cattle.io/v3)
kind: OIDCClient
metadata:
  name: oidc-observability
spec:
  tokenExpirationSeconds: 600
  refreshTokenExpirationSeconds: 3600
  redirectURIs:
    - "https://observability.174.138.103.184.sslip.io/loginCallback?client_name=StsOidcClient"
EOF```

---

**Javier Lagos** (2025-10-09 12:05):
Hey @Alejandro Acevedo Osorio.PVC is almost empty.

```Filesystem   Size Used Avail Use% Mounted on
/dev/sdb     20G 1.2G  19G  6% /hadoop-data/data```
It looks like they are using azure csi provider as storageclass.
```parameters:

 networkAccessPolicy: DenyAll

 skuname: StandardSSD_ZRS

provisioner: disk.csi.azure.com (http://disk.csi.azure.com)

reclaimPolicy: Delete

volumeBindingMode: WaitForFirstConsumer ```
Do you have any idea of what is the main reason that caused the issue?

---

**Rodolfo de Almeida** (2025-10-09 13:05):
Hello @Amol Kharche @Javier Lagos
Initially the customer was trying it without the redirectURI and was facing the same issue.

---

**Rodolfo de Almeida** (2025-10-09 13:06):
This is the initial authentication.yaml used by the customer.
```stackstate:
  authentication:
    rancher:
      clientId: "client-vhw5rr25jk"
      secret: "secret-xxxx"
      baseUrl: "https://els-atlantis.tridentcloud.io"```

---

**Rodolfo de Almeida** (2025-10-09 13:07):
@Javier Lagos it also worked in my lab, but using the 10-nonha size.

---

**Alejandro Acevedo Osorio** (2025-10-09 13:41):
TBH not sure what could have caused the partial write of those `WAL` files that stackgraph is complaining about. Given that is a TRIAL instance I'd go with the clean reinstall

---

**Javier Lagos** (2025-10-09 14:08):
Thanks @Alejandro Acevedo Osorio. I can see they have been running TRIAL size for almost 40 days by testing the product which I think its not the expected usage for this size. I am going to recommend them to perform a clean installation by selecting 10-nonHA size and I will let you know in case of issues.

---

**Alejandro Acevedo Osorio** (2025-10-09 14:09):
that sounds fair, although there's not much difference among those 2 profiles. But anywho I think it's a good recommendation to go to a bigger profile if they are looking for durability

---

**Rodolfo de Almeida** (2025-10-09 14:12):
Thanks @Amol Kharche I will ask the customer to try it

---

**Rodolfo de Almeida** (2025-10-09 17:16):
<!here> it seems this is something urgent to the customer. Can someone from engineer also check this issue and if there is anything else to add to Amol's recommendation?
https://suse.slack.com/archives/C07CF9770R3/p1759973598516129

Thanks!

---

**Alejandro Acevedo Osorio** (2025-10-09 17:28):
@Rodolfo de Almeida seems they are using `rancher` as OIDC provider. The docs for that config establish `redirectURIs` as an array https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/authentication/oidc.html#_rancher on the OICDClient resource
```apiVersion: management.cattle.io/v3
kind: OIDCClient
metadata:
  name: oidc-observability
spec:
  tokenExpirationSeconds: 600
  refreshTokenExpirationSeconds: 3600
  redirectURIs:
    - "https://<observability-base-url>/loginCallback?client_name=StsOidcClient"```
and what the customer is using on the `oidc_values.yaml` is
```stackstate:
  authentication:
    rancher:
      clientId: "client-vhw5rr25jk"
      secret: "secret-nhgfggdx4kgp8qfn7ldbrv7ct2b2w78xrtktwjmspnfrv6cmwpc56fjx%"
      baseUrl: "https://els-atlantis.tridentcloud.io"
      redirectUri: "https://els-atlantis-observa01.tridentcloud.io/loginCallback?client_name=StsOidcClient"```
`redirectUri` being a singular value

---

**Alejandro Acevedo Osorio** (2025-10-09 17:31):
So probably remove the `redirectUri` on the `oidc_values.yaml` and verify the `OIDCClient`

---

**Alejandro Acevedo Osorio** (2025-10-09 17:31):
which is what @Javier Lagos already pointed on this message https://suse.slack.com/archives/C07CF9770R3/p1759992176693429?thread_ts=1759973598.516129&amp;cid=C07CF9770R3

---

**Alejandro Acevedo Osorio** (2025-10-09 17:39):
~On other interesting thing is that on the `oidc_values.yaml` and the screenshot you shared there's a mismatch of the `redirectUri`  and the `baseUrl`~
```      baseUrl: "https://els-atlantis.tridentcloud.io"
      redirectUri: "https://els-atlantis-observa01.tridentcloud.io/loginCallback?client_name=StsOidcClient```
~`https://els-atlantis.tridentcloud.io` vs `https://els-atlantis-observa01.tridentcloud.io`~
~Did they change the baseUrl and didn't update the `redirecUri` on the `OIDCClient`?~

---

**Rodolfo de Almeida** (2025-10-09 17:50):
The baseUrl is the Rancher url and the redirectUri is the observability url.
Not sure how this should be configured

---

**Alejandro Acevedo Osorio** (2025-10-09 17:52):
~`baseUrl` needs to be the observability url~

---

**Rodolfo de Almeida** (2025-10-09 17:53):
Strange... I was following the docs. It says rancher-url
```stackstate:
  authentication:
    rancher:
      clientId: "&lt;oidc-client-id&gt;"
      secret: "&lt;oidc-secret&gt;"
      baseUrl: "&lt;rancher-url&gt;"```

---

**Alejandro Acevedo Osorio** (2025-10-09 17:55):
my bad, you are totally right. this is the `baseUrl` within the rancher auth namespace

---

**Alejandro Acevedo Osorio** (2025-10-09 18:01):
On the `oidc_values.yaml` I see
```secret: "secret-nhgfggdx4kgp8qfn7ldbrv7ct2b2w78xrtktwjmspnfrv6cmwpc56fjx%"```
and in the screensht that last `%` char is not present ... I guess they copied the extra `%` that `base64 -d` outputs

---

**Rodolfo de Almeida** (2025-10-09 18:33):
This was a mistake that I made yesterday but was fixed.

---

**Rodolfo de Almeida** (2025-10-10 03:42):
Hello @Amol Kharche @Alejandro Acevedo Osorio
The customer tried to apply the `CONFIG_FORCE_stackstate_misc_sslCertificateChecking: false` in the authentication.yaml file but according to the logs shared, we are still facing the same issue. I am attaching the new logs.

After testing the sslCertificateChecking set to false, the customer created a test environment because they were trying to configure a production one and was impacting other workers.
It looks like they are still having the same issue in the test environment.
This is the OIDClient and authentication settings used in the test environment. They are using the same Rancher cluster but a test Observability cluster.
```kubectl get oidcclient test-observability -oyaml

apiVersion: management.cattle.io/v3 (http://management.cattle.io/v3)
kind: OIDCClient
metadata:
  creationTimestamp: "2025-10-09T17:20:42Z"
  generation: 1
  name: test-observability
  resourceVersion: "9081992"
  uid: 96a194d6-5919-4c94-92ee-ed69436d853f
spec:
  redirectURIs:
    - https://els-atlantis-observa02.tridentcloud.io/loginCallback?client_name=StsOidcClient
  refreshTokenExpirationSeconds: 3600
  tokenExpirationSeconds: 600
status:
  clientID: client-cf8glm6pdn
  clientSecrets:
    client-secret-1:
    createdAt: "1760030442"
    lastFiveCharacters: 789s5


--- 
stackstate:
  authentication:
    rancher:
      clientId: "client-cf8glm6pdn"
      secret: "secret-kwlwmnz7bvzr7wpcvw5w"
      baseUrl: "https://els-atlantis.tridentcloud.io"
  components:
    server:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_misc_sslCertificateChecking: false```
I also asked the customer to collect and share the logs from the test environment.

Any other ideas?

---

**Alejandro Acevedo Osorio** (2025-10-10 08:00):
The disable of sslCertCheck is being applied to components.server (non-ha) but the customer is using ha with an api pod rather than server so I think it needs to be on components.api that extra env variable

---

**Frank van Lankvelt** (2025-10-10 08:53):
hi @Bruno Bernardi,
on the SUSE Observability side, we use the resource attributes `cluster_name` and `namespace` to determine scoping.  So if those two are set then things should work.

---

**Frank van Lankvelt** (2025-10-10 08:59):
if you look in victoriametrics, there should be a label `_scope_` with values `k8s:{{ "{{cluster_name}}:{{namespace}}" }}` on the metrics that are ingested.

---

**Rodolfo de Almeida** (2025-10-10 12:21):
@Alejandro Acevedo Osorio @Amol Kharche 
Sorry, but I did not understand your last comment.  Is there anything from the configuration files that we can set to fix the certificate issue?

---

**Amol Kharche** (2025-10-10 12:22):
I think we need to add api instead of server, @Alejandro Acevedo Osorio Could you please confirm
```  components:
    api:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_misc_sslCertificateChecking: false```
Full content.
```stackstate:
  authentication:
    rancher:
      clientId: "client-cf8glm6pdn"
      secret: "secret-kwlwmnz7bvzr7wpcvw5w"
      baseUrl: "https://els-atlantis.tridentcloud.io"
  components:
    api:
      extraEnv:
        open:
          CONFIG_FORCE_stackstate_misc_sslCertificateChecking: false```

---

**Rodolfo de Almeida** (2025-10-10 12:24):
Ahhhh that is clear now. Thanks Amol :blush:  
I will wait Alejandro to confirm and send an update to the customer…

---

**Rodolfo de Almeida** (2025-10-10 12:24):
Thank you both!!!

---

**Alejandro Acevedo Osorio** (2025-10-10 12:24):
That's exactly what I meant @Amol Kharche :+1:

---

**IHAC** (2025-10-10 12:34):
@Amol Kharche has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Hi Team,
One of customer would like to understand how to scope on namespaces in Observability. They are using the following config to scope a cluster, which works:
```resourcePermissions:
get-topology:
- "cluster-name:usr-rh-1001"
get-metrics:
- "k8s:usr-rh-1001:__any__"
get-traces:
- "k8s.cluster.name:usr-rh-1001"```
Now on this cluster they want to scope it to the suse-observability-agent namespace. What is the correct syntax for this?

---

**Amol Kharche** (2025-10-10 12:37):
Do we need to just add namespace after clustername ?
```resourcePermissions:
get-topology:
- "cluster-name:usr-rh-1001/suse-observability"
get-metrics:
- "k8s:usr-rh-1001/suse-observability:__any__"
get-traces:
- "k8s.cluster.name/suse-observability:usr-rh-1001 (http://k8s.cluster.name/suse-observability:usr-rh-1001)"```

---

**Frank van Lankvelt** (2025-10-10 12:54):
that would be
```get-topology:
  - "k8s-scope:usr-rh-1001/suse-observability"
get-metrics:
  - "k8s:usr-rh-1001:suse-observability"
get-traces:
  - "k8s.scope:usr-rh-1001/suse-observability"```

---

**Amol Kharche** (2025-10-10 13:41):
Is there any documentation on how to use this correctly? Customer looking for docs

---

**Frank van Lankvelt** (2025-10-10 14:34):
I'm  only aware of https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/metrics/k8s-stackstate-grafana-datasource.html#_restrict_a[…]_to_metrics (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/metrics/k8s-stackstate-grafana-datasource.html#_restrict_access_to_metrics) - where it's documented for metrics

---

**Amol Kharche** (2025-10-10 15:27):
The following setup doesn't seem to work for customer.
``` resourcePermissions:
       get-topology:
      - "cluster-name:usr-ol-3024"
      - "k8s-scope:usr-rh-3001/eidas-acc"
      - "k8s-scope:usr-rh-3001/eidas-tst"
       get-metrics:
      - "k8s:usr-ol-3024:__any__"
      - "k8s:usr-rh-3001:eidas-acc"
      - "k8s:usr-rh-3001:eidas-tst"
       get-traces:
      - "k8s.cluster.name:usr-ol-3024"
      - "k8s.scope:usr-rh-3001/eidas-acc"
      - "k8s.scope:usr-rh-3001/eidas-tst"```
In Observability they can only view the usr-ol-3024 cluster. Is this because the - "cluster-name:usr-ol-3024" has to be changed to - "k8s-scope:usr-ol-3024" for the usr-rh-3001 scope to also work?

---

**Javier Lagos** (2025-10-10 15:51):
Oh no... @Alejandro Acevedo Osorio. This error seems to be the same or similar to the one we had on Rabobank's environment.

https://suse.slack.com/archives/C07CF9770R3/p1758701281178949?thread_ts=1758643475.385599&cid=C07CF9770R3.


FYI @Giovanni Lo Vecchio - The workaround was to restore all the databases by following the docs provided here https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/kubernetes_backup.html#_resto[…]apshots (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/kubernetes_backup.html#_restore_backups_and_snapshots) but lets wait until engineering confirms.

---

**Frank van Lankvelt** (2025-10-10 15:53):
for the topology, a component is visible if one of it's labels is in the list for `get-topology`.  So I'm a bit puzzled why the cluster would be visible but the namespaces are not

---

**Alejandro Acevedo Osorio** (2025-10-10 16:08):
That doesn’t look good. I think you are right @Javier Lagos  … if the vertex not found is consistent among restarts then I think we don’t have other solution yet

---

**Javier Lagos** (2025-10-10 16:10):
They actually don't have a vertex message. The error message is the same but in their case its element.

```Element does not exist 139475125838282```
In our case it was like this.
```Vertex with id=28887470107634 does not exist```

---

**Amol Kharche** (2025-10-10 16:21):
I have asked more clarity on above setup what they want to achieve.

---

**Rodolfo de Almeida** (2025-10-10 16:22):
Hello @Amol Kharche @Alejandro Acevedo Osorio
Thanks for your help, the customer just confirmed that it is working now.
I believe we should update the docs, what do you think?

---

**Amol Kharche** (2025-10-10 16:38):
@Alejandro Acevedo Osorio Can you please review https://github.com/rancher/stackstate-product-docs/pull/102

---

**Bruno Bernardi** (2025-10-10 18:08):
Thanks, @Frank van Lankvelt. Let me test this in my lab and also share it with the customer. I will keep you updated. Thanks again for your help!

---

**Alejandro Acevedo Osorio** (2025-10-10 18:44):
Approved. Thanks for taking care of it Amol

---

**David Noland** (2025-10-11 03:06):
Is this fix in the latest 1.1.2 release of the observability agent? If not, any plans on which version will have this fix?

---

**Giovanni Lo Vecchio** (2025-10-11 14:40):
So, @Alejandro Acevedo Osorio, what is the suggestion for the customer? Is it correct to say that StackState’s internal database has become corrupted and that they can either restore from a backup (if one exists!) or reinstall from scratch?

Are we working on a fix for this issue? Writing it like this without providing an explanation might make it seem unreliable…

TIA!

---

**Alejandro Acevedo Osorio** (2025-10-11 16:09):
If we confirm that the sync pod on every restart gets stuck on the same elementId not existing then indeed the only solution we have now is to restore an stackgraph backup (might not be available) or a configuration backup (always available). In the very next release we are making an improvement in the database to prevent this kind of issues. https://stackstate.atlassian.net/browse/STAC-23446 (https://stackstate.atlassian.net/browse/STAC-23446)

---

**Bram Schuur** (2025-10-13 08:47):
@Rodolfo de Almeida this work got scheduled as part of our stackpacks 2.0 effort, which means it will happen somewhere coming months (we are actively working on that), but not very soon.

---

**Andrea Terzolo** (2025-10-13 09:28):
Yes the 1.1.2 release of the observability agent chart contains the fix

---

**Amol Kharche** (2025-10-13 09:59):
Here is the response from customer.

```"Hi,
The config I send before only show the resources from cluster usr-ol-3024 in Observability. It should also show the two defined namespaces from usr-rh-3001, but these are not visible. The setup does work when I scope one or even two namespaces. But when I add a full cluster scope to it, the full cluster is not visible.
For example this works:
 resourcePermissions:
       get-topology:
      - "k8s-scope:usr-ol-1001/suse-observability-agent"
      - "k8s-scope:usr-rh-1001/suse-observability-agent"
       get-metrics:
      - "k8s:usr-ol-1001:suse-observability-agent"
      - "k8s:usr-rh-1001:suse-observability-agent"
       get-traces:
      - "k8s.scope:usr-ol-1001/suse-observability-agent"       
      - "k8s.scope:usr-rh-1001/suse-observability-agent"

and these do not:

 resourcePermissions:
       get-topology:
      - "k8s-scope:usr-ol-1001/suse-observability-agent"
      - "k8s-scope:usr-rh-1001/suse-observability-agent"
      - "k8s-scope:dcmp-tooling-1000"
       get-metrics:
      - "k8s:usr-ol-1001:suse-observability-agent"
      - "k8s:usr-rh-1001:suse-observability-agent"
      - "k8s:dcmp-tooling-1000"
       get-traces:
      - "k8s.scope:usr-ol-1001/suse-observability-agent"       
      - "k8s.scope:usr-rh-1001/suse-observability-agent"
      - "k8s.scope:dcmp-tooling-1000"

 resourcePermissions:
       get-topology:
      - "k8s-scope:usr-ol-1001/suse-observability-agent"
      - "k8s-scope:usr-rh-1001/suse-observability-agent"
      - "cluster-name:dcmp-tooling-1000"
       get-metrics:
      - "k8s:usr-ol-1001:suse-observability-agent"
      - "k8s:usr-rh-1001:suse-observability-agent"
      - "k8s:dcmp-tooling-1000:__any__"
       get-traces:
      - "k8s.scope:usr-ol-1001/suse-observability-agent"       
      - "k8s.scope:usr-rh-1001/suse-observability-agent"
      - "k8s.cluster.name:dcmp-tooling-1000"

Thanks!"```

---

**Giovanni Lo Vecchio** (2025-10-13 10:04):
Hey @Alejandro Acevedo Osorio, thanks a lot for the reply!

Yeah, it looks like the described issue.

---

**David Noland** (2025-10-13 17:29):
Great, will be testing it out today, thanks for confirming

---

**Bruno Bernardi** (2025-10-13 18:37):
Hi @Frank van Lankvelt! We were able to fix the last issue after your guidance. Thanks!

---

**Frank van Lankvelt** (2025-10-13 18:44):
Great to hear!

---

**Rodolfo de Almeida** (2025-10-13 20:13):
Thanks, @Bram Schuur. I’ll update the customer that we’re working to resolve the issue, but it may take some time before it’s released.

---

**Rodolfo de Almeida** (2025-10-13 20:19):
Hi @Bram Schuur, do you happen to have an ETA for this issue?

---

**Frank van Lankvelt** (2025-10-13 23:13):
We are wrapping it up at the moment.  We missed the slot for the next release - that will address some urgent data corruption issues so could not be delayed.  But the one after that (I imagine in a few weeks) will include the fix.

---

**Alejandro Acevedo Osorio** (2025-10-14 09:15):
Then indeed the only solution is to restore a backup

---

**Giovanni Lo Vecchio** (2025-10-14 09:17):
Thanks a lot for the help, @Alejandro Acevedo Osorio

---

**Bram Schuur** (2025-10-14 09:31):
@Frank van Lankvelt i checked our docs and could not immediately find anything about RBAC in the context of OTEL (which you described here. Do you know whether we have it? (If not i think it makes sense to document that)

---

**Daniel Barra** (2025-10-14 12:05):
*We are pleased to announce the release of 2.6.1, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.1.html).*

---

**Chris Riley** (2025-10-14 12:13):
Thanks for the update, Frank.

---

**Amol Kharche** (2025-10-14 12:34):
@Frank van Lankvelt Can you please guide here.

---

**IHAC** (2025-10-14 14:25):
@Devendra Kulkarni has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
Customer is trying out the Rancher RBAC and the issue they are facing is that when they configure user with Admin privileges and login to SUSE Observability they can view everything correctly, but when they create a custom project role following https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_rancher.html, the users with project owner role and the SUSE Observability Recommended access role, they are not able to see anything on the SUSE observability instance.

---

**Devendra Kulkarni** (2025-10-14 14:26):
Even I tried reproducing the issue locally and I am able to reproduce it successfully.

---

**Devendra Kulkarni** (2025-10-14 14:28):
Let me know I have an environment where I am able to reproduce this issue and I can show this behavior!

---

**Alejandro Acevedo Osorio** (2025-10-14 14:29):
The `project owner role` is not sufficient you need to add the `Observer` role as the docs suggest

---

**Devendra Kulkarni** (2025-10-14 14:32):
```Observer - grants access to data coming from namespaces in a Project. You can use this in the "Project Membership" section of the cluster configuration.```

---

**Devendra Kulkarni** (2025-10-14 14:32):
I missed it completely, I thought recommended access would allow me, I tried adding this and it worked in my cluster

---

**Devendra Kulkarni** (2025-10-14 14:33):
Thank you!

---

**Alejandro Acevedo Osorio** (2025-10-14 14:33):
@Frank van Lankvelt @Bram Schuur `Recommended access` seems to be creating some confusion. I think it's the second time I see it. Perhaps we need a tweak on the docs or something

---

**IHAC** (2025-10-14 14:42):
@Devendra Kulkarni has a question.

:customer:  CloudFire Srl - CLOUD

:facts-2: *Problem (symptom):*  
Hello Team,

Theres's one more customer CloudFire Srl - CLOUD (https://suse.lightning.force.com/lightning/r/Account/0015q00000GdvFbAAJ/view) trying out a bit different RBAC and not exactly using Rancher RBAC.

As per my understanding, their setup currently is:

```KeyCloak -&gt; Rancher -&gt; Observability```
Issue they are facing is:
• Login issues to the Downstream clusters on Rancher.
```Keycloak user -&gt; Rancher -&gt; Rancher Downstream cluster -&gt; Loops back to Rancher Login```
Workaround:
```Keycloak user -&gt; Observability -&gt; Rancher login -&gt; Rancher Downstream cluster```

---

**Devendra Kulkarni** (2025-10-14 14:43):
Here's the video capture that shows the issue:

---

**Devendra Kulkarni** (2025-10-14 14:44):
Attaching baseconfig_values.yaml

Customer confirmed that currently they do not have any integration between Rancher and Observability Cluster as such, I have already proposed a call to customer to confirm the configurations.

---

**Devendra Kulkarni** (2025-10-14 14:44):
Creating this thread for getting more context if you have seen such issues earlier!

---

**Frank van Lankvelt** (2025-10-14 15:04):
I'm not sure a tweak to the docs can fix it - the roles are not cleanly decoupled.  I think we can split them into two sets:
• Admin/Troubleshooter/Recommended
• Project/Cluster/Instance Observer
where the first would handle non-scoped resources and the second would handle the scoped resources (topology,metrics,traces)

Maybe the Recommended should also be renamed to Basic - sounds less optional IMHO

---

**Alejandro Acevedo Osorio** (2025-10-14 15:05):
yup, I guess making clear that `Recommended/Basic` is all about instance permissions and nothing about data permissions is the thing here

---

**Frank van Lankvelt** (2025-10-14 15:28):
the last config looks correct to me.  Maybe you could try with just the cluster scopes?  And do I understand correctly that this is about the topology components not being visible - or are you trying to plot metrics in grafana, for instance?

---

**Amol Kharche** (2025-10-14 16:04):
Let me ask customer.

---

**Alejandro Acevedo Osorio** (2025-10-14 16:34):
I would expect the `testuser` to be able to login. Probably not see any data, but to be able to login. And based on the logs you provided I think that's the case as the profile being created (empty roles and permissions) is kind of correct.
```2025-10-14 05:31:53,547 ERROR c.s.s.generators.ConfigurableOidcAuthorizationGenerator - Failed to get groups from OIDC Profile for user u-x5hhv. Field 'groups' is not available or is not a list of groups.```
is benign and is just flashing that we don't receive any groups for the user, this is expected as the `auth_provider=local`  and rancher itself doesn't have a concept of groups. The only way we would get any groups is if they are logging to Rancher (and eventually Suse Observability) in via a third party OIDC provider

---

**Alejandro Acevedo Osorio** (2025-10-14 16:34):
Are they using a third party OIDC provider?

---

**Daniel Murga** (2025-10-14 16:54):
No... they are using rancher as OIDC provider

---

**Alejandro Acevedo Osorio** (2025-10-14 16:56):
and have you confirmed that they can't login? Do we have some screenshots?

---

**Daniel Murga** (2025-10-14 22:18):
Tomorrow i've got a meeting with them

---

**Amol Kharche** (2025-10-15 07:21):
Hi Team,
We are not able to see metrics data from one of the agent cluster (`centene-lab`) on our https://rancher-hosted.app.stackstate.io/.
https://rancher-hosted.app.stackstate.io/#/metrics?alias=%24%7Bcluster_name%7D&amp;promql=avg%28c[…]%20%2F%201000000000&amp;timeRange=LAST_7_DAYS&amp;unit=short (https://rancher-hosted.app.stackstate.io/#/metrics?alias=%24%7Bcluster_name%7D&amp;promql=avg%28container_memory_usage%7Bcluster_name%3D~%22centene-.%2A%22%2C%20container%3D%22rancher%22%2C%20namespace%3D%22cattle-system%22%7D%29%20by%20%28cluster_name%29%20%2F%201000000000&amp;timeRange=LAST_7_DAYS&amp;unit=short)
Logs from the agent cluster is attached.  Could you please help.

---

**Vladimir Iliakov** (2025-10-15 08:05):
<!subteam^S08HEN1JX50> some metrics, at least this one, still make to the instance

---

**Daniel Murga** (2025-10-15 09:42):
@Alejandro Acevedo Osorio I'm reafding your previous thoughts... So...
If rancher is the OIDC provider is expected to not receive group membership info... In that case... how do we manage auth? User is validated against OIDC provider (Rancher) then auth request is forwarded to Observability (`auth_provider=local`) and here is where user rights are evaluated? Am I right?

---

**Alejandro Acevedo Osorio** (2025-10-15 09:44):
that's right. The authentication authority is Rancher itself (no concept of groups) and for authorization (user rights) then we rely (same as if there was a third party OIDC provider in place) on the `ClusterRoleBinding` and `RoleBinding` that apply to that local user (basically the same permission system that rancher uses). So basically they need to assign to that `test` user the `Observer` or `ClusterObserver` RoleTemplate (depending if want to give cluster access or project access)

---

**Daniel Murga** (2025-10-15 09:56):
ok... thanks... so they can login but receiving the typical "loading SUSE ..."   some evidences of HTTP/500:
``` "startedDateTime": "2025-10-09T15:17:05.412+02:00",
        "request": {
          "bodySize": 192,
          "method": "POST",
          "url": "https://suse-obs.dev.bcp.mindef.nl/api/timeline/summary",
          "httpVersion": "HTTP/2",
          "headers": [
            {
              "name": "Host",
              "value": "suse-obs.dev.bcp.mindef.nl (http://suse-obs.dev.bcp.mindef.nl)"
            },
            {
              "name": "User-Agent",
              "value": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"
            },
            {
              "name": "Accept",
              "value": "application/json"
            },
            {
              "name": "Accept-Language",
              "value": "en-US,en;q=0.5"
            },
            {
              "name": "Accept-Encoding",
              "value": "gzip, deflate, br, zstd"
            },
            {
              "name": "Referer",
              "value": "https://suse-obs.dev.bcp.mindef.nl/"
            },
            {
              "name": "Content-Type",
              "value": "application/json; charset=utf-8"
            },
            {
              "name": "X-Sts-Token",
              "value": "a454bb83-edbf-4d73-a215-b7fca5f10b0a"
            },
            {
              "name": "X-Requested-With",
              "value": "XMLHttpRequest"
            },
            {
              "name": "Content-Length",
              "value": "192"
            },
            {
              "name": "Origin",
              "value": "https://suse-obs.dev.bcp.mindef.nl"
            },
            {
              "name": "DNT",
              "value": "1"
            },
            {
              "name": "Sec-GPC",
              "value": "1"
            },
            {
              "name": "Connection",
              "value": "keep-alive"
            },
            {
              "name": "Cookie",
              "value": "pac4jCsrfToken=a454bb83-edbf-4d73-a215-b7fca5f10b0a; pac4jCsrfToken=a454bb83-edbf-4d73-a215-b7fca5f10b0a; AkkaHttpPac4jSession=1cdfcc69-2656-46f6-b7cd-32bd6d162411"
            },
            {
              "name": "Sec-Fetch-Dest",
              "value": "empty"
            },
            {
              "name": "Sec-Fetch-Mode",
              "value": "cors"
            },
            {
              "name": "Sec-Fetch-Site",
              "value": "same-origin"
            },
            {
              "name": "Priority",
              "value": "u=4"
            },
            {
              "name": "TE",
              "value": "trailers"
            }
          ],
          "cookies": [
            {
              "name": "pac4jCsrfToken",
              "value": "a454bb83-edbf-4d73-a215-b7fca5f10b0a"
            },
            {
              "name": "pac4jCsrfToken",
              "value": "a454bb83-edbf-4d73-a215-b7fca5f10b0a"
            },
            {
              "name": "AkkaHttpPac4jSession",
              "value": "1cdfcc69-2656-46f6-b7cd-32bd6d162411"
            }
          ],
          "queryString": [],
          "headersSize": 817,
          "postData": {
            "mimeType": "application/json; charset=utf-8",
            "params": [],
            "text": "{\"arguments\":{\"_type\":\"QueryViewArguments\",\"query\":\"(label IN (\\\"stackpack:kubernetes\\\") AND type IN (\\\"service\\\"))\",\"queryVersion\":\"0.0.1\"},\"startTime\":1760012225407,\"histogramBucketCount\":1}"
          }
        },
        "response": {
          "status": 500,
          "statusText": "",
          "httpVersion": "HTTP/2",
          "headers": [
            {
              "name": "date",
              "value": "Thu, 09 Oct 2025 13:17:05 GMT"
            },
            {
              "name": "content-type",
              "value": "application/json"
            },
            {
              "name": "content-encoding",
              "value": "gzip"
            },
            {
              "name": "x-xss-protection",
              "value": "1; mode=block"
            },
            {
              "name": "access-control-allow-origin",
              "value": "https://suse-obs.dev.bcp.mindef.nl"
            },
            {
              "name": "access-control-allow-credentials",
              "value": "true"
            },
            {
              "name": "access-control-allow-headers",
              "value": "Authorization, Content-Type, x-api-csrf"
            },
            {
              "name": "x-xss-protection",
              "value": "1; mode=block"
            },
            {
              "name": "x-frame-options",
              "value": "DENY"
            },
            {
              "name": "x-content-type-options",
              "value": "nosniff"
            },
            {
              "name": "expires",
              "value": "Wed, 01 Jan 1800 00:00:00 GMT"
            },
            {
              "name": "pragma",
              "value": "no-cache"
            },
            {
              "name": "cache-control",
              "value": "no-cache, no-store, max-age=0, must-revalidate"
            },
            {
              "name": "x-sts-username",
              "value": "u-x5hhv"
            },
            {
              "name": "x-envoy-upstream-service-time",
              "value": "9"
            },
            {
              "name": "strict-transport-security",
              "value": "max-age=31536000; includeSubDomains"
            },
            {
              "name": "X-Firefox-Spdy",
              "value": "h2"
            }
          ],
          "cookies": [],
          "content": {
            "mimeType": "application/json",
            "size": 27,
            "text": "{\"message\":\"Unknown error\"}"
          },
          "redirectURL": "",
          "headersSize": 652,
          "bodySize": 705
        },
        "cache": {},
        "timings": {
          "blocked": 0,
          "dns": 0,
          "connect": 0,
          "ssl": 0,
          "send": 0,
          "wait": 25,
          "receive": 0
        },
        "time": 25,
        "_securityState": "secure",
        "serverIPAddress": "10.11.5.197",
        "connection": "443",
        "pageref": "page_1"
      },```

---

**Alejandro Acevedo Osorio** (2025-10-15 09:57):
Exactly as they basically don't hold any permissions to see any data at all.

---

**Daniel Murga** (2025-10-15 09:58):
ok, so it's a matter of checking user bindings in observability

---

**Daniel Murga** (2025-10-15 09:58):
thanks @Alejandro Acevedo Osorio! I think we can improve product documentation to make this process 100% clear for users

---

**Alejandro Acevedo Osorio** (2025-10-15 10:02):
We tried to describe here https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_rancher.html where we talk about the `RoleTemplate`s that matter for Observability ... we mention what rights each RoleTemplate grants. And of course we didn't go into saying how to bind them to a user as that's really a Rancher thing https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permiss[…]l-configuration/manage-role-based-access-control-rbac (https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/manage-role-based-access-control-rbac) but perhaps we need to make a link over there.
What do you think would make it clearer?

---

**Daniel Murga** (2025-10-15 10:05):
let me check it carefully

---

**Alejandro Acevedo Osorio** (2025-10-15 10:06):
Sure thing :+1:  ...

---

**Daniel Murga** (2025-10-15 12:36):
That's what customer is getting:

---

**Devendra Kulkarni** (2025-10-15 13:26):
Hello Team,

We're thinking of submitting a talk/CFP on Rancher RBAC with SUSE observability.
Do you have any test cases that you have tested and can share guidelines on it? As I understand this is pretty new and customer would definitely be benefitted. Or is someone from the engineering team is already sharing insights on this topic?

---

**Frank van Lankvelt** (2025-10-15 13:45):
cool!  I'm not aware of anyone submitting talks to conferences about this topic - maybe @Mark Bakker knows more about this?

The use cases we had in mind when implementing were to support granting access on rancher instance level (everything from all clusters), cluster level (all projects from one cluster) and project level.  And then across all observability data - topology, metrics, traces, events &amp; logs.

As part of this effort we streamlined the whole Observability RBAC as well, making it possible to e.g. expose metrics data for a single cluster to grafana. (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/metrics/k8s-stackstate-grafana-datasource.html)

---

**Alejandro Acevedo Osorio** (2025-10-15 13:46):
yup, matches with my expectation and what tried to describe. User could login, but sees no data and even some calls get `Forbidden`

---

**Frank van Lankvelt** (2025-10-15 13:54):
I don't think we have that indeed.  Maybe a bit implicitly in the documentation for Kubernetes - but that only works for data coming from pods.

---

**Bram Schuur** (2025-10-15 13:55):
gotcha, i will write a ticket for that

---

**Bram Schuur** (2025-10-15 13:56):
story: https://stackstate.atlassian.net/browse/STAC-23561

---

**David Noland** (2025-10-15 18:27):
Yes, noticed that too, some metrics come through, but not everything.

---

**IHAC** (2025-10-15 20:03):
@Garrick Tam has a question.

:customer:  Disney Cruises

:facts-2: *Problem (symptom):*  
Customer's non-HA server pod is in CrashLoopBackOff state.  Ultimately, it change state from running to failing.
```2025-10-15 15:59:54,076 INFO  com.stackstate.servicemanager.StackStateServiceManagerImpl - Service StateServiceEvents changed state to Running Failing(Failed to initialize: Element does not exist 178489701701338.) from Some(Running IsRunning).```
Anyway to rectify this condition?

Customer try to upgraded from v2.5.0 to v2.6.1 to see if the condition recovers but reported the error state remains.  I'll include the supportbundle logs from both v2.5.0 and v2.6.1.

---

**Garrick Tam** (2025-10-15 20:05):
support log bundles attached.

---

**Garrick Tam** (2025-10-15 20:49):
Deployment history: We have been running this for several months, but it has been rebuilt a few times and all of the PVCs have been dropped and recreated as recently as a few weeks ago. I don't know when this particular problem started.
We did have node patching last week, so it is possible it never recovered from the pod migrations during the node reboots.

---

**Daniel Murga** (2025-10-16 08:08):
ok, I'm checking within the team as it seems to be a recurrent issue, I'm still reviewing the documentation to provide my feedback, I'll keep you updated in both points. Thanks @Alejandro Acevedo Osorio

---

**Remco Beckers** (2025-10-16 08:53):
This is indeed a custom development that used to be part of the standard product in StackState 5.1 and earlier.

@Louis Parkin I believe you've been working on this together with Rabobank recently to iron out the details in their environment.

---

**Remco Beckers** (2025-10-16 08:53):
Can you have a look?

---

**Bram Schuur** (2025-10-16 08:54):
I will take a look here with @Alessio Biancalana

---

**Remco Beckers** (2025-10-16 08:54):
:thumbs-up:

---

**Daniel Murga** (2025-10-16 08:55):
Thanks guys! Do I need to communicate something to customer? I just told them that there's some communication evidences in the logs...

---

**Bram Schuur** (2025-10-16 09:20):
hmm, unfortunately the logs don't tell us why the saved search is being retried

---

**Bram Schuur** (2025-10-16 09:28):
@Daniel Murga i'd recommend upping the `default_search_max_retry_count` for the health integration, or upping the `default_search_seconds_between_retries` . In the configmap for health is see:
```- apiVersion: v1                                                                                                                 
  data:                                                                                                                          
    conf.yaml: |                                                                                                                 
      init_config:                                                                                                               
        # time before a HTTP request times out                                                                                   
        default_request_timeout_seconds: 300                                                                                     
                                                                                                                                 
        # a search on a saved search does not immediately return results, one has to retry until data is received,               
        # search_max_retry_count specifies the number of retries in which it expects results to be available.                    
        # Between each retry some time is waited before retrying, specified by search_seconds_between_retries.                   
        default_search_max_retry_count: 10                                                                                       
        default_search_seconds_between_retries: 1                                                                                
                                                                                                                                 ```
It seems 10 seconds (default_search_max_retry_count * default_search_seconds_between_retries) is not enough for splunk  so lets up the retry count here to give it more time to retrieve the result

---

**Bram Schuur** (2025-10-16 09:28):
Couldyou communicate that to customer?

---

**Daniel Murga** (2025-10-16 09:30):
sure! should I suggest 30 for example?

---

**Bram Schuur** (2025-10-16 09:31):
yrah that makes sense

---

**Bram Schuur** (2025-10-16 09:35):
@Frank van Lankvelt do you have a moment on discord so we can turn this into stories?

---

**Daniel Murga** (2025-10-16 09:44):
Just one thing... we've got 2 configmaps:

*splunk-health-integration-yaml:*

```apiVersion: v1
kind: ConfigMap
metadata:
  name: splunk-health-integration-yaml
  namespace: suse-observability
data:
  conf.yaml: |
    init_config:
      default_request_timeout_seconds: 300
      default_search_max_retry_count: 10 &lt;----- SUGGEST TO CHANGE TO '30'
      default_search_seconds_between_retries: 1
      default_saved_searches_parallel: 10
      default_batch_size: 1000
      default_verify_ssl_certificate: false
      default_app: "search"
      
    instances:
      - url: "https://81ce199f-a411-4058-b746-3e416c40d770.eu.api.rabo.cloud"
        collection_interval: 120  # 2 minutes
        verify_ssl_certificate: false
        authentication:
          token_auth:
            name: "nobody"
            initial_token: ${INITIAL_TOKEN}
            audience: "search"
            token_expiration_days: 900
            renewal_days: 1
        ignore_saved_search_errors: false
        saved_searches:
          - match: "stackstate.health.*"
            app: "app_aemon"```
*splunk-integration-yaml:*

```apiVersion: v1
kind: ConfigMap
metadata:
  name: splunk-integration-yaml
  namespace: suse-observability
data:
  conf.yaml: |
    init_config:
      default_request_timeout_seconds: 300
      default_search_max_retry_count: 20    # Different from health!
      default_search_seconds_between_retries: 5    # Different from health!
      default_saved_searches_parallel: 10
      default_batch_size: 1000
      
    instances:
      - url: "https://81ce199f-a411-4058-b746-3e416c40d770.eu.api.rabo.cloud"
        collection_interval: 900  # 15 minutes
        verify_ssl_certificate: false
        authentication:
          token_auth:
            name: "nobody"
            initial_token: ${INITIAL_TOKEN}
            audience: "search"
            token_expiration_days: 900
            renewal_days: 1
        ignore_saved_search_errors: false
        component_saved_searches:
          - match: "stackstate.topo.*"
            app: "app_aemon"
        relation_saved_searches:
          - match: "stackstate.rel.*"
            app: "app_aemon"```
You're suggesting to increase *`default_search_max_retry_count`* in *`splunk-health-integration-yaml`*   right?

---

**Bram Schuur** (2025-10-16 09:44):
indeed, the health was giving the trouble, topology seems to have been changed already

---

**Bram Schuur** (2025-10-16 09:45):
We could also use the same settings as the topology one in health:
```      default_search_seconds_between_retries: 5    # Different from health!
      default_saved_searches_parallel: 10```

---

**Bram Schuur** (2025-10-16 09:48):
ah sorry, it is your day off, @Alejandro Acevedo Osorio do you have a moment?

---

**Vladimir Iliakov** (2025-10-16 09:49):
<!subteam^S08HEN1JX50> I suspect the problem with the agent, can you please help here?

---

**Alejandro Acevedo Osorio** (2025-10-16 09:49):
@Akash Raj @Bram Schuur more feedback on documentation coming from here

---

**Alejandro Acevedo Osorio** (2025-10-16 09:51):
sure, give me a moment

---

**Daniel Murga** (2025-10-16 09:52):
by the way... customer fixed the issue applying "something"... I'm trying to get more details but customer seems to be a little bit obscure

---

**Alejandro Acevedo Osorio** (2025-10-16 09:53):
that would be nice as it can be something we highlight in the docs

---

**Daniel Murga** (2025-10-16 09:59):
done! Let's wait their feedback

---

**Louis Parkin** (2025-10-16 10:01):
@Amol Kharche is this in ongoing issue? Or is it an intermittent issue?

---

**Louis Parkin** (2025-10-16 10:04):
My prompt was not biased for or against the agent in any way:
```I am troubleshooting an issue with the stackstate-agent (suse-observability-agent).  Logs are in /home/louis/Downloads/suse-observability_logs_20251015092632.  The complaint from the customer is that metrics data from cluster `centene-lab` is missing.  Could you check the logs and config to see if there is an obvious issue?```

---

**Vladimir Iliakov** (2025-10-16 10:08):
The problem is still present. The tenant is deployed to our cluster. The issue with at least one metric: container_cpu_usage, it is present for other clusters, but not for `centene-lab` . The other metrics from `centene-lab` are there.

---

**Louis Parkin** (2025-10-16 10:13):
I see.  Do I have access to this environment?

---

**Vladimir Iliakov** (2025-10-16 10:16):
You should have a sign-up link to the tenant in your mailbox by now.

---

**Devendra Kulkarni** (2025-10-16 10:33):
So I had a call with the customer and indeed the setup is what I mentioned.

```KeyCloak -&gt; Rancher -&gt; Observability```
For the default admin user, the issue is:

```Rancher -&gt; Downstream cluster -&gt; Loops back to Rancher Home screen```
Workaround for default admin user:
```Login to Observability first -&gt; Go to Rancher Home -&gt; Downstream cluster```
For other users in keycloak,
```Keycloak User -&gt; Rancher -&gt; DS cluster all works fine.```
Issue with other users:
```Although they can login to DS cluster, the Workloads -&gt; Pods -&gt; Health columns shows "Loading" although the user is having SUSE Observability Observer role.```

---

**Devendra Kulkarni** (2025-10-16 10:33):
@Bram Schuur @Alejandro Acevedo Osorio Have you guys come across such situation?

---

**Devendra Kulkarni** (2025-10-16 10:34):
I am having a setup ready with Rancher + Observability configured with Rancher RBAC. I am going to add Keycloak authentication to my Rancher instance and try to reproduce the issue

---

**Bram Schuur** (2025-10-16 10:35):
Some tickets were logged to improve the docs/setup around this, let me know whether you find something not matching what you'd want @Daniel Murga:
• https://stackstate.atlassian.net/browse/STAC-23581
• https://stackstate.atlassian.net/browse/STAC-23582
• https://stackstate.atlassian.net/browse/STAC-23583

---

**Bram Schuur** (2025-10-16 10:36):
Some tickets were logged to improve the docs/setup around this, let me know whether you find something not matching what you'd want @Devendra Kulkarni
• https://stackstate.atlassian.net/browse/STAC-23581
• https://stackstate.atlassian.net/browse/STAC-23582
• https://stackstate.atlassian.net/browse/STAC-23583

---

**Alejandro Acevedo Osorio** (2025-10-16 10:41):
That resembles this bug tickets @Frank van Lankvelt is working on
• https://stackstate.atlassian.net/browse/STAC-23545
• https://stackstate.atlassian.net/browse/STAC-23512
At least the first one with the logout part
@Rajukumar Macha this is apparently the same case, what do you think?

---

**Vladimir Iliakov** (2025-10-16 10:42):
I sent you creds directly. In the meantime I will check why welcome messages don't work.

---

**Devendra Kulkarni** (2025-10-16 10:45):
Yes its the same case, I can confirm that. Earlier it was handled by Rancher Support team and now its with us

---

**Alejandro Acevedo Osorio** (2025-10-16 10:45):
@Rajukumar Macha is doing the QA on the extension fixes. Not sure if it's relevant that you take a look together

---

**Devendra Kulkarni** (2025-10-16 10:46):
Second issue is not the same, since with this customer they are not using observability extension, they cannot see the pod health when logged in using non-admin user

---

**Louis Parkin** (2025-10-16 10:59):
:thumbs-up:

---

**Louis Parkin** (2025-10-16 10:59):
I got the mail from you

---

**Louis Parkin** (2025-10-16 10:59):
Still no welcome mail

---

**Louis Parkin** (2025-10-16 11:00):
Just in case you wondered.

---

**Vladimir Iliakov** (2025-10-16 11:07):
No wondering anymore, I found the issue and fixing it now.

---

**Louis Parkin** (2025-10-16 11:13):
@Vladimir Iliakov what do you think about this...?  Live view, no metrics:

---

**Louis Parkin** (2025-10-16 11:13):
Oct 10, just after the rancher pod metrics went missing:

---

**Louis Parkin** (2025-10-16 11:20):
Live view of agent pods, no metrics.

---

**Louis Parkin** (2025-10-16 11:21):
Same view around the time the rancher pod metrics went missing:

---

**Vladimir Iliakov** (2025-10-16 11:40):
The all two nodes were restarted at that time...

---

**Vladimir Iliakov** (2025-10-16 11:42):
But nothing changed at the infra side
```before restart:
nodeInfo:
  architecture: amd64
  bootID: e7068e78-848b-4ccf-ae69-1895e4f581cb
  containerRuntimeVersion: <containerd://2.0.5-k3s2.32>
  kernelVersion: 6.4.0-150600.23.70-default
  kubeletVersion: v1.31.12+k3s1
  kubeProxyVersion: v1.31.12+k3s1
  machineID: ec2370c9728e2de8e736799cb2700702
  operatingSystem: linux
  osImage: SUSE Linux Enterprise Server 15 SP6
  systemUUID: ec2370c9-728e-2de8-e736-799cb2700702

after restart
nodeInfo:
  architecture: amd64
  bootID: d2d9c672-38f8-49fd-afa1-5c08199d018a
  containerRuntimeVersion: <containerd://2.0.5-k3s2.32>
  kernelVersion: 6.4.0-150600.23.70-default
  kubeletVersion: v1.31.12+k3s1
  kubeProxyVersion: v1.31.12+k3s1
  machineID: ec2d07fd95dab9ac9bb49f92a8a25a35
  operatingSystem: linux
  osImage: SUSE Linux Enterprise Server 15 SP6
  systemUUID: ec2d07fd-95da-b9ac-9bb4-9f92a8a25a35```

---

**Louis Parkin** (2025-10-16 11:43):
Is there a cadvisor pod running somewhere?

---

**Louis Parkin** (2025-10-16 11:44):
```bootID: e7068e78-848b-4ccf-ae69-1895e4f581cb```
vs
```bootID: d2d9c672-38f8-49fd-afa1-5c08199d018a```

---

**Louis Parkin** (2025-10-16 11:44):
IP addresses?

---

**Vladimir Iliakov** (2025-10-16 11:56):
IP addresses were changed, you can see it at my screenhots.

---

**Louis Parkin** (2025-10-16 11:58):
And my cadvisor question?

---

**Vladimir Iliakov** (2025-10-16 12:05):
I didn't find any pod with cadvisor in the name. At least on the pod view.

---

**Daniel Murga** (2025-10-16 12:17):
That's what customer provided:

"I noticed that we were seeing ssl errors in the rbac agent, even though we added ignore ssl in all sections of the values.
-      As we are using self-signed certificates I used your article to add our certificate chain, this did not resolve the issue
-      I checked if the chain was deployed to the configmap, this was present
-      Checked other deployments they were working fine, but noticed that there was a volume mounted to the cm
-      Checked the rbac agent, this was missing the cm volume. This must be a config issue in the helmchart.
-      Checked the release charts for the agent and we were a few versions behind (1.0.66)
-      Updated the agent chart and everything was working

Regards, Eric"

---

**Louis Parkin** (2025-10-16 12:18):
Gotcha, thanks.

---

**Louis Parkin** (2025-10-16 12:18):
cc @Mark Bakker this is the thread I was referring to.

---

**Vladimir Iliakov** (2025-10-16 12:26):
```suse-observability-hbase-hbase-rs-0                               1/1     Running    0                 17h   100.74.9.51     cl02-n070    <none>           <none>
suse-observability-hbase-hbase-rs-1                               1/1     Running    0                 17h   100.74.6.237    cl02-n068    <none>           <none>
suse-observability-hbase-hbase-rs-2                               1/1     Running    0                 17h   100.74.8.122    cl02-n067    <none>           <none>
suse-observability-hbase-hbase-rs-3                               1/1     Running    0                 17h   100.74.30.110   cl02-n015    <none>           <none>
suse-observability-hbase-hbase-rs-4                               1/1     Running    0                 17h   100.74.25.174   cl02-n011    <none>           <none>
s```
~That looks strange, it has to be only 3 replicas of suse-observability-hbase-hbase-rs.~
NVM, it is a valid case for 4000-ha profile.

---

**Daniel Murga** (2025-10-16 12:53):
@Bram Schuur I reviewed the JIRA's, all fine. thanks!

---

**Saurabh Sadhale** (2025-10-16 13:12):
Sorry but just for my information is this information in a configmap ? How do you check that ?

---

**Vladimir Iliakov** (2025-10-16 13:17):
@Alejandro Acevedo Osorio can you please have a look?

---

**Alejandro Acevedo Osorio** (2025-10-16 13:38):
@Saurabh Sadhale usually the mitigation action when we find a Region that is not serving is to restart HBase masters and HBase region servers. Can you try that?

---

**Saurabh Sadhale** (2025-10-16 13:40):
okay let me try that once. I will keep you posted.v

---

**Alejandro Acevedo Osorio** (2025-10-16 13:55):
And when you mention `After upgrading the k8s cluster`  ... is a like a node upgrades. Draining the nodes one by one, etc?

---

**Daniel Murga** (2025-10-16 15:04):
Answer from customer:
```Hi Daniel,

We fixed the saved search stackstate.health.doca and are looking for similar issues with searches.

In the mean while we'll roll out the suggest change in the settings on our PA environment and let it run overnight before implementing the change on our Production environment.

Any other suggestions are welcome.

With kind regards,

Karan Bahadoer```
I asked them to provide details how they fixed the issue

---

**Bram Schuur** (2025-10-16 15:04):
@Daniel Murga awesome, thanks

---

**Alejandro Acevedo Osorio** (2025-10-16 15:34):
```Caused by: java.lang.IllegalArgumentException: Overflow when reading key length at position=0, KeyValueBytesHex=, offset=0, length=0```
Seems to be persistent.

---

**Alejandro Acevedo Osorio** (2025-10-16 15:43):
Did they share they process about upgrading their clustee?

---

**Saurabh Sadhale** (2025-10-16 15:45):
I have asked them now. I missed it earlier. Will share here soon.

---

**Garrick Tam** (2025-10-16 15:48):
Can someone please help on this?

---

**Vladimir Iliakov** (2025-10-16 16:12):
&gt; Deployment history: We have been running this for several months, but it has been rebuilt a few times and all of the PVCs have been dropped and recreated as recently as a few weeks ago. I don't know when this particular problem started
Regarding this note:
The pvc-s are 20 days old
```persistentvolumeclaim/data-suse-observability-clickhouse-shard0-0             Bound    pvc-9b1075c0-6369-46aa-97d1-946654a44266   50Gi       RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/data-suse-observability-elasticsearch-master-0          Bound    pvc-9e3b977d-1390-409b-8e99-c6f0adfc6742   50Gi       RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/data-suse-observability-hbase-stackgraph-0              Bound    pvc-058941ef-1793-422b-a34f-96ed653ab64b   100Gi      RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/data-suse-observability-kafka-0                         Bound    pvc-6d5c7391-5402-4fb7-8826-8e55f51482c9   100Gi      RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/data-suse-observability-zookeeper-0                     Bound    pvc-66ddfe67-3f2f-427e-bfaa-031376273f34   8Gi        RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/server-volume-suse-observability-victoria-metrics-0-0   Bound    pvc-adb6b76a-2fc6-41cd-b4ad-55793c456735   50Gi       RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem
persistentvolumeclaim/snapshot-suse-observability-hbase-tephra-mono-0         Bound    pvc-2c7e3e10-c195-408d-b638-a7542f648661   1Gi        RWO            vsphere-csi-sc   &lt;unset&gt;                 10m   Filesystem
persistentvolumeclaim/suse-observability-settings-backup-data                 Bound    pvc-acc39aa3-1b94-402c-8607-0addbdd3820c   1Gi        RWO            vsphere-csi-sc   &lt;unset&gt;                 13d   Filesystem
persistentvolumeclaim/suse-observability-stackpacks                           Bound    pvc-dcdfd6cc-68f8-46ae-b0c6-261a1125d73c   1Gi        RWO            vsphere-csi-sc   &lt;unset&gt;                 13d   Filesystem
persistentvolumeclaim/suse-observability-stackpacks-local                     Bound    pvc-62df9f11-0a9c-4425-bb06-0019625591ab   1Gi        RWO            vsphere-csi-sc   &lt;unset&gt;                 13d   Filesystem
persistentvolumeclaim/tmpdata-suse-observability-vmagent-0                    Bound    pvc-8a9f28d7-5569-43b4-a79e-60cd5a25a31f   10Gi       RWO            vsphere-csi-sc   &lt;unset&gt;                 20d   Filesystem```
whereas Statefulsets were created 13 days ago
```NAME                                      READY   AGE     CONTAINERS                  IMAGES
suse-observability-clickhouse-shard0      1/1     13d     clickhouse,backup           registry.rancher.com/suse-observability/clickhouse:24.12.3-debian-12-r1-59d02972,registry.rancher.com/suse-observability/clickhouse-backup:2.6.38-9157204e (http://registry.rancher.com/suse-observability/clickhouse:24.12.3-debian-12-r1-59d02972,registry.rancher.com/suse-observability/clickhouse-backup:2.6.38-9157204e)
suse-observability-elasticsearch-master   1/1     13d     elasticsearch               registry.rancher.com/suse-observability/elasticsearch:8.19.4-8fb32031 (http://registry.rancher.com/suse-observability/elasticsearch:8.19.4-8fb32031)
suse-observability-hbase-stackgraph       1/1     13d     stackgraph                  registry.rancher.com/suse-observability/stackgraph-hbase:2.5-7.11.11 (http://registry.rancher.com/suse-observability/stackgraph-hbase:2.5-7.11.11)
suse-observability-hbase-tephra-mono      1/1     9m52s   tephra                      registry.rancher.com/suse-observability/tephra-server:2.5-7.11.11 (http://registry.rancher.com/suse-observability/tephra-server:2.5-7.11.11)
suse-observability-kafka                  1/1     13d     kafka,jmx-exporter          registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402,registry.rancher.com/suse-observability/jmx-exporter:0.17.0-e3374eb0 (http://registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402,registry.rancher.com/suse-observability/jmx-exporter:0.17.0-e3374eb0)
suse-observability-otel-collector         1/1     9m51s   opentelemetry-collector     registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.20 (http://registry.rancher.com/suse-observability/sts-opentelemetry-collector:v0.0.20)
suse-observability-victoria-metrics-0     1/1     13d     victoria-metrics-0-server   registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-accea47f (http://registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-accea47f)
suse-observability-vmagent                1/1     13d     vmagent                     registry.rancher.com/suse-observability/vmagent:v1.109.0-e6dc53fb (http://registry.rancher.com/suse-observability/vmagent:v1.109.0-e6dc53fb)
suse-observability-zookeeper              1/1     13d     zookeeper                   registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7 (http://registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7)```
It looks like it was re-installed without purging the pvc-s. Might it be a cause for the errors?

---

**Garrick Tam** (2025-10-16 16:23):
Customer opened case 20 days ago where they ended up having to clear out the PVCs and reinstall in order to recover.  --&gt; https://suse.slack.com/archives/C07CF9770R3/p1758732377934379

---

**Garrick Tam** (2025-10-16 16:24):
Also, I know multiple customers (without our instructions) are redeploying without clearing PVCs.  That's their way of maintaining the existing data from a reinstall.  Sound like this is not a good practice but more importantly if customer should never do this we need to explicitly express this in our documentation.

---

**Alejandro Acevedo Osorio** (2025-10-16 16:25):
Well @Saurabh Sadhale the thing does look like Data Corruption on hbase and hdfs. Do you know if the customer when deploying added the `affinity_values.yaml` https://documentation.suse.com/cloudnative/suse-observability/latest/en/k8s-suse-rancher-prime.html#_installation

---

**David Noland** (2025-10-16 22:26):
Is https://rancher-hosted.app.stackstate.io down? Pages are blank

---

**David Noland** (2025-10-16 22:27):
browser console showing this

---

**David Noland** (2025-10-16 22:37):
I tried another browser and appears to work ok.

---

**Garrick Tam** (2025-10-17 01:19):
Appreciate help to confirm the issue and identify solution.

---

**Remco Beckers** (2025-10-17 07:49):
Did you try a hard refresh of the page? Ctrl+R or Cmd+R (or on windows with Ctrl+F5)

---

**Remco Beckers** (2025-10-17 07:50):
It did get a recent version bump but that should normally not lead to issues loading the page

---

**David Noland** (2025-10-17 07:51):
I did try that and didn't help. It's now working again. Not sure if it was an intermittent issue on my side or server side.

---

**Remco Beckers** (2025-10-17 07:54):
Upgrading while keeping the PVCs is the logical thing to do, that keeps your data which is desirable with an upgrade obviously.

When re-installing because there was an issue (like in this example) or to switch from a non-HA to an HA profile (or vice-versa) we recommend to always delete the PVCs. If you keep the PVCs it will not be a clean install and any issues may persist. When switching profiles several databases have a different way of storing data for HA vs non-HA and will not properly work if the data from the other setup is still present

---

**Remco Beckers** (2025-10-17 08:00):
Based on the data @Vladimir Iliakov found it looks like they did a clean install, with new PVCs, 20 days ago. Then, for some reason, another uninstall + new install 13 days ago. The latter however with the same PVCs. That doesn't have to be a problem if there were no issues and the same profile was used.

---

**Remco Beckers** (2025-10-17 08:03):
The issue they have now looks very similar to the one in the linked thread that was fixed in version 2.6.0. The fix only prevents the issue from occurring, if it is already present it does not fix it. So doing an upgrade doesn't fix it indeed.

---

**Remco Beckers** (2025-10-17 08:04):
I still need to check if the issue is the exact same issue as before or if it is unrelated.

---

**Garrick Tam** (2025-10-17 08:07):
I can check and confirm with customer if they reinstall 13 days ago reusing preexisting pv.  I was going to ask following but let’s wait for your full analysis.  “Is the only way forward to reinstall with fresh blank PVs?   As it sounds like even backup isn’t any good unless the backup is from prior to the reinstall over existing PVs, right?”

---

**Remco Beckers** (2025-10-17 08:09):
The answer is: it depends. The reinstall over existing PVCs could have been fine if it was jsut an elaborate way of doing `helm upgrade`, but that seems a bit unlikely to be honest.

---

**Remco Beckers** (2025-10-17 08:09):
So I think the safe thing to do, and quickest way to resolve the issue, is a clean reinstall (including removing the PVCs)

---

**Remco Beckers** (2025-10-17 08:28):
@Bram Schuur or @Alejandro Acevedo Osorio I can't find any specific cause in the logs. But could this be caused by the same issue they previously had (it happened on 2.5.0, so before the fix): https://stackstate.atlassian.net/browse/STAC-23312#icft=STAC-23312.

---

**Remco Beckers** (2025-10-17 08:31):
I do see some problematic behavior that can contribute to this occuring and that doesn't look like a healthy setup:
•  a lot of restarts for both the stackgraph-hbase and tephra pods. 
• Some restarts are caused by a SIGTERM (i.e. Kubernetes shutting the container down)
• Others (in this case hbase-stackgraph) stopped due to very long GC pauses (and getting disconnected from Zookeeper because of that).
Based on this, it looks like the cluster may have limited capacity and/or they are running with a profile that is just too small for the cluster size.

@Garrick Tam Do you know what profile they are running and what their cluster size is (#cores and total memory) ?

---

**Remco Beckers** (2025-10-17 08:35):
I don't see any errors on the server-side either.

---

**Remco Beckers** (2025-10-17 08:38):
Completely unrelated but maybe useful to know: something is sending data with an invalid service token, from the logs I see it is likely an rbac-agent.

---

**Bram Schuur** (2025-10-17 08:43):
@Remco Beckers https://stackstate.atlassian.net/browse/STAC-23312#icft=STAC-23312 could have for sure cause the missing element error

---

**Remco Beckers** (2025-10-17 08:44):
Ok cool. That means my suggestion to do a clean install, now using 2.6.1, should resolve the issue and hopefully avoid it from happening again.

---

**Bram Schuur** (2025-10-17 08:57):
Yes agred @Remco Beckers

Although repeated restarts and SIGTERMs/GC puases on a non-ha setup are also suspect and can causes issues due to the non-ha nature of the setup. @Garrick Tam i would recommend monitoring the instance more closely after reinstall, if pods get restarted/killed or go OOM after resinstall. If that happens please contact us again, because the profiles should be sized so that they can take the workload with oom/pod terminations.

I see the profile is 50-nonha

---

**Remco Beckers** (2025-10-17 08:59):
Oh damn, could have seen that myself too.

But would still be good to know what the actual size is. The frequent restarts won't help for sure.

---

**Devendra Kulkarni** (2025-10-17 09:23):
Hello Team,

I have following working setup:
```Keycloak -&gt; Rancher -&gt; SUSE observability```
Issue 1: Keycloak User having SUSE Observability Cluster Observer cannot see the actual Health status of the workload.

Although workload shows "CLEAR" state in Observability UI, in Rancher it shows "Unknown".

Let me know if a JIRA is needed or we already know this.

---

**Frank van Lankvelt** (2025-10-17 09:26):
could you create a HAR of a full page reload of Rancher on the workload page?

---

**Devendra Kulkarni** (2025-10-17 09:26):
I have this setup ready now but I was not able to reproduce the issue. For me, the authentication worked well and Rancher RBAC works well too.

---

**Alessio Biancalana** (2025-10-17 09:26):
I would also ask for JS console logs, maybe they shed some light

---

**Bram Schuur** (2025-10-17 09:28):
@Frank van Lankvelt out of curiosity: do we use the service token from the rancher install or the actual rancher user credentials when we populate those states? (I was under the impression it was the former, but if that is the case, that might not be the right setup in an RBAC scenario)

---

**Devendra Kulkarni** (2025-10-17 09:29):
here you go

---

**Frank van Lankvelt** (2025-10-17 09:29):
we should and do use the service token.

---

**Bram Schuur** (2025-10-17 09:29):
gotcha @Frank van Lankvelt

---

**Frank van Lankvelt** (2025-10-17 09:30):
in the latest release (2.2.7) there were some interactions between rancher and observability browser sessions.  There is a new release (2.2.8) that addresses those, but that has not yet been published to the ui-plugin-charts helm repo

---

**Frank van Lankvelt** (2025-10-17 09:42):
looks like the user cannot read the observability configuration - can you check if the `suse-observability-rancher` cluster role &amp; binding are present in the local cluster?

---

**Devendra Kulkarni** (2025-10-17 09:46):
I dont see any cluster role named `suse-observability-rancher`

---

**Frank van Lankvelt** (2025-10-17 09:47):
we've created a new version (2.2.8) that should fix these kind of multi-browser-session issues.  It is available in our pre-release repository https://stackvista.github.io/rancher-extension-stackstate and should soon end up in the official ui-plugin-charts repo as well

---

**Devendra Kulkarni** (2025-10-17 09:49):
This setup does not use the Observability UI Extension.

https://stackstate.atlassian.net/browse/STAC-23545 is the issue where customer is not able to click on a Downstream cluster unless he logs into SUSE Observability UI. But I am not able to reproduce this issue.

---

**Devendra Kulkarni** (2025-10-17 09:50):
For this,
Issue with other users:
```Although they can login to DS cluster, the Workloads -&gt; Pods -&gt; Health columns shows "Loading" although the user is having SUSE Observability Observer role.```
I see "Unknown" state instead of "Loading" and Observability UI shows "CLEAR"

---

**Frank van Lankvelt** (2025-10-17 09:50):
that's weird - the helm install of the plugin should have taken care of that

---

**Devendra Kulkarni** (2025-10-17 09:50):
this is what we are discussing in the new thread

---

**Devendra Kulkarni** (2025-10-17 09:51):
I want to know more on https://stackstate.atlassian.net/browse/STAC-23545 what to check in customer's setup? what logs would you need to further test/debug this?

---

**Devendra Kulkarni** (2025-10-17 09:51):
I am not using Observability UI plugin

---

**Devendra Kulkarni** (2025-10-17 09:54):
This is a normal setup...
[1] Keycloak server
[2] Rancher 2.12.1
[3] Observability cluster

• Keycloak authenticates to Rancher
• Rancher configured to be OIDC provider for SUSE Observability
• Keycloak users hit the Observability URL -&gt; Goes to Rancher -&gt; Login via keycloak creds -&gt; Observability UI loads -&gt; Workload status - Clear
• Keycloak users hit the Rancher URL -&gt; Goes to DS cluster -&gt; Workloads -&gt; Pods -&gt; Pod status -&gt; Unknown for me / Loading for customer

---

**Saurabh Sadhale** (2025-10-17 09:57):
Customer confirmed that they had added  affinity_values.yaml and the other two helm value files as well while installing. No manual changes to the affinity values file, only to the sizing_values.yaml (setting the proper storageClass for our environment).

---

**Frank van Lankvelt** (2025-10-17 09:58):
I don't know how to bring this gently - but you do have the Observability UI Extension installed.  The icon is in your screenshots and the CRDs are in your HAR

---

**Frank van Lankvelt** (2025-10-17 09:59):
maybe it has not been configured yet - which would explain why the health state is UNKNOWN

---

**Devendra Kulkarni** (2025-10-17 10:00):
Yeah I mean its not configured, and maybe my colleague installed the extension. I didn't

---

**Devendra Kulkarni** (2025-10-17 10:01):
So for the Health to be displayed correctly in Rancher, UI extension is must?

---

**Frank van Lankvelt** (2025-10-17 10:03):
umm - yes.  Otherwise Rancher does not know where to find Observability and does not have the credentials to access it

---

**Bram Schuur** (2025-10-17 10:04):
i am surprised the health column does show up even though the extension is not installed, do you know why that is @Frank van Lankvelt?

---

**Frank van Lankvelt** (2025-10-17 10:04):
that's because it IS installed

---

**Frank van Lankvelt** (2025-10-17 10:04):
it's just not  configured

---

**Bram Schuur** (2025-10-17 10:04):
oo sorry, my bad, i am not reading proper

---

**Devendra Kulkarni** (2025-10-17 10:05):
but then in customer's cluster the pod health shows "Loading" although its Clear in Obs UI

---

**Devendra Kulkarni** (2025-10-17 10:31):
I have setup a call with customer Monday October 20 -&gt; 2:30 PM IST for checking the issue mentioned here - https://stackstate.atlassian.net/browse/STAC-23545

---

**Devendra Kulkarni** (2025-10-17 10:32):
@Frank van Lankvelt Do you want me to extend invite to you?

---

**Frank van Lankvelt** (2025-10-17 10:58):
TBH I'ld rather not join.

---

**Frank van Lankvelt** (2025-10-17 10:59):
let me try to come up with some scenarios that could lead to the "Loading" state though

---

**Devendra Kulkarni** (2025-10-17 11:01):
Okay, and what could be wrong with https://stackstate.atlassian.net/browse/STAC-23545? I am unable to reproduce this, but not sure what can cause this? This issue started only when customer started using Rancher Rbac for Observability.

---

**Frank van Lankvelt** (2025-10-17 11:08):
for that "logout" issue, I don't have a reproduction path either - but the 2.2.7 (and earlier) did use Rancher's Vuex stores to send requests to Observability.  Those however assumed to all be directed to Rancher itself - so would redirect to login when some error was returned.  The new release (2.2.8 - see above) no longer does that.  So if the customer CAN still reproduce it, I would urge them to install the newer version.

---

**Frank van Lankvelt** (2025-10-17 11:11):
The "Loading" issue is most likely caused by the Rancher user not being able to read the configuration.  The helm chart for the Observability UI Extension added a cluster role / binding that should take care of this - both named`suse-observability-rancher`

---

**Devendra Kulkarni** (2025-10-17 11:12):
Okay, so basically trying out the new 2.2.8 extension should fix the issue

---

**Devendra Kulkarni** (2025-10-17 11:12):
I will test it locally before the call on Monday

---

**Louis Parkin** (2025-10-17 11:29):
@Bram Schuur ticket (https://stackstate.atlassian.net/browse/STAC-23609) logged

---

**Bram Schuur** (2025-10-17 11:30):
thanks:+1:

---

**Devendra Kulkarni** (2025-10-17 12:22):
Can this happen due to expired tokens?

---

**Bram Schuur** (2025-10-17 12:24):
the service tokens we hand out for the agent do not expire at this moment. However, it could be that they are using the global 'api_key' which cannot be used for rbac, for rbac a service token needs to be generated for each specific cluster form the stackpacks page.

---

**Devendra Kulkarni** (2025-10-17 12:26):
okay, I will check that

---

**David Noland** (2025-10-17 19:49):
Thanks. Let me know if you need any info/logs on the agent side

---

**Bram Schuur** (2025-10-20 09:57):
Dear @Saurabh Sadhale, i took a look together with @Alejandro Acevedo Osorio, it seems like some form of data corruption, throwing off hdfs/hbase.

Could you validate their storage setup, and whether all PVCs are setup to properly store data synchronously ('sync'). Are there other ways in which the underlying datastore could lose data?
We see they are using a 'csi.huawei.com (http://csi.huawei.com)' which we are not to familiar with.

Also, be advised we do not recommend NFS for production setups: https://documentation.suse.com/cloudnative/suse-observability/latest/en/k8s-suse-rancher-prime.html#_storage

---

**Bram Schuur** (2025-10-20 11:04):
@Louis Parkin could this be related to https://stackstate.atlassian.net/browse/STAC-23511?

---

**Bram Schuur** (2025-10-20 11:04):
ah nvm, i see after restart it is stil 1.31

---

**Louis Parkin** (2025-10-20 11:04):
:thumbs-up:

---

**Louis Parkin** (2025-10-20 11:04):
Was just about to mention that

---

**Bram Schuur** (2025-10-20 11:30):
@Vladimir Iliakov @Remco Beckers could you guys take this ticket? my team is pretty swamped with bug tickets right now.

---

**Devendra Kulkarni** (2025-10-20 12:00):
@Alejandro Acevedo Osorio @Bram Schuur Have you seen this issue? Can you help me debug further?

---

**Devendra Kulkarni** (2025-10-20 12:05):
Customer requested a soft escalation as they cannot use SUSE Observability at all, causing their end customers downtime for log collection!

---

**Alejandro Acevedo Osorio** (2025-10-20 12:10):
Well it looks like data corruption. Some hbase files seem to be half written (most likely due to the disk space issues)

---

**Alejandro Acevedo Osorio** (2025-10-20 12:13):
Do you know what profile are they using? I was inspecting the `configmaps` and expected to find `CONFIG_FORCE_stackstate_agents_agentLimit` but I couldn't which is intriguing as basically means the installation does not have any guard if you push too much data.

---

**Devendra Kulkarni** (2025-10-20 12:23):
They are using 50-nonha

---

**Devendra Kulkarni** (2025-10-20 12:23):
Is there a way we can fix this data corruption?

---

**Alejandro Acevedo Osorio** (2025-10-20 12:24):
Just found it ... was looking in the wrong place
```          - name: CONFIG_FORCE_stackstate_agents_agentLimit
            value: "50"```

---

**Devendra Kulkarni** (2025-10-20 12:24):
I do see it in server pod yaml:

``` - name: CONFIG_FORCE_stackstate_agents_agentLimit
        value: "50"```

---

**Alejandro Acevedo Osorio** (2025-10-20 12:27):
https://suse.slack.com/archives/C07CF9770R3/p1760955825442189?thread_ts=1760954037.599939&amp;cid=C07CF9770R3 we don't have a way to fix it right now. I think that best way to go is to restore a configuration backup so they can use the instance again.

---

**Devendra Kulkarni** (2025-10-20 12:30):
Okay, I will inform the customer accordingly and get on call with them to help them backup

---

**Alejandro Acevedo Osorio** (2025-10-20 12:31):
Perhaps is good to verify what kind of data they are ingesting (only k8s data, open telemetry data) to see if we can get an idea of the high disk space usage

---

**Devendra Kulkarni** (2025-10-20 12:32):
I saw they have otel collector deployed, and many clusters connected to it. I will confirm it though once on call with them

---

**Devendra Kulkarni** (2025-10-20 12:33):
For now, simply following https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html should help right?

---

**Alejandro Acevedo Osorio** (2025-10-20 12:34):
@Bram Schuur might be that we want to put somewhere in the docs about increasing the disk space if you have some considerate otel collector traffic. :point_up:

---

**Alejandro Acevedo Osorio** (2025-10-20 12:35):
and then if they can keep/override the disk space the increased disk space. Or of course consider migrating to a bigger profile

---

**Remco Beckers** (2025-10-20 14:42):
We've very recently fixed an issue (https://stackstate.atlassian.net/browse/STAC-23434) in the agent that under specific circumstances (a permission error on a directory) fails to collect CPU and memory metrics for containers. The symptoms look very similar (other metrics for the nodes are present but not container cpu/memory metrics), although it is quite surprising it would appear after a restart of the nodes.

Can you upgrade the agent on the cluster to the latest version that contains the fix? At the moment it runs a version that doesn't have it yet and I have good hopes that it will fix the problem

---

**Alejandro Acevedo Osorio** (2025-10-20 15:29):
the configuration backup is enabled by default. You got the list of available backups
```=== Listing StackGraph backups in local persistent volume...
sts-backup-20251008-0403.sty
sts-backup-20251009-0402.sty
sts-backup-20251010-0402.sty
sts-backup-20251011-0402.sty
sts-backup-20251012-0402.sty
sts-backup-20251013-0402.sty
sts-backup-20251014-0402.sty
sts-backup-20251017-0809.sty
sts-backup-20251017-0810.sty
sts-backup-20251018-0400.st```
But indeed due to the data corruption the restore did not work as we need a stable stackgraph - tephra  in order to do the restore.

---

**Javier Lagos** (2025-10-20 15:32):
My assumption was correct then. Configuration backup didn't work because we needed to perform a restore of stackgraph first.

However,  the list of stackgraph backups didn't work. Was it because of the global parameter?

---

**Alejandro Acevedo Osorio** (2025-10-20 15:33):
the list of backups did work
```-&gt; ./list-configuration-backups.sh
job.batch/configuration-list-backups-20251020t140747 created
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Waiting for pod to start...
=== Listing StackGraph backups in local persistent volume...
sts-backup-20251008-0403.sty
sts-backup-20251009-0402.sty
sts-backup-20251010-0402.sty
sts-backup-20251011-0402.sty
sts-backup-20251012-0402.sty
sts-backup-20251013-0402.sty
sts-backup-20251014-0402.sty
sts-backup-20251017-0809.sty
sts-backup-20251017-0810.sty
sts-backup-20251018-0400.sty
===
=== Cleaning up job configuration-list-backups-20251020t140747
job.batch "configuration-list-backups-20251020t140747" deleted```

---

**Alejandro Acevedo Osorio** (2025-10-20 15:34):
Ohhh I guess it's not on the output but you tried the list of stackgraph backups as well ?

---

**Javier Lagos** (2025-10-20 15:34):
We tried to list the stackgraph backups

---

**Javier Lagos** (2025-10-20 15:34):
list-stackgraph-backups.sh

---

**Javier Lagos** (2025-10-20 15:34):
and the pod never came up

---

**Alejandro Acevedo Osorio** (2025-10-20 15:34):
There your interpretation is correct as well. That does depend on the customer enabling it

---

**Javier Lagos** (2025-10-20 15:35):
all the time waiting on the init container with messages saying about that minio service was not found

---

**Javier Lagos** (2025-10-20 15:35):
Is it possible to enable it now?

---

**Alejandro Acevedo Osorio** (2025-10-20 15:35):
Mmmm that might need some improvement to actually output that the backups are not enabled. Perhaps something for <!subteam^S08HHSW67FE>

---

**Alejandro Acevedo Osorio** (2025-10-20 15:37):
Now it doesn't help to enable it. I guess the easiest course of action would be to scale down stackgraph and tephra. Delete the stackgraph and tephra pvcs. And then do the configuration backup restore

---

**Javier Lagos** (2025-10-20 15:38):
Let me ask the customer to join another call and try to perform those steps

---

**Javier Lagos** (2025-10-20 15:38):
Thanks Alejandro

---

**Alejandro Acevedo Osorio** (2025-10-20 15:40):
no problem, thank you

---

**Vladimir Iliakov** (2025-10-20 15:43):
&gt; Mmmm that might need some improvement to actually output that the backups are not enabled. Perhaps something for <!subteam^S08HHSW67FE>
I will take it into account in the new backup cli.

---

**Alejandro Acevedo Osorio** (2025-10-20 15:57):
Ooops, I wasn't clear enough. After deleting the PVCs then you scale them up again. Wait for them to be stable and then do the restore

---

**Giovanni Lo Vecchio** (2025-10-20 17:03):
FYI - The workaround worked and I closed the case. They are awaiting for the new version and the fix.

Thanks for the help :smile:

---

**Alejandro Acevedo Osorio** (2025-10-20 17:07):
Version `2.6.1` is released. Some other thing besides updating is to make sure that you are using the affinity values config https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/install-stackstate/kubernetes_openshift/affinity.html

---

**David Noland** (2025-10-20 23:21):
ok, bumping agent from 1.0.61 to 1.1.2

---

**David Noland** (2025-10-20 23:32):
I'm seeing memory metrics now for centene-lab, so that appears to have fixed the problem

---

**Daniel Murga** (2025-10-21 08:15):
Morning! I'm resurrecting this thread... customer (Frank van de Pol) replied to the case... I know Rabobank is an "strategic" customer...
October 20, 2025 (https://suse.lightning.force.com/lightning/r/0D5Tr00001DOSuiKAH/view)
```Hi Daniel,

Before we made the change to the doka search the issue rolsolved itself.
I asked the team if we changed anything but that was not the case.
The issue now is that we dont know what caused it or what resolved it and that it can happen at any moment. Do you have any more ideas what we can investigate to try and pinpoint the root cause of this issue?

Best Regards
Frank```
My answer:
```Hello Frank, 

Thanks for the provided information. Just to get a clear understanding, I receive a message through this case from Karan Bahadoer explaining that after some changes in the query/search targeting splunk data, can you please confirm that this fixed the issue? ```
Frank:
```You mean that doka search that took 40 seconds?
That was done a day after I saw that the issue was resolved. We where checking the effect of that change but then I noticed the searches where working since the night before.

Best Regards
Frank```
Me:
```Hello Frank, 

Thanks for the provided information. From our point of view we found no evident issues in the observability logs provided earlier pointing to issues in your deployment, besides our recommendation of increasing default_search_max_retry_count do you need something more from our side?```
Frank:
```Hi Daniel,

I dont see the value of increasing that value from 10 to 20. A search should not need more than 10 retry' s if it does there is something very very wrong and I would expect other signs.

Best Regards
Frank ```
Maybe it's worth that you guys contact the customer? Thanks!

---

**Daniel Murga** (2025-10-21 08:18):
Morning guys! Can you please provide more details about STAC-23279? TIA

---

**Remco Beckers** (2025-10-21 08:36):
The ticket is resolved and released as part of 2.6.0. @Frank van Lankvelt @Alejandro Acevedo Osorio you both were involved with this it seems, can you provide more details?

---

**Daniel Murga** (2025-10-21 08:55):
Nice @Remco Beckers should I encourage customer to upgrade then?

---

**Bram Schuur** (2025-10-21 08:58):
Hey Daniel,

My interpretation here:

1. For the first question: I do not have any direct pointers where they can investigate. The issue is at splunk side or somewhere inbetween, our agent is timing out on splunk not producing a result. Might be network partitioning, heavy load on splunk, anything.
 2. (Last message) Frank chooses to stay with 10 retries, which is fine, they want their results to be timely.

Not sure i should get into a call with them about this one, unless you feel like 1. should be communicated in person.

---

**Remco Beckers** (2025-10-21 09:01):
Let's see if Frank or Alejandro have anything to add, but judging from the ticket that would make sense if they've been having this problem

---

**Alejandro Acevedo Osorio** (2025-10-21 09:19):
The fix is related to upgrading one of our database dependencies which brings fixes to issues like the `RegionNotServing` that the customer experienced. So I would indeed encourage the customer to upgrade (and even to the just released `2.6.1` which has a some other database fixes)

---

**Louis Lotter** (2025-10-21 09:30):
:party_blob_cat:

---

**Daniel Murga** (2025-10-21 09:30):
Thanks for your answer @Bram Schuur! I will try to keep customer happy with my anwers... I'll keep you posted in case a direct call or similar is needed.

---

**IHAC** (2025-10-21 16:22):
@Bruno Bernardi has a question.

:customer:  Nationwide Mutual Insurance Company

:facts-2: *Problem (symptom):*  
Hi Team,

The customer is looking for a possible parameter to disable logs data on SUSE Observability, similar to what we have for the Agent `logsAgent.enabled=false` .

The services that they'd like to disable logging are, for example, ElasticSearch and Receiver. I believe this may not be recommended, as important troubleshooting information may be lost. But the customer's goal is a possible parameter to disable logs if the log data is never sent or exists for such components.

Thanks in advance.

---

**Alessio Biancalana** (2025-10-21 16:25):
if I recall correctly either you have the logs agent and you have the logs sent from the monitored cluster to the platform, or you just disable the logs agent using `logsAgent.enabled=false`

we don't currently have something to selectively drop incoming logs data. As you stated having something like that would be very clunky not to mention the effort to code that :sweat_smile:

---

**Bruno Bernardi** (2025-10-21 16:29):
Thanks for the quick answer, @Alessio Biancalana.

---

**IHAC** (2025-10-22 09:22):
@Javier Lagos has a question.

:customer:  DR Horton

:facts-2: *Problem (symptom):*  
Hello team.

The customer DR Horton (https://suse.lightning.force.com/lightning/r/Account/0011i00000vMVxDAAW/view) has opened the case 01601524 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000lV56qIAC/view) due to the fact that they cannot access SUSE Observability after a maintenance on their environment. They have performed the following operation:

Drain node -&gt; Reboot -&gt; Unordon on all the nodes one at a time.

After performing this operation they were able to see that the SUSE Observability server was on CrashLoopBackOff due to the following problem that we know about it.

```2025-10-21 13:43:46,941 ERROR com.stackstate.domain.stack.stateservice.StateServiceEvents - [RecalculationFlow] Upstream failed.
java.util.NoSuchElementException: Element does not exist 92515034084210.```
It looks like the customer is having the same data corruption issue we have had multiple times. I know the workaround which is to restore configuration backup, but, the problem is that the customer is already running on 2.6.1 version which is the version that should be preventing this specific problem to happen(?)

I have requested to the customer to restart the server pod and now the issue is the same on a different element and the message is a bit different.

```java.util.NoSuchElementException: Element does not exist 61987478010147

...

java.lang.IllegalStateException: Performing check state create 114929556937199-prod%11-calico%1kube%1controllers-0-calico%1kube%1controllers-calico%1system but check state already exists```
Can you guys help me identify the root cause of the data corruption and confirm the workaround? Might be interesting to find out the root cause as it looks like that on 2.6.1 version we still have the same known issue.

Thanks!

---

**Bram Schuur** (2025-10-22 11:18):
@Javier Lagos I analyzed the logs, it looks to me the update to 2.6.1 was done at 12:39:50 - 2025-10-21. Based on the logs i can see that the transaction state was actually empty after that upgrade due to https://stackstate.atlassian.net/browse/STAC-23312.

My hunch is that they were on &lt; 2.6.0 which caused that bug to trigger. Now that they are on 2.6.1 it should not happen again. Recommendation is to reinstall or restore a backup.

The evidence i found is here: No state after restart (image 1), the transaction state PVC is made just 5 hours ago during the upgrade (image 2).

---

**Javier Lagos** (2025-10-22 11:36):
Thanks a lot @Bram Schuur! I truly appreciate your help here.

---

**Saurabh Sadhale** (2025-10-22 11:52):
@Bram Schuur  thank you for your response.

I had updated the customer and they responded back with further clarifications.

I had enquired about the pvc setup and check for the data sync. They are requesting whether we are looking for some helm values that we should be looking to see if this is enabled. They have used the default generated helm values for almost everything, just added the global.storageClass in sizing_values.yaml when installing.

They have also responded that the k8s upgrade might have probably caused this issue. The colleague who performed the upgrade has performed actions to kill something in order to drain the nodes . But the colleague does not remember the exact steps that might have caused this. However,  system-upgrade-controller was used to perform the upgrade.

It is purely that something was not properly shut down during the upgrade and caused the hbase corruption. They believe there is no issues with the storage that they are using.

Is there any command / guides we can use to solve this hbase corruption?

Regarding storage: We are using our internal storage class called “flash-campx-block” for all PVCs for SUSE Observability, which is a block storage (not NFS) and the fastest available to us.

---

**Javier Lagos** (2025-10-22 15:37):
Here is the support package logs and the values used to deploy SUSE Observability.

Customer said that when they used the upstream Rancher where Downstream cluster is located rancher-coll.intra.camera.it (http://rancher-coll.intra.camera.it) it worked but once they moved to the prod rancher it does not work anymore and I'm wondering if this setup is even allowed.

---

**Javier Lagos** (2025-10-22 15:39):
Api configmap seems to be correct by allowing the correct rancher url.

```      stackstate.web.origins = [
          "https://rancher.intra.camera.it"
        ]```

```      stackstate.api.authentication.authServer.oidcAuthServer {
        clientId = ${oidc_client_id}
        secret = ${oidc_secret}
        discoveryUri = "https://rancher.intra.camera.it/oidc/.well-known/openid-configuration"
        redirectUri = "https://suse-observability-coll.intra.camera.it/loginCallback"
        scope = ["openid", "profile", "offline_access"]
        jwsAlgorithm = "RS256"
        jwtClaims {
          usernameField = "sub"
          groupsField = "groups"
        }
      }```

---

**Javier Lagos** (2025-10-22 15:41):
We tried to upgrade to 2.6.0 version but it didn't work either

---

**Javier Lagos** (2025-10-22 15:43):
Here is the OIDC provider created on the local rancher.intra.camera.it (http://rancher.intra.camera.it) cluster.

```kubectl get oidcclient oidc-client-suse-observability-coll -o yaml
apiVersion: management.cattle.io/v3 (http://management.cattle.io/v3)
kind: OIDCClient
metadata:
  annotations:
   cattle.io.oidc-client-secret-used-client-secret-1: "1760684049"
   kubectl.kubernetes.io/last-applied-configuration (http://kubectl.kubernetes.io/last-applied-configuration): | {"apiVersion":"management.cattle.io/v3 (http://management.cattle.io/v3)","kind":"OIDCClient","metadata":{"annotations":{},"name":"oidc-client-suse-observability-coll"},"spec":{"redirectURIs":["https://suse-observabili
ty-coll.intra.camera.it/loginCallback?client_name=StsOidcClient" (http://ty-coll.intra.camera.it/loginCallback?client_name=StsOidcClient%22)],"refreshTokenExpirationSeconds":3600,"tokenExpirationSeconds":600}}
  creationTimestamp: "2025-10-15T14:50:04Z"
  generation: 1
  name: oidc-client-suse-observability-coll
  resourceVersion: "849423698"
  uid: a4fd5554-b102-43cf-9470-3b921ed89c4d
spec:
  redirectURIs:
  - https://suse-observability-coll.intra.camera.it/loginCallback?client_name=StsOidcClient
  refreshTokenExpirationSeconds: 3600
  tokenExpirationSeconds: 600
status:
  clientID: client-5lqxl47bqh
  clientSecrets:
   client-secret-1:
    createdAt: "1760539804"
    lastFiveCharacters: 5z7r6
    lastUsedAt: "1760684049"```

---

**Alejandro Acevedo Osorio** (2025-10-22 15:54):
I can confirm this is not a setup we have tested and I'm not sure if we want to support. @Louis Lotter here we have another kind of custom setup.

---

**Louis Lotter** (2025-10-22 15:55):
yeah I think @Mark Bakker needs to review these cases and see if this is something we want to work on supporting. He's on leave and will only be back next week.

---

**Alejandro Acevedo Osorio** (2025-10-22 15:59):
I think the setup that the customer wants to achieve @Javier Lagos is possible but currently would require some manual actions (creation of Rolebindings, etc) as basically 2 kind of disconnected Rancher instances need to work together. The main mechanism that populates (Cluster)Role and (Cluster)RoleBindings only works within one Rancher instance and its downstream clusters.

---

**Javier Lagos** (2025-10-22 16:08):
Thanks guys! I really appreciate your inputs.

One of the concern I have is about that the prod rancher that contains the monitored cluster is the same that the one who has been configured as OIDC provider on SUSE Observability. So basically the cluster-admin user that can login into the prod rancher that is able to see the monitored cluster should be able, theoretically, to see this downstream monitored cluster on SUSE Observability even though SUSE observability has been deployed on a separate rancher, right? this thing is not working on the customer environment.

What do you suggest guys? should I tell the customer that this scenario has not been tested/validated to see if he can deploy a downstream cluster inside the rancher that works as an OIDC provider?

---

**Alejandro Acevedo Osorio** (2025-10-22 16:11):
Do we have input why the customer prefers this setup?

---

**Javier Lagos** (2025-10-22 16:14):
I actually have this information but I have to say that the customer is just trying this setup without any pressure. If we decide that this setup is not supported/allowed I think that they will be fine with it.

They are currently trying this config as they have an upstream rancher cluster managing downstream clusters with prod applications while they have a separate upstream rancher that is managing downstream clusters with tools like SUSE Observability.

---

**Javier Lagos** (2025-10-22 17:29):
Ok I have been able to replicate the same error when deploying SUSE Observability in a different rancher than the one used as OIDC provider so I think this is not supported/allowed at the moment.

```2025-10-22 15:25:08,583 ERROR com.stackstate.api.streamapi.ViewSnapshotDiffStream - Cancelling stream because a StreamFailed was sent: ViewSnapshotDiffStream failed with exception class com.stackstate.dto.security.package$PermissionException: 'com.stackstate.dto.security.package$ScopeNotFoundError$'.. ```
The question now is about if we want to provide support to this setup or not so we may need to wait for @Mark Bakker to come back from holidays!

---

**Javier Lagos** (2025-10-22 17:43):
If I add the cluster-observer role to the user which is cluster-admin I can access with cluster-view but I can't give cluster-admin privileges.

The thing is... How can we grant admin privileges if we don't have direct access to the SUSE Observability project if upstream OIDC rancher cluster does not have direct access??

---

**Devendra Kulkarni** (2025-10-22 20:05):
But indeed it created agent pods correctly with the svctoken generated from the UI as I manually edited the values as per the command generated on observability UI:

---

**Devendra Kulkarni** (2025-10-22 20:05):
So i think customer is having some configuration mistake and I will try to verify that on call.

---

**Devendra Kulkarni** (2025-10-22 20:06):
But with my local setup, dont know why rbac agents are failing with features: 404 not found error

---

**Devendra Kulkarni** (2025-10-22 22:26):
just adding my two cents here, I think the setup customer is trying to achieve does not make sense to me since they are trying to have admin privileges for a user on Rancher A cluster for Rancher B cluster, where A is configured as OIDC provider.

Our documentation clearly mentions that:
&gt;  for Rancher RBAC to function, authentication for SUSE Observability must be configured with the Rancher OIDC Provider (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/authentication/oidc.html#_rancher).
This might not exactly tell us which Rancher and can be made clear that its the one which manages SUSE observability server.

Agents can be deployed anywhere and then accordingly the users on this Rancher should have appropriate access to DS clusters.



Moreover, if the customer wants to have a setup as mentioned by @Javier Lagos I think they should stick to RBAC Roles in SUSE Observability https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_roles.html rather than using Rancher RBAC.

---

**Bram Schuur** (2025-10-23 09:07):
Thanks for investigating the storage layer. The killing of pods might be indeed what caused all this (although hard to prove in an after-the fact analysis).

I am not aware of any commands that can fix the hbase corruption without throwing away data. Throwing out data will confuse tephra/stackgraph so i think the only option is a restore

---

**Javier Lagos** (2025-10-23 09:36):
Thanks @Devendra Kulkarni for your inputs here. I agree with you that with this setup we are re-inventing the wheel and I'm not sure about if we want to provide support to this scenarios. We will need the inputs from @Mark Bakker here.

In addition to that. I have been able to configure the rancher OIDC provider even though when SUSE Observability has been deployed inside a downstream cluster managed by another Rancher cluster. (Thanks @Alejandro Acevedo Osorio for your inputs here)

I'm gonna make a summary of the environment:

Rancher A:

• OpenLDAP Auth provider.
• 1 prod downstream cluster monitored by SUSE Observability
• Working as OIDC provider for SUSE Observability
Rancher B:
• Same OpenLDAP auth provider configured.
• SUSE Observability deployed in a downstream cluster. Configured to use Rancher A as an OIDC provider.
As I said before, If we grant cluster-observer permission to the downstream cluster we will get cluster view access within SUSE Observability UI. But, In order to get admin privileges we need access to the SUSE Observability project where SERVER is installed so I had to grant instance-admin permissions to the group where the user belongs on RancherB. I was able to do that because the same auth provider has been configured on both rancher clusters.

---

**Alejandro Acevedo Osorio** (2025-10-23 09:47):
Kudos @Javier Lagos !!!! Well done!!!!

---

**Devendra Kulkarni** (2025-10-23 10:59):
```helm upgrade --install \
--namespace suse-observability \
--create-namespace \
--set-string 'stackstate.apiKey'=$SERVICE_TOKEN \
--set-string 'stackstate.cluster.name'='argo-agent' \
--set-string 'stackstate.url'='https://stackstate.165.227.255.81.nip.io/receiver/stsAgent' \
suse-observability-agent suse-observability/suse-observability-agent```
While deploying agent, can we pass in the service token by referring to a secret?

---

**Devendra Kulkarni** (2025-10-23 11:01):
@Alejandro Acevedo Osorio @Vladimir Iliakov ^^
Customer doesn't want to use plaintext values, and want to refer to a secret, as he is using ArgoCD for deployment.

---

**Alejandro Acevedo Osorio** (2025-10-23 11:07):
I would say the way to go is indeed with  `global.apiKey.fromSecret` as described https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/agent/k8s-custom-secrets-setup.html because the `service token` is a synonym on `apikey` in this context. I understand that in your local setup you got it working.

---

**Alejandro Acevedo Osorio** (2025-10-23 11:08):
@Bram Schuur perhaps you know more of this part on the agent chart?

---

**Vladimir Iliakov** (2025-10-23 11:10):
So the problem is that the rbac agent doesn't respect global.apiKey.fromSecret or what?

---

**Devendra Kulkarni** (2025-10-23 11:13):
So the customer is trying to deploy agent using ArgoCD and it somehow complains for API key as mentioned above:
```Failed to load target state: failed to generate manifest for source 1 of 3: rpc error: code = Unknown desc = Manifest generation error (cached): failed to execute helm template command: failed to get command args to log: `helm template . --name-template suse-observability-agent --namespace suse-observability-agent --kube-version 1.33 --set stackstate.cluster.name=usr-ol-1001 --values &lt;path to cached source&gt;/applications/suse-observability-agent/values.yaml --values &lt;path to cached source&gt;/applications/suse-observability-agent/values.dev.yaml &lt;api versions removed&gt; --include-crds` failed exit status 1: Error: execution error at (suse-observability-agent/templates/secret.yaml:19:8): Please provide an api key. Use --debug flag to render out invalid YAML```
Now after my tests, I suggested customer to add values in plaintext to stackstate.apiKey , stackstate.cluster.name and stackstate.url, and customer confirmed that this worked for him too. But then replied:
```I let it run a bit longer and now the cluster usr-rh-1001 which has the api key plaintext set in the values works, but the rest of the clusters now fail because it needs an api key. This is solvable of course by adding the svc-tokens also in the values for these clusters. But how is this possible without plaintext values? I will test this with using global.apiKey.fromSecret again and defining the apikey in a sealedsecret. I will let you know how this turns out. Maybe stackstate.customSecretName is also an option.```
Somehow when global.apiKey.fromSecret is updated with the service token, the rbac agent does not refer to the correct secret - `suse-observability-agent-secrets`

---

**Devendra Kulkarni** (2025-10-23 11:15):
Have we tested using servicetoken with `global.apiKey.fromSecret` while deploying agents and is this value realisable?

---

**Alejandro Acevedo Osorio** (2025-10-23 11:20):
@Devendra Kulkarni I think the issues is the order of the `values` files
```Failed to load target state: failed to generate manifest for source 1 of 3: rpc error: code = Unknown desc = Manifest generation error (cached): failed to execute helm template command: failed to get command args to log: `helm template . --name-template suse-observability-agent --namespace suse-observability-agent --kube-version 1.33 --set stackstate.cluster.name=usr-ol-1001 --values <path to cached source>/applications/suse-observability-agent/values.yaml --values <path to cached source>/applications/suse-observability-agent/values.dev.yaml <api versions removed> --include-crds` failed exit status 1: Error: execution error at (suse-observability-agent/templates/secret.yaml:19:8): Please provide an api key. Use --debug flag to render out invalid YAML```
I see that first we mix
1. `--values <path to cached source>/applications/suse-observability-agent/values.yaml`
2. `--values <path to cached source>/applications/suse-observability-agent/values.dev.yaml`

---

**Alejandro Acevedo Osorio** (2025-10-23 11:21):
The first establishes
```---

global:
  imageRegistry: redacted/rancher_com
  skipSslValidation: true
  apiKey:
    fromSecret: stackstate-apikey

nodeAgent:
  containerRuntime:
    customSocketPath: /run/k3s/containerd/containerd.sock
  skipKubeletTLSVerify: true

logsAgent:
  enabled: true

kubernetes-rbac-agent:
  enabled: false```
and the second overwrites with
```global:
  imageRegistry: redacted```

---

**Alejandro Acevedo Osorio** (2025-10-23 11:23):
~are we losing the `apikey.fromSecret` there? Have you tried only with `--values <path to cached source>/applications/suse-observability-agent/values.yaml`?~

---

**Vladimir Iliakov** (2025-10-23 11:24):
It does deep merge, so global.apikey should be preserved

---

**Alejandro Acevedo Osorio** (2025-10-23 11:24):
Gotcha ...

---

**Bram Schuur** (2025-10-23 11:26):
I do not have more context, i understand `global.apiKey.fromSecret` did work from helm, i did not do a specific test on argo.

---

**Devendra Kulkarni** (2025-10-23 11:28):
I tried it with ArgoCD UI only, it worked for me when I override the values as per the helm command above, above logs are from customer environment.
Customer is passing multiple values.yaml file which I told them not to use and use a single file, now they are trying that out but asking if this value can be realised

---

**Vladimir Iliakov** (2025-10-23 11:28):
The Helm value works as expected, it adds the expected *envFrom*
❯ helm template --name-template suse-observability-agent --namespace suse-observability-agent --kube-version 1.33 --set stackstate.cluster.name=usr-ol-1001 --values values.yaml --values values.dev.yaml suse-observability/suse-observability-agent | yq 'select(.kind=="Deployment" and .metadata.name=="suse-observability-agent-rbac-agent")'
# Source: suse-observability-agent/charts/kubernetes-rbac-agent/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component (http://app.kubernetes.io/component): kubernetes-rbac-agent
    app.kubernetes.io/instance (http://app.kubernetes.io/instance): suse-observability-agent
    app.kubernetes.io/name (http://app.kubernetes.io/name): suse-observability-agent-rbac-agent
    app: "suse-observability-agent-rbac-agent"
  annotations:
  name: "suse-observability-agent-rbac-agent"
spec:
  replicas: 1
  # Avoid duplicate instances, getting data from multiple agents will confuse the rbac sync.
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: "suse-observability-agent-rbac-agent"
  template:
    metadata:
      labels:
        app.kubernetes.io/component (http://app.kubernetes.io/component): kubernetes-rbac-agent
        app.kubernetes.io/instance (http://app.kubernetes.io/instance): suse-observability-agent
        app.kubernetes.io/name (http://app.kubernetes.io/name): suse-observability-agent-rbac-agent
        app: "suse-observability-agent-rbac-agent"
      annotations:
        # This is required to make the rbac agent pick up changes when a new helm chart is deployed. We cannot
        # generate a checksum for the configmaps/secrets because they can be external, or subcharts are in the way,
        # prohibiting communication of values in the main chart to go to this subchart.
        # What we think should be the final solution is something like https://github.com/stakater/Reloader, which
        # would also make the helm chart simpler due to ditching the checksums.
        revision: "1"
      name: "suse-observability-agent-rbac-agent"
    spec:
      serviceAccountName: "suse-observability-agent-rbac-agent"
      imagePullSecrets:
        - name: suse-observability-agent-rbac-agent-pull-secret
      containers:
        - image: "redacted/suse-observability/kubernetes-rbac-agent:35ec5206"
          imagePullPolicy: IfNotPresent
          name: kubernetes-rbac-agent
          ports:
            - containerPort: 8080
          env:
            - name: STS_NAMESPACE
              value: "suse-observability-agent"
            - name: "STS_ROLE_TYPE"
              value: "scope"
            - name: "STS_SKIP_SSL_VALIDATION"
              value: "true"
          envFrom:
            - configMapRef:
                name: "suse-observability-agent-url"
            - configMapRef:
                name: "suse-observability-agent-cluster-name"
            *- secretRef:*
                *name: "stackstate-apikey"*
          command: ["/usr/bin/kubernetes-rbac-agent"]

---

**Alejandro Acevedo Osorio** (2025-10-23 11:28):
I just ran
```helm upgrade --install --dry-run \
--namespace suse-observability \
--create-namespace \
--set-string 'stackstate.cluster.name'='demo-dev.preprod.stackstate.io (http://demo-dev.preprod.stackstate.io)' \
--set-string 'stackstate.url'='https://master.dev.stackstate.io/receiver/stsAgent' \
--values ~/Downloads/values.yaml \
--values ~/Downloads/values.dev.yaml \
suse-observability-agent suse-observability/suse-observability-agent &gt; ~/Desktop/debug.yaml```
with the two files from the support package and I don't the `Please provide an api key.` error

---

**Alejandro Acevedo Osorio** (2025-10-23 11:30):
I got the same render as @Vladimir Iliakov

---

**Vladimir Iliakov** (2025-10-23 11:32):
So far it looks like the value files are different from those in attachment

---

**Vladimir Iliakov** (2025-10-23 11:33):
Can the client use the value directly --set global.apiKey.fromSecret=stackstate-apikey in ArgoCD ?

---

**Vladimir Iliakov** (2025-10-23 11:34):
Just to verify the idea with the incorrect value files?

---

**Devendra Kulkarni** (2025-10-23 11:36):
They did try to use stackstate.apiKey = &lt;service-token-in-plain-text&gt; and this worked, but not with global.apiKey.fromSecret. Using global.apiKey.fromSecret creates the secret correctly, but the rbac agent pod uses the default API key secret `stackstate-apiKey`and not `suse-observability-agent-secrets`

---

**Devendra Kulkarni** (2025-10-23 11:37):
I will propose a call and check their environment and values files. Thanks

---

**Devendra Kulkarni** (2025-10-23 11:41):
If you see in the rendered values as well @Vladimir Iliakov it is referencing secret:
```  - secretRef:
                name: "stackstate-apikey"
          command: ["/usr/bin/kubernetes-rbac-agent"]```
Although in a working setup that I have, I see the rbac-agent pod refers to secret:
```kubectl get deploy suse-observability-agent-rbac-agent -n suse-observability-agent -o yaml | grep secretRef -A1
- secretRef:
    name: suse-observability-agent-secrets```

---

**Vladimir Iliakov** (2025-10-23 11:42):
Give me a bit more time )))

---

**Devendra Kulkarni** (2025-10-23 11:43):
Okay, my assumption based on my tests is that helm does not render the secret correctly if using global.apiKey.fromSecret with servicetokens

---

**Devendra Kulkarni** (2025-10-23 11:43):
but I may be wrong

---

**Devendra Kulkarni** (2025-10-23 11:43):
thanks for looking into it!

---

**Vladimir Iliakov** (2025-10-23 12:16):
Ok, according to the Chart if global.apiKey.fromSecret is set then stackstate.customSecretName is ignored. No matter whether it is API key or servicetoken in the secret specified in global.apiKey.fromSecret .
Moreover stackstate.customSecretName is only used if `.Values.apiKey` , which is a bit confusing, at least for me.

@Bram Schuur can you clarify the intentions for this condition, why to render a secret reference for the case when fromSecret is not specified but `.Values.apiKey` is? Is it a bug or just misunderstanding of how it is supposed to work?
https://gitlab.com/stackvista/agent/kubernetes-rbac-agent/-/blob/main/charts/kubernetes-rbac-agent/templates/deployment.yaml?ref_type=heads#L93
```          {{- if or .Values.global.apiKey.fromSecret .Values.apiKey }}
            - secretRef:
                name: {{ include "kubernetes-rbac-agent.api-key.secret.name" .  }}
          {{- end }}```
# the related helpers
```{{- define "kubernetes-rbac-agent.externalOrInternal" -}}
{{- if .external }}
{{- tpl .external . }}
{{- else }}
{{- template "kubernetes-rbac-agent.app.name" . }}-{{ .internalName }}
{{- end }}
{{- end }}


{{- define "kubernetes-rbac-agent.api-key.secret.name" -}}
{{ include "kubernetes-rbac-agent.externalOrInternal" (merge (dict "external" .Values.global.apiKey.fromSecret "internalName" "api-key") .) | quote }}
{{- end }}```

---

**Bram Schuur** (2025-10-23 12:30):
The whole infrastructure around `stackstate.customSecretName` and `manageOwnSecrets` is deprecated (see https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/agent/k8s-custom-secrets-setup-deprecated.html)

I made it such that it should still work, but the interaction with global.apiKey.formSecret is indeed sub-par due to limitations in helm. Better steer clear of that whole thing

---

**IHAC** (2025-10-23 12:34):
@Javier Lagos has a question.

:customer:  AB SANDVIK COROMANT

:facts-2: *Problem (symptom):*  
Hello team. Here is another case related to RBAC with Rancher + SUSE Observability from customer AB SANDVIK COROMANT (https://suse.lightning.force.com/lightning/r/Case/500Tr00000jqC6UIAU/view).

After working on different issues we were able to configure Rancher as an OIDC provider successfully which is good.
However,  we have just realized about one behavior that I'm not sure if this should be the expected one.

The customer has installed the OpenTelemetry StackPack which creates a menu on the left. The problem is that the data inside this menu can only be accessible by cluster-readers/admins of the instance. I can confirm that I was able to replicate the scenario even though the information within this section belongs to different namespaces.

Is this the correct and expected behavior? shouldn't we have also RBAC for this menu?

In my case I used one user with cluster observer role in one of the downstream cluster, which gives me access to all data inside this downstream cluster, but this was not enough for the OTEL data inside the OTEL menu.
Until the user received the instance-observer role within the SUSE Observabilty project I couldn't see the data inside the Otel menu.

---

**Javier Lagos** (2025-10-23 12:34):
As agreed @Alejandro Acevedo Osorio! Here is the video that I have recorded from my lab where I was able to replicate the same behavior

---

**Devendra Kulkarni** (2025-10-23 12:38):
So whats the recommendation? not to use stackstate.customSecretName and specify servicetoken in global.apiKey.fromSecret?

---

**Saurabh Sadhale** (2025-10-23 12:39):
Do you have any steps for recommendation ?

---

**Bram Schuur** (2025-10-23 12:57):
Indeed, not using `stackstate.customSecretName`

If you want to pass the service token to the suse-observability-agent by referring to an existing kubernetes secret (managed by yourself), you can:
• Store the service token in your own secret in the same namepsace, under the `STS_API_KEY` key (documented here: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/agent/k8s-custom-secrets-setup.html#_configuration_options)
• Set `global.apiKey.fromSecret="&lt;my-custom-secret-name&gt;"` when deploying the `suse-observability-agent`
If you want to set the service token directly and have the helm chart manage the secret you can put `stackstate.apiKey="&lt;my-super-secret-service-token&gt;"`

All documented here (for the agent): https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/agent/k8s-custom-secrets-setup.html#_overview

---

**Bram Schuur** (2025-10-23 12:59):
Restore a full backup, configuration backup or start over:
• https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/kubernetes_backup.html
• https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html

---

**Devendra Kulkarni** (2025-10-23 13:01):
Thanks let me try that

---

**Alejandro Acevedo Osorio** (2025-10-23 13:44):
My first impression is that the otel traces  might be missing the `k8s.cluster.name` resource attribute which we use to build the topology scope.
So when the cluster observer queries the data with a permission like
```PERMISSION   | RESOURCE                                                                                                                               
get-topology | cluster-name:jlagos-pool```
can't find it.

---

**Alejandro Acevedo Osorio** (2025-10-23 13:45):
And the instance admin gets of course unfiltered data so he can see those topology elements.

---

**Alejandro Acevedo Osorio** (2025-10-23 13:47):
The docs for the open telemetry collector are over here https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_o[…]lector (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_open_telemetry_collector) ... and the snippet regarding the cluster name
```      resource:
        attributes:
        - key: k8s.cluster.name
          action: upsert
          # Insert your own cluster name
          value: &lt;your-cluster-name&gt;```

---

**Alejandro Acevedo Osorio** (2025-10-23 13:47):
Can you verify that part?

---

**Devendra Kulkarni** (2025-10-23 14:02):
That worked for me, as well as the customer, he mentioned:
```The stackstate.customSecretName I just used for testing in this instance, we normally don't use it. I added a sealedsecret with STS_API_KEY = svc-token.. and loaded this in with global.apiKey.fromSecret. This now works correctly. The RBAC doesn't throw errors and the other pods also seem fine. I am just wondering which receiver api key it is using now, since we had the same receiver api key for all clusters and loaded it in as a sealedsecret and with global.apiKey.fromSecret. Do you know where to find it?```
I think the svc-token itself will act as apikey for the agent cluster, correct? It does not need the receiver API key in this case, right?

Can you clarify when to use receiver API key and when to use service token?

---

**Alejandro Acevedo Osorio** (2025-10-23 14:08):
the `svc-token` will work for all agents. We encourage to use the `svc-token` and not rely on the ApiKey. The RBAC Agent for example won't work with an ApiKey.

---

**Alejandro Acevedo Osorio** (2025-10-23 15:02):
@Javier Lagos I verified and the Otel components seem to be missing the `cluster-name` label that we use to filter topology whenever for users with scoped topology permissions. I created this bug ticket related to it https://stackstate.atlassian.net/browse/STAC-23660 (cc @Bram Schuur)

---

**Saurabh Sadhale** (2025-10-24 09:49):
hey @Alejandro Acevedo Osorio can you help me clarify this one point ?

• Can the restore be done when the hbase DB is already  corrupt? This question arises from the customer as the documentation regarding restore states this: “Data collection and ingestion stays active during the restore”.

---

**Alejandro Acevedo Osorio** (2025-10-24 10:29):
The restore process will wipe the `StackGraph` data when it starts the process (both the full backup restore and the configuration backup restore) ... I think the part of the docs regarding `Data collection and ingestion stays active during the restore`  refers that metrics, logs and the rest of the data but topology (that's what we are restoring) would continue being ingested

---

**IHAC** (2025-10-24 13:35):
@Saurabh Sadhale has a question.

:customer:  Edicom Capital Sociedad Limitada

:facts-2: *Problem (symptom):*  
Hello Team,

I am working with Edicom Capital Sociedad Limitada (https://suse.lightning.force.com/lightning/r/0011i00000vOiAfAAK/view). The customer wants to view the JVM metrics on their SUSE Obs Dashboard.

They have performed the following steps:

1. In the application deployment annotations they have added: 
    a. instrumentation.opentelemetry.io/inject-java (http://instrumentation.opentelemetry.io/inject-java): open-telemetry/otel-instrumentation
2. Created an OpenTelemetryCollector object. 
The application pods from the downstream cluster are successfully sending metrics to the SUSE Obs as we have checked this.

But when they click on the Service and check Metrics they are not able to view the JVM button as shown in this screenshot / link (https://observability.suse.com/#/components/urn:opentelemetry:namespace%2Fopentelemetry-demo:service%2Fadservice/metrics?metricTab=JVM&amp;rightPane=hidden-0__active_tab-selection__chain-component%3A188525879229603&amp;timeRange=LAST_1_HOUR) of our playground.

Is there any additional configuration missing from the customer ?

---

**Saurabh Sadhale** (2025-10-24 13:37):
image_10 shows that the JVM button that is expected is not seen.
image_11 shows the metrics are observed in SUSE Obs

---

**Remco Beckers** (2025-10-24 14:38):
From the fact that they are using auto-instrumentation I assume they have been following this guide in our docs and installed the OTEL operator: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_auto_[…]tation (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_auto_instrumentation).

Did they also create the Instrumentation resource named `otel-instrumentation` in the `open-telemetry` namespace that the inject annotation refers to? I'm asking because you mention explicitly they followed the other steps, but not this one.

I'm not sure the `jvm_classes_loaded` metric comes from the instrumentation (I think it is a metric that the Java prometheus exporter exposes, that's at least what I see in our own test environments). A better check to see if data is available is to use one of the metrics that are shown on the JVM tab: `sum by(service_namespace, service_name) (jvm_memory_used_bytes)`. If those metrics are absent I suspect there is still some misconfiguration, for example a missing `otel-instrumentation` resource or having it in a different namespace etc..

Can you check the above with he customer?

---

**Devendra Kulkarni** (2025-10-24 14:39):
Customer is asking:
```Is my understanding correct then that the receiver ApiKey is depricated and incorporated in the svc-token? Is this also the case for the Opentelemtry collector? ```

---

**Devendra Kulkarni** (2025-10-24 14:40):
It would be better if we have this mentioned in documentation and this should clarify further doubts from all customers.

---

**Alejandro Acevedo Osorio** (2025-10-24 14:40):
it is the case for the open telemetry collector as well that in can use service tokens. Indeed service tokens are absorbing the ApiKey as they are more powerful (expiry, permission scope) but the ApiKey is not yet deprecated I mean the customer could use it for almost any agent but the Rbac Agent.

---

**IHAC** (2025-10-24 20:05):
@Garrick Tam has a question.

:customer:  Nationwide Mutual Insurance Company

:facts-2: *Problem (symptom):*  
Customer configured Rancher Auth for Observability.  The following is as follows:  user/browser --&gt; STS --&gt; Rancher Auth --&gt; Rancher OIDC --&gt; Azure idP.

There are 15 Rancher admins configured similarly.  One of the 15 Rancher admins (Caroline Zhang) is experiencing an issue where she is able to authenticate into Observability UI but the left navigation bar fails to list any content for selection.  After enabling authentication debug logging, we see java exception "Too many elements" referring to azuread_group count is greater than 256.  I counted up Caroline Zhang's group count is at 327.

Caroline Zhang (Rancher id: u-j73d3wb6jn) azuread_group count: 327
Greg Sidelinger (Rancher id: u-gq7gghhzg2) azuread_group count: 235

---

**Garrick Tam** (2025-10-24 20:06):
Here's an example of the java exception.:
``````

---

**Garrick Tam** (2025-10-24 20:07):
Attached is the screenshot of the issue and log bundle.

---

**IHAC** (2025-10-27 04:27):
@David Noland has a question.

:customer:  Hosted Rancher

:facts-2: *Problem (symptom):*  
Is it possible to get the login session extended on rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io) ? I'm having to log in several times a day, sometimes even when I'm actively using the system. It seems like my session is only valid for around 4-8 hours.

---

**Saurabh Sadhale** (2025-10-27 06:56):
Yes followed that guide to install.
The metric jvm_memory_used_bytes can also be seen in the screenshot attached below.

```$ helm list
NAME           NAMESPACE     REVISION  UPDATED                   STATUS   CHART              APP VERSION
opentelemetry-operator  open-telemetry  1      2025-10-08 16:12:14.947259473 +0200 CEST  deployed  opentelemetry-operator-0.97.1  0.136.0 

$ k get po
NAME                                    READY  STATUS  RESTARTS  AGE
krqa-collector-0                         1/1   Running  0        14d
opentelemetry-operator-6f89699d97-cv4sj  2/2   Running  0        16d

k get instrumentations.opentelemetry.io (http://instrumentations.opentelemetry.io) -A

NAMESPACE       NAME                  AGE  ENDPOINT                                                     SAMPLER   SAMPLER ARG
open-telemetry  otel-instrumentation  16d  http://krqa-collector.open-telemetry.svc.cluster.local:4317  always_on ```

---

**Vladimir Iliakov** (2025-10-27 09:29):
We have the following tiemouts for the sessions. I will create a ticket to investigate, why your sessions are so short

---

**Vladimir Iliakov** (2025-10-27 09:35):
I see multiple login/errors attempts related to your user. I can't say straight away where the problem is IdP, SUSE Observability or the client (browser) ...

---

**Vladimir Iliakov** (2025-10-27 10:04):
@David Noland is there any chance that you use an OAuth URL directly to access the tenant, maybe from the bookmarks? Something like
`https://sso.us.app.stackstate.io/realms/rancher-hosted/protocol/openid-connect/auth?scope=openid+profile+email&response_type=code&redirect_uri=https%3A%2F%2Francher-hosted.app.stackstate.io%2FloginCallback%3Fclient_name%3DStsKeycloakOidcClient&state=...&code_challenge_method=S256&client_id=stackstate-rancher-hosted&code_challenge=...`


and not just `https://rancher-hosted.app.stackstate.io` ?

---

**Remco Beckers** (2025-10-27 11:51):
If the metric is there the only thing that can cause problems would be a mismatch in the labels of the component with what is expected. I cannot verify it from only the screenshots I've got now (for example I cannot see the component labels). To get to the bottom of this I would do the following:
1. Verify that the name labels on the component page match the labels on the metrics, specifically  the component `name` to `service_name` (from the screenshots this looks to be the case) and `service.namespace` -> `service_namespace` .
2. Make sure there is also a label `stackpack:open-telemetry`, and that the component type is `otel service` (from the screenshot I can see that is the case)
3. Try to fill in this query manually using the label values from the component for the service_namespace and service_name): `jvm_memory_used_bytes{service_namespace="${tags.service.namespace}", service_name="${name}",jvm_memory_type="heap"}` . Given the lack of charts I expect this to give no results, then try removing one label at a time to see when results are present.
4. If this still doesn't show a mismatch or if in point 3 you do get a result without any changes, we need to check what queries the API is providing us:
    a. For this we need to open the developer tools in the browser first
    b. Then open the network tab
    c. Filter requests for `api/components/urn`
    d. Open the service highlight page (or refresh the browser tab) and pick the response from the last request
    e. You can inspect it yourself, the metrics we would expect are in the `boundMetrics` list (you can filter in the respone for the text `JVM` to only see the JVM bound metrics). But please share the whole response with me so I can do some more detailed checks too

---

**Garrick Tam** (2025-10-28 00:07):
Hello STS Team, can I get please get some help with this?

---

**Garrick Tam** (2025-10-28 00:39):
Here's a HAR capture from Caroline Zhang's firefox browser.

---

**Remco Beckers** (2025-10-28 08:11):
Hi Garrick. Looking at the errors this is a problem with the code where we hit a query limit on our backend store because of the way the permission lookup is implemented.

Let me check if we can increase the limit, but this will also need a bug fix

---

**Remco Beckers** (2025-10-28 09:05):
Here our Jira ticket https://stackstate.atlassian.net/browse/STAC-23692.

A work-around for now is to increase the limit and then redeploying the platform (via a `helm upgrade` ) with an extra custom value (when we have the bug fixed it can and should be removed again):
• From the command line: `--set-string 'stackstate.components.api.extraEnv.open.CONFIG_FORCE_stackgraph_index_maxWithinLimit='400'`
• Or via a values file
```stackstate:
  components:
    api:
      extraEnv:
        open:
          CONFIG_FORCE_stackgraph_index_maxWithinLimit: "400"```
I'm using 400 as the new limit so we are well over the 327 groups that are problematic.

---

**Vladimir Iliakov** (2025-10-28 09:40):
I have increased those parameters

---

**Saurabh Sadhale** (2025-10-28 09:52):
@Remco Beckers thanks a lot. I have checked those points in the play.stackstate and all the points match.  I am awaiting screenshots and HAR report for point 4. Will update you once I recieve them

---

**Remco Beckers** (2025-10-28 10:02):
Yeah. That's why it works ok on play indeed :slightly_smiling_face:

---

**Garrick Tam** (2025-10-28 15:29):
Thank you.

---

**Daniel Murga** (2025-10-28 15:45):
I forgot to mention: SUSE Observability 2.6.1
Attached a "inspect" of observability namespace

---

**Daniel Murga** (2025-10-28 15:53):
Customer replied:
*"Thanks Daniel , just FYI I did restart the sync, health sync, state and notification pods this morning before I raised the call when I saw they were failing to see if it would recover. It did not. The sync pod runs but has the blocking error in it"*

---

**Alejandro Acevedo Osorio** (2025-10-28 16:46):
Hi Daniel, I agree with that it's a data corruption issue on StackGraph. I understand that they run the `AKS node image` on their staging environment on Saturday. Do we know if the side effects (`InvalidObjectPropertyException`) appeared just today?

---

**David Noland** (2025-10-28 18:49):
Great, thanks Vladimir!

---

**Daniel Murga** (2025-10-28 22:23):
Sorry @Alejandro Acevedo Osorio I missed your reply... Seems that the issue appeared just after the node image update reboot.

---

**Vladimir Iliakov** (2025-10-29 09:56):
For SSO Session Idle it is 24 hours, not days. :facepalm:

---

**Bram Schuur** (2025-10-29 10:04):
@Daniel Murga Just fyi: me and @Alejandro Acevedo Osorio are taking a look. We found nothing substantial so far.

---

**Andrea Terzolo** (2025-10-29 11:27):
Ei! uhm the issue seems a little bit different from the above one. The above one had a specific issue with http2 protocol, in this case it seems the whole network tracing feature. More in detail it seems kprobes are not supported on that machine. Can you check the following things?
•  kernel config on the node running this agent
```cat /boot/config-$(uname -r) | grep KPROBE```
•  info on the running kernel
```uname -a```
• mount points
```mount```

---

**IHAC** (2025-10-29 11:33):
@Giovanni Lo Vecchio has a question.

:customer:  Ministere de l'Agriculture

:facts-2: *Problem (symptom):*  
Hi Team,
I have a problem regarding the deprecation of topology scores (v2.5.0).

The customer has this configuration with v2.4.0:
```grp-suse_observability-reader:
systemPermissions:
- execute-component-actions
- export-settings
- manage-monitors
- manage-notifications
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
topologyScope: "label = 'agriculture.gouv.fr/qsi:foo (http://agriculture.gouv.fr/qsi:foo)' and label = 'agriculture.gouv.fr/tenant:bar (http://agriculture.gouv.fr/tenant:bar)'"```
Tried to modify the custom role as follows (but it doesn’t work):
```grp-suse_observability-reader:
systemPermissions:
- execute-component-actions
- export-settings
- manage-monitors
- manage-notifications
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
resourcePermissions:
get-topology:
- "label = 'agriculture.gouv.fr/qsi:foo (http://agriculture.gouv.fr/qsi:foo)' and label = 'agriculture.gouv.fr/tenant:bar (http://agriculture.gouv.fr/tenant:bar)'"```
Do you have any examples of how this “migration” should be done?
Can you tell from the setup what’s wrong?

TIA!

---

**Javier Lagos** (2025-10-29 11:35):
https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/rbac/rbac_roles.html#_custom_roles_via_the_configuration_file

---

**Javier Lagos** (2025-10-29 11:36):
Here you can see an example of the new get-topology structure

---

**Javier Lagos** (2025-10-29 11:36):
```stackstate:
  authentication:
    roles:
      custom:
        development-troubleshooter:
          systemPermissions:
          - create-dashboards
          - create-favorite-dashboards
          - create-favorite-views
          - create-monitors
          - create-notifications
          - create-views
          - delete-dashboards
          - delete-favorite-dashboards
          - delete-favorite-views
          - delete-monitors
          - delete-notifications
          - delete-views
          - execute-monitors
          - get-agents
          - get-api-tokens
          - get-dashboards
          - get-metric-bindings
          - get-metrics
          - get-monitors
          - get-notifications
          - get-permissions
          - get-settings
          - get-stackpacks
          - get-system-notifications
          - get-topic-messages
          - get-traces
          - get-views
          - update-dashboards
          - update-monitors
          - update-notifications
          - update-stackpacks
          - update-views
          - update-visualization
          resourcePermissions:
            get-topology:
            - "cluster-name:dev-test"```

---

**Alejandro Acevedo Osorio** (2025-10-29 11:36):
the `topologyScope: "label = 'agriculture.gouv.fr/qsi:foo (http://agriculture.gouv.fr/qsi:foo)' and label = 'agriculture.gouv.fr/tenant:bar (http://agriculture.gouv.fr/tenant:bar)'"` is still supported as a way of configuring scope.
The only thing that needs to be done is to drop any
```perform-custom-query
get-topology```
from the `systemPermissions` because the platform interprets it as giving access to topology system wide (basically can observe all)

---

**Alejandro Acevedo Osorio** (2025-10-29 11:39):
And I mean drop it from the `systemPermissions` if you actually want to narrow the user's topology visibility (which I think is what they are trying to accomplish there). For a user with complete topology visibility you do need to keep `get-topology|perform-custom-query` as a `systemPermissions`

---

**Giovanni Lo Vecchio** (2025-10-29 11:42):
Amazing! Thank you so much for the explanation, @Alejandro Acevedo Osorio

---

**Andrea Terzolo** (2025-10-29 11:49):
BTW as a temporary mitigation for the customer you can disable the process agent container, but this will disable connection tracing so not network correlation will be visible in the UI.
```--set nodeAgent.containers.processAgent.enabled=false```

---

**Daniel Murga** (2025-10-29 12:52):
nice! Just keep me updated so I can update customer accordingly

---

**Bram Schuur** (2025-10-29 13:37):
@Daniel Murga we have a updated docker image which should give us more information on the issue. It extends the logging for the error we see. (This will not solve the issue, just bring us further on resolution)

Could you ask the customer to install with the following helm flag on the broken image and ship the logs (support package)?

`--set stackstate.components.all.image.tag='7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c'`

---

**Daniel Murga** (2025-10-29 13:41):
Sure! Asking customer.

---

**Daniel Murga** (2025-10-29 13:45):
Sent! I'll keep you guys posted

---

**Daniel Murga** (2025-10-29 14:20):
response from customer: "Hi Daniel,

Can you clarify exactly where and how they expect me to do this?

We download the helm release direct from rancher.com/prime/suse-observability (http://rancher.com/prime/suse-observability) I cannot edit it we do not currently use an Azure Container registry for example (its being tested on other code we have but not used for suse versions as yet)

Regards

Duncan"

---

**Alejandro Acevedo Osorio** (2025-10-29 14:29):
@Daniel Murga I think the customer will need to use a second override (for the registry)
```--set stackstate.components.all.image.tag='7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c' \
--set stackstate.components.all.image.registry=quay.io (http://quay.io)'```

---

**Daniel Murga** (2025-10-29 14:33):
good catch... I was just preparing instructions for them to run the helm upgrade

---

**Bram Schuur** (2025-10-29 14:33):
@Daniel Murga we did do this succesfully with the customer before (mitesh did it).
It could be we patched the image directly in their deployment rather than their helm install (which they run through ansible).

@Alejandro Acevedo Osorio’s suggestion might work but it could be also the repository needs changing.

To patch the image directly they should change the image on one of the failing deployments to `quay.io/stackstate/stackstate-server:7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c-2.5 (http://quay.io/stackstate/stackstate-server:7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c-2.5)`

---

**Daniel Murga** (2025-10-29 14:35):
ok... so maybe it's better to change the image directly in the deployment...

---

**Bram Schuur** (2025-10-29 14:41):
I think to make this work through helm on the published rancher chart, the following would be needed, to just patch the 'state' deployment. @Alejandro Acevedo Osorio do you think this is accurate? (i think we need the repository override due to that being changed on the rancher chart)
```
--set stackstate.components.state.image.imageRegistry=quay.io (http://quay.io)
--set stackstate.components.state.image.repository=stackstate/stackstate-server
--set stackstate.components.state.image.tag=7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c```

---

**Daniel Murga** (2025-10-29 14:43):
ok, just to confirm... the image should be changed on `suse-observability-server`  deployment right?

---

**Bram Schuur** (2025-10-29 14:45):
Its slichtly different: We use the same server image for multiple deployments. The suse-observability-server deployment does not exist for them (they run HA, so the server is split into multiple deployments). We want to change the image on one of the deployments that exert the issue. I picket the `suse-observability-state` deployment in the above helm command

---

**Daniel Murga** (2025-10-29 14:48):
so helm upgrade?
```helm upgrade --install \
    --namespace suse-observability \
    --create-namespace \
    --values $VALUES_DIR/suse-observability-values/templates/baseConfig_values.yaml \
    --values $VALUES_DIR/suse-observability-values/templates/sizing_values.yaml \
    --values $VALUES_DIR/suse-observability-values/templates/affinity_values.yaml \
    suse-observability \
    suse-observability/suse-observability
--set stackstate.components.state.image.imageRegistry=quay.io (http://quay.io)
--set stackstate.components.state.image.repository=stackstate/stackstate-server
--set stackstate.components.state.image.tag=7.0.0-snapshot.20251029113156-stac-23711-2.6.1-fb4485c```

---

**Bram Schuur** (2025-10-29 14:50):
in spirit yes, but:
•  some trailing slashes are missing from your command
• I think the --set should be right after --values flags
• Over at rabo they might have their own additional flags themselves, that i cannot see from here.

---

**Bram Schuur** (2025-10-29 14:51):
It might make sense to get into a call with them

---

**Daniel Murga** (2025-10-29 15:01):
perfect! I will manage to arrange a call with them, I think I will propose tomorrow morning 10am CET

---

**Daniel Murga** (2025-10-30 08:20):
Hi @Bram Schuur @Chris Riley customer seems not to be happy with our answer to this case, that's what I told them:

_"Hello Frank,_ 
_Thank you for your follow-up and for providing that excellent clarification on the timeline—it's very helpful to know that the issue resolved itself before the Doka search change, and that the root cause remains unknown._
_I've shared all of our conversation and your feedback with my engineering team to see if we can offer further guidance. Here is our current interpretation and recommendation:_
_*Our Analysis*_
_Based on the observability logs and the information you provided, we still have no immediate evidence of an issue within your SUSE Observability deployment._
 
• _*Timeout Issue:* The problem you experienced was our agent timing out because Splunk did not produce a result within the expected timeframe. This suggests the root cause is likely external to our platform._
• _*Possible Root Causes:* We don't have direct pointers for what caused the transient issue, but it typically points to problems between our agent and Splunk. This could be due to:_
 
    ◦ _*Network Partitioning or Intermittency:* Temporary drops or instability in the network path._
    ◦ _*Heavy Load on Splunk:* Splunk being temporarily overloaded and slow to respond._
    ◦ _*Resource Contention:* Issues with resources on the underlying infrastructure._
_*Next Steps and Recommendation*_
_Regarding your decision to keep the default_search_max_retry_count at 10, we completely understand and agree with your reasoning. A search shouldn't need more than 10 retries, and forcing it to wait longer simply masks a deeper problem._
_Since the issue resolved itself, and we cannot pinpoint the root cause from our side, we recommend focusing your investigation on the environment surrounding Splunk and the network path to it._
_If the issue reoccurs, we would be happy to re-engage immediately. The best chance of diagnosing this will be with logs and data captured while the problem is actively happening._
_Please let us know if you have any questions or if you feel a deeper discussion with our engineering team would be beneficial at this stage."_

I sent them this on 20th of October, yesterday (after 9 days without answer) I closed the case, and we received:

_"Hi Daniel,_

_Where did I say that the provided solution was sufficient?_
_The last email I send was Monday 20-10-25 where I started that I do not see raising the retry count from 10 to 20 as anything that would help since 10 retry’s is already beyond normal operation._
_So no the solution is not sufficient and we still would like to find the root cause if this problem since now this can happen at any moment without us being able to resolve it. So I want to keep this case open until we get to the bottom of this._

_I will be on holiday till 04-11-25 but if you have any question Karan can answer them for you._

_Best Regards_
_Frank"_

Do you think that there's the need of a "formal" call to keep their expectations aligned? I mean... this is a custom development and I'm not sure how we  (support) can help customer here.

What do you think?

---

**Bram Schuur** (2025-10-30 08:31):
Yeah lets do that, feel free to set up a call

---

**Daniel Murga** (2025-10-30 08:32):
We've got one already booked for the case related to AKS instance reboot...

Rabobank - 01602588
Monday, November 3 · 11:30am – 12:30pm
Time zone: Europe/Madrid
Google Meet joining info
Video call link: https://meet.google.com/nsy-uiyd-hcj
Or dial: ‪(ES) +34 877 99 41 16‬ PIN: ‪252 306 026‬#
More phone numbers: https://tel.meet/nsy-uiyd-hcj?pin=2314836974661

Maybe we can talk about this Splunk thing also...

---

**Bram Schuur** (2025-10-30 08:34):
Okey, we can also look at this issue there. That time clashes with my team standup and sprint planning, which i have to run, any chance that can be moved?

---

**Daniel Murga** (2025-10-30 08:35):
sure, just tell me what suits better for you

---

**Chris Riley** (2025-10-30 09:22):
Thanks guys, let me know if you need anything from my side ... I'm following the case already btw.

---

**Daniel Murga** (2025-10-30 10:51):
We agreed to jump in a call with customer to discuss about this specific topic. I'll keep you posted

---

**Daniel Murga** (2025-10-30 10:55):
Ok as we agreed I just asked Mitesh (rabobank) to join a remote call to apply the changes prior getting the logs:

Rabobank - 01602588
Friday, October 31 · 11:00am – 12:00pm
Time zone: Europe/Madrid
Google Meet joining info
Video call link: https://meet.google.com/rzg-dkcf-pzs
Or dial: ‪(ES) +34 872 55 99 84‬ PIN: ‪391 727 174‬#
More phone numbers: https://tel.meet/rzg-dkcf-pzs?pin=3084673714523

---

**Saurabh Sadhale** (2025-10-31 07:13):
I am sharing the logs here.

---

**Daniel Murga** (2025-10-31 08:47):
Morning! Customer did not reply to the meeting request yet... I'll keep you updated

---

**Remco Beckers** (2025-10-31 09:30):
Ok. I think I understand what's happening now:
1. I suspect the auto-instrumentation is not working and the application is not instrumented
2. But we still see metrics that are very similar but with different labels, these labels are not the labels from the OTel semantic conventions so are not from the instrumentation
3. The labels match the ones from the JVM Prometheus exporter
4. I also see that they configured the target allocator in the OpenTelemetryCollector.yaml, if this is enabled with this config it will start scraping the prometheus exporter endpoints and ship these metrics. This would explain why we still see some very similar, but slightly different metrics.
To verify if the auto-instrumentation is working at all I suggest following the troubleshooting steps on the Open Telemetry Operator docs site, specifically
• Check if there are auto-instrumetnation errors: https://opentelemetry.io/docs/platforms/kubernetes/operator/automatic/#do-the-otel-operator-logs-show-any-auto-instrumentation-errors
• Order of installaton: https://opentelemetry.io/docs/platforms/kubernetes/operator/automatic/#were-the-resources-deployed-in-the-right-order
The second also has instructions on how to verify if the auto-instrumentation actually happened (for example the pod should have an extra init container). It may also be useful to check if the operator has the required permissions to modify pods that are started.

---

**Daniel Murga** (2025-10-31 10:03):
Customer (mitesh) agreed to join the call

---

**Daniel Murga** (2025-10-31 10:03):
see you at 11

---

**Bram Schuur** (2025-10-31 10:04):
great! see you then

---

**Daniel Murga** (2025-10-31 10:05):
you will provide instructions to update the deployment , right?

---

**Daniel Murga** (2025-10-31 12:04):
Guys I need to drop to another call...

---

**Bram Schuur** (2025-10-31 12:25):
np, thanks for being there!

---

**Daniel Murga** (2025-10-31 13:27):
no problem guys! Please keep me updated with the findings/troubleshooting so I can update de SCC case accordingly

---

**Bram Schuur** (2025-10-31 15:21):
Okey, update based on todays session:
• Sequence of events:
    ◦ We found a database edge write to be partially applied at 25-10-2025 7:13 UTC (or removed between 7:13 - 7:22 timeframe, we can't say which one of these)
    ◦ The partial write caused the subsequent attempt at a removal to fail at 7:22, so the partial data still surfaces, causing confusion in the data model.
    ◦ This cause state,notification,sync health-sync to be in crashloopbackoff
    ◦ After an exhaustive investigation (more below) we opted to fix the partially written edge in the database. Removing it brought the system back up
• Investigation results:
    ◦ None of the involved services showed any sign of trouble
    ◦ We have not found the root cause yet, we identified two actionable items to make progress towards that:
        ▪︎ Do not continue when an edge cannot be removed, to avoid confusing the data model and avoid the corruption.
        ▪︎ Implement a consistency checker for stackgraph, to be ran as a cron-job to validate the data in the database and have more information when/what broke.

---

**IHAC** (2025-10-31 16:50):
@Javier Lagos has a question.

:customer:  Dienst ICT Uitvoering

:facts-2: *Problem (symptom):*  
I'm currently working in a customer case 01603266 (https://suse.lightning.force.com/lightning/r/Case/500Tr00000mtmEsIAI/view) where the customer is asking us for some help as it looks like they have the same "synchronization" issues on their SUSE Observability instances located on their non-prod and prod clusters.

This is what the customer has commented to me about the environments.

`There are likely two causes to trace this back to: node patching (where we drain and reboot the nodes one by one) and an incident where are all our nodes went unavailable and Observability was offline for a few hours.`

So it looks like they had an outage that affected their nodes during a couple of hours.

The instances affected are located on the cluster Tooling-2101 and Tooling-3002

After checking the support packages logs I think I have found information and evidences of data corruption that I need you to confirm with me.

Thanks!!

---

**Javier Lagos** (2025-10-31 16:50):
Here are the support package logs.

---

**Javier Lagos** (2025-10-31 16:54):
I have already asked customer about if they have enabled backups during installation.

And, just in case, customer is running 250-HA profile on both clusters.

```          - name: CONFIG_FORCE_stackstate_agents_agentLimit
            value: "250"```

---

**Javier Lagos** (2025-10-31 16:54):
Customer is already on 2.6.1 version

---

**Louis Lotter** (2025-10-31 17:01):
@Javier Lagos Hi. This issue looks serious enough to log a ticket on Jira. We would like to do that for serious bugs and customer issues for trackability. Please take a look at https://jira.suse.com/browse/SURE-10861 which is a test ticket that shows some of what should be on the ticket.
It's a Project SURE ticket with Suse Observability chosen as the component.

---

**Louis Lotter** (2025-10-31 17:01):
We would like to start aligning with the rest of ECM on how we handle support cases like these.

---

**Javier Lagos** (2025-10-31 17:02):
Sure! Thanks for the information @Louis Lotter. I'm on it now

---

**Louis Lotter** (2025-10-31 17:03):
@Alejandro Acevedo Osorio if you're still around can you confirm that this is likely data corruption :point_up:. May be the same issue you're looking at atm.

---

**Louis Lotter** (2025-10-31 17:04):
@Javier Lagos once you have the ticket please share it here

---

**Alejandro Acevedo Osorio** (2025-10-31 17:10):
@Louis Lotter Does look like data corruption, but a really different issue that the one we are looking atm. And regarding the `all our nodes were unavailable` for some hours does show up on
```2025-10-31 13:21:03,482 ERROR akka.kafka.internal.KafkaConsumerActor - [011ca] Exception when polling from consumer, stopping actor: org.apache.kafka.clients.consumer.OffsetOutOfRangeException: Fetch position FetchPosition{offset=8595692, offsetEpoch=Optional.empty, currentLeader=LeaderAndEpoch{leader=Optional[suse-observability-kafka-1.suse-observability-kafka-headless.suse-observability.svc.cluster.local:9092 (id: 1 rack: null)], epoch=54}} is out of range for partition sts_health_sync-0
org.apache.kafka.clients.consumer.OffsetOutOfRangeException: Fetch position FetchPosition{offset=8595692, offsetEpoch=Optional.empty, currentLeader=LeaderAndEpoch{leader=Optional[suse-observability-kafka-1.suse-observability-kafka-headless.suse-observability.svc.cluster.local:9092 (id: 1 rack: null)], epoch=54}} is out of range for partition sts_health_sync-0```
where the health-sync restarts and tries to reset to the last known offset but apparently kafka doesn't like it saying
```out of range for partition sts_health_sync-0```

---

**Javier Lagos** (2025-10-31 17:10):
https://jira.suse.com/browse/SURE-10904

---

**Javier Lagos** (2025-10-31 17:11):
Customer has just confirmed that the downtime only happened on cluster tooling-2101. I'm asking them about what happened on cluster tooling-3002 but I suspect that issue happened after node patching

---

**IHAC** (2025-10-31 18:22):
@David Noland has a question.

:customer:  Centene (Hosted Rancher)

:facts-2: *Problem (symptom):*  
We are monitoring Centene's hosted environment using StackState (SaaS) and seeing what appears to be a significant memory leak in rancher pods when looking at the container_memory_usage metric. However, this doesn't seem to come close to matching what we see in "top",  "ps aux" output on the host, or "kubectl top pods -n cattle-system". Golang profiles also indicate the memory is not as high as the metric is reporting. How is this metric calculated/scraped? This is the query we use in metrics explorer - "(container_memory_usage{container="rancher", namespace="cattle-system", cluster_name="centene-east"}) / 1073741824" For more context, see also SURE-10880 (https://jira.suse.com/browse/SURE-10880)

---

**Amol Kharche** (2025-11-03 09:04):
Hello Team,
Instead of using Keycloak for the our Hosted Rancher StackState environment (rancher-hosted.app.stackstate.io (http://rancher-hosted.app.stackstate.io)), Could we switch it over to use OIDC on our Hosted Rancher Ops (ops-us-west-2.rancher.cloud).
Is that possible? This would make user management a bit easier.
cc: @David Noland @Surya Boorlu

---

**Alejandro Acevedo Osorio** (2025-11-03 09:05):
And the node patching was performed last Friday?

---

**Amol Kharche** (2025-11-03 09:11):
Or if possible give access to One user from support team and let him manage users for hosted rancher project?

---

**Javier Lagos** (2025-11-03 09:14):
I've not received any confirmation about cluster tooling-3002 since Friday! I will update you as soon as possible with that

---

**Vladimir Iliakov** (2025-11-03 09:21):
We don't support custom OIDC providers in Saas.

---

**Vladimir Iliakov** (2025-11-03 09:28):
THe people below can manage users via https://sso.us.app.stackstate.io/admin/rancher-hosted/console

---

**Javier Lagos** (2025-11-03 09:52):
Ok! I have got some insights from the customer.

• Outage only affected cluster tooling-2101. 
• There has been no changes on tooling-3002 but customer has commented to me that they didn't check the environment after nodePatching that was applied last Wednesday on the same cluster. They suspect SUSE observability started having issues on cluster tooling-3002 after that outage.
Do you need anything else @Alejandro Acevedo Osorio?

---

**Alejandro Acevedo Osorio** (2025-11-03 09:55):
I'm focusing for now on `tooling-3002` . So if I understand correctly:
• Node patching was performed last Wednesday and the customer didn't really check the environment after that operation.
• On Friday they had an outage (although it only affected `tooling-2101` and that's when they notices issues on `tooling-3002` (which in theory didn't have any impact from the outage)

---

**Javier Lagos** (2025-11-03 09:55):
Exactly. That's what I also understood from them.

---

**Alejandro Acevedo Osorio** (2025-11-03 10:07):
if we would have a clear view of the moment the node patching started and ended it would be great ... and f course if there would be a way to get the logs from the moment of the node patching it would be great. I mean the support package has `tephra` logs from Friday Oct 31st but that's probably won't help us to investigate.

---

**Javier Lagos** (2025-11-03 10:15):
Let me ask them about it

---

**Javier Lagos** (2025-11-03 10:15):
Thanks Alejandro

---

**Javier Lagos** (2025-11-03 10:34):
Hey Alejandro. Here is the latest information from customer. However, I still don't have the logs.

```I might have been a bit unclear, but the incident occured on the 23th of October. The rest is correct! The patching happened for a few hours starting around 10 in the morning on wednesday the 29th of October. It takes a while because we are using Longhorn and it has to rebuild the volumes.```
We might be in front of a wall here as the issue happened a long time ago and without logs we are not going to be able to see what happened...

---

**Alejandro Acevedo Osorio** (2025-11-03 10:35):
I don't get this part `I might have been a bit unclear, but the incident occured on the 23th of October.`  the 23rd of Oct?

---

**Javier Lagos** (2025-11-03 10:35):
It seems to be

---

**Javier Lagos** (2025-11-03 10:42):
Will the configuration restore fix the issue on both clusters? What do you think @Alejandro Acevedo Osorio? What are the options we have here?

---

**Alejandro Acevedo Osorio** (2025-11-03 10:55):
Well that's the only option to restore the cluster for sure, but I was trying to gather more info to get closer to tackle the issue. So my next question is on the `23rd` did they already have `2.6.1` running?

---

**Alejandro Acevedo Osorio** (2025-11-03 10:56):
BTW do you know where the customer servers are located?

---

**Javier Lagos** (2025-11-03 10:59):
That's something I already asked about. and yes. customer said that they didn't perform any operation on SUSE observability and it's been running on 2.6.1 version before the problem started to happen

---

**Javier Lagos** (2025-11-03 11:00):
Do you want me to ask where the servers are located? from tooling-3102?

---

**Alejandro Acevedo Osorio** (2025-11-03 11:09):
https://suse.slack.com/archives/C07CF9770R3/p1762163953544409?thread_ts=1761925829.203589&amp;cid=C07CF9770R3 well this is good piece of info as we have been focusing on the moment the nodes are cycled. But if the customer confirms that the issues were present way before that's a new angle to consider

---

**Javier Lagos** (2025-11-03 11:12):
Maybe I was not really clear. But customer has just confirmed that product was on 2.6.1 version before/after the issue. The issue started to happen after the outage and node patching as we mentioned

---

**Alejandro Acevedo Osorio** (2025-11-03 11:23):
Well it's just that I'm confused about what the `23rd of Oct` has to do ... but anywho ... Given that we don't have logs from the moment the nodes were rotated, I think then we can proceed with the configuration restore

---

**Javier Lagos** (2025-11-03 11:25):
I think that they did mention 23rd of October as the day when they performed the patching while the outage was 29th. They might just realized that both SUSE observability instances were not working the same day.

Thanks @Alejandro Acevedo Osorio!

---

**Bram Schuur** (2025-11-03 14:23):
I forwarded the question to our agent engineers (made a ticket on our board to track it): https://stackstate.atlassian.net/browse/STAC-23731

---

**Alessio Biancalana** (2025-11-03 14:44):
sorry I totally missed this one, thanks @Bram Schuur

---

**David Noland** (2025-11-03 16:46):
What is the reason Rancher OIDC is not supported?

---

**Vladimir Iliakov** (2025-11-03 17:46):
The current Saas automation only supports Keycloak as an OIDC.

---

**Surya Boorlu** (2025-11-03 18:18):
Will raising an FRE to include OIDC possible with present design?

---

**Vladimir Iliakov** (2025-11-03 18:39):
For Saas, for the paid customers, we used to provide the full access to the Keycloak realm where it is possible to configure external IdP. In that case the management of the Keycloak realm was responsibility of the user, effectively meaning if the user messed up with the configuration we could just reset the Realm.
Technically this is possible for http://rancher-hosted.app.stackstate.io/ , though I don't know whether we should take this way. The basic user management is pretty simple and reliable and easier for the saas team to support.

---

**Garrick Tam** (2025-11-04 00:36):
Here's the log bundle.

---

**Surya Boorlu** (2025-11-04 06:55):
@Vladimir Iliakov Thank you for the details. If we could include the OICD, we can directly authenticate with Rancher for SSO across Rancher Prime components in the future.

I see https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/a[…]9L00*czE3NjIyMzQ3NDAkbzkkZzEkdDE3NjIyMzU2NDYkajYwJGwwJGgw (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/security/authentication/oidc.html?_gl=1*64d3b4*_gcl_aw*R0NMLjE3NTg2ODgwMTAuRUFJYUlRb2JDaE1JOXBQZXJzZndqd01WYWtGQkFoMEhzaEIwRUFBWUFTQUFFZ0lMdmZEX0J3RQ..*_gcl_au*MTg0NzI3OTgzMS4xNzU2MTMzODU3*_ga*NDkyMjI0NzU2LjE3NTYxMzM4NTc.*_ga_Y7SFXF9L00*czE3NjIyMzQ3NDAkbzkkZzEkdDE3NjIyMzU2NDYkajYwJGwwJGgw)  it is possible even now. Could you please check and let me know?

---

**Surya Boorlu** (2025-11-04 06:56):
We have the redirectURI available already, we just need to configure it with Observability using the OIDClient CRD.

---

**Vladimir Iliakov** (2025-11-04 07:22):
The documentation you refer to is for the self-hosted installation.

---

**Surya Boorlu** (2025-11-04 07:40):
I am little confused, If the self-hosted Observability stack is capable, ours should also work right as we are hosting it ourself? The charts are same right?

Please correct me if I was wrong.

---

**Vladimir Iliakov** (2025-11-04 08:01):
https://suse.slack.com/archives/C07CF9770R3/p1762188362716469?thread_ts=1762157055.405099&amp;cid=C07CF9770R3

---

**Surya Boorlu** (2025-11-04 08:03):
I see, this is just related to the automation. Thank you @Vladimir Iliakov
I will go ahead and raise the request in Jira.

---

**Surya Boorlu** (2025-11-04 08:09):
Ref: SURE-10919 (https://jira.suse.com/browse/SURE-10919)

---

**Javier Lagos** (2025-11-04 08:59):
Sounds like data corruption, right @Bram Schuur?

```Cannot un-exist verified existing stackelement: v[235903254837176],{}, loaded=VERIFIED, existing=true, verifiedAtTxId=1762111281557000000, lastUpdateTransactionId=null, label=OneWayRelation, edgesIn={}, edgesOut={}, loadTransactionId=1762207385769000000```
FYI @Garrick Tam I did resolve a couple of cases like this by performing a configuration restore https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_rest[…]ackup (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_restore_a_backup)

---

**Bram Schuur** (2025-11-04 09:01):
Indeed @Javier Lagos, i am now investigating whether a cause can be found and what to recommend. I will go over my findings with @Alejandro Acevedo Osorio and report

---

**Garrick Tam** (2025-11-04 16:33):
Thank you for the analysis.  I'll get back to customer with suggestion.

I got more details from customer in case these are helpful.
```Yes this is a new install using the 4000 HA profile. It has a total of six Kubernetes clusters shipping it data and based on ruff node sizing calculations it is getting data from about 2000 nodes worth of compute using the sizing recommendations of 1 node being 4CPU and 16G of RAM. All the pods started and where not in crash loops after the initial install.



And I can throw more IPOS at if needed. Right now it is using our generic EBS storage class with cheap defaults.



And no this will not be our official production cluster for it. We have four Rancher installs so we plan on a Observability install for each based on how the Rancher RBAC works. However this install is the closest sizing and capacity wise to production.



I did do an upgrade from 2.6.1 to 2.6.2 before opening the ticket so the correlate pod restarts might have been related to that.```

---

**Daniel Barra** (2025-11-04 16:57):
*We are pleased to announce the release of 2.6.2, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.2.html).*

---

**Garrick Tam** (2025-11-04 17:37):
&gt; *Could you ask the customer to, if possible, access the `tephra-1` pod through the suse observability UI and get the logs around `2025-10-30 22:06:00 - 23:00:00 UTC` and ship those to us?*
*Can you give more step by step on how to do this?*

---

**Bram Schuur** (2025-11-04 18:12):
I'll try to capture it in a short step-by-step, if it is not clear we can call:
• Open SUSE observability, go to the 'Pods' page (overview)
• Extend the timerange of the view to 7 days (bottom left time picker)
• Click the time line at ~*`2025-10-30 22:15:00`* , this will show all pods active at that time
• From the list scroll navigate to `suse-observability-hbase-tephra-1` pod. It is possible to filter by namespace to filter the list down to SUSE Observability namespace
• In the 'logs' section click 'View All'
• On the logs drawer click-drag on the timeline to select the requested timerange
• Click-drag to select the logs and CTRL-C CTRL-V them into a text file
There is a chance the instance throws errors due to the corrupted state it is in, in which case: tough luck.
You can try to follow these steps on https://observability.suse.com/ by clicking around yourself (only the tephra pod is not there).

If this is too much i can also guide you through on huddle.

---

**Garrick Tam** (2025-11-05 00:01):
Customer restored from backup and everything appears to be working now.  Customer does not ship pod logs to SUSE Observability but will try to gather the pod logs from splunk to help us figure out why things went south.  Their sentiment on this issue is  "this is the 2nd time we have had to restore from configuration which feels wrong. The other time was for a different install but still."

---

**Saurabh Sadhale** (2025-11-05 09:14):
I have asked the customer but they have not responded yet

---

**Garrick Tam** (2025-11-05 17:23):
Here's the hbase-tephra-1 pod log.

---

**Garrick Tam** (2025-11-05 17:23):
Is there an existing bug already opened for this?  Can you please share for my reference?

---

**Bram Schuur** (2025-11-05 17:24):
Fantastic! Thanks :+1:

---

**Bram Schuur** (2025-11-05 17:24):
We have a general epic, I will file specific for this issue when I am behind my pc

---

**Bram Schuur** (2025-11-06 09:05):
I filed the following ticket to track this specifically.

---

**Bram Schuur** (2025-11-06 09:06):
https://stackstate.atlassian.net/browse/STAC-23757

---

**Amol Kharche** (2025-11-06 10:03):
Customer just now shared the logs , Here is the logs.

---

**Amol Kharche** (2025-11-06 10:08):
They said the node is a Jetson AGX Orin with a custom kernel

---

**Andrea Terzolo** (2025-11-06 10:14):
thank you! as we suspected kprobes are not supported on this kernel, this is the technology we use to collect connections from the host...
```# CONFIG_KPROBES is not set```
unfortunately there is not so much to do here, or they rebuild their kernels to support kprobes or they need to run without the process agent
```--set nodeAgent.containers.processAgent.enabled=false```
As said before, this will disable connection tracing so no network correlations will be visible in the UI.

---

**Andrea Terzolo** (2025-11-06 14:35):
Posted a comment here https://jira.suse.com/browse/SURE-10880
TL;DR;
Regarding `container_memory_usage` metric, it comes directly from the container cgroup. More in detail:
for cgroupv1:
• We take the content of the `memory.usage_in_bytes` file
for cgroupv2:
• We take the content of the `memory.current` file

---

**Bram Schuur** (2025-11-06 16:48):
@Daniel Murga @David Noland would it be possible for us developers to get access to SCC? (read only access), would be great to be able to see the communication there with the customer when we get into the engagement and read up on what was already found

---

**Chris Riley** (2025-11-06 17:29):
Hi @Bram Schuur
Things have changed recently as far as SCC is concerned, please see this (https://sites.google.com/suse.com/salesforce/salesforce-service-cloud-operations/support-center/log-in-as-permission) for more details.
The 'L3 Engineering' section is likely your best option here - request a salesforce license.

Hope this helps.

---

**Daniel Murga** (2025-11-06 18:40):
Hey guys! Frank accepted tomorrow's meeting appointment

---

**David Noland** (2025-11-06 20:11):
Thanks Andrea. I'm still trying to pinpoint what exactly is taking up the memory, since Rancher engineering says it doesn't appear to be the rancher process running inside the rancher container. The top output from the container seems to indicate that too:
```Mem: 63312764K used, 1464488K free, 98796K shrd, 3156K buff, 46848908K cached
CPU: 10.8% usr  4.4% sys  0.0% nic 82.8% idle  0.0% io  0.0% irq  1.9% sirq
Load average: 1.91 2.53 2.78 4/1457 18507
  PID  PPID USER     STAT   VSZ %VSZ CPU %CPU COMMAND
   43     1 root     S    7033m 10.9   3  6.3 rancher --http-listen-port=80 --https-listen-port=443 --audit-log-path=/var/log/auditlog/rancher-api-audit.log --audit-level=2 --audit-log-maxage=1 --audit-log-maxbackup=1 --audit-log-maxsize=100 --no-cacerts --http-listen-port=80 --https-listen-port=443 --add-local=true
18502     0 root     R     7720  0.0   3  0.0 top -bn1
    1     0 root     S     2688  0.0   6  0.0 tini -- rancher --http-listen-port=80 --https-listen-port=443 --audit-log-path=/var/log/auditlog/rancher-api-audit.log --audit-level=2 --audit-log-maxage=1 --audit-log-maxbackup=1 --audit-log-maxsize=100 --no-cacerts --http-listen-port=80 --https-listen-port=443 --add-local=true```

---

**Andrea Terzolo** (2025-11-07 12:18):
uhm i see, not all kinds of memory are accounted by `top` maybe you can try to get other metrics like `container_memory_kernel`, `container_memory_rss` , `container_memory_cache` to see where is the bigger footprint. For example `container_memory_cache` shouldn't be accounted by tools like `top` . thanks to your question we are also adding some documentation on these metrics https://github.com/rancher/stackstate-product-docs/pull/112

---

**Bram Schuur** (2025-11-10 10:07):
thanks a bunch!

---

**Bram Schuur** (2025-11-10 10:40):
For completeness: we filed a ticket to improve the documentaiton around apikey/service tokens: https://stackstate.atlassian.net/browse/STAC-23694

---

**IHAC** (2025-11-10 12:25):
@Javier Lagos has a question.

:customer:  AB SANDVIK COROMANT

:facts-2: *Problem (symptom):*  
Hello team!

I'm currently working in a customer case where the Rancher RBAC is not working properly on SUSE Observability specifically on the Open Telemetry section that is available once StackPack is deployed in which I need some of your help to identify the possible root cause of it as I suspect this behavior is happening due to a missing label on the objects.

As far as I have been able to see on a call with the customer the situation is as follow:

1 - Customer has deployed SUSE Observability Open Telemetry StackPack, OpenTelemetry Operator and OpenTelemetry Collector.
2 - Customer commented that some developers has deployed an application that are sending traces to OpenTelemetry Collector.
3 - Applications are visible under "services" menu within OpenTelemetry on SUSE Observability console for an Admin user.
4 - When we are logged as a nonAdmin user with just observer permissions on the namespace where this applications are deployed, we couldn't see nothing inside this menu while it was possible for the user to see other details of the NS like pods, deployments..
5 - I realized that on the services created inside the OpenTelemetry menu there is one label missing `"k8s-scope:segi-tst/&lt;namespace&gt;"` (I will put here some screenshots that will help you understand the issue)
6 - We performed one test by deploying AutoInstrumentation CR along with one custom java pod. We saw that this pod was added with the correct label on the OTEL menu.
7 - We added the previous namespace where we deployed our java testing pod to the same project where the others services are running into.
8 - The same user was able now to see just the service created from our test but still couldn't see the services created by their developers.
9 - I have checked their OpenTelemetryCollector CR and everything looks fine from my side. However, I will share it here with you.

Based on the previous outputs, I'm wondering about the reason behind this behavior. Why the label is not added to the customer applications while it is added on our testing application auto instrumented? Does it mean that RBAC only works with autoInstrumentation? Does the customer need to configure something specifically on their application when sending the traces?

Customer is running SUSE Observability 2.6.2 and latest OpenTelemetry operator version

---

**Javier Lagos** (2025-11-10 12:27):
Here are the labels of our custom JAVA pod deployed while doing some testing . You will see the k8s-scope label

---

**Javier Lagos** (2025-11-10 12:27):
Jira case already created -&gt; https://jira.suse.com/browse/SURE-10941

---

**Javier Lagos** (2025-11-10 12:29):
cc - @Alejandro Acevedo Osorio. I'm pinging you here as I think you have more context about this topic.

---

**Bram Schuur** (2025-11-10 13:49):
It sounds like the traces coming from the application are missing the required labels (`cluster_name` and `namespace`). This was discussed earlier here: https://suse.slack.com/archives/C07CF9770R3/p1760079197645429?thread_ts=1759847266.334559&amp;cid=C07CF9770R3

We have a story on the short-term backlog to properly document how to setup RBAC in OTEL context: https://stackstate.atlassian.net/browse/STAC-23561

---

**Javier Lagos** (2025-11-10 14:08):
Thanks @Bram Schuur!! I can see that cluster_name label is added on the Otel services while namespace is not there.

Do you know how the customer can add this label to the Otel service? Is there any documentation published or not yet?

As far as I can see on the OtelCollecttor, the desired namespace label should be added

```      resource:
        attributes:
          - action: upsert
            key: k8s.cluster.name
            value: segi-tst
          - action: insert
            from_attribute: k8s.pod.uid
            key: service.instance.id
          - action: insert
            from_attribute: k8s.namespace.name
            key: service.namespace```
Thanks!!

---

**Bram Schuur** (2025-11-10 14:16):
I think we take the namespace from `k8s.namespace.name` , not `service.namespace`, am i correct @Frank van Lankvelt?

---

**Javier Lagos** (2025-11-10 14:24):
In our docs I can see the same config.  https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_o[…]lector (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_open_telemetry_collector)

Actually the test pod we created with auto-instrumentation was added into SUSE Observability with the correct labels so I think Collectors are well configured (?)

---

**Frank van Lankvelt** (2025-11-10 14:27):
we indeed use `k8s.namespace.name`  for locating traces/spans for a component, the config just puts the same also on the `service.namespace` resource attribute

---

**Bram Schuur** (2025-11-10 14:31):
I must say i have no more ideas here, @Frank van Lankvelt do you have an idea what could cause the `k8s-scope` to not be there?

---

**Javier Lagos** (2025-11-10 14:32):
I'm wondering if there is anything else that the customer should do on the application side?

---

**Bram Schuur** (2025-11-10 14:34):
Could be. I am going out on a limb here, but i think there is the expectation that `k8s.namespace.name` is set by the application collector. if that is missing i can imagine the symptomps oyu are reporting could happen. So maybe that is something you can check?

---

**Javier Lagos** (2025-11-10 14:38):
I'm not getting your point, sorry. What do we need to check on the customer side? Customer confirmed to me that application is sending traces to collector but it looks like collector is not somehow modifying the output by adding the attribute?? I'm going a bit blind at this point too.

---

**Bram Schuur** (2025-11-10 14:49):
Sorry i'm also a bit new here, what i meant to say is: the application ~collector~  *instrumentation* is i think supposed to report the `k8s.namespace.name`, it might be that is not happening.

@Frank van Lankvelt told me he is looking aswell, he much more knowledgeable on this topic

---

**Frank van Lankvelt** (2025-11-10 14:51):
~I think there may be a slight mismatch between the data coming from kubernetes and that coming in via opentelemetry.  We merge the two sources of data by matching identifiers - at the least this should work on the pod level.~

---

**Frank van Lankvelt** (2025-11-10 14:54):
~the `k8s-scope` label is currently only set by the kubernetes stackpack - so it will be there for pods.~

---

**Frank van Lankvelt** (2025-11-10 15:05):
the `k8s-scope` label is added whenever `k8s.cluster.name` and `k8s.namespace.name` are available on metrics and/or traces sent via otel.

---

**Javier Lagos** (2025-11-10 15:16):
so, if I'm not wrong, k8s-scope label has not been added because there is no k8s.namespace.name label. Am I right?

---

**Javier Lagos** (2025-11-10 15:16):
What can we do to debug this? IS there anything the customer can do on their side?

---

**Frank van Lankvelt** (2025-11-10 15:18):
did you also take a look at https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s.html?  There are some slight differences with pure OTEL

---

**Frank van Lankvelt** (2025-11-10 15:19):
in particular, there is
```presets:
  kubernetesAttributes:
    enabled: true
    extractAllPodLabels: true```
which adds k8s attributes to traces coming from a pod

---

**Frank van Lankvelt** (2025-11-10 15:22):
maybe you can take a look at the traces coming in and see which resource attributes are present there?

---

**Javier Lagos** (2025-11-10 15:23):
Customer, also me, were looking at the following docs to create OpenTelemetry Collectors by using the custom resource instead of the helm chart https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_o[…]lector (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/otel/getting-started/getting-started-k8s-operator.html#_the_open_telemetry_collector)

```apiVersion: opentelemetry.io/v1beta1 (http://opentelemetry.io/v1beta1)
kind: OpenTelemetryCollector
metadata:
  name: otel-collector
  namespace: open-telemetry
spec:
  config:
    connectors:
      spanmetrics:
        metrics_expiration: 5m
        namespace: otel_span
    exporters:
      debug:
        verbosity: detailed
      nop: {}
      otlp/suse-observability:
        auth:
          authenticator: bearertokenauth
        compression: snappy
        endpoint: https://otlp.obs-prd.k8s.coromant.sandvik.com:443
        tls:
          insecure: false
          insecure_skip_verify: true
    extensions:
      bearertokenauth:
        scheme: SUSEObservability
        token: ${env:API_KEY}
      health_check:
        endpoint: ${env:MY_POD_IP}:13133
        path: /
    processors:
      batch: {}
      k8sattributes:
        extract:
          metadata:
            - k8s.namespace.name
            - k8s.deployment.name
            - k8s.statefulset.name
            - k8s.daemonset.name
            - k8s.cronjob.name
            - k8s.job.name
            - k8s.node.name
            - k8s.pod.name
            - k8s.pod.uid
            - k8s.pod.start_time
        passthrough: false
        pod_association:
          - sources:
              - from: resource_attribute
                name: k8s.pod.ip
          - sources:
              - from: resource_attribute
                name: k8s.pod.uid
          - sources:
              - from: connection
      memory_limiter:
        check_interval: 5s
        limit_percentage: 80
        spike_limit_percentage: 25
      resource:
        attributes:
          - action: upsert
            key: k8s.cluster.name
            value: segi-tst
          - action: insert
            from_attribute: k8s.pod.uid
            key: service.instance.id
          - action: insert
            from_attribute: k8s.namespace.name
            key: service.namespace
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      prometheus:
        config:
          scrape_configs:
            - job_name: opentelemetry-collector
              scrape_interval: 10s
              static_configs:
                - targets:
                    - ${env:MY_POD_IP}:8888
    resources:
      limits:
        cpu: 500m
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 512Mi
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
          - ALL
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 1000
      seccompProfile:
        type: RuntimeDefault
    service:
      extensions:
        - health_check
        - bearertokenauth
      pipelines:
        logs:
          exporters:
            - nop
          processors: []
          receivers:
            - otlp
        metrics:
          exporters:
            - debug
            - otlp/suse-observability
          processors:
            - memory_limiter
            - resource
            - batch
          receivers:
            - otlp
            - spanmetrics
            - prometheus
        traces:
          exporters:
            - debug
            - spanmetrics
            - otlp/suse-observability
          processors:
            - memory_limiter
            - resource
            - batch
          receivers:
            - otlp
      telemetry:
        metrics:
          address: ${env:MY_POD_IP}:8888
  configVersions: 3
  daemonSetUpdateStrategy: {}
  deploymentUpdateStrategy: {}
  envFrom:
    - secretRef:
        name: open-telemetry-collector
  ingress:
    route: {}
  ipFamilyPolicy: SingleStack
  managementState: managed
  mode: deployment
  networkPolicy: {}
  observability:
    metrics: {}
  podDnsConfig: {}
  replicas: 1
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 250m
      memory: 512Mi
  targetAllocator:
    allocationStrategy: consistent-hashing
    collectorNotReadyGracePeriod: 30s
    collectorTargetReloadInterval: 30s
    filterStrategy: relabel-config
    observability:
      metrics: {}
    prometheusCR:
      scrapeInterval: 30s
    resources: {}
  upgradeStrategy: automatic```
As I said before. with the applications deployed by the customer there is no label k8s-namespace but when we tried with a custom pod with a custom java applications along with AutoInstrumentation everything worked( all labels and RBAC worked)


_maybe you can take a look at the traces coming in and see which resource attributes are present there? -&gt;_ This is indeed weird. Cause there are no traces on the pods but on the OTEL service. Maybe this is related to the issue?  We saw on the call that the service that belongs to some specific pods did have traces while on the pod view there were no traces.

---

**Frank van Lankvelt** (2025-11-10 15:29):
thanks - that configuration looks solid.  I think it's probably the `k8sattributes` processor that is not able to fully expand the set of resource attributes on an incoming span.  According to https://pkg.go.dev/github.com/open-telemetry/opentelemetry-collector-contrib/processor/k8sattributesprocessor#readme-configuration it uses a "connection IP address" when the pod association is not configured.

---

**Frank van Lankvelt** (2025-11-10 15:30):
It could be that autoinstrumentation add just enough metadata for the k8sattributes processor to function, but that this data is not there on manually instrumented code?

---

**Javier Lagos** (2025-11-10 15:36):
That's the thing. I don't have details, neither the customer since the applications have been developed by another internal team, about how the code was instrumented. Do you think that this behavior is happening because instrumentation made by the customer on the code is not well configured? Would be great to confirm this theory but I don't know how...

---

**Javier Lagos** (2025-11-10 15:36):
The only thing we know for sure is that application is sending traces to SUSE Observability as services can be seen on the UI along with "dotnet" language but with the namespace missing label

---

**Frank van Lankvelt** (2025-11-10 15:45):
you could take a look at the traces/spans that are sent.  If one of them is `k8s.pod.ip`then the attributes processor should have been able to figure out which pod the span came from and enriched it with additional metadata.  (there are some more heuristics - a full example could help to figure out where it fails)

---

**Javier Lagos** (2025-11-10 16:23):
Sorry for the delay @Frank van Lankvelt and thanks for your help. I really appreciate it.

I have been testing on my lab where I have the same auto-instrumented application that works and I cannot see on the traces the k8s.pod.ip neither which seems a bit weird, right?

which is exactly what we should check on the traces?

---

**Frank van Lankvelt** (2025-11-10 16:34):
hmm, in the docs it says
```The processor stores the list of running pods and the associated metadata. When it sees a datapoint (log, trace or metric), it will try to associate the datapoint
to the pod from where the datapoint originated, so we can add the relevant pod metadata to the datapoint. By default, it associates the incoming connection IP
to the Pod IP. But for cases where this approach doesn't work (sending through a proxy, etc.), a custom association rule can be specified.```
so the k8s attributes processor seems to be able to figure out which pod sent a trace based on the  connection.  So seems like the k8s.pod.ip is indeed not necessary.

---

**Frank van Lankvelt** (2025-11-10 16:35):
I think it would be valuable to see what metadata is available on the traces that are not enriched properly - I still suspect the k8s attributes processor is not able to determine the pod

---

**Javier Lagos** (2025-11-10 17:47):
Do you mean resource attributes of the traces from the services that are not getting the correct labels? I can ask to the customer to provide that if you need that to continue debugging the issue.

---

**Garrick Tam** (2025-11-10 19:23):
Here's the agent log bundle.

---

**Garrick Tam** (2025-11-11 01:36):
I filed https://jira.suse.com/browse/SURE-10945 for this.

---

**IHAC** (2025-11-11 02:54):
@David Noland has a question.

:customer:  Hosted Rancher

:facts-2: *Problem (symptom):*  
I created a monitor called "Terminating namespaces" but when I try view it, I get forbidden. See thread for screen capture

---

**David Noland** (2025-11-11 02:56):
Was getting this. But I logged out and in again and it's working now

---

**Andrea Terzolo** (2025-11-11 08:36):
thank you i will take a look ASAP!

---

**Daniel Murga** (2025-11-11 09:42):
Morning guys! Rabobank opened a new splunk related case last friday:
_"The Splunk topology sync is not working anymore in our PA and Production environment._
_Topology changes are not always shown. In those occasions we dont see the data reaching Kafka. We did see all correct data in Splunk and that the integration did start the jobs in splunk and they ran fine._

_After restarting the sync pod tags where updated. But later it stops working again._
_So its not clear what is happening and why it sometimes is working and at other times its not_

_We checked the podlogs disabled some searches that we did not trust but that did not resolve the issue._
_It was known to us that we have 502 bad gateway errors in there. We checked if the occur every 15m (thats our sync interval for topo) but that was also not the case and even at moment where log wise everything seems fine we where still not getting updates._

_Versions of the connectors:_
_TEST/PA SPLUNK AGENT (V2) : image: quay.io/stackstate/stackstate-k8s-agent:dd103bf5 (http://quay.io/stackstate/stackstate-k8s-agent:dd103bf5)_
_PRD SPLUNK AGENT (v1): image: quay.io/stackstate/stackstate-k8s-agent:c4caacef (http://quay.io/stackstate/stackstate-k8s-agent:c4caacef)._

_We also have a case open for health data that stopped working about 2 weeks ago:_
_SUSE Case 01600607_
_That is currently still working but i wonder of some of these issues have a similar cause. In that case we have not been able to find a root cause why it happend and also no way to preventing this in the future since we dont know what happend._
_Now with Topo we are facing a similar issue also not knowing what is going on._

_We are currently downloading all logs and will add them tot this case soon._
_"_

---

**Daniel Murga** (2025-11-11 09:44):
I asked them to discuss in tomorrow's meeting as it's strictly related to the previous case

---

**Bram Schuur** (2025-11-11 15:37):
thanks for picking this up @Andrea Terzolo, i filed the following issue to track and put a release not: https://stackstate.atlassian.net/browse/STAC-23813

---

**IHAC** (2025-11-11 17:27):
@Rodolfo de Almeida has a question.

:customer:  NATO Communications and Information Agency

:facts-2: *Problem (symptom):*  
*Subject*
The customer opened a case complaining about a high number of CRITICAL and HIGH vulnerabilities detected in the SUSE Observability and SUSE Observability Agent container images.

*Description*
They scanned SUSE Observability container images using Prisma and Anchore and found over:
• 500 CVEs in Observability Agent - 11 CRITICAL and 126 HIGH
• 2900 CVEs in Observability - 19 CRITICAL and 731 HIGH.
Scanning Tools are Prisma and Anchore.

They said that the product cannot be used on their networks because of these findings.

They also mentioned a note that https://scans.rancher.com/ does not cover SUSE Observability, yet.

Is this a known issue? Should I open a Jira ticket about this case?

---

**Giovanni Lo Vecchio** (2025-11-11 17:48):
Hi Team!
I opened a Jira ticket (https://jira.suse.com/browse/SURE-10944) for Rabobank; is there someone that can take a look at it?

The case is still in _needs-triage_ stage.

TIA!

---

**Chris Riley** (2025-11-11 18:44):
@Louis Lotter ^^

---

**Louis Lotter** (2025-11-11 21:14):
Hi guys. My team and myself are all EU time zone. So we're all going to bed atm.
Can this wait for tomorrow ?

---

**Chris Riley** (2025-11-11 21:52):
No problem, Louis. I was just flagging this for you, for tomorrow morning.

---

**Bram Schuur** (2025-11-12 09:07):
The HAR file is only showing 200s, there are some errors in the API, but those cannot be directly linked to the frontend because all responses to the frontendare 200s.

@Giovanni Lo Vecchio could you get a log of the web inspector (browser) console output? I am thinking this is a frontend issue.

---

**Bram Schuur** (2025-11-12 09:10):
tagging @Louis Parkin and @Louis Lotter here.

We are working on getting our CVE status up on scans.rancher.com (http://scans.rancher.com) and are working on bringing CVEs down.

Do these number match with your latest reports @Louis Parkin?

@Rodolfo de Almeida i think it is worth it opening a jira ticket. We are actively working on bringing CVEs down, but it competes with other priorities, so opening a ticket laying out what this means for your customer can help us prioritize in your customers favor.

---

**Louis Parkin** (2025-11-12 09:13):
Hey @Bram Schuur we could get close to those numbers if we include severities below HIGH. But I don’t have numbers that reflect the same high and critical counts as those above. I logged new tickets yesterday for you and Remco to prioritize.

---

**Giovanni Lo Vecchio** (2025-11-12 09:14):
Hi @Bram Schuur, Thank you for the reply.
I’m going to ask the customer about that.

---

**Giovanni Lo Vecchio** (2025-11-12 09:15):
Hi @Alejandro Acevedo Osorio,
FYI -
```grp-suse_observability-test-reader:

     systemPermissions:

      - get-permissions

      - get-notifications

      - get-api-tokens

      - get-dashboards

      - get-metric-bindings

      - get-monitors

      - get-system-notifications

      - get-topic-messages

      - get-settings

      - execute-component-actions

     resourcePermissions:

      get-topology:

       - "k8s-scope:test/test"

      get-traces:

       - "k8s.scope:test/test"

      get-views:

       - "test-namespaces"

      get-metrics:

       - "k8s:test:test"



this is working fine. You can close the case.```

---

**Giovanni Lo Vecchio** (2025-11-12 09:16):
Thank you, @Alejandro Acevedo Osorio and @Javier Lagos

---

**Alejandro Acevedo Osorio** (2025-11-12 09:16):
Than you @Giovanni Lo Vecchio :thumbs-up:

---

**Louis Parkin** (2025-11-12 09:54):
@Bram Schuur @Louis Lotter this is what I have for the latest releases:
```=============================================================================================================================================================
Helm chart: suse-observability/suse-observability
=============================================================================================================================================================
Image                                                                                                       Critical High Medium Low Negligible Unknown Total
-------------------------------------------------------------------------------------------------------------------------------------------------------------
registry.rancher.com/suse-observability/clickhouse-backup:2.6.38-9157204e (http://registry.rancher.com/suse-observability/clickhouse-backup:2.6.38-9157204e)                                          2   23     23   2          0       0    50
registry.rancher.com/suse-observability/clickhouse:24.12.3-debian-12-r1-59d02972 (http://registry.rancher.com/suse-observability/clickhouse:24.12.3-debian-12-r1-59d02972)                                   4   19     17  31          0       0    71
registry.rancher.com/suse-observability/container-tools:1.8.0-bci (http://registry.rancher.com/suse-observability/container-tools:1.8.0-bci)                                                  1   22     10   0          0       0    33
registry.rancher.com/suse-observability/elasticsearch-exporter:v1.8.0-d2aa61ab (http://registry.rancher.com/suse-observability/elasticsearch-exporter:v1.8.0-d2aa61ab)                                     3   14     12   2          0       0    31
registry.rancher.com/suse-observability/elasticsearch:8.19.4-8fb32031 (http://registry.rancher.com/suse-observability/elasticsearch:8.19.4-8fb32031)                                              0    3     10   9          0       0    22
registry.rancher.com/suse-observability/envoy:v1.31.1-92f410cd (http://registry.rancher.com/suse-observability/envoy:v1.31.1-92f410cd)                                                     0    1      6  12          0       0    19
registry.rancher.com/suse-observability/hadoop:3.4.1-java21-8-11835454 (http://registry.rancher.com/suse-observability/hadoop:3.4.1-java21-8-11835454)                                             0   16     44  24          0       0    84
registry.rancher.com/suse-observability/hbase-master:2.5-7.11.11 (http://registry.rancher.com/suse-observability/hbase-master:2.5-7.11.11)                                                   0   18     12   3          0       0    33
registry.rancher.com/suse-observability/hbase-regionserver:2.5-7.11.11 (http://registry.rancher.com/suse-observability/hbase-regionserver:2.5-7.11.11)                                             0   18     12   3          0       0    33
registry.rancher.com/suse-observability/jmx-exporter:0.17.0-e3374eb0 (http://registry.rancher.com/suse-observability/jmx-exporter:0.17.0-e3374eb0)                                               0   13     26  26          0       0    65
registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402 (http://registry.rancher.com/suse-observability/kafka:3.6.2-aec2a402)                                                       2   33     44  10          0       0    89
registry.rancher.com/suse-observability/kafkaup-operator:0.0.4 (http://registry.rancher.com/suse-observability/kafkaup-operator:0.0.4)                                                     1   15      8   0          0       0    24
registry.rancher.com/suse-observability/kubernetes-rbac-agent:35ec5206 (http://registry.rancher.com/suse-observability/kubernetes-rbac-agent:35ec5206)                                             0   10      0   0          0       0    10
registry.rancher.com/suse-observability/minio:RELEASE.2025-01-13T16-22-00Z-4ae4220f (http://registry.rancher.com/suse-observability/minio:RELEASE.2025-01-13T16-22-00Z-4ae4220f)                                3   34     59  46          0       0   142
registry.rancher.com/suse-observability/nginx-prometheus-exporter:1.4.0-11589218739 (http://registry.rancher.com/suse-observability/nginx-prometheus-exporter:1.4.0-11589218739)                                2   14      8   0          0       0    24
registry.rancher.com/suse-observability/spotlight:5.2.0-snapshot.168 (http://registry.rancher.com/suse-observability/spotlight:5.2.0-snapshot.168)                                               2  101   3102 109          1       0  3315
registry.rancher.com/suse-observability/stackgraph-console:2.5-7.11.11 (http://registry.rancher.com/suse-observability/stackgraph-console:2.5-7.11.11)                                             0   18     16   4          0       0    38
registry.rancher.com/suse-observability/stackpacks:20251020091714-master-92b6a08-2_0-prime-selfhosted (http://registry.rancher.com/suse-observability/stackpacks:20251020091714-master-92b6a08-2_0-prime-selfhosted)              0    0      0   2          0       0     2
registry.rancher.com/suse-observability/stackstate-correlate:7.0.0-snapshot.20251030130227-master-9bdda25 (http://registry.rancher.com/suse-observability/stackstate-correlate:7.0.0-snapshot.20251030130227-master-9bdda25)          0   12     12   4          0       0    28
registry.rancher.com/suse-observability/stackstate-kafka-to-es:7.0.0-snapshot.20251030130227-master-9bdda25 (http://registry.rancher.com/suse-observability/stackstate-kafka-to-es:7.0.0-snapshot.20251030130227-master-9bdda25)        0   12     12   4          0       0    28
registry.rancher.com/suse-observability/stackstate-receiver:7.0.0-snapshot.20251030130227-master-9bdda25 (http://registry.rancher.com/suse-observability/stackstate-receiver:7.0.0-snapshot.20251030130227-master-9bdda25)           0   12     12   4          0       0    28
registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20251030130227-master-9bdda25-2.5 (http://registry.rancher.com/suse-observability/stackstate-server:7.0.0-snapshot.20251030130227-master-9bdda25-2.5)         0   16     20   5          0       0    41
registry.rancher.com/suse-observability/stackstate-ui:7.0.0-snapshot.20251030130227-master-9bdda25 (http://registry.rancher.com/suse-observability/stackstate-ui:7.0.0-snapshot.20251030130227-master-9bdda25)                 0    1      3   2          0       0     6
registry.rancher.com/suse-observability/tephra-server:2.5-7.11.11 (http://registry.rancher.com/suse-observability/tephra-server:2.5-7.11.11)                                                  0   18     14   4          0       0    36
registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-accea47f (http://registry.rancher.com/suse-observability/victoria-metrics:v1.109.0-accea47f)                                         1   13      8   2          0       0    24
registry.rancher.com/suse-observability/vmagent:v1.109.0-e6dc53fb (http://registry.rancher.com/suse-observability/vmagent:v1.109.0-e6dc53fb)                                                  1   13      8   2          0       0    24
registry.rancher.com/suse-observability/wait:1.0.11-04b49abf (http://registry.rancher.com/suse-observability/wait:1.0.11-04b49abf)                                                       0    3      2   2          0       0     7
registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7 (http://registry.rancher.com/suse-observability/zookeeper:3.8.4-85653dc7)                                                   2   31     42  10          0       0    85

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Totals                                                                                                            24  503   3542 322          1       0  4392

=============================================================================================================================================================
Helm chart: suse-observability/suse-observability-agent
=============================================================================================================================================================
Image                                                                                                       Critical High Medium Low Negligible Unknown Total
-------------------------------------------------------------------------------------------------------------------------------------------------------------
registry.rancher.com/suse-observability/generic-sidecar-injector:sha-5678567f (http://registry.rancher.com/suse-observability/generic-sidecar-injector:sha-5678567f)                                      1   12      9   0          0       0    22
registry.rancher.com/suse-observability/promtail:2.9.15-2a5cc100 (http://registry.rancher.com/suse-observability/promtail:2.9.15-2a5cc100)                                                   0   10      1   1          0       0    12
registry.rancher.com/suse-observability/stackstate-k8s-agent:de9360ab (http://registry.rancher.com/suse-observability/stackstate-k8s-agent:de9360ab)                                              5   32     27   3          0       0    67
registry.rancher.com/suse-observability/stackstate-k8s-cluster-agent:de9360ab (http://registry.rancher.com/suse-observability/stackstate-k8s-cluster-agent:de9360ab)                                      2   20     13   2          0       0    37
registry.rancher.com/suse-observability/stackstate-k8s-process-agent:644a2640 (http://registry.rancher.com/suse-observability/stackstate-k8s-process-agent:644a2640)                                      0   13      4   2          0       0    19

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Totals                                                                                                             8   87     54   8          0       0   157```

---

**Louis Parkin** (2025-11-12 09:55):
As you can see, @Bram Schuur, nowhere near 500 for the agent, even if we include CVEs below `High` Severity

---

**Bram Schuur** (2025-11-12 09:56):
thanks @Louis Parkin, @Rodolfo de Almeida could you verify what version of the platform/agent chart this scan was produced on?

---

**Louis Parkin** (2025-11-12 09:56):
@Bram Schuur I might be missing images here, I am busy double-checking.

---

**Louis Parkin** (2025-11-12 10:17):
To confirm, I did not miss images, the `rbac-agent` and `container-tools` are not listed under the agent chart because they are already accounted for by the platform chart.

---

**Louis Parkin** (2025-11-12 10:19):
@Rodolfo de Almeida could you also confirm the scanning tool that was used to produce the numbers you cited?

---

**Chris Riley** (2025-11-12 10:21):
@Louis Parkin - Rodolfo mentioned the scanning tools in his original post:

_Scanning Tools are Prisma and Anchore._

---

**Louis Parkin** (2025-11-12 10:21):
Thanks @Chris Riley, I missed that.

---

**Louis Parkin** (2025-11-12 10:22):
Anchore is dead though, as far as I know, the github repo was archived two years ago.

---

**Louis Parkin** (2025-11-12 10:22):
They replaced it with Syft and Grype.

---

**Chris Riley** (2025-11-12 10:26):
OK, I guess we can push back to an extent regarding the results from Anchore then?

The customer provided these attachments so sharing them here, maybe they help. Rodolfo will be online in a few hours.

---

**Louis Parkin** (2025-11-12 10:30):
&gt; OK, I guess we can push back to an extent regarding the results from Anchore then?
I wouldn't say that, no.  I just find it interesting that it is still being used.

---

**Louis Parkin** (2025-11-12 10:30):
I'll have a look at the spreadsheets, thanks Chris.

---

**Louis Parkin** (2025-11-12 10:31):
@Bram Schuur FYI, including the container-tools and rbac-agent totals under the agent brings us to 200 total across all severities for all images in the chart, still not the 500 mentioned.

---

**Louis Parkin** (2025-11-12 10:36):
It is worth noting, we deduplicate CVE occurrences within the same image.  So if `clickhouse:24.12.3-debian-12-r1-59d02972` had CVE-2020-xyzabc occurring 20 times, we count it as one, because it is one CVE.

---

**Louis Lotter** (2025-11-12 10:42):
@Chris Riley I think the key question here for me is what amount of CVE's this customer will find acceptable. We could put in some serious effort to reduce these numbers again. It's something we do as regularly as we can considering the small team and everything else we have to do but there are limits to how low we can get it. Some CVE's would require massive effort.
As this is NATO I do wonder if their requirements are simply unfeasible for us to reach atm.

---

**Louis Parkin** (2025-11-12 10:45):
&gt; It is worth noting, we deduplicate CVE occurrences within the same image.  So if `clickhouse:24.12.3-debian-12-r1-59d02972` had CVE-2020-xyzabc occurring 20 times, we count it as one, because it is one CVE.
I ran the counts without SELECT DISTINCT, and they are the same, so in this instance,  we don't have duplicates per image. Our totals are what I said they are.

---

**Chris Riley** (2025-11-12 10:46):
@Louis Lotter Understood. This is perhaps a conversation that we'll need to have with the customer and their CSM (I've already reached out to the CSM, waiting their response).
@Rodolfo de Almeida - we can discuss this aspect later today when you are available.

---

**Giovanni Lo Vecchio** (2025-11-12 11:24):
Hello!
Browser logs attached to the Jira case.

---

**Bram Schuur** (2025-11-12 11:30):
@Remco Beckers @Anton Ovechkin I see the following browser log:

```BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'creationTimestamp')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
    at oY (BrowserPageTitle-CSwqBj-E.js:32:39822)
    at Vht (BrowserPageTitle-CSwqBj-E.js:32:39748)
    at w_ (BrowserPageTitle-CSwqBj-E.js:32:39598)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'serviceType')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
    at oY (BrowserPageTitle-CSwqBj-E.js:32:39822)
    at Vht (BrowserPageTitle-CSwqBj-E.js:32:39748)
    at w_ (BrowserPageTitle-CSwqBj-E.js:32:39598)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'clusterIP')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
    at oY (BrowserPageTitle-CSwqBj-E.js:32:39822)
    at Vht (BrowserPageTitle-CSwqBj-E.js:32:39748)
    at w_ (BrowserPageTitle-CSwqBj-E.js:32:39598)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'externalIP')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
    at oY (BrowserPageTitle-CSwqBj-E.js:32:39822)
    at Vht (BrowserPageTitle-CSwqBj-E.js:32:39748)
    at w_ (BrowserPageTitle-CSwqBj-E.js:32:39598)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'namespaceIdentifier')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:62179
    at Array.map (&lt;anonymous&gt;)
    at xn (View-BtuPPYDO.js:2:62151)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  TypeError: Cannot read properties of undefined (reading 'clusterNameIdentifier')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:62179
    at Array.map (&lt;anonymous&gt;)
    at xn (View-BtuPPYDO.js:2:62151)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
wM @ BrowserPageTitle-CSwqBj-E.js:32
VK.r.callback @ BrowserPageTitle-CSwqBj-E.js:32
Dz @ BrowserPageTitle-CSwqBj-E.js:30
eB @ BrowserPageTitle-CSwqBj-E.js:32
eY @ BrowserPageTitle-CSwqBj-E.js:32
Nht @ BrowserPageTitle-CSwqBj-E.js:32
zht @ BrowserPageTitle-CSwqBj-E.js:32
Xd @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
BrowserPageTitle-CSwqBj-E.js:32  Uncaught TypeError: Cannot read properties of undefined (reading 'creationTimestamp')
    at xn (View-BtuPPYDO.js:2:62067)
    at View-BtuPPYDO.js:2:60331
    at Object.useMemo (BrowserPageTitle-CSwqBj-E.js:30:23368)
    at Me.useMemo (BrowserPageTitle-CSwqBj-E.js:9:6253)
    at Um (View-BtuPPYDO.js:2:60319)
    at KL (BrowserPageTitle-CSwqBj-E.js:30:17033)
    at uY (BrowserPageTitle-CSwqBj-E.js:32:44104)
    at oY (BrowserPageTitle-CSwqBj-E.js:32:39822)
    at Vht (BrowserPageTitle-CSwqBj-E.js:32:39748)
    at w_ (BrowserPageTitle-CSwqBj-E.js:32:39598)
xn @ View-BtuPPYDO.js:2
(anonymous) @ View-BtuPPYDO.js:2
useMemo @ BrowserPageTitle-CSwqBj-E.js:30
Me.useMemo @ BrowserPageTitle-CSwqBj-E.js:9
Um @ View-BtuPPYDO.js:2
KL @ BrowserPageTitle-CSwqBj-E.js:30
uY @ BrowserPageTitle-CSwqBj-E.js:32
oY @ BrowserPageTitle-CSwqBj-E.js:32
Vht @ BrowserPageTitle-CSwqBj-E.js:32
w_ @ BrowserPageTitle-CSwqBj-E.js:32
PM @ BrowserPageTitle-CSwqBj-E.js:32
rY @ BrowserPageTitle-CSwqBj-E.js:32
M @ BrowserPageTitle-CSwqBj-E.js:17
ht @ BrowserPageTitle-CSwqBj-E.js:17
[NEW] Explain Console errors by using Copilot in Edge: click
         
         to explain an error. 
        Learn more
        Don't show again
BrowserPageTitle-CSwqBj-E.js:52  [WebSocketProvider] Server connectivity issues, retrying in 5000ms
warn @ BrowserPageTitle-CSwqBj-E.js:52
shouldReconnect @ index-Cf4Q7AZ7.js:213
VIt.e.onclose @ index-Cf4Q7AZ7.js:213```
I have the very strong hunch that a kubernetes services componenttype is applied to a dyntrace component (which might be wrong or not wrong). I think at least the frontend should be resilient to this case

---

**Remco Beckers** (2025-11-12 11:36):
I agree it shouldn't blow up indeed

---

**Anton Ovechkin** (2025-11-12 13:48):
it is so odd… we do not use most the listed fields, but the ones which we use are extracted in a safe way :thinking_face:

---

**Rodolfo de Almeida** (2025-11-12 13:50):
@Bram Schuur  The customer mentioned on the case that they performed all tests on version 2.6.2. I believe the spreadsheets contains all image versions scanned by the customer, correct? Do you still need any further information?

---

**Daniel Murga** (2025-11-12 14:10):
Error: *UnknownHostException: suse-observability-kafka-1.suse-observability-kafka-headless.suse-observability.svc.cluster.local*

---

**Rodolfo de Almeida** (2025-11-12 14:11):
A Jira was created for this case. https://jira.suse.com/browse/SURE-10951
It is not automatically assigning to the SUSE Observability team. Who should I assign this Jira ticket?

---

**Louis Lotter** (2025-11-12 14:38):
The team and components are already correct.

---

**Rodolfo de Almeida** (2025-11-12 14:56):
Great, thanks for confirming @Louis Lotter

---

**Daniel Murga** (2025-11-12 15:14):
Thanks for you time @Bram Schuur

---

**Daniel Murga** (2025-11-12 15:15):
So... values had been changed and waiting customer feedback

---

**Chris Riley** (2025-11-12 17:22):
I know that @Rodolfo de Almeida is planning to have a call with the customer, but I'm just sharing the customer response (Rodolfo asked what their expectations were):

_I understand that this work is difficult and endlessly needs to be kept up to date. Luckily, we're not due to deliver for several months._

_Our standard policy is to accept 0 critical, max 1 high or 2 mediums._
_Our delivery milestone is in May 2026, so this gives you some time to remediate._

_I could also suggest that if you see any "false positives" that we can justify that something is not in use or protected due to the RKE2 CIS profile: I am not certain that this will get accepted by our security team._

_Alternatively, if SUSE can provide a remediation plan, with clear milestones then we might be able to proceed._

---

**Rodolfo de Almeida** (2025-11-12 17:23):
Thanks Chris

---

**Louis Lotter** (2025-11-12 17:26):
@Chris Riley I believe you will have to engage with @Mark Bakker and maybe @Jeff Hobbs or someone on that level to figure out how important this customer is and if it will make sense for us to focus on this.

---

**Chris Riley** (2025-11-12 17:27):
@Louis Lotter as a starting point, I can setup a short call for us with the account team for Nato, does that work for you?

---

**Louis Lotter** (2025-11-12 17:27):
we of course want to get things to be an a better state but 1 high or 2 mediums is quite extreme

---

**Louis Lotter** (2025-11-12 17:28):
yeah of course

---

**Chris Riley** (2025-11-12 17:28):
I agree, they are asking for a lot here. I'll see if I can schedule something in for tomorrow.

---

**IHAC** (2025-11-13 08:17):
@Daniel Murga has a question.

:customer:  Ministere de l'Agriculture

:facts-2: *Problem (symptom):*  
*Component*: SUSE Observability Kubernetes Agent
*Feature*: Collect logs and send it to SUSE Observability (https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/logs/k8sTs-log-shipping.html#_agent_installation).
*Issue/request:* 
Customer is running JAVA applications and expects stacktraces to be correctly formated once collected and sent to SUSE Observability.
*Investigation*:
• We're currently using Promtail container deployed to each node to collect logs and send it to SUSE Observability.
• Promtail configuration is applied using a configmap defined in helm chart --&gt;  suse-observability/suse-observability-agent 
• Currently there's 2 shipped in pipelines:
```pipeline_stages:
  - docker: {}
  - cri: {}```
• To properly handle Java stack traces and multi-line logs, we would typically need a multiline pipeline stage in Promtail configuration similar to:
```pipeline_stages:
  - docker: {}
  - cri: {}
  - multiline:
      firstline: '^\d{4}-\d{2}-\d{2}'  # Java timestamp pattern
      max_lines: 128
      max_wait_time: 3s```
• Helm chart does not provide this flexibility
1. Do you think it's interesting to create a RFE?
2. Or should I encourage customer to create their own customized Observability Agent Helm Chart?
Thanks!

---

**Bram Schuur** (2025-11-13 09:14):
I think an RFE would be most appropriate, although it will most likely not be picked up very soon (i think we'd defer this to our upcoming OTEL logging epic). Having the RFE puts that requirement on our radar though.

I would not encourage a customer to make their own helm chart. We do don't provide release nodes beyond the helm chart, so they'll be pretty much in unsupported mode from that moment on.

---

**Daniel Murga** (2025-11-13 09:21):
Thanks @Bram Schuur! So... RFE in jira.suse.com (http://jira.suse.com)?

---

**Daniel Murga** (2025-11-13 11:18):
Project SURE (https://jira.suse.com/browse/SURE-10948)?

---

**Daniel Murga** (2025-11-13 11:26):
https://jira.suse.com/browse/SURE-10954

---

**Chris Riley** (2025-11-13 13:03):
@Rodolfo de Almeida - Louis and myself just had a call with the CSM and AE about this. We agreed that a call with the customer is needed in order to fully understand their expectations and agree a plan.
Can you please setup a call with the customer and invite both Louis and @Sander de Jonge (AE). As it's SKO next week, a call either later today or tomorrow would be best - if possible.

---

**Rodolfo de Almeida** (2025-11-13 13:20):
Hello @Chris Riley
I will send and e-mail to the customer asking for a call as soon as possible.

---

**Rodolfo de Almeida** (2025-11-13 14:51):
Customer said they are available today 4pm Amsterdam time.
I am scheduling a meeting and will share the invitation to you in a few minutes

---

**Rodolfo de Almeida** (2025-11-13 14:54):
SUSE Support -  Case 01604993
Video call link: https://meet.google.com/whg-ddmx-bie

---

**Chris Riley** (2025-11-13 14:58):
Sander is not in this channel, did you send the invite to him?

---

**Chris Riley** (2025-11-13 14:59):
Just seen it!

---

**Rodolfo de Almeida** (2025-11-13 14:59):
Yes, I just sent the meeting invitation to the corporate email.

---

**Giovanni Lo Vecchio** (2025-11-13 15:21):
hey guys! thank you all for the reply!
do you have any updates?
TIA!

---

**Javier Lagos** (2025-11-13 16:47):
Hey Guys! After working with the customer we can finally see the traces correctly and apply RBAC so that one user with observer privileges can see OTEL menu as well as the namespace where pods sending tracing are located.

However, I think we have found a bug here related to metrics within OTEL menu that I've been able to replicate.

I have deployed a dummy java auto-instrumented application that is sending traces through OpenTelemetry collector.

If I go to OTEL menu -> Service -> Metric with an admin user I am able to see all metrics perfectly ( see attached screenshot)

but If I do the same with my test user with just observer permissions on the dummy project where dummy namespace is located I can see the traces while metrics view is empty.

The same behavior is happening on the customer's environment.

cc - @Alejandro Acevedo Osorio, @Frank van Lankvelt

---

**Andrea Terzolo** (2025-11-13 17:08):
the fix was merged, see more details here https://stackstate.atlassian.net/browse/STAC-23813
it's not clear to me how should i mark the ticket here https://jira.suse.com/browse/SURE-10945 if i try to resolve it, it asks me the release that contains the fix but at the moment no releases contain the the fix

---

**Andrea Terzolo** (2025-11-13 17:09):
2.6.2 should be release that will contain the fix but it is not yet released

---

**David Noland** (2025-11-13 17:41):
You just put "SUSE Observability 2.6.2" as the Fix Version/s. I made the change.

---

**David Noland** (2025-11-13 17:45):
no problem

---

**Bram Schuur** (2025-11-13 19:30):
A ticket was filed and will be picked up with critical priority: https://stackstate.atlassian.net/browse/STAC-23823 (https://stackstate.atlassian.net/browse/STAC-23823)

---

**Giovanni Lo Vecchio** (2025-11-14 08:51):
Thank you, Bram!

---

**Alejandro Acevedo Osorio** (2025-11-14 11:08):
Hi @Javier Lagos, thanks for reporting it. We identified the bug when ingesting otel metrics that's preventing to apply correctly the `scope` to them. We created this bug ticket https://stackstate.atlassian.net/browse/STAC-23828 and most likely will be ready on the next release.

---

**Javier Lagos** (2025-11-14 11:09):
Thanks @Alejandro Acevedo Osorio!! Really appreciate your help.

---

**Rodolfo de Almeida** (2025-11-14 14:36):
Hello @Louis Lotter @Chris Riley @Sander de Jonge
Thanks for the meeting with the customer yesterday.
I would just like to understand what the next steps for this case will be and how I can follow the progress to keep the customer updated.
I know this is an unusual case, and for that reason, I would like to align on how we should proceed from now on.
Thank you.

---

**Louis Lotter** (2025-11-14 14:53):
from my perspective I don't have any todos. We will be fixing some low hanging fruit with the cve's but nothing that will satisfy NATO until that directive is given by upper management.

---

**Chris Riley** (2025-11-14 15:00):
@Rodolfo de Almeida I would say that the case can stay 'paused' for the moment. @Sander de Jonge has the action to flag this with senior leadership within the product org to see what level of work we are able to commit to here.
Stay tuned for more updates ..

---

**Louis Parkin** (2025-11-14 16:25):
@Rodolfo de Almeida @Sander de Jonge @Chris Riley do you guys know what the deal is with Rancher and RKE2?
I see lots of CVEs there, but it is my understanding NATO is already running the software?
RKE2 -&gt; https://scans.rancher.com/rke2-v1.34.1.html
Rancher -&gt; https://scans.rancher.com/rancher-v2.13-head.html

---

**Sander de Jonge** (2025-11-14 16:28):
I understand that we supplies a VEX file with explanations. However if you want to be sure, you should add Jurrien Bloemen to this channel. When he was still the SA he  workes with the NATO team to get Rancher validated.

---

**Chris Riley** (2025-11-14 16:36):
Added @Jurriën Bloemen

---

**Jurriën Bloemen** (2025-11-14 16:45):
What seems to be the problem? It seems like sales want to sell them Observability but the customer states there are too many CVE's in the product. Sounds like we need to fix some issue's/CVE's.

---

**Louis Parkin** (2025-11-14 17:17):
The customer appetite for CVEs is 0 to 3. Either total or per image, but still, a tough target to achieve given availability of engineers to do the work. Also, Rancher and RKE2 scans don’t meet this requirement, but the customer uses the product, how?

---

**Rodolfo de Almeida** (2025-11-14 17:38):
The customer mentioned in our meeting that there are ways to validate the use of SUSE Observability in their production environment. As @Sander de Jonge pointed out, if we can provide a VEX file with explanations, such as when the CVE will be fixed, whether it is relevant, whether it can be exploited, and whether any configurations can prevent the vulnerability from being exploited, the customer’s security team will be able to evaluate the use of SUSE Observability.
They are planning to install SUSE Observability next year, so we have approximately six months from now to work with them on this.

---

**Max Ross** (2025-11-14 17:45):
We’re updating processes on the SSE side to catch unassigned Jiras so that we are quicker to take a look when things don’t come up via Slack, and this ticket showed up in my new filter (https://jira.suse.com/issues/?filter=183685)

Bram, I’m going to assign to you, but feel free to adjust as needed and apologies if it’s any inconvenience!

---

**David Noland** (2025-11-14 18:19):
JFYI - I believe we currently have an agreement with Dell to deliver RKE2 with a limited number of CVEs and within a set time limit. It requires significant engineering work, but I believe Dell pays substantially for this. We may be able to leverage processes and resources if we need to do this for SUSE Observability.

---

**Daniel Murga** (2025-11-17 11:38):
Hi @Alejandro Acevedo Osorio, customer created a new case related to this issue... here's what they're providing:

"Recently I opened the following case 01600368 about the Rancher RBAC not working. This was fixed till the point where I would add a user to a project and the project would be visible in Observability. The issue now is that for example: get monitors instance.observability.cattle.io (http://instance.observability.cattle.io) doesn't work. Only the recommended access permissions seem to work. I don't see the opentelemetry or monitors section for example. Last time we came to the conclusion that these default roles should be accessible in Rancher straight away, but these are not created in our Rancher environment, so I had to make them myself.
What could be going wrong here? Thanks in advance."

---

**Daniel Murga** (2025-11-17 11:39):
@Devendra Kulkarni any idea?

---

**Devendra Kulkarni** (2025-11-17 11:47):
Yes the default roles get created automatically, do they have the Observability UI Extension enabled?

---

**Daniel Murga** (2025-11-17 11:49):
I'm pretty sure yes...

---

**Bram Schuur** (2025-11-17 11:51):
be advised they also need to 'configure' the extension before the roles appear (e.g. configure the extension with a service token)

---

**Daniel Murga** (2025-11-17 12:06):
https://documentation.suse.com/cloudnative/suse-observability/latest/en/k8s-suse-rancher-prime.html#_installing_ui_extensions

---

**Mark Bakker** (2025-11-17 12:52):
@Rodolfo de Almeida and @Louis Lotter we don't have any special SKU for Observability without CVE's and indeed like David shared we do have something in specific cases but also let the customer pay significant for this.
Feel free to involve me next week @Louis Lotter.
For now I see this as a customer wish which we agree it's a good ask but we don't prioritize it without a specific agreement for this (and I did not yet receive any exception request for something like this).
Obviously we continue to try to keep the CVE's low with our current processes.

---

**Daniel Murga** (2025-11-17 13:15):
thanks @Devendra Kulkarni to point out the versioning issue. We asked customer to upgrade the extension from 2.0.0 to at least 2.3.3

---

**Javier Lagos** (2025-11-17 13:29):
Hey @Alejandro Acevedo Osorio and @Frank van Lankvelt! I'm back with more Open Telemetry issues in the same customer infrastructure and the same case. It looks like that the view of traces within a service inside OpenTelemetry menu is different based on the permissions of the user.

Please see attached screenshots. One is from an Admin user and the other is from a user from a group that only was assigned with observer permissions to his group on the project where application is located. Can you please help understand why this is happening?

Apart from that, I have 2 questions where I need your help.

1 - What  `unmatched span` means? We can see those messages on the traces in the screenshots.
2 - Status is always `unset` unless the request has failed. Is this the normal behavior or the customer needs to modify something on their side? They are expecting to have a sort of green and red light once it is working / Not working but it looks like is only displayed red when it is not working.

---

**Bram Schuur** (2025-11-17 15:58):
@Daniel Murga The *`Filtering snapshot start from host`*  indicates that multiple splunk checks are reporting data to the same synchronization. In this case the system will pick one of the two hosts as the one to use data from. Could you check with them this is not the case?

---

**Bram Schuur** (2025-11-17 16:00):
If so they need to make sure only one agent reports into the instance

---

**IHAC** (2025-11-17 23:18):
@Garrick Tam has a question.

:customer:  LeadVenture

:facts-2: *Problem (symptom):*  
Correlate pods in CrashLoopBackOff state.
```suse-observability-correlate-868858466f-fwfnf                     1/1     Running            5 (7m46s ago)   20m     172.30.255.71    sdf-monitoring-worker-f46t4-ndf4b   &lt;none&gt;           &lt;none&gt;
suse-observability-correlate-868858466f-hjbw9                     0/1     CrashLoopBackOff   5 (15s ago)     20m     172.30.13.28     sdf-monitoring-worker-f46t4-dx247   &lt;none&gt;           &lt;none&gt;
suse-observability-correlate-868858466f-wttgw                     1/1     Running            5 (7m46s ago)   20m     172.30.166.80    sdf-monitoring-worker-f46t4-grrjz   &lt;none&gt;           &lt;none&gt;
s```
The primary reason appears to be loss of connection or responsiveness from the Kafka broker(s) acting as the group coordinator and/or partition leaders.  I suspected possible hw performance but customer believe otherwise and provided the following details regarding the hardware.  There were a few pod OOM initially but I don't think those are related to kafka issues.

SUSE Observability platform cluster is a Rancher downstream cluster build from VMware virtual machines with storage array.  The storage performance is included in the attached PDF.

VM run on the following hardware:
VMware ESXi, 8.0.3, 24859861
3- Dell PowerEdge R640
Dual - Intel(R) Xeon(R) Gold 6242 CPU @ 2.80GHz
768 GB RAM

10GB optical network paths

Backing Storage:
HPE HF60 Hybrid Array

---

**Garrick Tam** (2025-11-17 23:20):
Here's the Obervability log bundle and the storage array performance data.

---

**Garrick Tam** (2025-11-17 23:20):
Observability Team, appreciate your help in determining why the correlate pods are restarting?

---

**Garrick Tam** (2025-11-17 23:34):
Customer also sent over a host performance report.

---

**Bram Schuur** (2025-11-18 09:45):
yeah i saw that, but that resolved itself. correlator keeps restarting though

---

**Alejandro Acevedo Osorio** (2025-11-18 09:49):
Well I guess what comes after those issues is more than a couple of rebalances that will get the `10` correlator pods probably unstable for awhile
```[2025-11-14 20:56:52,544] INFO [GroupCoordinator 1]: Preparing to rebalance group correlationAggregationConsumers in state PreparingRebalance with old generation 1128 (__consumer_offsets-33) (reason: Removing member correlation-0eaa36cb-bf4c-4867-bdd7-eb546920e9ba-14a8e2fc-2f1b-4401-b083-d980d49e81a5 on LeaveGroup; client reason: the consumer is being closed) (kafka.coordinator.group.GroupCoordinator)```

---

**Remco Beckers** (2025-11-18 09:54):
10 correlator pods? I only see 3 in the pod status overview.

---

**Bram Schuur** (2025-11-18 09:54):
this is due to the new ES logs gathering

---

**Remco Beckers** (2025-11-18 09:55):
Yeah, in this version of the script it was probably still always enabled.

---

**Alejandro Acevedo Osorio** (2025-11-18 09:55):
Ooops ... indeed, I went with the amount of folders over there :facepalm:

---

**Remco Beckers** (2025-11-18 09:56):
If Kafka was having issues you'd also expect the receiver (or the syncs for that matter) having some problems

---

**Remco Beckers** (2025-11-18 09:57):
Ok. The receiver-base logs also have kafka producer errors in the logs

---

**Bram Schuur** (2025-11-18 09:58):
good point

---

**Remco Beckers** (2025-11-18 09:58):
But it will reconnect internally yeah

---

**Louis Parkin** (2025-11-18 09:59):
@Guilherme Macedo for context, this is the thread I was telling you about.

---

**Remco Beckers** (2025-11-18 09:59):
This seems to all have started when the Kafka cluster was "redeployed". The Kafka nodes are only up for &lt;30 minutes

---

**Remco Beckers** (2025-11-18 10:00):
Could it be we're back at the case where the JVM is caching old DNS resolution and therefore using the wrong ip for kafka-2? Erhm nope. Then the correlator restart would fix it

---

**Alejandro Acevedo Osorio** (2025-11-18 10:01):
how do we conclude is about `kakfak-2`?

---

**Remco Beckers** (2025-11-18 10:02):
Both receiver and correlate fail to produce to kafka-2 according to their logs

---

**Remco Beckers** (2025-11-18 10:03):
Maybe there's another error with kafka-0 or kafka-1 though

---

**Alejandro Acevedo Osorio** (2025-11-18 10:05):
From the `receiver-base`
```2025-11-14 20:56:22,611 WARN  org.apache.kafka.clients.NetworkClient - [Producer clientId=producer-3305] Error while fetching metadata with correlation id 8 : {sts_topo_disk_agents=INVALID_REPLICATION_FACTOR}
2025-11-14 20:56:48,531 ERROR c.s.kafka.reconnectable.AsyncReconnectableProducerImpl - Failed to send messages to Kafka
org.apache.kafka.common.errors.TimeoutException: Disconnected from node 2 due to timeout```
```{sts_topo_disk_agents=INVALID_REPLICATION_FACTOR}```

---

**Daniel Murga** (2025-11-18 10:09):
Morning... answer from customer:
"Hi Daniel,

The PA splunk agent was restarted during the second support call with Suse last Wednesday (~15:03 CET) (to increase the max retries on searches I hear from colleagues). And the Prod splunk agent was restarted some 20 minutes later.

The process of restarting a pod is to kill the existing one after which the Kubernetes system starts the new one. So having two at the same time is difficult. I don't see concurrent Splunk-agent pods during that timeframe either looking back.

My conclusion so far is that restarting an agent pod can lead to the sync pod thinking there are two concurrent versions of that agent.
And that would be bad as restarting those pods happens frequently (aks patches, node patches, support cases where Suse asks us to do so).

Please advise us on how to prevent this from happening."

---

**Remco Beckers** (2025-11-18 10:09):
Mmm, what does that even mean

---

**Remco Beckers** (2025-11-18 10:09):
Cannot replicate or invalid configuration for the replication factor

---

**Remco Beckers** (2025-11-18 10:10):
•   The replication factor is greater than the number of available brokers in the cluster.
•   The replication factor is set to zero or a negative number.

---

**Bram Schuur** (2025-11-18 10:17):
gotcha

the thing that is triggering is a protection to avoid data from multiple hosts. given that snapshots are far inbetween and not stable at rabobank due to to occasional bad requests, i'd suggest disabling that validation as follows (i already did this in the past with mitesh, seems that was not brought to these other environments):

Add to the sync pod extraEnv:
`CONFIG_FORCE_stackstate_sync_activeHostBufferSize=0`

This should resolve the issue

---

**Alejandro Acevedo Osorio** (2025-11-18 10:19):
On `kafka-1` logs I see it suffering from the same connectivity issues with Node 2
```[2025-11-14 21:04:24,502] INFO [BrokerToControllerChannelManager id=1 name=forwarding] Node 2 disconnected. (org.apache.kafka.clients.NetworkClient)```

---

**Remco Beckers** (2025-11-18 10:26):
Didn't the errors stop appearing?

---

**Bram Schuur** (2025-11-18 10:26):
yeah, at 20:56 there was a redeploy it seemed, some confusion and it seemed to go to normal, but after that we still get timeouts

---

**Remco Beckers** (2025-11-18 10:27):
Otherwise this definitely seems to imply split-brain yeah. It would explain why Kafka-2 claims incorrect wrong # replicas.

---

**Bram Schuur** (2025-11-18 10:27):
not sure whether timeouts are pointing to splitbrain

---

**Bram Schuur** (2025-11-18 10:27):
i would expect some more consuion in the logs

---

**Remco Beckers** (2025-11-18 10:27):
Kafka-2 being its own cluster it cannot replicate, which may cause a timeout

---

**Bram Schuur** (2025-11-18 10:27):
that is true

---

**Remco Beckers** (2025-11-18 10:27):
(not 100% sure how kafka deals with that)

---

**Bram Schuur** (2025-11-18 10:29):
the `INVALID_REPLICATION_FACTOR` also seem transient though

---

**Remco Beckers** (2025-11-18 10:46):
Node 1 and 2 don't have such log lines

---

**Remco Beckers** (2025-11-18 10:47):
But at the end of the logs they seem to reconnect. So I wonder if correlate is still stuck in restarts

---

**Guilherme Macedo** (2025-11-18 12:46):
Thanks! Let me read the thread and get the context.

---

**Guilherme Macedo** (2025-11-18 13:11):
Providing my comments:
1. Aiming to have 0 criticals and a couple of highs per image is totally feasible, but it takes a lot of time and work to get to that state (look what RKE2 team did).
    a. Reducing the amount of mediums is also possible, but normally that goes into the amount of a dozen or so.
    b. Generally this will take a couple of months of work before we can see the results.
2. We have to work together with the Observability team to see which practices around dependency bumping and automated pipelines are in place and to enable what is missing.
3. About RKE2 and Dell, I know that Dell pays for a specific contract with RKE2 in order to have timed updates, backporting and a very low amount of CVEs.
4. About VEX - https://support.scc.suse.com/s/kb/How-to-use-SUSE-Rancher-s-VEX-Reports?language=en_US, we only publish the status of false-positive CVEs, we don't publish when a CVE will be fixed.
    a. We can scan Observability for automated VEXing, but this works only for Go code right now, because other languages lack tooling for automatically flagging false-positives.
    b. Nevertheless, we can manually VEX CVEs, but it takes time to confirm manually the false-positives. We do this for our other products.
5. About when a CVE is/will be fixed, SUSE doesn't provide such SLA or expectations.
6. I'm working to integrate the Observability scans into scans.rancher.com (http://scans.rancher.com) (aiming to have it ready between today and tomorrow).
7. Once the scans are integrated, customers must follow this process - https://support.scc.suse.com/s/kb/How-to-Inquire-About-CVEs-in-SUSE-Rancher-Prime-Product?language=en_US - to inquire about CVEs, as opposed to sending their own ran results, which leads to a lot of mistakes, misunderstandings and back and forth comparing their results with ours.

---

**Guilherme Macedo** (2025-11-18 13:15):
8. Regarding Prisma, from my personal and professional experience, this is one of the worst CVE scanners and that usually generates a lot of false-positives. There are dozens of threads about it in <#C02CP7ZLBDM|>.
     a. I was never able to discuss with a customer about it, but I would be happy to join a call with them if they can connect us with Prisma to understand why they tend to generate more false-positives.

---

**Guilherme Macedo** (2025-11-18 13:16):
Having said that, I (from RST) am happy to get to know more about how Observability is built on GitLab and for us to start automating dependency bumping.

---

**Garrick Tam** (2025-11-19 00:58):
Thank you for looking at this.  Any ideas and recommendation for the customer to try or need to collect additional logs/data?  Please let me know.

---

**IHAC** (2025-11-19 08:59):
@Amol Kharche has a question.

:customer:  First Abu Dhabi Bank (FAB)

:facts-2: *Problem (symptom):*  
Hello Team,

Customer has rancher clusters deployed in on-premise data center. Currently there is one rancher prime manager and 5 downstream clusters in each environment(prod, non-prod). They are setting up the SUSE Observability stack rancher cluster.

1) Since their is a financial based organization, they have application with sensitive logs and they want to restrict the agent to collect only the limited logs like *errors* or *warnings* from the application log instead of capturing complete logs.

2) Also, they need documentation to see the integration of SUSE observability with ServiceNow for automatic incident creation.

Can you please help here.

---

**Amol Kharche** (2025-11-19 09:00):
Here is my finding.
1. For now we dont have limited logs collection facility with agent. 
2. Customer need to configure webhook server that should send data to ServiceNow and create incident.
Please correct me If I'm wrong.

---

**Bram Schuur** (2025-11-19 09:09):
You are exactly right @Amol Kharche

---

**Amol Kharche** (2025-11-19 09:34):
Cool, Thanks for the confirmation.

---

**Daniel Murga** (2025-11-19 12:00):
Sorry @Bram Schuur I forgot to send it to customer... doing it right now

---

**Daniel Murga** (2025-11-19 13:35):
answer from customer:
"Hi Daniel,

On a previous support call with Bram, we have already set this up in a separate values file:

# This code block will disable the Host Switch Protection (HSP)-on the sync pod. We have a single integration for Splunk and Dynatrace so this can be disabled to prevent sync delay in case of pod restarting on another host.

stackstate:
 components:
  sync:
   extraEnv:
    open:
     CONFIG_FORCE_stackstate_sync_activeHostBufferSize: "0"


This is applied to all environments.
"

---

**Bram Schuur** (2025-11-19 15:35):
gotcha, i am now validating whether there is something wrong in the handling of this setting, otherwise we should get into a call i think to really validate whether the setting propagates

---

**Bram Schuur** (2025-11-19 15:50):
Hmm i think i identified the issue. Could you ask them to configure `CONFIG_FORCE_stackstate_sync_activeHostBufferSize: "1"` ? That should side-step the issue for now and fix their setup. I will fix it proper at our end

---

**Daniel Murga** (2025-11-19 15:58):
ok, sending to customer

---

**Bram Schuur** (2025-11-19 16:17):
hmm, i found a flaw in my reproducing case. I'll keep digging, lets see what result the proposed change gives but it might actually not work for them

---

**Bram Schuur** (2025-11-19 16:18):
could you setup a call with them tomorrow morning? i think i'd for sure want to test this a bit more even if the proposed change fixes it

---

**Bram Schuur** (2025-11-19 16:31):
Reading the logs again i am actually pretty convinced data is coming from multiple sources, i think a call is definitely the way to go

---

**Daniel Murga** (2025-11-19 16:32):
Nice, scheduling!

---

**Daniel Murga** (2025-11-19 16:34):
01604429
Thursday, November 20 · 11:00am – 12:00pm
Time zone: Europe/Madrid
Google Meet joining info
Video call link: https://meet.google.com/srf-tndz-her
Or dial: ‪(ES) +34 822 11 34 29‬ PIN: ‪170 337 843‬#
More phone numbers: https://tel.meet/srf-tndz-her?pin=8368780037476

---

**Daniel Murga** (2025-11-19 16:35):
Let's see if works for them

---

**Anton Ovechkin** (2025-11-19 16:37):
hello @Giovanni Lo Vecchio, I am back reporting the result of our investigation

## Bug Closure Summary: API Contract Discrepancy

---

### Root Cause Analysis

The error occurred in the **`HighlightsAboutSection`** component. Specifically, the **`About field` extractor** failed when attempting to access fields within a **`component.properties`** object.

The fundamental issue was a **discrepancy** between the **generated API contract** and the **backend implementation**.

---

### Resolution and Timeline

* **Fix:** The API contract/backend discrepancy was resolved by the changes implemented in **Merge Request 9278** (details: `https://gitlab.com/stackvista/stackstate/-/merge_requests/9278/diffs#diff-content-76dda34d6b58f6d35d5e88be26a73d334f1522de`), which was tracked under ticket **STAC-22871** (`https://stackstate.atlassian.net/browse/STAC-22871`).
* **Merge Date:** The fix was **merged on October 10th, 2025**.
* **Customer Version:** The customer was using an application version that originated from **October 9th, 2025**.

**Conclusion:** The customer’s application version **predates the fix**, explaining the presence of the error in their environment. The issue is considered resolved in all subsequent releases/builds.

---

**Bram Schuur** (2025-11-19 16:43):
@Anton Ovechkin could you be more specific here? The customer was on 2.6.1. Does this mean the issue is not inthere but is on 2.6.2?

---

**Giovanni Lo Vecchio** (2025-11-19 17:28):
Thank you, @Anton Ovechkin!

So I have to ask to update?

---

**Giovanni Lo Vecchio** (2025-11-19 18:17):
Does this version contain the bug-fix?
https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.2.html

---

**Garrick Tam** (2025-11-19 20:03):
Thank you for your analysis and identify supporting logs entries.  I relayed to the customer and awaiting your response.

---

**Daniel Murga** (2025-11-20 08:01):
Morning! 10:30 suits better for rabobank

---

**Bram Schuur** (2025-11-20 08:02):
:thumbs-up:

---

**Anton Ovechkin** (2025-11-20 08:47):
judging by the .har file I can tell the customer indeed was using `platformVersion` 2.6.1, that version has the issue
I cannot find the tags for platform version in project git, I need assistance to map the platform version to a commit in the project so then I can tell if the fix is included in 2.6.2

---

**Remco Beckers** (2025-11-20 08:51):
The issue was indeed in version 2.6.1 and got fixed in version 2.6.2 due to a small technical improvement we made. At the time we didn't realize it was also causing a bug.

---

**Javier Lagos** (2025-11-20 09:09):
Is anyone available to take a look at my latest message on the thread :upvote:?? Thanks!

---

**Alejandro Acevedo Osorio** (2025-11-20 09:14):
Hi @Javier Lagos I'm sorry for the late response.
The traces look different because indeed they depend on the permissions of the user, if the trace is going through some services where the user does not have visibility then they would get occluded.
For the other 2 questions I'll ask some help from @Remco Beckers as @Frank van Lankvelt is not available today.

---

**Giovanni Lo Vecchio** (2025-11-20 09:17):
Hey @Anton Ovechkin, @Remco Beckers,
Thanks a lot for the reply and the help! I will notify the client of what has been done and suggest that they update the platform asap.

---

**Javier Lagos** (2025-11-20 09:18):
No worries @Alejandro Acevedo Osorio!! I really appreciate your amazing help here.

Is there a way to debug which kind of permissions are missing on the OTEL view for the non admin user? They will ask that 100%

---

**Remco Beckers** (2025-11-20 09:18):
Unmatched span: spans that are not matched by the current selection. In this case the traces are viewed for a specific component. So any span that is not in this component will be considered "unmatched".

The status is very often `Unset` indeed. That's entirely controlled by the open telemetry SDK that did the instrumentation. There are only 3 statuses that are supported by OTel: `unset`, `ok`, `error`.

---

**Remco Beckers** (2025-11-20 09:20):
As far as I can tell the `ok` status is only set for spans that have an explicit OK result. ~For example an HTTP Get request span that runs a `200` status.~ That example was not fully correct. Not all instrumentations do that (the HTTP instrumentations in our demo setup don't do it, but some of the instrumented RPC client libraries do set the status to `ok`).

---

**Alejandro Acevedo Osorio** (2025-11-20 09:22):
https://suse.slack.com/archives/C07CF9770R3/p1763626681630679?thread_ts=1762773954.262089&amp;cid=C07CF9770R3 well the permission would be `get-traces` but the tricky bit would be to know all the scopes that might be missing, e.g. the user has a traces scope for ns1 but the trace being inspected goes to ns2 and ns3 as well ... then the parts of the trace that belong to ns2 and ns3 are occluded as the user does not have rights for those scopes ... and I guess it's debatable if you would give the user access to those scopes (imagine some belong to some other teams or owners). My best option here would be to inspect it from the admin point of view to determine which other scopes might be this user entitled to. Something like the `shared-infra` namespace (where kafka, dbs or other services run)

---

**Javier Lagos** (2025-11-20 09:28):
Hey @Remco Beckers Thanks for your answer.  I was about to write you as I have tested to auto-instrument an application which was doing just single HTTP requests to a valid endpoint and on my lab the traces were still set as `unset` but I have seen you edited the message so thanks for that.

What `As far as I can tell the ok status is only set for spans that have an explicit OK result` means? Does it means that it only displays OK on the console when the traces contains OK results? 200 code is not enough for that, right? on my lab I can't see OK status even though my auto instrumented java application is receiving 200 HTTP codes all the time

---

**Remco Beckers** (2025-11-20 09:30):
The instrumentation (or when adding manual spans in an application the app developer) needs to decide to set the status to `ok`. OTel leaves a lot of room for interpretation there: https://opentelemetry.io/docs/concepts/signals/traces/#span-status. So in the end it simply depends on what the developers of the SDK that does the instrumentation decided on

---

**Remco Beckers** (2025-11-20 09:30):
For errors I think the situation is way more clear, but for `ok` it seems many simply don't set it

---

**Javier Lagos** (2025-11-20 09:31):
Thanks for that. Really appreciate it guys

---

**Bram Schuur** (2025-11-20 11:57):
As a recap @Daniel Murga
• We pinpointed the issue, (desription here: https://stackstate.atlassian.net/browse/STAC-23878). 
• We advised a temporary fix to have the sync and splunk pods co-located, so there are no inbetween movements of the splunk pod to different hosts which could cause it to trigger.

---

**Amol Kharche** (2025-11-24 07:53):
@Bram Schuur Customer would like to know if this can be take as a feature request for limited logs collection.
cc: @Wissam Eid

---

**Wissam Eid** (2025-11-24 08:24):
Could you please let us know if this is an option: https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/logs/k8sTs-log-shipping.html

---

**Wissam Eid** (2025-11-24 08:24):
I know it does not filter but could it be selectively done on sensitive pods ! and what would be the impact on observability dashboards ?

---

**Wissam Eid** (2025-11-24 08:25):
@Mennatallah Shaaban adding our project consultant

---

**Bram Schuur** (2025-11-24 08:43):
@Amol Kharche you can file a feature request through https://jira.suse.com/. Most likely we will tackle this in an upcoming 'generalized logging epic, but that work is at least 6 months out (could be more). But it really helps us having thos feature requests in jira there to prioritize the work.

---

**Bram Schuur** (2025-11-24 08:44):
@Wissam Eid https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/logs/k8sTs-log-shipping.html only allows log shipping on or off, not more detailed configuration like pod filtering at the moment.

---

**Amol Kharche** (2025-11-24 09:02):
https://jira.suse.com/browse/SURE-10994

---

**Giovanni Lo Vecchio** (2025-11-24 11:02):
FYI:

We’ve updated our PA environment this morning and the problem is resolved. All components that previously failed to render do so now.

---

**Giovanni Lo Vecchio** (2025-11-24 11:02):
I’m closing the Jira case too

---

**Rajesh Kumar** (2025-11-24 14:56):
Hi Team,

Customer Jeti Servcies AB - Youmoni (https://suse.lightning.force.com/lightning/r/Account/0015q00000JmXg1AAF/view) reached out saying several pods are restarting and few are because of OOM. They are using 10-nonha profile for testing and doesn't have any other clusters. The agent and server is deployed on the same single node cluster with 128GB memory. I looked at the yaml and can see Kafka JMX Exporter  having 1172 restarts due to OOM. I see these logs in its logs


`VM settings:`
   `Max. Heap Size (Estimated): 29.97G`  
   `Using VM: OpenJDK 64-Bit Server VM`

Not sure but is JVM seeing 128GB node memory and calculating ~30GB heap? But the container has 300Mi container limit, and may be that's why he kernel OOM killer is terminating it immediately? Can someone check and help?

---

**Bram Schuur** (2025-11-24 17:12):
This is a known issue and will be fixed in the upcoming release, which should be released somehwere this week: https://stackstate.atlassian.net/browse/STAC-23856

---

**IHAC** (2025-11-25 11:24):
@Giovanni Lo Vecchio has a question.

:customer:  Rabobank Nederland

:facts-2: *Problem (symptom):*  
Hi Team!
I’m contacting you to ask your opinion on case 01606451.
In short, the customer tells us that SUSE Observability (specifically, the agent) performs searches on Splunk, and it works properly, but they would like to prevent the DISABLED searches from being exported.

I had the configuration file shared with me, but I don’t see any sections where a similar customization can be applied.

Example:
```############ file pa_init_config.txt
# Currently it is not possible to specify multiple instances with the same url.
# It is possible to specify multiple saved_searches on a single instance.
instances:
  - url: "xyz"
    collection_interval: 900
 
    verify_ssl_certificate: false
 
    ## Integration supports either basic authentication or token based authentication.
    ## Token based authentication is preferred before basic authentication.
    authentication:
 
      token_auth_ms: {}
       
    # Determine whether to produce topology in snapshots, defaults to true
    # snapshot: true
 
    # saved_searches_parallel: 5
 
 
    # on_saved_search_error: "abort"   -&gt; abort the splunk check and do not complete the snapshot until next scheduled run
    # on_saved_search_error: "ignore" -&gt; ignore the error and continue (discarding the data) until next scheduled run
    on_saved_search_error: "abort"
 
    component_saved_searches:
        # name: "components"
        # Wilcard match to find component queries, can be used instead of name
      - match: "stackstate.topo.*"
        # app: "app_aemon"
        # request_timeout_seconds: 10
        # search_max_retry_count: 5
        # search_seconds_between_retries: 1
        # batch_size: 1000
        # parameters:
        #   force_dispatch: true
        #   dispatch.now: true
    relation_saved_searches:
      - match: "stackstate.rel.*"
        # app: "app_aemon"
      #  request_timeout_seconds: 10
      #  search_max_retry_count: 5
      #  search_seconds_between_retries: 1
      #  parameters:
      #    force_dispatch: true
      #    dispatch.now: true
 
    # tags:
    #      - optional_tag1
    #      - optional_tag2```
Is there a strategy we can suggest? Is there a new feature planned, or does it just work as it is?

TIA!

---

**Rajesh Kumar** (2025-11-25 11:24):
@Bram Schuur We tried that but it is still crashing. There shouldn't be any sizing issue because there aren't any other clusters. We increased the memory limits and requests to 1G. but didn't work. Here is the reply from the customer:

It wasn't enough. I had to increase it to 2Gb.

Also, I got other OOM:

Memory cgroup out of memory: Killed process 3681198 (java) total-vm:9103860kB, anon-rss:1016680kB, file-rss:27516kB, shmem-rss:0kB, UID:65534 pgtables:2812kB oom_score_adj:993
Tasks in /kubepods.slice/kubepods-burstable.slice/kubepods-burstable-pod0d9da369_5479_41dd_8370_e9ccec09bd7d.slice/cri-containerd-03a58f56374826e70871b52f72c0de66dbc99352dd5be4a56c53765f0d0ade85.scope are going to be killed due to memory.oom.group set
Memory cgroup out of memory: Killed process 3681186 (docker-init) total-vm:1068kB, anon-rss:0kB, file-rss:532kB, shmem-rss:0kB, UID:65534 pgtables:40kB oom_score_adj:993
Memory cgroup out of memory: Killed process 3681198 (java) total-vm:9103860kB, anon-rss:1016680kB, file-rss:27516kB, shmem-rss:0kB, UID:65534 pgtables:2812kB oom_score_adj:993

It seemed to be suse-observability-hbase-tephra-mono-0, and I tried to double the memory limit (from 512Mb till 1Gb), but it didn't help. Will it need a similar MaxRAMPercentage?

I see also that suse-observability-elasticsearch-master crashed...

Attaching "kubectl get pods --namespace suse-observability" together with a new support bundle.

---

**Chris Riley** (2025-11-25 12:31):
@Sander de Jonge It was good to meet you at SKO last week ... just returning to this topic at Nato.

Not sure if you were able to speak with any of the senior folks (Jeff etc)? I see @Mark Bakker explains above that we would essentially need some business justification here. How do you want us to proceed with the support case?

I see that Observability is now listed on https://scans.rancher.com/ - great work by @Louis Lotter and team. That is a positive that we can share with the customer, but that's all we have for now ... at least in my understanding.

---

**Rodolfo de Almeida** (2025-11-25 12:33):
@Chris Riley
Thanks for the heads up about Observability being available at scans.rancher.
I am going to share that with the customer

---

**Giovanni Lo Vecchio** (2025-11-25 16:05):
Jira case: https://jira.suse.com/browse/SURE-11000

---

**Remco Beckers** (2025-11-25 16:50):
@Louis Parkin, @Bram Schuur is this something you know? I'm not sure who else can help with this given it's the Splunk integration

---

**Bram Schuur** (2025-11-25 16:51):
Currently we do not support this. I would have to investigate how we could do that.

---

**IHAC** (2025-11-25 17:07):
@Bruno Bernardi has a question.

:customer:  Nationwide Mutual Insurance Company

:facts-2: *Problem (symptom):*  
Hi Team,

We're looking to expand the resource limits for the RBAC Agent PODs. When we looked at the helm chart for suse-observability-agent using version 1.2.3, we did not see any options to expand this. The customer's cluster side limit ranges are getting applied to that namespace, and we need a way to customize the POD resources, as it is getting OOM killed.

Even after applying the configurations below, we do not see it being recognized, and the configurations are not applied. When I look at the helm template in charts/kubernetes-rbac-agent/templates/deployment.yaml for the 1.2.3 suse-observability-agent helm chart, I'm not seeing anything to apply resources for this container, even though it is mentioned in the helm chart.

```kubernetes-rbac-agent:
   containers:
    rbacAgent:
     resources:
      requests:
       memory: "25Mi"
      limits:
       memory: "40Mi"```
*Question:* Are these limit definitions supported for RBAC Agent? Looking at the helm chart for version 1.2.3, it seems that there are some missing snippets that could make this happen. Could you please check?

Thanks in advance,

---

**Bruno Bernardi** (2025-11-25 17:08):
I tested a fix with the customer, and it seems to have helped resolve the issue. Here is what we tested:

```diff -u -r suse-observability-agent-orig/charts/kubernetes-rbac-agent/templates/deployment.yaml suse-observability-agent/charts/kubernetes-rbac-agent/templates/deployment.yaml

--- suse-observability-agent-orig/charts/kubernetes-rbac-agent/templates/deployment.yaml    2025-11-20 13:42:20.132604948 -0500
+++ suse-observability-agent/charts/kubernetes-rbac-agent/templates/deployment.yaml   2025-11-20 13:46:25.878893590 -0500
@@ -103,6 +103,10 @@
       httpGet:
        path: /healthz
        port: 8080
+     {{- with .Values.containers.rbacAgent.resources }}
+     resources:
+      {{- toYaml . | nindent 12 }}
+     {{- end }}
      volumeMounts:
       {{- include "kubernetes-rbac-agent.customCertificates.volumeMount" . | nindent 12 }}```
Granted, the fix needs to go into the kubernetes-rbac-agent subchart, which I think is hosted at https://github.com/StackVista/kubernetes-rbac-agent, but I can't see it to submit a patch.

---

**Giovanni Lo Vecchio** (2025-11-25 17:59):
I thought about renaming the enabled ones in Splunk, so as to have an easy-to-manage filter in SUSE Obs., but I don’t think the customer would be happy with all this effort...

---

**Rodolfo de Almeida** (2025-11-25 20:42):
Hello @Frank van Lankvelt
Do we have any updates regarding this case? I would like to check whether there is any progress we can share with the customer, or if there is an estimated time of resolution for this issue.

---

**Frank van Lankvelt** (2025-11-25 20:53):
hi @Rodolfo de Almeida - yeah this issue is included in the upcoming release, which should be announced in the next few days

---

**Rajesh Kumar** (2025-11-26 07:24):
Jira https://jira.suse.com/browse/SURE-11003

---

**Alejandro Acevedo Osorio** (2025-11-26 09:11):
@Alessio Biancalana perhaps you can help @Bruno Bernardi

---

**Alessio Biancalana** (2025-11-26 09:17):
@Bruno Bernardi ciao! Evidently the rbac agent's chart is missing this snippet, it's a whoopsie on our side I guess. Can I just ask out of curiosity how many roles and cluster roles does the customer have? If you get OOMKilled it looks like a very huge cluster, right?

---

**Bram Schuur** (2025-11-26 09:25):
@Giovanni Lo Vecchio that would indeed be an idea if that is ok for them, if not we'll have to take this as a feature request, the docs are non-conlusive about whether the api produces the 'disabled' field, but i am pretty sure we can do seomthing here

---

**Bram Schuur** (2025-11-26 09:30):
Just increasing the memory will not work for the jmx pod, the proper fix will be in 2.6.3 which is about to be released. I am taking a look at the elasticsearch memory

---

**Bram Schuur** (2025-11-26 09:33):
The MaxRAMPercentage is actually the problem for jmx (the container gets the host memory instead of pod limit and makes Xmx out of that). All other pods have Xmx set directly, so those should be ok, it is a bit puzzling why they are going OOM

---

**Rajesh Kumar** (2025-11-26 09:34):
Even for tphera I saw similar logs..

---

**Bram Schuur** (2025-11-26 09:35):
gotcha, let me check that

---

**Rajesh Kumar** (2025-11-26 09:35):
os.memory.max=83584MB

---

**Bram Schuur** (2025-11-26 09:36):
Gotcha, i think for those services we indeed also do not set -Xmx

---

**Bram Schuur** (2025-11-26 09:36):
And causing it to take a percentage of the host memory somehow

---

**Bram Schuur** (2025-11-26 09:40):
I'll have to take this in as a bugfix, but it can take some time to release. In the meanwhile you could:
• Investigate why the pods are seeing the host memory as their memory rather than the configured limit (this might have to do with the k8s version, container runtime, cgroup version) and fix it that way
• Deploy on smaller nodes to mitigate the issue

---

**Bram Schuur** (2025-11-26 09:41):
It seems java gets its max memory for a pod from `/sys/fs/cgroup/memory/memory.limit_in_bytes` on the filesystem, could you see what that reads for tephra?

---

**Rajesh Kumar** (2025-11-26 09:41):
I have tried deploying it on my cluster with 48GB memory, but it didn't crash. I am also curious why its crashing in their setup without much load. Will run few more test and try to see.

---

**Rajesh Kumar** (2025-11-26 09:42):
I will deploy again and test. It takes sufficient resources so cannot keep it running for long.

---

**Bram Schuur** (2025-11-26 09:42):
@Rajesh Kumar the main reason is: pods are observing the node mmeory rather than the pod memory as their available memory, making java consume way too much

---

**Rajesh Kumar** (2025-11-26 09:43):
yes, that's my observation as well with the help of GPT.!

---

**Giovanni Lo Vecchio** (2025-11-26 09:49):
Great, thank you @Bram Schuur!
I’ll get back to you as soon as possible

---

**Bram Schuur** (2025-11-26 10:05):
I made a ticket to keep track of this: https://jira.suse.com/browse/SURE-11004 @Bruno Bernardi can you amend if i missed something there.

---

**Bram Schuur** (2025-11-26 10:41):
@Rajesh Kumar we think it might be this bug in the JVM https://bugs.openjdk.org/browse/JDK-8370572. Could you work with the customer to see whether cgroups v1 or v2 is used? https://www.chkk.io/blog/cgroup-v1-to-v2-migration-in-kubernetes#:~:text=Verify%20the%20cgroup%20version%3A%20Use,while%20tmpfs%20indicates%20cgroup%20v1.

---

**Rajesh Kumar** (2025-11-26 10:41):
Yes, I will get the info

---

**Rajesh Kumar** (2025-11-26 10:46):
From the logs it seems it is v2
/pods/suse-observability-clickhouse-shard0-0/clickhouse.log:2025.11.19 11:02:38.760148 [ 50 ] {} &lt;Information&gt; CgroupsReader: Will create cgroup reader from '/sys/fs/cgroup/' (cgroups version: v2)

---

**Rajesh Kumar** (2025-11-26 10:48):
Confirmed cgroup2fs

---

**Rajesh Kumar** (2025-11-26 11:01):
The OS is SUSE Linux Enterprise Server 16.0 (kernel-default-6.12.0-160000.5.1.x86_64)

---

**Alejandro Acevedo Osorio** (2025-11-26 11:42):
@Ettore Ciarcia here's is where we get support tickets

---

**Bram Schuur** (2025-11-26 11:49):
thanks! that seems to not match https://bugs.openjdk.org/browse/JDK-8370572, continuiing the search..

---

**Bram Schuur** (2025-11-26 11:50):
it does match https://bugs.openjdk.org/browse/JDK-8322420, tephra has `Client environment:java.version=21.0.8`

---

**Bram Schuur** (2025-11-26 12:01):
For stackgraph and tephra the to be released version 2.6.3 of SUSE obs will include java 21.0.9, so there recommendation will be to upgrade. I am still a bit puzzled about elasticsearch and will continue that investigation, because we actually do set Xmx there, so that problem seems to be slightly different

---

**Rajesh Kumar** (2025-11-26 12:09):
thank you!

---

**Rajesh Kumar** (2025-11-26 12:24):
In my cluster this is properly seen

kubectl -n suse-observability logs -f suse-observability-kafka-0 -c jmx-exporter
VM settings:
    Max. Heap Size: 256.00M
    Using VM: OpenJDK 64-Bit Server VM

I am using k3s on sle micro

---

**Rajesh Kumar** (2025-11-26 12:25):
what is causing the issue in the customer's env. :dizzy_face:

---

**Rajesh Kumar** (2025-11-26 14:15):
Couldn't see any issues with the env:

sles16, default k3s installation, default observability istallation.

---

**Ettore Ciarcia** (2025-11-26 14:46):
Hi @Alejandro Acevedo Osorio! Thanks for your help
Customer logs:

---

**Ettore Ciarcia** (2025-11-26 14:50):
If you want, we can take a look together. I can learn something new today :smile:

---

**Ettore Ciarcia** (2025-11-26 15:04):
Do we have some utility in Hbase to fix that?

---

**Ettore Ciarcia** (2025-11-26 15:05):
Sorry, I don't know Hbase

---

**Alejandro Acevedo Osorio** (2025-11-26 15:12):
@Bram Schuur@Remco Beckers we have an interesting case here of Hbase regions stuck in transition. The recent addition of the `hbase` report if really helpful ...

---

**Alejandro Acevedo Osorio** (2025-11-26 15:14):
@Ettore Ciarcia if you see the file `hbase.log` under `./reports`  it has great input about the issue

---

**Ettore Ciarcia** (2025-11-26 15:19):
Are you referring to
```ERROR: Found unknown server, some of the regions held by this server may not get assigned. Use HBCK2 scheduleRecoveries```
?

---

**Ettore Ciarcia** (2025-11-26 15:20):
Ok, got it

---

**Ettore Ciarcia** (2025-11-26 15:20):
How can we recover from that?

---

**Ettore Ciarcia** (2025-11-26 15:21):
From the log I can see

"Use HBCK2 scheduleRecoveries"

---

**Alejandro Acevedo Osorio** (2025-11-26 15:24):
indeed, I need to check if we have that utility available though

---

**Ettore Ciarcia** (2025-11-26 15:24):
The customer already tried this
"I also tried to use hbase hbck2 in the hbase-master, but I can't find where this .jar is located in the container."

---

**Ettore Ciarcia** (2025-11-26 15:25):
My installation profile for suse obs is not HA so I don't have Hbase pod to test it

---

**Alejandro Acevedo Osorio** (2025-11-26 15:36):
Seems it's not on the image

---

**Ettore Ciarcia** (2025-11-26 15:37):
Can we interact with it from another container?

---

**Bruno Bernardi** (2025-11-26 15:57):
Ciao @Alessio Biancalana!

Yes, I also thought that was strange and initially asked the customer to provide more details and send us a packet of logs so we could evaluate the behavior. However, the customer did not seem very willing to clarify this or even send these logs.

He seemed more interested in having the CPU and memory consumption limits defined in his Helm chart. However, if it helps, please let me know so that I can request this data and additional information once again.

Thanks!

---

**Alessio Biancalana** (2025-11-26 16:08):
&gt; the customer did not seem very willing to clarify this
feel free to share with the customer that in order to get any sort of help one usually, in life, has to provide a satisfactory amount of information to the person that is trying to help -_-

anyway, if they are just interested in resource limits, we are going to implement them as soon as possible inside the RBAC agent helm chart :+1: :green_heart:

---

**Bruno Bernardi** (2025-11-26 16:15):
Exactly, thank you for clarifying. I will send him feedback on this as I believe it may help avoid potential troubles in the future. I will keep you updated and will monitor the Jira ticket to see how the progress of resource limits goes.

---

**Alejandro Acevedo Osorio** (2025-11-26 16:27):
Ok we found a way to run it but has a lot of manual steps of course and to be honest it's hard to tell the customer that it will repair the environment. But if they want to try it I can share the steps here

---

**Ettore Ciarcia** (2025-11-26 16:28):
We can try

---

**Alejandro Acevedo Osorio** (2025-11-26 16:28):
BTW I'll create a ticket in our backlog to bring the `hbck2` tooling into our docker image

---

**Alejandro Acevedo Osorio** (2025-11-26 16:32):
Ok here are the steps:
1. get into a shell in any of the `hbase-master` or `hbase-rs`
2. Download the tooling `curl https://dlcdn.apache.org/hbase/hbase-operator-tools-1.2.0/hbase-operator-tools-1.2.0-bin.tar.gz -o /tmp/hbase-operator-tools-1.2.0-bin.tar.gz`
    a. `cd /tmp && untar hbase-operator-tools-1.2.0-bin.tar.gz`
3. `/tmp/hbase-operator-tools-1.2.0/hbase-hbck2` is where the jar that we need is located
4. on `tmp` do a `touch log4j2.properties`
5. try out  the command `HBASE_OPTS=-Dlog4j.configurationFile=/tmp/log4j2.properties hbase --config /etc/hbase hbck -j /tmp/hbase-operator-tools-1.2.0/hbase-hbck2/hbase-hbck2-1.2.0.jar`

---

**Alessio Biancalana** (2025-11-26 16:37):
(I home my humor was clear in the first sentence :smile:)

---

**Alejandro Acevedo Osorio** (2025-11-26 16:37):
and eventually run it with the arguments suggested in the output we review previously ... e.g. `scheduleRecoveries suse-observability-hbase-hbase-rs-0.suse-observability-hbase-hbase-rs.suse-observability.svc.cluster.local,16020,1763493256964`
```HBASE_OPTS=-Dlog4j.configurationFile=/tmp/log4j2.properties hbase --config /etc/hbase hbck -j /tmp/hbase-operator-tools-1.2.0/hbase-hbck2/hbase-hbck2-1.2.0.jar scheduleRecoveries suse-observability-hbase-hbase-rs-0.suse-observability-hbase-hbase-rs.suse-observability.svc.cluster.local,16020,1763493256964```

---

**Ettore Ciarcia** (2025-11-26 16:38):
Perfect, I'll share that with our customer

---

**Alejandro Acevedo Osorio** (2025-11-26 16:38):
I can't really test it more as I don't have a broken example myself.

---

**Ettore Ciarcia** (2025-11-26 16:39):
I'll keep you posted

---

**Alejandro Acevedo Osorio** (2025-11-26 16:39):
And I guess the very last step (if everything goes Ok) is to get another report `hbase hbck -details`

---

**Ettore Ciarcia** (2025-11-26 16:39):
Thanks a lot

---

**Alejandro Acevedo Osorio** (2025-11-26 16:40):
Hope it works :crossed_fingers:

---

**Alejandro Acevedo Osorio** (2025-11-26 16:43):
Here the ticket to bring the `hbck2` to our docker image https://stackstate.atlassian.net/browse/STAC-23999 ... cc @Bram Schuur

---

**Bruno Bernardi** (2025-11-26 16:50):
Yes, very clear, Alessio.

---

**Bram Schuur** (2025-11-26 16:51):
For elasticsearch i have the hunch that due to the receiver restarting all the time, it might be taking a bit took much data when the system comes through. For now we could bump `elasticsearch.resources.limit.memory` to something like "4Gi" to prove that it is only just exceeding the memory envelope in this degenerate case

---

**Bram Schuur** (2025-11-26 16:55):
@Alejandro Acevedo Osorio will you pick it up immediately?

---

**Alejandro Acevedo Osorio** (2025-11-26 16:58):
Not like immediately as I have some work in-flight

---

**Daniel Barra** (2025-11-26 17:45):
*We are pleased to announce the release of 2.6.3, featuring bug fixes and enhancements. For details, please review the release notes (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.3.html).*

---

**Rajesh Kumar** (2025-11-26 18:50):
Ok.i will ask

---

**Daniel Murga** (2025-11-27 08:58):
Hi guys! Question... My customer is trying to setup RBAC on their environment, is this changing how Agents interact with the Observability? I mean... each agent should have the same Receiver API KEY configured to communicate with the SUSE Observability Receiver API, am I wrong?

---

**Alejandro Acevedo Osorio** (2025-11-27 09:03):
For rbac is necessary to have a dedicated service token issued for the cluster, that service token token can be used for all other agents in that cluster. The service token is the one you get on the stack packs page when installing the cluster

---

**Bram Schuur** (2025-11-27 09:04):
Dear Garrick, we just released version 2.6.3 which includes a fix for the data corruption for NationWide Mutual Insurance. This will not recover a broken instance but will prevent the corruption scenario that happened at this customer form happening. Advise is to upgrade ASAP. Release notes: https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.3.html

---

**Bram Schuur** (2025-11-27 09:08):
@Daniel Murga Version 2.6.3 has been released, which fixes the issue we diagnosed, could you notify the customer? https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.3.html

---

**Daniel Murga** (2025-11-27 09:10):
thanks @Alejandro Acevedo Osorio! Is this documented anywhere?

---

**Louis Lotter** (2025-11-27 09:16):
<!subteam^S09KPNND599> Hi. For L3 tickets related to Suse observability. Please engage with the Suse observability team in this channel.

---

**Bram Schuur** (2025-11-27 09:19):
I also put this on the board (https://stackstate.atlassian.net/browse/STAC-24000), @Alessio Biancalana i think we should fix this quick, its an easy fix and we can release it soon.

---

**Bram Schuur** (2025-11-27 09:19):
@Rajesh Kumar version 2.6.3 has been released, could you ask the custmer to upgrade? https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/release-notes/v2.6.3.html

---

**Rajesh Kumar** (2025-11-27 09:20):
Yes, I have requested them for a upgrade and monitor without doing any manual changes we did earlier

---

**Bram Schuur** (2025-11-27 09:20):
great! thanks

---

**Rajesh Kumar** (2025-11-27 09:21):
Will update once we receive anything. Thank you soooooo much for all your help and guidance.

---

**Alejandro Acevedo Osorio** (2025-11-27 09:27):
We have the service token for agent here https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/security/k8s-service-tokens.html#_suse_observability_agent
and service tokens themselves https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/security/k8s-service-tokens.html#_suse_observability_agent

---

**Alejandro Acevedo Osorio** (2025-11-27 09:29):
where you get the service token for the cluster you are about to observe. Basically the user gets a service token via that screen and that's what they use when installing the agent via `helm upgrade ...` or via the `Rancher UI`

---

**Daniel Murga** (2025-11-27 09:42):
Nice... Is there something to configure on server side?

---

**Alejandro Acevedo Osorio** (2025-11-27 09:43):
not at all ... that button takes care of creating everything we need server side (the service token with the needed permissions)

---

**Alejandro Acevedo Osorio** (2025-11-27 09:47):
@Javier Lagos with the just released `SUSE Observabaility 2.6.3` the fix for https://stackstate.atlassian.net/browse/STAC-23828 is available for customers

---

**Alejandro Acevedo Osorio** (2025-11-27 09:52):
Another useful docs link for this topic https://documentation.suse.com/cloudnative/suse-observability/latest/en/use/security/k8s-ingestion-api-keys.html#_ingestion_api_keys_deprecated

---

**Bram Schuur** (2025-11-27 09:56):
@Alejandro Acevedo Osorio i feel the last page you linked could do with an update to reflect that the service token is now the thing to do. I'll fix that right away

---

**Alejandro Acevedo Osorio** (2025-11-27 09:57):
Great idea

---

**Daniel Murga** (2025-11-27 10:18):
yes please... yesterday during a call with a customer I just realized (because they told me) that receiver api key is not the prefered method now

---

**Bram Schuur** (2025-11-27 10:55):
@David Noland could you make it such that some of our team (me, @Remco Beckers, @Louis Lotter, @Daniel Barra) can create release/fix verison on the SUSE jira? i seem to not be able to do that (permissions probably? or me just not knowing how)

---

**Chris Riley** (2025-11-27 11:44):
Just to clarify, Bram ... you mean; get the ability to create new product versions that will be available in the dropdown list?

---

**Bram Schuur** (2025-11-27 12:16):
Exactly that

---

**Bram Schuur** (2025-11-27 12:26):
@Alejandro Acevedo Osorio @Akash Raj openend the following PR, could you check? https://github.com/rancher/stackstate-product-docs/pull/139

---

**Alejandro Acevedo Osorio** (2025-11-27 12:27):
I'm in a customer call, will take a look later

---

**Ettore Ciarcia** (2025-11-27 12:31):
Hi @Alejandro Acevedo Osorio
customer followed the steps but at the end the Hbase cluster is still in an inconsistent state

I'm building some knowledge around Hbase right now, Otherwise I don't understand what's going on

---

**Alejandro Acevedo Osorio** (2025-11-27 12:35):
We went from 4 to 6 inconsistencies :sadpanda:  ... although one of the original is no longer present in this report

---

**Chris Riley** (2025-11-27 12:53):
Ok. I believe you’ll need to raise an SD ticket to request admin access.
Might also be worth checking with Paul Gonin to see if he knows a better way.

---

**Alejandro Acevedo Osorio** (2025-11-27 12:53):
wonder if after the `scheduleRecoveries` commands we should have restarted all hbase ... :thinking_face:

---

**Bram Schuur** (2025-11-27 13:14):
SD ticket filed: https://sd.suse.com/servicedesk/customer/portal/1/SD-204714

---

**Ettore Ciarcia** (2025-11-27 13:22):
Yes, they restarted Hbase

---

**Alejandro Acevedo Osorio** (2025-11-27 13:33):
well then I guess we only have 2 options. Either to retry the recover with the now 6 inconsistencies found ... or go for restoring a configuration backup https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_rest[…]ackup (https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/data-management/backup_restore/configuration_backup.html#_restore_a_backup) ... on the configuration restore option they'll loose the historic topology but of course they get the instance up and running quite fast will all the stackpacks installed, etc ...

---

**Sam Vasconcelos** (2025-11-27 14:20):
Hey Team! We have a customer who is unable to view one of the Health Monitors in the Related Health Violations section. but when Clicking on the specific component name in the _Related Health Violations_ section and then going to the _Health Monitor_, the Health Monitor is displayed normally.
when checking the HAR we can see the failed request:
```GET /api/monitor/checkStatus/&lt;monitorID&gt;?topologyTime=1764134613651
→ 404```
and the backend returns:
```"_type": "MonitorCheckStatusNotFoundError"
"id": "day-to-day/debit-and-credit-cards/…/No successful Creditcard VISA payments_anomaly"```
The violation references an outdated monitor ID whose MonitorCheckStatus object no longer exists (likely deleted/renamed/migrated?). The UI does not handle this case and crashes.
The monitor seems to exists _as referenced by the violation_, but the backend cannot find the corresponding MonitorCheckStatus object.
Could this be an application bug? Is there a repository I can take a look?

---

**Bram Schuur** (2025-11-27 14:45):
Dear sam, we saw the ticket and confirmed it as a bug on our end. Its been scheduled for refinement. (https://jira.suse.com/browse/SURE-11002)

---

**Bram Schuur** (2025-11-27 14:45):
thanks for reporting!

---

**Sam Vasconcelos** (2025-11-27 14:46):
thanks Bram! :sonic_running:

---

**Rajesh Kumar** (2025-11-27 14:54):
upgrade done. jmx is fine but elasticsearch and receiver pods are crashing with OOM. Also server and tephera mono are restarting for some reason, can't see anything in logs.

---

**Rajesh Kumar** (2025-11-27 15:02):
they have noticed that the issue appears after deploying the agent.

---

**Rajesh Kumar** (2025-11-27 15:12):
yes.. still taking from the node

---

**Rajesh Kumar** (2025-11-27 15:14):
except server all of them are OOMKilled.

---

**Ettore Ciarcia** (2025-11-27 16:11):
These script can't work right now because a lot of pod are down

---

**Alejandro Acevedo Osorio** (2025-11-27 16:12):
I see, the hbase issue prevents it from working.

---

**Ettore Ciarcia** (2025-11-27 16:13):
It seems like we're stuck

---

**Ettore Ciarcia** (2025-11-27 16:14):
CLI procedure didn't work and we can't move forward with a backup, What can we do from here?

---

**Ettore Ciarcia** (2025-11-27 16:15):
Now the customer is asking "If I have to delete a PVC of Hbase, which statefulset would you recommend to delete first? Maybe Zookeeper?"
I don't want him to delete the PVCs. Are there any other options?

---

**Alejandro Acevedo Osorio** (2025-11-27 16:17):
So I see 2 options then:
• Clean install
• Lot of manual intervention recovery
    ◦ Uninstall Suse Obs
    ◦ Delete PVCs for
        ▪︎ data-suse-observability-zookeeper-0
        ▪︎ data-suse-observability-kafka-0
        ▪︎ data-suse-observability-hbase-hdfs-snn-0
        ▪︎ data-suse-observability-hbase-hdfs-nn-0
        ▪︎ data-suse-observability-hbase-hdfs-dn-2
        ▪︎ data-suse-observability-hbase-hdfs-dn-1
        ▪︎ data-suse-observability-hbase-hdfs-dn-0
    ◦ Install again Suse Obs
    ◦ Do the restore of configuration now that we have a stable (empty) hbase

---

**Alejandro Acevedo Osorio** (2025-11-27 16:19):
But again the option with manual interaction takes some time and is of course tricky

---

**Ettore Ciarcia** (2025-11-27 16:22):
I can suggest to uninstall SUSE Obs and starting with a clean install since this is a non-production environment.
But I don't think the customer will be happy.

Also because they're using the same stack in production

---

**Alejandro Acevedo Osorio** (2025-11-27 16:24):
I can imagine they won't love it, TBH given is a non prod environment I'd go for the clean install.
Do we know what caused the several nodes going down?

---

**Ettore Ciarcia** (2025-11-27 16:24):
They regularly patch nodes/reboot them

---

**Alejandro Acevedo Osorio** (2025-11-27 16:26):
It would be nice if they do it in the recommended 1 at a time fashion :joy:

---

**Ettore Ciarcia** (2025-11-27 16:27):
I can suggest both options

---

**Ettore Ciarcia** (2025-11-27 16:27):
But what if the customer want to go for the "Lot of manual intervation"?

---

**Ettore Ciarcia** (2025-11-27 16:27):
Can someone assist me?

---

**Bram Schuur** (2025-11-27 16:27):
okey, i reproduced the issue using SLES 16, k3s and our latest master. For tephra it is clera it cannot find the mem limit:

```nobody@bram-instance-hbase-tephra-mono-0:/&gt; java -Xlog:os+container=trace --version
[0.000s][trace][os,container] OSContainer::init: Initializing Container Support
[0.000s][debug][os,container] Detected optional pids controller entry in /proc/cgroups
[0.000s][debug][os,container] controller cpuset is not enabled

[0.000s][debug][os,container] controller cpuacct is not enabled

[0.000s][debug][os,container] controller memory is not enabled

[0.000s][debug][os,container] One or more required controllers disabled at kernel level.
openjdk 21.0.9 2025-10-21
OpenJDK Runtime Environment (build 21.0.9+10-suse-1500-x8664)
OpenJDK 64-Bit Server VM (build 21.0.9+10-suse-1500-x8664, mixed mode, sharing)
nobody@bram-instance-hbase-tephra-mono-0:/&gt; ```
This stackoverflow post confirms the issue combining java 21, kernel 6.12 and cgroupsv2: https://stackoverflow.com/a/79634679

The issue for this exact combination is fixed in jvm 25: https://bugs.openjdk.org/browse/JDK-8347811
The backport for this particular issue is done in JVM 21.0.10: https://bugs.openjdk.org/browse/JDK-8371005

I am not sure what to recommend to the user here. We will do another round of bumping JVM versions and verifying on my reproduction, but that will take some time to release.

The stackoverflow recommmends recompiling the kernel, which is not great, downgrading SLES might be an option if the customer want to get started quickly. Otherwise i don't immediately see an option but to wait

---

**Alejandro Acevedo Osorio** (2025-11-27 16:28):
For customers who do rolling updates to patch nodes we for sure recommend https://documentation.suse.com/cloudnative/suse-observability/latest/en/setup/install-stackstate/kubernetes_openshift/affinity.html ... the whole hbase/hdfs setup relies on not having all members of the cluster going down at once. Those affinity values help to make sure that hbase pods are colocated in different nodes

---

**Alejandro Acevedo Osorio** (2025-11-27 16:29):
https://suse.slack.com/archives/C07CF9770R3/p1764257254567609?thread_ts=1764164776.059959&amp;cid=C07CF9770R3 Not sure given that is not a prod environment. If it was prod for sure.

---

**Bram Schuur** (2025-11-27 16:39):
hmm, 21.0.10 will be released in januari according to https://www.java.com/releases/

---

**Bram Schuur** (2025-11-27 16:41):
and 25.0 is not on the bci images yet, which we use as base

---

**Bram Schuur** (2025-11-27 17:04):
I discussed, we'll make all memory settings 'fixed' to not be be exposed to the plethora of bugs jvm has, pugrading to JVM 25 is too much of a stretch right away. This fix will take time to land though. cc @Remco Beckers @Alejandro Acevedo Osorio

---

**Rajesh Kumar** (2025-11-27 17:10):
I have asked them to downgrade to sales 15 and test. Hopefully it works there

---

**Ettore Ciarcia** (2025-11-27 17:11):
That's why we are in this situation:
"We discovered that some of the worker nodes were drained before the reboot with the --force flag."

---

**Rajesh Kumar** (2025-11-27 17:12):
But should we document this for now as its not working on sles16

---

**Alejandro Acevedo Osorio** (2025-11-27 17:12):
I see ... well I guess there can't be much guarantees in a distributed system|database (hbase) when that happens. So hopefully they will be ok with the clean install

---

**Ettore Ciarcia** (2025-11-27 17:12):
I don't understand why they want to start deleting PVCs. Am i missing something?

---

**Alejandro Acevedo Osorio** (2025-11-27 17:13):
not sure, but the manual PVC deletion is tricky in this case (as I described)  on the previous steps. So really for a test env I think they should just do a clean install

---

**David Noland** (2025-11-27 21:55):
For me, I don't see new versions in the drop down, but I can enter in new versions directly. Does that work for you? If not, then yes, an SD ticket should help to get that enabled for you.

---

**Bram Schuur** (2025-11-28 11:10):
I am not able to do that, I am assuming due to permissions

---

**Louis Lotter** (2025-11-28 16:06):
<!here> We are hosting an RBAC knowledge sharing session now. If anyone is interested to join
Video call link: https://meet.google.com/emf-edgq-ctt

---

**Louis Lotter** (2025-12-01 09:21):
<!here> Here is the video for the above RBAC training session https://drive.google.com/file/d/13z53QMdLlkAMw4bBub66H05XesN0jbB1/view?usp=sharing

---

**Louis Lotter** (2025-12-01 09:22):
@Alejandro Acevedo Osorio thanks for your time and effort to prepare this.

---

**Daniel Murga** (2025-12-01 09:58):
Thanks a lot guys!

---

**Chris Riley** (2025-12-01 10:28):
Yeah, thanks so much @Alejandro Acevedo Osorio - much appreciated!

---

**Bram Schuur** (2025-12-01 14:29):
@Giovanni Lo Vecchio i filed the following ticket, taking it into our prioritization: https://stackstate.atlassian.net/browse/STAC-24023

---

**Giovanni Lo Vecchio** (2025-12-01 14:41):
Thanks a lot, @Bram Schuur!

---

**Garrick Tam** (2025-12-01 19:12):
Thank you for the fix and update.

---

**Garrick Tam** (2025-12-01 20:33):
Customer came back asking if it is possible to split the PVC between NVMe storage and slower hybrid storage?  I see from the values.yaml --&gt; https://github.com/StackVista/helm-charts/blob/master/stable/suse-observability/values.yaml#L11C1-L12C16; storageClass can be overridden per PVC.  Which PVC should use NVMe storageClass to circumvent the above condition?  And where can I find that storageClass definition in the values.yaml?  I don't believe I see a storageClass line for kafka?  TIA

---

**Akash Raj** (2025-12-02 04:35):
Hi @Bram Schuur  Reviewed and added my comments :+1::skin-tone-2:

---

**Remco Beckers** (2025-12-02 12:35):
I see in all the agent logs the same thing is happening: a few times per day (in the last few days mostly) the received request is Malformed, no data is received at all and the request times out. But that's only for a few requests every day (a little more for the logs receiver, but it likely gets more data to process than the others).

I don't see any component that's not working properly. The receiver tries to parse the message and finds out it cannot parse it as proper protobuf (or HTTP in some cases). In combination with the other errors (timeouts reported at client and server side) it seems like requests may get truncated and/or delayed somewhere on the network between the agent and the receiver.

Given the agent is shipping data to an HTTPS endpoint and the receiver is receiving it on an HTTP endpoint there must be some load balancer, reverse proxy and/or ingress controller in between.

---

**Remco Beckers** (2025-12-02 12:36):
I would expect either the receiver pods themselves are a bottleneck (maybe they get throttled) or the load balancer/proxy in between is a bottleneck

---

**Remco Beckers** (2025-12-02 12:36):
For the receiver they can use SUSE Observability itself to check the pod cpu/memory usage and throttling on the pods page (if they have the agent installed in the SUSE Observability cluster)

---

**Remco Beckers** (2025-12-02 12:38):
But back to the original question: I really have to search for these errors in the agent logs and on the receiver log side we also see them only occassionaly. If they have pod logs consistently missing for some pods the cause is likely something else. Note that for 2 out of the 3 errors the agent will retry sending of the logs

---

**Remco Beckers** (2025-12-02 12:47):
A Jira ticket would be helpful indeed

---

**Bram Schuur** (2025-12-02 13:02):
We require NVMe for all backing stores.

---

**Daniel Murga** (2025-12-02 18:58):
Thanks for your time and accurate answer @Remco Beckers! I will arrange a call with customer to get more details. Tomorrow I will create the Jira ticket.

---

**Javier Lagos** (2025-12-03 10:55):
Can anyone take a look at the following PullRequest? https://github.com/rancher/stackstate-product-docs/pull/144/files. Today I have just noticed that support package logs is not working properly as it never finishes . @Amol Kharche and me have found that there is a duplicated jq command on the current line 174. I just removed it and created a quick PullRequest

---

**IHAC** (2025-12-04 09:49):
@Daniel Murga has a question.

:customer:  Ministerie van Defensie (JIVC)

:facts-2: *Problem (symptom):*  
Customer environment is air-gapped. They opened a case... when accessing observability dashboards from a user computer the browser is trying to download a JS dependency, see attached screnshots. I told the customer that's nothing to do with an air-gapped environment, from my point of view what's "air-gapped" and we can provide support is the product instance itself not the user's computer and browser. The issue is a browser dependency... Please take a look at converstation:

```Hello Paul, 
We've reviewed the screenshot showing the StackState UI loading errors.

The issue is not with the StackState application itself, but with your computer's inability to download a required file from the internet to finish loading the UI.

The specific error, net::ERR_NAME_NOT_RESOLVED, means your machine cannot find the server for cdn.jsdelivr.net (http://cdn.jsdelivr.net). This is needed by the StackState interface.

This is a network/DNS issue on the user's computer, not an application error.  Can you please run the following tests:


Open a command prompt/Terminal.
Run the command: ping cdn.jsdelivr.net (http://cdn.jsdelivr.net)
If this fails: It confirms the DNS lookup is blocked or misconfigured.
Ensure no local firewall rules, proxy settings, or VPN restrictions are blocking access to the external domain cdn.jsdelivr.net (http://cdn.jsdelivr.net).

Once the user's machine can successfully reach cdn.jsdelivr.net (http://cdn.jsdelivr.net), the StackState UI should load completely.

Please let me know the result of the ping test.```
Customer answer:
```we are air-gapped that means, we don't have any internet access.. The application should load without any internet connection```

---

**Bram Schuur** (2025-12-04 10:03):
@Anton Ovechkin @Sam Jones do we have a policy on this? I think it would be great if we ship all required js code, but if this is infeasible/a lot of work we might reconsider. Tagging @Mark Bakker

---

**Anton Ovechkin** (2025-12-04 10:06):
it would badly hurt performance of the app if we ship the entire JS bundle as a single file
we have been using code splitting for a while and it is an industry-standart literally every somehow modern web app follows

---

**Anton Ovechkin** (2025-12-04 10:07):
but I don’t get it why monaco is hosted in a cdn.jsdelivr.net (http://cdn.jsdelivr.net) :thinking_face:

---

**Anton Ovechkin** (2025-12-04 10:07):
it should be hosted next to the rest of the app source code

---

**Anton Ovechkin** (2025-12-04 10:08):
in that case, the answer is that we absolutely must provide all source code for download without internet access

---

**Daniel Murga** (2025-12-04 10:10):
thanks @Bram Schuur and @Anton Ovechkin! Should we consider this a bug or a RFE? Should I communicate that we will provide a solution?

---

**Anton Ovechkin** (2025-12-04 10:12):
it’s a bug for sure

---

**Daniel Murga** (2025-12-04 10:13):
ok, let me fill a Jira for this

---

**Remco Beckers** (2025-12-04 10:21):
How is a customer using an unreleased feature (dashboards)? Did they flip the feature flag themselves?
I don't really care if the do that, but they also need to be aware that we don't support dashboards yet and the release may have breaking changes on them

---

**Daniel Murga** (2025-12-04 10:23):
Not aware of that... @Remco Beckers
```Hello,

We recently deployed the suse-observability helm-chart (2.6.3) with the feature enabled:

stackstate:
features:
dashboards: true

The dashboard functionality is not working properly in our air-gapped environment
it tries to download some JavaScript: https://cdn.jsdelivr.net/npm/monaco-editor@0.52.2/min/vs/loader.js but we don't have any internet access ....```

---

**Daniel Murga** (2025-12-04 10:23):
Is there any place where we can check that this feature is not yet GA?

---

**Remco Beckers** (2025-12-04 10:25):
It's  not in our documentation for exmaple. All supported feature flags are enabled by default afaik

---

**Daniel Murga** (2025-12-04 10:27):
this is a weird situation... should we support it? Should we tell the customer to stop using it?

---

