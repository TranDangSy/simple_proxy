# Browser Configuration Guide for HTTPS Proxy

## 🌐 Cấu hình Browser sử dụng HTTPS Proxy

### 📋 **Bước 1: Chạy HTTPS Proxy**
```bash
# Tạo certificates
./generate-certs.sh localhost

# Chạy HTTPS proxy
./simple-proxy -protocol https -cert certs/server.crt -key certs/server.key \
  -port 8443 -basic-auth "admin:password123"
```

### 🔒 **Bước 2: Thêm Certificate vào Browser (Tùy chọn)**

#### **Chrome/Chromium:**
1. Mở `chrome://settings/certificates`
2. Chọn tab "Authorities"
3. Click "Import" và chọn file `certs/server.crt`
4. Tick "Trust this certificate for identifying websites"

#### **Firefox:**
1. Mở `about:preferences#privacy`
2. Scroll xuống "Certificates" → Click "View Certificates"
3. Tab "Authorities" → Click "Import"
4. Chọn file `certs/server.crt`
5. Tick "Trust this CA to identify websites"

#### **Safari:**
1. Double-click file `certs/server.crt`
2. Keychain Access sẽ mở → Chọn "System" keychain
3. Tìm certificate → Right-click → "Get Info"
4. Expand "Trust" → Set "When using this certificate" to "Always Trust"

### 🌐 **Bước 3: Cấu hình Proxy trong Browser**

#### **Chrome:**
```bash
# Chạy Chrome với proxy settings
google-chrome --proxy-server="https://localhost:8443" \
  --proxy-auth="admin:password123" \
  --ignore-certificate-errors-spki-list \
  --ignore-ssl-errors
```

#### **Firefox:**
1. Mở `about:preferences#general`
2. Scroll xuống "Network Settings" → Click "Settings"
3. Chọn "Manual proxy configuration"
4. SSL Proxy: `localhost` Port: `8443`
5. Tick "Use this proxy server for all protocols"
6. Username: `admin`, Password: `password123`

#### **Safari:**
1. System Preferences → Network
2. Chọn network interface → Click "Advanced"
3. Tab "Proxies" → Tick "Secure Web Proxy (HTTPS)"
4. Server: `localhost:8443`
5. Username: `admin`, Password: `password123`

### 🔧 **Bước 4: Kiểm tra kết nối**

#### **Test với curl:**
```bash
# Test HTTP request qua HTTPS proxy
curl -x https://admin:password123@localhost:8443 \
  --proxy-insecure \
  http://httpbin.org/ip

# Test HTTPS request
curl -x https://admin:password123@localhost:8443 \
  --proxy-insecure \
  https://httpbin.org/ip
```

#### **Test trong browser:**
1. Mở browser đã cấu hình proxy
2. Truy cập: `http://whatismyipaddress.com`
3. IP hiển thị phải là IP của proxy server

### ⚙️ **Docker Compose cho HTTPS Proxy:**

```yaml
version: '3.8'
services:
  https-proxy:
    build: .
    ports:
      - "8443:8443"
    volumes:
      - ./certs:/certs:ro
    command: [
      "-protocol", "https",
      "-port", "8443", 
      "-cert", "/certs/server.crt",
      "-key", "/certs/server.key",
      "-basic-auth", "admin:password123",
      "-log-headers"
    ]
```

### 🚨 **Lưu ý quan trọng:**

1. **Self-signed certificates**: Browser sẽ hiển thị cảnh báo bảo mật
2. **Certificate trust**: Nên thêm cert vào trusted store để tránh cảnh báo
3. **Proxy authentication**: Một số browser có thể yêu cầu nhập auth riêng
4. **CORS issues**: Một số website có thể block requests qua proxy

### 🛡️ **Security Best Practices:**

- Sử dụng password mạnh cho proxy auth
- Chỉ bind proxy vào localhost nếu chỉ dùng local
- Thường xuyên rotate certificates
- Monitor proxy logs để phát hiện truy cập bất thường

### 🔍 **Troubleshooting:**

#### **Browser không kết nối được:**
- Kiểm tra proxy đang chạy: `netstat -an | grep 8443`
- Thử disable firewall tạm thời
- Kiểm tra certificate path và permissions

#### **Certificate errors:**
- Đảm bảo certificate bao gồm đúng domain/IP
- Thử flag `--ignore-certificate-errors` (chỉ cho testing)
- Regenerate certificate với đúng SAN extensions