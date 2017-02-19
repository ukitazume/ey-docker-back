name "ey-custom"
version '0.1.0'

maintainer 'Engine Yard'
maintainer_email 'support@engineyard.com'

depends "chef_gem_fix"
depends "docker_custom"
depends "docker_nginx"
depends "after_haproxy"
depends "docker_nginx_cleaner"

issues_url 'https://github.com/engineyard/ey-docker-recipes/issues'
source_url 'https://github.com/engineyard/ey-docker-recipes'

#depends "docker_memcached"
#depends "docker_youtrack"
#depends "docker_rails"
#depends "docker_laravel"
