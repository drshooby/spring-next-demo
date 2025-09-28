# NGINX Templates

This directory contains NGINX configuration templates used during deployment to set up reverse proxy and SSL termination for the spring-next-demo application.

## Overview

The templates use a placeholder-based system where `DEPLOY_URL_PLACEHOLDER` is automatically replaced with your actual domain during deployment.

## Template Files

### `nginx-https.conf.tmpl`
**Purpose**: Production NGINX configuration with SSL/HTTPS support and API proxying.

**Features**:
- HTTP to HTTPS redirect (port 80 → 443)
- SSL certificate configuration for Let's Encrypt
- Static file serving for Next.js frontend
- Reverse proxy for Spring Boot API endpoints
- Security headers and SSL hardening

### `nginx-http-only.conf.tmpl`  
**Purpose**: Temporary configuration used during SSL certificate generation.

**Features**:
- HTTP-only server (port 80)
- ACME challenge support for Let's Encrypt
- Simple response for certificate validation

## How Templates Work

1. **During deployment**: The `easy_deploy` script processes templates using `sed`:
   ```bash
   sed "s|DEPLOY_URL_PLACEHOLDER|${DEPLOY_URL}|g" nginx-https.conf.tmpl > nginx.conf
   ```

2. **Placeholder replacement**: `DEPLOY_URL_PLACEHOLDER` becomes your actual domain (e.g., `example.com`)

3. **File generation**: Creates ready-to-use NGINX configuration files

## NGINX Configuration Explained

### Basic Structure (nginx-https.conf.tmpl)

```nginx
# HTTP server - redirects to HTTPS
server {
    listen 80;
    server_name your-domain.com;
    
    # Let's Encrypt certificate validation
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    # Redirect everything else to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}

# HTTPS server - main application
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    # SSL certificates (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # Serve static files (Next.js frontend)
    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }
    
    # Proxy API requests to Spring Boot
    location /hello {
        proxy_pass http://server:8080/hello;
        # Headers for proper proxying...
    }
}
```

## Adding New API Endpoints

### Simple Endpoint Example
To add a new API endpoint like `/api/test`, add this location block to `nginx-https.conf.tmpl`:

```nginx
# Add this inside the HTTPS server block, after the /hello location
location /api/test {
    proxy_pass http://server:8080/api/test;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### Complex API Routing Examples

**1. Proxy all `/api/*` paths**:
```nginx
location /api/ {
    proxy_pass http://server:8080/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # Optional: Handle CORS for API requests
    add_header Access-Control-Allow-Origin *;
}
```

**2. Different backend services**:
```nginx
# User service
location /api/users {
    proxy_pass http://user-service:8081/api/users;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

# Order service  
location /api/orders {
    proxy_pass http://order-service:8082/api/orders;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

**3. Advanced routing with regex**:
```nginx
# Route /api/v1/* and /api/v2/* to different backends
location ~ ^/api/v1/(.*)$ {
    proxy_pass http://server:8080/api/v1/$1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

location ~ ^/api/v2/(.*)$ {
    proxy_pass http://server-v2:8080/api/v2/$1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

**4. Static file handling with fallback**:
```nginx
# Serve uploaded files
location /uploads/ {
    alias /var/www/uploads/;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# API with file upload support
location /api/upload {
    client_max_body_size 50M;  # Allow large file uploads
    proxy_pass http://server:8080/api/upload;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

## Testing Configuration Changes

### 1. Local Testing (HTTP only)
Before deploying, test your nginx configuration locally using Docker:

```bash
# Create a test config (replace DEPLOY_URL_PLACEHOLDER with localhost)
cd nginx_templates/
sed 's|DEPLOY_URL_PLACEHOLDER|localhost|g' nginx-https.conf.tmpl > test-nginx.conf

# Remove SSL configuration for local testing (edit test-nginx.conf)
# Keep only the HTTP server block and remove SSL directives
```

### 2. Validate Syntax
```bash
# Test nginx configuration syntax
docker run --rm -v $(pwd)/test-nginx.conf:/etc/nginx/conf.d/default.conf nginx nginx -t
```

### 3. Deploy and Test
After updating templates and deploying:
```bash
# Test endpoints
curl https://your-domain.com/hello
curl https://your-domain.com/api/test

# Check nginx logs on server
ssh ubuntu@your-server-ip 'docker compose logs frontend'
```

## Important Notes

- **Always test locally first** before deploying configuration changes
- **Backup your working configuration** before making changes
- **Location order matters** in NGINX - more specific patterns should come before general ones
- **SSL certificates** are automatically handled by Let's Encrypt/Certbot
- **Service names** like `server:8080` refer to Docker Compose service names