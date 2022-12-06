---
title: "Exploring SSL/TLS libraries for OpenSIPS 3.2"
date: "2021-02-11 20:04:16"
draft: false
---
> OpenSIPS和OpenSSL之间的集成总是存在各种个样的问题。我之前就遇到死锁的问题，opensips CPU cpu占用很高。但是不再处理SIP消息。最终排查下来，是和OpenSSL有关。
> 深层次的原因，是因为OpenSIPS是个多进程的程序，而OpenSSL主要是面向多线程的程序。
> 在OpenSIPS3.2版本上，官方团队列出了几个OpenSSL的替代品，并进行优劣对比，最终选择一个比较好的方案。
> 我们一起来看看吧。

For the purpose of providing secure SIP communication over the TLS protocol, OpenSIPS uses the **OpenSSL** library, the most popular TLS implementation across the Internet. However, integrating OpenSSL with OpenSIPS has posed a series of challenges starting with OpenSSL version 1.1.0, and has caused quite a few bugs and crashes since then, as presented in more detail in [this article](https://blog.opensips.org/2020/01/16/the-opensips-and-openssl-journey/).<br />As such, for the new OpenSIPS 3.2 version, we have finally decided to provide support for an additional TLS library, as an alternative to OpenSSL. In this article, we are going to take a look at the options we have explored and the criteria and factors that we used to choose a candidate.

### Issues with OpenSSL
Even though up to this point, we have been able to solve the encountered issues, new problems continue to emerge and there are still ongoing reports and Github tickets on this topic. The main reason for this, in short, is that OpenSSL is designed with multi-threaded applications in mind, and is incompatible with certain design principles of a multi-process application like OpenSIPS. OpenSSL is not intended to be used in an environment where TLS connections can be shared between multiple worker processes.

### Requirements for a new TLS library
First, we considered the following general requirements for the new TLS library to use in OpenSIPS:

- cross-platform support, availability for many operating systems (ideally, through the default package repository);
- comprehensive, up to date documentation;
- support for the the latest and widely used protocols and encryption algorithms;
- mature, lively project and good adoption.

But more precisely, in order for a TLS library to be viable for OpenSIPS, in the light of our multi-process architecture constraints, we specifically look for:

- **thread-safe design** (in OpenSIPS we only have a single thread per process, but we do  concurrently access the library from multiple processes nonetheless);
- hooks for providing custom memory allocation functions (instead of the system malloc() family), to make sure the TLS connection contexts are allocated in OpenSIPS shared memory, similarly to **CRYPTO_set_mem_functions()** in OpenSSL;
- hooks for providing custom locking mechanisms (primitives like create, lock, unlock mutex) in order to synchronize access between processes to the shared TLS connection contexts, similarly to the obsolete **CRYPTO_set_locking_callback()** in OpenSSL;
- no use of specific, per-thread memory zone storage mechanisms like _Thread Local Storage_ (which OpenSSL adopted in version 1.1.1, and caused further crashes in OpenSIPS).

### Candidates
In this section we are going to list the top candidates that we have identified in our search for the best TLS implementation that fits OpenSIPS and provide a short conclusion on the findings on each one.

#### OpenSSL forks
Even though prominent OpenSSL forks like _LibreSSL_ (forked by OpenBSD project from OpenSSL 1.0.1g) or _BoringSSL _(forked by Google), seem good options from other perspectives (like features or availability),_ _they fail to bring or keep from old OpenSSL, the required mechanisms for properly integrating with OpenSIPS. _LibreSSL_ for example has dropped both **CRYPTO_set_mem_functions()** and **CRYPTO_set_locking_callback()**.

#### GnuTLS
Popular among free and open source software, GnuTLS’s documentation on [thread safety](https://www.gnutls.org/manual/gnutls.html#Thread-safety) does not seem to indicate that it is safe to share TLS session objects between threads. Moreover, the library uses hard-coded mutex implementations (e.g., pthreads on GNU/Linux and CriticalSection on Windows) for several aspects, like random number generation (this operation has led to issues in OpenSSL). In terms of custom application hooks, GnuTLS does offer **[gnutls_global_set_mutex()](https://www.gnutls.org/manual/gnutls.html#index-gnutls_005fglobal_005fset_005fmutex) **for locking, but since version 3.3.0 has dropped  **[gnutls_global_set_mem_functions()](https://www.gnutls.org/manual/gnutls.html#index-gnutls_005fglobal_005fset_005fmem_005ffunctions)** for memory allocation, which is a must for OpenSIPS shared memory.

#### Mbed TLS
Formerly known as _PolarSSL_, _MbedTLS_ is a library designed for embedded devices and for the purpose of better integration with different systems, offers abstraction layers for memory allocation and threading mechanisms. OpenSIPS can take advantage of this features by installing its own handlers via [**mbedtls_platform_set_calloc_free**()](https://tls.mbed.org/kb/how-to/using-static-memory-instead-of-the-heap) and [**mbedtls_threading_set_alt**()](https://tls.mbed.org/kb/development/thread-safety-and-multi-threading). The downside in this case is that the customisations are only available if the library is compiled with specific flags, which are not enabled by default. This would mean that TLS in OpenSIPS would not properly work with the library installed directly from packages, which is not a desirable approach.

#### WolfSSL
Previously called _yaSSL _/ _CyaSSL, WolfSSL_ is a lightweight TLS library aimed at embedded devices. It has achieved high distribution volumes on all systems nevertheless, due to formerly being bundled with MySQL, as the default TLS implementation. As it is the case with Mbed TLS, the library’s high portability design can be exploited for better integration with OpenSIPS. WolfSSL provides a hook for setting custom memory allocation functions through **[wolfSSL_SetAllocators()](https://www.wolfssl.com/doxygen/group__Memory.html#ga47a9702df2b8249d1a5002509d0a64ad)** but does not offer a way to change the locking mechanism at runtime (unless compiled differently). However, [the documentation](https://www.wolfssl.com/docs/wolfssl-manual/ch9/) and forum discussions on this matter, suggest that as long as access to shared connection contexts is synchronised at the user application level, the library will not internally acquire any mutexes and no concurrency issues will arise.

### Final choice
Based on our evaluation of the available TLS libraries, **WolfSSL** seems to be a good TLS implementation overall and the most appropriate to work with OpenSIPS’s multi-process design and constraints. In conclusion, starting with OpenSIPS 3.2, we plan on providing the possibility of choosing between WolfSSL and OpenSSL for the TLS needs in OpenSIPS.

参考：[https://blog.opensips.org/2021/02/11/exploring-ssl-tls-libraries-for-opensips-3-2/](https://blog.opensips.org/2021/02/11/exploring-ssl-tls-libraries-for-opensips-3-2/)

