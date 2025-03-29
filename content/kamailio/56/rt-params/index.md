---
title: "1.13 实时参数"
draft: false
tags:
- all
categories:
- all
---



# 1. real_time

Sets real time priority for all the Kamailio processes, or the timers
(bitmask).

       Possible values:   0  - off
                          1  - the "fast" timer
                          2  - the "slow" timer
                          4  - all processes, except the timers
       Example: real_time= 7 => everything switched to real time priority.

    real_time = <int> (flags) (default off)

# 2. rt_policy

Real time scheduling policy, 0 = SCHED_OTHER, 1= SCHED_RR and
2=SCHED_FIFO

    rt_policy= <0..3> (default 0)

# 3. rt_prio

Real time priority used for everything except the timers, if real_time
is enabled.

    rt_prio = <int> (default 0)

# 4. rt_timer1_policy

**Alias name:** **rt_ftimer_policy**

Like rt_policy but for the "fast" timer.

    rt_timer1_policy=<0..3> (default 0)

# 5. rt_timer1_prio

**Alias name:** **rt_fast_timer_prio, rt_ftimer_prio**

Like rt_prio but for the "fast" timer process (if real_time & 1).

    rt_timer1_prio=<int> (default 0)

# 6. rt_timer2_policy

**Alias name:** **rt_stimer_policy**

Like rt_policy but for the "slow" timer.

    rt_timer2_policy=<0..3> (default 0)

# 7. rt_timer2_prio

**Alias name:** **rt_stimer_prio**

Like rt_prio but for the "slow" timer.

    rt_timer2_prio=<int> (default 0)
