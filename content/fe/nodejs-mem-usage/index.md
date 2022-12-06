---
title: "Nodejs Mem Usage"
date: "2020-06-10 14:24:00"
draft: false
---

# process.memoryUsage()
```shell
{
  rss: 4935680,
  heapTotal: 1826816,
  heapUsed: 650472,
  external: 49879,
  arrayBuffers: 9386
}
```

- heapTotal 和 heapUsed指向V8's 内存使用
- external 指向 C++ 对象的内存使用， C++对象绑定js对象，并且由V8管理
- rss, 实际占用内存，包括C++, js对象和代码三块的总计。使用 ps aux命令输出时，rss的值对应了RSS列的数值
- node js 所有buffer占用的内存

> - `heapTotal` and `heapUsed` refer to V8's memory usage.
> - `external` refers to the memory usage of C++ objects bound to JavaScript objects managed by V8.
> - `rss`, Resident Set Size, is the amount of space occupied in the main memory device (that is a subset of the total allocated memory) for the process, including all C++ and JavaScript objects and code.
> - `arrayBuffers` refers to memory allocated for `ArrayBuffer`s and `SharedArrayBuffer`s, including all Node.js [`Buffer`](https://nodejs.org/dist/latest-v12.x/docs/api/buffer.html)s. This is also included in the `external` value. When Node.js is used as an embedded library, this value may be `0` because allocations for `ArrayBuffer`s may not be tracked in that case.


# process.resourceUsage()

- `userCPUTime` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_utime` computed in microseconds. It is the same value as [`process.cpuUsage().user`](https://nodejs.org/dist/latest-v12.x/docs/api/process.html#process_process_cpuusage_previousvalue).
- `systemCPUTime` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_stime` computed in microseconds. It is the same value as [`process.cpuUsage().system`](https://nodejs.org/dist/latest-v12.x/docs/api/process.html#process_process_cpuusage_previousvalue).
- `maxRSS` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_maxrss` which is the maximum resident set size used in kilobytes.
- `sharedMemorySize` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_ixrss` but is not supported by any platform.
- `unsharedDataSize` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_idrss` but is not supported by any platform.
- `unsharedStackSize` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_isrss` but is not supported by any platform.
- `minorPageFault` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_minflt` which is the number of minor page faults for the process, see [this article for more details](https://en.wikipedia.org/wiki/Page_fault#Minor).
- `majorPageFault` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_majflt` which is the number of major page faults for the process, see [this article for more details](https://en.wikipedia.org/wiki/Page_fault#Major). This field is not supported on Windows.
- `swappedOut` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_nswap` but is not supported by any platform.
- `fsRead` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_inblock` which is the number of times the file system had to perform input.
- `fsWrite` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_oublock` which is the number of times the file system had to perform output.
- `ipcSent` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_msgsnd` but is not supported by any platform.
- `ipcReceived` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_msgrcv` but is not supported by any platform.
- `signalsCount` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_nsignals` but is not supported by any platform.
- `voluntaryContextSwitches` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_nvcsw` which is the number of times a CPU context switch resulted due to a process voluntarily giving up the processor before its time slice was completed (usually to await availability of a resource). This field is not supported on Windows.
- `involuntaryContextSwitches` [<integer>](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#Number_type) maps to `ru_nivcsw` which is the number of times a CPU context switch resulted due to a higher priority process becoming runnable or because the current process exceeded its time slice. This field is not supported on Windows.
```shell
console.log(process.resourceUsage());
/*
  Will output:
  {
    userCPUTime: 82872,
    systemCPUTime: 4143,
    maxRSS: 33164,
    sharedMemorySize: 0,
    unsharedDataSize: 0,
    unsharedStackSize: 0,
    minorPageFault: 2469,
    majorPageFault: 0,
    swappedOut: 0,
    fsRead: 0,
    fsWrite: 8,
    ipcSent: 0,
    ipcReceived: 0,
    signalsCount: 0,
    voluntaryContextSwitches: 79,
    involuntaryContextSwitches: 1
  }
*/
```

