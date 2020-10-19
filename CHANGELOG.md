# Changelog

All notable changes to this project will be documented in this file.

## Release v0.1.0

First release of puppet-honeytail :partying_face:

**Features**
* Implements core features:
    * Installs Honeytail
    * Sets up Systemd service
    * Can create multiple honeytail instances with the `honeytail::instance` resource

* Unit and Acceptance Tests

**Bugfixes**
* (prerelease) puppetlabs/inifile was replaced with hash2stuff as inifile doesn't support purging resources #8

**Known Issues**
* Module has only been tested on CentOS 7
* Currently no support for CentOS 6
