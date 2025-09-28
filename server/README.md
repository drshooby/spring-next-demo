# Server (Spring Boot Backend)

This directory contains the Spring Boot backend application that provides REST API endpoints for the spring-next-demo project.

## Overview

A minimal Spring Boot application with:
- REST API controller serving `/hello` endpoint
- Dockerized deployment with optimized multi-stage builds
- Maven build system with wrapper included

## Dependencies

### Required Software
- **Java 17+**: Download from [OpenJDK](https://openjdk.org/) or [Oracle JDK](https://oracle.com/java/)
- **Maven** (optional): Use included Maven wrapper (`mvnw` / `mvnw.cmd`)
- **Docker** (for containerized deployment)

### Check Java Installation
```bash
java --version
# Should show Java 17 or higher
```

## Project Structure

```
server/
├── src/
│   ├── main/
│   │   ├── java/com/example/server/
│   │   │   ├── ServerApplication.java     # Main Spring Boot application
│   │   │   └── controllers/
│   │   │       └── HelloController.java   # REST API controller
│   │   └── resources/
│   │       └── application.properties     # Spring configuration
│   └── test/
│       └── java/com/example/server/
│           └── ServerApplicationTests.java # Unit tests
├── .mvn/                 # Maven wrapper configuration
├── Dockerfile           # Multi-stage Docker build
├── mvnw                 # Maven wrapper (Unix/Linux/macOS)
├── mvnw.cmd             # Maven wrapper (Windows)
└── pom.xml              # Maven dependencies and build configuration
```

## Usage Steps

### Local Development

#### 1. Run with Maven (Development)
```bash
cd server/
./mvnw spring-boot:run
```
Application starts on `http://localhost:8080`

#### 2. Test the API
```bash
# Test the hello endpoint
curl http://localhost:8080/hello
# Expected response: "Hello from Spring Boot!"
```

#### 3. Run Tests
```bash
./mvnw test
```

#### 4. Build JAR
```bash
./mvnw clean package
java -jar target/*.jar
```

### Docker Development

#### Build and Run
```bash
cd server/
docker build -t spring-server .
docker run -p 8080:8080 spring-server
```

### Production Deployment

The server is deployed using Docker Compose as part of the complete application stack (see root `compose.yaml`).

## Configuration

### `application.properties`
```properties
server.port=8080
server.address=0.0.0.0
```

- **Port 8080**: Standard Spring Boot port
- **Bind to all interfaces**: Allows Docker container access

### `pom.xml` Key Dependencies
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## API Endpoints

### GET `/hello`
**Purpose**: Simple hello world endpoint for testing connectivity.

**Response**:
```json
"Hello from Spring Boot!"
```

**Example**:
```bash
curl http://localhost:8080/hello
```

## Adding New Endpoints

### Basic Endpoint Example

1. **Create a new controller** or add to `HelloController.java`:
```java
@GetMapping("/api/test")
public String test() {
    return "Test endpoint working!";
}
```

2. **Update NGINX configuration** (see `nginx_templates/README.md`) to proxy the new endpoint:
```nginx
location /api/test {
    proxy_pass http://server:8080/api/test;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### Advanced Endpoint Examples

#### JSON Response
```java
@RestController
public class ApiController {
    
    @GetMapping("/api/user")
    public Map<String, Object> getUser() {
        Map<String, Object> user = new HashMap<>();
        user.put("id", 1);
        user.put("name", "John Doe");
        user.put("email", "john@example.com");
        return user;
    }
}
```

#### POST Endpoint with Request Body
```java
@PostMapping("/api/user")
public ResponseEntity<String> createUser(@RequestBody Map<String, String> userData) {
    String name = userData.get("name");
    String email = userData.get("email");
    
    // Process user data here
    
    return ResponseEntity.ok("User created: " + name);
}
```

## Docker Configuration

### Multi-stage Build Process

The `Dockerfile` uses a multi-stage build for optimization:

1. **Build Stage**: Uses Maven image to compile and build the JAR
2. **Runtime Stage**: Uses minimal OpenJDK image with layered dependencies

### Build Optimization Features
- **Dependency Caching**: Dependencies are cached in separate layer
- **Non-root User**: Runs as `spring` user for security
- **Layered JARs**: Separates dependencies from application code for better caching

## Testing

### Unit Tests
```bash
./mvnw test
```

### Integration Tests
```bash
# Test with running application
./mvnw spring-boot:run &
sleep 10
curl http://localhost:8080/hello
kill %1
```

### Docker Testing
```bash
# Build and test container
docker build -t test-server .
docker run -d -p 8080:8080 --name test-container test-server
sleep 5
curl http://localhost:8080/hello
docker stop test-container
docker rm test-container
```

## Common Issues

### Port Already in Use
```bash
# Kill process using port 8080
lsof -ti:8080 | xargs kill -9

# Or use different port
./mvnw spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
```

### Java Version Issues
```bash
# Check Java version
java --version

# Set JAVA_HOME if needed (Linux/macOS)
export JAVA_HOME=/path/to/java21

# Windows
set JAVA_HOME=C:\path\to\java21
```

### Maven Issues
```bash
# Clean and rebuild
./mvnw clean compile

# Update dependencies  
./mvnw dependency:resolve
```

## Development Tips

- **Hot Reload**: Use `spring-boot-devtools` for automatic restarts during development
- **Profiles**: Use Spring profiles for different environments (dev, staging, prod)
- **Logging**: Adjust logging levels in `application.properties`
- **Database**: Add database dependencies to `pom.xml` when needed
- **Security**: Add Spring Security for authentication/authorization if required