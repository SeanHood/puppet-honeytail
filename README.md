# puppet-honeytail

This module installs and configures [Honeycomb](https://www.honeycomb.io/)'s `honeytail`. [honeytail](https://docs.honeycomb.io/getting-data-in/integrations/honeytail/) is an open source agent for ingesting data into Honeycomb and making it available for exploration.

#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module uses a feature of systemd to trivially run multiple instances of `honeytail` with different configuration. This allows you to ingest application and web server logs residing on the same machine.

## Usage

This example below shows the configuration required to collect logs from MySQL/MariaDB. Note: There is some configuration required inside of MySQL to get the most out of Honeycomb. Refer to the `honeytail` docs for this information: https://docs.honeycomb.io/getting-data-in/integrations/databases/mysql/logs/

```puppet
class {'honeytail':
  direct_download => 'https://honeycomb.io/download/honeytail/linux/honeytail-1.762-1.x86_64.rpm'
}

honeytail::instance {'mysql':
  config => {
    'Required Options' => {
      'ParserName' => 'mysql',
      'WriteKey'   => 'REDACTED',
      'LogFiles'   => '/var/lib/mysql/slow-query.log',
      'Dataset'    => 'mysql'
    }
  }
}
```

