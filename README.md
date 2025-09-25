# Spring Next Demo

A full-stack containerized application demonstrating a modern web architecture with a Next.js/React/TypeScript frontend and a Spring Boot backend, deployed on AWS EC2.

## Architecture Overview

This demo showcases a complete full-stack application with the following components:

- **Frontend**: Next.js application with React and TypeScript
- **Backend**: Spring Boot REST API
- **Infrastructure**: AWS EC2 deployment with containerized services
- **Containerization**: Docker containers for both frontend and backend

## Project Structure

```
spring-next-demo/
├── client/           # Next.js/React/TypeScript frontend
├── server/           # Spring Boot backend API
├── infra/            # Infrastructure configuration and deployment scripts
└── README.md         # This file
```

## Components

### Client (Frontend)
- **Technology Stack**: Next.js, React, TypeScript
- **Features**: Modern React application with server-side rendering
- **Containerization**: Dockerized for consistent deployment

### Server (Backend)
- **Technology Stack**: Spring Boot, Java
- **Features**: RESTful API services
- **Containerization**: Dockerized Spring Boot application

### Infrastructure
- **Platform**: AWS EC2
- **Deployment**: Container orchestration on cloud infrastructure
- **Configuration**: Infrastructure as Code for reproducible deployments

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Node.js (for local development)
- Java 17+ (for local development)
- AWS CLI (for deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/drshooby/spring-next-demo.git
   cd spring-next-demo
   ```

2. **Start the backend**
   ```bash
   cd server
   # Follow instructions in server/README.md
   ```

3. **Start the frontend**
   ```bash
   cd client
   # Follow instructions in client/README.md
   ```

### Containerized Development

```bash
# Build and run all services
docker-compose up --build

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8080
```

### Deployment

The application is configured for deployment on AWS EC2. See the `infra/` directory for deployment scripts and configuration.

## Technology Highlights

- **Frontend**: Modern React development with Next.js features like SSR, SSG, and API routes
- **Backend**: Robust Spring Boot application with RESTful architecture
- **Containerization**: Multi-stage Docker builds for optimized production images
- **Cloud Deployment**: Scalable deployment on AWS EC2 infrastructure

## Development Workflow

1. Develop frontend features in the `client/` directory
2. Develop backend APIs in the `server/` directory
3. Test integration using Docker Compose
4. Deploy to AWS EC2 using infrastructure configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker Compose
5. Submit a pull request

## License

This project is a demonstration application. See individual component directories for specific licensing information.
