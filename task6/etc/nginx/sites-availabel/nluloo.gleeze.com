
log_format  proxy_log  '[$time_local] $remote_addr - $remote_user "$http_host$request_uri" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$proxy_add_x_forwarded_for"'
                      ' Proxy: "$proxy_host" "$upstream_addr"';

access_log /var/log/nginx/proxy_log.log proxy_log;


upstream redblue{
        least_conn;
        server 127.0.0.1:8082;
        server 127.0.0.1:8083;
}


server {
	
	server_name nluloo.gleeze.com;

	root /var/www/task4/;
	index index.html index.htm index.nginx-debian.html;


		location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

	listen [::]:443 ssl ipv6only=on; # managed by Certbot
	listen 443 ssl; # managed by Certbot
	ssl_certificate /etc/letsencrypt/live/nluloo.gleeze.com/fullchain.pem; # managed by Certbot
	ssl_certificate_key /etc/letsencrypt/live/nluloo.gleeze.com/privkey.pem; # managed by Certbot
	include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot



	location /other {
		proxy_pass http://127.0.0.1:8000/;

                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

	}

	location /secondpage{
		proxy_pass http://127.0.0.1:8081/;
		proxy_set_header Host $http_host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}

	location /secondserver{
		return 301 https://google.com;
	}
	location /redblue{
		proxy_pass http://redblue/;
		proxy_set_header Host $http_host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}

	location ~* \.png$ {
	        alias /var/www/task4/resources;
	 	try_files $uri =404;
	}

	location ~* \.jpg$ {
	    alias /var/www/task4/resources;
	    try_files $uri =404;
	    image_filter rotate 180;             
	}

	location /image1 {
	    rewrite ^/image1$ /image1.jpg break;
	    root /var/www/task4/resources;
	    image_filter rotate 180;
	}

	location /image2 {
	    rewrite ^/image2$ /image2.png break;
	    root /var/www/task4/resources;
	    try_files $uri =404;
	}


	location /music {
	    alias /var/www/music/;
	    add_header Content-Disposition 'attachment; filename="Lad.mp3"';    
	    add_header Content-type aplication/octet-stream;
	    try_files /Lad.mp3 =404;
	}

	location /cpu{
		alias /var/www/task6/;
		index index.html

		try_files $uri $uri/ =404;
	}
	location /error {
	return 500;
}
}
server {
	listen 8000;
	root /var/www/other_page/;
	index index.html index.htm index.nginx-debian.html;

	location /{
	try_files $uri $uri/ =404;
	}
}
