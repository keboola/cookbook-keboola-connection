

action = node['keboola-connection']['enable_cron'].to_i > 0 ? :create : :delete

cron "token expirator" do
  user "deploy"
  command "/www/connection/current/cli.sh storage:token-expirator --lock >/dev/null 2>&1"
  action action
end

cron "elastic events roll index" do
  user "deploy"
  hour "00"
  minute "00"
  day "1"
  command "/www/connection/current/cli.sh storage:elastic-events-roll-index --lock >/dev/null 2>&1"
  action action
end
