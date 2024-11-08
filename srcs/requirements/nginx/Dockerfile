FROM	debian:bullseye

EXPOSE	443

RUN		apt-get update \ 
		&& apt-get install -y \
			nginx \
			openssl

# Replace the default Nginx configuration with our custom configuration.
COPY	conf/nginx.conf /etc/nginx/nginx.conf

# Generate a self-signed SSL certificate. 
# This is needed to enable HTTPS on the Nginx server.
RUN		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/cert.key \
		-out /etc/nginx/cert.crt \
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCATION}/O=${ORGANIZATION}/CN=${COMMON_NAME}"

ENTRYPOINT ["nginx", "-g", "daemon off;"]
