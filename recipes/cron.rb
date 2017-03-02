

action = node['keboola-connection']['enable_cron'].to_i > 0 ? :create : :delete

cron "components sync" do
  user "deploy"
  command "/www/connection/current/cli.sh storage:sync-components #{node['keboola-connection']['syrup_url']} --lock 2>&1 | /usr/bin/logger -t 'components-sync' -p local1.info"
  minute "*/5"
  action action
end

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

cron "publish project metrics" do
  user "deploy"
  minute "08"
  hour "00"
  command "/www/connection/current/cli.sh storage:publish-projects-stats --lock 2>&1 | /usr/bin/logger -t 'publish-projects-stats' -p local1.info"
  action action
end

cron "metrics snapshots" do
  user "deploy"
  minute "12"
  command "/www/connection/current/cli.sh storage:snapshot-project-metrics --lock 2>&1 | /usr/bin/logger -t 'snapshot-project-metrics' -p local1.info"
  action action
end
