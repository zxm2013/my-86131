# Linux Deployment (Ubuntu 22.04+/Debian 12+)

## 1. Clone Repository

```bash
git clone <your-repo-url> /opt/realtime-chat-app
cd /opt/realtime-chat-app
```

## 2. Install Node 20

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential
```

## 3. Configure Environment

```bash
cp backend/.env.example backend/.env
nano backend/.env
```

Required:

- set `JWT_SECRET` to a strong random value
- set `PORT` (default `5001`)
- optionally set `MONGODB_URI` and `CLOUDINARY_*`

## 4. Build and Start

```bash
npm run build
npm start
```

## 5. Run as systemd Service

```bash
sudo cp deploy/linux/chat-app.service /etc/systemd/system/chat-app.service
sudo systemctl daemon-reload
sudo systemctl enable chat-app
sudo systemctl start chat-app
sudo systemctl status chat-app
```

## 6. Nginx Reverse Proxy (Optional)

Minimal config:

```nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
```

## 7. Update to Latest

```bash
cd /opt/realtime-chat-app
bash scripts/sync-upstream.sh https://github.com/harshsuiiii/Real-time-chat-app.git main
npm run build
sudo systemctl restart chat-app
```
