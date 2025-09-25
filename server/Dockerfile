# =========================
# Stage 1: build
# =========================
FROM maven:3.9.11-eclipse-temurin-24-alpine AS build
WORKDIR /app

# Copy Maven files first to leverage caching
COPY pom.xml .
COPY src ./src

# Build the fat JAR and unpack dependencies
RUN mvn clean package -DskipTests \
  && mkdir -p target/dependency \
  && (cd target/dependency && jar -xf ../*.jar)

# =========================
# Stage 2: runtime
# =========================
FROM openjdk:24-slim
WORKDIR /app

# Create system user
RUN addgroup --system spring && adduser --system --ingroup spring spring

# Copy dependencies (rarely changes) — caches well
COPY --from=build /app/target/dependency/BOOT-INF/lib /app/lib

# Copy application classes (changes often)
COPY --from=build /app/target/dependency/BOOT-INF/classes /app/classes

# Copy META-INF if needed
COPY --from=build /app/target/dependency/META-INF /app/META-INF

# Switch to non-root user
USER spring:spring

# Entrypoint with correct classpath
ENTRYPOINT ["java", "-cp", "/app/classes:/app/lib/*", "com.example.server.ServerApplication"]