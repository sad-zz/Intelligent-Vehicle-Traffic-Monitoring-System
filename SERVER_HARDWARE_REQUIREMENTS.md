# مشخصات سرور و راهنمای راه‌اندازی کامل

## نمای کلی

این سند شامل تمام اطلاعات مورد نیاز برای راه‌اندازی سرور مرکزی سیستم نظارت بر تردد خودروها است.

---

## بخش 1: مشخصات سخت‌افزار سرور

### 1.1 پیکربندی‌های پیشنهادی

#### پیکربندی کوچک (تا 50 دستگاه)

| قطعه | مشخصات | قیمت تقریبی |
|------|---------|-------------|
| **CPU** | Intel Core i5 (4 Core, 8 Thread) یا AMD Ryzen 5 | $200 |
| **RAM** | 8GB DDR4 | $40 |
| **Storage** | 256GB SSD SATA | $30 |
| **Network** | Gigabit Ethernet (onboard) | - |
| **Power Supply** | 300W | $30 |
| **Case** | Standard ATX | $40 |
| **UPS** | 650VA (اختیاری ولی توصیه می‌شود) | $80 |

**مجموع:** ≈ $420 (بدون UPS)

#### پیکربندی متوسط (50-150 دستگاه)

| قطعه | مشخصات | قیمت تقریبی |
|------|---------|-------------|
| **CPU** | Intel Xeon E-2236 (6 Core, 12 Thread) | $400 |
| **RAM** | 16GB DDR4 ECC | $120 |
| **Storage OS** | 256GB NVMe SSD | $50 |
| **Storage Data** | 1TB HDD 7200RPM | $50 |
| **Network** | Dual Gigabit Ethernet | $30 |
| **Power Supply** | 500W | $50 |
| **UPS** | 1500VA | $200 |
| **Rack Case** | 1U Rackmount (اختیاری) | $100 |

**مجموع:** ≈ $1000

#### پیکربندی بزرگ (150-200 دستگاه)

| قطعه | مشخصات | قیمت تقریبی |
|------|---------|-------------|
| **CPU** | Intel Xeon E-2288G (8 Core, 16 Thread) | $600 |
| **RAM** | 32GB DDR4 ECC | $250 |
| **Storage OS** | 512GB NVMe SSD | $80 |
| **Storage Data** | 2TB SSD SATA | $200 |
| **Network** | Dual Gigabit Ethernet | $30 |
| **Power Supply** | 650W Redundant | $150 |
| **UPS** | 3000VA | $400 |
| **Rack** | 19" Rack | $200 |

**مجموع:** ≈ $1900

### 1.2 محاسبه نیازمندی‌های سرور

#### CPU
```
فرمول: تعداد دستگاه × 0.02 Core

مثال برای 100 دستگاه:
100 × 0.02 = 2 Core (حداقل)
توصیه: 4-6 Core
```

#### RAM
```
فرمول: (تعداد دستگاه × 40MB) + 2GB (OS) + 1GB (Redis)

مثال برای 100 دستگاه:
(100 × 40MB) + 2GB + 1GB = 7GB
توصیه: 8-16GB
```

#### Storage
```
محاسبه فضای دیتابیس:

هر دستگاه = 512 bytes/interval
Intervals per day = 144 (10 دقیقه)
Data per device per day = 512 × 144 = 73KB

برای 100 دستگاه، 365 روز:
100 × 73KB × 365 = 2.6GB/year

با احتساب indexes و overhead: × 3 = 8GB/year

توصیه:
- 50 دستگاه: 256GB SSD
- 100 دستگاه: 512GB SSD
- 200 دستگاه: 1TB SSD
```

#### Network Bandwidth
```
محاسبه:

هر بسته داده ≈ 2KB
هر دستگاه ارسال هر 10 دقیقه = 144 packet/day
Peak load (اگر همه همزمان): تعداد دستگاه × 2KB

برای 100 دستگاه:
Normal: 100 × 2KB / 600s = 0.33 KB/s
Peak: 100 × 2KB = 200KB

توصیه: Gigabit Ethernet (کافی برای 200 دستگاه)
```

---

## بخش 2: نصب سیستم عامل

### 2.1 انتخاب سیستم عامل

**توصیه: Ubuntu Server 22.04 LTS**

**دلایل:**
- ✅ رایگان و Open Source
- ✅ پشتیبانی بلند‌مدت (5 سال)
- ✅ مستندات کامل
- ✅ جامعه بزرگ کاربران
- ✅ سازگاری عالی با Python/PostgreSQL

**جایگزین‌های دیگر:**
- Debian 12
- CentOS Stream 9
- Rocky Linux 9

### 2.2 دانلود و نصب Ubuntu Server

#### دانلود
```bash
# لینک دانلود:
https://ubuntu.com/download/server

# یا با wget:
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso
```

#### ساخت USB نصب

**Linux:**
```bash
# یافتن دستگاه USB
lsblk

# نوشتن ISO روی USB (جایگزین /dev/sdX با دستگاه صحیح)
sudo dd if=ubuntu-22.04.3-live-server-amd64.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

**Windows:**
- استفاده از Rufus: https://rufus.ie/

#### مراحل نصب

1. **Boot از USB**
   - تنظیم Boot Order در BIOS
   - انتخاب USB

2. **انتخاب زبان و صفحه کلید**
   - زبان: English
   - Keyboard: US (یا مورد دلخواه)

3. **پیکربندی شبکه**
   - انتخاب اتصال Ethernet
   - IPv4: DHCP (یا Static IP)

   **برای Static IP:**
   ```
   Subnet: 192.168.1.0/24
   Address: 192.168.1.100
   Gateway: 192.168.1.1
   Name servers: 8.8.8.8, 8.8.4.4
   ```

4. **پیکربندی Storage**
   - انتخاب "Use an entire disk"
   - یا Manual برای Partitioning سفارشی:

   **پیشنهاد Partitioning:**
   ```
   /boot  : 1GB  (ext4)
   /      : 50GB (ext4)
   swap   : 8GB  (برای 8GB RAM)
   /var   : Remaining (ext4) - برای دیتابیس
   ```

5. **Profile Setup**
   ```
   Your name: admin
   Server name: vtms-server
   Username: vtms
   Password: [رمز قوی]
   ```

6. **SSH Setup**
   - ✅ Install OpenSSH server

7. **Featured Server Snaps**
   - برای الان skip کنید (بعداً نصب می‌کنیم)

8. **نصب**
   - منتظر بمانید (15-30 دقیقه)
   - Reboot

### 2.3 تنظیمات اولیه پس از نصب

#### ورود به سیستم
```bash
# Local
username: vtms
password: [password]

# یا از راه دور (SSH)
ssh vtms@192.168.1.100
```

#### به‌روزرسانی سیستم
```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

#### نصب ابزارهای ضروری
```bash
sudo apt install -y \
  curl wget git vim htop \
  net-tools build-essential \
  software-properties-common
```

#### تنظیم Timezone
```bash
sudo timedatectl set-timezone Asia/Tehran

# بررسی
timedatectl
```

#### تنظیم Hostname
```bash
sudo hostnamectl set-hostname vtms-server

# بررسی
hostnamectl
```

#### غیرفعال کردن Swap (اختیاری - برای بهینه‌سازی)
```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

---

## بخش 3: نصب و پیکربندی نرم‌افزارها

### 3.1 نصب PostgreSQL

```bash
# اضافه کردن repository PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# نصب PostgreSQL 15
sudo apt update
sudo apt install -y postgresql-15 postgresql-contrib-15

# بررسی وضعیت
sudo systemctl status postgresql

# فعال کردن auto-start
sudo systemctl enable postgresql
```

#### پیکربندی PostgreSQL

**1. ایجاد User و Database:**
```bash
# ورود به PostgreSQL
sudo -u postgres psql

# در PostgreSQL shell:
CREATE DATABASE vehicle_traffic_db;
CREATE USER vtms WITH ENCRYPTED PASSWORD 'YourStrongPassword123!';
GRANT ALL PRIVILEGES ON DATABASE vehicle_traffic_db TO vtms;

# خروج
\q
```

**2. تنظیم دسترسی از راه دور (اختیاری):**
```bash
# ویرایش pg_hba.conf
sudo nano /etc/postgresql/15/main/pg_hba.conf

# اضافه کردن خط زیر (برای شبکه محلی):
host    all             all             192.168.1.0/24          md5

# ویرایش postgresql.conf
sudo nano /etc/postgresql/15/main/postgresql.conf

# تغییر:
listen_addresses = '*'

# Restart
sudo systemctl restart postgresql
```

**3. بهینه‌سازی PostgreSQL:**
```bash
sudo nano /etc/postgresql/15/main/postgresql.conf

# تنظیمات پیشنهادی (برای 16GB RAM):
shared_buffers = 4GB
effective_cache_size = 12GB
maintenance_work_mem = 1GB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 10MB
min_wal_size = 1GB
max_wal_size = 4GB
max_worker_processes = 4
max_parallel_workers_per_gather = 2
max_parallel_workers = 4

# Restart
sudo systemctl restart postgresql
```

### 3.2 نصب Redis

```bash
# نصب Redis
sudo apt install -y redis-server

# پیکربندی
sudo nano /etc/redis/redis.conf

# تغییرات:
supervised systemd
maxmemory 1gb
maxmemory-policy allkeys-lru

# Restart
sudo systemctl restart redis-server
sudo systemctl enable redis-server

# تست
redis-cli ping
# باید پاسخ دهد: PONG
```

### 3.3 نصب Python و Dependencies

```bash
# نصب Python 3.10+
sudo apt install -y python3 python3-pip python3-venv python3-dev

# بررسی نسخه
python3 --version

# ایجاد Virtual Environment
cd /opt
sudo mkdir vtms
sudo chown vtms:vtms vtms
cd vtms

python3 -m venv venv
source venv/bin/activate

# نصب dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

### 3.4 نصب Nginx (Web Server & Reverse Proxy)

```bash
# نصب Nginx
sudo apt install -y nginx

# فعال کردن
sudo systemctl enable nginx
sudo systemctl start nginx

# بررسی
sudo systemctl status nginx

# تست
curl http://localhost
```

#### پیکربندی Nginx

```bash
# ایجاد فایل پیکربندی
sudo nano /etc/nginx/sites-available/vtms

# محتوا:
server {
    listen 80;
    server_name your-domain.com;  # یا IP سرور

    # Static files (Dashboard)
    location / {
        root /opt/vtms/server/frontend/dashboard;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API Proxy
    location /api {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # WebSocket Proxy
    location /socket.io {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }

    # Health check
    location /health {
        proxy_pass http://127.0.0.1:5000;
    }
}

# فعال کردن سایت
sudo ln -s /etc/nginx/sites-available/vtms /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 3.5 نصب و راه‌اندازی Application

```bash
# Clone repository
cd /opt/vtms
git clone https://github.com/your-repo/Intelligent-Vehicle-Traffic-Monitoring-System.git app
cd app

# Copy files
sudo cp -r server/* /opt/vtms/

# Virtual environment
source /opt/vtms/venv/bin/activate
cd /opt/vtms/backend

# Install dependencies
pip install -r requirements.txt

# تنظیمات محیطی
sudo nano /opt/vtms/.env

# محتوا:
FLASK_ENV=production
DATABASE_URL=postgresql://vtms:YourStrongPassword123!@localhost:5432/vehicle_traffic_db
REDIS_URL=redis://localhost:6379/0
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(32))')
TCP_LISTEN_HOST=0.0.0.0
TCP_LISTEN_PORT=8080
WEB_LISTEN_PORT=5000

# Load environment
export $(cat /opt/vtms/.env | xargs)

# ایجاد جداول دیتابیس
psql -U vtms -d vehicle_traffic_db -f /opt/vtms/database/schema.sql
```

### 3.6 ساخت Systemd Service

```bash
# ایجاد service file
sudo nano /etc/systemd/system/vtms.service

# محتوا:
[Unit]
Description=Vehicle Traffic Monitoring System
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=vtms
WorkingDirectory=/opt/vtms/backend
Environment="PATH=/opt/vtms/venv/bin"
EnvironmentFile=/opt/vtms/.env
ExecStart=/opt/vtms/venv/bin/python app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# فعال کردن و شروع
sudo systemctl daemon-reload
sudo systemctl enable vtms
sudo systemctl start vtms

# بررسی وضعیت
sudo systemctl status vtms

# مشاهده لاگ‌ها
sudo journalctl -u vtms -f
```

---

## بخش 4: تنظیمات امنیتی

### 4.1 Firewall (UFW)

```bash
# فعال کردن UFW
sudo ufw enable

# قوانین پایه
sudo ufw default deny incoming
sudo ufw default allow outgoing

# اجازه دسترسی
sudo ufw allow ssh
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 8080/tcp  # TCP Server (از دستگاه‌ها)

# محدود کردن SSH (اختیاری)
sudo ufw limit ssh

# بررسی
sudo ufw status verbose
```

### 4.2 تنظیم SSH

```bash
# ویرایش پیکربندی
sudo nano /etc/ssh/sshd_config

# تغییرات امنیتی:
PermitRootLogin no
PasswordAuthentication yes  # یا no اگر از SSH Key استفاده می‌کنید
PubkeyAuthentication yes
Port 22  # یا یک پورت دیگر
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2

# Restart
sudo systemctl restart sshd
```

### 4.3 SSL/TLS با Let's Encrypt (اختیاری ولی توصیه می‌شود)

```bash
# نصب Certbot
sudo apt install -y certbot python3-certbot-nginx

# دریافت گواهی
sudo certbot --nginx -d your-domain.com

# تست تمدید خودکار
sudo certbot renew --dry-run
```

### 4.4 Fail2ban (محافظت در برابر Brute Force)

```bash
# نصب
sudo apt install -y fail2ban

# پیکربندی
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local

# تنظیمات:
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

# شروع
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# بررسی
sudo fail2ban-client status sshd
```

---

## بخش 5: Monitoring و Logging

### 5.1 نصب Grafana (اختیاری)

```bash
# اضافه کردن repository
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# نصب
sudo apt-get update
sudo apt-get install -y grafana

# فعال کردن
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# دسترسی: http://your-server:3000
# Default login: admin/admin
```

### 5.2 Log Rotation

```bash
# ایجاد پیکربندی logrotate
sudo nano /etc/logrotate.d/vtms

# محتوا:
/var/log/vtms/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 vtms vtms
    sharedscripts
    postrotate
        systemctl reload vtms > /dev/null
    endscript
}
```

### 5.3 System Monitoring

```bash
# نصب htop
sudo apt install -y htop

# نصب netdata (اختیاری)
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# دسترسی: http://your-server:19999
```

---

## بخش 6: Backup و Recovery

### 6.1 Backup خودکار دیتابیس

```bash
# ایجاد اسکریپت backup
sudo nano /opt/vtms/scripts/backup.sh

# محتوا:
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/vtms/backups"
DB_NAME="vehicle_traffic_db"
DB_USER="vtms"

mkdir -p $BACKUP_DIR

# Backup database
pg_dump -U $DB_USER $DB_NAME | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# حذف backup های قدیمی (بیش از 30 روز)
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete

# اجرای مجوز
sudo chmod +x /opt/vtms/scripts/backup.sh

# اضافه کردن به crontab (هر روز ساعت 2 صبح)
sudo crontab -e

# اضافه کردن:
0 2 * * * /opt/vtms/scripts/backup.sh
```

### 6.2 Restore از Backup

```bash
# لیست backup ها
ls -lh /opt/vtms/backups/

# Restore
gunzip -c /opt/vtms/backups/db_YYYYMMDD_HHMMSS.sql.gz | \
  psql -U vtms vehicle_traffic_db
```

---

## بخش 7: بهینه‌سازی عملکرد

### 7.1 تنظیمات سیستم

```bash
# ویرایش sysctl
sudo nano /etc/sysctl.conf

# اضافه کردن:
# Network
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.ip_local_port_range = 10000 65000

# File descriptors
fs.file-max = 65536

# اعمال تغییرات
sudo sysctl -p
```

### 7.2 PostgreSQL Vacuum

```bash
# اضافه کردن به crontab
sudo crontab -e

# هر هفته یکشنبه ساعت 3 صبح
0 3 * * 0 vacuumdb -U vtms -d vehicle_traffic_db -z
```

---

## بخش 8: تست سرور

### 8.1 تست اتصال TCP

```bash
# از یک کامپیوتر دیگر
telnet your-server-ip 8080

# یا با netcat
nc -zv your-server-ip 8080
```

### 8.2 تست API

```bash
# Health check
curl http://your-server-ip/health

# دریافت لیست دستگاه‌ها
curl http://your-server-ip/api/devices

# دریافت خلاصه
curl http://your-server-ip/api/dashboard/summary
```

### 8.3 تست Load (اختیاری)

```bash
# نصب Apache Bench
sudo apt install -y apache2-utils

# تست 1000 request با 10 concurrent
ab -n 1000 -c 10 http://your-server-ip/api/devices
```

---

## بخش 9: عیب‌یابی

### مشکلات رایج و راه‌حل

#### 1. سرویس start نمی‌شود

```bash
# بررسی لاگ
sudo journalctl -u vtms -n 50

# بررسی پورت‌ها
sudo netstat -tulpn | grep -E '5000|8080'

# Kill process روی پورت
sudo lsof -ti:5000 | xargs kill -9
```

#### 2. دیتابیس connection error

```bash
# بررسی PostgreSQL
sudo systemctl status postgresql

# تست اتصال
psql -U vtms -d vehicle_traffic_db -h localhost

# بررسی لاگ
sudo tail -f /var/log/postgresql/postgresql-15-main.log
```

#### 3. Performance پایین

```bash
# بررسی منابع
htop

# بررسی disk I/O
iostat -x 1

# بررسی network
iftop
```

---

## بخش 10: Checklist راه‌اندازی

### Pre-deployment
- [ ] سخت‌افزار آماده و تست شده
- [ ] سیستم عامل نصب شده
- [ ] شبکه پیکربندی شده (IP ثابت)
- [ ] Firewall تنظیم شده

### Software Installation
- [ ] PostgreSQL نصب و پیکربندی شده
- [ ] Redis نصب شده
- [ ] Python و dependencies نصب شده
- [ ] Nginx نصب و پیکربندی شده
- [ ] Application راه‌اندازی شده

### Security
- [ ] Firewall فعال
- [ ] SSH محدود شده
- [ ] SSL/TLS نصب شده (برای production)
- [ ] Fail2ban فعال
- [ ] Backup خودکار تنظیم شده

### Testing
- [ ] TCP Server جواب می‌دهد (port 8080)
- [ ] API در دسترس است (port 80/443)
- [ ] Dashboard باز می‌شود
- [ ] Database queries کار می‌کنند

### Monitoring
- [ ] Logs قابل دسترسی
- [ ] Monitoring فعال (Grafana/Netdata)
- [ ] Alerts تنظیم شده

---

## فایل‌های مرجع

```
/opt/vtms/
├── venv/                    # Python virtual environment
├── backend/                 # Flask application
├── frontend/                # Web dashboard
├── database/                # Database schemas
├── scripts/                 # Maintenance scripts
│   └── backup.sh
├── backups/                 # Database backups
└── .env                     # Environment variables
```

---

## پشتیبانی و منابع

- **Documentation:** `README.md` در repository
- **Server logs:** `/var/log/vtms/`
- **Application logs:** `sudo journalctl -u vtms`
- **Database logs:** `/var/log/postgresql/`

---

**نکته:** همیشه قبل از تغییرات مهم، از سیستم backup بگیرید!
