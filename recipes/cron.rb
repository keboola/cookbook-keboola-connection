

action = node['keboola-connection']['enable_cron'].to_i > 0 ? :create : :delete

cron "token expirator" do
  user "deploy"
  command "/www/connection/current/cli.sh storage:token-expirator --lock 2>&1 | /usr/bin/logger -t 'token-expirator' -p local1.info"
  action action
end

cron "backend stats update" do
  user "deploy"
  command "/www/connection/current/cli.sh storage:update-backend-stats --lock 2>&1 | /usr/bin/logger -t 'update-backend-stats' -p local1.info"
  minute "38"
  action action
end

cron "elastic events roll index" do
  user "deploy"
  hour "00"
  minute "00"
  day "1"
  command "/www/connection/current/cli.sh storage:elastic-events-roll-index --lock 2>&1 | /usr/bin/logger -t 'elastic-events-roll-index' -p local1.info"
  action action
end
