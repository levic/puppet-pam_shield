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

The first release has no customisable parameters as the config file is hard-coded.
Future releases will provide this functionality (feel free to send patches if you
want it sooner).

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

The first release of this module provides no customisable options. To use it,
just `include ::pam_shield`

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
