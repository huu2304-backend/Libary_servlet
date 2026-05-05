# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM tomcat:10.1-jdk21-openjdk-slim
# Xóa sạch app mặc định
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy file war vào đặt tên là ROOT.war để chạy ở trang chủ
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]