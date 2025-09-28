# spring-next-demo
full-stack app with next, react and spring - deployed on EC2

### Project Structure Summary
- **Client**: Next.js with TypeScript, served by NGINX in production
- **Server**: Spring Boot with Maven, providing REST API
- **Reverse Proxy**: NGINX handles routing and SSL with Certbot
- **Communication**: Frontend calls backend via `/hello` endpoint
- **Deployment**: Containerized services with Docker Compose

> **Note:** While this code has been locally tested, the repository only contains production deployment scripts. No local development setup is included.
