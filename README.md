# pam_shield

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with pam_shield](#setup)
    * [What pam_shield affects](#what-pam_shield-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module install pam_shield brute-force protection for sshd. It was developed for
use with CentOS and by extension should work on Red Hat, Scientific and Fedora. It has
not been tested with Debian or Ubuntu.

## Module Description

This module installs the pam_shield package and provides basic config files
to protect your system from ssh brute-force attacks with (relatively) sane
defaults. It should "just work" out of the box.

## Setup

### What pam_shield affects

Wherever possible, this module adds its own files to your system without overwriting
anything. However it will stamp all over your copy of `/etc/pam.d/sshd` so if you
have customised this on your system, be sure to check the source of this module and
make sure it is compatible.

On RedHat-like systems (except Fedora), the `pam_shield` package is provided by the
EPEL repository. This module uses `stahnma/epel` to provide the repository. Check for
conflicts if you provide EPEL in a different way.

## Usage

Basic use of this module requires no parameters. To use it and accept the defaults,
just call `include ::pam_shield` in your manifest.

It is likely you'll want to customise the installation and override the defaults.

```puppet
  class { 'pam_shield':
    allow_missing_dns     => true,
    allow_missing_reverse => true,
    max_conns             => 5,
    interval              => '1m',
    retention             => '4m',
    allow                 => [
      '192.168.0.1/24',
      '192.168.6.32',
    ],
  }
```

Parameters with `pam_shield`:

### `allow_missing_dns` ###
Boolean. Is it OK for the remote host to have no DNS entry? Default: `true`

### `allow_missing_reverse` ###
Boolean. Is it OK for the remote host to have no reverse DNS entry? Default: `true`

### `max_conns` ###
Integer. Number of failed connections per interval from one site that triggers us to block them. Default: `5`

### `interval` ###
String. The time interval during which `max_conns` must not be exceeded. Default: `1m`

String formatting must be one of the following:
`1s seconds`
`1m minutes`
`1h hours`
`1d days`
`1w weeks`
`1M months (30 days)`
`1y years`

### `retention` ###
String. Period until the entry expires from the database again. Formatting as `interval`. Default: `4m`

### `allow` ###
Array of strings. Any IP address or subnet in CIDR notation. Default: `undef`

## Reference

... one day

## Limitations

This module was developed for use with CentOS and by extension should work on
Red Hat, Scientific and Fedora. It has not been tested with Debian or Ubuntu.
If packages are available for other platforms then it should be easy to extend
this module.

## Development

Feel free to fork and send pull requests, or just make feature requests in the
issue tracker. I can't guarantee having the time to look at anything.
