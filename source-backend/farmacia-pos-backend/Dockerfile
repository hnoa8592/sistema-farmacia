# Stage 1: Extraer capas del JAR para optimizar layers de Docker
FROM amazoncorretto:17-alpine-jdk AS builder
WORKDIR /build
COPY /target/farmacia-pos-backend-1.0.0-SNAPSHOT.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# Stage 2: Imagen final con capas separadas
FROM amazoncorretto:21-alpine-jdk
WORKDIR /app

COPY --from=builder /build/dependencies/ ./
COPY --from=builder /build/spring-boot-loader/ ./
COPY --from=builder /build/snapshot-dependencies/ ./
COPY --from=builder /build/application/ ./

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", \
  "-XX:+UseContainerSupport", \
  "-XX:MaxRAMPercentage=75.0", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "org.springframework.boot.loader.launch.JarLauncher"]
