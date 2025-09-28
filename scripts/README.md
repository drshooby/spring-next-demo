# Scripts

This directory contains deployment automation scripts for the spring-next-demo application.

## Dependencies

### Operating System Requirements
- **Linux/macOS**: Scripts run natively
- **Windows**: Use **Git Bash** or Windows Subsystem for Linux (WSL)
  - `rsync` is not available natively on Windows - Git Bash includes it
  - PowerShell and Command Prompt will not work

### Required Tools
- **rsync**: File synchronization tool
  - Pre-installed on Linux/macOS  
  - Available in Git Bash on Windows
- **ssh/scp**: Secure shell and copy utilities
- **sed**: Stream editor for text manipulation
- **Terraform**: Must be installed and infrastructure deployed (`cd infra && terraform apply`)

## Scripts Overview

### `easy_deploy`
**Purpose**: Automated deployment script that handles the complete deployment process from local machine to remote EC2 instance.

**What it does**:
1. Gets public IP from Terraform output
2. Generates nginx configuration files from templates
3. Syncs application code to EC2 instance using `rsync`
4. Copies deployment configuration files via `scp`
5. Executes remote deployment script on EC2 instance
6. Cleans up temporary files

**Usage**:
```bash
cd scripts/
./easy_deploy
```

**Interactive prompts**:
- Deploy URL (your domain name)
- Email address (for SSL certificates)
- Confirmation of deployment

**Prerequisites**:
- Terraform infrastructure must be deployed (`terraform apply` completed)
- SSH key configured for EC2 access
- Domain nameservers configured with Route53 (see infra/README.md)

### `configure_server`
**Purpose**: Remote server configuration script that runs on the EC2 instance.

**What it does**:
1. Installs Docker if not present
2. Sets up SSL certificate directories
3. Obtains SSL certificates using Let's Encrypt/Certbot
4. Switches from HTTP-only to HTTPS configuration
5. Starts the application using Docker Compose

**Usage**: This script is automatically executed by `easy_deploy` - you don't run it directly.

**Parameters**:
```bash
./configure_server <DEPLOY_URL> <USER_EMAIL>
```

## Usage Workflow

### Complete Deployment Process

1. **Deploy Infrastructure**:
   ```bash
   cd infra/
   terraform apply
   ```

2. **Configure Domain** (see infra/README.md for details):
   - Get nameservers: `terraform output name_servers`
   - Update your domain registrar's DNS settings

3. **Run Deployment**:
   ```bash
   cd ../scripts/
   ./easy_deploy
   ```

4. **Monitor Deployment**: The script will show progress and any errors

### File Synchronization Details

The `easy_deploy` script uses `rsync` to efficiently sync files:

**Client sync**:
```bash
rsync -az --delete \
  --exclude node_modules \
  --exclude .git \
  --exclude .next \
  --exclude out \
  ../client/ ubuntu@${PUBLIC_IP}:/home/ubuntu/client/
```

**Server sync**:
```bash
rsync -az --delete \
  --exclude target \
  --exclude .git \
  --exclude node_modules \
  ../server/ ubuntu@${PUBLIC_IP}:/home/ubuntu/server/
```

**Exclusions**: Build artifacts and dependencies are excluded to reduce transfer time.

## Troubleshooting

### Common Issues

1. **"rsync: command not found" on Windows**:
   - Use Git Bash instead of PowerShell/Command Prompt
   - Install WSL as an alternative

2. **"Could not get public IP from Terraform"**:
   - Ensure `terraform apply` completed successfully
   - Check you're running the script from the `scripts/` directory

3. **SSH connection failures**:
   - Verify your SSH key is configured correctly
   - Check EC2 security group allows SSH (port 22)
   - Ensure EC2 instance is running

4. **SSL certificate failures**:
   - Verify domain DNS is pointing to your server (may take up to 48 hours)
   - Check domain is accessible via HTTP first
   - Ensure email address is valid

### Manual Verification

After deployment, verify your application is running:

```bash
# Check if containers are running
ssh ubuntu@<your-server-ip> 'docker compose ps'

# Check nginx logs
ssh ubuntu@<your-server-ip> 'docker compose logs frontend'

# Check application logs  
ssh ubuntu@<your-server-ip> 'docker compose logs server'
```

## Security Notes

- Scripts require SSH access to EC2 instance
- SSL certificates are automatically renewed via Docker Compose
- All traffic is redirected to HTTPS after certificate installation