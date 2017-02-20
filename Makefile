IMAGE=ukitazume/node-hello
ATTR_PATH=cookbooks/docker_nginx/attributes/default.rb

create:
	echo '{"image": "${IMAGE}", "tag": "", "name": "app-$(shell date "+%Y%m%d%H%M")"}' > deploys/$(shell date "+%Y%m%d%H%M").json

write:
	echo $(shell ruby ./parse.rb) > ${ATTR_PATH}


