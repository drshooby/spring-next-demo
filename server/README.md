# Server

Spring Boot backend API.

## Development

```bash
mvn spring-boot:run

# http://localhost:8080
```

## Production

```bash
mvn clean package
java -jar target/spring-next-demo-server.jar
```

## Docker

```bash
docker build -t spring-next-demo-server .
docker run -p 8080:8080 spring-next-demo-server
```

## Testing

```bash
mvn test
```

## API Endpoints

```
GET    /api/health
GET    /api/status
POST   /api/data
GET    /api/data
PUT    /api/data/{id}
DELETE /api/data/{id}
```

## Environment

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=springnextdemo
DB_USERNAME=user
DB_PASSWORD=password
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=dev
```