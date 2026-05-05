# Stage 1: Giữ nguyên
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Chạy bằng Tomcat 10.1
FROM tomcat:10.1-jdk21-openjdk-slim

# Xóa các app mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# 1. Tạo thư mục chứa ảnh và cấp quyền ghi (Rất quan trọng)
# Giả sử trong code bạn lưu vào thư mục 'uploads' bên trong webapp
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads && \
    chmod -R 777 /usr/local/tomcat/webapps/ROOT/

# 2. Copy file .war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Mở rộng bộ nhớ đệm và giới hạn upload (Tùy chọn nhưng nên có)
# Giúp tránh lỗi 'Unexpected output' khi file ảnh quá nặng
ENV CATALINA_OPTS="-Xms512M -Xmx1024M"

EXPOSE 8080
CMD ["catalina.sh", "run"]