# Expect this to run before haproxy::install
#

# We need to do an execute here because a service
# definition requires the init.d file to be in
# place at by this point. And since we configure first
# it won't be on clean instances
execute "reload-haproxy" do
  command 'if /etc/init.d/haproxy status ; then /etc/init.d/haproxy reload; else /etc/init.d/haproxy restart; fi'
  action :nothing
end

#
# SD-4650
# Remove it when awsm stops using dnapi to generate the dna and allows configure ports

haproxy_http_port = (app = node.engineyard.apps.detect {|a| a.metadata?(:haproxy_http_port) } and app.metadata?(:haproxy_http_port)) || 80
haproxy_https_port = (app = node.engineyard.apps.detect {|a| a.metadata?(:haproxy_https_port) } and app.metadata?(:haproxy_https_port)) || 443

# CC-52
# Add http check for accounts with adequate settings in their dna metadata
haproxy_httpchk_path = (app = node.engineyard.apps.detect {|a| a.metadata?(:haproxy_httpchk_path) } and app.metadata?(:haproxy_httpchk_path))
haproxy_httpchk_host = (app = node.engineyard.apps.detect {|a| a.metadata?(:haproxy_httpchk_host) } and app.metadata?(:haproxy_httpchk_host))

# CC-954: Allow for an app to use specific http check endpoint instead of tcp connectivity check
unless haproxy_httpchk_path
  app = node.engineyard.apps.detect {|a| a.metadata?(:node_health_check_url)}
  if app
    haproxy_httpchk_path = app.metadata(:node_health_check_url)
    haproxy_httpchk_host = app.vhosts.first.domain_name.empty? ? nil : app.vhosts.first.domain_name
  end
end


managed_template "/etc/haproxy.cfg" do
  owner 'root'
  group 'root'
  mode 0644
  source "haproxy.cfg.erb"
  members = node.dna[:members] || []
  variables({
    :backends => node.engineyard.environment.app_servers,
    :dockers => node['dna']['engineyard']['environment']['instances'].select{ |i| i['role'] == 'util' && i['name'] =~ /docker/ },
    :docker_port => node['docker_nginx']['after']['port'],
    :app_master_weight => members.size < 51 ? (50 - (members.size - 1)) : 0,
    :haproxy_user => node.dna[:haproxy][:username],
    :haproxy_pass => node.dna[:haproxy][:password],
    :http_bind_port => haproxy_http_port,
    :https_bind_port => haproxy_https_port,
    :httpchk_host => haproxy_httpchk_host,
    :httpchk_path => haproxy_httpchk_path
  })

  # We need to reload to activate any changes to the config
  # but delay it as haproxy may not be installed yet
  # end
 notifies :run, resources(:execute => 'reload-haproxy'), :delayed
end


