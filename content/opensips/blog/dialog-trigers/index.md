---
title: "Dialog triggers, or how to control the calls from script"
date: "2021-02-11 20:23:40"
draft: false
---
原文：[https://blog.opensips.org/2020/05/26/dialog-triggers-or-how-to-control-the-calls-from-script/](https://blog.opensips.org/2020/05/26/dialog-triggers-or-how-to-control-the-calls-from-script/)

The OpenSIPS script is a very powerful tool, both in terms of capabilities (statements, variables, transformations) and in terms of integration (support for DB, REST, Events and more).<br />So why not using the OpenSIPS script (or the script routes) to interact and control your call, in order to build more complex services on top of the dialog support?<br />For this purpose, OpenSIPS 3.1 introduces three new per-dialog triggers:

- **on_answer** route, triggered when the dialog is answered;
- **on_timeout** route, triggered when the dialog is about to timeout;
- **on_hangup** route, triggered after the dialog was terminated.

The routes are optional and per-dialog and they give you the possibility to attach custom operations to the various critical milestones in a dialog life.<br />While the **on_answer** and **on_hangup** routes are 100% data-manipulation oriented (you have full read/write access to the full data context of the dialog, but you cannot change anything about the dialog progress), the **on_timeout** route is a bit more versatile – by increasing the dialog’s timeout, you can dynamically increase the dialog lifetime (to postpone the dialog timeout, without waiting for any signalling to do it).<br />But let’s talk example 🙂

### Simple PrePaid
Using the **on_timeout** route, we can simulate the incremental check and charge behavior of a basic prepaid.<br />For example, we set 5 seconds timeout for the dialog and when the **on_timeout** route is triggered (after the 5 secs), we can re-check if the caller still have credit to continue the call. If not, we leave the call to timeout, to be terminated by the OpenSIPS. If he still has credit, we deduct the cost for 5 secs more and we increase the dialog timeout is 5 more seconds. Simple, right ?
```
route {
  ....
  create_dialog("B");
  # remember some billing account id, to remember
  # where to check for credit
  $dlg_val(account_id) = "...";
  # keep a running cost for the call also
  $dlg_val(total_cost) = 0;
  # start with an initial 5 seconds duration
  $DLG_tiemout = 5;
  t_on_timeout("call_recheck");
  t_on_hangup("call_terminated");
  ....
}
route[call_recheck] 
{
  # the dialog data (vars, flags, profiles) are accesible here.
  xlog("[$DLG_id] dialog timeout triggered\n");
  # calculate the cost for the next 5 seconds
  $var(cost) = 5 * .... ;
  # use a critical/locked region to do test and update upon the credit
  get_dynamic_lock( "$dlg_val(account_id)" );
  if (avp_db_query("select credit from accounts where credit>=$var(cost) and id=$dlg_val(account_id)")) {
    # credit is stil available
    avp_db_query("update accounts set credit=credit-$var(cost) where id=$dlg_val(account_id)");
    # give the dialog 5 more seconds
    $DLG_timeout = 5;
    # update the total cost
    $dlg_val(total_cost) = $(dlg_val(total_cost){s.int}) + $var(cost);
  } else {
    # query returned nothing, so no credit is available, allow the call
    # to timeout and terminate right away
  }
  release_dynamic_lock( "$dlg_val(account_id)" );
}
route[call_terminated]
{
  # the dialog data (vars, flags, profiles) are accesible here.
  xlog("[$DLG_id] call terminated after $DLG_lifetime seconds with a cost of $dlg_val(total_cost)\n");
  # IMPROVEMENT - eventually ajust the call if the call didn't used
  # the whole span of the last 5 seconds
}
```

### SHARE THIS:

