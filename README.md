# Spring Next Demo

Full-stack containerized application with Next.js/React/TypeScript frontend and Spring Boot backend, deployed on AWS EC2.

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Node.js (for local development)
- Java 17+ (for local development)
- AWS CLI (for deployment)

### Local Development

```bash
git clone https://github.com/drshooby/spring-next-demo.git
cd spring-next-demo

# Start backend
cd server
# Follow server/README.md

# Start frontend  
cd client
# Follow client/README.md
```

### Containerized Development

```bash
docker-compose up --build

# Frontend: http://localhost:3000
# Backend API: http://localhost:8080
```

### Deployment

See `infra/` directory for AWS EC2 deployment configuration.
