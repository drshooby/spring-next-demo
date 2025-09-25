# Server (Backend)

This directory contains the backend API built with Spring Boot and Java.

## Technology Stack

- **Spring Boot**: Java framework for building production-ready applications
- **Spring Web**: RESTful web services and MVC architecture
- **Spring Data JPA**: Data access layer with ORM capabilities
- **Spring Security**: Authentication and authorization (if implemented)
- **Maven**: Dependency management and build tool

## Features

- RESTful API endpoints for frontend integration
- Data persistence with JPA/Hibernate
- Cross-origin resource sharing (CORS) configuration for frontend access
- Production-ready configuration with profiles
- Health checks and monitoring endpoints
- Containerized deployment with Docker

## Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Docker (for containerized development)
- Database (H2 for development, PostgreSQL/MySQL for production)

### Local Development

```bash
# Build the application
mvn clean compile

# Run tests
mvn test

# Start the application
mvn spring-boot:run

# The API will be available at http://localhost:8080
```

### Building for Production

```bash
# Build executable JAR
mvn clean package

# Run the JAR file
java -jar target/spring-next-demo-server.jar
```

### Docker Development

```bash
# Build the container
docker build -t spring-next-demo-server .

# Run the container
docker run -p 8080:8080 spring-next-demo-server
```

## Project Structure

```
server/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/springnextdemo/
│   │   │       ├── SpringNextDemoApplication.java
│   │   │       ├── controller/     # REST controllers
│   │   │       ├── service/        # Business logic services
│   │   │       ├── repository/     # Data access repositories
│   │   │       ├── model/          # Entity classes
│   │   │       ├── dto/            # Data Transfer Objects
│   │   │       └── config/         # Configuration classes
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── application-dev.properties
│   │       └── application-prod.properties
│   └── test/
│       └── java/                   # Unit and integration tests
├── Dockerfile                      # Docker configuration
├── pom.xml                        # Maven configuration
└── README.md                      # This file
```

## API Endpoints

The server provides RESTful endpoints for the frontend application:

```
GET    /api/health              # Health check
GET    /api/status              # Application status
POST   /api/data                # Create data
GET    /api/data                # Retrieve data
PUT    /api/data/{id}           # Update data
DELETE /api/data/{id}           # Delete data
```

## Configuration

### Development Profile
- Uses H2 in-memory database
- Debug logging enabled
- CORS configured for localhost:3000

### Production Profile
- External database configuration
- Optimized logging
- Security configurations
- Health monitoring endpoints

## Environment Variables

Configure the following environment variables for different environments:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=springnextdemo
DB_USERNAME=user
DB_PASSWORD=password

# Application Configuration
SERVER_PORT=8080
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://your-domain.com

# Profile Selection
SPRING_PROFILES_ACTIVE=dev
```

## Database

The application supports multiple database configurations:

- **Development**: H2 in-memory database
- **Production**: PostgreSQL or MySQL with proper connection pooling
- **Testing**: H2 for unit and integration tests

## Security

Security features include:
- CORS configuration for cross-origin requests
- Input validation and sanitization
- Error handling without sensitive information exposure
- Production-ready security headers

## Monitoring and Health Checks

Spring Boot Actuator provides:
- `/actuator/health` - Application health status
- `/actuator/info` - Application information
- `/actuator/metrics` - Application metrics

## Testing

```bash
# Run unit tests
mvn test

# Run integration tests
mvn integration-test

# Generate test coverage report
mvn jacoco:report
```

## Deployment

The server application is containerized and deployed on AWS EC2 with:
- Multi-stage Docker builds for optimized image size
- Production database connectivity
- Load balancing and scaling capabilities
- Monitoring and logging integration

## Development Guidelines

- Follow Spring Boot best practices
- Implement proper error handling and validation
- Write comprehensive unit and integration tests
- Use proper logging with structured output
- Document API endpoints with OpenAPI/Swagger