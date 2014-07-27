def generate_php_fpm_config domain_name, user_name
  <<EOS
[#{domain_name}]
prefix = /home/#{user_name}/
listen = /home/#{user_name}/socket/socket
listen.owner = www-data
listen.group = www-data
listen.mode = 0660
user = #{user_name}
group = #{user_name}

pm = dynamic
pm.max_children = 10
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 5
pm.max_requests = 50
catch_workers_output = yes
request_terminate_timeout = 75
request_slowlog_timeout = 15
slowlog = logs/slow.log
chdir = /home/#{user_name}/public_html
env[HOSTNAME] = server
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/#{user_name}/tmp
env[TMPDIR] = /home/#{user_name}/tmp
env[TEMP] = /home/#{user_name}/tmp
include = /home/#{user_name}/php/php.pool.conf
EOS
end

def generate_php_local_file domain_name, user_name
  <<EOS
php_flag[display_errors] = off
php_admin_value[error_log] = logs/error_php.log
php_admin_flag[log_errors] = on
php_admin_value[memory_limit] = 32M
EOS
end
