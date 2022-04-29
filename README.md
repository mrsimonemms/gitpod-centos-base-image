# Gitpod CentOS Base Image

The [Gitpod base image](https://github.com/gitpod-io/workspace-images/blob/main/base/Dockerfile), but in CentOS

## Important

> tl;dr Use at your own risk

This project is almost entirely unmaintained and no guarantees are made
about it's suitability. It's an example of what can be achieved rather
than a stable piece of work.

It worked at the time of publishing (April 2022) but is very unlikely to
receive any updates nor maintain parity with the Gitpod base image.

## What is this?

The Gitpod base image is written on top of Ubuntu. This is the exact
same image but written on top of CentOS 7.

## Why have you done it?

1. [Why not?](https://www.youtube.com/watch?v=Gqp8BYpzRFs)
2. We recently had a paying customer enquire about how to do this as their
Python library had a testing framework that required CentOS for _\<reasons\>_.
I gave them an answer specific to their needs, but this is a more general
answer for public consumption.

## How do I use it?

Follow the instructions for using a [custom Docker image](https://www.gitpod.io/docs/config-docker).

This is just the base image, so any additional dependencies will need to
be added separately. Refer to the [chunks](https://github.com/gitpod-io/workspace-images/tree/main/chunks)
section of the Gitpod workspace-images repo for idea on how to achieve
that.

I've also written a [blog post](https://simonemms.com/blog/2022/04/30/using-a-non-ubuntu-base-image-in-gitpod)
on how to use this.
