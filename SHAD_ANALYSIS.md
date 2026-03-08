# آنالیز پلتفرم شاد و راهنمای راه‌اندازی محلی برای ۱۰۰ کاربر

## فهرست مطالب

1. [معرفی پلتفرم شاد](#معرفی-پلتفرم-شاد)
2. [آنالیز معماری](#آنالیز-معماری)
3. [ویژگی‌های اصلی](#ویژگیهای-اصلی)
4. [مقایسه با تلگرام](#مقایسه-با-تلگرام)
5. [گزینه‌های متن‌باز مشابه](#گزینههای-متنباز-مشابه)
6. [راه‌اندازی محلی با Matrix/Element](#راهاندازی-محلی-با-matrixelement)
7. [نیازمندی‌های سخت‌افزاری برای ۱۰۰ کاربر](#نیازمندیهای-سختافزاری-برای-۱۰۰-کاربر)
8. [راهنمای نصب گام‌به‌گام](#راهنمای-نصب-گامبهگام)
9. [مدیریت کاربران و امنیت](#مدیریت-کاربران-و-امنیت)
10. [عیب‌یابی](#عیبیابی)

---

## معرفی پلتفرم شاد

**شاد** (شبکه اجتماعی دانش‌آموزی) یک پلتفرم آموزش از راه دور ایرانی است که توسط وزارت آموزش و پرورش ایران توسعه داده شده است. این پلتفرم به‌عنوان بستر اصلی آموزش مجازی در دوران COVID-19 مورد استفاده قرار گرفت.

### ویژگی‌های کلیدی شاد
- پیام‌رسانی متنی، تصویری، صوتی و ویدیویی
- ایجاد کلاس‌های آنلاین و گروه‌های درسی
- اشتراک‌گذاری محتوای آموزشی (PDF، ویدیو، تصویر)
- برگزاری آزمون و تکلیف آنلاین
- تماس صوتی و تصویری گروهی
- مدیریت دانش‌آموزان و معلمان
- پشتیبانی از ۶ تا ۶۵+ میلیون کاربر همزمان

---

## آنالیز معماری

### معماری کلی (Client-Server)

```
┌─────────────────────────────────────────────────────────────┐
│                        کلاینت                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────────────┐   │
│  │ اندروید  │  │   iOS    │  │  مرورگر وب (PWA)         │   │
│  └────┬─────┘  └────┬─────┘  └──────────┬───────────────┘   │
└───────┼─────────────┼──────────────────┼────────────────────┘
        │             │                  │
        └──────────────┴──────────────────┘
                              │
                    HTTPS / WebSocket
                              │
┌─────────────────────────────▼───────────────────────────────┐
│                    لایه Load Balancer                        │
│              (Nginx / HAProxy / Traefik)                     │
└──────────────────────────────┬──────────────────────────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
     ┌──────▼──────┐   ┌───────▼──────┐   ┌──────▼──────┐
     │ API Server  │   │  Media Server│   │  Chat Server│
     │ (REST/gRPC) │   │  (تصویر/فایل)│   │ (WebSocket) │
     └──────┬──────┘   └───────┬──────┘   └──────┬──────┘
            │                  │                  │
     ┌──────▼──────────────────▼──────────────────▼──────┐
     │                   Message Bus                      │
     │                 (Redis / Kafka)                    │
     └──────────────────────────┬─────────────────────────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
     ┌──────▼──────┐   ┌────────▼─────┐    ┌───────▼──────┐
     │ PostgreSQL  │   │  MongoDB /   │    │  MinIO /     │
     │ (کاربران,   │   │  Cassandra   │    │  Object Store│
     │  کلاس‌ها)   │   │ (پیام‌ها)    │    │  (فایل‌ها)   │
     └─────────────┘   └──────────────┘    └──────────────┘
```

### پروتکل‌های مورد استفاده

| لایه | پروتکل |
|------|--------|
| انتقال پیام | WebSocket + HTTPS |
| پیام‌رسانی real-time | XMPP یا پروتکل اختصاصی مشابه Matrix |
| احراز هویت | OAuth2 / JWT |
| تماس صوتی/تصویری | WebRTC |
| Push Notification | FCM (Android) / APNs (iOS) |
| رمزنگاری | TLS 1.3 |

### ویژگی‌های معماری مشابه تلگرام

شاد از اصولی مشابه تلگرام (MTProto) پیروی می‌کند:

1. **Server-side storage**: تمام پیام‌ها روی سرور ذخیره می‌شوند (برخلاف Signal)
2. **Cloud-based**: دسترسی از چند دستگاه همزمان
3. **Group/Channel**: پشتیبانی از گروه‌های بزرگ (مثل کانال‌های تلگرام)
4. **Media optimization**: فشرده‌سازی و بهینه‌سازی فایل‌های رسانه‌ای
5. **Offline support**: ذخیره پیام‌های دریافت‌نشده

---

## ویژگی‌های اصلی

### ۱. مدیریت کلاس
- ایجاد کلاس مجازی توسط معلم
- دعوت دانش‌آموزان با کد کلاس
- مدیریت دسترسی‌ها (ارسال/دریافت پیام، فقط خواندنی)

### ۲. اشتراک محتوا
- ارسال فایل‌های PDF، ویدیو، تصویر
- محدودیت حجم فایل
- پیش‌نمایش آنلاین

### ۳. ارزیابی
- آزمون آنلاین (تستی و تشریحی)
- تکلیف با مهلت زمانی
- نمره‌دهی خودکار (تستی) و دستی

### ۴. تماس ویدیویی
- WebRTC-based
- پشتیبانی از ۱۰۰+ شرکت‌کننده (برای کلاس)

---

## مقایسه با تلگرام

| ویژگی | شاد | تلگرام |
|-------|-----|--------|
| پروتکل | اختصاصی | MTProto |
| رمزنگاری end-to-end | محدود | بله (Secret Chat) |
| حداکثر اعضای گروه | کلاس محور | ۲۰۰,۰۰۰ |
| Bot API | ندارد | دارد |
| کانال | دارد (کلاس) | دارد |
| تماس ویدیویی | دارد | دارد |
| سرور | ایران (داخلی) | هلند/سنگاپور |
| متن‌باز | خیر | API محدود |
| هدف | آموزش | عمومی |

---

## گزینه‌های متن‌باز مشابه

برای راه‌اندازی یک سیستم مشابه شاد در محیط محلی، چند گزینه متن‌باز وجود دارد:

### ۱. Matrix + Element (توصیه شده ✅)
> بیشترین شباهت به تلگرام/شاد

- **پروتکل**: Matrix (استاندارد باز و decentralized)
- **کلاینت**: Element (اندروید، iOS، وب، دسکتاپ)
- **سرور**: Synapse (Python) یا Dendrite (Go)
- **ویدیو**: Jitsi Meet یا Element Call
- **مزایا**: E2E encryption، federation، API کامل
- **معایب**: مصرف RAM بالاتر از سایر گزینه‌ها

### ۲. Rocket.Chat
- پلتفرم کامل مشابه Slack/Teams
- دارای ویدیوکنفرانس داخلی
- قابلیت‌های مدیریت کاربران پیشرفته
- مناسب برای سازمان‌ها

### ۳. Mattermost
- مشابه Slack
- نسخه Community رایگان
- قابلیت‌های آموزشی محدود

### ۴. Zulip
- پیام‌رسانی موضوع‌محور (Topic-based)
- مناسب برای آموزش و بحث علمی
- رابط کاربری متفاوت

### مقایسه برای ۱۰۰ کاربر

| پلتفرم | RAM | CPU | متن‌باز | یادگیری |
|--------|-----|-----|---------|---------|
| Matrix+Element | ۴-۸ GB | ۲-۴ core | ✅ | متوسط |
| Rocket.Chat | ۲-۴ GB | ۲ core | ✅ | آسان |
| Mattermost | ۲-۴ GB | ۲ core | ✅ | آسان |
| Zulip | ۲-۴ GB | ۲ core | ✅ | آسان |

---

## راه‌اندازی محلی با Matrix/Element

Matrix/Element به‌عنوان نزدیک‌ترین معادل متن‌باز به شاد/تلگرام انتخاب شده است.

### ساختار کلی سیستم

```
┌────────────────────────────────────────────────────────────┐
│                    سرور محلی (Local)                       │
│                                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │   Synapse    │  │  PostgreSQL  │  │    Element Web   │  │
│  │ (Matrix Server│  │  (Database)  │  │  (Web Client)    │  │
│  │  Port: 8448) │  │  Port: 5432  │  │  Port: 80/443    │  │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘  │
│         │                 │                   │             │
│  ┌──────▼─────────────────▼───────────────────▼──────────┐  │
│  │                  Docker Network                       │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │     Jitsi    │  │  Coturn      │                        │
│  │  (ویدیوکنفرانس│  │  (TURN/STUN) │                        │
│  │  Port: 8443) │  │  Port: 3478  │                        │
│  └──────────────┘  └──────────────┘                        │
└────────────────────────────────────────────────────────────┘
```

---

## نیازمندی‌های سخت‌افزاری برای ۱۰۰ کاربر

### حداقل (Minimum)
| منبع | مقدار |
|------|-------|
| CPU | ۲ core (x86_64) |
| RAM | ۴ GB |
| Storage | ۱۰۰ GB SSD |
| Network | ۱۰ Mbps (Upload + Download) |
| OS | Ubuntu 22.04 LTS |

### توصیه‌شده (Recommended)
| منبع | مقدار |
|------|-------|
| CPU | ۴ core (x86_64) |
| RAM | ۸ GB |
| Storage | ۲۵۰ GB SSD |
| Network | ۵۰ Mbps (برای ویدیوکنفرانس همزمان) |
| OS | Ubuntu 22.04 LTS |

> **نکته**: برای ۱۰۰ کاربر همزمان با تماس ویدیویی (۱۰ اتاق × ۱۰ نفر)، bandwidth باید حداقل ۵۰ Mbps باشد.

---

## راهنمای نصب گام‌به‌گام

### پیش‌نیازها

```bash
# نصب Docker و Docker Compose
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin

# اضافه کردن کاربر به گروه docker
sudo usermod -aG docker $USER
newgrp docker

# تأیید نصب
docker --version
docker compose version
```

### ساختار پوشه‌بندی

```bash
mkdir -p ~/shad-local/{synapse,element,postgres,coturn,jitsi}
cd ~/shad-local
```

### گام ۱: تنظیم Synapse (سرور Matrix)

```bash
# تولید فایل پیکربندی اولیه
docker run --rm \
  -v $(pwd)/synapse:/data \
  -e SYNAPSE_SERVER_NAME=matrix.local \
  -e SYNAPSE_REPORT_STATS=no \
  matrixdotorg/synapse:latest \
  generate
```

فایل `synapse/homeserver.yaml` را ویرایش کنید:

```yaml
# homeserver.yaml - تنظیمات اصلی
server_name: "matrix.local"
public_baseurl: "http://matrix.local:8448"

# دیتابیس PostgreSQL
database:
  name: psycopg2
  args:
    user: synapse
    password: synapse_password
    database: synapse
    host: postgres
    cp_min: 5
    cp_max: 10

# تنظیم لاگ
log_config: "/data/matrix.local.log.config"

# ذخیره رسانه
media_store_path: "/data/media_store"

# ثبت‌نام کاربر
enable_registration: true
enable_registration_without_verification: true

# محدودیت‌های امنیتی
registration_requires_token: false

# حداکثر حجم فایل آپلود (MB)
max_upload_size: 50M

# تنظیم TURN (برای WebRTC)
turn_uris:
  - "turn:coturn:3478?transport=udp"
  - "turn:coturn:3478?transport=tcp"
turn_shared_secret: "your_turn_secret_here"
turn_user_lifetime: 86400000
turn_allow_guests: True

# تنظیم federation (برای محیط محلی غیرفعال کنید)
federation_domain_whitelist: []
```

### گام ۲: فایل docker-compose.yml

```yaml
# docker-compose.yml
version: '3.8'

services:

  # دیتابیس
  postgres:
    image: postgres:15-alpine
    container_name: synapse-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: synapse
      POSTGRES_USER: synapse
      POSTGRES_PASSWORD: synapse_password
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    volumes:
      - ./postgres/data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U synapse"]
      interval: 10s
      timeout: 5s
      retries: 5

  # سرور Matrix
  synapse:
    image: matrixdotorg/synapse:latest
    container_name: synapse-server
    restart: unless-stopped
    volumes:
      - ./synapse:/data
    ports:
      - "8448:8448"
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      SYNAPSE_CONFIG_PATH: /data/homeserver.yaml
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8448/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

  # کلاینت وب
  element-web:
    image: vectorim/element-web:latest
    container_name: element-web
    restart: unless-stopped
    volumes:
      - ./element/config.json:/app/config.json:ro
    ports:
      - "8080:80"
    depends_on:
      - synapse

  # TURN/STUN Server برای WebRTC
  coturn:
    image: coturn/coturn:latest
    container_name: coturn
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./coturn/turnserver.conf:/etc/coturn/turnserver.conf:ro
    command: -c /etc/coturn/turnserver.conf

  # سرور ویدیوکنفرانس Jitsi
  jitsi-web:
    image: jitsi/web:latest
    container_name: jitsi-web
    restart: unless-stopped
    ports:
      - "8443:443"
    environment:
      - ENABLE_AUTH=0
      - ENABLE_GUESTS=1
      - DISABLE_HTTPS=0
    volumes:
      - ./jitsi/web:/config

  jitsi-prosody:
    image: jitsi/prosody:latest
    container_name: jitsi-prosody
    restart: unless-stopped
    environment:
      - ENABLE_AUTH=0
      - ENABLE_GUESTS=1

  jitsi-jicofo:
    image: jitsi/jicofo:latest
    container_name: jitsi-jicofo
    restart: unless-stopped

  jitsi-jvb:
    image: jitsi/jvb:latest
    container_name: jitsi-jvb
    restart: unless-stopped
    ports:
      - "10000:10000/udp"

volumes:
  postgres_data:
```

### گام ۳: پیکربندی Element Web

فایل `element/config.json` را ایجاد کنید:

```json
{
  "default_server_config": {
    "m.homeserver": {
      "base_url": "http://192.168.1.100:8448",
      "server_name": "matrix.local"
    },
    "m.identity_server": {
      "base_url": ""
    }
  },
  "disable_custom_urls": false,
  "disable_guests": true,
  "disable_login_language_selector": false,
  "disable_3pid_login": true,
  "brand": "شاد محلی",
  "integrations_ui_url": "",
  "integrations_rest_url": "",
  "integrations_widgets_urls": [],
  "bug_report_endpoint_url": "",
  "showLabsSettings": false,
  "default_theme": "light",
  "room_directory": {
    "servers": ["matrix.local"]
  },
  "piwik": false,
  "welcomeUserId": "@admin:matrix.local",
  "branding": {
    "welcomeBackgroundUrl": "",
    "authHeaderLogoUrl": "",
    "authFooterLinks": []
  }
}
```

### گام ۴: پیکربندی TURN Server

فایل `coturn/turnserver.conf`:

```conf
# turnserver.conf
listening-port=3478
tls-listening-port=5349

# آدرس IP سرور
listening-ip=0.0.0.0
external-ip=192.168.1.100

# رمز مشترک (باید با homeserver.yaml یکسان باشد)
use-auth-secret
static-auth-secret=your_turn_secret_here

# نام دامنه
realm=matrix.local

# لاگ
log-file=/var/log/turnserver.log
verbose

# محدوده پورت‌های رله
min-port=49152
max-port=65535

# غیرفعال کردن تلفن قدیمی
no-multicast-peers
no-loopback-peers
```

### گام ۵: راه‌اندازی سیستم

```bash
cd ~/shad-local

# اجرای سرویس‌ها
docker compose up -d

# بررسی وضعیت
docker compose ps

# مشاهده لاگ‌ها
docker compose logs -f synapse

# ایجاد کاربر ادمین
docker exec -it synapse-server register_new_matrix_user \
  -c /data/homeserver.yaml \
  -u admin \
  -p Admin@1234 \
  -a \
  http://localhost:8448
```

### گام ۶: دسترسی به سیستم

پس از راه‌اندازی:

| سرویس | آدرس |
|-------|------|
| Element Web (کلاینت) | `http://192.168.1.100:8080` |
| Matrix Server | `http://192.168.1.100:8448` |
| Jitsi (ویدیوکنفرانس) | `https://192.168.1.100:8443` |

---

## مدیریت کاربران و امنیت

### ایجاد کاربران

**روش ۱: ثبت‌نام از طریق Element Web**
- به `http://192.168.1.100:8080` بروید
- روی "Create Account" کلیک کنید
- نام کاربری و رمز عبور وارد کنید
- آدرس سرور را به `192.168.1.100:8448` تغییر دهید

**روش ۲: ایجاد دسته‌جمعی کاربران (bulk)**

```bash
# اسکریپت Python برای ایجاد کاربران از فایل CSV
cat > /tmp/create_users.py << 'EOF'
import csv
import subprocess

# فایل CSV: username,password,admin
with open('users.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        admin_flag = '-a' if row['admin'] == 'true' else ''
        cmd = [
            'docker', 'exec', 'synapse-server',
            'register_new_matrix_user',
            '-c', '/data/homeserver.yaml',
            '-u', row['username'],
            '-p', row['password'],
            admin_flag,
            'http://localhost:8448'
        ]
        result = subprocess.run([x for x in cmd if x], capture_output=True, text=True)
        print(f"Created user {row['username']}: {result.returncode}")
EOF
```

فایل `users.csv` نمونه:
```csv
username,password,admin
teacher1,Pass@1234,false
teacher2,Pass@1234,false
student001,Pass@1234,false
student002,Pass@1234,false
```

### تنظیم محدودیت‌های کاربران

در `homeserver.yaml`:

```yaml
# محدودیت آپلود فایل
max_upload_size: 50M

# محدودیت اتاق‌های کاربر
max_mau_value: 100  # حداکثر کاربر فعال ماهانه

# جلوگیری از ثبت‌نام بدون دعوت (برای امنیت بیشتر)
enable_registration: false
# برای دعوت توسط ادمین:
registration_requires_token: true
```

### تولید Token دعوت

```bash
# ایجاد token برای ثبت‌نام
curl -X POST \
  "http://localhost:8448/_synapse/admin/v1/registration_tokens/new" \
  -H "Authorization: Bearer $(cat admin_token.txt)" \
  -H "Content-Type: application/json" \
  -d '{"uses_allowed": 50, "expiry_time": null}'
```

### گرفتن Access Token ادمین

```bash
curl -X POST \
  "http://localhost:8448/_matrix/client/v3/login" \
  -H "Content-Type: application/json" \
  -d '{"type": "m.login.password", "user": "admin", "password": "Admin@1234"}'
```

---

## امنیت و بهینه‌سازی

### تنظیمات امنیتی پایه

```bash
# تنظیم Firewall (UFW)
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # Element Web
sudo ufw allow 8448/tcp  # Matrix/Synapse
sudo ufw allow 3478/udp  # TURN/STUN
sudo ufw allow 3478/tcp  # TURN/STUN
sudo ufw allow 8443/tcp  # Jitsi
sudo ufw allow 10000/udp # Jitsi JVB
sudo ufw enable
```

### بکاپ خودکار

```bash
cat > /home/runner/backup_matrix.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/matrix"

mkdir -p $BACKUP_DIR

# بکاپ دیتابیس
docker exec synapse-postgres pg_dump -U synapse synapse | \
  gzip > "$BACKUP_DIR/synapse_db_$DATE.sql.gz"

# بکاپ فایل‌های رسانه
tar -czf "$BACKUP_DIR/media_$DATE.tar.gz" ~/shad-local/synapse/media_store/

# حذف بکاپ‌های قدیمی‌تر از ۷ روز
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

chmod +x /home/runner/backup_matrix.sh

# اجرای خودکار روزانه
echo "0 2 * * * /home/runner/backup_matrix.sh" | crontab -
```

### مانیتورینگ منابع

```bash
# بررسی مصرف منابع در زمان واقعی
docker stats

# مشاهده لاگ‌های Synapse
docker compose logs -f synapse --tail=100

# بررسی وضعیت سرویس‌ها
docker compose ps

# تعداد کاربران فعال
curl -s "http://localhost:8448/_synapse/admin/v1/users?limit=200&guests=false" \
  -H "Authorization: Bearer $ADMIN_TOKEN" | python3 -m json.tool | grep '"total"'
```

---

## عیب‌یابی

### مشکل: Synapse راه‌اندازی نمی‌شود

```bash
# بررسی لاگ‌ها
docker compose logs synapse

# خطاهای رایج:
# 1. مشکل اتصال به دیتابیس
docker compose logs postgres

# 2. خطای پیکربندی
docker exec synapse-server python -c "
import yaml
with open('/data/homeserver.yaml') as f:
    yaml.safe_load(f)
print('Config OK')
"
```

### مشکل: کاربر نمی‌تواند ثبت‌نام کند

```bash
# بررسی تنظیمات ثبت‌نام در homeserver.yaml
grep "enable_registration" ~/shad-local/synapse/homeserver.yaml

# فعال کردن موقت ثبت‌نام
docker exec synapse-server sed -i \
  's/enable_registration: false/enable_registration: true/' \
  /data/homeserver.yaml

# ری‌استارت Synapse
docker compose restart synapse
```

### مشکل: تماس ویدیویی برقرار نمی‌شود

```bash
# تست TURN Server
docker run --rm -it instrumentisto/coturn turnutils_uclient \
  -u test -w your_turn_secret_here \
  -p 3478 192.168.1.100

# بررسی پورت‌های باز
sudo netstat -tulnp | grep -E '3478|10000'
```

### مشکل: کندی سیستم با ۱۰۰ کاربر

```yaml
# در homeserver.yaml، افزایش pool اتصالات دیتابیس:
database:
  args:
    cp_min: 10
    cp_max: 50

# در docker-compose.yml، افزایش منابع:
services:
  synapse:
    deploy:
      resources:
        limits:
          memory: 4G
          cpus: '2.0'
```

---

## خلاصه

برای راه‌اندازی یک سیستم مشابه شاد برای ۱۰۰ کاربر:

| مرحله | توضیح |
|-------|-------|
| ۱ | نصب Docker و Docker Compose روی سرور Ubuntu |
| ۲ | تنظیم فایل‌های پیکربندی (homeserver.yaml، config.json) |
| ۳ | اجرای `docker compose up -d` |
| ۴ | ایجاد کاربر ادمین |
| ۵ | دسترسی از طریق Element Web در مرورگر |
| ۶ | ایجاد اتاق‌های درسی و دعوت دانش‌آموزان |

**بودجه سخت‌افزاری تخمینی** (برای ۱۰۰ کاربر محلی):
- سرور فیزیکی: ۴ core / ۸ GB RAM / ۲۵۰ GB SSD → حدود ۵-۱۰ میلیون تومان
- سرور ابری (VPS داخلی): حدود ۵۰۰,۰۰۰ تا ۱,۰۰۰,۰۰۰ تومان/ماه

---

*این راهنما بر اساس آخرین نسخه‌های Matrix/Synapse و Element Web تهیه شده است.*
*برای اطلاعات بیشتر: https://matrix.org/docs/*
