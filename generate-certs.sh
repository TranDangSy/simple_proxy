#!/bin/bash

# Script to generate self-signed certificates for Simple Proxy
# Usage: ./generate-certs.sh [domain]

DOMAIN=${1:-localhost}
CERT_DIR="certs"
KEY_FILE="$CERT_DIR/server.key"
CERT_FILE="$CERT_DIR/server.crt"
CSR_FILE="$CERT_DIR/server.csr"

echo "🔐 Generating SSL certificates for domain: $DOMAIN"

# Create certs directory
mkdir -p $CERT_DIR

# Generate private key
echo "📝 Generating private key..."
openssl genrsa -out $KEY_FILE 2048

# Create certificate signing request
echo "📝 Creating certificate signing request..."
openssl req -new -key $KEY_FILE -out $CSR_FILE -subj "/C=VN/ST=HCM/L=HCM/O=SimpleProxy/OU=IT/CN=$DOMAIN"

# Generate self-signed certificate
echo "📝 Generating self-signed certificate..."
openssl x509 -req -days 365 -in $CSR_FILE -signkey $KEY_FILE -out $CERT_FILE

# Create certificate with SAN (Subject Alternative Names) for better browser compatibility
echo "📝 Creating certificate with SAN extensions..."
cat > $CERT_DIR/openssl.conf << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C=VN
ST=HCM
L=Ho Chi Minh
O=Simple Proxy
OU=IT Department
CN=$DOMAIN

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = localhost
DNS.3 = *.localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF

# Generate new certificate with extensions
openssl req -new -x509 -key $KEY_FILE -out $CERT_FILE -days 365 -config $CERT_DIR/openssl.conf -extensions v3_req

# Clean up
rm $CSR_FILE $CERT_DIR/openssl.conf

echo "✅ Certificates generated successfully!"
echo "📁 Files created:"
echo "   - Private key: $KEY_FILE"
echo "   - Certificate: $CERT_FILE"
echo ""
echo "🔧 To use with Simple Proxy:"
echo "   ./simple-proxy -protocol https -cert $CERT_FILE -key $KEY_FILE -port 8443"
echo ""
echo "🐳 To use with Docker:"
echo "   docker run -p 8443:8443 -v \$(pwd)/certs:/certs simple-proxy:v1.0.0 \\"
echo "     -protocol https -cert /certs/server.crt -key /certs/server.key -port 8443"
echo ""
echo "⚠️  Note: You'll need to add this certificate to your browser's trusted certificates"