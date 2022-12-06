---
title: "Full Anycast support in OpenSIPS 2.4"
date: "2019-07-31 13:37:31"
draft: false
---
he advantages of doing Load Balancing and High Availability **without **any particular requirements from the clients side are starting to make Anycast IPs more and more appealing in the VoIP world. But are you actually using the best out of it? This article describes how you can use OpenSIPS 2.4 to make the best use of an anycast environment.<br />[Anycast](https://en.wikipedia.org/wiki/Anycast) is a UDP-based special network setup where a single IP is assigned to multiple nodes, each of them being able to actively use it (as opposed to a VRRP setup, where only one instance can use the IP). When a packet reaches the network with an anycast destination, the router sends it to the “closest” node, based on different metrics (application status, network latency, etc). This behavior ensures that traffic is (1) **balanced** by sending it to one of the least busy nodes (based on application status) and also ensures (2) **geo-distribution**, by sending the request to the closest node (based on latency). Moreover, if a node goes down, it will be completely put out of route, ensuring (3) **high availability** for your platform. All these features without any special requirements from your customers, all they need is to send traffic to the anycast IP.<br />Sounds wonderful, right? It really is! And if you are running using anycast IPs in a transaction stateless mode, things just work out of the box.

#### State of the art
A common Anycast setup is to assign the anycast IPs to the nodes at the edge of your  platform, facing the clients. This setup ensures that all three features (load balancing, geo-distribution and high-availability) are provided for your customers’ inbound calls. However, most of the anycast “stories” we have heard or read about are only using the anycast IP for the initial incoming INVITEs from customers. Once received, the entire call is pinned to a unicast IP of the first server that received the INVITE. Therefore all sequential messages will go through that single unicast IP. Although this works fine from SIP point of view, you will lose all the anycast advantages such as high-availability.<br />When using this approach (of only receiving initial request on the anycast IP) the inbound calls to the clients will also be affected, because besides losing dialog high-availability, you will also need to ask all your clients to accept calls from all your available unicast IPs. Imagine what happens when you add a new node.<br />Our full anycast solution aims to sort out these limitations by always keeping the anycast IPs in the route for the entire call. This means that your clients will always have one single IP to provision, the anycast IP. And when a node goes down, all sequential messages will be re-routed (by the router) to the next available node. Of course, this node needs to have the entire call information to be able to properly close the call, but that can be easily done in OpenSIPS using [dialog replication](http://www.opensips.org/html/docs/modules/2.4.x/dialog.html#idp5554400).<br />Besides the previous issue, most of the time running in stateless mode is not possible due to application logic constraints (re-transmission handling, upstream timeout detection, etc.). Thus stateful transaction mode is required, which complicates a bit more our anycast scenario.

#### Anycast in a transaction stateful scenario
A SIP transaction consists of a request and all the replies associated to that request. According to the [SIP RFC](https://www.ietf.org/rfc/rfc3261.txt), when a stateful SIP proxy sends a request, the next hop should immediately send a reply as soon as it received the request. Otherwise, the SIP proxy will start re-transmitting that request until it either receives a reply, or will eventually time out. Now, let’s consider the anycast scenario described in **Figure 1**:<br />![](https://blogopensips.files.wordpress.com/2018/03/anycast-transaction-stateful.png?w=380&h=462#align=left&display=inline&height=462&originHeight=462&originWidth=380&status=uploading&width=380)Figure 1.<br />OpenSIPS instance 1 sends an INVITE to the client, originated from the Anycast IP interface. The INVITE goes through the Router, and reaches the Client’s IP. However, when the Client replies with 200 OK, the Router decides the “shortest” path is to OpenSIPS instance 2, which has no information about the transaction. Therefore, instance 2 drops all the replies. Moreover, since instance 1 did not receive any reply, it will start re-transmitting the INVITE. And so on, and so forth, until instance 1 times out, because it did not receive any reply, and the Client times out because there was no ACK received for its replies. Therefore the call is unable to complete.<br />To overcome this behavior, we have developed a new mechanism that is able to handle transactions in such distributed environments. The following section describes how this is done.

#### Distributed transactions handling
Transactions are probably the most complicated structures in SIP, especially because they are very dynamic (requests and replies are exchanged within milliseconds) and they contain a lot of data (various information from the SIP messages, requests for re-transmissions, received replies, multiple branches, etc). That makes them very hard to move around between different instances. Therefore, instead of sending transaction information to each node within the anycast “cluster”, our approach was to bring the events to the node that created the transaction. This way we minimize the amount of data exchanged between instances – instead of sending huge transaction data, we simply replicate one single message –  and we are only doing this when it’s really necessary – we are only replicating messages when the router that manages the anycast config switches to a different node.<br />When doing distributed transaction handling, the logic of the [transaction module](http://www.opensips.org/html/docs/modules/2.4.x/tm.html) is the following: when a reply comes on one server, we check whether the current node has a transaction for that reply. If it does (i.e. the router did not switch the path), the reply is processed locally. If it does not, then somebody else must “own” that transaction. The question is who? That’s where the SIP magic comes: when we generate the INVITE request towards the client, we add a special parameter in the VIA header, indicating the ID of the node that created the transaction. When the reply comes back, that ID contains exactly the node that “owns” the transaction. Therefore, all we have to do is to take that ID and forward the message to it, using the [proto_bin module](http://www.opensips.org/html/docs/modules/2.4.x/proto_bin). When the “owner” receives the reply, it “sees” it exactly as it would have received it directly from the client, thus treating it exactly as any other regular reply. And the call is properly established further.<br />![](https://cdn.nlark.com/yuque/0/2019/png/280451/1564551492001-1b9052d8-a693-4856-b55a-6ff04ce7f312.png#align=left&display=inline&height=479&originHeight=479&originWidth=394&size=0&status=done&width=394)Figure 2.<br />There is one more scenario that needs to be taken into account, namely what happens when a CANCEL message reaches a different node (**Figure 2**). Since there is no transaction found on node 2, normally that message would have been declined. However, in an anycast environment, the transaction might be “owned” by a different node. , therefore, we need to instruct him that the transaction was canceled. However, this time we have no information about who “owns” that transaction – so all we can do is to broadcast the CANCEL event to all the nodes within the cluster. If any of the nodes that receive the event find the transaction that the CANCEL refers to, it will properly reply a 200 OK message and then close all the ongoing branches. If no transaction is found on any node, the CANCEL will eventually time out on the Client side.<br />A similar approach is done for a hop-by-hop ACK message received in an anycast interface.

#### Anycast Configuration
The first thing we have to do is to configure the anycast address on each node that uses it. This is done in the [listen](http://www.opensips.org/Documentation/Script-CoreParameters-2-4#toc37) parameter:

```bash
listen = udp:10.10.10.10:5060 anycast
```
The distributed transaction handling feature relies on the [clusterer module](http://www.opensips.org/html/docs/modules/2.4.x/clusterer) to group the nodes that use the same anycast address in a cluster. The resulting cluster id has to be provisioned using the [tm_replication_cluster](http://www.opensips.org/html/docs/modules/2.4.x/tm#tm_replication_cluster) parameter of the transaction module:

```
loadmodule "tm.so"
modparam("tm", "tm_replication_cluster", 1)
The last thing that we need to take care of is the hop-by-hop messages, such as ACK. This is automatically done by using the t_anycast_replicate() function:
if (!loose_route()) {
    if (is_method("ACK") && !t_check_trans()) {
        # transanction not here - replicate msg to other nodes
        t_anycast_replicate();
        exit;
    }
}

```

Notice that the CANCEL is not treated in the snippet above. That is because CANCEL messages received on an anycast interface are automatically handled by the transaction layer as described in the previous section. However, if one intends to explicitly receive the CANCEL message in the script to make any adjustments (i.e. change the message Reason), they can disable the default behavior using the cluster_auto_cancel param. However, this changes the previous logic a bit, since the CANCEL must be replicated as well in case no transaction is locally found:

```bash
modparam("tm", "cluster_auto_cancel", no)
...
if (!loose_route()) {
    if (!t_check_trans()) {
        if (is_method("CANCEL")) {
            # do your adjustments here
            t_anycast_replicate();
            exit;
        } else if is_method("ACK") {
            t_anycast_replicate();
            exit;
        }
    }
}
```

And that’s it – you have a fully working anycast environment, with distributed transaction matching!

#### Find out more!
The distributed transaction handling mechanism has already been released on the OpenSIPS 2.4 development branch. To find out more about the design and internals of this feature, as well as other use cases, make sure you do not miss the [Full Anycast support at the edge of your platform using OpenSIPS 2.4](http://www.opensips.org/events/Summit-2018Amsterdam/#mu-schedule) presentation about this at the  [Amsterdam 2018 OpenSIPS Summit, May 1-4](http://www.opensips.org/events/Summit-2018Amsterdam)!


