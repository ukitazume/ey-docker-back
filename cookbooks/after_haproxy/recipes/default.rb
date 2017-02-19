install_docker = node['dna']['instance_role'] == "util" && node['docker_custom']['docker_instances'].include?(node['dna']['name'])

if install_docker
  require_recipe 'after_haproxy::configure'
end
