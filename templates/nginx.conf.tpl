user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
  worker_connections 768;
  # multi_accept on;
}

http {
  # Prevent flood
  limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
  limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;

  # Format log
  log_format timed_combined '$remote_addr - $remote_user [$time_local] '
    '"$request" $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '$request_time $upstream_response_time $pipe';

  # Look for client IP in the X-Forwarded-For header
  real_ip_header X-Forwarded-For;

  # Ignore trusted IPs
  real_ip_recursive on;

  set_real_ip_from 0.0.0.0/0;

  ##
  # Basic Settings
  ##

  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  server_tokens off;

  # server_names_hash_bucket_size 64;
  # server_name_in_redirect off;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # SSL Settings
  ##

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  ##
  # Logging Settings
  ##

  access_log /var/log/nginx/access.log timed_combined;
  error_log /var/log/nginx/error.log;

  ##
  # Gzip Settings
  ##

  gzip on;
  gzip_disable "msie6";

  gzip_vary on;
  gzip_proxied any;
  gzip_comp_level 6;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_min_length 256;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;

  ##
  # MUCONTENT
  ##
  ##buffer policy 
  client_body_buffer_size 1K; 
  client_header_buffer_size 1k; 
  client_max_body_size 1k; 
  large_client_header_buffers 2 1k; 
  ##end buffer policy

  # config to don't allow the browser to render the page inside an frame or iframe
  # and avoid clickjacking http://en.wikipedia.org/wiki/Clickjacking
  # if you need to allow [i]frames, you can use SAMEORIGIN or even set an uri with ALLOW-FROM uri
  # https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options
  add_header X-Frame-Options SAMEORIGIN;

  # when serving user-supplied content, include a X-Content-Type-Options: nosniff header along with the Content-Type: header,
  # to disable content-type sniffing on some browsers.
  # https://www.owasp.org/index.php/List_of_useful_HTTP_headers
  # currently suppoorted in IE > 8 http://blogs.msdn.com/b/ie/archive/2008/09/02/ie8-security-part-vi-beta-2-update.aspx
  # http://msdn.microsoft.com/en-us/library/ie/gg622941(v=vs.85).aspx
  # 'soon' on Firefox https://bugzilla.mozilla.org/show_bug.cgi?id=471020
  add_header X-Content-Type-Options nosniff;

  # This header enables the Cross-site scripting (XSS) filter built into most recent web browsers.
  # It's usually enabled by default anyway, so the role of this header is to re-enable the filter for 
  # this particular website if it was disabled by the user.
  # https://www.owasp.org/index.php/List_of_useful_HTTP_headers
  add_header X-XSS-Protection "1; mode=block";
}

