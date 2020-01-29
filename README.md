[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/simp_banners.svg)](https://forge.puppetlabs.com/simp/simp_banners)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/simp_banners.svg)](https://forge.puppetlabs.com/simp/simp_banners)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-simp_banners.svg)](https://travis-ci.org/simp/pupmod-simp-simp_banners)

#### Table of Contents

<!-- vim-markdown-toc GFM -->

* [Description](#description)
  * [This is a SIMP module](#this-is-a-simp-module)
* [Setup](#setup)
  * [Beginning with simp_banners](#beginning-with-simp_banners)
* [Usage](#usage)
* [Development](#development)

<!-- vim-markdown-toc -->


## Description

This module provides the content of many common login banners, and the Puppet
function `simp_banners::fetch()` to access them.

### This is a SIMP module

This module is a component of the [System Integrity Management
Platform][simp-site], a compliance-management framework built on Puppet. If you
find any issues, they may be submitted to our [bug tracker][simp-bug-tracker].

This module is optimally designed for use within a larger SIMP ecosystem, but
it can be used independently.

[simp-bug-tracker]: https://simp-project.atlassian.net/
[simp-site]: https://simp-project.com

## Setup

### Beginning with simp_banners

```puppet
$banner_text = simp_banners::fetch('us/department_of_commerce')
```

## Usage

This module provides the `simp_banners::fetch()` function.  See
[REFERENCE.md](REFERENCE.md) for more details.

## Development

Please read our [Contribution Guide](https://simp.readthedocs.io/en/stable/contributors_guide/index.html).
