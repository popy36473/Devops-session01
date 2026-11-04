#!/bin/bash

# Bước 1: Cập nhật hệ thống
echo "=== Cập nhật hệ thống ==="
apt-get update && apt-get upgrade -y

# Bước 2: Cài đặt các gói cần thiết
echo "=== Cài đặt phần mềm ==="
apt-get install -y openjdk-17-jdk git curl

# Bước 3: Kiểm tra & tạo nhóm quickbite
echo "=== Kiểm tra nhóm quickbite ==="
if ! getent group quickbite > /dev/null; then
    echo "Tạo nhóm quickbite..."
    groupadd quickbite
else
    echo "Nhóm quickbite đã tồn tại, bỏ qua"
fi

# Bước 4: Tạo tài khoản hệ thống quickbite
# -r = system user, không tạo thư mục home
# -g = đặt nhóm chính là quickbite
# -s = đặt shell đăng nhập thành /bin/false (khóa đăng nhập trực tiếp)
echo "=== Tạo tài khoản quickbite ==="
if ! id quickbite > /dev/null 2>&1; then
    useradd -r -g quickbite -s /bin/false quickbite
    echo "Tạo tài khoản quickbite thành công"
else
    echo "Tài khoản quickbite đã tồn tại, bỏ qua"
fi

echo "=== Hoàn tất ==="
