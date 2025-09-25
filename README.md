# spring-next-demo
full-stack app with next, react and spring - deployed on EC2

## Directory Structure

This repository contains a full-stack application with a clear separation between frontend and backend components:

```
spring-next-demo/
├── client/                 # Next.js frontend application
├── server/                 # Spring Boot backend application
├── compose.yaml           # Docker Compose configuration for local development
├── .gitignore            # Git ignore rules for the root project
└── README.md             # This file
```

### Client Directory (`client/`)
The frontend is built with Next.js, React, and TypeScript:

```
client/
├── app/                   # Next.js App Router directory
│   ├── globals.css        # Global CSS styles
│   ├── layout.tsx         # Root layout component
│   ├── page.tsx          # Home page component (calls Spring Boot API)
│   ├── page.module.css   # Page-specific CSS modules
│   └── favicon.ico       # Site favicon
├── .dockerignore         # Docker ignore rules for client
├── .gitignore           # Git ignore rules for client
├── Dockerfile           # Multi-stage Docker build for production
├── README.md            # Next.js specific documentation
├── eslint.config.mjs    # ESLint configuration
├── next.config.ts       # Next.js configuration (exports static site)
├── nginx.conf           # NGINX configuration for production deployment
├── package.json         # Node.js dependencies and scripts
├── package-lock.json    # Locked dependency versions
└── tsconfig.json        # TypeScript configuration
```

### Server Directory (`server/`)
The backend is built with Spring Boot and Java:

```
server/
├── src/
│   ├── main/
│   │   ├── java/com/example/server/
│   │   │   ├── ServerApplication.java     # Spring Boot main application class
│   │   │   └── controllers/
│   │   │       └── HelloController.java   # REST API controller (/hello endpoint)
│   │   └── resources/
│   │       └── application.properties     # Spring Boot configuration
│   └── test/
│       └── java/com/example/server/
│           └── ServerApplicationTests.java # Basic Spring Boot tests
├── .mvn/                 # Maven wrapper configuration
├── .dockerignore         # Docker ignore rules for server
├── .gitignore           # Git ignore rules for server
├── .gitattributes       # Git attributes configuration
├── Dockerfile           # Multi-stage Docker build for production
├── mvnw                 # Maven wrapper script (Unix)
├── mvnw.cmd             # Maven wrapper script (Windows)
└── pom.xml              # Maven project configuration and dependencies
```

### Configuration Files

- **`compose.yaml`**: Docker Compose configuration for local development
  - Builds and runs both client and server containers
  - Exposes client on port 3000 (via NGINX) and server on port 8080
  - Sets up service dependencies

- **Client Configuration**:
  - `next.config.ts`: Configures Next.js for static export
  - `nginx.conf`: NGINX configuration for production deployment with API proxying
  - `eslint.config.mjs`: Code linting rules for TypeScript/React

- **Server Configuration**:
  - `pom.xml`: Maven dependencies (Spring Boot Web, Test)
  - `application.properties`: Server configuration (port 8080, bind to all interfaces)

### Docker Architecture

Both client and server use multi-stage Docker builds for optimized production images:

- **Client**: Node.js build → Static export → NGINX serving
- **Server**: Maven build → OpenJDK runtime with layered JAR optimization

The application is designed to be deployed on EC2 with NGINX handling both static file serving and API proxying to the Spring Boot backend.

## Quick Start

### Local Development with Docker Compose
```bash
# Build and run both services
docker compose up --build

# Access the application
# Frontend: http://localhost:3000
# Backend API: http://localhost:8080/hello
```

### Individual Development
```bash
# Run server (requires Java 21)
cd server
./mvnw spring-boot:run

# Run client (requires Node.js)
cd client
npm install
npm run dev
```

### Project Structure Summary
- **Frontend**: Next.js with TypeScript, served by NGINX in production
- **Backend**: Spring Boot with Maven, providing REST API
- **Communication**: Frontend calls backend via `/hello` endpoint
- **Deployment**: Containerized services with Docker Compose
