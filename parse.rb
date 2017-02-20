require 'json'

deploys = Dir["./deploys/*"].sort

before = deploys[-2]
after = deploys[-1]

before_conf = JSON.parse(File.read(before))
after_conf = JSON.parse(File.read(after))

if rand(2) == 0
  after_conf['port'] = before_conf['port'] + 1
else
  after_conf['port'] = before_conf['port'] - 1
end

File.open(after, "w") do |f|
  f.write(after_conf.to_json)
end

p "default['before'] = #{before_conf}"
p "\n"
p "default['after'] = #{after_conf}"



