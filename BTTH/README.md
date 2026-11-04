# User Service - Triển khai trên VPS

## Thông tin dự án
- Công nghệ: Spring Boot + Gradle
- Cổng: 8080
- Tài khoản chạy: user-svc (không dùng root)

## 1. Kéo code về VPS
mkdir -p ~/workspace && cd ~/workspace
git clone https://github.com/popy36473/user-service-test.git
cd user-service-test

## 2. Build & đóng gói
chmod +x gradlew
./gradlew clean bootJar
ls -la build/libs/

## 3. Tạo tài khoản & thư mục
groupadd quickbite-apps
useradd -r -g quickbite-apps -s /bin/false user-svc
mkdir -p /opt/quickbite/dev/user-service
chown -R user-svc:quickbite-apps /opt/quickbite
chmod 755 /opt/quickbite /opt/quickbite/dev /opt/quickbite/dev/user-service

## 4. Sao chép & chạy dịch vụ
cp build/libs/user-service-0.0.1-SNAPSHOT.jar /opt/quickbite/dev/user-service/application.jar
chown user-svc:quickbite-apps /opt/quickbite/dev/user-service/application.jar
chmod 750 /opt/quickbite/dev/user-service/application.jar
su -s /bin/bash user-svc -c "nohup java -jar /opt/quickbite/dev/user-service/application.jar > /opt/quickbite/dev/user-service/app.log 2>&1 &"
sleep 10

## 5. Kiểm tra kết quả
curl http://localhost:8080
ls -la /opt/quickbite/dev/user-service/
ss -tulpn | grep :8080

## Bằng chứng
- screenshots/01-curl-result.png - Gọi thử dịch vụ thành công
- screenshots/02-folder-permission.png - Quyền thư mục user-svc
- screenshots/03-service-running.png - Cổng 8080 đang lắng nghe

## Bảo mật
- Không dùng root chạy dịch vụ
- Tài khoản user-svc quyền tối thiểu
- Log: /opt/quickbite/dev/user-service/app.log
