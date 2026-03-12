---
title: "VoIP Explained #1: When Do You Need OpenSIPS or Kamailio? The Evolution of Softswitch Architecture"
date: "2026-03-09 18:26:07"
draft: false
type: posts
tags:
- VoIP
- OpenSIPS
- Kamailio
categories:
- all
---

# The Simplest Architecture – The 1-Node Architecture

> **1-Node Architecture: 1 FreeSWITCH Node**

In the simplest VoIP architecture, you only need to deploy a single **FreeSWITCH** server with a public IP address to start providing calling services.

Extensions register directly to the FreeSWITCH server, and the server connects directly to SIP trunks.

![](./p1.drawio.svg)

However, it doesn’t take long before you start encountering the following problems:

## Security Issues

- **Direct Internet exposure**  
  FreeSWITCH is directly exposed to the public Internet, which inevitably means it will be attacked.  
  While trunk connections can be protected with network policies, extension IP addresses are often dynamic.

- **Attack risks**  
  Small-scale attacks include malicious registration scanning.  
  Large-scale attacks can involve **DDoS**, which can easily saturate your bandwidth and interrupt services.

- **Simple defenses are ineffective**  
  For example, changing the default SIP port from `5060` to another port may help slightly.  
  But with modern port-scanning tools, scanning all **65k ports takes only a few seconds**.

## High Availability Issues

- If the single FreeSWITCH node fails, the service stops.
- Maintenance downtime will also interrupt the service.

## Scalability Issues

When traffic grows, a single FreeSWITCH node will no longer be sufficient, and you will inevitably need to add more nodes.

At this point, new problems arise:

- Extension registration information is stored on the FreeSWITCH node.  
  How do you synchronize registration data across multiple FreeSWITCH nodes?

- When receiving inbound calls, do you need to notify the SIP trunk provider about the new FreeSWITCH nodes?

- Do network policies need to be configured again for every new node?

# Architecture Supporting Dynamic FreeSWITCH Scaling – The 2+N Architecture

> **2+N Architecture: 2 SIP Proxy nodes + N FreeSWITCH nodes**

![](./p2.drawio.svg)

Key characteristics of this architecture:

1. The **SIP Proxy layer** has public IP addresses.  
   All SIP signaling—both extension registration and trunk communication—passes through this layer.

2. Extension registration information is stored in the **SIP Proxy layer**, so FreeSWITCH no longer needs to track extension registration addresses.

3. The SIP Proxy layer can use **keep-alive mechanisms** and be deployed in an **active-standby configuration**.

4. FreeSWITCH nodes can scale dynamically, with the proxy layer handling **load balancing**.

In this diagram, I did not introduce **rtpproxy** or **rtpengine**.  
As a result, the media flow becomes somewhat awkward.

**Each FreeSWITCH node still needs a public IP address** so that extensions can communicate directly with it.

The reason is simple:  
**OpenSIPS or Kamailio cannot process media streams.**

Therefore, this architecture still cannot reduce the number of public IPs (EIPs), and FreeSWITCH nodes remain exposed to potential Internet attacks.

# The 2+N+N Architecture

> **2+N+N Architecture: 2 SIP Proxy nodes + N Media Proxy nodes + N FreeSWITCH nodes**

To completely remove the need for FreeSWITCH servers to be publicly exposed, we introduce a **media proxy layer**.

![](./p3.drawio.svg)

Based on the previous architecture, we add a **media proxy cluster**, such as multiple **rtpengine** nodes, to relay media streams between:

- UAC
- FreeSWITCH
- SIP trunks

This layer forwards RTP traffic and prevents FreeSWITCH from needing a public IP address.

# The “Sandwich” Architecture

You can also refer to the **SIPwise C5 architecture**:  
https://wdd.js.org/posts/2025/sipwise-c5-arch/

![](./p4.drawio.svg)

In this architecture, an additional layer is introduced between the **media layer** and the **SIP proxy layer**.  
I call this the **SIP Router layer**.

Why introduce two SIP proxy layers?

Because it allows each layer to focus on a more specific set of responsibilities.

## SIP Proxy Layer – Access Layer

The SIP Proxy layer becomes the **SIP access layer**.

Responsibilities include:

- **Unified protocol access**  
  Regardless of the client protocol (TLS / TCP / UDP / WSS), all connections can be handled here and normalized internally to UDP.

- **Security and authentication**  
  As the system’s entry point, this layer performs centralized access control and security verification.

- **NAT traversal handling**

- **Topology hiding**

- **SIP flood protection / IP blocking**

## SIP Router Layer – Business Logic Layer

The SIP Router layer focuses on **core service logic**, including:

- Registration management
- Trunk selection
- Number rewriting
- Call detail record (CDR) generation and billing
- Other business logic

Some people might argue that the **SIP Router layer and the SIP Proxy layer could be merged into one**.

But let me ask you a question:

**Have you ever seen a house where opening the front door leads directly into the bedroom?**

- The **SIP Proxy layer** is like the **security front door**.
- The **Router layer** is the **living room**.
- The **Media layer** is the **bedroom**.

Separating them creates a clearer and more secure architecture.

Additionally, in some **restricted network environments**, the SIP Proxy layer can also act as the network’s **access gateway**.