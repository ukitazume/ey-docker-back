install_docker = node['dna']['instance_role'] == "util" && node['docker_custom']['docker_instances'].include?(node['dna']['name'])

before = node["docker_nginx"]["before"]

if install_docker
  docker_container before["name"] do
    action :delete
    kill_after 30
  end  
end
