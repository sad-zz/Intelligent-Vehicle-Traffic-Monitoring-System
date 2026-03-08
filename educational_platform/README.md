# پلتفرم آموزشی محلی — تحلیل و راه‌اندازی مشابه شاد
# Local Educational Platform — SHAD-Like System Analysis & Deployment

---

## فهرست مطالب / Table of Contents

1. [تحلیل معماری شاد](#تحلیل-معماری-شاد)
2. [Stack فنی](#stack-فنی)
3. [معماری سیستم](#معماری-سیستم)
4. [پیش‌نیازهای سخت‌افزاری برای ۱۰۰ کاربر](#پیش‌نیازهای-سخت‌افزاری)
5. [راه‌اندازی با Docker](#راه‌اندازی-با-docker)
6. [راه‌اندازی بدون Docker](#راه‌اندازی-بدون-docker)
7. [تنظیمات پیکربندی](#تنظیمات-پیکربندی)
8. [مدیریت کاربران](#مدیریت-کاربران)
9. [امنیت](#امنیت)
10. [عیب‌یابی](#عیب‌یابی)

---

## تحلیل معماری شاد

### شاد چیست؟

**شاد** (شبکه اجتماعی دانش‌آموزی) یک پلتفرم آموزش از راه دور است که توسط وزارت آموزش و پرورش ایران برای ارتباط بین معلمان و دانش‌آموزان طراحی شده است. این سیستم ویژگی‌های زیر را دارد:

- 📱 پیام‌رسانی متنی، صوتی و تصویری
- 📚 ایجاد کلاس‌های آنلاین و گروه‌های درسی
- 📁 اشتراک‌گذاری فایل، تکلیف و محتوای آموزشی
- 🔴 پخش زنده (Live Stream) برای کلاس‌های آنلاین
- ✅ مدیریت حضور و غیاب دانش‌آموزان
- 📊 گزارش‌گیری و آمار

### پایه فنی شاد

بر اساس تحلیل‌های فنی و شواهد موجود، شاد بر پایه **Rocket.Chat** ساخته شده است — یک پلتفرم متن‌باز پیام‌رسانی سازمانی که:

| ویژگی | Rocket.Chat | شاد |
|--------|-------------|------|
| پروتکل پیام | WebSocket + REST API | WebSocket + REST API |
| پایگاه داده | MongoDB | MongoDB (تغییر یافته) |
| Real-time | ✅ DDP (Distributed Data Protocol) | ✅ |
| فایل‌های ضمیمه | GridFS / S3 | محلی / CDN |
| پیام‌های صوتی | ✅ | ✅ |
| ویدیو کنفرانس | Jitsi Meet / BigBlueButton | BigBlueButton |
| Push Notification | ✅ FCM + APNs | ✅ FCM |
| رمزگذاری End-to-End | ✅ (اختیاری) | پیاده‌سازی سفارشی |

---

## Stack فنی

```
┌─────────────────────────────────────────────────────┐
│                    کاربران (مرورگر / اپ)              │
└───────────────────┬─────────────────────────────────┘
                    │ HTTPS / WSS
┌───────────────────▼─────────────────────────────────┐
│                 Nginx (Reverse Proxy)                 │
│         SSL Termination + Load Balancing              │
└───────────────────┬─────────────────────────────────┘
                    │ HTTP / WS
┌───────────────────▼─────────────────────────────────┐
│              Rocket.Chat Server                       │
│         (Node.js + Meteor Framework)                  │
│                                                       │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │ REST API    │  │ WebSocket    │  │ File Upload │ │
│  │ /api/v1/*  │  │ DDP Protocol │  │ GridFS/MinIO│ │
│  └─────────────┘  └──────────────┘  └─────────────┘ │
└──────────┬──────────────────────────────────────────┘
           │
     ┌─────▼──────┐      ┌──────────────┐
     │  MongoDB   │      │  MinIO       │
     │  Database  │      │  (فایل‌ها)   │
     └────────────┘      └──────────────┘
```

### اجزای اصلی سیستم

| کامپوننت | نقش | پورت |
|-----------|------|------|
| **Nginx** | Reverse proxy + SSL | 80, 443 |
| **Rocket.Chat** | سرور اصلی پیام‌رسان | 3000 |
| **MongoDB** | پایگاه داده | 27017 |
| **MinIO** | ذخیره‌سازی فایل | 9000, 9001 |

---

## پیش‌نیازهای سخت‌افزاری

### برای ۱۰۰ کاربر همزمان

| منبع | حداقل | توصیه‌شده |
|------|--------|-----------|
| **CPU** | 4 هسته | 8 هسته |
| **RAM** | 8 GB | 16 GB |
| **Storage** | 100 GB SSD | 500 GB SSD |
| **Network** | 100 Mbps | 1 Gbps |
| **OS** | Ubuntu 20.04 LTS | Ubuntu 22.04 LTS |

#### توضیح محاسبات RAM:
- Rocket.Chat process: ~2–4 GB
- MongoDB: ~2–3 GB
- Nginx: ~256 MB
- MinIO: ~512 MB
- سیستم‌عامل: ~1 GB
- **جمع: ~6–8.7 GB** → حداقل 8 GB، توصیه 16 GB

---

## راه‌اندازی با Docker

### پیش‌نیازها

```bash
# نصب Docker
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker $USER
newgrp docker

# نصب Docker Compose v2
sudo apt-get install docker-compose-plugin -y

# تأیید نصب
docker --version         # Docker 24.x+
docker compose version   # Docker Compose v2.x+
```

### ۱. کلون و آماده‌سازی

```bash
cd educational_platform

# کپی فایل محیطی
cp .env.example .env

# ویرایش تنظیمات ضروری
nano .env
```

### ۲. راه‌اندازی یک‌دستوری

```bash
./scripts/setup.sh
```

یا به صورت دستی:

```bash
# راه‌اندازی سرویس‌ها
docker compose up -d

# مشاهده وضعیت
docker compose ps

# مشاهده لاگ‌ها
docker compose logs -f rocketchat
```

### ۳. تنظیم اولیه Rocket.Chat

پس از راه‌اندازی (۲–۳ دقیقه)، مرورگر را باز کنید:

```
http://localhost:3000
```

یا اگر دامنه دارید:
```
https://your-domain.com
```

**مراحل Setup Wizard:**
1. ایجاد حساب ادمین
2. تنظیم نام سازمان (مثلاً: "مدرسه شماره ۱")
3. تنظیم نوع سرور: "Community"
4. Skip کردن مرحله ثبت

### ۴. بارگذاری ۱۰۰ کاربر

```bash
# پس از تنظیم اولیه و دریافت توکن ادمین:
ADMIN_TOKEN="your-admin-token" \
ADMIN_USER_ID="your-admin-user-id" \
node scripts/init-users.js
```

---

## راه‌اندازی بدون Docker

### ۱. نصب پیش‌نیازها

```bash
# به‌روزرسانی سیستم
sudo apt-get update && sudo apt-get upgrade -y

# نصب Node.js 14.x (نسخه سازگار با Rocket.Chat 6.x)
curl -fsSL https://deb.nodesource.com/setup_14.x -o /tmp/setup_node.sh
# قبل از اجرا، محتوا را بررسی کنید
bash /tmp/setup_node.sh
sudo apt-get install -y nodejs

# نصب MongoDB 6.0
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] \
  https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update
sudo apt-get install -y mongodb-org

# راه‌اندازی MongoDB
sudo systemctl enable mongod
sudo systemctl start mongod

# تبدیل به Replica Set (الزامی برای Rocket.Chat)
sudo mongosh --eval "rs.initiate()"
```

### ۲. دانلود و نصب Rocket.Chat

```bash
# دانلود آخرین نسخه
curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
tar -xzf /tmp/rocket.chat.tgz -C /opt/

# نصب وابستگی‌ها
cd /opt/bundle/programs/server
npm install --production

# ایجاد کاربر سیستمی
sudo useradd -M rocketchat
sudo chown -R rocketchat:rocketchat /opt/bundle
```

### ۳. ایجاد سرویس systemd

```bash
sudo tee /etc/systemd/system/rocketchat.service << 'EOF'
[Unit]
Description=Rocket.Chat Server
After=network.target mongod.service
Requires=mongod.service

[Service]
ExecStart=/usr/bin/node /opt/bundle/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs0
Environment=MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs0
Environment=ROOT_URL=http://localhost:3000
Environment=PORT=3000
Environment=DEPLOY_PLATFORM=selfhosted
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable rocketchat
sudo systemctl start rocketchat
```

---

## تنظیمات پیکربندی

### تنظیمات توصیه‌شده برای ۱۰۰ کاربر (از پنل ادمین)

```
Administration > General:
  - Site URL: https://your-domain.com
  - Site Name: نام مدرسه/سازمان شما
  - Language: fa (Persian)

Administration > Accounts:
  - Allow users to change their email: false (برای محیط آموزشی)
  - Registration Form: Disabled (فقط ادمین کاربر ایجاد کند)
  - Send email to user when user is activated: true

Administration > File Upload:
  - Storage Type: GridFS (پیش‌فرض) یا MinIO
  - Maximum File Upload Size: 52428800 (50 MB)
  - Accepted Media Types: image/*, video/*, audio/*, application/pdf

Administration > Video Conference:
  - Provider: Jitsi
  - Jitsi Domain: meet.jit.si (یا سرور Jitsi خودتان)
  - Jitsi Enable in Channels: true

Administration > Push:
  - (اختیاری) تنظیم Firebase برای push notification

Administration > Rate Limiter:
  - API Rate Limiter: true
  - Limit calls per minute: 600 (برای 100 کاربر کافی است)
```

### تنظیم SSL با Certbot

```bash
# نصب Certbot
sudo apt-get install certbot python3-certbot-nginx -y

# دریافت SSL رایگان
sudo certbot --nginx -d your-domain.com

# تمدید خودکار
sudo crontab -e
# اضافه کنید:
# 0 12 * * * /usr/bin/certbot renew --quiet
```

---

## مدیریت کاربران

### ایجاد کاربر از طریق API

```bash
# لاگین و دریافت توکن
RESPONSE=$(curl -s -X POST \
  http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"user": "admin", "password": "your-password"}')

TOKEN=$(echo $RESPONSE | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['authToken'])")
USER_ID=$(echo $RESPONSE | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['userId'])")

# ایجاد کاربر جدید
curl -X POST \
  http://localhost:3000/api/v1/users.create \
  -H "X-Auth-Token: $TOKEN" \
  -H "X-User-Id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "نام دانش‌آموز",
    "email": "student@school.ir",
    "password": "ChangeMe123!",
    "username": "student001",
    "roles": ["user"],
    "requirePasswordChange": true
  }'
```

### ایجاد گروه/کلاس درسی

```bash
# ایجاد کانال عمومی (کلاس درسی)
curl -X POST \
  http://localhost:3000/api/v1/channels.create \
  -H "X-Auth-Token: $TOKEN" \
  -H "X-User-Id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "class-math-grade10",
    "members": ["teacher001", "student001", "student002"],
    "readOnly": false
  }'
```

---

## امنیت

### نکات امنیتی ضروری

```bash
# ۱. تغییر پورت SSH
sudo nano /etc/ssh/sshd_config
# Port 2222

# ۲. فعال‌سازی Firewall
sudo ufw enable
sudo ufw allow 22/tcp   # یا پورت جدید SSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw deny 3000/tcp  # فقط از طریق Nginx دسترسی باشد
sudo ufw deny 27017/tcp # MongoDB فقط local
sudo ufw status

# ۳. تنظیم امنیت MongoDB
mongosh << 'EOF'
use admin
db.createUser({
  user: "rocketchat_user",
  pwd: "StrongPassword123!",
  roles: [{ role: "readWrite", db: "rocketchat" }]
})
EOF

# ۴. محدود کردن IP در Nginx
# در nginx.conf اضافه کنید:
# allow 192.168.1.0/24;
# deny all;
```

### چک‌لیست امنیتی برای محیط آموزشی

- [ ] SSL/TLS فعال است
- [ ] رمز ادمین قوی تنظیم شده
- [ ] ثبت‌نام عمومی غیرفعال است
- [ ] MongoDB از شبکه خارجی در دسترس نیست
- [ ] فایروال پیکربندی شده
- [ ] بکاپ خودکار تنظیم شده
- [ ] لاگ‌های دسترسی فعال هستند

---

## عیب‌یابی

### Rocket.Chat راه‌اندازی نمی‌شود

```bash
# بررسی لاگ‌ها
docker compose logs rocketchat --tail=50

# بررسی وضعیت MongoDB
docker compose exec mongodb mongosh --eval "rs.status()"

# ریستارت سرویس‌ها
docker compose restart rocketchat
```

### مشکل اتصال WebSocket

```bash
# بررسی Nginx
sudo nginx -t
sudo systemctl status nginx

# تست WebSocket
curl -i -N -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Host: localhost" \
  http://localhost/websocket
```

### مشکل آپلود فایل

```bash
# بررسی فضا
df -h

# بررسی مجوز MinIO
docker compose exec minio mc admin user list local
```

### پایین بودن Performance

```bash
# بررسی منابع
docker stats

# بهینه‌سازی MongoDB
docker compose exec mongodb mongosh rocketchat --eval "
db.runCommand({
  compact: 'rocketchat_room',
  force: true
})"

# افزایش حافظه Node.js
# در docker-compose.yml اضافه کنید:
# environment:
#   - NODE_OPTIONS=--max-old-space-size=4096
```

---

## بکاپ و بازیابی

```bash
# بکاپ MongoDB
docker compose exec mongodb mongodump \
  --db rocketchat \
  --out /tmp/backup-$(date +%Y%m%d)

# کپی بکاپ به خارج از container
docker compose cp mongodb:/tmp/backup-$(date +%Y%m%d) ./backups/

# بازیابی
docker compose exec mongodb mongorestore \
  --db rocketchat \
  /tmp/backup-20251201/rocketchat
```

---

## مقایسه با سایر گزینه‌ها

| پلتفرم | مزایا | معایب | مناسب برای |
|--------|--------|--------|-----------|
| **Rocket.Chat** | کامل‌ترین قابلیت‌ها، شبیه‌ترین به شاد | نیاز به MongoDB، سنگین‌تر | ۵۰+ کاربر |
| **Matrix + Element** | فدراتد، E2E رمزنگاری | پیچیده‌تر برای تنظیم | موارد حساس امنیتی |
| **Mattermost** | سبک‌تر، UI ساده | قابلیت‌های کمتر | تیم‌های کوچک |
| **Zulip** | سازمان‌دهی موضوعی | UI متفاوت | تیم‌های فنی |

---

## لایسنس

این راهنما تحت لایسنس MIT منتشر شده است. Rocket.Chat نیز تحت لایسنس MIT منتشر است.
