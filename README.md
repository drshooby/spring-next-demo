# spring-next-demo
full-stack app with next, react and spring - deployed on EC2

### Project Structure Summary
- **Client**: Next.js with TypeScript, served by NGINX in production
- **Server**: Spring Boot with Maven, providing REST API
- **Reverse Proxy**: NGINX handles routing and SSL with Certbot
- **Communication**: Frontend calls backend via `/hello` endpoint
- **Deployment**: Containerized services with Docker Compose

> **Note:** While this code has been locally tested, the repository only contains production deployment scripts. No local development setup is included.

App:  
<img width="890" height="408" alt="image" src="https://github.com/user-attachments/assets/0bf471af-5de6-4f5a-b808-36718307e655" />

Architecture Diagram:  
<img width="826" height="399" alt="image" src="https://github.com/user-attachments/assets/cbdb431f-7c4c-4b52-92d2-19dbac1fc375" />
