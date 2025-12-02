#!/bin/bash
set -e
# simple install for Amazon Linux 2023 / Amazon Linux 2 / Debian family
if command -v dnf >/dev/null 2>&1; then
  sudo dnf update -y
  sudo dnf install -y nginx
elif command -v yum >/dev/null 2>&1; then
  sudo yum update -y
  sudo yum install -y nginx
else
  sudo apt-get update -y
  sudo apt-get install -y nginx
fi

sudo systemctl enable nginx
sudo systemctl start nginx

cat > /usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Hitansh Bhagatni — HA Nginx</title></head>
<body>
  <h1>${resume_message}</h1>
  <p>Hosted by Auto Scaling Group - Hitansh_Bhagatni_ASG</p>
</body>
</html>
HTML
