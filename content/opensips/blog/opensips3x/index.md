---
title: "Introducing OpenSIPS 3.0"
date: "2019-07-31 13:31:30"
draft: false
---
You already know the story – one more year, one more evolution cycle, one more OpenSIPS major release. Even more, a new OpenSIPS direction is about to start. So let me introduce you to the upcoming OpenSIPS 3.0 .<br />For the upcoming OpenSIPS 3.0 release (and 3.x family) the main focus is on the **_devops _**concept. Shortly said, this translates into:

- making the OpenSIPS script writing/developing much easier
- simplifying the operational activities around OpenSIPS

What features and functionalities a software is able to deliver is a very important factor. Nevertheless, how easy to use and operate the software is, it;s a another factor with almost the same importance . Especially if we consider the case of OpenSIPS which is a very complex software to configure, to integrate and to operate in large scale multi-party platforms.

### The “dev” aspects in OpenSIPS 3.0
This release is looking to improve the experience of the OpenSIPS script writer (developer), by enhancing and simplifying the OpenSIPS script, at all its level.<br />The **script re-formatting** (as structure), the addition of **full pre-processor support**, the enhancement of the **script variable’s naming and support**, the standardization of the complex modparams (and many other) will address the script writers needs of

- easiness
- flexibility
- strength

when comes to creating, managing and maintaining more and more complex OpenSIPS configurations.<br />The full list of “dev” oriented features along with explanations and details is to be found on the [official 3.0 planning document](https://www.opensips.org/Development/Opensips-3-0-Planning#development).

### The “ops” aspects in OpenSIPS 3.0
The operational activity is a continues job, starting from day one, when you started to run your OpenSIPS. Usually there is a lot of time, effort and resources invested in this operational activities, so any extra help in the area is more than welcome.<br />OpenSIPS 3.0 is planning several enhancements and new concepts in order to help with operating OpenSIPS – making it simpler to run, to monitor, to troubleshoot and diagnose.<br />We are especially looking at reducing the need of restarts during service time – restarting your production OpenSIPS is something that any devops engineer will try to avoid as much as possible. New features as **auto-scaling** (as number of processes), **runtime changes of module parameters** or **script reload** are addressing this fear. Even when a restart cannot be avoided, the internal memory persistence during restart may minimize the impact.<br />But when comes to vital operational activities like monitoring and understanding what is going one with your OpenSIPS or troubleshooting calls or traffic handled by your OpenSIPS, the most important new additions for helping to operate OpenSIPS are:

- **tracing console** – provided by the new ‘opensipsctl’ tool, the console will allow you to see in realtime various information related to specifics call only. The information may be the OpenSIPS logs, SIP packets, script logs, rest queries, maybe DB queries
- **self diagnosis tool** – also provided by the opensipsctl tool, this is a logic that collects various information from a running OpenSIPS (via MI) in regards to thresholds, load information, statistics and logs in order to locate and indicate a potential problem or bottleneck with your OpenSIPS.

There are even more features that will simply the way you operate your OpenSIPS – the full list (with explanations) is available on the [official 3.0 planning document](https://www.opensips.org/Development/Opensips-3-0-Planning#operational).

### More Integration aspects withe OpenSIPS 3.0
The work to make possible the integration of OpenSIPS with other external components is a never-ending job. This release will make no exception and address this need.<br />A major **rework of the Management Interface** is ongoing, with the sole purpose of standardizing and simplifying the way you interact with the MI interface. Shifting to Json encoding as the only way to pack data and re-structuring all the available transport (protocols) for interacting with the MI interface will enhance your experience in using this interface from any other language / application.<br />The 3.0 release is planning to provide new modules for more integration capabilities:

- **SMPP **module – a bidirectional gateway / translator between SIP (MESSAGE requests) and SMPP protocol.
- **RabbitMQ consumer** module – a RabbitMQ consumer that pushes the messages as events into the OpenSIPS script.

A more detailed description is available on the [official 3.0 planning document](https://www.opensips.org/Development/Opensips-3-0-Planning#integration).

### Community opinion is important
The opinion of the community matters to us, so we need your feedback and comments in regards to the 3.0 Dev Plan.<br />To express yourself on the 3.0 Dev Plan, please see the **[online form](https://docs.google.com/forms/d/e/1FAIpQLSeFZ4KYa81LHO7xYyi1GfLklQK4IomXQNdfeu4KqYaT5peHLQ/viewform)** — you can give scores to the items in the plan and you can suggest other items. This feedback will be very useful for us in order to align the Dev Plan to the real needs of our community, of the people actually using OpenSIPS. Besides our ideas listed in the form, you can of course come with your own ideas, or feature requests that we will gladly take into considerations.<br />The deadline for submitting your answers in the **[form](https://docs.google.com/forms/d/e/1FAIpQLSeFZ4KYa81LHO7xYyi1GfLklQK4IomXQNdfeu4KqYaT5peHLQ/viewform)** is 6th of January 2019. After this deadline we will gather all your submissions and sort them according to your feedback. We will use the result to filter the topics you consider interesting and prioritize the most wanted ones.<br />Also, to talk more in details about the features of this new release, a public [audio conference](https://www.uberconference.com/opensips)will be available on [20th of December 2018, 4 pm GMT](https://www.timeanddate.com/worldclock/fixedtime.html?msg=Introducing+OpenSIPS+3.0&iso=20181220T16&p1=1440&ah=1) , thanks to the kind sponsorship of [UberConference](https://www.uberconference.com/). Anyone is welcome to join to find out more details or to ask questions about [OpenSIPS](http://opensips.org/) 3.0.<br />This is a public and open conference, so no registration is needed.

### The timeline
The timeline for OpenSIPS 3.0 is:

- Beta Release – 18-31 March 2019
- Stable Release – 22-29 April 2019
- General Availability – 30th of April 2019, during [OpenSIPS Summit 2019](http://www.opensips.org/events/Summit-2019Amsterdam/)

