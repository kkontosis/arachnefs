# arachnefs
ArachneFS is a locally based, highly available, distributed file system with modular external storage intended to combine the pros of conventional storage and cloud storage to improve personal data storage.
It relies on existing file systems, the external sources, which are formatted so that an instance of arachnefs is created, which is done by creating special files and directories in them. Those sources are then integrated into a single file system mounted on a user directory.

| **arachne**  |   |  |
|---:|---|---|
| ![spider-outline.svg](./spider-outline.svg) | **fs** |  |
| | | *Icons made by [Freepik](http://www.freepik.com) from [Flaticon](https://www.flaticon.com/) is licensed by [CC 3.0 BY](http://creativecommons.org/licenses/by/3.0/)* |


## Introduction

This is a file system that is currently being designed.
There is no code yet and this project is in its beginning.

If you were looking for a usuable file system I am sorry.
You are welcome to check again in the future to see
how the development of this project goes.

## Why arachnefs?

The name of this project may change.

For now, the word arachne was chosen which means spider. I know spiders are disgusting little insects but they show some similarities with our system (...).
Still, some may find spiders unappealing and we may use a different name if we come up with a better one.


## What is this?

This section is a question and answer paragraph summarizing some of the selling points of this system, written in order to assert the necessity of the existence of this file system. During this pseudodiscussion I am acting as a devil's advocate devaluing the project and creating responses. Before going into this paragraph, I should mention that the problem being addressed is a bit more complicated, as a problem, than what it seems to be in the section below and the overall appearance may be such that undersells this project the way I imagine it to be. Nonetheless, self doubt is very useful in this early stage of the project, and the decision to move on to the implementation has been made, unless something changes!

Arachnefs is meant to be the ultimate file system, or rather the ultimate file system middleware, for personal use.

The following **FAQ** is a **TL;DR** version of our description for what this is:

>> Q: What does this do?

> A: It shows more data in your machine than it can fit

>> Q: And how does this work?

> A: By utilizing remote or external space

>> Q: Then, why not use that space directly?

> A: Because it supports redundancy (if a disk fails data is read from another disk), in other words, is highly available. It syncs data automatically when the sources are connected, with no user action. This way it also acts as an automated backup.

>> Q: And how is this project new?

> A: It is a cloud set up at home rather than at a remote company

>> Q: And why do I care?

> A: You can use more proximate hard disks which are way faster

>> Q: Ok, but at what tradeoff? Would you lose the benefits of a remote cloud system like reliability?

> A: No, you still get the benefits of a remote cloud storage by adding one as a backup source

>> Q: All of the benefits?

> A: Yes, the ones regarding private data use. You will have synchronization between multiple computers, and you can even have that via the internet, via a local network, or even via external drives

>> Q: What else does this project do besides the speed improvement?

> A: You can work offline too, so you additionally get a cut of the cost of having to work with a constant, never-breaking internet connection that would be imposed by a cloud solution

>> Q: Other projects do this as well

> A: Almost, this one is open source and it allows local synchronization as well

>> Q: Is that all?

> A: This project also has high configurability even up to a directory level. You can even combine data sources

>> Q: Anything else?

> A: Additionally you get client-side symmetrical encryption, meaning that no-one without your key can access your data

>> Q: And I suppose this is it?

> A: Not quite, with this file system you can access recent previous versions of your files as well

>> Q: At what kind of granularity, in number of changes, do I get to access the previous versions?

> A: Practically? Infinite. But you only get the very recent changes, which is controlled by a configurable time limit

>> Q: Is that all?

> A: Elaborating on combining data sources, you may keep some data locally while having some other data remote-only

>> Q: Are all these implemented?

> A: Not at the time of writing of this document

>> Q: And then, why bother write this?

> A: To aid the implementation process, which will start with a version 1

>> Q: Will all the above features be included version 1?

> A: Possibly not, but a very important subset should be

>> Q: Are you ([the author](https://github.com/kkontosis)) a disturbed person?

> A: Yes, you can clearly see that I'm conversing with myself :) but this is for the good of this project

## Long version

Arachnefs is the file system one needs to have in order to:

* work, anywhere, whether on-line or off-line, without any distractions,
* without having to take care of backups,
* without having to synchronize or copy files between multiple computers,
* ideally without having to control any synchronization,
* free from being tied to a unique cloud provider,

while at the same time:

* their data gets safely backed up at any chance,
* they can work on a total storage that is bigger than what fits their computer,
* they can be sure that noone else can have access to their data

While using it, one would potentially get instant backups and synchronization with multiple computers,
for a file space that can be too large to fit in their own computer, with the ability to split
the storage to as many internal, external or remote cloud sources, with the ability to add configurable
redundancy of any number to all the file space or have different configuration for different parts of the
file space.

The speed of the file system should be almost as fast as native, when using local cache, and
would have an expected latency when the data needs to be downloaded.
Recently downloaded data however, would be immediately stored in a configurable-size cache.

This file system would be incredibly handy when a computer breaks and one needs to keep on working
on their projects on another computer, when they don't have a local networked file system handy, or
when they want to be working on files that can be accessed at almost-native local speed.

It would also be interesting for a dual boot scenario, where some data, stored in either or even both
partitions of the two operating systems, can be shared at a common place, even if write access is
not allowed for a given partition, without the sacrifice of having to double the disk usage.

The most common intended use scenario however, would be working with an external disk, as backup, or as sole
data source for certain large data, that can sometimes be disconnected, but we are still able to work on
the latest active files, while at the same time, remote backups are made to a pool of available cloud providers,
or SSH servers, or to a secondary external disk
and whenever we want, we can work on the same data from another computer,
if we have access to the internet, or by swapping our external disk.

It is also interesting that most of the mentioned scenarios are not mutually exclusive.

At the end, the system should constantly synchronize changes made from any data source to the other data sources
the moment they are connected, thus making a constantly converging file system, which can be viewed as a single one.

Data loss, e.g. destruction of a single data source, should not be a problem, as long as there is a redundant source,
and as much redundancy as one desires can be configured to be used.

Bringing up the idea behind this. This file system could be able to store the entire data collected or created
by an individual, which
they want to keep, even if it is too big to fit e.g. in a single hard disk, where they
can have it all as a single view.
Then, they can configure the storage layers to hold the data such that larger but most infrequent items,
are in cheaper places, perhaps with less redundancy, while critical items, have a higher redundancy and lower
latency. Some data can then be configured to be constantly accessible offline, such as current projects.

The use case can of course be something else, like a project, a company's data, a family's data etc.

The proposal of this filesystem is something like an alternative to cloud data storage.

The main way it is different, is that, local sources can be used, alongside remote sources.

One important detail in this filesystem is that one does not have to pay for it, if they want to provide the
data sources themselves, they are thus in control of their own data.

Another important detail is that it is meant to be mounted with **FUSE**, so it will be seen as a native folder.

An idea of having a secondary option of synchronizing various files of random locations, with tha main system,
is under thought, mostly to allow one to quickly set up their environment, like the local user configuration
files of various programs that run in their computer, so that they can use that to quickly set up a new computer
to match their old.

Finally, a REST API could be handy for servers.

The important part however should be that someone should be able to work natively, and keep their work,
without having to spend too much time saving files and setting up machines, and still keep large volumes.

## Micro-features

This is mostly a list of thoughts which is helpful for organizing those thoughts and not forgetting them.
They are in the form of draft notes.
These features are desired to have.
But they may not be there in the first version of the project:

* Tarballs as reference in snapshots instead of files for directories that have too many small files.
* Diff as write event contents instead of binary for text files
* Automatically mount some file systems before mounting this file system, to be used as sources.
* Adoption of code for several important known file systems, as core or as plugin.
* Watching file for modifications at backend side, if needed as primitive and fallback to polling.
* Watching file for modifications at a filesystem level as a feature.
* Tracking of connected agents via events.
* Communication of connected agents.
* Discovery of modifications during connection as an optinal configurable feature as opposed to upon request.
* Different schemes based on connection status e.g. online, wifi, on battery, on specific network etc.
* Configurable cache with clever algorithm to select cached files
* Chmod and attributes
* Owners and groups and permissions and chown
* A store that consists of distinct backends for storing snapshots and events.
* A consensus algorithm using events and timeouts to create a handshake before snapshot creation.
* Disk format tool
* Health check tool
* Migration from existing files to a new filesystem tool, migrations should be ongoing and self-healing
* Migration between encrypted and non-encrypted backend
* Migration tool to onboard a new source to an existing setup
* Migration tool to divide data from a single source to a pair of sources
* Migration tool to unite data from previously divided sources
* Tool to step back in time
* Step back in time: Explore events and selectively remove to resolve conflicts

## Roadmap

The following **FAQ** answer's questions regarding the project's roadmap and timelines:

>> Q: When will this project begin its development?

> A: ASAP. Most of the study, which is the lion's share of the work has already been done

>> Q: How many features will be included in the first version?

> A: The first version will be cut as short as possible. The mechanism of the file system greatly relies on
various optimizations. Even if some features exist, without optimizations, like the cache they may not be
so appealing. Nonetheless, many parts of the file system are inherent to its mechanism so they can't be cut,
and the plan is to have a useful version one.

>> Q: Any important features that might be cut?

> A: Encryption may not be present, mainly because it can make debugging harder and because it is best well
thought. Nonetheless, it is extremely straightforward. Most of the desired configurability may not make it
to version one.

>> Q: How big is the timeline for this project?

> A: Extremely small. This project is only created as a storage solution for my personal needs because
I have found all existing solutions that I have considered so far to be **unsatisfactory** compared to
what I would like to have.

>> Q: Will this project be ongoing?

> A: Many secondary targets are described, however it is highly possible that this project will stop at version one.
I have no ways of supporting this project and currently it only serves as a means to aiding my other projects.
Hopefully someone else may benefit from it as well.


## License

arachnefs is distributed under the GNU General Public License Version 3.0 as described below.

```
arachnefs, local highly available distributed file system
Copyright (C) 2018 Kimon Kontosis http://kkonsoft.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
