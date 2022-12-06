---
title: "Improved series-based call statistics using OpenSIPS 3.2"
date: "2021-02-11 20:11:43"
draft: false
---
> 早期1x和2x版本的OpenSIPS，统计模块只有两种模式，一种时计算值，另一种是从运行开始的累加值。而无法获取比如说最近一分钟，最近5分钟，这样的基于一定周期的统计值，在OpenSIPS 3.2上，提供了新的解决方案。


原文：[https://blog.opensips.org/2021/02/02/improved-series-based-call-statistics-using-opensips-3-2/](https://blog.opensips.org/2021/02/02/improved-series-based-call-statistics-using-opensips-3-2/)

Real-time call statistics is an excellent tool to evaluate the quality and performance of your telephony platform, that is why it is very important to expose as many statistics as possible, accumulated over different periods of time.<br />OpenSIPS provides an easy to use [interface](https://www.opensips.org/Documentation/Interface-Statistics-3-2) that exposes simple primitives for creating, updating, and displaying various statistics, both [well defined](https://www.opensips.org/Documentation/Interface-CoreStatistics-3-2) as well as tailored to your needs. However, the current implementation comes with a limitation: statistics are gathered starting from the beginning of the execution, up to the point they are read. In other words, you cannot gather statistics only for a limited time frame.<br />That is why starting with OpenSIPS 3.2, the statistics module was enhanced with a new type of statistics, namely statistics series, that allow you to provide custom stats accumulated over a specific time window (such as one second, one minute, one hour, etc.). When the stat is evaluated, only the values gathered within the specified time window is accounted, all the others are simply dropped (similar to a time-based circular buffer, or a sliding window). Using these new stats, you can easily provide standard statistics such as ACD, AST, PPT, ASR, NER, CCR in a per minute/hour fashion.

## Profiles
In order to use the statistics series you first need to define a statistics profile, which describes certain properties of the statistics to be used, such as:

- the duration of the time frame to be used – the number of seconds worth of data that should be accumulated for the statistics that use this profile; all data gathered outside of this time window is discarded
- the granularity of the time window – the number of slots used for each series – the more slots, the more accurate the statistic is, with a penalty of an increased memory footprint
- how to [group](https://opensips.org/docs/modules/3.2.x/statistics.html#idp3070208) statistics to make them easier to process
- the processing algorithm – or how data should be accumulated and interpreted when the statistic is evaluated; this is presented in the next chapter

The profile needs to be specified every time data is pushed in a statistic series, so that the engine knows how to process it.

## Algorithms
The statistics series algorithm describe how the data gathered over the specified time window should be processed. There are several algorithms available:

- accumulate – this is useful when you want to count the number of times a specific event appears (such as number of requests, replies, dialogs, etc); for this algorithm, the statistic is represented as a simple counter that accumulates when data is fed, and is decreased when data (out of the sliding window) expires
- average – this is used to compute an average value over the entire window frame; this is useful to compute average call duration (ACD) or average post dial delay (PDD) over a specified time window
- percentage – used to compute the percentage of some data out of a total number of entries; useful to compute different types of ratios, such as Answer-seizure ratio (ASR), NER or CCR

## Usage
The new functionality can be leveraged by defining one (or more) [stat_series_profile](https://opensips.org/docs/modules/3.1.x/statistics.html#param_stat_series_profile)s, and then feed data to that statistic according to your script’s logic using the [update_stat_series()](https://opensips.org/docs/modules/3.1.x/statistics.html#func_update_stat_series) function. In order to evaluate the result of the stats, one can use the [$stat()](https://opensips.org/docs/modules/3.1.x/statistics.html#pv_stat) variable from within OpenSIPS’s script, or access it from outside using the [get_statistics](https://www.opensips.org/Documentation/Interface-CoreMI-3-2#toc12) MI command.<br />As a quick theoretical example, let us consider creating two statistics: one that counts the number of initial INVITE requests per minute your platform receives, and another one that shows the ratio of the INVITE requests out of all the other requests received.<br />First, we shall define the two profiles that describe how the new statistics should be interpreted: the first one, should be a counter that accumulates all the initial INVITEs received in one minute, and the second one should be a percentage series, is incremented for initial INVITEs, and decremented for all the others. Both statistics series will use a 60s (one minute) window:<br />modparam("statistics", "stat_series_profile", "inv_acc_per_min: algorithm=accumulate window=60")<br />modparam("statistics", "stat_series_profile", "inv_perc_per_min: algorithm=percentage window=60")<br />Now, in the main route, we shell update statistics with data:<br />...<br />route {<br />    ...<br />    if (is_method("INVITE") && has_totag()) {<br />        update_stat_series("inv_acc_per_min", "INVITE_per_min", "1");<br />        update_stat_series("inv_perc_per_min", "INVITE_ratio", "1");<br />    } else {<br />        update_stat_series("inv_perc_per_min", "INVITE_ratio", "-1");<br />    }<br />    xlog("INVITEs per min $stat(INVITE_per_min) represents $stat(INVITE_ratio)% of total requests\n");<br />    ...<br />}<br />...<br />You can query these statistics through the MI interface by running:<br />opensips-cli -x mi get_statistics INVITE_per_min INVITE_ratio

## Use case
In a production environment, the KPIs you provide your customers are very important, as they describe the quality of the service you provide. Some of these are quite standard indices (ACD, ASR, AST, PDD, NER, CCR), that are relevant for specific period of times (one minute, ten minutes, one hour). In the following paragraphs we will see how we can provide these statistics on a customer basis, as well as overall.<br />First, we need to understand what each stat represents, to understand the logic that has to be scripted:

- _ASR (Answer Seizure Ratio)_ – the percentage of telephone calls which are answered (200 reply status code)
- _CCR (Call Completion Ratio)_ – the percentage of telephone calls which are signaled back by the far-end client. Thus, 5xx, 6xx reply codes and internal 408 timeouts generated before reaching the client do not count here. The following is always true: CCR >= ASR
- _PDD (Post Dial Delay) _– the duration, in milliseconds, between the receival of the initial INVITE and the receival of the first 180/183 provisional reply (the call state advances to _“ringing”_)
- _AST (Average Setup Time)_ – the duration, in milliseconds, between the receival of the initial INVITE and the receival of the first 200 OK reply (the call state advances to _“answered”_). The following is always true: AST >= PDD
- _ACD (Average Call Duration)_ – the duration, in seconds, between the receival of the initial INVITE and the receival of the first BYE request from either participant (the call state advances to _“ended”_)
- _NER (Network Effectiveness Ratio)_ – measures the ability of a server to deliver the call to the called terminal; in addition to ASR, NER also considers busy and user failures as success

Now that we know what we want to see, we can start scripting: we need to load the statistics module, and define two types of profiles: one that computes average indices (used for AST, PDD, ACD), and one for percentage indices (used for ASR, NER, CCR). For each of them, we define 3 different time windows: per minute, per 10 minutes and per hour:

```bash
loadmodule "statistics.so"
modparam("statistics", "stat_series_profile", "perc: algorithm=percentage group=stats")
modparam("statistics", "stat_series_profile", "10m-perc: algorithm=percentage window=600 slots=10 group=stats_10m")
modparam("statistics", "stat_series_profile", "1h-perc: algorithm=percentage window=3600 slots=6 group=stats_1h")
modparam("statistics", "stat_series_profile", "avg: algorithm=average group=stats")
modparam("statistics", "stat_series_profile", "10m-avg: algorithm=average window=600 slots=10 group=stats_10m")
modparam("statistics", "stat_series_profile", "1h-avg: algorithm=average window=3600 slots=6 group=stats_1h")
```

In order to catch all the relevant events we need to hook on, we will be using the [E_ACC_CDR](https://opensips.org/docs/modules/3.1.x/acc.html#event_E_ACC_CDR) and [E_ACC_MISSED_EVENT](https://opensips.org/docs/modules/3.1.x/acc.html#event_E_ACC_CDR) events exposed by the accounting module. In order to have identify the customer that the events were triggered for, we need to export the customer’s identifier in the event:

```bash
loadmodule "acc.so"
modparam("acc", "extra_fields","evi: customer")

route {
    ...
    if (has_totag() && is_method("INVITE")) {
        do_accounting("evi", "cdr|missed");
        t_on_reply("stats");
        # store the moment the call started
        get_accurate_time($avp(call_start_s), $avp(call_start_us));
        # TODO: store the customer's id in $acc_extra(customer)
    }
    ...
}
```

When a reply comes in, our “stats” reply route will be called, where we will update all the statistics, according to our logic. Because we need to compute them twice, once for global statistics, and once for customer’s one, we will put the logic in a new route, “calculate_stats_reply”, that we call when a reply comes in:

```bash
onreply_route[stats] {
    route(calculate_stats_reply, $avp(call_start_s), $avp(call_start_us), "");
    route(calculate_stats_reply, $avp(call_start_s), $avp(call_start_us), $acc_extra(customer));
}
route[calculate_stats_reply] {
    # expects:
    # - param 1: timestamp (in seconds) when the initial request was received
    # - param 2: timestamp (in microseconds) when the initial request was received
    # - param 3: statistic identifier; for global, empty string is used
    if ($rs == "180" || $rs == "183" || $rs == "200"
            || $rs == "400" || $rs == "403" || $rs == "408
            || $rs == "480" || $rs == "487") {
        if (!isflagset("FLAG_PDD_CALCULATED")) {
            get_accurate_time($var(now_s), $var(now_us));
            ts_usec_delta($var(now_s), $var(now_us), $param(1), $param(2), $var(pdd_us));
            $var(pdd_ms) = $var(pdd_us) / 1000; # milliseconds
            $avp(pdd) = $var(pdd_ms);
            setflag("FLAG_PDD_CALCULATED");
        } else {
            $var(pdd_ms) = $avp(pdd);
        }
        update_stat_series("avg", "PDD$param(3)", $var(pdd_ms));
        update_stat_series("10m-avg", "PDD_10m$param(3)", $var(pdd_ms));
        update_stat_series("1h-avg", "PDD_1h$param(3)", $var(pdd_ms));
    }
    if ($rs >= 200 && $rs < 300) {
        update_stat_series("perc", "ASR$param(3)", 1);
        update_stat_series("10m-perc", "ASR_10m$param(3)", 1);
        update_stat_series("1h-perc", "ASR_1h$param(3)", 1);
        update_stat_series("perc", "NER$param(3)", 1);
        update_stat_series("10m-perc", "NER_10m$param(3)", 1);
        update_stat_series("1h-perc", "NER_1h$param(3)", 1);
        update_stat_series("perc", "CCR$param(3)", 1);
        update_stat_series("10m-perc", "CCR_10m$param(3)", 1);
        update_stat_series("1h-perc", "CCR_1h$param(3)", 1);
        get_accurate_time($var(now_s), $var(now_us));
        ts_usec_delta($var(now_s), $var(now_us), $param(1), $param(2), $var(ast_us));
        $var(ast_us) = $var(ast_us) / 1000; # milliseconds
        update_stat_series("avg", "AST$param(3)", $var(ast_us));
        update_stat_series("10m-avg", "AST_10m$param(3)", $var(ast_us));
        update_stat_series("1h-avg", "AST_1h$param(3)", $var(ast_us));
    }
}
```
In case of a successful call, the dialog generates a CDR, that we use to update our ACD statistics:

```bash
event_route[E_ACC_CDR] {
    route(calculate_stats_cdr, $param(duration), $param(setuptime), "");                             
    route(calculate_stats_cdr, $param(duration), $param(setuptime), $param(customer));
}
route[calculate_stats_cdr] {
    # expects:
    # - param 1: duration (in seconds) of the call
    # - param 2: setuptime (in seconds) of the call
    # - param 3: optional - statistic identifier; global is empty string
    $var(total_duration) = $param(1) + $param(2);
    update_stat_series("avg", "ACD$param(3)", $var(total_duration));
    update_stat_series("10m-avg", "ACD_10m$param(3)", $var(total_duration));
    update_stat_series("1h-avg", "ACD_1h$param(3)", $var(total_duration));
}
```

And in case of a failure, we update the corresponding statistics:

```
event_route[E_ACC_MISSED_EVENT] {
    route(calculate_stats_failure, $param(code), "");
    route(calculate_stats_failure, $param(code), $param(customer));
}
route[calculate_stats_failure] {
    # expects:
    # - param 1: failure code
    # - param 2: statistic identifier; global is empty string
    update_stat_series("perc", "ASR$param(3)", -1);
    update_stat_series("10m-perc", "ASR_10m$param(3)", -1);
    update_stat_series("1h-perc", "ASR_1h$param(3)", -1);
    if ($param(1) == "486" || $param(1) == "408") {
        update_stat_series("perc", "NER$param(3)", 1);
        update_stat_series("10m-perc", "NER_10m$param(3)", 1);
        update_stat_series("1h-perc", "NER_1h$param(3)", 1);
    } else {
        update_stat_series("perc", "NER$param(3)", -1);
        update_stat_series("10m-perc", "NER_10m$param(3)", -1);
        update_stat_series("1h-perc", "NER_1h$param(3)", -1);
    }
    if ($(param(1){s.int}) > 499) {
        update_stat_series("perc", "CCR$param(3)", -1);
        update_stat_series("10m-perc", "CCR_10m$param(3)", -1);
        update_stat_series("1h-perc", "CCR_1h$param(3)", -1);
    } else {
        update_stat_series("perc", "CCR$param(3)", 1);
        update_stat_series("10m-perc", "CCR_10m$param(3)", 1);
        update_stat_series("1h-perc", "CCR_1h$param(3)", 1);
    }
}
```

And we are all set – all you have to do is to run traffic through your server, query the statistics (over MI) at your desired pace (such as every minute), and plot them nicely in a graph to improve your monitoring experience .

## Possible enhancements
There is currently no way of persisting these statistics over a restart – this means that every time you restart, the new statistics have to be re-computed, resulting in possible misleading results. In the future, it would be nice if we could provide some sort of persistent storage for them.<br />All statistics are currently local, although it might be possible aggregate values across multiple servers using some scripting + cluster broadcast messages from script. Ideally, we shall implement this in an automatic fashion using the clusterer module.<br />Finally, although there are currently only three algorithms supported (accumulate, percentage and average), more can be added quite easily – we shall do that in future versions.<br />Enjoy your new statistics!

