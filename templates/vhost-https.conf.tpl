server {
  listen 80;
  listen [::]:80;

  location / {
    return 302 https://$host$request_uri;
  }
}

server {
  listen 443 ssl spdy;
  ssl_certificate /etc/ssl/certs/{{ vhost_name }}.crt;
  ssl_certificate_key /etc/ssl/private/{{ vhost_name }}.key;
  server_name {{ vhost_name }} www.{{ vhost_name }};

  # enables server-side protection from BEAST attacks
  # http://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html
  ssl_prefer_server_ciphers on;
  # disable SSLv3(enabled by default since nginx 0.8.19) since it's less secure then TLS http://en.wikipedia.org/wiki/Secure_Sockets_Layer#SSL_3.0
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  # ciphers chosen for forward secrecy and compatibility
  # http://blog.ivanristic.com/2013/08/configuring-apache-nginx-and-openssl-for-forward-secrecy.html
  ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';

  # config to enable HSTS(HTTP Strict Transport Security) https://developer.mozilla.org/en-US/docs/Security/HTTP_Strict_Transport_Security
  # to avoid ssl stripping https://en.wikipedia.org/wiki/SSL_stripping#SSL_stripping
  # also https://hstspreload.org/
  add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";

  location / {
    proxy_pass http://127.0.0.1:{{ mucontent_port }};
    include /etc/nginx/proxy_params;
  }
}