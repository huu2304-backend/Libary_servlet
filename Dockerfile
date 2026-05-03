# Stage 1: Build bằng Maven với JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
# Lệnh build
RUN mvn clean package -DskipTests

# Stage 2: Chạy bằng Tomcat 10.1
FROM tomcat:10.1-jdk21-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war (Dùng dấu * để tự tìm file war bất kể tên gì)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]