def generate_nginx_config(domain_name, folder_name)
  return <<EOS
server {
  root /home/#{folder_name}/public_html;
  index index.php index.html index.htm default.html default.htm;
  access_log /home/#{folder_name}/logs/nginx.access.log;
  error_log /home/#{folder_name}/logs/nginx.error.log;
  server_name www.#{domain_name} #{domain_name};
  server_tokens off;

  location ~* /(images|cache|media|logs|tmp)/.*\.(php|pl|py|jsp|asp|sh|cgi)$ {
    error_page 403 /403_error.html;
    return 403;
  }

  location /phpmyadmin {
    alias /usr/share/phpmyadmin;
    try_files $uri $uri/ /index.php?$args;
  }

  location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
    root /usr/share;
  }

  location ~ ^/phpmyadmin(.+\.php)$ {
    alias /usr/share/phpmyadmin$1;
    fastcgi_pass unix:/home/srosrt/socket/socket;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /usr/share/phpmyadmin$1;
    fastcgi_param  DOCUMENT_ROOT      /usr/share/phpmyadmin;
    include fastcgi_params;
  }


  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    access_log /home/#{folder_name}/logs/nginx.php.access.log;
    fastcgi_pass   unix:/home/#{folder_name}/socket/socket;
    fastcgi_index  index.php;
    fastcgi_param  DOCUMENT_ROOT    /home/#{folder_name}/public_html;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param  PATH_TRANSLATED  $document_root$fastcgi_script_name;

    include fastcgi_params;
    fastcgi_param  QUERY_STRING     $query_string;
    fastcgi_param  REQUEST_METHOD   $request_method;
    fastcgi_param  CONTENT_TYPE     $content_type;
    fastcgi_param  CONTENT_LENGTH   $content_length;
    fastcgi_intercept_errors        on;
    fastcgi_ignore_client_abort     off;
    fastcgi_connect_timeout 60;
    fastcgi_send_timeout 180;
    fastcgi_read_timeout 180;
    fastcgi_buffer_size 128k;
    fastcgi_buffers 4 256k;
    fastcgi_busy_buffers_size 256k;
    fastcgi_temp_file_write_size 256k;
  }


   # caching of files
  location ~* \.(ico|pdf|flv)$ {
    expires 1y;
  }

  location ~* \.(js|css|png|jpg|jpeg|gif|swf|xml|txt)$ {
    expires 14d;
  }
  location ~ /\. {
    access_log off;
    log_not_found off;
    deny all;
  }
}
EOS
end
