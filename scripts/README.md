# Easy Deploy Script

This project includes a pair of Bash scripts that automate the process of deploying a web application to an AWS EC2 instance created with Terraform.  
They handle configuration, file uploads, Docker setup, SSL certificates, and final deployment — all with minimal manual work.

> **NOTE** For Windows, this is best run in Git Bash for `rsync` availability.

---

## Overview

### What this script does

The **easy_deploy** script:

1. Collects your deployment URL (e.g., `myproject.com`) and your email (for SSL registration).
2. Fetches the public IP of your EC2 instance from Terraform.
3. Generates Nginx configuration files based on your domain name.
4. Uploads your client and server code, along with configuration files, to the EC2 instance.
5. Runs a remote setup script (`configure_server`) that:
   - Installs Docker if missing.
   - Sets up directories for SSL certificates.
   - Launches temporary containers to perform the SSL certificate challenge using **Certbot**.
   - Switches to a secure HTTPS configuration.
   - Starts your application using **Docker Compose**.

---

## Prerequisites

Before using `easy_deploy`, make sure you have:

- **An EC2 instance deployed** with your Terraform configuration (and `terraform apply` completed).
- **Terraform output** that exposes the EC2’s public IP (this script depends on it).
- **SSH access** to the EC2 instance using the same keypair configured in Terraform.
- **Docker Compose file** (`compose.yaml`) and Nginx templates available in your project directories:
  - `../nginx_templates/nginx-http-only.conf.tmpl`
  - `../nginx_templates/nginx-https.conf.tmpl`
- **Project directories**:

```
  project-root/
  ├── infra/ # Terraform files
  ├── client/ # Frontend code
  ├── server/ # Backend code
  ├── scripts/
     ├── easy_deploy # Local deploy script
     ├── configure_server # Remote deploy script
  ├── nginx_templates/ # Nginx config templates
  └── compose.yaml # Docker Compose configuration
```

---

## How to Use

### 1. Run the Easy Deploy Script

From your local machine (in the `deploy` folder):

```bash
chmod +x easy_deploy
./easy_deploy
```

### 2. Enter Required Information

The script will prompt you for:

- **Deployment URL** — your full domain (e.g., cs601f.ettukube.com).
- **Email Address** — used for SSL certificate registration with Let’s Encrypt.

You’ll see a confirmation like:

```bash
Deployment URL:    cs601f.ettukube.com
Certbot Email:     you@example.com
```

Type `Y` to continue.

### 3. What Happens Next

1. The script runs:

```bash
terraform output --raw public_ip
```

to get the EC2’s IP address. If Terraform hasn’t been applied yet, this step will fail.

2. Two NGINX config files are generated automatically:

```
nginx-http-only.conf # used temporarily for SSL setup
nginx.conf # used for the final HTTPS deployment
```

Each file replaces placeholders in the template with your domain name.

3. Upload files:

Your code and configuration files are uploaded to the EC2 instance using `rsync` and `scp`:

```
Frontend → /home/ubuntu/client
Backend → /home/ubuntu/server
Compose + Config files → /home/ubuntu
```

4. Remote setup:

Once files are uploaded, the `configure_server` script is executed remotely via SSH.

This script performs the following tasks:

```
1. Installs Docker if it’s not already present.
2. Prepares directories for Certbot certificates.
3. Starts containers using the HTTP-only config.
4. Waits for Nginx to respond before running Certbot.
5. Requests an SSL certificate from Let’s Encrypt.
6. Stops containers, switches to HTTPS config, and restarts the stack securely.
7. Displays running services using docker compose ps.
```

5. Lastly, the script cleans up any additional local artifacts created.
