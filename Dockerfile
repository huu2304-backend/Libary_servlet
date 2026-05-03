# Sử dụng bản Tomcat 10.1 chạy trên nền JDK mới nhất có sẵn
FROM tomcat:10.1-jdk21-openjdk-slim

# Nếu Render hỗ trợ build JDK 25, bước build sẽ tự xử lý.
# Nhưng để chạy, JDK 21 có khả năng tương thích ngược với byte-code của Java 25
# (Trừ khi bạn dùng các tính năng quá đặc thù của Java 25).

RUN rm -rf /usr/local/tomcat/webapps/*

# Lưu ý: ArtifactId của bạn là "Libary" (viết sai chính tả chữ Library)
# Maven sẽ tạo ra file Libary-1.0-SNAPSHOT.war
COPY target/Libary-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]