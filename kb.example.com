server {
    listen 80;
    listen [::]:80;
    server_name kb.example.com;
    return 301 https://$host$request_uri;
}
server {
    listen 443 ssl;
    server_name kb.example.com;
    ssl_certificate /etc/nginx/ssl/kb.example.com.chained.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    ssl_protocols TLSv1 TLSV1.1 TLSv1.2;
    ssl_ciphers   HIGH:!aNULL:!MD5;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location / {
        proxy_pass_header Authorization;
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Connection "";
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_buffering off;
        client_max_body_size 0;
        proxy_read_timeout 36000s;
        proxy_redirect off;
    }
}
