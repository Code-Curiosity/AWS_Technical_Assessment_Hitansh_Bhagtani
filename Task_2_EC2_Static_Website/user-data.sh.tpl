#!/bin/bash
set -e

# Detect distro family and use appropriate package manager
if command -v dnf >/dev/null 2>&1; then
  PKG_MGR="dnf"
elif command -v yum >/dev/null 2>&1; then
  PKG_MGR="yum"
else
  PKG_MGR="apt-get"
fi

# Update packages and install nginx
if [ "$PKG_MGR" = "dnf" ]; then
  sudo dnf update -y
  sudo dnf install -y nginx
elif [ "$PKG_MGR" = "yum" ]; then
  sudo yum update -y
  sudo yum install -y nginx
else
  sudo apt-get update -y
  sudo apt-get install -y nginx
fi

# Write resume HTML
cat > /usr/share/nginx/html/index.html <<'HTML'
${resume_html}
HTML

# Start and enable nginx
sudo systemctl enable nginx
sudo systemctl start nginx
