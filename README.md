**FIXME**: Ensure the badges are correct and complete, then remove this message!

[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/simp_banners.svg)](https://forge.puppetlabs.com/simp/simp_banners)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/simp_banners.svg)](https://forge.puppetlabs.com/simp/simp_banners)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-simp_banners.svg)](https://travis-ci.org/simp/pupmod-simp-simp_banners)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with simp_banners](#setup)
    * [What simp_banners affects](#what-simp_banners-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with simp_banners](#beginning-with-simp_banners)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Acceptance Tests - Beaker env variables](#acceptance-tests)

## Description

**FIXME:** Ensure the *Description* section is correct and complete, then remove this message!

Start with a one- or two-sentence summary of what the module does and/or what
problem it solves. This is your 30-second elevator pitch for your module.
Consider including OS and Puppet version compatability, and any other
information users will need to quickly assess the module's viability within
their environment.

You can give more descriptive information in a second paragraph. This paragraph
should answer the questions: "What does this module *do*?" and "Why would I use
it?" If your module has a range of functionality (installation, configuration,
management, etc.), this is the time to mention it.

### This is a SIMP module

This module is a component of the [System Integrity Management
Platform](https://simp-project.com), a
compliance-management framework built on Puppet.

If you find any issues, they may be submitted to our [bug
tracker](https://simp-project.atlassian.net/).

**FIXME:** Ensure the *This is a SIMP module* section is correct and complete, then remove this message!

This module is optimally designed for use within a larger SIMP ecosystem, but
it can be used independently:

 * When included within the SIMP ecosystem, security compliance settings will
   be managed from the Puppet server.
 * If used independently, all SIMP-managed security subsystems are disabled by
   default and must be explicitly opted into by administrators.  Please review
   the parameters in
   [`simp/simp_options`](https://github.com/simp/pupmod-simp-simp_options) for
   details.

## Setup

### What simp_banners affects

**FIXME:** Ensure the *What simp_banners affects* section is correct and complete, then remove this message!

If it's obvious what your module touches, you can skip this section. For
example, folks can probably figure out that your mysql_instance module affects
their MySQL instances.

If there's more that they should know about, though, this is the place to
mention:

 * A list of files, packages, services, or operations that the module will
   alter, impact, or execute.
 * Dependencies that your module automatically installs.
 * Warnings or other important notices.

### Setup Requirements **OPTIONAL**

**FIXME:** Ensure the *Setup Requirements* section is correct and complete, then remove this message!

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you might want to include an additional "Upgrading" section
here.

### Beginning with simp_banners

**FIXME:** Ensure the *Beginning with simp_banners* section is correct and complete, then remove this message!

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

**FIXME:** Ensure the *Usage* section is correct and complete, then remove this message!

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

**FIXME:** Ensure the *Reference* section is correct and complete, then remove this message!  If there is pre-generated YARD documentation for this module, ensure the text links to it and remove references to inline documentation.

Please refer to the inline documentation within each source file, or to the
module's generated YARD documentation for reference material.

## Limitations

**FIXME:** Ensure the *Limitations* section is correct and complete, then remove this message!

SIMP Puppet modules are generally intended for use on Red Hat Enterprise Linux
and compatible distributions, such as CentOS. Please see the
[`metadata.json` file](./metadata.json) for the most up-to-date list of
supported operating systems, Puppet versions, and module dependencies.

## Development

**FIXME:** Ensure the *Development* section is correct and complete, then remove this message!

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

### Acceptance tests

This module includes [Beaker](https://github.com/puppetlabs/beaker) acceptance
tests using the SIMP [Beaker Helpers](https://github.com/simp/rubygem-simp-beaker-helpers).
By default the tests use [Vagrant](https://www.vagrantup.com/) with
[VirtualBox](https://www.virtualbox.org) as a back-end; Vagrant and VirtualBox
must both be installed to run these tests without modification. To execute the
tests run the following:

```shell
bundle install
bundle exec rake beaker:suites
```

**FIXME:** Ensure the *Acceptance tests* section is correct and complete, including any module-specific instructions, and remove this message!

Please refer to the [SIMP Beaker Helpers documentation](https://github.com/simp/rubygem-simp-beaker-helpers/blob/master/README.md)
for more information.
