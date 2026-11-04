#!/bin/bash
# Script triển khai User Service trên VPS

echo "=== Bắt đầu triển khai User Service ==="

# 1. Tạo thư mục làm việc & kéo code
mkdir -p ~/workspace
cd ~/workspace
if [ ! -d "user-service-test" ]; then
  git clone https://github.com/popy36473/user-service-test.git
fi
cd user-service-test

# 2. Cấp quyền & Build
chmod +x gradlew
./gradlew clean bootJar

# 3. Tạo nhóm & user
groupadd quickbite-apps 2>/dev/null
useradd -r -g quickbite-apps -s /bin/false user-svc 2>/dev/null

# 4. Tạo thư mục & phân quyền
mkdir -p /opt/quickbite/dev/user-service
chown -R user-svc:quickbite-apps /opt/quickbite
chmod 755 /opt/quickbite
chmod 755 /opt/quickbite/dev
chmod 755 /opt/quickbite/dev/user-service

# 5. Sao chép file JAR
cp build/libs/user-service-0.0.1-SNAPSHOT.jar /opt/quickbite/dev/user-service/application.jar
chown user-svc:quickbite-apps /opt/quickbite/dev/user-service/application.jar
chmod 750 /opt/quickbite/dev/user-service/application.jar

# 6. Dừng tiến trình cũ nếu có
OLD_PID=$(ss -tulpn | grep :8080 | grep -oP 'pid=\K[0-9]+' | head -n 1)
if [ -n "$OLD_PID" ]; then
  kill -9 "$OLD_PID" 2>/dev/null
  echo "→ Đã dừng tiến trình cũ"
fi

# 7. Khởi động dịch vụ mới
su -s /bin/bash user-svc -c "
  nohup java -jar /opt/quickbite/dev/user-service/application.jar > /opt/quickbite/dev/user-service/app.log 2>&1 &
"

echo "→ Đang chờ khởi động 10 giây..."
sleep 10

# 8. Kiểm tra
echo ""
echo "=== Kết quả kiểm tra ==="
echo "1. Gọi dịch vụ:"
curl http://localhost:8080
echo ""
echo "2. Quyền thư mục:"
ls -la /opt/quickbite/dev/user-service/
echo "3. Cổng 8080:"
ss -tulpn | grep :8080

echo ""
echo "=== Hoàn thành ==="
