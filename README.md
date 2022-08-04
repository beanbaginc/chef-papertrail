# Papertrail Cookbook

This is a fork of the [official chef-papertrail
repository](https://github.com/papertrail/chef-papertrail) that adds:

* RPM-based Arm64 builds
* Chef 17 compatibility
* Newer `remote_syslog2` versions by default.

This cookbook configures the Papertrail [remote_syslog2](https://github.com/papertrail/remote_syslog2) agent. To configure `rsyslog` for use with Papertrail, check out the [Papertrail documentation](http://help.papertrailapp.com/kb/configuration/configuring-remote-syslog-from-unixlinux-and-bsdos-x/).

## Supported Platforms

Our version of the cookbook has been tested on:

* Amazon Linux 2

And Chef 17.

## Usage

### Quickstart

1. Set the attributes `node['papertrail']['destination_host']`, `node['papertrail']['destination_port']`, and at least one file/directory in `node['papertrail']['files']`.
2. Include `papertrail` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[papertrail]"
  ]
}
```

This will install `remote_syslog2` with the configured settings from the Chef node attributes.


## Recipes & their attributes

This cookbook only has one recipe, which does all setup and configuration. There are a number of attributes you can configure, all of which mirror the configuration items found in the `remote_syslog2` [README](https://github.com/papertrail/remote_syslog2#configuration).

- `node['papertrail']['files']`

  **Type:** Array

  A list of files or patterns to send to Papertrail. At least one entry is required.

  Example:
  ```ruby
    node['papertrail']['files'] = [
      '/tmp/test.log',
      '/srv/foo.txt',
      '/var/log/*.bar'
    ]
  ```

  To tag a file/path, the structure is slightly different:
  ```ruby
    node['papertrail']['files'] = [
      '/tmp/test.log',
      '/srv/foo.txt',
      {'path' => '/srv/foo.txt', 'tag' => 'my_tag'}
    ]
   ```

- `node['papertrail']['exclude_files']`

  **Type:** Array

  A list of files or patterns to exclude.

  Example:
  ```ruby
    node['papertrail']['exclude_files'] = [
      '/tmp/exlude.log',
      '/srv/dont-include.log',
      '/var/log/skip-me.log'
    ]
  ```

- `node['papertrail']['exclude_patterns']`

  **Type:** Array

  A regex of log message patterns to exclude.

  Example:
  ```ruby
    node['papertrail']['exclude_patterns'] = ['\d+ things']
  ```
- `node['papertrail']['hostname']`

  **Type:** String

  Override the default hostname.

  Example:
  ```ruby
    node['papertrail']['hostname'] = 'my-super-awesome-hostname'
  ```

- `node['papertrail']['destination_host']`, `node['papertrail']['destination_port']`, & `node['papertrail']['destination_protocol']`

  **Type:** String (`destination_host` & `destination_protocol`)
  **Type:** Integer (`destination_port`)

  The Papertrail host and port to send logs to, and the protocol to use. These are required. Destination and port default to empty, while Protocol defaults to `tls`.

  Example:
  ```ruby
    node['papertrail']['destination_host'] = 'logsN.papertrailapp.com'
    node['papertrail']['destination_port'] = XXXXX
    node['papertrail']['destination_protocol'] = 'tls'
  ```

- `node['papertrail']['new_file_check_interval']`

  **Type:** Integer

  Overrides the default file check interval.

  Example:
  ```ruby
    node['papertrail']['new_file_check_interval'] = 30
  ```

- `node['papertrail']['severity']`

  Overrides the default `remote_syslog2` severity level.

  Example:
  ```ruby
    node['papertrail']['severity'] = 'warn'
  ```

- `node['papertrail']['facility']`

  Overrides the default `remote_syslog2` facility.

  Example:
  ```ruby
    node['papertrail']['facility'] = 'local7'
  ```

- `node['papertrail']['version']`

  **Type:** String

  Use a different version of `remote_syslog` than the default.

  Example:
  ```ruby
    node['papertrail']['version'] = '0.18'
  ```

## Testing

See [TESTING.md](TESTING.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License and Authors

**License:** See [LICENSE](LICENSE.md)

**Fork maintainer:** Christian Hammond (@chipx86)
**Original author:** Mike Julian (@mjulian)
