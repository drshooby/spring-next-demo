# spring-next-demo

A full-stack application demonstrating modern web development with Next.js frontend, Spring Boot backend, deployed on AWS EC2 with Docker containers and automated SSL certificates.

## 🏗️ Architecture Overview

- **Frontend**: Next.js + React + TypeScript (static export)
- **Backend**: Spring Boot + Java 21 + Maven
- **Infrastructure**: AWS EC2, VPC, Route53, Let's Encrypt SSL
- **Deployment**: Docker Compose + NGINX reverse proxy
- **Automation**: Terraform infrastructure + deployment scripts

## 📁 Directory Structure

```
spring-next-demo/
├── client/                 # Next.js frontend application
│   ├── app/               # Next.js App Router pages
│   ├── Dockerfile         # Multi-stage Docker build
│   ├── package.json       # Node.js dependencies
│   └── README.md          # Frontend-specific documentation
├── server/                # Spring Boot backend application  
│   ├── src/               # Java source code
│   ├── Dockerfile         # Multi-stage Docker build
│   ├── pom.xml           # Maven dependencies
│   └── README.md         # Backend-specific documentation
├── infra/                 # Terraform infrastructure as code
│   ├── *.tf              # AWS resource definitions
│   └── README.md         # Infrastructure documentation
├── scripts/               # Deployment automation scripts
│   ├── easy_deploy       # Main deployment script
│   ├── configure_server  # Remote server configuration
│   └── README.md         # Scripts documentation
├── nginx_templates/       # NGINX configuration templates
│   ├── *.conf.tmpl       # HTTP/HTTPS configurations
│   └── README.md         # NGINX configuration guide
├── compose.yaml          # Docker Compose for local development
└── README.md             # This file
```

## 🚀 Quick Start

### Prerequisites

**Operating System**:
- **Linux/macOS**: All commands work natively
- **Windows**: Use **Git Bash** (includes required tools like `rsync`)
  - **Don't use PowerShell or Command Prompt** - they lack required tools

**Required Software**:
- **Docker** (for local development)
- **Node.js 18+** (for client development)
- **Java 17+** (for server development)
- **Terraform** (for AWS infrastructure deployment)

### Local Development

```bash
# 1. Clone the repository
git clone https://github.com/drshooby/spring-next-demo.git
cd spring-next-demo

# 2. Start both frontend and backend
docker compose up --build

# 3. Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8080/hello
```

### Individual Component Development

**Backend Only**:
```bash
cd server/
./mvnw spring-boot:run
# Runs on http://localhost:8080
```

**Frontend Only**:
```bash
cd client/
npm install
npm run dev
# Runs on http://localhost:3000
```

## 🌐 Production Deployment

### Step 1: Deploy AWS Infrastructure

```bash
cd infra/
terraform init
terraform apply
```

**Important**: After deployment, you **MUST** configure your domain registrar:
1. Get nameservers: `terraform output name_servers`
2. Update your domain's DNS settings with these 4 nameservers
3. Wait for DNS propagation (up to 48 hours)

For detailed infrastructure documentation, see [`infra/README.md`](infra/README.md).

### Step 2: Deploy Application

```bash
cd scripts/
./easy_deploy
```

The script will:
- Prompt for your domain name and email
- Sync code to EC2 instance
- Configure SSL certificates
- Start the application with HTTPS

For detailed deployment documentation, see [`scripts/README.md`](scripts/README.md).

## 🏗️ Component Documentation

Each directory contains detailed documentation:

- **[`client/README.md`](client/README.md)**: Next.js frontend development
- **[`server/README.md`](server/README.md)**: Spring Boot backend development  
- **[`infra/README.md`](infra/README.md)**: AWS infrastructure setup
- **[`scripts/README.md`](scripts/README.md)**: Deployment automation
- **[`nginx_templates/README.md`](nginx_templates/README.md)**: NGINX configuration and API routing

## 🔧 Dependencies

### Development Dependencies

| Component | Requirement | Purpose |
|-----------|-------------|---------|
| **Node.js 18+** | Frontend | Next.js development and build |
| **Java 17+** | Backend | Spring Boot application |
| **Docker** | Both | Containerization and local development |
| **Git Bash** | Windows only | Provides `rsync` and shell tools |

### Deployment Dependencies

| Tool | Purpose | Alternative |
|------|---------|-------------|
| **Terraform** | Infrastructure automation | Manual AWS Console setup |
| **rsync** | File synchronization | Included in Git Bash (Windows) |
| **ssh/scp** | Remote server access | Built into most systems |

### Check Your Installation

```bash
# Check required tools
node --version    # Should be v18.0.0+
java --version    # Should be 17+
docker --version  # Any recent version
terraform --version  # 1.0+

# Windows users check Git Bash
rsync --version   # Should work in Git Bash
```

## 🔀 API Integration

### Current Endpoints

- `GET /hello` - Test endpoint returning "Hello from Spring Boot!"

### Adding New Endpoints

1. **Add Spring Boot endpoint** (see [`server/README.md`](server/README.md)):
   ```java
   @GetMapping("/api/test")
   public String test() {
       return "Test endpoint working!";
   }
   ```

2. **Update NGINX configuration** (see [`nginx_templates/README.md`](nginx_templates/README.md)):
   ```nginx
   location /api/test {
       proxy_pass http://server:8080/api/test;
       # ... proxy headers
   }
   ```

3. **Call from frontend**:
   ```typescript
   const response = await fetch('/api/test')
   const data = await response.text()
   ```

## 🐳 Docker Architecture

### Multi-stage Builds

Both components use optimized Docker builds:

**Client** (3 stages):
1. **Dependencies**: Install npm packages
2. **Build**: Generate static files  
3. **Runtime**: NGINX serving static files

**Server** (2 stages):
1. **Build**: Maven compile and package
2. **Runtime**: OpenJDK with layered JAR

### Local Development

```bash
# Build individual components
cd client && docker build -t client .
cd server && docker build -t server .

# Or use Docker Compose
docker compose build
docker compose up
```

## 🔒 Security Features

- **SSL/TLS**: Automatic Let's Encrypt certificates
- **HTTPS Redirect**: All HTTP traffic redirected to HTTPS
- **Non-root Containers**: Docker containers run as non-root users
- **Security Groups**: AWS firewall rules restrict access
- **SSL Hardening**: Modern TLS protocols and ciphers

## 🚨 Troubleshooting

### Common Issues

**Windows "rsync not found"**:
- Use Git Bash instead of PowerShell/Command Prompt
- Install WSL as alternative

**Docker permission denied**:
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

**Java version conflicts**:
```bash
# Check multiple Java versions
update-alternatives --list java  # Linux
/usr/libexec/java_home -V        # macOS
```

**Domain not accessible**:
- Verify nameservers are configured with registrar
- Check DNS propagation: `nslookup your-domain.com`
- Allow 24-48 hours for full propagation

## 🧪 Testing

### Local Testing

```bash
# Test backend
cd server && ./mvnw test

# Test frontend build  
cd client && npm run build

# Test full stack
docker compose up --build
curl http://localhost:3000
curl http://localhost:8080/hello
```

### Production Testing

```bash
# After deployment
curl https://your-domain.com/hello
curl https://your-domain.com/

# Check SSL certificate
openssl s_client -connect your-domain.com:443 -servername your-domain.com
```

## 💰 AWS Cost Considerations

**Monthly Costs** (approximate):
- **EC2 t3.micro**: Free tier eligible, ~$8.50/month after
- **Route53 hosted zone**: ~$0.50/month
- **NAT Gateway**: ~$32/month (can be optimized)
- **Data transfer**: Variable based on usage

**Cost Optimization**:
- Use single NAT Gateway (already configured)
- Consider t3.micro or t3.small instance types
- Monitor data transfer costs

## 📊 Monitoring

### Application Health

```bash
# Check container status
ssh ubuntu@your-server-ip 'docker compose ps'

# View logs
ssh ubuntu@your-server-ip 'docker compose logs frontend'
ssh ubuntu@your-server-ip 'docker compose logs server'
```

### System Health

```bash
# Check disk usage
ssh ubuntu@your-server-ip 'df -h'

# Check memory usage
ssh ubuntu@your-server-ip 'free -m'

# Check SSL certificate expiry
ssh ubuntu@your-server-ip 'docker compose logs certbot'
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker Compose
5. Submit a pull request

## 📄 License

This project is provided as-is for demonstration and learning purposes.
