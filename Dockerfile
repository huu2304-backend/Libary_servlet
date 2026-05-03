# Bước 1: Dùng Maven để đóng gói code
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
# Lệnh này sẽ tạo ra file trong thư mục target/
RUN mvn clean package -DskipTests

# Bước 2: Dùng Tomcat để chạy
FROM tomcat:10.1-jdk21-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Chỗ này phải khớp với <artifactId> trong pom.xml
# Giữ nguyên tên "Libary" như bạn muốn
COPY --from=build /app/target/Libary-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]