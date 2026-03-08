#!/usr/bin/env bash
# ====================================================
# setup.sh — راه‌اندازی پلتفرم آموزشی محلی (مشابه شاد)
# Local Educational Platform Setup Script
# ====================================================
#
# استفاده / Usage:
#   chmod +x scripts/setup.sh
#   ./scripts/setup.sh
#
# برای راه‌اندازی بدون SSL (تست محلی):
#   ./scripts/setup.sh --no-ssl
# ====================================================

set -euo pipefail

# رنگ‌ها
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
USE_SSL=true

# پردازش آرگومان‌ها
for arg in "$@"; do
  case $arg in
    --no-ssl)
      USE_SSL=false
      ;;
  esac
done

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
info() { echo -e "${BLUE}[→]${NC} $1"; }

banner() {
  echo -e "${BLUE}"
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║   پلتفرم آموزشی محلی — مشابه شاد                     ║"
  echo "║   Local Educational Platform (SHAD-like)              ║"
  echo "║   بهینه‌شده برای ۱۰۰ کاربر همزمان                    ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

check_requirements() {
  info "بررسی پیش‌نیازها..."

  command -v docker &>/dev/null  || err "Docker نصب نیست. https://docs.docker.com/get-docker/"
  command -v docker &>/dev/null && docker compose version &>/dev/null || \
    err "Docker Compose v2 نصب نیست: sudo apt-get install docker-compose-plugin"

  # حداقل RAM
  local total_ram
  total_ram=$(awk '/MemTotal/ {print int($2/1024/1024)}' /proc/meminfo 2>/dev/null || echo "0")
  if [[ "$total_ram" -lt 6 ]]; then
    warn "RAM شما ${total_ram}GB است. حداقل 8GB توصیه می‌شود."
  else
    log "RAM: ${total_ram}GB ✓"
  fi

  # حداقل فضای دیسک (30GB)
  local free_disk
  free_disk=$(df -BG "$PROJECT_DIR" | awk 'NR==2 {print int($4)}')
  if [[ "$free_disk" -lt 30 ]]; then
    warn "فضای آزاد دیسک ${free_disk}GB است. حداقل 30GB توصیه می‌شود."
  else
    log "فضای دیسک: ${free_disk}GB آزاد ✓"
  fi

  log "پیش‌نیازها بررسی شدند"
}

setup_env() {
  info "تنظیم متغیرهای محیطی..."
  cd "$PROJECT_DIR"

  if [[ ! -f .env ]]; then
    cp .env.example .env
    # تولید رمزهای تصادفی
    local mongo_pass minio_pass admin_pass
    mongo_pass=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9!@#$%' | head -c 20)
    minio_pass=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9!@#$%' | head -c 20)
    admin_pass=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9!@#$%' | head -c 20)

    sed -i "s|ChangeMongoPassword456!|${mongo_pass}|g" .env
    sed -i "s|ChangeMinioPassword789!|${minio_pass}|g" .env
    sed -i "s|ChangeThisPassword123!|${admin_pass}|g" .env

    log "فایل .env ایجاد شد با رمزهای تصادفی"
    echo ""
    warn "رمز ادمین اولیه: ${admin_pass}"
    warn "این رمز را یادداشت کنید! پس از راه‌اندازی قابل بازیابی نیست."
    echo ""
  else
    log "فایل .env از قبل وجود دارد"
  fi
}

setup_ssl() {
  info "تنظیم SSL..."
  mkdir -p "$PROJECT_DIR/nginx/ssl"

  if [[ "$USE_SSL" == false ]]; then
    warn "حالت بدون SSL — فقط برای تست محلی"
    # فعال‌سازی بلوک HTTP در nginx.conf (حذف کامنت از خطوط مربوطه)
    sed -i 's|^[[:space:]]*# server {[[:space:]]*$|    server {|' "$PROJECT_DIR/nginx/nginx.conf"
    sed -i 's|^[[:space:]]*# }[[:space:]]*$|    }|' "$PROJECT_DIR/nginx/nginx.conf"
    return
  fi

  if [[ -f "$PROJECT_DIR/nginx/ssl/fullchain.pem" ]]; then
    log "گواهی SSL از قبل وجود دارد"
    return
  fi

  warn "گواهی SSL یافت نشد. در حال تولید گواهی خود-امضا برای تست..."
  warn "برای محیط production، از Let's Encrypt استفاده کنید."

  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$PROJECT_DIR/nginx/ssl/privkey.pem" \
    -out "$PROJECT_DIR/nginx/ssl/fullchain.pem" \
    -subj "/C=IR/ST=Tehran/L=Tehran/O=School/OU=IT/CN=localhost" \
    2>/dev/null

  log "گواهی SSL خود-امضا ایجاد شد (فقط برای تست)"
}

start_services() {
  info "راه‌اندازی سرویس‌ها..."
  cd "$PROJECT_DIR"

  # دانلود image‌ها
  docker compose pull --quiet

  # راه‌اندازی
  docker compose up -d

  log "سرویس‌ها در حال راه‌اندازی..."
}

wait_for_rocketchat() {
  info "انتظار برای راه‌اندازی Rocket.Chat (تا ۳ دقیقه)..."
  local max_attempts=36
  local attempt=0
  local url="http://localhost:3000/api/info"

  while [[ $attempt -lt $max_attempts ]]; do
    if curl -sf "$url" &>/dev/null; then
      log "Rocket.Chat آماده است!"
      return 0
    fi
    attempt=$((attempt + 1))
    echo -n "."
    sleep 5
  done

  echo ""
  err "Rocket.Chat پس از ۳ دقیقه راه‌اندازی نشد. لاگ‌ها را بررسی کنید:
  docker compose logs rocketchat"
}

print_summary() {
  local root_url
  root_url=$(grep '^ROOT_URL=' "$PROJECT_DIR/.env" | cut -d= -f2)

  echo ""
  echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}  پلتفرم آموزشی با موفقیت راه‌اندازی شد!${NC}"
  echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
  echo ""
  echo -e "  🌐 آدرس پلتفرم:      ${BLUE}${root_url}${NC}"
  echo -e "  🔧 پنل MinIO:         ${BLUE}http://localhost:9001${NC}"
  echo ""
  echo -e "  👤 نام کاربری ادمین: ${YELLOW}$(grep '^ADMIN_USERNAME=' "$PROJECT_DIR/.env" | cut -d= -f2)${NC}"
  echo -e "  🔑 رمز ادمین:        ${YELLOW}$(grep '^ADMIN_PASSWORD=' "$PROJECT_DIR/.env" | cut -d= -f2)${NC}"
  echo ""
  echo -e "  📚 برای ایجاد ۱۰۰ کاربر:"
  echo -e "     ${BLUE}node scripts/init-users.js${NC}"
  echo ""
  echo -e "  📖 راهنمای کامل: educational_platform/README.md"
  echo ""
  echo -e "  🛑 برای متوقف کردن:"
  echo -e "     ${RED}docker compose down${NC}"
  echo ""
  echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
}

main() {
  banner
  check_requirements
  setup_env
  setup_ssl
  start_services
  wait_for_rocketchat
  print_summary
}

main "$@"
