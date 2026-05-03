# Stage 1: Build bằng Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
# Copy toàn bộ code vào trong container
COPY . .
# Chạy lệnh build để tạo ra file .war trong thư mục target/
RUN mvn clean package -DskipTests

# Stage 2: Chạy bằng Tomcat
FROM tomcat:10.1-jdk21-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war vừa build ở Stage 1 vào Stage 2 (Giữ nguyên tên Libary)
# Sử dụng dấu * để copy bất kỳ file .war nào được tạo ra trong target
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]