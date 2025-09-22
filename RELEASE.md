# Simple Proxy v1.0.0 - Release Notes

## Overview
Simple Proxy là một HTTP/HTTPS proxy server đơn giản được viết bằng Go, hỗ trợ basic authentication và SOCKS5 tunneling.

## Features
- HTTP/HTTPS proxy server
- Basic authentication support
- SOCKS5 proxy tunneling
- Custom timeout configuration
- Request headers logging
- Multi-platform support

## Installation

### Pre-built Binaries
Download the appropriate binary for your platform:

- **Linux 32-bit**: `simple-proxy_linux_386.zip`
- **Linux 64-bit**: `simple-proxy_linux_amd64.zip`
- **Linux ARM**: `simple-proxy_linux_arm.zip`
- **Linux ARM64**: `simple-proxy_linux_arm64.zip`
- **macOS Intel**: `simple-proxy_darwin_amd64.zip`
- **macOS Apple Silicon**: `simple-proxy_darwin_arm64.zip`
- **Windows 32-bit**: `simple-proxy_windows_386.zip`
- **Windows 64-bit**: `simple-proxy_windows_amd64.zip`

### Extract and Run
```bash
# Linux/macOS
unzip simple-proxy_[platform].zip
chmod +x simple-proxy
./simple-proxy

# Windows
unzip simple-proxy_windows_[arch].zip
simple-proxy.exe
```

### Docker
```bash
# Build the Docker image
docker build -t simple-proxy:v1.0.0 .

# Run with Docker
docker run -p 8888:8888 simple-proxy:v1.0.0
```

## Usage

### Basic Usage
```bash
# Start HTTP proxy on default port 8888
./simple-proxy

# Start with custom port
./simple-proxy -port 3128

# Start with basic authentication
./simple-proxy -basic-auth "username:password"

# Start HTTPS proxy with SSL certificates
./simple-proxy -protocol https -cert cert.pem -key key.pem
```

### Advanced Options
```bash
# With SOCKS5 tunneling
./simple-proxy -socks5 "socks5-server:1080" -socks5-auth "user:pass"

# With custom bind address and timeout
./simple-proxy -bind "127.0.0.1" -port "8080" -timeout 30

# Enable request logging
./simple-proxy -log-headers -log-auth
```

### Command Line Options
- `-protocol`: Proxy protocol (http or https, default: http)
- `-bind`: Address to bind the proxy server to (default: 0.0.0.0)
- `-port`: Proxy port to listen on (default: 8888)
- `-basic-auth`: Basic auth format 'username:password'
- `-socks5`: SOCKS5 proxy for tunneling
- `-socks5-auth`: Basic auth for SOCKS5 format 'username:password'
- `-cert`: Path to cert file (required for HTTPS)
- `-key`: Path to key file (required for HTTPS)
- `-timeout`: Timeout in seconds (default: 10)
- `-log-auth`: Log failed proxy auth details
- `-log-headers`: Log request headers
- `-version`: Print version information

## License
This project is licensed under the terms included in the LICENSE file.

## Build Information
- Version: v1.0.0
- Built with Go 1.25+
- Cross-compiled for multiple platforms
- Static binaries with no external dependencies