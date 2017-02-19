default['docker_nginx']['before'] = {
  name: 'node-3',
  port: 8083,
  image: 'ukitazume/node-hello',
  tag: '2.0',
  name: 'node-3',
}

default['docker_nginx']['after'] = {
  name: 'node-4',
  port: 8082,
  image: 'ukitazume/node-hello',
  tag: '3.0',
}

