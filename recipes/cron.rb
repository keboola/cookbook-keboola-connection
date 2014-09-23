

action = node['keboola-connection']['enable_cron'].to_i > 0 ? :create : :delete

cron "token expirator" do
  user "deploy"
  command "/www/connection/current/cli.sh storage:token-expirator --lock >/dev/null 2>&1"
  action action
end

cron "twitter import-export" do
  user "deploy"
  hour "09"
  minute "02"
  command "/www/connection/current/cli.sh twitter:cron:import-export --lock >/dev/null 2>&1"
  action action
end

cron "twitter update-engaged-users" do
  user "deploy"
  hour "07"
  minute "02"
  command "/www/connection/current/cli.sh twitter:cron:update-engaged-users --lock >/dev/null 2>&1"
  action action
end

cron "twitter import-retweets-of-user" do
  user "deploy"
  minute "17"
  command "/www/connection/current/cli.sh twitter:cron:import-retweets-of-user --lock >/dev/null 2>&1"
  action action
end

cron "twitter import-source-tweets" do
  user "deploy"
  minute "*/5"
  command "/www/connection/current/cli.sh twitter:cron:import-source-tweets --lock >/dev/null 2>&1"
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