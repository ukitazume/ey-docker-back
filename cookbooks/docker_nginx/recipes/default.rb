install_docker = node['dna']['instance_role'] == "util" && node['docker_custom']['docker_instances'].include?(node['dna']['name'])

after = node["docker_nginx"]["after"]

if install_docker
  docker_image after["image"] do
    tag after["tag"]
    action :pull
  end

  docker_container after["name"] do
    repo after["image"]
    tag after["tag"]
    port "#{after["port"]}:8080"
    restart_policy "always"
    kill_after 30
    action :run
  end  
end
