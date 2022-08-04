version = node['papertrail']['version']
full_pkg_name = node['papertrail']['package_url']
pkg_name = node['papertrail']['package_name']

if full_pkg_name.nil? or pkg_name.nil?
  case node['platform']
  when 'redhat', 'centos', 'amazon'
    pkg_name = 'remote_syslog2'
    pkg_arch = node['kernel']['machine']
    full_pkg_name = "remote_syslog2-#{version}-1.#{pkg_arch}.rpm"
  when 'debian', 'ubuntu'
    full_pkg_name = "remote-syslog2_#{version}_amd64.deb"
    pkg_name = 'remote-syslog2'
  else
    raise "Unsupported platform: #{node['platform']}"
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/#{full_pkg_name}" do
  source "https://github.com/papertrail/remote_syslog2/releases/download/v#{version}/#{full_pkg_name}"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

case node['platform']
when 'redhat', 'centos', 'amazon'
  package 'remote_syslog2' do
    action :install
    source "#{Chef::Config[:file_cache_path]}/#{full_pkg_name}"
  end
when 'debian', 'ubuntu'
  dpkg_package 'remote-syslog2' do
    action :install
    source "#{Chef::Config[:file_cache_path]}/#{full_pkg_name}"
  end
else
  raise "Unsupported platform: #{node['platform']}"
end

template '/etc/log_files.yml' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    files: node['papertrail']['files'],
    destination_host: node['papertrail']['destination_host'],
    destination_port: node['papertrail']['destination_port'],
    destination_protocol: node['papertrail']['destination_protocol'],
    exclude_files: node['papertrail']['exclude_files'],
    hostname: node['papertrail']['hostname'],
    exclude_patterns: node['papertrail']['exclude_patterns'],
    new_file_check_interval: node['papertrail']['new_file_check_interval'],
    facility: node['papertrail']['facility'],
    severity: node['papertrail']['severity']
  )
  notifies :restart, 'service[remote_syslog]', :delayed
end

service 'remote_syslog' do
  action [:start, :enable]
  subscribes :restart, 'package[#{pkg_name}]', :delayed
end
