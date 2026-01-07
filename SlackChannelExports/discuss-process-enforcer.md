# Slack Channel: #discuss-process-enforcer

Exported conversations for search and reference.

---

**Flavio Castelli** (2025-10-08 15:36):
@Andrea Terzolo let's use this channel to discuss about the process enforcer :slightly_smiling_face:

---

**Sam Wang** (2025-10-09 03:03):
Thanks for the discussion @Andrea Terzolo brought up today in <#C08C8E46AF5|>!
I did a few scaling tests with 200 WorkloadSecurityPolicies and created two issues:
• https://github.com/neuvector/runtime-enforcement/issues/221
• https://github.com/neuvector/runtime-enforcement/issues/222
One unexpected finding is that, our usage doesn't really require kprobe_override_return, so we don't need #190 (https://github.com/neuvector/runtime-enforcement/pull/190) anymore for good.  This will facilitate #222 as well.

---

**Bram Schuur** (2025-10-09 11:35):
Question @Flavio Castelli (and @Sam Wang @Kyle Dong). Has there already been work done on a rancher extension for the process enforcer? (Afaik this should be owned/developed by the suse security ui team?)

---

**Flavio Castelli** (2025-10-09 11:40):
no work has been done yet. We have not defined the UX even.

We want to collect more user stories with our PM before doing that

---

**Flavio Castelli** (2025-10-09 11:40):
when this is going to be done, it will be owned by the former NV UI team

---

**Andrea Terzolo** (2025-10-09 14:31):
IMHO we should try to figure out which is best way to enforce policies, knowing the limits of each approach. As far as i understand tetragon has 3 main ways to enforce polices:
1. kprobe + `bpf_override_return`
    ◦ this doesn't seem to have limits on the number of policies we can inject but requires `CONFIG_BPF_KPROBE_OVERRIDE` enabled
2. `BPF_MODIFY_RETURN` ebpf progs
    ◦ this has for sure the limit on max 38 hooks on the same function due to  BPF_MAX_TRAMP_LINKS https://lore.kernel.org/bpf/CAGQdkDs8e0_o0uHpcUF_ZbG=isa_GjJcTr8=Ykwy0jJek=e=4w@mail.gmail.com/T/
3. LSM
    ◦ still need to investigate
If i understand correctly the acutal implementation uses 1/2 according to the kernel version/traced function. Is this right?
What is the minimum kernel version we plan to support with the process enforcer?

---

**Flavio Castelli** (2025-10-09 14:51):
I think here we must make a distinction between community and commercial edition. I think the commercial edition is more constrained compared to the community one (where we could just say "run with latest shiny kernel).

We have to look at rancher's support matrix (https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-12-2/) and investigate which kernels these distributions are running and build a spreadsheet with what we have at our disposal. Then we can make a decision together with product.

---

**Sam Wang** (2025-10-09 15:32):
@Andrea Terzolo thanks for putting those information together.  To add

&gt; kprobe + `bpf_override_return`
When using kprobe on LSM functions (`security_*`), Tetragon will use `BPF_MODIFY_RETURN` implicitly.  This is implemented in this PR: https://github.com/cilium/tetragon/pull/1609


&gt; LSM
• For Tetragon LSM, it installs *two* LSM programs for `generic_lsm_core` and `generic_lsm_output` (or three if IMA is enabled).  This is done here (https://github.com/cilium/tetragon/blob/ab6640a6871e86d1841bee7ac2574a29d73cd0be/pkg/sensors/tracing/genericlsm.go#L452). 
• Under the hood, LSM ebpf programs are installed via BPF_LINK_CREATE, which uses eBPF trampoline, so unfortunately it will also suffer from the `BPF_MAX_TRAMP_LINKS` limit too.

---

**Sam Wang** (2025-10-09 15:39):
If we put the hook point into consideration:
1. kprobe + bpf_override_return on syscalls
    ◦ Hooking on syscalls is prone to TOCTOU race and symlink resolution.
    ◦ Doesn't have the BPF_MAX_TRAMP_LINKS limitation.
2. kprobe + BPF_MODIFY_RETURN on LSM functions
    ◦ Hooking on LSM functions - bprm provides the real path of executable without the need to resolve the path.
    ◦ Has the 38 BPF_MAX_TRAMP_LINKS limitation, but would be relatively easier to resolve compared to LSM. 
3. LSM BPF programs on LSM functions.
    a. Hooking on LSM functions - bprm provides the real path of executable without the need to resolve the path.
    b. Has the 38 BPF_MAX_TRAMP_LINKS limitation.
    c. Relatively difficult to resolve, because all Tetragon core logic is in the LSM ebpf program, which will take one seat of ebpf trampoline.

---

**Sam Wang** (2025-10-09 15:39):
@Andrea Terzolo thoughts?  Does it make sense to you? :slightly_smiling_face:

---

**Andrea Terzolo** (2025-10-09 15:44):
yep, thank you for the detailed summary!
So today if we want to inject more than 38 policies we need to use solution 1, but we still need a patch upstream to disable the automatic injection of `BPF_MODIFY_RETURN` when we have a kprobe on LSM (our current use case since we use `security_bprm_creds_for_exec`)

---

**Sam Wang** (2025-10-09 15:54):
&gt; So today if we want to inject more than 38 policies we need to use solution 1
Yes that's correct.  I would have to take a thorough read of the tetragon PR (https://github.com/cilium/tetragon/pull/1609) and maybe some Linux discussions/codes, but I am under an impression that `BPF_MODIFY_RETURN` has to be used if we install hooks on LSM functions.  That means if we want to use solution#1, we would still have to change our hook points and deal with the race and path resolution, which makes it less ideal.  I think solution#2 is more ideal from security and effort's perspective if it doesn't involve a large changes.  I plan to do some POC today or tomorrow.

Our current implementation is on solution#2.

---

**Andrea Terzolo** (2025-10-09 15:59):
&gt; Yes that's correct.  I would have to take a thorough read of the tetragon PR (https://github.com/cilium/tetragon/pull/1609) and maybe some Linux discussions/codes, but I am under an impression that `BPF_MODIFY_RETURN` has to be used if we install hooks on LSM functions.
uhm i honestly don't know, we need to check. I thought you could attach a kprobe there, in the end they are kernel functions but yeah we should double check.
&gt; I think solution#2 is more ideal from security and effort's perspective if it doesn't involve a large changes. I plan to do some POC today or tomorrow.
Yeah i agree with you kprobing on other kernel functions/syscalls could be dangerous
Thank you for taking a look into this, i will do the same as well

---

**Sam Wang** (2025-10-09 16:02):
&gt; uhm i honestly don't know, we need to check. I thought you could attach a kprobe there, in the end they are kernel functions but yeah we should double check.
In addition to attaching kprobe, there is a white list in the kernel defining what can be `kprobe_override_return`, but I have to double check too.

---

**Sam Wang** (2025-10-09 16:25):
yeah LSM functions, i.e., `security_` are not there:

---

**Andrea Terzolo** (2025-10-09 17:15):
i see so no kprobes with override on these functions...

---

**Sam Wang** (2025-10-09 23:35):
A detailed investigation is still needed, but here is the high-level requirement of kernel versions/options for process enforcer that I’m aware of.  Hope this can help to build a strategy for us to create a support matrix and compare with rancher.
• kprobe_override
    ◦ CONFIG_BPF_KPROBE_OVERRIDE kernel compile option
    ◦ Disabled on SLES and Fedora. 
• fmod_ret
    ◦ Linux 5.7+ per here (https://docs.ebpf.io/linux/program-type/BPF_PROG_TYPE_TRACING/). 
• LSM BPF
    ◦ Linux 5.7+ per here (https://docs.ebpf.io/linux/program-type/BPF_PROG_TYPE_LSM/).
    ◦ CONFIG_BPF_LSM and CONFIG_LSM compile options
    ◦ Disabled on Ubuntu and Amazon Linux.

---

**Sam Wang** (2025-10-10 00:31):
Just a note that the next Monday is Canadian holiday (thanksgiving :turkey:).  Kyle and I will be off.

---

**Alessio Biancalana** (2025-10-10 08:56):
@Sam Wang thanks for conducting the search yourself, I was about to do it yesterday but other things filled my plate and stole plenty of time (:cry-cat:)

I don't know what @Andrea Terzolo thinks about that but to me from this initial investigation it looks like basically `fmod_ret` is the only way to go if we want to lower the barrier for users

---

**Flavio Castelli** (2025-10-10 09:38):
Thanks for the research, can you also make sure linux 5.7 is available on the distro versions that Rancher supports?

---

**Alessio Biancalana** (2025-10-10 09:54):
• SLE Micro 6.0: Linux 6.4
• SLES 15 SP7: Linux 6.4
• Leap 15.6: Linux 6.4
• Oracle Linux: it depends if you pick the default kernel (6.12) or the Red Hat Compatible Kernel (5.14) (safe in both cases I think)
• Rocky Linux 9.4: Linux 5.14
• Amazon Linux 8.8: Linux 4.18 :skull: 
• RHEL 10: Linux 6.12
• Ubuntu 22.04 LTS: Linux 5.15
These are all .0 versions.

I'd say if we rule out Amazon Linux 8.8 we are pretty much covered. (on a personal note: why do we support Amazon Linux 8.8? It's a pretty old version compared to the rest of the distros I'm seeing)

---

**Andrea Terzolo** (2025-10-10 10:04):
&gt;  Amazon Linux 8.8: Linux 4.18
probably there is some heavy backporting here, we need to check if they backported the features we need

---

**Andrea Terzolo** (2025-10-10 10:09):
If we really want to hook the LSM api we cannot go under 5.7 (unless backported). This is the kernel version where it was introduced.
Side note: kernel 5.4 will go EOF at the end of the year https://www.kernel.org/releases.html , since we release on march i would suggest to not go under 5.10 support if possible (RHEL 8/9 are the usual exceptions because they support almost all eBPF features even with a kernel 4.18/4.19)

---

**Andrea Terzolo** (2025-10-10 14:01):
Hey all! this is a summary with my takes on the process-enforcer as of today. Please note the first line in bold *`This is my take on our current solution, we could face other limitations while going deeper or i could have misunderstood something so please take it with a grain of salt.`,* please correct me if there is something wrong there. I created a google doc for now because i don't think all the people in this channel has access to the github repo.
https://docs.google.com/document/d/1dHaPXOQttkg4Y2nUSasw8-YWneQ5PtjOii1nKQhI-sg/edit?tab=t.0

---

**Andrea Terzolo** (2025-10-10 14:02):
i'm not proposing any action item there, just dumping what i have on top of my mind

---

**Alessio Biancalana** (2025-10-10 14:51):
thanks! I'm totally on board with these results, maybe the result of a further analysis will be that we'll have to rethink a little bit the usecase and leverage a per-node instead of a per-pod solution.

I don't wanna be too hasty in providing advice tho, I'll try to have a deeper look.

Amazing job man, really

---

**Sam Wang** (2025-10-10 16:05):
It’s so great to see these information put together with great technical detail.  Thanks @Andrea Terzolo !  

I agree sigkill can be a great alternative.  A different hook point might be needed as LSM examines the parent process instead of the process that violates the policy, i.e., the new process is not spawned yet in LSM hooks, but a different hook point should work.  This will also help us to expand the support matrix since we don’t need kprobe override or kmod_ret. We can also use it to circumvent the 38 limits in case the communication/fix with upstream drags long.  

I think we should start the communication about the 128 limit with upstream first, as it is more straightforward, can’t be worked around, and will help all Tetragon users.  Thoughts? @Andrea Terzolo ? 

On the performance/memory utilization part, @Andrea Terzolo do you think it’s a major concern right now?

---

**Andrea Terzolo** (2025-10-10 16:29):
> On the performance/memory utilization part, @Andrea Terzolo do you think it’s a major concern right now?
Good question. As of now, my concern is that even if we scale the number of policies the solution itself won't scale from the performance point of view. Let's say we set the limit to 500 policies, this means that on the same node we are running 500 eBPF programs attached to the same function. If tomorrow we support another policy on files we have other 500 progs and so on...
I believe that in the long term this model wouldn't scale.

We could say, ok let's do this as a v1 but if we already know that after 2/3 months we have to do breaking changes because we change the whole architecture probably this is not the best approach.

At the moment i'm reading the full tetragon documentation to see if i missed something obvious. Maybe there is a way to do that.
As far as i can tell for now what they would probably suggest for our use case is a set of tracing policies per-node. With a set i mean that maybe some workloads needs a more strict policy while other a more relaxed one, but we can group them in a few policies. They don't grow linearly with the number of worlkloads. Of course we lose granularity but at least this seems a solution that could scale in the future.

The alternative is probably to have a unique ebpf prog that dispatches the policies of all the pods, but this is something we need to model and design from scratch. Before going down this road i would like to understand the real benefits with respect to a per-node policy. What is the original feature request that led us to per-workload policies?

IMHO we should try to understand if given the requirements a set of node policies could be enough for the use cases we have in mind. WDYT?

---

**Andrea Terzolo** (2025-10-10 16:34):
maybe in the past you have already excluded the per node policy for some reasons because it doesn't fit the requirements

---

**Sam Wang** (2025-10-10 17:12):
Yeah the requirement is basically that we want to allow cluster administrators, or the author of containers to define a white list of executables that their workload can run.

Eventually we would like to allow users to define a prebuilt policy with their container, so they can be released along with their container.  This would start from the AppCo. Unfortunately, this is not something that can be done with the per-node policy if I understand it correctly.

This RFC has some information in it: https://github.com/neuvector/runtime-enforcement/blob/main/docs/rfc/0001-workloadgroup.md

---

**Sam Wang** (2025-10-10 17:34):
I think we have a consensus that the current model based on Tetragon is not very efficient.  The ideal architecture is to only attach only one program + its tail calls through kprobe + LSM hook.  (Feel correct me if I'm wrong.)

The question right now is how to do it.

I think in our use case, we only need a shared ebpf program on `security_bprm_creds_for_exec` .

Tetragon has a few pre-defined ebpf programs, e.g., tg_kp_bprm_committing_creds (https://github.com/cilium/tetragon/blob/e4bfe1452d9b6364a936322c1b57cb9f8c6c06b5/bpf/process/bpf_execve_bprm_commit_creds.c#L48).  We might be able to provide a pre-built shared `security_bprm_creds_for_exec` in Tetragon.

We might be able to add a new argument in Tetragon tracing policy's schema, so it will use the existing shared program if it's available.

Not saying that upstream will happily accept all our proposals, but there seems to be rooms to explore on Tetragon side for the usage of our kinds.

---

**Sam Wang** (2025-10-10 17:37):
What I wanna say is, addressing those issues in the future Tetragon is also an option of v2.

---

**Sam Wang** (2025-10-10 17:44):
&gt; The alternative is probably to have a unique ebpf prog that dispatches the policies of all the pods, but this is something we need to model and design from scratch.
We've discussed this from the day one.  Unfortunately this approach means that we have to re-invent everything, for example,
• Associate a process to a container.
    ◦ Convert a task_struct to a container ID
• Container runtime integration. 
    ◦ Get container metadata using the container ID
• Kubernetes integration. 
    ◦ Get k8s metadata using container ID.
• Kernel/verifier compatibility
    ◦ Probably the trickiest part since we will have a super large test matrix without community support.

---

**Sam Wang** (2025-10-10 17:50):
Personally I loved the idea to implement our own because it provides more flexibility in the future, but it's kind of trade-off after considering the effort and the community.

---

**Sam Wang** (2025-10-10 17:59):
lol It's a lot of information.  I hope it makes sense to you.  I'm actually not that pessimistic about working with upstream because Tetragon seems very active and willing to accept patches, unlike some other OpenShift projects that I worked with before.

---

**Andrea Terzolo** (2025-10-10 18:03):
ahhahah yeah it is taking some time to craft a response that summarize my point of view, hang on :joy_cat:

---

**Andrea Terzolo** (2025-10-10 18:12):
> _The ideal architecture is to only attach only one program + its tail calls through kprobe + LSM hook.  (Feel correct me if I'm wrong.)_
Yeah i agree with you that we should do something similar to this. If a per workload policy is an hard requirement i believe this is the way to go.

Ideally we should build the solution on top of tetragon since it already provides a lot of the functionality we need. It's ok to ship it even if it is still not merged upstream but IMO it should have been already accepted. Forking tetragon and keep patches on top of it is not a viable solution for me, the ebpf part is too complex to maintain it ourselves. So if we do something on top of it we should upstream it.

The open point is that all the above thing could be not feasible or too complex to do. Maybe we can do that but not using tetragon. There are a lot of unknowns, and we need to release something working in a few months. I'm not 100% sure we can reach a production ready solution in the next 2/3 months.

What i'm trying to understand is: what is the best plan we should follow to be sure we ship something scalable at the first iteration?
What seems clear from this discussion is that we want a per workload policy and we should try a solution for this, but is it something we really want to ship in March?

Should we provide a per-node policy in March and then work on a per workload policy in the following release? If we are fast enough we can do both for March but if not i would avoid to set wrong expectations.

---

**Andrea Terzolo** (2025-10-10 18:15):
&gt; I loved the idea to implement our own because it provides more flexibility in the future, but it's kind of trade-off after considering the effort and the community.
It doesn't seem impossible to implement that feature on top of tetragon but with my limited knowledge of that codebase i cannot extimate how much time it would require or if we will face road blockers during the implementation

---

**Andrea Terzolo** (2025-10-10 18:22):
Should we try to scratch it and postpone the answers to these questions until we have more info? :man-shrugging:

---

**Alessio Biancalana** (2025-10-10 19:09):
I think this is something we wanna clarify ASAP so thanks for bringing that up and yeah, at this point this is n.1 item on the radar I'd say.

m2c: for now going with a per-node policy implementation would allow us to be sort of sure to meet the March window. Of course it would awesome to build more and more but I'd stay conservative for the moment. For example one thing we could do would be starting implementing a per-node strategy and meanwhile already starting getting in touch with upstream to understand if it's feasible and start contributing.

thanks for the thorough explanation @Sam Wang! I think we need more and more data points to actually make a good call here :grimacing:

---

**Sam Wang** (2025-10-11 03:02):
So I did a POC to see if we can overcome the 38 limits if we let multiple policies to share the same `generic_fmodret_override` program and `override_tasks` map.  The change is here (https://github.com/holyspectral/tetragon/commit/a6c577ba84cc6c9a253d6328615f782f6daadd32).

TL;DR it works well.  Some changes are still needed, but it's great to know that it's pretty easy to control/connect the ebpf map and programs inside Tetragon.

In my test scenario I have 100 policies with different selectors to match 100 pods with different labels.  The enforcement based on kprobe + kmod_ret can be done correctly without problem.

We still need some changes to move the map to a different location to make the trampoline/map requirement from #polices to #hookpoints, which is a lot less.  We would also need to change how we install fmod_ret program, but yeah I think it's some progress if we want to address the 38 trampoline limit.

---

**Sam Wang** (2025-10-11 03:11):
> What i'm trying to understand is: what is the best plan we should follow to be sure we ship something scalable at the first iteration?
> What seems clear from this discussion is that we want a per workload policy and we should try a solution for this, but is it something we really want to ship in March?
Agreed.  That's also why I think these discussion is great.  We're evaluating the requirement again to set the correct expectation for the March release. For many questions I don't have answers now, but it's great to see them being brought up, so at least we can try to reach a consensus about it.

---

**Andrea Terzolo** (2025-10-13 09:57):
I just realized something i didn't think about before. Even if a deployment doesn't have a pod on a particular node the tetragon instance on that node will in any case inject a policy for that deployment into the kernel. This means that the number of policies is linear with the k8s workload in the cluster... Today in our preprod cluster we have 58 statefulsets + 139 deployment + 14 daemonset, we are already over 200 policies and this is not even a real production cluster

---

**Andrea Terzolo** (2025-10-13 09:59):
please correct me if i'm wrong but unless there are some optimizations i'm not aware of each instance of tetragon in the cluster will reconcile each policy and inject ebpf progs on the corresponding node.

---

**Andrea Terzolo** (2025-10-13 10:03):
if i look at the tetragon metric `tetragon_tracingpolicy_kernel_memory_bytes` i can see it reports ~4 MB for each policy, this means 200 policies -&gt; 800 MB

---

**Alessio Biancalana** (2025-10-13 10:34):
I thought about that over the weekend, even tho not in terms of memory. Basically what I thought was, with these numbers we need a kind of improvement that doesn't allow us to inject 2x policies (linear, as you said), we need an exponential improvement.

The current design could even be pitched imho but it's very unlikely it actually scales when hitting even test setups.

I'm constantly fidgeting with the idea of having something that translates several policies of our own to one big cilium/tetragon policy per-node, but it's very unlikely that I'll be able to prototype that soon

---

**Andrea Terzolo** (2025-10-14 11:57):
&gt; it reports ~4 MB for each policy, this means 200 policies -&gt; 800 MB
I have to correct myself the memlock for the ebpf maps is ~ 7 MB for each policy , this means 200 policies -&gt; 1.4 GB

---

**Andrea Terzolo** (2025-10-14 11:58):
Even if it seems some not useful maps are loaded

---

**Andrea Terzolo** (2025-10-14 15:02):
Hi guys this is the issue i would like to open on Tetragon to start the discussion on our use case. Let me know what you think

---

**Andrea Terzolo** (2025-10-14 15:04):
it doesn't propose possible solutions for 2 reasons:
• i want to start the discussion ASAP
• i don't want to be super aggressive pushing a solution

---

**Alessio Biancalana** (2025-10-14 15:06):
you're absolutely right, I want to see if just by opening the issue they try to push to address it from the start or they start pushing back :+1:

---

**Bram Schuur** (2025-10-14 15:08):
Nice, looking sharp:+1:

---

**Sam Wang** (2025-10-14 16:09):
yeah I think it looks great.  I think I can understand why they design it that way, but it's great to initiate the discussion.  Thanks for doing this @Andrea Terzolo!

---

**Andrea Terzolo** (2025-10-14 16:10):
>  The change is here (https://github.com/holyspectral/tetragon/commit/a6c577ba84cc6c9a253d6328615f782f6daadd32).
Yep i believe we should end up with something similar. As you mentioned in the standup this specific change will allow us to use just one `fmod_ret` program instead of one for each policy. This is great! i'm just wondering if it should be part of a more holistic solution. I see a future where we just have a one unique ebpf program for all the policies of the same type. Let me share a very first example here. First of all we may need 2 new CRDs
```apiVersion: cilium.io/v1alpha1
kind: ForEachWorkloadPolicy
metadata:
  name: "block-not-allowed-process"
spec:
  # This is the hook we want to instrument once
  kprobes:
  - call: "security_bprm_creds_for_exec"
    syscall: false
    args:
    - index: 0
      type: "linux_binprm"
    selectors:
    - matchArgs:
      - index: 0 
        operator: "NotEqual" 
      matchActions:
      - action: Override
        argError: -1```
This new CR will create just 1 unique ebpf prog. A sort of skeleton prog where maps will be populated by the second CR i will show you in a minute
```__attribute__((section("fmod_ret/security_bprm_creds_for_exec"), used)) long
generic_fmodret_override(void *ctx)
{
    // pseudo code to explain the idea

    // 1. Get the cgroup id of the current process
    cgroupid = tg_get_current_cgroup_id();

    // 2. Retrieve filters associated to that cgroup id
    // the map will be populated by the second CR each time a new one is deployed.
    // it could be we need to run a dedicated ebpf prog in tail call to exec the filters.
    // map[cgroupid] -> filters

    // 3. According to the filter we override or not the return value
    if (match){
      return 0;
    }
    return error; // this is defined once in the policy definition
}```
Now that we have a skeleton injected in the kernel we just need to tell the program which filters we want for that particular workload (so cgroups -> filters).
To do that we can use the second CR
```apiVersion: cilium.io/v1alpha1
kind: ForEachWorkloadPolicyValues
metadata:
  # we need a way to allow multiple instances of this CR with the same name but for different `ForEachWorkloadPolicy`
  name: "deploy-my-deployment" 
spec:
  # Reference to the policy, probably not ideal to use the name as it is not unique
  refPolicy: "block-not-allowed-process" 
  # Select the pods in the workload
  # The controller must ensure that there are no overlapping podSelectors to avoid ambiguity.
  podSelector:
    matchLabels:
      app: "my-deployment-1"
  # Values
  allowedValues: 
    - "/usr/bin/sleep"
    - "/usr/bin/cat"
    - "/usr/bin/my-server-1"```
when the CR is deployed the map in the skeleton program will be updated with the necessary entries `cgroup -> filters` for that specific workload.

This is really something i thought this morning so it could not work at all but i believe this is what they will ask us to do to solve all the performance issues we listed above (both number of progs and number of maps)

---

**Andrea Terzolo** (2025-10-14 16:16):
&gt; I think I can understand why they design it that way, but it's great to initiate the discussion
Yep in their current approach they really want to isolate a policy from another, unfortunately for our use case we want kind of the opposite thing, we want to aggregate as much as we can. That's the reason why i was thinking at something like this https://suse.slack.com/archives/C09KMBW6DA5/p1760451025206789?thread_ts=1760097687.225789&amp;cid=C09KMBW6DA5, we should find a way to tell tetragon "ei, we want all these policies to work together and be related"

---

**Andrea Terzolo** (2025-10-14 16:17):
unfortunately designing something general that addresses all possible use cases tetragon has today it's really hard...

---

**Andrea Terzolo** (2025-10-14 16:22):
Of course this is my take on this. Sam you know that code better than me, do you feel there is a way to reach a similar goal without crafting new CRDs or a new way of working from Tetragon? Let me put it into another way, do you feel that with some feature flags we can reach a clean flow 1 kprobe -> 1 fmod_ret prog and a limited set of maps (for all the policies)?

---

**Sam Wang** (2025-10-14 16:30):
yeah that's what in mind as well and I'm also not sure if it's doable at the moment, unlike the `override_task` program, which is relatively simple. Some POC might be needed.

If I recall it right, the current *per-policy* flow is:
• The cgroup ID is retrieved via `tg_get_current_cgroup_id` .
• The ID is then used to check with `policy_map` , which is maintained by userspace program.  If the ID is found, it tail-calls to the action phase. (sending events, send kill signals and etc. )
The challenge would be to implement this in a shared eBPF program, since one process can match multiple policies.  This is hard to implement in ebpf from my experience. The #instruction would become O(n), n is the #policy, which can hit the size limit pretty easily.

---

**Andrea Terzolo** (2025-10-14 16:57):
&gt; The challenge would be to implement this in a shared eBPF program, since one process can match multiple policies
With the approach above, my idea is to have a unique program for a `ForEachWorkloadPolicy` and inside this BPF program having a map {key:cgroup_id, value: filters map id/prog_id where to jump} so that in this map each cgroup can be bound to one specific filter(it's not possible an association same cgroup -&gt; multiple filters by design). So if we have a cgroup(pod) involved in different policies this relation will be expressed in different maps

---

**Sam Wang** (2025-10-14 17:34):
> So if we have a cgroup(pod) involved in different policies this relation will be expressed in different maps
This part is exactly what I'm not sure.  I think the policy matching itself is big enough.  If we want to do it n times, n= the maximum size of the map (probably a map of map?), the verifier might not like it.  A POC would be nice to verify if this is feasible.

---

**Andrea Terzolo** (2025-10-14 17:55):
ok if we all agree at this point i will open the issue!

---

**Alessio Biancalana** (2025-10-14 17:57):
you have my sword :crossed_swords:

---

**Sam Wang** (2025-10-14 17:58):
And my bow :bow_and_arrow:

---

**Andrea Terzolo** (2025-10-14 17:58):
we have lord of the rings fans here

---

**Louis Lotter** (2025-10-15 10:58):
@Mark Bakker Do we expect the process enforcer to be "production ready" by March next year ? I notice this being discussed in this channel as a requirement but to my understanding March should be for demo purposes only.
I don't mention this to say the we should do things the we know would have to be redone to get it production ready. Only that we may want to be more ambitious than would be allowed if we feel we have to get it "done" in 4 months.

---

**Mark Bakker** (2025-10-15 10:59):
All we made should be made with production in mind if it comes to Agent code running on customer systems.

---

**Mark Bakker** (2025-10-15 10:59):
We don't call it GA but we should aim for GA standards

---

**Louis Lotter** (2025-10-15 11:00):
Of course but there is a difference between aiming for GA standards and knowing it would take 6 - 8 months to get there with a demo at 4 months. and saying we need to have something GA ready by march.

---

**Mark Bakker** (2025-10-15 11:00):
Non GA might mean we don't have all the policies yet. It should not mean high overhead or possible mistakes or instability

---

**Louis Lotter** (2025-10-15 11:00):
we may kill entire trains of thought because we don't think it's doable in 4 months

---

**Mark Bakker** (2025-10-15 11:05):
We should not do that, most important are the things I just said, having a good foundation for the future, the deadline is also important, but if we can't make it somehow because of reasons I am more open to discuss that than having the possibility to introduce overhead or instability.

---

**Andrea Terzolo** (2025-10-15 12:35):
I tried to propose something similar to what we discussed in this slack thread https://github.com/cilium/tetragon/issues/4191#issuecomment-3405723954. Let's see what they say, maybe they will come up with something easier.

---

**Sam Wang** (2025-10-15 16:05):
@Andrea Terzolo I saw your GitHub issue now.  Thanks for doing that!
I'm wondering if you're okay with me chiming in, or you would prefer that we have some discussion here before I do that?

It's no a big deal.  Just wanted to check how we usually co-work in a upstream project.   Thanks!

---

**Bram Schuur** (2025-10-15 16:09):
I had a question based on your great presentation today @Davide Iori (thanks for that). Maybe @Flavio Castelli or @Sam Wang or @Mark Bakker have some insight here?
1. When the runtime enforcer (both the new one and NV one) is in enforce mode, will it always kill/block a process when the policy is violated, or might it still resort to a warning (and not be super secure but lenient).
2. Follow up on 1. If we go for the enforce mode always, i wonder how much the 'alert fatigue' applies to the runtime enforcer? E.g. if we get many alerts, it means that processes get blocked/killed all the time and pretty much the application will be down and blocked.

---

**Flavio Castelli** (2025-10-15 16:10):
when in protect mode, processes not on the allow list are blocked. They cannot be started. That's our goal

---

**Flavio Castelli** (2025-10-15 16:11):
I agree that the alert fatigue from the process enforcer should be low, unless you haven't configured your profile properly. In that case you would also get lots of complaints, because things would not work as expected

---

**Sam Wang** (2025-10-15 16:15):
Thanks for the presentation! @Davide Iori! It's great to see how the product is shaped.  It's also a good lesson for people like me, so we can keep those issues in mind when we implement new stuffs.

Just wanted to add that NV doesn't _learn_ file activities at the moment.  If we decide to pursue this direction, there will be things to explore, especially in dealing with its scalability.

---

**Davide Iori** (2025-10-15 16:25):
Hi Sam, thanks for the feedback!
Good you mentioned the file activities. Depending on technical challenges, we may leave file activities out of the MVP scope and aiming to add those later. To be defined yet.
Anyway thanks for the clarification!

---

**Andrea Terzolo** (2025-10-15 16:26):
Sure i don't see any issues! of course we should try to push in the "same direction" to put a little bit of "pressure" on them, so if you feel i'm pushing in the wrong direction maybe let me know here before going upstream

---

**Andrea Terzolo** (2025-10-15 16:28):
at the moment i'm trying to keep a very conservative approach with them i don't want to push too hard to see how they react to possible new features in tetragon

---

**Sam Wang** (2025-10-15 16:31):
lol I haven’t read through the discussion yet.  Sure I will definitely let you know if I have any thoughts/concerns.

---

**Andrea Terzolo** (2025-10-15 16:35):
nothing special actually. It's more or less what we wrote in this channel, i proposed the idea of the per-workload policy in a very high level form just to see if this is something they could like or not

---

**Sam Wang** (2025-10-15 16:44):
Yeah I second what @Flavio Castelli mentioned.  We currently use EPERM errno, which will be translated to the operation not permitted error message.  

On the other hand, it’s not specific for the alert fatigue, but if the workload is somehow compromised, we might see a burst of alerts showing up.

An example would be an attacker managed to run a bash script in a container, where bash is allowed, and explore the environment.  We might see a lot of events in one or two seconds.

All in all, we might still have to define how we handle the burst.

---

**Davide Iori** (2025-10-15 16:45):
Hi @Bram Schuur
&gt; When the runtime enforcer (both the new one and NV one) is in enforce mode, will it always kill/block a process when the policy is violated, or might it still resort to a warning (and not be super secure but lenient).
Once the enforce (or protect) mode is ON the expectations is that the violation attempts are blocked. If a user wants NOT to block it, he/she should "downgrade" the mode to monitor so that alerts are still sent but the process is not blocked

---

**Davide Iori** (2025-10-15 16:54):
A lot of events is anyway good data we can learn from. However, the way that these events are presented should be "noiseless": a burst of very similar, if not identical, events can perhaps be aggregated in a single warning with a count. Or a burst of events all happening in a specific workload could be aggregated in a workload-specific view so that other users monitoring other workloads are not impacted.
What I am saying, we should strive for a noiseless UX and that is decoupled from the amount of data we collect.
Of course we should also protect our platform stability and have some guardrails around what we ingest. But that is more on the non-functional requirements side of things.

---

**Kyle Dong** (2025-10-15 16:55):
Thanks for the great presentation @Davide Iori!
I wonder if we have conducted a feature gap analysis between NeuVector 5.x and our new SUSE Security 6.0 with Tetragon as the process enforcer. It would be great to ensure that we don’t miss any existing features from NV 5.x that customer likes and that we deliver the new process enforcer to be a better product.

---

**Bram Schuur** (2025-10-15 16:58):
Gotcha, thanks all

---

**Davide Iori** (2025-10-15 16:59):
That's part of the next calls which are centered around the main, high-level customer needs:
• define the security posture
• view the security posture
• remediate the security posture
• trust
For every single topic, we'll see what NV 5.x offers and what competition offers. This should help designing what we want to deliver

---

**Sam Wang** (2025-10-15 17:48):
Sounds good.

The first thing I noticed is that they can change the map size during load time, which is pretty cool.  I know they already adjust the size when loading fmod_ret program.  If this can be applied to the policy map too then we can get rid of the 128 policy limit.  We should be able to implement a helm option as we discussed last week if everything goes well. 

This and the per-hook override should solve short term issues for us.  Do you think we can propose these now, or we should hold a little bit until the dust settles down?

---

**Andrea Terzolo** (2025-10-15 18:25):
&gt; Do you think we can propose these now, or we should hold a little bit until the dust settles down?
this is a good point! I believe we should move in 2 directions here:
1. try to reduce the memory overhead and policy limits we have today as you are suggesting. Here i would probably prepare the patches and then open directly the PR upstream, but maybe let's wait until next week just to avoid being too pushy. So i would say prepare the patch but don't open it until the next week.
2. proposing a long term solution like we are doing in the issue and working on a local POC so that if they say yes we have something to show. 
WDYT?

---

**Sam Wang** (2025-10-15 18:31):
yeah that sounds like a plan.  The patch for the per-hook override will still take a while, but allowing the policy map limit to be changed should be easy to implement.  I will post my patch here once I get some progress, then we can decide when to create the PR.

---

**Andrea Terzolo** (2025-10-15 18:34):
For point 1, I would say our bigger concerns are:
• the memory used for each policy (~7 MB)
• the limited number of policies
Regarding "the memory used for each policy" i would investigate the following things:
• if with kprobe + sigkill we get rid of the  `override_tasks` map. This would be a great win because today it seems to take 2.6 MB. Moreover with sigkill we don't need the fmod_ret at all so we have also less bpf prog install for each policy
• if we can completely remove `socktrack_map` . This seems to be loaded for each policy but i don't think we use it and it seems to take again ~ 2.8 MB 
• if we can reduce the size of the `policy_map` installed for each policy, today it takes 2.6 MB and has `32768` entries but i believe this is a little bit too much since this maps should just keep the cgroups that match the policy, `32768` seems a huge number for our use case
These are the 3 maps i'm talking about
```// inner map for each loaded policy with pod selectors
721: hash  name policy_1_map  flags 0x0 
 key 8B  value 1B  max_entries 32768  memlock 2624000B
 pids tetragon(63603)

// Still need to check if this is really needed (?)
764: lru_hash  name socktrack_map  flags 0x0
 key 8B  value 16B  max_entries 32000  memlock 2829696B
 btf_id 947
 pids tetragon(63603)

// map used for overriding the return value
766: hash  name override_tasks  flags 0x0
 key 8B  value 4B  max_entries 32768  memlock 2624000B
 btf_id 949
 pids tetragon(63603)```

---

**Andrea Terzolo** (2025-10-15 18:42):
&gt; • if with kprobe + sigkill we get rid of the  `override_tasks` map. This would be a great win because today it seems to take 2.6 MB. Moreover with sigkill we don't need the fmod_ret at all so we have also less bpf prog install for each policy
This is something i don't love but if it can save us some extra memory and less ebpf prog for each policy i would take it. Of course if you believe we can end up with just one fmod_ret and override_task map shared between all policies that would be fine as well, but not sure how easy it is

---

**Sam Wang** (2025-10-15 19:17):
I wasn’t aware that it takes 7mb per policy.  I agree that’s an issue.  

I think the socktrack_map can at least be adjusted, so its size can become 1 when the feature is not used, as Mahé mentioned.  

I have to check policy_map again to see if it can be improved. In our use case we probably don’t use that many.  That’s for sure.  I can find some time to look into it after I finish my active PR and the POC to adjust the 128 limit. 

For the kprobe + sigkill, I thought about it a few days ago and I think there are technical challenges.  

Say we have a parent process A trying to run a child process B, and the process B will be denied and killed.  
• In order to kill the process B, the process B has to be the active task per bpf_send_signal ‘s limitation. 
• To send the kill signal to the process B correctly, we will have to wait until the process B starts, i.e., after a successful execve call from the process A. 
• However, after the process B runs, it can technically avoid any interaction with kernel - this is a common approach for malware to avoid detection in a sandbox.   Then we have no chance to re-evaluate and kill the process B. 
• Of course we can check all syscalls or find some other ways, so the process B can be killed when it interacts with the kernel the first time, but at this point, it has become very inefficient to enforce the policy. 
Not saying that it’s 100% impossible to use kprobe + sigkill to enforce a policy.  Just these are the technical challenges that I can think of so far.

---

**Sam Wang** (2025-10-15 19:22):
There is a new ebpf ~helper~ kfunc exactly for this use case, but unfortunately it’s not there until 6.13: bpf_send_signal_task (https://docs.ebpf.io/linux/kfuncs/bpf_send_signal_task/)

---

**Alessio Biancalana** (2025-10-15 23:10):
For sure we cannot use bpf_send_signal_task, too bad, but nice to know. Maybe as time passes we can revisit it, but not right now, it’s too recent :grimacing:

I welcome every effort of this kind, I’m just afraid this won’t be enough to allow us to scale by a 10x (just making an example) the number of policies we can load. How much are you confident we can optimize keeping a goal like that in mind?

---

**Sam Wang** (2025-10-15 23:14):
yeah I don't know the answer at the moment, because Tetragon blocks us from having more than 38 or 128 policies.  We should have some answers after we can deploy 200 policies for example.

---

**Sam Wang** (2025-10-15 23:20):
My first priority right now is to unblock us - so we have more information about the CPU/memory utilization and other stuffs.  Then we know if there is anything else blocking us - just we haven't discovered them yet.

---

**Sam Wang** (2025-10-15 23:52):
Today I did a change (https://github.com/holyspectral/tetragon/commit/2685245ae56f803946e160d637be3923eb8e0aff) to allow us to have more than the 128 policies limit in Tetragon and I think it works well.  Combined with the previous experimental per hook point fmod_ret change (https://github.com/holyspectral/tetragon/commit/62b4a688d333ead024fba89e68c7480506fcb273), now I can deploy 200 policies on my EKS cluster without problem. I also wrote some scripts (https://github.com/holyspectral/tetragon/tree/experiments/test-scripts) to test the enforcement based on pod label and they all work well.  @Andrea Terzolo @Alessio Biancalana Please take a look and let me know your thoughts.  I also did some performance test.  Will keep the result in :thread:.

Disclaimer:  This doesn't contradict with our current discussion with upstream Tetragon.  This is more like a spike task, so we know if any blockers were not discovered in the previous testing.

---

**Sam Wang** (2025-10-16 00:00):
Latency: the test (https://github.com/holyspectral/tetragon/blob/experiments/test-scripts/test-performance.sh) is designed to run `date` 10k times, so we can see the added latency for a process to spawn.

Latency - no policies:
```real	0m13.436s
user	0m8.815s
sys     0m2.336s```
Latency - 200 policies:
```real	0m14.378s
user	0m9.599s
sys     0m2.483s```
There is 7% slowdown, i.e., 0.0942 ms per each new process, when we have 200 policies.
To be honest I don' think this is too bad.  It would be nice if we can have more real world environment to verify.

---

**Sam Wang** (2025-10-16 00:02):
The memory utilization is more significant.

Memory - no policies:
```# free -h
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       1.2Gi       5.0Gi        60Mi       1.8Gi       6.5Gi
Swap:             0B          0B          0B```
Memory - 200 policies:
```# free -h
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       2.4Gi       3.8Gi        60Mi       1.8Gi       5.2Gi
Swap:             0B          0B          0B```
Basically 6mb per policy, which aligns with @Andrea Terzolo’s finding here (https://suse.slack.com/archives/C09KMBW6DA5/p1760546043218829?thread_ts=1760446958.107449&amp;cid=C09KMBW6DA5).

---

**Andrea Terzolo** (2025-10-16 09:51):
&gt; Say we have a parent process A trying to run a child process B, and the process B will be denied and killed. 
&gt; • In order to kill the process B, the process B has to be the active task per bpf_send_signal ‘s limitation.
&gt; • To send the kill signal to the process B correctly, we will have to wait until the process B starts, i.e., after a successful execve call from the process A.
&gt; • However, after the process B runs, it can technically avoid any interaction with kernel - this is a common approach for malware to avoid detection in a sandbox.  Then we have no chance to re-evaluate and kill the process B.
&gt; • Of course we can check all syscalls or find some other ways, so the process B can be killed when it interacts with the kernel the first time, but at this point, it has become very inefficient to enforce the policy.
Uhm i'm not super sure i understood here.
• Let's say the process A create a child process B with clone/fork syscall.
• Now the process B is running and at a certain point it calls execve syscall
• During the execve flow the process B will face our security hook and should hit `bpf_send_signal` . Process B is the task that is currently running so it should receive the signal.
&gt;  we will have to wait until the process B starts, i.e., after a successful execve call from the process A.
the execve is called by the process B, the usual flow is: Process A forks a new process B and then process B changes execution context with execve

---

**Louis Lotter** (2025-10-16 10:25):
great work Sam. This looks promising. @Mark Bakker do you think customers will be ok with memory usage like this ?
How does this compare with Neuvector applying the equivalent of 200 policies ?

---

**Mark Bakker** (2025-10-16 10:42):
The overhead of 6MB per policy is really high, in general customers expect overheads in the low procent numbers. e.g. 1-3% maybe 3.4, 4.
This obviously depends on the amount of pods and policies, but 6 per policy seams like a lot.
How many policies do we expect per pod?

---

**Mark Bakker** (2025-10-16 10:43):
Can you also test the overhead for other calls e.g. the one's we do not track. e.g. 100x a malloc and free call per spawned process to let the process do something and see the cpu overhead in general. I do expect this to be &lt; 1% in those cases, correct?

---

**Mark Bakker** (2025-10-16 10:44):
So basically test a 'real' process to spawn, do something and than see the overall latency.

---

**Andrea Terzolo** (2025-10-16 10:48):
> How many policies do we expect per pod?
in the current implementation we should have 1 policy for each k8s workload (deployment, daemonset, ...). Today we just have a policy on the binaries a workload can run. Tomorrow we could have more than one policy for each workload because maybe we want to enforce something on files opened or socket opened.
example: with 500 deployments we a have consumption of 3 GB (500*6MB)  on each node

---

**Andrea Terzolo** (2025-10-16 10:52):
> Can you also test the overhead for other calls e.g. the one's we do not track. e.g. 100x a malloc and free call per spawned process to let the process do something and see the cpu overhead in general. I do expect this to be < 1% in those cases, correct?
Yes we don't hook these flows so we have no overhead there. The good thing about this first policy is that we just put overhead when a new process is created, the rest of the execution will be untouched. Again, things could change if we deploy other policies in other places in the future. If we hook a function that is called on the node 2/3 millions times per seconds we will feel the overhead of having 500 ebpf progs there.

---

**Andrea Terzolo** (2025-10-16 10:59):
BTW @Sam Wang I left a comment here https://github.com/holyspectral/tetragon/commit/62b4a688d333ead024fba89e68c7480506fcb273#r168024325

---

**Mark Bakker** (2025-10-16 11:00):
Yeah I know that part of the theory. Would be good to test it, to get real overhead. The 7% does not say anything

---

**Mark Bakker** (2025-10-16 11:00):
3GB overhead on each node will be too much

---

**Mark Bakker** (2025-10-16 11:00):
It should be in the range of 1-150 MB or-so

---

**Bram Schuur** (2025-10-16 14:37):
Hey all, with the risk of surfacing idea that maybe already was discarded, I wanted to share an idea what we could investigate to limit the amount of policies that get applied per node, and improve scalability of the process enforcer that way. Quite simply the idea is: on a node only load those policies which apply to the pods that were scheduled there. If a pod gets removed form the node, remove the policy hooks. I think the details are tricky here, because we would not want to start a pod without having the policies loaded, so we would need to:
• hook into containerd to figure out which pod is being started on a node
• block the actual container startup until we figured out which policies apply and apply them to the kernel
• unblock the pod
• especially the 'blocking part' is tricky, we might have to resort to killing/disallowing anything within the pod up until our policies are loaded as a fallback
I think the main pro of this approach is that the amount of policies loaded is proportional to the amount of pods on a node, not to the amount of workloads/pods in the entire cluster. This scales much better at cluster size.

Is this approach something you considered @Andrea Terzolo @Sam Wang?

---

**Andrea Terzolo** (2025-10-16 14:49):
good point! i believe we discussed this together in the last sync but Sam was not there. The answer IMO is yes, this is another effort in the direction of "making the current implementation scale". As far as i know the kubelet limits the number of pods to 110 or something similar on each node. Unfortunately this parameter can be overwritten so it's not a static fixed value but usually it is not pushed to 500 (at least i hope!). We could still have more than 100 policies (and so 100 ebpf programs) on the same node but at least we shouldn't reach big numbers. This change + some memory optimization could allow us to run this solution in v1.

---

**Andrea Terzolo** (2025-10-16 14:51):
Tetragon already has an hook in the container runtime, so the implementation of this mechanism shouldn't be too complex

---

**Andrea Terzolo** (2025-10-16 14:51):
maybe i should create a GH issue with all these points so that we can keep track of them in a unique place.

---

**Bram Schuur** (2025-10-16 14:54):
That sounds promising actually, with the tetragon hook. Feel free to file this as a possible enhancement on the runtime-enforcement issues indeed

---

**Andrea Terzolo** (2025-10-16 14:56):
yep actually we should double check this is something they are not already doing under the hood. I don't think so but better to double check

---

**Sam Wang** (2025-10-16 14:56):
Thanks for those feedback! Yeah I agree the memory utilization is too high.

Apart from the potential optimization that @Andrea Terzolo mentioned in other thread, I noticed that Tetragon only enables BPF_F_NO_PREALLOC on some of the maps.  

Without this option, the Linux kernel will allocate all the memory used by a map upfront, i.e., #max entries * entry size.

Having said that, it’s mentioned here (https://github.com/torvalds/linux/commit/94dacdbd5d2d) in 5.7 that Linux would block this kind of usage moving forward.  I will revisit and see if there is any change.

---

**Sam Wang** (2025-10-16 15:08):
Here is my quick thoughts:

I think this is a great idea overall.
• Tetragon already has a rthook (https://tetragon.io/docs/installation/runtime-hooks/) that does similar thing to make sure policy is ready before a container starts.  Maybe it’s something we can enhance or build on top.  
• We can add a policy only when a pod matches it.  K8s allows only 200 pods at maximum per node, but generally recommend < 110 pods.  That means 200 pods would be a very reasonable upbound for us to support.  
• If we do this in Tetragon, we can still keep the existing mechanism to get policies from  CRs.
• The only issue that I’m not sure is that Tetragon takes 1 second to load a policy.  By doing this we would get 1 second extra latency *when start a container*.  Maybe it’s fine?  It’s definitely much better than using 6gb memory per node when we have 1000 policies in a cluster.

---

**Sam Wang** (2025-10-16 15:14):
Another thing to check if that rthook also has its own support matrix and the difficulty to deploy.  It would be a good idea to reevaluate our support matrix before we make a decision.

---

**Andrea Terzolo** (2025-10-16 15:14):
&gt; K8s allows only 200 pods at maximum per node
Is this an hard limit documented somewhere? I know there are suggestions to stay under 256 but i didn't know there was an hard limit

&gt; If we do this in Tetragon, we can still keep the existing mechanism to get policies from  CRs.
Yep if we optimize the memory and we limit the number of policies we can probably ship current implementation as a v1. I've still some doubts on the long term solution, if we imagine we hook functions like `security_file_open`, having 200 ebpf prog on it still seems a little bit an overkill but maybe it's not that bad.

---

**Sam Wang** (2025-10-16 15:27):
&gt; Is this an hard limit documented somewhere? I know there are suggestions to stay under 256 but i didn't know there was an hard limit
yeah sorry I misremembered the number.  It should be 256.  It's a limitation due to the IP address that a pod can get, so it's in fact a hard limit at the moment.  We recently got a customer using 200 pods for that setting and that's why I was confused.

(I'll leave other comments later for the standup. )

---

**Andrea Terzolo** (2025-10-16 15:58):
got it. I believe this is not an hard limit as well because probably you can have more pod CIDRs for the same node (i think Cilium CNI supports use cases like this) but yes they should be pretty rare

---

**Sam Wang** (2025-10-16 16:02):
&gt; Cilium CNI supports use cases like this
yeah that's a good point.

---

**Andrea Terzolo** (2025-10-16 16:02):
This is the issue with the summary of all optimizations we though about until now https://github.com/neuvector/runtime-enforcement/issues/227, let me know if i forgot something

---

**Andrea Terzolo** (2025-10-16 16:03):
It is a GH task list so we can create new issues directly from it

---

**Sam Wang** (2025-10-16 16:06):
:thread: BPF_F_NO_PREALLOC to reduce memory utilization

---

**Kyle Dong** (2025-10-16 16:08):
Yeah, I think we can create sub-issues from it.

---

**Kyle Dong** (2025-10-16 16:10):
Since it has higher priority, maybe I can pick 1 item to do some research. If nobody is working on evaluating `socktrack_map` I can investigate it.

---

**Andrea Terzolo** (2025-10-16 16:11):
yep for me sounds perfect :+1:

---

**Sam Wang** (2025-10-16 16:11):
As we're aware, using non-preallocated map in trace program like kprobe, we would get a warning per https://github.com/torvalds/linux/commit/94dacdbd5d2d.

The good news is that this requirement was removed in this commit: https://github.com/torvalds/linux/commit/34dd3bad1a6f1dc7d18ee8dd53f1d31bffd2aee8

The bad news is that this is only available after Linux 6.1.

While this will give us a lot of ease in 6.x kernels, given that we support 5.x, this still doesn't seem like a perfect solution.

---

**Sam Wang** (2025-10-16 16:14):
Technically, the verifier warning is there to prevent memory allocation through `bpf_map_update_elem` helper.  When the memory allocation happens in the wrong context, a deadlock can happen.

I don't believe that the Tetragon design would trigger this easily, given that the maps are all allocated in userspace programs, but unfortunately this is probably not something that we can make sure easily.

---

**Andrea Terzolo** (2025-10-16 16:14):
can you please post here the link to the PRs that need reviews?
if i recall correctly these are the 2:
• https://github.com/neuvector/runtime-enforcement/pull/208
• https://github.com/neuvector/runtime-enforcement/pull/216

---

**Sam Wang** (2025-10-16 16:17):
I think I'll ask in @Andrea Terzolo’s GitHub issue first.

---

**Kyle Dong** (2025-10-16 16:25):
Yes, those are the two PRs that need reviews for @Sam Wang

---

**Sam Wang** (2025-10-16 16:26):
https://github.com/cilium/tetragon/issues/4191#issuecomment-3411177291

---

**Andrea Terzolo** (2025-10-16 16:28):
So if i understand it correctly the warning from kernel 5.7 to 6.1 is kind of wrong for non per-cpu hash maps ?

---

**Sam Wang** (2025-10-16 16:29):
I did spend some time to look into `socktrack_map` but I didn't have much time to post it.  lol
I think the map is not used in our use case and we should be able to scale its size down, using a check like this: https://github.com/cilium/tetragon/blob/94b9cfd5772185fe8c78c5d558e6d01a49f364dd/pkg/sensors/tracing/generickprobe.go#L344

---

**Sam Wang** (2025-10-16 16:34):
I wish so, but apparently they changed the way how ebpf programs allocate memory per here (https://github.com/torvalds/linux/commit/34dd3bad1a6f1dc7d18ee8dd53f1d31bffd2aee8), so it's not prone to a race condition anymore.  In other words, the code seems correct.

On the other hand, I do believe that with Tetragon's use case they won't hit this easily.  In fact, they still specify the `BPF_F_NO_PREALLOC` in some places.

What's in my mind is a new flag attached to the existing TracingPolicy spec, which will guide Tetragon to use `BPF_F_NO_PREALLOC` .  The author of the tracing policy has to make sure that their policy is safe.

---

**Sam Wang** (2025-10-16 16:37):
I hesitated when I saw the original commit adding the warning (https://github.com/torvalds/linux/commit/94dacdbd5d2d) saying that they allow this kind of program to load only for backward compatibility.  Now they remove the constraint in 6.x so this might be a way forward.

---

**Sam Wang** (2025-10-16 16:38):
I can start building a Tetragon with those flags enabled first.

---

**Sam Wang** (2025-10-16 16:45):
These maps would be updated inside ebpf programs, therefore they can't be dynamically allocated until Linux 6.1:
• override_tasks
• socktrack_map
• write_offload
• retprobe_map
• fdinstall_map
• ratelimit_map
• ima_hash_map
• tg_execve_joined_info_map
• execve_map
• tg_errmetrics_map
• tg_cgrps_tracking_map
• tg_cgtracker_map

---

**Sam Wang** (2025-10-16 16:46):
Seems like I just need to enable that on policy map.  :thinking_face:

---

**Andrea Terzolo** (2025-10-16 16:52):
great catch Sam!!
I created a sub-task for this one https://github.com/neuvector/runtime-enforcement/issues/228!
Since this is something that should go upstream as well, what do you think about completing and pushing upstream the ones you are working on before continuing with this one? It's probably better to close something upstream and than going on with others instead of going with many of them in parallel

---

**Andrea Terzolo** (2025-10-16 16:53):
If i recall correctly during standup you said you are working on:
• https://github.com/neuvector/runtime-enforcement/issues/221
• https://github.com/neuvector/runtime-enforcement/issues/222
• and probably something else i'm missing

---

**Andrea Terzolo** (2025-10-16 16:57):
oh i see 222 contains 2 different issues, let me split them, becuase there you ara addressing both the limit and the POC

---

**Sam Wang** (2025-10-16 16:57):
&gt; It's probably better to close something upstream and than going on with others instead of going with many of them in parallel
yeah that's true.  The only reason is that I'd like to discover blockers to make sure nothing is missed at the moment.  The issue#222 still needs some love as it creates a global map, as an experiment.  (sorry haven't got time to respond but I think you've got that during our standup.)

The `BPF_F_NO_PREALLOC` would be the other but I think it can be under the umbrella of issue#228.

---

**Andrea Terzolo** (2025-10-16 16:59):
it seems fair, so are you suggesting to address `BPF_F_NO_PREALLOC` before the poc on fmod_ret?

---

**Andrea Terzolo** (2025-10-16 17:08):
great thanks for the input! i think Kyle you can take it if you have some spare time, it seems a kind of "good first issue" on tetragon :joy:

---

**Sam Wang** (2025-10-16 17:11):
@Andrea Terzolo do you have time to check the support matrix of the existing Tetragon rthook?  I think that would be a nice spike case to know if it would fit our scenario.

---

**Andrea Terzolo** (2025-10-16 17:14):
Sure! i will add it to my backlog! i will try to review your PRs as a next thing.
P.S tomorrow i'm on PTO :vacation-parrot:

---

**Sam Wang** (2025-10-16 17:14):
Fantastic.  Enjoy your day off!

---

**Sam Wang** (2025-10-16 17:23):
yeah I think the POC of `BPF_F_NO_PREALLOC` is a no brainer for me, so I will just create a build and have some tests first.  `fmod_ret` would need 1~2 days for the implementation I believe.

---

**Sam Wang** (2025-10-16 18:18):
```// inner map for each loaded policy with pod selectors
721: hash  name policy_1_map  flags 0x0 
 key 8B  value 1B  max_entries 32768  memlock 2624000B
 pids tetragon(63603)```
@Andrea Terzolo may I know your tetragon tracing policy when you tested?  I use Tetragon 1.5 + EKS, but the memory used in my cluster is much less than yours.  512k vs 2.6m.

```23761: hash  name policy_58_map  flags 0x0
	key 8B  value 1B  max_entries 32768  memlock 524288B
	pids tetragon(348757)```

---

**Andrea Terzolo** (2025-10-16 18:31):
sure i can also provide you with the setup
```kind create cluster
helm install tetragon cilium/tetragon -n kube-system
kubectl apply -f ./policy_1.yaml```
this is `policy_1.yaml`
```apiVersion: cilium.io/v1alpha1 (http://cilium.io/v1alpha1)
kind: TracingPolicy
metadata:
  name: "policy-example-1"
spec:
  podSelector:
    matchLabels:
      app: "client"
  kprobes:
  - call: "security_bprm_creds_for_exec"
    syscall: false
    args:
    - index: 0
      type: "linux_binprm"
    selectors:
    - matchArgs:
      - index: 0
        operator: "Equal"
        values:
        - "/usr/bin/impossible"
      matchActions:
      - action: Override
        argError: -1
  options:
  - name: disable-kprobe-multi
    value: "1"```
i can confirm that on my system it requires a lot of memory
```634: hash  name policy_1_map  flags 0x0
	key 8B  value 1B  max_entries 32768  memlock 2624000B
	pids tetragon(92541)```

---

**Sam Wang** (2025-10-16 18:32):
hmm yeah thanks for confirming.  I'm guessing it might be related to the pinned map because I'm switching with my POC build and v1.5.0.  I will double check.  Thanks!

---

**Andrea Terzolo** (2025-10-16 18:33):
and tetragon version is 1.5.0
```NAME    	NAMESPACE  	REVISION	UPDATED                                 	STATUS  	CHART         	APP VERSION
tetragon	kube-system	1       	2025-10-16 18:21:04.980144047 +0200 CEST	deployed	tetragon-1.5.0	1.5.0 ```

---

**Andrea Terzolo** (2025-10-16 18:33):
it could be! thank you for taking a look!

---

**Sam Wang** (2025-10-16 18:34):
Hopefully `524288B` is the exact benefit from my change but fingers crossed.  :crossed_fingers:

---

**Sam Wang** (2025-10-16 18:50):
hmm it seems like sort of kernel dependencies.  On my EKS 6.1 kernel (amzn2023), it takes only 524288B per map.
```23761: hash  name policy_58_map  flags 0x0
	key 8B  value 1B  max_entries 32768  memlock 524288B
	pids tetragon(348757)```
But on my ubuntu laptop, Tetragon 1.5.0 takes 2.6mb per policy.
```23149: hash  name policy_1_map  flags 0x0
	key 8B  value 1B  max_entries 32768  memlock 2624000B
	pids tetragon(139308)```
With my POC build on my laptop, it takes 525k per policy. :tada:
```27060: hash  name policy_1_map  flags 0x1
	key 8B  value 1B  max_entries 32768  memlock 525696B
	pids tetragon(139894)```

---

**Sam Wang** (2025-10-16 18:51):
I don't see significant improvement on EKS though.  Maybe they have some patches applied to reduce the memory utilization like this.

---

**Sam Wang** (2025-10-16 19:39):
Cross post here: https://suse.slack.com/archives/C09KMBW6DA5/p1760633436364169?thread_ts=1760446958.107449&amp;cid=C09KMBW6DA5

On my ubuntu laptop, Tetragon 1.5.0 takes 2.6mb per policy.
```23149: hash  name policy_1_map  flags 0x0
	key 8B  value 1B  max_entries 32768  memlock 2624000B
	pids tetragon(139308)```
With my POC build on my laptop, it takes 525k per policy. :tada:
```27060: hash  name policy_1_map  flags 0x1
	key 8B  value 1B  max_entries 32768  memlock 525696B
	pids tetragon(139894)```

---

**Sam Wang** (2025-10-17 20:01):
Another thing about the support matrix is arm support.  From what I can see, the eBPF trampoline on arm is introduced (https://github.com/torvalds/linux/commit/efc9909fdce00a827a37609628223cd45bf95d0b) in Linux 6.0.  We might have less support on arm compared to x86 systems.

---

**Kyle Dong** (2025-10-17 20:16):
We can also review what Tetragon support (https://tetragon.io/docs/installation/faq/) as a reference.

---

**Sam Wang** (2025-10-17 21:08):
I've consolidated my findings and created an upstream issue (https://github.com/cilium/tetragon/issues/4204) about the 38 ebpf trampoline limit.  FYI.

---

**Andrea Terzolo** (2025-10-20 11:12):
great job Sam!! :tada:

---

**Sam Wang** (2025-10-20 15:14):
FYI. DockerHub is having an outage (https://www.dockerstatus.com/).

---

**Sam Wang** (2025-10-20 15:22):
oh apparently it's AWS: https://www.cbc.ca/news/world/amazon-web-services-outage-9.6944889

quay.io (http://quay.io) is down too.

---

**Alessio Biancalana** (2025-10-20 15:31):
yeah I had a pipeline failure this morning (my morning, like 10 am), I just retriggered it when the situation looked good and now the CI for the enforcer is good

---

**Alessio Biancalana** (2025-10-21 15:47):
@Sam Wang since it's very close to completion can I ask you to address the comments on https://github.com/neuvector/runtime-enforcement/pull/208 as the first thing? :cry-cat:

---

**Sam Wang** (2025-10-21 15:48):
Sure.  I will do it now.  Sorry for blocking those PRs if any.

---

**Alessio Biancalana** (2025-10-21 15:49):
not yet but I was looking into the codebase and getting my hands a little dirty and I noticed a couple things that could end up in a huge git conflict :smile:

---

**Sam Wang** (2025-10-21 16:19):
Nice.  I know I still owe a kind of deep diving to you and Andrea, but apparently you've got some great progress.  :sweat_smile:  Are you folks available some time later this week?

---

**Alessio Biancalana** (2025-10-21 16:21):
I have time tomorrow if you want, idk about @Andrea Terzolo, thursday and friday I would avoid it because I'll be off on friday and travelling on thursday night

---

**Sam Wang** (2025-10-21 16:25):
hmm I usually use wednesdays as my no-meeting days so I can focus on some stuffs.  Maybe let's find some time early next week?  In the meantime feel free to drop me a message if you're not sure about anything.

---

**Andrea Terzolo** (2025-10-21 16:28):
On my side, I think I more or less got the idea. I don’t have any specific questions, so I wouldn't steal your time

---

**Sam Wang** (2025-10-21 17:06):
Sounds good.  I think I can prepare some material for maybe next Monday.  @Alessio Biancalana @Kyle Dong does it sound like a plan?  @Andrea Terzolo I will add you as optional.  Feel free to skip it if it's not helpful.

---

**Alessio Biancalana** (2025-10-21 17:07):
yes let's go with next monday :green_heart:

---

**Alessio Biancalana** (2025-10-21 17:07):
thank you so much!

---

**Andrea Terzolo** (2025-10-21 17:08):
if you do that i will be there for sure! i didn't want to push some extra work on your shoulders just for me

---

**Kyle Dong** (2025-10-21 17:08):
Next Monday sounds great for me. Thanks @Sam Wang!

---

**Sam Wang** (2025-10-21 17:11):
Ah btw, is you folks' daylight savings ending this weekend?  @Andrea Terzolo @Alessio Biancalana

Our daylight savings ends on Nov. 2, so there might be some disruption in our regular meetings.

---

**Andrea Terzolo** (2025-10-21 17:14):
yes it ends this weekend for us

---

**Sam Wang** (2025-10-21 17:15):
Good to know.  @Kyle Dong so our standup next week will be at 10:30am.  :slightly_smiling_face:

---

**Alessio Biancalana** (2025-10-21 17:35):
PR approved, thanks for bearing with me @Sam Wang :green_heart:  :grimacing:

---

**Sam Wang** (2025-10-21 22:00):
@Andrea Terzolo Thanks for your latest comment (https://github.com/cilium/tetragon/issues/4191#issuecomment-3426660262)! It clarified the details a lot.  While there is still some detail to figure out, now I think it's very feasible.

I like that instead of using `map_idx` to access argument filters like `string_maps_*`, we make these maps `BPF_MAP_TYPE_HASH_OF_MAPS`, so we can can combine `cgroup_id` and `map_index` as its key.  This way we can get the per-cgroup policy easily in ebpf space.

With this, we should be able to get a cgroup id, store it in `msg_generic_kprobe` and bring the cgroupid to argument filters for matching.

This should enable more conversation with upstream.  Great job!

---

**Sam Wang** (2025-10-21 22:04):
I still have some questions that I don't have answers right now.

In the current Tetragon, the filter used by a policy itself is static after assigning to its related maps (except policy_filter_maps). The reloading of policies is actually done via delete &amp; add (https://github.com/cilium/tetragon/blob/ad88ff9eff83bd1372aaa12972f0749643e623ae/pkg/watcher/crdwatcher/tracingpolicy.go#L103).  This actually simplifies the logic a lot.

With our proposal, these argument filters have to be updated in an atomic manner.  For example, when we change a value from this:
```  - matchArgs:
        - index: 0
          operator: NotEqual
          values:
          - /usr/bin/sleep```
to this:
```  - matchArgs:
        - index: 0
          operator: NotPrefix
          values:
          - /usr/bin/```
If not done properly, we might deny/bypass a process unexpectedly.  Not sure if we should resort in a `delete/add` approach, or there is another way.

---

**Sam Wang** (2025-10-21 22:41):
• `policy` is changed =&gt; delete&amp;re-add (the current behavior)
• a container is added or removed =&gt; update the map without delete/re-add (the current behavior)
• `values` are changed =&gt; delete&amp;re-add?
The problem of `delete&amp;re-add` is that we would lose the protection temporarily.  There seems to be still things to be sorted out.

---

**Sam Wang** (2025-10-21 22:42):
My other questions are relatively small:
• We will be making argument filter maps size configurable.  Not sure if upstream would have some concern. 
• Not sure if we would use spinlock but it can't be used with BPF_PROG_TYPE_KPROBE anyway.

---

**Andrea Terzolo** (2025-10-22 09:50):
&gt; • `values` are changed =&gt; delete&amp;re-add?
i would say yes, if i understood correctly today tetragon doesn't allow to modify the values of a tracing policy because once loaded they are hardcoded in memory. So a delete&amp;add is necessary. We should probably do the same, if you we want to modify the value we should remove and add the resource that i called `ForEachWorkloadPolicyValues`
&gt; The problem of `delete&amp;re-add` is that we would lose the protection temporarily 
yep that's true but if you delete&amp;and a tetragon tracing policy today you should obtain the same result
&gt; • We will be making argument filter maps size configurable.  Not sure if upstream would have some concern.
good point. we can also use the maximum size and then BPF_NO_PREALLOC, these maps are only updated by the userspace
&gt; • Not sure if we would use spinlock but it can't be used with BPF_PROG_TYPE_KPROBE
yes unfortunately we cannot use them

---

**Alessio Biancalana** (2025-10-22 12:38):
@Sam Wang @Kyle Dong howdy, sorry for the ping while you are still sleeping (hopefully lol), can I ask a brief explanation about how you convert a policy proposal to an actual policy during the development flow? Do you trigger an event or do you write (and apply) an actual policy out from a policy proposal?

I was trying to get the whole flow working but I didn't see this step in the code, maybe I missed that

---

**Alessio Biancalana** (2025-10-22 14:19):
&gt; The problem of delete&amp;re-add is that we would lose the protection temporarily. 
I agree but at the same time I also agree with Andrea :smile: I'd say we can live with that as a first prototype

---

**Kyle Dong** (2025-10-22 14:32):
@Sam Wang Please correct me if I'm wrong. From my understanding, currently process-enforcer supports user manually review and creates WorkloadSecurityPolicy from WorkloadSecurityPolicyProposal. Reference from the rfc (https://github.com/neuvector/runtime-enforcement/blob/main/docs/rfc/0001-workloadgroup.md#crds)
```WorkloadSecurityPolicy share many fields with WorkloadSecurityPolicyProposal.
WorkloadSecurityPolicy could be created based on a WorkloadSecurityPolicyProposal by the user when they think the system learnt enough of their workload behavior.
On top of that, this CR could also be created directly by the user who has knowledge of what the workload is allowed to do, or other sources.
This is a namespaced resource. We will create a tetragon TracingPolicyNamespaced resource out of that.```

---

**Alessio Biancalana** (2025-10-22 14:46):
thanks for the answer @Kyle Dong, I wanted to create a tiny tool to automate the creation of a WorkloadSecurityPolicy starting from a WorkloadSecurityPolicyProposal just for development's sake :+1: let me know what you think

---

**Kyle Dong** (2025-10-22 15:04):
That sounds a great idea!

---

**Sam Wang** (2025-10-22 16:35):
&gt; yep that's true but if you delete&amp;and a tetragon tracing policy today you should obtain the same result
Just to make sure that the detail is not missed, there is still subtle difference from a product's perspective.
• With the current multiple policies
    ◦ If one of the policies is changed, the ebpf programs and maps associated to that policy will be removed and re-added. 
    ◦ *Only pods associated with that one policy* will be affected.
• With our proposal
    ◦ If any of the policy or values is changed, all ebpf programs and maps will be removed and re-added. 
    ◦ *All pods associated with the policy/values* will be affected.
If we make the description more high-level, that means if we apply policy to a newly added workload by adding a new `value`, the protection for all our protected workload would be gone temporarily.

After thinking a bit more since yesterday, I think the flow like below should help when a policy/value is updated:
1. We evaluate all pods scheduled on the node and the new policy/values to find out what containers/cgroup IDs are affected.
2. We remove the affected cgroup ID from a filter, e.g., `policy_%d_map` , so the policy will not be applied to the container while we're working on it.  
3. After we update all related maps for a given cgroup ID, we add the cgroup ID back to the `policy_%d_map` map.
I don't mean that the progress so far isn't great.  Just trying to brainstorm to see if we can make it better.  :sweat_smile:

---

**Sam Wang** (2025-10-22 16:38):
&gt; I agree but at the same time I also agree with Andrea :smile: I'd say we can live with that as a first prototype
yeah a first prototype is fine with me too.

---

**Alessio Biancalana** (2025-10-22 17:00):
@bin.xu hi, good morning (or evening, depending on the timezone)! I wanted to start having a look at how we manage the project and look into the board, and while I can access the issues I noticed I can't see the github boards we're using. Could you add @Alessio Biancalana, @Andrea Terzolo, @Bram Schuur and @Remco Beckers to the people allowed to see and modify the project boards?

In case you need the github handles:

• Andreagit97
• craffit
• rb3ckers
• dottorblaster

---

**Andrea Terzolo** (2025-10-22 17:02):
&gt; Just trying to brainstorm to see if we can make it better.
Absolutely, thank you for raising these points!

I imagine the proposed solution in a slightly different way.

We first deploy a Tetragon Tracing policy

```apiVersion: cilium.io/v1alpha1 (http://cilium.io/v1alpha1)
kind: TracingPolicy
metadata:
  name: "block-not-allowed-process"
spec:
  kprobes:
  - call: "security_bprm_creds_for_exec"
    syscall: false
    args:
    - index: 0
      type: "linux_binprm"
    selectors:
    - matchArgs:
      - index: 0
        operator: "EqForEachCgroup"
        values: []
      matchActions:
      - action: Override
        argError: -1```
This is kind of a skeleton so it should be never unloaded unless we really want to remove this enforcement from the k8s node.

Then let's say we deploy the policy for one workload

```apiVersion: cilium.io/v1alpha1 (http://cilium.io/v1alpha1)
kind: ForEachWorkloadPolicyValues
metadata:
  name: "block-not-allowed-process-my-deployment-1" 
spec:
  refPolicy: "block-not-allowed-process" 
  selector:
    matchLabels:
      app: "my-deployment-1"
  values: 
    - "/usr/bin/sleep"
    - "/usr/bin/cat"
    - "/usr/bin/my-server-1"```
this should just populate the right ebpf maps with the `values`.
If at a certain point i want change a value in the above policy, i need to:
1. remove just the `ForEachWorkloadPolicyValues` -&gt; the association cgroups:values will be deleted
2. create again the policy with the new values -&gt; a new association cgroups:values is created

---

**Andrea Terzolo** (2025-10-22 17:05):
the kprobe/fmod_ret are never detached, we just change the content of maps

---

**Louis Lotter** (2025-10-22 17:20):
please add me as well

---

**Sam Wang** (2025-10-22 17:33):
> Absolutely, thank you for raising these points!
No problem!

> 1. remove just the `ForEachWorkloadPolicyValues` -> the association cgroups:values will be deleted
yeah if I understand the proposal correctly, the problem is that we might have more than one maps to update in this step.

Here is a simplified example.  Say we have a `ForEachWorkloadPolicyValues` resource like this:

```apiVersion: cilium.io/v1alpha1
kind: ForEachWorkloadPolicyValues
metadata:
  name: "block-not-allowed-process-my-deployment-1" 
...
  values: 
    - "/usr/bin/A"
    - "/usr/bin/B"
    - "/long/path/long/path/executable/C"```
Because the path of `C` executable size exceeds 25,  `C` will be stored in `string_maps_1` and others (A&B) will be stored in `string_maps_0` .

When we remove the associated `cgroups:values` , because the operation to update these two maps is not atomic, it's possible that the ebpf program generated from the TracingPolicy will receive the partial change, e.g.,

```  values: 
    - "/usr/bin/A"
    - "/usr/bin/B"```
or

```  values:
    - "/longlong/longlong/executable/C"```
This can lead to a potential false negative or positive, depending on the operator we use.

BTW I think we will be supporting `NotEqForEachCgroup` and `NotPrefixForEachCgroup` at least?

---

**Sam Wang** (2025-10-22 17:36):
I might be wrong and this might not be an issue, but this is what in my mind.

---

**Andrea Terzolo** (2025-10-22 17:50):
&gt; This can lead to a potential false negative or positive, depending on the operator we use.
This is true, it is the disadvantage of having just one unique ebpf prog attached and manipulating only maps. Actually the current tetragon implementation can suffer of the same issue if they don't detach the ebpf prog before deleting the maps, but i believe they first detach the prog. The biggest issue here is that we could end up blocking a process that shouldn't be blocked, the opposite case is ok IMO since we are deleting the policy in any case so it's possible that in this interval we miss some detections. But i see your point this is probably something we can improve, maybe using just one single map and not 10 for different sizes (this is just an optimization they did but if it causes friction we can also decide to drop it)
&gt; BTW I think we will be supporting `NotEqForEachCgroup` and `NotPrefixForEachCgroup` at least?
Yep ideally every operator could use this `ForEachCgroup` , unfortunately each one seems to require a dedicated implementation :disappointed:

---

**bin.xu** (2025-10-22 17:53):
Sure, invitation sent.

---

**Sam Wang** (2025-10-22 18:00):
> This is true, it is the disadvantage of having just one unique ebpf prog attached and manipulating only maps.
After figuring out a possible solution above (https://suse.slack.com/archives/C09KMBW6DA5/p1761143728989099?thread_ts=1761076806.171389&cid=C09KMBW6DA5), I actually think this is not that bad.  At least it doesn't seem like a limitation and we should be able to get around it.

> Yep ideally every operator could use this `ForEachCgroup` , unfortunately each one seems to require a dedicated implementation :disappointed:
I actually start feeling that having another CRD instead of `TracingPolicy` like your original proposal is probably not a bad idea. At least we can control what we support/not support, so we don't get overwhelmed by the existing feature combination.  Say, what if a `EqForEachCgroup` is combined with `Equal` operator.

---

**Sam Wang** (2025-10-22 18:05):
Another thing just came to my mind:  :question: Would the new policy be namespace-scoped or not? If we want to support namespece-scoped one, we will still need https://github.com/cilium/tetragon/issues/4204, otherwise we can't support more than 38 namespaces.

---

**Andrea Terzolo** (2025-10-22 18:15):
&gt; I actually start feeling that having another CRD instead of `TracingPolicy` like your original proposal is probably not a bad idea.
I agree. The support matrix here is pretty big... i'm curious to receive some feedback from the tetragon team on this, at the moment i'm most focusing on a raw implementation just to see if it is even possible to use this approach
&gt; Would the new policy be namespace-scoped or not?
i would say no for now, the pod/container selector should provide enough flexibility. Moreover we can introduce the possiblity to select also by namespace, but just using one unique policy, something like a `namespaceSelector`

---

**Alessio Biancalana** (2025-10-22 18:20):
Strange, I don't have any invitation in my inbox and I still can't see the projects :disappointed:

---

**Sam Wang** (2025-10-22 18:24):
> i would say no for now, the pod/container selector should provide enough flexibility. Moreover we can introduce the possiblity to select also by namespace, but just using one unique policy, something like a `namespaceSelector`
In our current implementation we create policy proposal in the same namespace with workload, users then convert them into `TracingPolicyNamespaced` , so they're namespace-scoped by default.

I'd prefer having a parameter in `values` CR first (of course, optional for prototype), like below.  `namespaceSelector` is great, but perhaps it can be later.

```apiVersion: cilium.io/v1alpha1
kind: ForEachWorkloadPolicyValues
metadata:
  name: "block-not-allowed-process-my-deployment-1" 
spec:
  refPolicy: "block-not-allowed-process" 
  namespace: xxx
  selector:
    matchLabels:
      app: "my-deployment-1"
  values: 
...```

---

**Sam Wang** (2025-10-22 18:30):
This is not hurried though.  We can discuss this later.  More like UX things.

---

**bin.xu** (2025-10-22 18:30):
@Alessio Biancalana you are already in the team, I have assigned you guys maintain role, let me check if i need change anything else.

---

**Andrea Terzolo** (2025-10-22 18:33):
yep it shouldn't be an issue, but yes probably it is something we can discuss better later

---

**bin.xu** (2025-10-22 18:43):
@Alessio Biancalana @Andrea Terzolo I just added you two in the project, please check if can do it now, I will add the others after you accept the invitation.

---

**Andrea Terzolo** (2025-10-22 18:51):
i can now see the project called "runtime enforcement"! thank you!

---

**bin.xu** (2025-10-22 18:59):
You are welcome :grinning:

---

**Alessio Biancalana** (2025-10-22 19:37):
perfect, me too! Thank you so much :green_heart:

---

**Davide Iori** (2025-10-23 12:55):
Hi team. We have a called planned in an hour from now.
Agenda:
• quick recap on the last session presentation
• overview and comparison of how different tools let users define runtime security policies
• open discussion on the above
So, the idea is to get your feedback/comments on what's being shown during the call, understand what are the functionalities we can implement for the MVP and what we should instead push to a later phase.
Let's make it a collaborative call.

See you in a bit

---

**Kyle Dong** (2025-10-23 14:55):
Opps, so sorry for the late! I had a hospital appointment last night, and I didn't wake up earlier this morning:sweat:

---

**Alessio Biancalana** (2025-10-23 14:59):
no worries!

---

**Sam Wang** (2025-10-23 15:13):
Hi team, I summarize the current scalability issues to make sure everyone is on the same page.  Please let me know if anything is missed:

1. 38 limit on protect rules from BPF_MAX_TRAMP_LINKS
    ◦ @Sam Wang is working on an official fix.
    ◦ A POC works to get rid of the limit as long as they're hooked on the same hook point.
    ◦ An upstream issue is created tetragon#4204.
    ◦ upstream is good about the direction. 
2. 128 policy limit
    ◦ @Kyle Dong is working on this.
    ◦ A POC shows that we can scale the size using a command line argument. 
    ◦ no upstream issue is created yet.
3. memory utilization - policy_%d_maps
    ◦ @Kyle Dong is working on this.
    ◦ POC shows that we can optimize the memory utilization using BPF_F_NO_PREALLOC.
    ◦ upstream said BPF_F_NO_PREALLOC is the last resort in tetragon#4191. Other option would include a command line argument. 
4. ~memory utilization - socktrack_maps~
    ◦ Merged in tetragon#4211.
5. memory utilization - override_maps
    ◦ Will be fixed along with issue#1.
6. one ebpf program attachment per-policy
    ◦ Discussing in tetragon#4191 and upstream agreed with the direction.
    ◦ More like a long-term solution.
    ◦ @Andrea Terzolo  is working on a prototype.

---

**Kyle Dong** (2025-10-23 15:15):
:tada: Exciting news — my first upstream PR to *Tetragon* has been merged today! I think it is included into v1.7.0
:point_right: https://github.com/cilium/tetragon/pull/4211
This change will reduce memory footprint of unused `socktrack_map` about `~ 2.8` MB per policy.
Thanks @Andrea Terzolo and @Sam Wang for the support and discussions.

---

**Alessio Biancalana** (2025-10-23 15:16):
thank you so much! Could you also link the corresponding github issues?

---

**Alessio Biancalana** (2025-10-23 15:17):
congratulations man! Always good to see some upstream love :green_heart:

---

**Andrea Terzolo** (2025-10-23 15:19):
https://github.com/neuvector/runtime-enforcement/issues/227

---

**Kyle Dong** (2025-10-23 15:20):
I'm investigating issue #3, `memory utilization - policy_%d_maps`. I'm also checking if we can use use dynamic map size when initialize the inner policy map. I'm working on the POC

---

**Sam Wang** (2025-10-23 15:22):
Congratulation! It's kind of sad that my PR is still there not merged.  :smiling_face_with_tear:

---

**Andrea Terzolo** (2025-10-23 15:22):
great job Kyle!

---

**Sam Wang** (2025-10-23 15:24):
@Kyle Dong I'll update the above accordingly.

---

**Louis Lotter** (2025-10-23 15:24):
Great work.

---

**Alessio Biancalana** (2025-10-23 15:25):
@Sam Wang I'm working on the board to keep it tidy, thanks for the help

---

**Sam Wang** (2025-10-23 15:25):
@Kyle Dong if you want to change the map size, my POC code might help: https://github.com/holyspectral/tetragon/commit/2685245ae56f803946e160d637be3923eb8e0aff

It's not specific for `policy_%d_maps` but I think it's pretty much the same.

---

**Kyle Dong** (2025-10-23 15:30):
@Sam Wang, I think it's more likely relates to issue #2. When I do the investigation, I realized the issue #2 and #3 are more or less related. I can work both of them if you're ok with it. The most important thing is to discuss with upstream:wink:

---

**Bram Schuur** (2025-10-23 15:32):
could you also add me to the project?

---

**Sam Wang** (2025-10-23 16:44):
&gt;&gt;  we will have to wait until the process B starts, i.e., after a successful execve call from the process A.
&gt; the execve is called by the process B, the usual flow is: Process A forks a new process B and then process B changes execution context with execve
Ahh I missed your message.  Just realized 5 minutes ago when I'm checking https://github.com/neuvector/runtime-enforcement/issues/227.

Yes, you're right.  I misunderstood the current task when `execve()` runs and then `sigkill` should kill the right process.  I'm not sure if there is a corner case from userspace program, but this should work.

---

**Sam Wang** (2025-10-23 16:48):
There is some limitation (https://www.elastic.co/security-labs/signaling-from-within-how-ebpf-interacts-with-signals) when we use it for file, but for process I don't think we have an issue.

---

**Sam Wang** (2025-10-23 17:31):
https://github.com/neuvector/runtime-enforcement/issues/232 is about only installing ebpf programs when a matching pod is running.  Is this still a direction that we will pursue?

---

**Alessio Biancalana** (2025-10-24 01:33):
Yes it is but if we have other things in progress feel free to finalize those and only then start looking into this :+1:

---

**Sam Wang** (2025-10-24 15:13):
I was waiting for upstream's feedback yesterday, so I got some time to look into this.  Directly jump into conclusions:
• Many platforms are not supported by Tetragon's rthook.
    ◦ For example, my EKS is still using containerd 1.7 (LTS), where NRI is not available. 
    ◦ Containerd 1.7 is not EOL until mid-2026. 
    ◦ Tetragon's rthook *might* still support this, but this is not the default setup and will need more time to investigate.  It's possible that users need to customize their container environment to some degree.
• There is a `pods/binding`sub-resource that we can see in a admission webhook
    ◦ This event happens when a pod is scheduled to a node.  See here (https://release-1-13-0.kyverno.io/blog/2024/02/19/assigning-node-metadata-to-pods/) for more detail. 
    ◦ Theoretically, with this, we can:
        i. See a pod is scheduled to a node.  (The node assignment will not change in a pod's lifecycle. )
        ii. Prepare the policy before the pod runs.
I will spend more time looking into this.

---

**Sam Wang** (2025-10-24 15:16):
Thanks.  I did spend some time to have a quick look: https://suse.slack.com/archives/C09KMBW6DA5/p1761311604768989?thread_ts=1760618277.439849&amp;cid=C09KMBW6DA5

---

**Andrea Terzolo** (2025-10-27 12:33):
thank you for the research! my 2 cents on this:
1. i believe we can do something with k8s API. They already have a lot of logic to manage policy updates when pods are created/deleted that seems to use k8s API if the runtime hook is available https://github.com/cilium/tetragon/blob/2d2eac242cf96b99c44e66e5a930ea777619708a/pkg/policyfilter/state.go#L691. BTW for what i can see the patch is far from being easy. I'm looking into the policy loading for the POC i'm doing and i can say that today there is no a method to receive a policy definition inside the agent and wait for the first pod that matches that policy before deploying it. From here my second point below.
2. i would leave this optimization as the last one since it is probably the most complex and would require more changes inside tetragon. Moreover by the end of the week i hope to push some code upstream with our possible POC on the per-policy workload. If they decide the approach is valid and we can proceed with the patch probably we don't need this optimization at all. On the other side if the per-policy POC is not considered valid we can reconsider this optimization as a workaround. In any case i would wait to implement this until we don't receive some feedback on the POC

---

**Andrea Terzolo** (2025-10-27 12:45):
I also added a comment on the optimization issue https://github.com/neuvector/runtime-enforcement/issues/227#issuecomment-3450866158

---

**Bram Schuur** (2025-10-27 13:50):
I've not had an invite to the project, could someone include me there? (@bin.xu @Alessio Biancalana?)

---

**Sam Wang** (2025-10-27 15:23):
&gt; BTW for what i can see the patch is far from being easy. I'm looking into the policy loading for the POC i'm doing and i can say that today there is no a method to receive a policy definition inside the agent and wait for the first pod that matches that policy before deploying it.
yes it's true that Tetragon doesn't have an existing logic to wait for the policy definition.  This is done by rthook.

If we're going to implement this using `pods/binding`, we will probably need to go through another way.  Tetragon's gRPC API provides a few methods to control TracingPolicy without using CRs.  That means we can control them via our daemon pods.  I did some experiments last week around this and it's possible to add a matching policy when a pod is binding to a node.

Having said that, it's a significant change.  There is also some concern/uncertainty from my side:
• `pods/binding` is a little dangerous.  Even if we make it fail open, it would still make the pod scheduling slow if there is an issue. 
• In order to send the policy down to a pod running on a specific node, we will still have to discover these pods.  This is not an easy job too.

---

**Alessio Biancalana** (2025-10-27 16:55):
@Sam Wang I noticed the CI is red on this PR you made on tetragon, it would be great if it could get merged, could you prioritize getting it green plus addressing the feedbacks? :green_heart:

By merging this we would get rid of two tickets on our side since we wouldn't need https://github.com/neuvector/runtime-enforcement/issues/231 anymore :D

https://github.com/cilium/tetragon/pull/4244

---

**Alessio Biancalana** (2025-10-27 16:56):
feel free to yell at me if you were already doing this

---

**Sam Wang** (2025-10-27 17:49):
&gt; https://github.com/cilium/tetragon/pull/4244
They're expected to be red because it's still WIP.  There is still some discussion ongoing with upstream about the scope of PR, like this one: https://github.com/cilium/tetragon/pull/4244#discussion_r2460645467

---

**Sam Wang** (2025-10-27 17:55):
TL;DR it's waiting for upstream right now.

---

**Sam Wang** (2025-10-28 01:41):
ok I got feedback from upstream now, so I can work on it tomorrow.

---

**Davide Iori** (2025-10-28 11:29):
Hi guys, a clarification. When we synced you mentioned the concept of policies attached to workloads. What is a workload? Are you referring to k8s objects or to something else? Thanks

---

**Alessio Biancalana** (2025-10-28 11:44):
usually kubernetes pods, but I'm open to further clarification :smile:

---

**Alessio Biancalana** (2025-10-28 11:46):
right now we implemented learning mode for deployments, daemonsets, statefulsets, replicasets and jobs, cronjobs will come in the future

---

**Davide Iori** (2025-10-28 11:51):
Ok thanks! no need for further clarifications for now :slightly_smiling_face:

---

**Flavio Castelli** (2025-10-28 13:36):
yes, but pods are the lowest building block of a workload. We will target the highest resource, which means: Deployment, StatefulSet, DaemonSet, CronJob

---

**Flavio Castelli** (2025-10-28 13:37):
some of them are implemented by intermediate objects, for example:
Deployment -&gt; ReplicaSet -&gt; Pod

In this case we will create a policy for the Deployment (which is what the user defined), and the policy will then target all the pods created by the Deployment

---

**Flavio Castelli** (2025-10-28 13:38):
if someone runs a pod "naked" we will target that one, but this is something not common

---

**Alessio Biancalana** (2025-10-28 18:31):
@Sam Wang congrats on getting https://github.com/cilium/tetragon/pull/4158 merged! :fire: :partying_face: :fire:

---

**Alessio Biancalana** (2025-10-30 11:56):
I will be missing the standup today because I have a conference I have to deliver a presentation to, @Andrea Terzolo will be running the meeting on my behalf :green_heart:

---

**Andrea Terzolo** (2025-10-30 15:17):
This is the POC https://github.com/cilium/tetragon/compare/main...Andreagit97:tetragon:POC3?expand=1 i would like to propose upstream.
It shows a possible way to implement what we need, but mainly it demonstrates that it’s feasible without too much complexity.
I haven't defined any new CRDs for now; I've just used what was already there in a hacky way, let's see what they suggest.
Moreover, the POC doesn’t support all the operations on tracing policies that Tetragon supports today (list, disable, enable, addSensor, etc.), but only add/delete.
In the commit, you can find a README.md if you want to try it. Please be cautious, I’ve only tried it a couple of times, so there could be bugs (or rather, there definitely are some bugs :joy:).

---

**Sam Wang** (2025-10-30 16:29):
I think it looks neat.  Thanks for putting these together!  I like having new maps instead because it does reduce the change scope compared to changing the existing map type.  Hopefully I didn't misread or anything.  :sweat_smile:  Some thoughts:
1. Instead of having new CRD, in the POC we use policy option.
    a. I think this is fine.  We can discuss the ideal schema with upstream as the next step.
2. I didn't see where multiple pod selectors are merged together.  Did I miss it?

---

**Sam Wang** (2025-10-30 16:33):
@Kyle Dong regarding the questions.yaml, there is a case (https://github.com/neuvector/runtime-enforcement/issues/256) created already. FYI.

---

**Andrea Terzolo** (2025-10-30 16:41):
> I think this is fine.  We can discuss the ideal schema with upstream as the next step.
Yeah that's the idea, i believe a more stable approach would be to use dedicated CRDs, but i didn't want to add too much code in the POC and i would like also some input from them on how to craft these CRDs
> I didn't see where multiple pod selectors are merged together.  Did I miss it?
do you mean when in the same policy we specify multiple podSelectos? if this is the case, it should be handled by the exisisting tetragon code https://github.com/cilium/tetragon/blob/7f09bfd2ca0123867bc7c2ab0155ac8efbc29ede/pkg/labels/labels.go#L70

---

**Sam Wang** (2025-10-30 17:05):
&gt; do you mean when in the same policy we specify multiple podSelectos? if this is the case, it should be handled by the exisisting tetragon code
hmm I think it's slightly different.  The existing code handles label selector in one policy, (BTW the Tetragon's implementation was probably inspired by k8s (https://github.com/kubernetes/apimachinery/blob/b72d93d174332f952a8d431419fece5e6f044bcb/pkg/apis/meta/v1/helpers.go#L36). ), but does not handle the case where multiple binding policies have different pod selectors.

Say we have binding policies like below:
• Binding Policy A with a path `/usr/bin/A` and a `app: A` selector.
• Binding Policy B with a path `/usr/bin/B` and a `application: B` selector.
I thought that I would see a map containing cgroup IDs and merged paths.

For example, for these three different pods
• alpha: `app: A`
• beta: `application: B`
• gamma: `app: A; application: B` 
we would get a map like this:
```The cgid of alpha =&gt; /usr/bin/A
The cgid of beta =&gt; /usr/bin/B
The cgid of gamma =&gt; /usr/bin/A + /usr/bin/B```
Maybe the existing code has handled `alpha` and `beta` ?  Not sure.

---

**Andrea Terzolo** (2025-10-30 17:21):
oh i got it thanks for the example! Well yes the answer is that overlapping is not allowed, and i think this is inline with our model if i don't miss anything.
We define a template like
```  kprobes:
  - call: "security_bprm_creds_for_exec"
    syscall: false
    args:
    - index: 0
      type: "linux_binprm"
    selectors:
    - matchArgs:
      - index: 0
        operator: "Equal"
        values:
        - "*"```
and each workload should specify its own values.
In a usecase like this "gamma: `app: A; application: B` " we are no more writing policies for each workload but we are grouping different applications... i mean this is fine and possible but at that point the policy should be only one that includes both workloads we shouldn't have also specific policies for each application, or am i missing something?

---

**Andrea Terzolo** (2025-10-30 17:23):
the idea is that for each cgroup there should be only one policy binding for a specific template. If there are multiple bindings the last one overwrite the previous one

---

**Sam Wang** (2025-10-30 17:33):
Ah I see.  What I was saying was the way a k8s pod selector would work.  If we want to do it that way, i.e., workload-based policy, I think we may need a different selector, e.g., workloadSelector.

There is a utility function, GetWorkloadMetaFromPod() (https://github.com/cilium/tetragon/blob/657f19eb85569de48314875d3e0f9f63d81ecc90/pkg/podhelpers/workload.go#L23), in Tetragon that you can use to get `Workload` from a pod.  It will be super cool if we can do that in Tetragon level.

cc: @Flavio Castelli as more discussion is going on.

---

**Sam Wang** (2025-10-31 15:33):
Trying to summarize my thoughts:
• I think the change is pretty good and it should work with our usage.  I'm just not fully sure whether upstream would be against it due to it's different from kubernetes and Tetragon's behavior.  Tetragon upstream might not like it per this comment (https://github.com/cilium/tetragon/issues/4191#issuecomment-3415576691).  We might need a different syntax to implement it, e.g., `workloadSelector`, if that's what we want.
• Besides, the assumption that each pod selector in binding policies is mutual exclusive is a little like an application logic.  Not sure if Tetragon would accept it.  
• A quick comparison between approaches that we can think of.  I think they're all out of our support scope, but it might still be something upstream cares about:
    ◦ POC
        ▪︎ The override action is triggered when the last policy is not matched.
        ▪︎ If we use the example above (https://suse.slack.com/archives/C09KMBW6DA5/p1761840333956289?thread_ts=1761833872.968199&amp;cid=C09KMBW6DA5), one of A or B in pod gamma will be *denied*, depending on policy order. 
    ◦ OR
        ▪︎ This is the current Tetragon's behavior with multiple policies where different pod selectors and arg selectors are specified. 
        ▪︎ The override action is triggered when `(Not(PolicyA) OR Not(PolicyB) OR Not(PolicyC))` is true. 
        ▪︎ If we use the example above (https://suse.slack.com/archives/C09KMBW6DA5/p1761840333956289?thread_ts=1761833872.968199&amp;cid=C09KMBW6DA5), the A&amp;B in pod gamma will *both be denied*.  
    ◦ Union
        ▪︎ More like KubeArmor's behavior.  
        ▪︎ The override action is triggered when `Not(PolicyA U PolicyB U PolicyC)` is true. 
        ▪︎ If we use the example above (https://suse.slack.com/archives/C09KMBW6DA5/p1761840333956289?thread_ts=1761833872.968199&amp;cid=C09KMBW6DA5), the A&amp;B in pod gamma will *both be allowed*.
@Andrea Terzolo please let me know if it makes sense.  I don't think we have to wait if you want to get feedback from upstream first, but we probably have to consider this before we create a formal PR.

---

**Andrea Terzolo** (2025-10-31 16:19):
I have to admit that i'm still a little bit confused by the reason why we should have more than one policy-binding for one cgroup.
Let's try to make a concrete example.
Taken from your example here https://suse.slack.com/archives/C09KMBW6DA5/p1761840333956289?thread_ts=1761833872.968199&amp;cid=C09KMBW6DA5

```policy-binding-1 -&gt; podA -&gt;  /usr/bin/A
policy-binding-2 -&gt; podB -&gt; /usr/bin/B
policy-binding-3 -&gt; (podA &amp;&amp; podB) -&gt; /usr/bin/A + /usr/bin/B```
I would argue that `policy-binding-3` is overriding the other 2 policies, extending them, so i'm not sure why we need `policy-binding-1` and `policy-binding-2` in the first place.
Can you help me with a concrete example where this overlap between policy-bindings is really needed?

---

**Sam Wang** (2025-10-31 17:01):
Sorry for the confusion.  I mean, you're absolutely right that this implementation will work with our use case given our pod selectors will be mutual-exclusive.  Even if we have new requirements, we can still let users to merge different securityPolicy CR or binding policies together, like you mentioned.

My point is more about the fact that kubernetes users expect a pod could be matched by multiple pod selectors.  This is just how kubernetes works.

---

**Sam Wang** (2025-10-31 17:20):
Given that we don't want a pod to match multiple binding policies, that's why I was wondering if we can define a new selector called `workloadSelector` , so we can customize this selector's behavior as we like.

```apiVersion: cilium.io/v1alpha1 (http://cilium.io/v1alpha1)
kind: TracingPolicy
metadata:
  name: "block-process-template-values-1"
spec:
  workloadSelector:
    kind: Deployment
    name: "my-deployment-1"
  options:
  - name: binding
    value: "targetExecPaths"
  - name: values
    value: "/usr/bin/nmap"
  - name: policy-template-ref
    value: "block-process-template"```

---

**Andrea Terzolo** (2025-10-31 17:30):
ah ok, yes, having something different from the standard podSelector could be an idea. Considering we want to support also containerSelectors https://github.com/neuvector/runtime-enforcement/issues/260 not sure what is right abstraction at the moment, but yes we can define something new if we believe that podSelectors could be misleading for the users

---

**Sam Wang** (2025-10-31 17:35):
Exactly.  Or we define new selectors solely used by the policy template it points to.  This really falls into upstream's discretion so it's hard to tell at this moment.

---

**Sam Wang** (2025-10-31 17:38):
I like the idea of `workloadSelector` because Tetragon already emits this kind of information in its event.  With this it will be much easier to setup a policy for a specific workload without having to check if there is overlap in labels.  (For Tetragon users)

---

**Alessio Biancalana** (2025-11-03 17:29):
@Sam Wang I need a moment of sparring partnership, when adding a condition to inspect the labels and prevent the policy proposal from being updated with new processes, would you add the condition in the `AddProcess` function or inside the reconciler directly? I just wanted to have it tested in a unit fashion :smile:

---

**Alessio Biancalana** (2025-11-03 17:41):
I pushed a commit with this implementation, if it works well for you I can write a test and finalize it tomorrow

---

**Sam Wang** (2025-11-03 19:45):
Thanks for looking into this.  I think this is a design preference that doesn't always have an  answer.  My preference for this is to add the logic in the reconciler, so we make the `AddProcess` a utility function that doesn't change its behavior depend on external factor.  Does it make sense to you?

For the testing, I think you can find some examples about how to test a reconciler here (https://github.com/neuvector/runtime-enforcement/blob/13920cf76194bdf6a398a1dee537bc9b78f64082/internal/controller/workloadsecuritypolicy_controller_test.go#L85).  If it doesn't work well, we can discuss.

---

**Alessio Biancalana** (2025-11-03 19:54):
I think it will work very well, thank you so much! Of course I already started implementing... the wrong one LOL

---

**Sam Wang** (2025-11-03 20:16):
Sorry for the inconvenience.  I really have to clean up my slack channels a bit so I can see the message in time...

---

**Alessio Biancalana** (2025-11-03 22:39):
Hahah no worries man

---

**Andrea Terzolo** (2025-11-05 12:44):
ei guys, one question about our tilt setup. When i do a change in let's say the daemon, what is the correct way to tell tilt to update the image? what i'm doing at the moment is to delete the previous binary and run `make daemon` but probably there is a better way to do that

---

**Andrea Terzolo** (2025-11-05 12:53):
Moreover this https://github.com/neuvector/runtime-enforcement/pull/266 should be ready for review when you have time

---

**Alessio Biancalana** (2025-11-05 13:05):
when I develop on the operator usually it works with the live reload, but let me look more into this

---

**Sam Wang** (2025-11-05 16:52):
hmm yes it usually gets reloaded automatically.  Some possibilities:
• The file list defined in Tiltfile (https://github.com/neuvector/runtime-enforcement/blob/b9bf9f33a1e382f45890d0833120265cabcc8c68/Tiltfile#L107) is out of date.
• The security profile of the container prevents the live-reload.  There was an issue in the early stage of the project but I supposed it's already fixed via overriding the helm overrides (https://github.com/neuvector/runtime-enforcement/blob/b9bf9f33a1e382f45890d0833120265cabcc8c68/Tiltfile#L48). If it happens again you should see something in daemon's container logs.

---

**Andrea Terzolo** (2025-11-05 17:51):
uhm thank you all! let me check if there is something in the logs

---

**Sam Wang** (2025-11-05 18:01):
This is the normal message that I got when I change `internal/tetragon` .  FYI.
```Will copy 1 file(s) to container: [runtime-enforcement-daemon-dcr7h/daemon]
- '/home/sam/Developments/neuvector/runtime-enforcement/bin/daemon' --&gt; '/daemon'
...
[CMD 1/1] sh -c date &gt; /tmp/.restart-proc
  → Container runtime-enforcement-daemon-dcr7h/daemon updated!```

---

**Andrea Terzolo** (2025-11-05 18:09):
oh i see, i don't have any logs from tilt

---

**Sam Wang** (2025-11-05 18:22):
Are your containers running?  That's the only thing I can think of.

---

**Andrea Terzolo** (2025-11-05 18:30):
yep, if i remove the daemon binary from the `bin` folder and create a new one, tilt works correctly... BTW since this is an issue with my setup i won't bother you with this, just wanted to be sure this is something that happens only to me

---

**Sam Wang** (2025-11-05 18:38):
no problem at all.  It sounds like a permission thing maybe?

---

**Kyle Dong** (2025-11-05 19:23):
I got no update with tilt once few days ago, which I have to rebuild daemon like you did. I couldn't find any log updated in tile. even `tilt down/tilt up` won't fix it. I finally recreated my kind cluster to get it fixed...

---

**Kyle Dong** (2025-11-05 20:47):
Hi @Flavio Castelli, @Alessio Biancalana, @Sam Wang, and @Andrea Terzolo I'm starting to look into this issue (https://github.com/neuvector/runtime-enforcement/issues/264).
Since a standalone Pod doesn’t have a `spec.selector` or any higher-level resource to associate with, it’s not straightforward to manage it in the same way as controller-managed workloads.
If we want to introduce a mutating admission controller to inject labels for such Pods, we have to ensure no label conflicts and keep the labels synchronized with our policy engine. We also need to handle Pods that restart, re-label, etc. This approach would easily increase the operational and design complexity.
Given that, I'm thinking if we want to simply skip standalone Pods and suppress the error for now. Please share your thoughts. Thanks.

---

**Sam Wang** (2025-11-05 20:50):
I think I agree with you. I also left my comments in the issue: https://github.com/neuvector/runtime-enforcement/issues/264#issuecomment-3493039165

---

**Alessio Biancalana** (2025-11-05 21:25):
I’d just say let’s ignore the Pods for now, suppress the error, and try to figure out if we wanna add that as a feature in the future. Thanks for looking into this

---

**Andrea Terzolo** (2025-11-06 11:11):
Agreed, IMO we can skip them for now

---

**Andrea Terzolo** (2025-11-06 16:47):
Hey guys! I was thinking about the use case in which we need to update an existing `WorkloadSecurityPolicy` to add/remove executables from the allowed list. So we are for example in monitor mode, we see a new process and we want to add it to the allowed list.
If i get it right, the flow should be the following (from the Tetragon perspective):

- Delete the existing `TracingPolicyNamespaced`.
- Create a new `TracingPolicyNamespaced` with the updated allowed list (adding/removing the executable).

An alternative flow could be:

- Create a new `TracingPolicyNamespaced` with the updated allowed list (adding/removing the executable). This policy should have the same podSelector of the existing one and actually a different name (because names must be unique in the namespace, not sure how to call it).
- Delete the old `TracingPolicyNamespaced`.

The second flow could avoid a small downtime in which no policy is applied to the workload, but I'm not sure how to handle the naming of the policies in this case. Actually having 2 policies with the same podSelector should be fine from the Tetragon point of view.

I've look into the Tetragon codebase but I didn't find anything related to this specific use case. Maybe is there a way to update an existing `TracingPolicyNamespaced` instead of deleting/creating a new one?

WDYT?

---

**Flavio Castelli** (2025-11-06 17:09):
I would prefer to go for a flow where we don't leave open gaps.

Keep in mind that the name of the TetragonPolicy is something that is managed by us, it doesn't have to be nice for the user.

We could even use a name that has the `.metadata.revision` of our parent object (the `WorkloadSecurityPolicy` ).

We could have:
• WorkloadSecurityPolicy gen 1 -&gt; Tracing policy named `foo-policy-g1`
• WorkloadSecurityPolicy gen 2 -&gt; `foo-policy-g1` AND `foo-policy-g2`, after some time we delete `foo-policy-g1`
What do you think?

---

**Andrea Terzolo** (2025-11-06 17:20):
yep i would do the same. I just want to be sure i'm not missing something trivial that could allow us to keep the same Tetragon policy, but i don't think so :confused:

---

**Sam Wang** (2025-11-06 17:51):
yeah I think having two policies would work to some degree, but to fix this properly we may need to dig into Tetragon.

One problem that I can see is that, it's an eventually-consistent/asynchronous flow for a `TracingPolicyNamespaced` to be applied and takes effect.  That means, while we can create two policies, we don't really know if the new one already takes effect.

Some options that I can think of:

• Tetragon should at least update the status of the `TracingPolicyNamespaced` CR.  
• Or we do this logic in Tetragon level.

---

**Sam Wang** (2025-11-06 18:02):
&gt; Tetragon should at least update the status of the `TracingPolicyNamespaced` CR. 
I think this is a valid use case for Tetragon, because currently there is no way for CR users to know if anything is wrong, except digging into Tetragon's logs.

---

**Sam Wang** (2025-11-06 18:08):
@Andrea Terzolo do you think it makes sense to create an issue to track these discussion?

---

**Andrea Terzolo** (2025-11-06 18:08):
do you mean an upstream issue or an issue in our repo?

---

**Sam Wang** (2025-11-06 18:09):
Sorry I mean an issue in our repo.  Then we can discuss if we want to create an upstream issue later.

---

**Andrea Terzolo** (2025-11-06 18:09):
i would say yes, this is probably something we need to support for the MVP since this is how the monitor mode should work when we face a new process

---

**Sam Wang** (2025-11-06 18:17):
yeah I mean, it's definitely something suitable for the MVP, but we would still need to prioritize it.  Let's create a case first so we know we will cover that in the planning and backlog grooming first.  I can do that if you're about to drop.

---

**Flavio Castelli** (2025-11-06 18:19):
:+1::skin-tone-3:

---

**Sam Wang** (2025-11-06 18:21):
Just a note for myself.  Here (https://github.com/cilium/tetragon/blob/9dea41615eae8a59b0433fa29fa01cf590dda41f/pkg/watcher/crdwatcher/tracingpolicy.go#L167) is where the tracing policy is handled.

---

**Andrea Terzolo** (2025-11-06 18:31):
&gt; I can do that if you're about to drop.
Yep if you have time it would be amazing otherwise i will do that tomorrow morning

---

**Sam Wang** (2025-11-06 18:59):
https://github.com/neuvector/runtime-enforcement/issues/279

---

**Kyle Dong** (2025-11-06 23:47):
Great discussion!
Give my two cents, I agree that having multiple policies with the same `podSelector` should work fine in practice. The key part is managing naming since Tetragon requires unique names per namespace.
If we want to handle this on our side, I think we can follow a consistent naming convention, for example appending a version or timestamp to the policy name. Once we confirm the new policy is active, we can safely delete the previous version or old timestamped policy.

---

**Sam Wang** (2025-11-07 00:46):
We can also do like how a Deployment is reconciled into a ReplicaSet, where the hash of the template is used as part of the name, in addition to using #generation or timestamp.  We have many options here.

---

**Flavio Castelli** (2025-11-10 14:29):
I just noticed the planning meeting overlaps with the kw's admission controller planning. Can we postpone it by 30 minutes?

---

**Flavio Castelli** (2025-11-10 14:29):
if this is not doable today we can change that next week

---

**Kyle Dong** (2025-11-10 14:37):
I’m ok with postpone the planning meeting by 30 mins

---

**Flavio Castelli** (2025-11-10 14:38):
you mean you're ok? :point_up::skin-tone-3: :smile:

---

**Kyle Dong** (2025-11-10 14:46):
Yes, sorry for the confusion :joy:

---

**Kyle Dong** (2025-11-10 14:48):
Was replying another message, I don’t know why I typed “I’m work”:sweat_smile:

---

**Alessio Biancalana** (2025-11-10 15:26):
yes let's postpone

---

**Alessio Biancalana** (2025-11-10 15:30):
@Flavio Castelli do you prefer 16.00 also for the next ones?

---

**Flavio Castelli** (2025-11-10 15:39):
yes, I would prefer 16:00 in the future, since the KW admission controller meeting always happens on Mon from 15-16

---

**Alessio Biancalana** (2025-11-10 15:40):
ok I'll move the subsequent ones too then

---

**Flavio Castelli** (2025-11-10 17:06):
sorry for the hiccup, due to a series of misfortunes my daughter and a friend of her had to be picked up by me, or left waiting in the cold... :sweat_smile:

---

**Sam Wang** (2025-11-10 17:53):
Anyone will be in the Tetragon community calls?

---

**Sam Wang** (2025-11-10 18:50):
Just finished the call:
• https://github.com/cilium/tetragon/issues/4322
    ◦ Some options are gone through by kkourt.  In the current version, the easiest way for now is probably via gRPC API or metrics.
    ◦ Update the status of CR is not scalable according to cilium's experience, especially from each node.
    ◦ It's possible to do that in Tetragon, but a few details to figure out.  =&gt; looks like they're willing to make the change. 
• https://github.com/cilium/design-cfps/pull/80
    ◦ It was mentioned but not much technical detail.
    ◦ kkourt said this is an existing issue even in entreprise version.  
    ◦ He might do a talk in KubeCon or CiliumCon.

---

**Andrea Terzolo** (2025-11-10 18:57):
thank you for the summary Sam :pray: i didn't make it :disappointed:

---

**Sam Wang** (2025-11-10 19:18):
Alright slack is down.

---

**Kyle Dong** (2025-11-10 19:20):
The app of mine seems work

---

**Alessio Biancalana** (2025-11-11 09:01):
thank you so much for attending! :fire:

---

**Sam Wang** (2025-11-11 15:40):
Question: we have two RFC docs that link to the original runtime-enforcement PR, e.g., https://github.com/neuvector/runtime-enforcer/blob/e93f24888890094f1ae506bbae8d667f7fc6a11e/docs/rfc/0002-process-snapshot.md?plain=1#L6

Any thoughts to deal with the links after the migration?  @Flavio Castelli @Alessio Biancalana

---

**Alessio Biancalana** (2025-11-11 17:11):
I just transferred the majority of the issues to the new repo, I have to go out for an errand, when I come back I'll finish the migration of the issues and I'll try to reconstruct the project board, sorry for the disruption!

---

**Alessio Biancalana** (2025-11-11 17:11):
no strong opinions there, I see in the PR you made that you updated the majority of them, good call

---

**Flavio Castelli** (2025-11-11 17:12):
I would just update the links to point to their final location

---

**Flavio Castelli** (2025-11-11 17:13):
we will have to update them another time in the future, since the repo is not going to be under the NV organization on GitHub

---

**Flavio Castelli** (2025-11-11 17:13):
we will have fun, making yet another rename. That's life :shrug::skin-tone-3:

---

**Sam Wang** (2025-11-11 17:16):
hmm yeah I'm sure that we will probably need to rename them again, but the issue right now is that there won't be a counterpart of, say, https://github.com/neuvector/runtime-enforcer/pull/193, in the new repo.  I inclined just removing the link but would like to know your thoughts first.

---

**Sam Wang** (2025-11-11 17:17):
hmm just noticed the link above is dead.  It actually points to #193 (https://github.com/neuvector/runtime-enforcement/issues/193) before my change.

---

**Sam Wang** (2025-11-11 17:19):
I think the best we can do is to keep it like the #193.  Let me know if you have different thoughts.  :slightly_smiling_face:

---

**Sam Wang** (2025-11-11 19:53):
The migration of code has completed. I've verified that all workflows run successfully.  Please help to verify if you have the access to the new repo and let me know if you have any questions.

---

**Kyle Dong** (2025-11-11 19:57):
I have the access to the new repo `runtime-enforcer` . Thanks for the great work!

---

**Alessio Biancalana** (2025-11-11 22:31):
Same same about the issues, I just left a couple behind, I also recreated the milestones and the project with the board, everything should be alright, tomorrow I’ll take a final look to iron it out

---

**Alessio Biancalana** (2025-11-11 22:32):
Thanks for bearing with us during this transition :heart:

---

**Flavio Castelli** (2025-11-12 08:21):
sure, go ahead and delete them

---

**Flavio Castelli** (2025-11-12 08:21):
good, I think we can archive the old repo now

---

**Flavio Castelli** (2025-11-12 08:23):
Is the board still https://github.com/orgs/neuvector/projects/6 ? I see that's the project board that is linked under process-enforcer -&gt; projects

---

**Alessio Biancalana** (2025-11-12 08:25):
Yes I just had to relink it to the new projects. Funnily enough the transferred tickets were preserved into their current lanes, nice

---

**Flavio Castelli** (2025-11-12 08:26):
nice, I've renamed the board to reflect the change

---

**Alessio Biancalana** (2025-11-12 08:34):
Ah right, thanks

---

**Sam Wang** (2025-11-12 16:01):
The old `neuvector/runtime-enforcement` repo is now archived.  Thanks everyone.

---

**Sam Wang** (2025-11-12 16:18):
The failing run (https://github.com/neuvector/runtime-enforcer/actions/runs/19301295911/job/55196218375) uses helm `v4.0.0` while the successful run  (https://github.com/neuvector/runtime-enforcer/actions/runs/19301391926/job/55197196694)uses `v3.19.1` .

---

**Sam Wang** (2025-11-12 18:28):
https://github.com/helm/helm/issues/31490

---

**Sam Wang** (2025-11-12 18:35):
I will remove the helm unit-test from the PR requirement for now.

---

**Alessio Biancalana** (2025-11-13 09:58):
We discussed the CRDs and the first outcome can be found here https://github.com/neuvector/runtime-enforcer/issues/34

Now the second stage begins: we would appreciate a feedback from all the team about the final proposal we're heading to. Feel free to comment the document you find in the issue!

---

**Alessio Biancalana** (2025-11-13 14:30):
regarding the error we have in CI about helm-unittest: https://github.com/neuvector/runtime-enforcer/pull/35

basically helm 4.0.0 still has some defects, so I just pinned the version in the CI for the moment

---

**Andrea Terzolo** (2025-11-13 15:27):
since the document is pretty long it's worth saying that the final idea starts from `Final proposal` at page 18. The previous pages are just  discarded ideas

---

**Flavio Castelli** (2025-11-13 16:56):
Yes, there are links at the beginning of the document to the sections you should read

---

**Andrea Terzolo** (2025-11-14 18:09):
After a quick discussion with Flavio and Alessio I proposed some changes to the proposal (renamed into v0.1.0)
I called the new version (v0.2.0) https://docs.google.com/document/d/1F415c0pleOn_5n50V1VU8eya8OGuzgCV_q8hRrcDNro/edit?tab=t.0#heading=h.wu7bymysx0ag
Please note i've not rewritten all the sections but just the ones subject to changes. Main proposed changes:
• looking also at your comments, imposing a strict constraint on the `security.rancher.io/policy (http://security.rancher.io/policy)` label seemed a little bit too much. The new version lets users to choose what to do reintroducing the label selector. The suggested thing is still to use a unique label to avoid conflicts, but if users prefer to avoid rollouts they can use plain k8s label selector. So we are just allowing more flexibility to the user in case the rollout is not an option.
• The WorkloadSecurityPolicy was renamed into PodPolicy
• The WorkloadSecurityPolicyTuning was deleted and replaced by the status in the PodPolicy resource. The idea here is to keep things simple for the first iteration. 2 main benefits:
    ◦ the flow is pretty simple and basic. We can introduce dedicated and more complex CRD only if we need them in the future
    ◦ SUSE security can really improve the experience over the CLI one where the user has to manually patch resources

---

**Flavio Castelli** (2025-11-14 18:34):
sorry for the late replies on the document, I didn't realize there were comments (I didn't get notified).

---

**Flavio Castelli** (2025-11-14 18:34):
I suggest we schedule a meeting next week to talk together about the document

---

**Andrea Terzolo** (2025-11-14 18:36):
yep it would be ideal to identify some specific topics to discuss more in detail in the meeting

---

**Andrea Terzolo** (2025-11-14 18:37):
maybe we can craft a list before the meeting where everyone puts a couple of lines on the topic to discuss

---

**Alessio Biancalana** (2025-11-14 19:26):
you tell me if you want me to schedule it early or later on, would tuesday after the daily be a good time for everybody?

---

**Louis Lotter** (2025-11-17 08:59):
@Alessio Biancalana please invite me as well. would be nice way to get insight into what you guys are up to.

---

**Flavio Castelli** (2025-11-17 09:00):
I would prefer to do that right after the daily if possible. I've a conflicting meeting before the daily

---

**Alessio Biancalana** (2025-11-17 09:14):
Perfect, I’ll schedule the meeting as soon as possible, thanks

---

**Andrea Terzolo** (2025-11-17 12:59):
Please remember to add your points/questions before the meeting so that we can keep the discussion focused https://docs.google.com/document/d/19qGoa91sht4TF-3JHaefMZOWCHzBi_5RLfuw-6dP-Qo/edit?tab=t.0

---

**Sam Wang** (2025-11-17 15:04):
Feeling a bit under the weather.  Will take a day off to have some rest.

---

**Andrea Terzolo** (2025-11-17 15:11):
take care!

---

**Alessio Biancalana** (2025-11-17 15:24):
no worries man, 大丈夫です :green_heart:

---

**Davide Iori** (2025-11-18 09:40):
Hi team. I see you are going to have a call over a document you created. I know it is 99% implementation details but please include me if you believe there are functional implications which need Product awareness. Thanks!

---

**Alessio Biancalana** (2025-11-18 09:44):
sure, I'm inviting you as optional, feel free to join

---

**Sam Wang** (2025-11-18 22:24):
Today in a nut shell:

---

**Sam Wang** (2025-11-18 22:25):
It's surprising that a GitHub workflow can't connect to GitHub itself without cloudflare...

---

**Alessio Biancalana** (2025-11-19 08:49):
I had a 502 coming from a clone action while sleeping and I was like "maybe that's a cloudflare fault too"

---

**Davide Iori** (2025-11-19 11:50):
Hi team, I had a follow-up question with regards the CRD structure.
Similarly to what NV does today, I'd like to show to users the name, the path and the updated datetime per learned process/executable. Where updated, in our case, is the datetime when the process was added to the whitelist.
Would that be possible?
We can discuss this here and later add the "final" answer in the RFC doc. (Here (https://docs.google.com/document/d/1F415c0pleOn_5n50V1VU8eya8OGuzgCV_q8hRrcDNro/edit?disco=AAABwdyz_jM) the same question in the doc)

---

**Alessio Biancalana** (2025-11-19 13:12):
usually I would avoid basing the CRD upon the UI we want to show and I'd base the UI on the CRD we are going to shape instead.

Moreover, I would avoid turning something that today is just a string into a struct that has some other fields inside because we would enlarge the object that hits etcd and therefore introduce potential performance issues.

So, if this is something that the user _really_ would die for, let us know, otherwise I would strip that out.

---

**Davide Iori** (2025-11-19 14:33):
OK I understand.
100% this is something current SUSE Security users (aka Neuvector adopters) see available when interacting with the product.
100% this is something the same users will not die for in case we won't make the same info available in the next SUSE Security.

*So, all in all, we can neglect it.* 

ps: On purpose, I am sharing what Neuvector has at the moment to remember that we are `building something from scratch which will be packaged as the new major of something existing`. This not-so-common scenario could raise more challenges of the type "I am used to see/do something, and now I can't anymore".
This is mostly a product concern, so no worries, but you having it in the back of your mind would not harm either :wink:

---

**Alessio Biancalana** (2025-11-19 14:35):
sure, I'm not forgetting it, I'm just balancing it with the fact that this rewrite has its own reasons :smile:

---

**Davide Iori** (2025-11-19 14:36):
yes, many.
All good :slightly_smiling_face:

---

**Alessio Biancalana** (2025-11-19 16:42):
personal update: I'm still working on writing a draft of the RFC :grimacing: I think we'll have it ready to comment tomorrow, I hoped I would have something draftable today but I'm still finalizing it and there are a couple things to iron out even for a first draft

---

**Kyle Dong** (2025-11-19 18:11):
As I mentioned in yesterday's syncup meeting, based on my recent POC about the BPF maps memory usage, with applying 20 tetragon tracing policies.
I tested with latest Tetragon (includes my enhancement for `socktrack_map`  which has been merged), the memory usage:
```BPF maps memory init: 32.30 MB

BPF maps memory after 20 policies applied: 141.91 MB

BPF maps memory delta: 109.61 MB

Per-policy Memory: 5.48 MB```
After adding `BPF_F_NO_PREALLOC` to per policy map `policy_%d_map` and `override_tasks` , also for the global map `execve_map` , the memory usage:
```BPF maps memory init: 2.91 MB

BPF maps memory after 20 policies applied: 32.50 MB

BPF maps memory delta: 29.59 MB

Per-policy Memory: 1.48 MB```
It saves roughly *73%* of memory.

The enhancement PR for `policy_%d_map` is currently pending upstream review. I have also proposed using `BPF_F_NO_PREALLOC` for `override_tasks`, and I'm still waiting for their feedback.
For the global `execve_map`, using `BPF_F_NO_PREALLOC` reduces memory usage significantly, from roughly ~*31 MB* down to about ~*0.8 MB*. Tetragon already provides a configurable flag to adjust its `MaxEntries`, which is currently set to the maximum value of *32768*. The question now is determining the most appropriate value for our use case. Since this is a global map, it will not grow uncontrollably over time, but we still need to choose a reasonable size that balances memory usage and operational requirements.

---

**Alessio Biancalana** (2025-11-19 18:41):
these are really great results, thank you so much for upstreaming so many patches and making us more comfortable with shipping this

---

**Alessio Biancalana** (2025-11-19 18:43):
about the `MaxEntries` for the global map I would tell you let's keep that on the radar and let's see what happens when we have the enforcer deployed somewhere internally where we can observe a behavior similar to a production/pre-production environment

---

**Alessio Biancalana** (2025-11-19 18:44):
anyway these are really significant improvement and ngl I'm gonna pour the champagne lol

---

**Andrea Terzolo** (2025-11-19 19:05):
Thank you for the benchmark Kyle! These results are really great `1.48 MB` considering that we started from `~8/9 MB` for each policy! If i understand well your bechmark contains all memory optimizations included here https://github.com/neuvector/runtime-enforcer/issues/18 (i mean only the memory optimizations not all), is it right?

&gt; I have also proposed using `BPF_F_NO_PREALLOC` for `override_tasks`, and I'm still waiting for their feedback.
this could be a minor issue if Sam's PR is merged https://github.com/cilium/tetragon/pull/4244 last time i saw the override map was shared by all progs on the same hook so in our case it would mean 1 map shared by all our policies

&gt; For the global `execve_map`, using `BPF_F_NO_PREALLOC` reduces memory usage significantly, from roughly ~*31 MB* down to about ~*0.8 MB*. Tetragon already provides a configurable flag to adjust its `MaxEntries`, which is currently set to the maximum value of *32768*. The question now is determining the most appropriate value for our use case. Since this is a global map, it will not grow uncontrollably over time, but we still need to choose a reasonable size that balances memory usage and operational requirements.
if we have `BPF_F_NO_PREALLOC` on it we can also keep the current maximum value *`32768`* so that we are sure we won't hit any limit also on big nodes. Since this is a global map and not per policy i believe it is ok even if it grows

---

**Andrea Terzolo** (2025-11-19 19:25):
While working on https://github.com/neuvector/runtime-enforcer/issues/5 i realized that is probably better to handle this one before  https://github.com/neuvector/runtime-enforcer/issues/41. Our own controllers need to know when a policy is correctly deployed to delete the previous one.

I posted a couple of solutions in the issue. Some notes:
• IMO the "ideal" solution would be to implement the status on Tetragon TracingPolicy. What i proposed can be for sure improved to avoid conflicts and to use smarter strategies for updates. What scares me is how much time would require to upstream this feature and to have it accepted and merged. Looking at https://github.com/cilium/tetragon/pull/4244 and https://github.com/cilium/design-cfps/pull/80 it seems they require high code standard before merging something so there is the risk we will end up with another cfp for implementing the status in the TracingPolicy...
• I proposed an alternative based on prometheus metrics. It is a little bit esoteric at a first glance but i believe it could work without too many complications, unless i'm missing something. Probably it is not the conventional approach but computing the state of a resource using a timer-based approach seems something possible and supported by the controller-runtime. 
• there is probably a third approach based on GRPC, where we have a daemon on each node that reads the outcome of the TracingPolicy creation and populate the status of the `WorkloadPolicy` or another new resource, but i've not explored this too much to be honest.
Curious to know your impressions about it!

---

**Davide Iori** (2025-11-19 19:34):
@Kyle Dong what a great results!
To further simulate some real scenarios would help getting some numbers from customers? E.g. Taking the largest NV installation, how many policies are running?
Or anything else that can help understanding impacts on some existing production use cases.

---

**Kyle Dong** (2025-11-19 19:43):
@Andrea Terzolo
&gt; If i understand well your bechmark contains all memory optimizations included here https://github.com/neuvector/runtime-enforcer/issues/18 (i mean only the memory optimizations not all), is it right?
Yes, this benchmark contains all memory optimizations included in this issue.
&gt; this could be a minor issue if Sam's PR is merged https://github.com/cilium/tetragon/pull/4244 last time i saw the override map was shared by all progs on the same hook so in our case it would mean 1 map shared by all our policies
I had a discussion with @Sam Wang last Friday about this one. Once upstream accepts Sam's enhancement, we can limit the number of `override_tasks` to be used, which will be another huge optimization for us if we have a large number of polices. Currently, ~0.5MB cost per policy.
&gt; if we have `BPF_F_NO_PREALLOC` on it we can also keep the current maximum value *`32768`* so that we are sure we won't hit any limit also on big nodes. Since this is a global map and not per policy i believe it is ok even if it grows
I agree. The only concern from upstream right now for using `BPF_F_NO_PREALLOC` is the CPU consumption. They suggest to use a configurable flag to enable `BPF_F_NO_PREALLOC` flag for those maps (I have implemented in https://github.com/cilium/tetragon/pull/4340). This configurable flag will act as a backup in case there are unwanted side-effects from this change. So I suppose they will be positive to add `BPF_F_NO_PREALLOC` in the other 2 maps as well:crossed_fingers:

---

**Sam Wang** (2025-11-19 20:05):
It's even better than my previous result of 2mb/policy! Great job!

&gt; this could be a minor issue if Sam's PR is merged https://github.com/cilium/tetragon/pull/4244 last time i saw the override map was shared by all progs on the same hook so in our case it would mean 1 map shared by all our policies
yeah we're being requested for some change, but the idea to share the same map stays the same.

&gt; Or anything else that can help understanding impacts on some existing production use cases.
Agreed.  This is something that we should work on next, so we have more real-world test.

---

**Sam Wang** (2025-11-19 20:32):
Quickly checked the PR and it looks good to me!  Just out of curiosity @Kyle Dong , did they mention anything about a per-policy knob?

The issue is about the potential deadlock when these three conditions are met:
1. Linux 5.x kernel
2. BPF_F_NO_PREALLOC is used.
3. the ebpf program is attached to a non-sleepable location.
To me it seems like it makes more sense to have a per-policy knob due to the condition#3, but it's out of our use case anyway...

---

**Kyle Dong** (2025-11-19 21:37):
@Sam Wang, no, they didn't mention the per-policy knob. I'll take another look and check this potential deadlock.

---

**Sam Wang** (2025-11-19 21:39):
No problem at all.  In case you need it, it's mentioned in our issue (https://github.com/neuvector/runtime-enforcer/issues/21#issue-3612953413) and this thread (https://suse.slack.com/archives/C09KMBW6DA5/p1760624090875439?thread_ts=1760623581.907899&amp;cid=C09KMBW6DA5).

---

**Sam Wang** (2025-11-20 16:32):
Looks neat!  I've left my comments in the ticket.  A quick summary:
• I think we can have a new CR for the status instead because it's much more efficient than a shared Policy status by all nodes.  We can potentially expand it to include more information.  Besides the new CR will enable us to filter out unhealthy agents/nodes easily. 
• I slightly prefer gRPC APIs compared to otel metrics because we already use their gRPC APIs, but I'm open to otel metrics if it has more benefits.

---

**Andrea Terzolo** (2025-11-20 17:30):
Thanks for the feedback!
&gt; • I think we can have a new CR for the status instead because it's much more efficient than a shared Policy status by all nodes
i've to admit that i miss the advantages of having a dedicated CR for the status in what i have in mind, i tried to explain it on GH
&gt; • I slightly prefer gRPC APIs compared to otel metrics because we already use their gRPC APIs, but I'm open to otel metrics if it has more benefits. 
yep that's true, i would prefer it as well, the only limit here is that could become tricky, while prometheus seems to offer everything we need almost out-of-the-box

---

**Alessio Biancalana** (2025-11-20 18:18):
RFC for the CRD revisit and policy lifecycle available here: https://github.com/neuvector/runtime-enforcer/pull/45

time to comment it! I would like it to be open for just a couple days, but on the other hand I'm sure there are details to iron out and things I forgot. Thanks everybody :green_heart:

---

**Sam Wang** (2025-11-23 17:03):
Hi team, sorry that I'm going to miss the sprint planning this time for a hospital appointment.  Here are the tasks I've been working on:
• #8 not done yet.  I'm moving codes from attestation.yml to release.yml, so that slsactl can verify it.
• #22 I've got upstream feedback but haven't got time to look into it.  
I'm dragged by a few big code review from neuvector sides too, so I'd expect that my bandwidth will be pretty full for the first week for the next sprint.  I will try to pick up #13 if I have some bandwidth later.

---

**Alessio Biancalana** (2025-11-24 12:05):
Just a little bit of a heads up, I had multiple feedbacks that we could switch the order of refinement and planning, so since I don't want to cause a mayhem in everybody's mailbox with rescheduling everything without seeing how it goes today we'll hold the refinement and tomorrow we'll hold the planning :smile:

---

**Andrea Terzolo** (2025-11-25 12:28):
for Tuesday in which we have runtime enforcer refinement+standup could i suggest to squeeze them in a unique call/slot? in this way we can avoid the 30 min hole between them

---

**Andrea Terzolo** (2025-11-25 12:34):
For the `WorkloadPolicy` status i was thinking something like this in order to report if the policy is correctly deployed on all nodes. This is more like the final design i have in mind

```status:
  phase: Failed
  # nice to have but if in my cluster there 1024 polcies and a new node comes up i have to update all the 1024 policies
  nodesReady: 498
  nodesTotal: 500
  conditions:
    - type: Failed
      status: "True"
      reason: PolicyInjectionFailed
      message: "Policy is not injected on nodes: node-worker-03, node-worker-15"
      lastTransitionTime: "2025-11-25T10:01:00Z"
  # Only failed nodes with a reason
  nodeStatusDetails:
    node-worker-03:
      status: Error
      errorMessage: "dedicated message"
      lastSyncTime: "2025-11-25T11:40:00Z"
    node-worker-15:
      status: Error
      errorMessage: "dedicated message"
      lastSyncTime: "2025-11-25T11:41:00Z"```
For the first iteration i would suggest something simpler, like a global state + conditions. I'm under the impression that in most of the cases if a node fails all the others nodes will fail, since our policy is identical. This probably not always true, there could be cases of single nodes memory issues, but i would like to understand if this situation is frequent, so that we can handle it properly in the status

```status:
  phase: Failed
  conditions:
    - type: Failed
      status: "True"
      reason: PolicyInjectionFailed
      message: "Policy is not injected on nodes: node-worker-03, node-worker-15"
      lastTransitionTime: "2025-11-25T10:01:00Z"```
WDYT?

---

**Andrea Terzolo** (2025-11-25 12:36):
it would be also interested in understanding how much frequently the status is updated. I don't expect too many updates but having some concrete data from a real cluster would be better

---

**Alessio Biancalana** (2025-11-25 13:56):
&gt; for Tuesday in which we have runtime enforcer refinement+standup could i suggest to squeeze them in a unique call/slot?
let's try this right away

---

**Alessio Biancalana** (2025-11-25 14:21):
ok it went pretty good, just a note to everybody involved: *we will not hold the daily* because we already did at 14:00. :smile:

---

**Alessio Biancalana** (2025-11-25 14:29):
for me this proposal is absolutely sensible, feel free to go ahead

---

**Sam Wang** (2025-11-25 14:29):
Regarding meetings, since the Tuesday one is going to become a sprint planning meeting moving forward and probably won't need a whole hour, could we make it slightly later like by 30mins or 1hr?  It's currently out of my usual business hour so it's a little inconvenient.

---

**Alessio Biancalana** (2025-11-25 14:30):
as long as we keep adding stuff and keep it incremental without breaking existing stuff it's ok to do whatever we want I think

---

**Alessio Biancalana** (2025-11-25 14:30):
I'll take that into account when rescheduling, thanks for the heads up

---

**Flavio Castelli** (2025-11-25 15:43):
looks nice!

---

**Andrea Terzolo** (2025-11-25 16:08):
@Kyle Dong great job on https://github.com/cilium/tetragon/pull/4331!
I just left a comment https://github.com/cilium/tetragon/pull/4331#discussion_r2547138530 since IMO they are suggesting something a little bit strange...maybe i misunderstood but the `policy_filter_maps` is global, why should we bring it inside each single sensor?

---

**Andrea Terzolo** (2025-11-25 16:10):
side question: do you think we need a specific config for it in tetragon helm chart or having the command line is enough to tweak it into the helm chart?

---

**Andrea Terzolo** (2025-11-25 16:18):
uhm it seems we should use `tetragon.argsOverride` with `--policy-filter-map-entries` to use a different size :thinking_face:

---

**Kyle Dong** (2025-11-25 16:20):
&gt; since IMO they are suggesting something a little bit strange...maybe i misunderstood but the `policy_filter_maps` is global, why should we bring it inside each single sensor?
I think you are absolutely right, `policy_filter_maps` is global. Their refactor suggestion isn’t to put a separate copy inside each sensor. They want to model this existing global map using the same abstraction (program.Map) that other global maps already use (like execve_map). so that it can use the same API, SetMaxEntries (https://github.com/cilium/tetragon/blob/2649af92d71af22a044924ff6b64a93419bb7a85/pkg/sensors/program/map.go#L374) to set the max entries.

---

**Andrea Terzolo** (2025-11-25 16:24):
oh i see, to be honest i would suggest to do that in another PR since seems a little bit out of scope, we just wanted to configure the size :joy:

---

**Kyle Dong** (2025-11-25 16:24):
@Andrea Terzolo to your comment in the PR, the agent-side map creation(in pkg/policyfilter/map.go) already sets the desired MaxEntries, but the loader still needs to see the same number in the ELF spec. That's because they define `policy_filter_maps` as raw ebpf.map. The loader change doesn't create another map; it just rewrites the spec's MaxEntries to match the runtime value before loading.

---

**Kyle Dong** (2025-11-25 16:26):
&gt; i would suggest to do that in another PR since seems a little bit out of scope, we just wanted to configure the size
I'll try to push back:sweat_smile:

---

**Kyle Dong** (2025-11-25 16:31):
&gt; side question: do you think we need a specific config for it in tetragon helm chart or having the command line is enough to tweak it into the helm chart?
I think technically the CLI flag is sufficient for us. For Tetragon, I think they want both to document it alongside the other scaling parameters, and avoid everyone having to remember the exact flag name...
Since it's not a lot of change for me, so I guess I'll just keep the existing implementation..

---

**Andrea Terzolo** (2025-11-25 16:37):
&gt; That's because they define `policy_filter_maps` as raw ebpf.map. The loader change doesn't create another map; it just rewrites the spec's MaxEntries to match the runtime value before loading.
thank you for the explanation!

---

**Andrea Terzolo** (2025-11-25 16:38):
&gt; I'll try to push back:sweat_smile:
i'm not saying we shouldn't do that, but probably it's not a priority for us. They play a little bit with us trying to oflload refactors when they can, unfortunately/fortunately this is part of the game

---

**Sam Wang** (2025-11-25 16:44):
Haha I have exactly the same thoughts and it seems like a pattern that they're asking more than we originally proposed.

I mean, this is not unusual for a open source project, because they don't really know if the person will just disappear if they allow a task to be pushed back.

To help with that, I think showing up in the community call would definitely help, and we can just ask if they are really necessary for the first batch.

---

**Andrea Terzolo** (2025-11-25 18:49):
I was preparing a document with the memory improvement we have done, and with all the optimization in place i get ~1.95 MB.
It's near the 1,48 MB but i would like to understand if i missed something.
I just used latest main
• with `BPF_F_NO_PREALLOC` on the `policy_%d_map`
• and i've not considered the `override_tasks` map that should become global with https://github.com/cilium/tetragon/pull/4244
This is the list of maps i obtain:
```1633: hash  name policy_1_map  flags 0x0
        key 8B  value 1B  max_entries 32768  memlock 524560B
        pids tetragon(212814)
1634: lru_hash  name fdinstall_map  flags 0x0
        key 16B  value 4104B  max_entries 1  memlock 5592B
        btf_id 1745
        pids tetragon(212814)
1635: array  name config_map  flags 0x0
        key 4B  value 704B  max_entries 1  memlock 968B
        btf_id 1746
        pids tetragon(212814)
1636: prog_array  name kprobe_calls  flags 0x0
        key 4B  value 4B  max_entries 13  memlock 368B
        owner_prog_type kprobe  owner jited
        pids tetragon(212814)
1637: array  name filter_map  flags 0x0
        key 4B  value 4096B  max_entries 1  memlock 4360B
        btf_id 1748
        pids tetragon(212814)
1639: array_of_maps  name argfilter_maps  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1641: array_of_maps  name addr4lpm_maps  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1643: array_of_maps  name addr6lpm_maps  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1645: array_of_maps  name string_maps_0  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1647: array_of_maps  name string_maps_1  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1649: array_of_maps  name string_maps_2  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1651: array_of_maps  name string_maps_3  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1653: array_of_maps  name string_maps_4  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1655: array_of_maps  name string_maps_5  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1657: array_of_maps  name string_maps_6  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1659: array_of_maps  name string_maps_7  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1661: array_of_maps  name string_maps_8  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1663: array_of_maps  name string_maps_9  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1665: array_of_maps  name string_maps_10  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1667: array_of_maps  name string_prefix_m  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1669: array_of_maps  name string_postfix_  flags 0x0
        key 4B  value 4B  max_entries 8  memlock 328B
        pids tetragon(212814)
1670: hash  name retprobe_map  flags 0x0
        key 16B  value 24B  max_entries 1024  memlock 109440B
        btf_id 1781
        pids tetragon(212814)
1671: percpu_array  name process_call_he  flags 0x0
        key 4B  value 25608B  max_entries 1  memlock 410000B
        btf_id 1782
        pids tetragon(212814)
1672: array  name tg_mb_sel_opts  flags 0x0
        key 4B  value 12B  max_entries 5  memlock 344B
        btf_id 1783
        pids tetragon(212814)
1674: array_of_maps  name tg_mb_paths  flags 0x0
        key 4B  value 4B  max_entries 5  memlock 304B
        pids tetragon(212814)
1675: stack_trace  name stack_trace_map  flags 0x0
        key 4B  value 1016B  max_entries 1  memlock 1328B
        pids tetragon(212814)
1676: lru_hash  name socktrack_map  flags 0x0
        key 8B  value 16B  max_entries 1  memlock 1496B
        btf_id 1787
        pids tetragon(212814)
1677: lru_hash  name ratelimit_map  flags 0x0
        key 224B  value 8B  max_entries 1  memlock 1704B
        btf_id 1788
        pids tetragon(212814)
1679: array  name policy_conf  flags 0x0
        key 4B  value 1B  max_entries 1  memlock 272B
        btf_id 1790
        pids tetragon(212814)
1680: array  name policy_stats  flags 0x0
        key 4B  value 64B  max_entries 1  memlock 328B
        btf_id 1791
        pids tetragon(212814)
1682: percpu_array  name ratelimit_heap  flags 0x0
        key 4B  value 352B  max_entries 1  memlock 5904B
        btf_id 1793
1683: percpu_array  name buffer_heap_map  flags 0x0
        key 4B  value 4352B  max_entries 1  memlock 69904B
        btf_id 1794
1687: percpu_array  name heap  flags 0x0
        key 4B  value 4104B  max_entries 1  memlock 65936B
        btf_id 1798
1689: percpu_array  name string_postfix_  flags 0x0
        key 4B  value 132B  max_entries 1  memlock 2448B
        btf_id 1800
1690: percpu_array  name string_prefix_m  flags 0x0
        key 4B  value 260B  max_entries 1  memlock 4496B
        btf_id 1801
1691: percpu_array  name tg_ipv6_ext_hea  flags 0x0
        key 4B  value 8B  max_entries 1  memlock 400B
        btf_id 1802
1692: array  name heap_ro_zero  flags 0x0
        key 4B  value 16384B  max_entries 1  memlock 16648B
        btf_id 1803
1694: hash  name enforcer_data  flags 0x0
        key 8B  value 12B  max_entries 1  memlock 2776B
        btf_id 1805
1695: hash  name tg_cgtracker_ma  flags 0x0
        key 8B  value 8B  max_entries 1  memlock 2640B
        btf_id 1806
1696: percpu_array  name string_maps_hea  flags 0x0
        key 4B  value 16384B  max_entries 1  memlock 262416B
1700: hash  name enforcer_missed  flags 0x0
        key 12B  value 4B  max_entries 128  memlock 13952B
        btf_id 1811
1704: percpu_array  name data_heap  flags 0x0
        key 4B  value 32768B  max_entries 1  memlock 524560B
        btf_id 1815
1705: hash  name string_maps_0_0  flags 0x0
        key 25B  value 1B  max_entries 5  memlock 3512B
1706: hash  name string_maps_1_0  flags 0x0
        key 49B  value 1B  max_entries 4  memlock 3840B
1707: hash  name string_maps_2_0  flags 0x0
        key 73B  value 1B  max_entries 1  memlock 3864B```
and this is the policy i used
```apiVersion: cilium.io/v1alpha1 (http://cilium.io/v1alpha1)
kind: TracingPolicy
metadata:
  name: "not-called-policy-${NUM}"
spec:
  podSelector:
    matchLabels:
      app: "client"
  kprobes:
  - call: "security_bprm_creds_for_exec"
    syscall: false
    args:
    - index: 0
      type: "linux_binprm"
    selectors:
    - matchArgs:
      - index: 0
        operator: "Equal"
        values:
        - "/usr/bin/impossible-1"
        - "/usr/bin/impossible-1w22222"
        - "/usr/bin/impossible-1w22222qqwqwqe"
        - "/usr/bin/impossible-1w22222qqwqwqeQWQE"
        - "/usr/impossi-1"
        - "/usr/impossi-1w22222qqwq"
        - "/usr/impossi-1w22222qqwqQWQEEQEEEEEEEEEEEEEEEEEEE"
        - "/usr/XX"
        - "/usr/XXSAEDDA"
        - "/usr/XXSAEDDASSSSSSSSSSSSSSSSSS"
      matchActions:
      - action: Override
        argError: -1
  options:
  - name: disable-kprobe-multi
    value: "1"```
am i missing anything ? @Kyle Dong

---

**Kyle Dong** (2025-11-25 19:42):
I' running the same tracing policy as yours on my private Tetragon image (based on latest code base, with `BPF_F_NO_PREALLOC` on the `policy_%d_map` and `override_tasks` . The following is the result of mine, which is still ~1.48MB (please note that it's include the `override_tasks` memlock ~0.5MB)
```131411: hash  name policy_1_map  flags 0x1
	key 8B  value 1B  max_entries 32768  memlock 525312B
	pids tetragon(864045)
131412: lru_hash  name fdinstall_map  flags 0x0
	key 16B  value 4104B  max_entries 1  memlock 5208B
	btf_id 136800
	pids tetragon(864045)
131413: array  name config_map  flags 0x0
	key 4B  value 736B  max_entries 1  memlock 1000B
	btf_id 136801
	pids tetragon(864045)
131414: prog_array  name kprobe_calls  flags 0x0
	key 4B  value 4B  max_entries 13  memlock 368B
	owner_prog_type kprobe  owner jited
	pids tetragon(864045)
131415: array  name filter_map  flags 0x0
	key 4B  value 4096B  max_entries 1  memlock 4360B
	btf_id 136803
	pids tetragon(864045)
131417: array_of_maps  name argfilter_maps  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131419: array_of_maps  name addr4lpm_maps  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131421: array_of_maps  name addr6lpm_maps  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131423: array_of_maps  name string_maps_0  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131425: array_of_maps  name string_maps_1  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131427: array_of_maps  name string_maps_2  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131429: array_of_maps  name string_maps_3  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131431: array_of_maps  name string_maps_4  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131433: array_of_maps  name string_maps_5  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131435: array_of_maps  name string_maps_6  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131437: array_of_maps  name string_maps_7  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131439: array_of_maps  name string_maps_8  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131441: array_of_maps  name string_maps_9  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131443: array_of_maps  name string_maps_10  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131445: array_of_maps  name string_prefix_m  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131447: array_of_maps  name string_postfix_  flags 0x0
	key 4B  value 4B  max_entries 8  memlock 328B
	pids tetragon(864045)
131448: hash  name retprobe_map  flags 0x0
	key 16B  value 24B  max_entries 1024  memlock 107904B
	btf_id 136836
	pids tetragon(864045)
131449: percpu_array  name process_call_he  flags 0x0
	key 4B  value 25608B  max_entries 1  memlock 102704B
	btf_id 136837
	pids tetragon(864045)
131450: array  name tg_mb_sel_opts  flags 0x0
	key 4B  value 12B  max_entries 5  memlock 344B
	btf_id 136838
	pids tetragon(864045)
131452: array_of_maps  name tg_mb_paths  flags 0x0
	key 4B  value 4B  max_entries 5  memlock 304B
	pids tetragon(864045)
131453: stack_trace  name stack_trace_map  flags 0x0
	key 4B  value 1016B  max_entries 1  memlock 1328B
	pids tetragon(864045)
131454: lru_hash  name socktrack_map  flags 0x0
	key 8B  value 16B  max_entries 1  memlock 1112B
	btf_id 136842
	pids tetragon(864045)
131455: lru_hash  name ratelimit_map  flags 0x0
	key 224B  value 8B  max_entries 1  memlock 1320B
	btf_id 136843
	pids tetragon(864045)
131456: hash  name override_tasks  flags 0x1
	key 8B  value 4B  max_entries 32768  memlock 525312B
	btf_id 136844
	pids tetragon(864045)
131457: array  name policy_conf  flags 0x0
	key 4B  value 1B  max_entries 1  memlock 272B
	btf_id 136845
	pids tetragon(864045)
131458: array  name policy_stats  flags 0x0
	key 4B  value 64B  max_entries 1  memlock 328B
	btf_id 136846
	pids tetragon(864045)
131459: percpu_array  name ratelimit_heap  flags 0x0
	key 4B  value 352B  max_entries 1  memlock 1680B
	btf_id 136847
131461: percpu_array  name string_prefix_m  flags 0x0
	key 4B  value 260B  max_entries 1  memlock 1328B
	btf_id 136849
131462: hash  name enforcer_missed  flags 0x0
	key 12B  value 4B  max_entries 128  memlock 12608B
	btf_id 136850
131463: percpu_array  name string_postfix_  flags 0x0
	key 4B  value 132B  max_entries 1  memlock 816B
	btf_id 136851
131465: percpu_array  name data_heap  flags 0x0
	key 4B  value 32768B  max_entries 1  memlock 131344B
	btf_id 136853
131468: percpu_array  name string_maps_hea  flags 0x0
	key 4B  value 16384B  max_entries 1  memlock 65808B
131472: hash  name tg_cgtracker_ma  flags 0x0
	key 8B  value 8B  max_entries 1  memlock 1392B
	btf_id 136860
131473: percpu_array  name heap  flags 0x0
	key 4B  value 4104B  max_entries 1  memlock 16688B
	btf_id 136861
131474: percpu_array  name tg_ipv6_ext_hea  flags 0x0
	key 4B  value 8B  max_entries 1  memlock 304B
	btf_id 136862
131476: hash  name enforcer_data  flags 0x0
	key 8B  value 12B  max_entries 1  memlock 1432B
	btf_id 136864
131480: percpu_array  name buffer_heap_map  flags 0x0
	key 4B  value 4352B  max_entries 1  memlock 17680B
	btf_id 136868
131482: array  name heap_ro_zero  flags 0x0
	key 4B  value 16384B  max_entries 1  memlock 16648B
	btf_id 136870
131483: hash  name string_maps_0_0  flags 0x0
	key 25B  value 1B  max_entries 5  memlock 1976B
131484: hash  name string_maps_1_0  flags 0x0
	key 49B  value 1B  max_entries 4  memlock 2016B
131485: hash  name string_maps_2_0  flags 0x0
	key 73B  value 1B  max_entries 1  memlock 1752B```
Looks like the main difference is the `process_call_heap` , `string_maps_heap`
I guess that's because I'm running Tetragon as a standalone container instead of in a cluster?

---

**Sam Wang** (2025-11-25 20:02):
Interesting!  What is you folks' Linux dist. and kernel version?  I've seen some inconsistent memory utilization on different kernels.  For example, my EKS (Amzn2 with 6.1 kernel) cluster uses much less memory than my Ubuntu laptop (24.04 with 6.14 kernels).

---

**Sam Wang** (2025-11-25 20:08):
My EKS has this map and it's pretty small:
```97590: percpu_array  name process_call_he  flags 0x0
	key 4B  value 25608B  max_entries 1  memlock 53248B
	btf_id 104367
	pids tetragon(3214364)```
but on my Ubuntu laptop it's 8x bigger.
```8196: percpu_array  name process_call_he  flags 0x0
	key 4B  value 25608B  max_entries 1  memlock 410000B
	btf_id 8847
	pids tetragon(77877)```

---

**Kyle Dong** (2025-11-25 20:47):
I guess it might be relate to how many cores of the CPU?
My VM is
```NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu

6.14.0-35-generic```
and the `process_call_he` usage is
```132893: percpu_array  name process_call_he  flags 0x0
	key 4B  value 25608B  max_entries 1  memlock 102704B
	btf_id 138338
	pids tetragon(864045)```

---

**Sam Wang** (2025-11-25 20:50):
I think it makes sense!  My EKS instance has 2 cores and my laptop has 16.

---

**Sam Wang** (2025-11-25 20:54):
This is probably not good news though...

---

**Alessio Biancalana** (2025-11-25 21:33):
So the more the cores the more the memory usage? O.o

---

**Sam Wang** (2025-11-25 22:05):
yep.  The `percpu_array` is the common way to avoid spinlock among CPUs.  From code, `process_call_heap` is used to implement the calling convention (https://en.wikipedia.org/wiki/Calling_convention) on tail calls and `string_maps_heap` is used to store arguments for string comparison later.  It would be a little hard to change I think...

---

**Sam Wang** (2025-11-25 22:26):
Some ideas:
• The value size of `process_call_heap` is determined by the size of `struct msg_generic_kprobe` per here (https://github.com/cilium/tetragon/blob/main/bpf/lib/generic.h#L65).  The MAX_PATH is usually 4096, and args is `24000` bytes long. There would be some room to adjust.  
• The size of `string_maps_heap` is 16384 (https://github.com/cilium/tetragon/blob/main/bpf/process/string_maps.h#L61), which is clearly too big too.

---

**Kyle Dong** (2025-11-26 15:10):
I’m feeling under the weather. Will take a sick leave for today.

---

**Alessio Biancalana** (2025-11-26 15:35):
with the amount of snow falling there you literally are under the weather

take care :heart:

---

**Andrea Terzolo** (2025-11-27 11:11):
Reasoning out of loud:
• for `process_call_heap` i'm not 100% sure we can reduce its size. Tetragon should be flexible enough to read 5 arguments of any length so the current size of  `24000` could be right (considering also there are arguments like iovec arrays https://github.com/cilium/tetragon/blob/7f09bfd2ca0123867bc7c2ab0155ac8efbc29ede/bpf/process/types/basic.h#L323). In our use case, we know the size of our argument for our hook but i'm not sure there is a clean way to reduce the size
• `buffer_heap_map` is again per-CPU and it seems to be used to reconstruct a path so again at least 4096+256 https://github.com/cilium/tetragon/blob/7f09bfd2ca0123867bc7c2ab0155ac8efbc29ede/bpf/lib/bpf_d_path.h#L42
• `heap` is again per-CPU and 4096 https://github.com/cilium/tetragon/blob/7f09bfd2ca0123867bc7c2ab0155ac8efbc29ede/bpf/process/heap.h#L33
• ...There are other per-CPU maps
This is a quick summary of the per-CPU maps i found in my system associated with each policy:

`process_call_heap` -> 25612 bytes * ncpu
`ratelimit_heap` -> 356 * ncpu
`buffer_heap_map` -> 4356 * ncpu
`heap` -> 4108 *ncpu
`string_postfix_` -> 136 * ncpu
`string_prefix_m` -> 264 * ncpu
`tg_ipv6_ext_heap` -> 16 * ncpu
`string_maps_heap` -> 16388 * ncpu
`data_heap` -> 32772 * ncpu

Doing the math -> 84008 bytes * ncpu.
• 16 CPUs -> ~1.3 MB for each policy
• 96 CPUs -> ~7,7 MB for each policy
To which we need to add  0,5 MB for our policy map + probably 0.1 MB for other tetragon maps (socktrack map and ovveride map are not considered in this computation)

• 16 CPUs -> ~1.9 MB for each policy (this is in line with what i see on my machine)
• 96 CPUs -> ~8.3 MB for each policy
---------------------------------------------------------------

Ideally, we could optimize some of them (even if i'm not sure upstream will accept this kind of patches):
`string_maps_heap` -> 4096 * ncpu
`data_heap` -> 4096(?) * ncpu
`process_call_heap` -> 4096(?) * ncpu

Doing the math -> 21524 bytes * ncpu.
• 16 CPUs -> ~0.33 MB for each policy
• 96 CPUs -> ~2 MB for each policy
Adding again 0.5 + 0.1

• 16 CPUs -> ~0.93 MB for each policy
• 96 CPUs -> ~2,6 MB for each policy
This is a more acceptable result...

Let me know if i missed something

---

**Andrea Terzolo** (2025-11-27 11:40):
I summarized the current performance situation here https://docs.google.com/document/d/1dHaPXOQttkg4Y2nUSasw8-YWneQ5PtjOii1nKQhI-sg/edit?usp=sharing

---

**Kyle Dong** (2025-11-27 14:33):
I’m still experiencing symptoms and don’t feel well. I’ll need to take another sick day to rest and recover. Sorry for any inconvenience.:doge_sad:

---

**Alessio Biancalana** (2025-11-27 14:34):
get well soon man :green_heart:

---

**Kyle Dong** (2025-11-27 14:36):
For what I did on Wednesday, I finished the coding part of #21 for optimizing with BPF_F_NO_PREALLOC with one global flag and an exception list flag. My initial test did well, just need to do more test then submit the commit

---

**Sam Wang** (2025-11-27 16:14):
I think it's pretty comprehensive!  Thanks a lot!

I read some document from AWS for this and here is my take:
• The max cores that a AWS EC2 instance (https://aws.amazon.com/ec2/instance-types/r8i/#:~:text=R8i%20instances%20scale%20up%20to%2096xlarge%20with,processing%20and%20improved%20scaling%20for%20database%20workloads.) supports is *384*.  I think we can treat this as the maximum we see in the wild.
• The RAM available on an EC2 instance depends on the number of cores.  The instance type that comes with the least RAM is *Compute optimized instances (c8i)*, where 2GiB per core is provided.  
• The instance with a lot of cores is pretty expensive. c8i.96xlarge (384 cores) costs $17.99232/hour.  The more efficient way is to scale horizontally instead of vertically.
TL; DR, I think the maximum of 384 cores and 2GiB per core could be a good start for us to define environments that we can support.  This way we don't have to consider instances like 384 cores with only 16 GiB of RAM, or something like that.

---

**Andrea Terzolo** (2025-11-27 16:27):
yep seems fair as a comparison model

---

**Kyle Dong** (2025-11-28 15:21):
Thanks for summarize this new findings. Since I'm discussing with them the memory footage optimization, I can create a new issue based on our findings and propose to them to reduce the footage of the following 3 maps
```string_maps_heap -&gt; 4096 * ncpu
data_heap -&gt; 4096(?) * ncpu
process_call_heap -&gt; 4096(?) * ncpu```
WDYT?

---

**Andrea Terzolo** (2025-11-28 16:02):
&gt; I can create a new issue based on our findings and propose to them to reduce the footage of the following 3 maps
reporting our findings is a good thing for sure, we can also report them here https://github.com/cilium/tetragon/issues/4191 if we want. In any case i would keep the discussion separate from what you are doing now (`BPF_F_NO_PREALLOC`), i'm not even sure we want to tackle these new findings in the short term, maybe it is something we can do later

---

**Kyle Dong** (2025-11-28 16:09):
&gt; in any case i would keep the discussion separate from what you are doing now (`BPF_F_NO_PREALLOC`)
Yeah, I totally agree. Even if we want to report, it should be a new issue.
I think adding it into https://github.com/cilium/tetragon/issues/4191 will be a good idea. The only concern is this issue seems too big to track.
&gt; i'm not even sure we want to tackle these new findings in the short term, maybe it is something we can do later
Yeah, maybe we can discuss in our next backlog revisit meeting do we need it for MVP or later.

---

**Andrea Terzolo** (2025-11-28 16:10):
yep fill free to open a new issue and maybe just link it to https://github.com/cilium/tetragon/issues/4191, thank you for this!

---

**Andrea Terzolo** (2025-11-28 18:55):
ei guys! what is the best way to debug our e2e tests in runtime-enforcer repo? it seems that `make test-e2e` recreate a new kind cluster each time it is called. Is there a way to just rerun a single test without recreating the cluster?

---

**Alessio Biancalana** (2025-11-28 20:04):
Not that I know actually, when we get back from hackweek I’ll inspect the makefile and help you figure that out

---

**Sam Wang** (2025-12-01 20:40):
yeah this part still needs some love.  The plan was to revisit this when we work on this issue (https://github.com/neuvector/runtime-enforcer/issues/23), so it can support existing clusters without creating one.

For now, I'd build the container image locally with `make build-operator-image && make build-daemon-image` and run the test in vscode by clicking `debug test`.

Then you will be able to set breakpoint or something.

---

**Sam Wang** (2025-12-02 14:09):
Can I safely assume that the standup today is cancelled as everyone is on hack week? :eyes:

---

**Andrea Terzolo** (2025-12-02 14:34):
i would say yes!

---

**Alessio Biancalana** (2025-12-02 16:16):
all standups are canceled since everybody is hacking :fire: :smile:

---

**Alessio Biancalana** (2025-12-06 00:37):
Just a little heads up that it’s gonna be a bank holiday in Italy on Monday :grimacing: so Andrea and I won’t be around

---

**Kyle Dong** (2025-12-08 15:53):
Good news, I got a reply from upstream, and they agree to do the refactoring in a separate issue.

---

**Kyle Dong** (2025-12-09 14:28):
I'll rejoin

---

**Kyle Dong** (2025-12-09 14:28):
the network seems not great today

---

**Alessio Biancalana** (2025-12-10 09:32):
rework of the WorkloadPolicyProposal CRD available at https://github.com/neuvector/runtime-enforcer/pull/72

---

**Alessio Biancalana** (2025-12-10 12:24):
@Kyle Dong I implemented the last two feedbacks you gave me :+1: https://github.com/neuvector/runtime-enforcer/pull/76

---

**Alessio Biancalana** (2025-12-11 09:23):
I won't be around today and tomorrow since I'm getting married and I needed a couple days off to arrange the last things :grimacing:

---

**Kyle Dong** (2025-12-11 09:27):
Congratulations on your upcoming wedding! Enjoy the big day!

---

**Bram Schuur** (2025-12-11 11:41):
Fantastic! Have a great time!

---

**Andrea Terzolo** (2025-12-11 15:04):
Hi all, as anticipated during the hackweek, I worked on a possible replacement for *Tetragon with a custom-built agent*. The primary goal of this exploration was to address the persistent *performance issues* we've encountered by focusing only on the specific Tetragon features we truly need.

What I did was primarily to take the essential parts of Tetragon we require and rework them. It turned out they are not too many...

## Current Implementation Status

The current implementation is near *feature parity* with our existing `main` branch, though we still missing at least these important features:

* *OCI Hook Support:* This is needed to resolve cgroup IDs immediately when a container is created, eliminating latency. Without it, initial container processes might be missed in e2e tests.
* *Initial Process Collection:* We need to collect initial processes from `/proc` (noticable when creating proposals in a cluster with existing deployments).
* *WorkloadPolicy Allowed Binaries Update:* On the `main` branch, we currently delete and redeploy the Tetragon policy. With the new implementation, updating the eBPF map is sufficient, but this specific update code is still missing.
* *Error Reporting:* We should store errors for WP inside each agent and expose them via gRPC (similar to what was done in https://github.com/neuvector/runtime-enforcer/pull/73). More generally, we should port that PR's logic to this new implementation.

## Notes and Environment

* *Local Dev:* `tilt up` is working as before, so our development environment is unchanged if you want to test it.
* *Testing:* Unit tests and e2e tests are running with minor adjustments (see `todo!:` in e2e tests).
* *Code Quality:* I still need to fix some linting issues and the code is still in a pretty raw status
* *Ready Status:* Of course, the code is *not yet production ready*. There are many `todo!:` notes in the code to track possible improvements/cleanups/missing features

## Idea

This implementation is a *proof-of-concept/starting point* to demonstrate that an alternative exists which could potentially resolve our performance bottlenecks.
*We do not have to pursue this path*, but I wanted to present a concrete option. I'd love to hear your feedback. Curious to know what you think about this first implementation!

The attached PR https://github.com/neuvector/runtime-enforcer/pull/79 is a Work-In-Progress and is intended for demonstration and testing *of the overall architectural approach*, not a final line-by-line review. There will certainly be some bugs, so please be patient!

---

**Sam Wang** (2025-12-11 15:33):
Congrats! :bouquet: :wedding:

---

**Sam Wang** (2025-12-11 16:20):
:question: I'm re-reading the RFC about the new CRD.  Is it just me or this part feels a little weird?  My understanding is that we will use  (https://github.com/neuvector/runtime-enforcer/pull/45#discussion_r2559085891)security.rancher.io/policy (https://github.com/neuvector/runtime-enforcer/pull/45#discussion_r2559085891)&lt;https://github.com/neuvector/runtime-enforcer/pull/45#discussion_r2559085891%7C: &lt;policy-name&gt;&gt;. What is the role of the `default k8s workload selectors` in the `Basic user` scenario?

---

**Davide Iori** (2025-12-11 17:02):
Congratulations Alessio!
Daje tutta

---

**Davide Iori** (2025-12-11 17:07):
Hi team, can you leave in the thread your link to the hackweek projects *in case they are somehow related to domain of Cloud native security*? I want to collect them all so that new cool ideas can become features for our customers

---

**Andrea Terzolo** (2025-12-11 17:09):
Uhm it seems a leftover... IIRC the last version was without the Selector on the WorkloadPolicy

---

**Sam Wang** (2025-12-11 17:40):
Here is what I did: https://hackweek.opensuse.org/25/projects/ebpf-resource-isolation-using-tetragon

There are still limitations and the source code needs some clean up, but it's here (https://github.com/holyspectral/tetragon/tree/hackweek-25).

---

**Sam Wang** (2025-12-11 18:00):
@Andrea Terzolo did you upload go files generated by cilium/ebpf?  It complains about missing `bpfObjects` or `bpfLoadConf` .

---

**Andrea Terzolo** (2025-12-11 18:03):
i didn't upload them because i'm not sure about the best practice here, if we need to store them within the git repo or not... btw there should be a makefile target to generate them `generate-ebpf` that should generate them by default where required. Where did you face the error?

---

**Sam Wang** (2025-12-11 18:03):
yeah I tried that and it fails to find libbpf.  I was trying to find that for my distribution before I joined the meeting that I'm in. lol

---

**Andrea Terzolo** (2025-12-11 18:06):
oh i see i can upload them so that you can try without having libbpf

---

**Sam Wang** (2025-12-11 18:07):
yeah or we can upload bpf_helpers.h.  I see Tetragon has that in its repo.

---

**Andrea Terzolo** (2025-12-11 18:08):
yeah that's also an option, for now i've just updated the bpf artifacts

---

**Sam Wang** (2025-12-11 18:09):
yeah that could be a temporary solution.  I know the object file generated by cilium/ebpf is very big.

---

**Flavio Castelli** (2025-12-12 14:26):
yeah, it's a left over. Can you make a PR to clean this up?

---

**Flavio Castelli** (2025-12-12 14:56):
folks, I'm a bit lost with the current state of the revised CRDs

---

**Sam Wang** (2025-12-12 15:31):
It looks like @Alessio Biancalana's change is in crd-rework (https://github.com/neuvector/runtime-enforcer/commits/crd-rework/) branch despite PRs merged, so it does seem a little confusing.
From high level I think the current state is: (@Alessio Biancalana @Kyle Dong please correct me if I'm wrong.)
• WorkloadPolicyProposal
    ◦ Functionality is ready.  (rulesByContainer)
    ◦ Not renamed yet.
• WorkloadPolicy
    ◦ Functionality is NOT ready.
    ◦ Not renamed yet.
• ClusterWorkloadSecurityPolicy
    ◦ Removed.

---

**Sam Wang** (2025-12-12 15:34):
yeah I can do that.

On the other hand, I also noticed that the RFC mentioned the name of `ContainerPolicy` but no description at all about how this CR works.

---

**Flavio Castelli** (2025-12-12 16:01):
I think it's a good thing that the work is happening inside of a branch. Because many things have to be changed and stuff is going to be in a broken state until everything is changed

---

**Flavio Castelli** (2025-12-12 16:02):
@Kyle Dong I would make your PR about the admission controller (the one I reviewed yesterday) against that branch, it's useless to build all the logic of finalizer removal against the more complicated CRD that we have right now

---

**Sam Wang** (2025-12-13 03:56):
Just finished my first round.  Overall I'm impressed that you put pieces from Tetragon together in this short time frame!  I didn't see significant design issues and I can see a few previous upstream issues addressed.  While there might still be more work, I do believe that having our own implementation like this is a right direction.

My only concern is, is it a good idea to port Tetragon's code/implemetation this way into our repo?  I don't mean the license issue because they're all GPL/Apache 2.0, and I understand that many rewrites are already in place.  It's more about losing the original context and possible backlash from Tetragon community.  I can also see that it will be hard to apply an upstream patch in the future.  I'm not sure if rewriting from scratch would be worth it, but it feels like we should keep documentation/records at least.  Except that I think it's really good actually.

If we go with this implementation, in addition to the TODOs you mentioned, IMO these tasks are important too:

• Define V1 scope, especially in events metadata, e.g., time, pid, cmdline as they were requested by PM before.
• Mount bpffs from host and pin our ebpf programs to prevent protection loss.
• Test automation for ebpf programs across different kernels.  Tetragon's vmtest (https://tetragon.io/docs/contribution-guide/running-tests/#test-specific-kernels) running on micro vms would be useful.  
I want to keep this short so I will leave other technical items for later. lol It's great to see such completeness in the code!  I will spend some more time to play with it to see if I have any other findings.

Note: These issues could be easily resolved with these new codes:

• process events don't have symlink resolved.
• actions trigged by kubectl exec don't have event metadata.
• monitor/enforce events are not actionable

---

**Kyle Dong** (2025-12-14 13:18):
@Flavio Castelli, thanks for the advice and I totally agree.
I worked on that PR because I expected the CRD rework will take some time. @Alessio Biancalana had been working on the rework for *WorkloadSecurityPolicyProposal*, and the *WorkloadSecurityPolicy* rework depends on the proposal changes.
So I thought it would be a good use of time to start working on the mutating admission controller in the meantime.
If there is no objection, I’ll close this PR for now. However, it should be a good reference once the CRDs rework is complete. At that point, I can quickly pick up this changeset and adapt it to the new simplified CRD.

---

**Andrea Terzolo** (2025-12-15 09:41):
Thank you for taking the time to look into this!

&gt; I can also see that it will be hard to apply an upstream patch in the future. I'm not sure if rewriting from scratch would be worth it, but it feels like we should keep documentation/records at least.
That is a very good point. I have to admit that while this project started as a rewrite of Tetragon, the implementation has significantly diverged to be tailored for our specific use case.
Regarding future upstream patches: I believe it's more realistic to maintain links to the original Tetragon implementation where the code is still related. If we encounter a bug, we can check how the upstream code handles it, but I don't think we will be able to directly apply upstream patches to our repository.
Since this is no longer a simple "fork" but a custom codebase that we fully own, I'm not overly concerned about merging upstream patches. We should, however, definitely add relevant links to the initial code source for documentation purposes. WDYT?

&gt; If we go with this implementation, in addition to the TODOs you mentioned, IMO these tasks are important too
I totally agree. And there are likely other tasks as well. We just need to define the scope for our initial MVP.

---

**Flavio Castelli** (2025-12-15 11:07):
don't close it, leave it as a draft

---

**Flavio Castelli** (2025-12-15 11:43):
I've taken a look at the PR created by @Andrea Terzolo, the one that introduces the new agent and replaces tetragon. I see the comment about it has been positive also from the others (see the thread from above (https://suse.slack.com/archives/C09KMBW6DA5/p1765461887167959)).

I propose to move forward in this way:
• Merge the PR from Andrea ASAP
• Keep track of all the technical debt: have issues filed for each `TODO` item andrea put into the PR
• Put on hold the work on the new CRDs, finalizer until the PR is merged (or start rebasing on top of that PR already)
I think it's reasonable to have maybe something broken on the `main` branch. Nobody is using the project right now, the source code is not even public. However, if you prefer, we could do all the work inside of a feature branch.

What do you think?

---

**Kyle Dong** (2025-12-15 12:01):
I would prefer if we can focus on reviewing and merging @Andrea Terzolo’s PR into `main` branch ASAP. It will give us a stable baseline and avoid duplicating work.

---

**Alessio Biancalana** (2025-12-15 12:03):
same from me, I'm totally positive about getting @Andrea Terzolo's work merged. This plan sounds very very good :+1:

---

**Andrea Terzolo** (2025-12-15 13:00):
Thank you for taking a look! yeah if we decide to go with this approach it would be great to avoid concurrent work that could cause painful and error prone rebase :confused:
Yes, if we are convinced by the approach i wouldn't probably focus too much on the implementation details, this is something we can always improve/fix in follow up PRs. The important thing is to have something that works and on which we can do the CRD rework and add new features.
On my side i'm trying to fix the latest linting issues, everything should be ready within today :crossed_fingers:

---

**Sam Wang** (2025-12-15 16:22):
yeah I think that's a good plan.  I will start looking into it in deep after it's marked as ready for review.

I'd also propose we remove those TODOs in the code when we create corresponding tasks in GitHub.  We don't need to keep them in two places.

---

**Alessio Biancalana** (2025-12-15 16:25):
&gt; I will start looking into it in deep after it's marked as ready for review
@Sam Wang what do you think about merging the current state and go through a review once we have it on main?

---

**Flavio Castelli** (2025-12-15 16:26):
I'm fine adding the issues after the PR is merged if that speeds the merging process, basically now we're blocked by this PR not being into main

---

**Sam Wang** (2025-12-15 16:34):
Sure, merging it as it is doesn't seem too bad.  I can leave my comments along with commits, so we still have track of discussion.

---

**Flavio Castelli** (2025-12-15 16:43):
good, let's move forward with all the other PRs once this is merged. @Sam Wang: don't forget to file issues if you find something that is missing or that should be refactored in the future. Let's keep track of our technical debt :muscle::skin-tone-3:

---

**Andrea Terzolo** (2025-12-15 16:43):
uhm ok sounds good to me, i just realized i need to sign the commit (no sure why git didn't do that this time :party_dead: )

---

**Andrea Terzolo** (2025-12-15 16:44):
i will open all the issues with missing features/todo

---

**Andrea Terzolo** (2025-12-15 17:08):
merged :merged: :partygeeko:

---

**Andrea Terzolo** (2025-12-15 17:22):
for some reason github issue type is broken, i will add the type when it works again

---

**Alessio Biancalana** (2025-12-15 17:27):
I'm going to rebase `crd-rework` against main now @Andrea Terzolo

---

**Andrea Terzolo** (2025-12-15 17:50):
@Sam Wang i noticed that we are opening issue in parallel and some of them are in someway overlapping like https://github.com/neuvector/runtime-enforcer/issues/94 and https://github.com/neuvector/runtime-enforcer/issues/88. Should i first open all issues related to `todo!:` ? in this way you can double check what is missing and integrate with new info in existing issues or creating new ones

---

**Sam Wang** (2025-12-15 17:52):
yeah I noticed it too.  I'd prefer we create them in parallel and close them as duplicate later.  This way we can also merge the information in two cases later without blocking each other now.  What do you think?

---

**Andrea Terzolo** (2025-12-15 17:55):
yep that's fine, moreover i will go offline in few minutes so probably there is no overlap :joy:  i will double check tomorrow what you opened :+1:

---

**Sam Wang** (2025-12-15 17:57):
yeah for now let's make sure that all issues we know are there.  Backlogs can be groomed later as long as they're not too crazy.

---

**Sam Wang** (2025-12-15 18:25):
Hi team, @Andrea Terzolo and I have a question about base images in issue#92 (https://github.com/neuvector/runtime-enforcer/issues/92).  Any thoughts on using public golang images instead of BCI images?  We used BCI images before to sync with other rancher projects, but I'm not sure if we still need to do that.  The problem of BCI images is that it doesn't have libraries that we need to build ebpf programs, and it's usually slower than the official golang images.

---

**Alessio Biancalana** (2025-12-15 18:47):
@Kyle Dong and everybody interested, I rebased `crd-rework` against `main`  :+1:

---

**Kyle Dong** (2025-12-16 07:19):
Hi @Alessio Biancalana, I noticed that you’ve created a draft PR for the CRD rework from `crd-rework` to `main`. Are we planning to merge it piece by piece, or do we want to complete all the rework in `crd-rework` first and then merge it in one go?

---

**Kyle Dong** (2025-12-16 07:49):
@Andrea Terzolo, I just finished briefly reviewing your agent rework PR (#79) which is really impressive work in a week! The architecture looks great and I love how clean the component separation is.
I’m going to check which issues have already been created and may file new ones based on my findings or from the Todo list in the code.

---

**Alessio Biancalana** (2025-12-16 09:25):
We are aiming for completing the whole rework in that branch first and then merge it. I just created the PR to have a bit of visual feedback about the CI and the commits on the fly :sweat_smile:

---

**Kyle Dong** (2025-12-16 09:54):
IMO, I think switching to the official Golang image is reasonable and more practical here.
We originally used BCI images mainly to stay aligned with other Rancher projects, but I checked Kubewarden and it’s using the official Golang image. If we’re planning to be part of Kubewarden, I think it’s safe and consistent to switch to the official Golang image as well:grinning:

---

**Andrea Terzolo** (2025-12-16 10:17):
thank you for taking a look! yep i agree, in the end we are always in time to switch back if we find some issues

---

**Andrea Terzolo** (2025-12-16 10:17):
i will do the PR to fix https://github.com/neuvector/runtime-enforcer/issues/92

---

**Andrea Terzolo** (2025-12-16 11:00):
https://github.com/neuvector/runtime-enforcer/pull/108 it is failing because i changed also the operator image and in the main branch we still use `registry.suse.com/bci/golang (http://registry.suse.com/bci/golang)` so there is no match. it seems the tool always looks at the dockerfiles on the main branch

---

**Andrea Terzolo** (2025-12-16 11:01):
uhm this is not related to your changes i think we can merge it :merged:

---

**Kyle Dong** (2025-12-16 11:10):
Yeah, I think it's not related to my changes. I'll just merge it.:grinning:

---

**Alessio Biancalana** (2025-12-16 12:06):
thanks @Kyle Dong, much appreciated :green_heart: I think I can start with the WorkloadPolicy then :smile:

---

**Alessio Biancalana** (2025-12-16 12:18):
fix for helm-unittest https://github.com/neuvector/runtime-enforcer/pull/110

---

**Davide Iori** (2025-12-16 13:20):
Kudos to @Alessio Biancalana and @Flavio Castelli who yesterday joined a sync with the Field (DSAs, Support engineers with daily interaction with Neuvector customers) where we shared the design choices we made for the Process enforcer. We received positive feedback from the audience and a few aspects stood out based on what the audience shared:
• truly k8s native, CRDs for everything: that's the way to go
• Everyone was very happy we kept the existing UX around Learn - Monitor - Enforce
• Although not planned for the first iteration, templating is necessary for certain customers which have built more advanced workflows leveraging custom groups (https://open-docs.neuvector.com/policy/groups#custom-group-examples).
• File system access enforcement: not the primary use case --&gt; *This is a feedback based on experience, we do not have real telemetry data*
As a take away from the call, the absence of product telemetry data is a clear gap which every ECM team should help closing so that we can make more informed decisions in the future. FYI @Flavio Castelli I know @Sheng Yang wants to do more in that direction and I fully support this.

Last but not least, kudos to the whole team. We are on the right path :muscle:

Flavio, Alessio feel free to add more in case I forgot other aspects

---

**Andrea Terzolo** (2025-12-16 15:42):
just for context, the new issues i opened in the repo don't have the `type` becuase for some reason github doesn't allow me to do that...not sure if this was always like that or it is a new thing :man-shrugging:

---

**Andrea Terzolo** (2025-12-16 15:43):
and for some weird reason i cannot tag Sam with @holyspectral (https://github.com/holyspectral) anymore on github :party_dead:

---

**Sam Wang** (2025-12-16 15:45):
:face_with_raised_eyebrow: It seems like a permission issue.  Let me take a look.

---

**Sam Wang** (2025-12-16 15:50):
hmm your permission is exactly the same with Kyle or Flavio.  Not sure what could go wrong.  Could you logout and re-log in to see if the issue is still persistent?

---

**Andrea Terzolo** (2025-12-16 16:00):
just tried but it didn't help :confused:

---

**Sam Wang** (2025-12-16 16:01):
For troubleshooting I will change you to an admin and see if that changes anything.

---

**Sam Wang** (2025-12-16 16:02):
ok done.  Could you try again?  Team members by default have `write`
permission, and it's supposed to have permission to manage issues...

---

**Andrea Terzolo** (2025-12-16 16:03):
nope it doesn't work, i will try to logout/login

---

**Andrea Terzolo** (2025-12-16 16:05):
maybe it is a transitory issue with github... BTW thank you for the help!

---

**Andrea Terzolo** (2025-12-16 16:06):
for now i can probably live without it, let's see if it goes away :man-shrugging:

---

**Sam Wang** (2025-12-16 23:09):
Just noticed that auto-merge was disabled in the new repo, so I've re-enabled it.  Enjoy! :merged-pull-request:

---

**Kyle Dong** (2025-12-17 07:40):
Oops, I forgot the auto-merge was enabled, just approved your PR and leave a comment with fixing an incomplete leftover line:rolling_on_the_floor_laughing:
I think we can fix it in the next PR:slightly_smiling_face:

---

**Sam Wang** (2025-12-17 14:17):
Oops you're right.  Let me work on it.

---

