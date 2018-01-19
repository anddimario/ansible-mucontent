server
{
    listen 80;
    listen [::]:80;
    server_name {{ vhost_name }} www.{{ vhost_name }};

    location /
    {
        proxy_pass http://127.0.0.1:{{ mucontent_port }};
        include /etc/nginx/proxy_params;
    }
}