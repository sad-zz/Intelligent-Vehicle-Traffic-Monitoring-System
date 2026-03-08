# راهنمای پیاده‌سازی دقیق پلتفرم کلاس آنلاین
## (مشابه شاد — برای ۴۰ کاربر همزمان)

---

## فهرست مطالب

1. [خلاصه اجرایی](#۱-خلاصه-اجرایی)
2. [معماری کامل سیستم](#۲-معماری-کامل-سیستم)
3. [احراز هویت با پیامک (SMS OTP)](#۳-احراز-هویت-با-پیامک-sms-otp)
4. [سرویس کلاس زنده (Live Class — مثل Clubhouse)](#۴-سرویس-کلاس-زنده-live-class)
5. [ارسال و دریافت فایل](#۵-ارسال-و-دریافت-فایل)
6. [پیکربندی کامل Docker](#۶-پیکربندی-کامل-docker)
7. [سمت کلاینت (وب + اندروید)](#۷-سمت-کلاینت-وب--اندروید)
8. [نیازمندی‌های سخت‌افزاری دقیق](#۸-نیازمندیهای-سختافزاری-دقیق)
9. [پیاده‌سازی گام‌به‌گام](#۹-پیادهسازی-گامبهگام)
10. [پایش، امنیت و نگهداری](#۱۰-پایش-امنیت-و-نگهداری)

---

## ۱. خلاصه اجرایی

### هدف سیستم
پلتفرم آموزش آنلاین با قابلیت‌های:
- ✅ ثبت‌نام و ورود با **پیامک OTP** (بدون نیاز به ایمیل)
- ✅ **کلاس صوتی/تصویری زنده** برای حداکثر ۴۰ نفر همزمان
- ✅ **اتاق صوتی Clubhouse-style** (همه می‌توانند صحبت کنند)
- ✅ **ارسال و دریافت** فایل متنی، تصویر، صدا
- ✅ کلاینت **وب (مرورگر)** و **اپ اندروید**

### انتخاب تکنولوژی

| بخش | تکنولوژی | دلیل انتخاب |
|-----|---------|------------|
| Backend API | **FastAPI (Python)** | سریع، ساده، async، مستندات خودکار |
| احراز هویت | **JWT + Redis OTP** | بدون state، امن |
| پیامک | **Kavenegar / SMS.ir** | پشتیبانی ایران |
| چت real-time | **Socket.IO** | WebSocket با fallback |
| ویدیو/صدای زنده | **LiveKit** یا **Janus Gateway** | WebRTC enterprise-grade |
| ذخیره فایل | **MinIO** | S3-compatible، self-hosted |
| دیتابیس | **PostgreSQL** | رابطه‌ای، قوی |
| Cache/Queue | **Redis** | کش OTP، session، queue |
| کانتینر | **Docker Compose** | ساده برای راه‌اندازی |

---

## ۲. معماری کامل سیستم

```
 ╔══════════════════════════════════════════════════════════════╗
 ║                   کلاینت‌ها                                   ║
 ║  ┌─────────────────┐          ┌──────────────────────────┐  ║
 ║  │  اپ اندروید      │          │   مرورگر وب (PWA)        │  ║
 ║  │  (React Native   │          │   (React / Vue)          │  ║
 ║  │   یا Flutter)    │          │                          │  ║
 ║  └────────┬────────┘          └──────────┬───────────────┘  ║
 ╚═══════════╪══════════════════════════════╪══════════════════╝
             │                              │
             └──────────────┬───────────────┘
                            │  HTTPS / WSS (TLS)
 ╔══════════════════════════▼═══════════════════════════════════╗
 ║                    Nginx (Reverse Proxy)                      ║
 ║        /api  →  FastAPI    /ws  →  Socket.IO                  ║
 ║        /livekit → LiveKit  /files → MinIO                     ║
 ╚══════════════════════════════════════════════════════════════╝
             │                    │                  │
    ┌────────▼────────┐  ┌────────▼──────┐  ┌───────▼────────┐
    │  FastAPI Server │  │  LiveKit SFU  │  │  MinIO Storage │
    │  (REST + WS)    │  │ (صدا و ویدیو) │  │  (فایل‌ها)     │
    │  Port: 8000     │  │  Port: 7880   │  │  Port: 9000    │
    └────────┬────────┘  └───────────────┘  └────────────────┘
             │
    ┌────────┴────────┐
    │                 │
 ┌──▼──────┐   ┌──────▼──┐
 │Postgres │   │  Redis  │
 │(کاربران │   │(OTP/Cache│
 │ کلاس‌ها)│   │ Session)│
 └─────────┘   └─────────┘
```

### جریان احراز هویت (OTP Flow)

```
کاربر       Frontend      FastAPI       Redis       SMS Provider
  │             │             │            │              │
  │──شماره───→  │             │            │              │
  │             │──POST /auth/send-otp──→  │              │
  │             │             │──ذخیره OTP→│              │
  │             │             │──────────────────SMS────→ │
  │             │             │            │              │──پیامک──→ تلفن کاربر
  │←─کد OTP─────│             │            │              │
  │──کد OTP──→  │             │            │              │
  │             │──POST /auth/verify-otp──→│              │
  │             │             │──بررسی OTP─│              │
  │             │←──JWT Token──            │              │
  │←─ورود موفق──│             │            │              │
```

---

## ۳. احراز هویت با پیامک (SMS OTP)

### ساختار دیتابیس کاربران

```sql
-- جدول کاربران
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone       VARCHAR(15) UNIQUE NOT NULL,   -- +989123456789
    full_name   VARCHAR(100),
    role        VARCHAR(20) DEFAULT 'student', -- student | teacher | admin
    avatar_url  TEXT,
    is_active   BOOLEAN DEFAULT true,
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    last_seen   TIMESTAMPTZ
);

-- جدول OTP (جهت کنترل محدودیت)
CREATE TABLE otp_logs (
    id          SERIAL PRIMARY KEY,
    phone       VARCHAR(15) NOT NULL,
    sent_at     TIMESTAMPTZ DEFAULT NOW(),
    ip_address  INET
);
CREATE INDEX ON otp_logs (phone, sent_at);
```

### کد سرور — ماژول احراز هویت (Python/FastAPI)

```python
# auth/router.py
import os
import secrets
import hashlib
import httpx
from datetime import datetime, timedelta
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
import redis.asyncio as aioredis
import jwt

router = APIRouter(prefix="/auth", tags=["auth"])

# ---- مدل‌های درخواست ----

class SendOTPRequest(BaseModel):
    phone: str          # مثال: 09123456789

class VerifyOTPRequest(BaseModel):
    phone: str
    code: str           # کد ۵ رقمی

# ---- تنظیمات (از متغیرهای محیطی) ----

SECRET_KEY = os.getenv("SECRET_KEY", "")  # باید در .env تنظیم شود
OTP_TTL_SECONDS = 120       # ۲ دقیقه اعتبار OTP
OTP_RATE_LIMIT = 3          # حداکثر ۳ بار در ۱۰ دقیقه

# ---- سرویس پیامک (Kavenegar) ----

async def send_sms(phone: str, code: str) -> bool:
    """ارسال پیامک OTP از طریق Kavenegar"""
    api_key = os.getenv("KAVENEGAR_API_KEY", "")
    url = f"https://api.kavenegar.com/v1/{api_key}/verify/lookup.json"
    params = {
        "receptor": phone,
        "token": code,
        "template": "verify"   # نام قالب در پنل Kavenegar
    }
    async with httpx.AsyncClient() as client:
        resp = await client.post(url, data=params, timeout=10)
    return resp.status_code == 200

# برای SMS.ir (جایگزین):
async def send_sms_smsir(phone: str, code: str) -> bool:
    """ارسال پیامک از طریق SMS.ir"""
    api_key = os.getenv("SMSIR_API_KEY", "")
    url = "https://api.sms.ir/v1/send/verify"
    payload = {
        "mobile": phone,
        "templateId": 12345,    # ID قالب در SMS.ir
        "parameters": [
            {"name": "CODE", "value": code}
        ]
    }
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            url,
            json=payload,
            headers={"x-api-key": api_key},
            timeout=10
        )
    return resp.status_code == 200

# ---- Endpoint: ارسال OTP ----

@router.post("/send-otp")
async def send_otp(
    req: SendOTPRequest,
    redis_client: aioredis.Redis = Depends(get_redis)
):
    phone = normalize_phone(req.phone)   # تبدیل 09xx به +989xx

    # بررسی محدودیت نرخ ارسال
    rate_key = f"otp_rate:{phone}"
    count = await redis_client.incr(rate_key)
    if count == 1:
        await redis_client.expire(rate_key, 600)   # ۱۰ دقیقه
    if count > OTP_RATE_LIMIT:
        raise HTTPException(429, "Too many OTP requests. Try again in 10 minutes.")

    # تولید کد ۵ رقمی — با secrets برای امنیت رمزنگاری
    code = str(secrets.randbelow(90000) + 10000)

    # ذخیره در Redis (هش‌شده)
    hashed = hashlib.sha256(code.encode()).hexdigest()
    otp_key = f"otp:{phone}"
    await redis_client.setex(otp_key, OTP_TTL_SECONDS, hashed)

    # ارسال پیامک
    sent = await send_sms(phone, code)
    if not sent:
        raise HTTPException(503, "Failed to send SMS. Try again.")

    return {"message": "OTP sent", "expires_in": OTP_TTL_SECONDS}

# ---- Endpoint: تأیید OTP و ورود ----

@router.post("/verify-otp")
async def verify_otp(
    req: VerifyOTPRequest,
    db=Depends(get_db),
    redis_client: aioredis.Redis = Depends(get_redis)
):
    phone = normalize_phone(req.phone)

    # بررسی OTP
    otp_key = f"otp:{phone}"
    stored_hash = await redis_client.get(otp_key)
    if not stored_hash:
        raise HTTPException(400, "OTP expired or not found.")

    input_hash = hashlib.sha256(req.code.encode()).hexdigest()
    # مقایسه با زمان ثابت برای جلوگیری از حملات Timing Attack
    if not secrets.compare_digest(input_hash, stored_hash):
        raise HTTPException(400, "Invalid OTP code.")

    # حذف OTP پس از استفاده (یکبار مصرف)
    await redis_client.delete(otp_key)

    # ایجاد یا یافتن کاربر
    user = await db.fetchrow(
        "SELECT * FROM users WHERE phone = $1", phone
    )
    if not user:
        user = await db.fetchrow(
            "INSERT INTO users (phone) VALUES ($1) RETURNING *", phone
        )

    # صدور JWT
    token_payload = {
        "sub": str(user["id"]),
        "phone": phone,
        "role": user["role"],
        "exp": datetime.utcnow() + timedelta(days=30)
    }
    token = jwt.encode(token_payload, SECRET_KEY, algorithm="HS256")

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": str(user["id"]),
            "phone": phone,
            "full_name": user["full_name"],
            "role": user["role"]
        }
    }

# ---- ابزار کمکی ----

def normalize_phone(phone: str) -> str:
    """تبدیل فرمت شماره به +98xxxxxxxx"""
    phone = phone.strip().replace(" ", "").replace("-", "")
    if phone.startswith("0"):
        return "+98" + phone[1:]
    if not phone.startswith("+"):
        return "+98" + phone
    return phone
```

---

## ۴. سرویس کلاس زنده (Live Class)

### انتخاب موتور WebRTC: **LiveKit**

LiveKit یک SFU (Selective Forwarding Unit) مدرن و متن‌باز است که:
- تا **۵۰۰ شرکت‌کننده** در یک اتاق پشتیبانی می‌کند
- برای **۴۰ نفر** منابع بسیار کمی مصرف می‌کند
- کلاینت دارد برای: iOS، Android، وب، Flutter، React Native
- مثل **Clubhouse**: همه می‌توانند میکروفون بزنند/خاموش کنند
- **اشتراک صفحه** (Screen Share) دارد
- **SDK پایتون** برای کنترل از سرور دارد

### مدل کلاس در دیتابیس

```sql
-- کلاس‌ها
CREATE TABLE classrooms (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(200) NOT NULL,
    description TEXT,
    owner_id    UUID REFERENCES users(id),
    room_token  VARCHAR(100) UNIQUE,    -- شناسه اتاق در LiveKit
    is_active   BOOLEAN DEFAULT false,
    max_members INTEGER DEFAULT 40,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- اعضای کلاس
CREATE TABLE classroom_members (
    classroom_id UUID REFERENCES classrooms(id),
    user_id      UUID REFERENCES users(id),
    role         VARCHAR(20) DEFAULT 'student',  -- student | teacher
    joined_at    TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (classroom_id, user_id)
);

-- پیام‌های چت کلاس
CREATE TABLE messages (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    classroom_id UUID REFERENCES classrooms(id),
    sender_id    UUID REFERENCES users(id),
    content      TEXT,
    file_url     TEXT,
    file_type    VARCHAR(20),   -- text | image | audio | video | document
    created_at   TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX ON messages (classroom_id, created_at DESC);
```

### کد سرور — مدیریت کلاس‌ها

```python
# classrooms/router.py
from livekit import api as livekit_api
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
import secrets

router = APIRouter(prefix="/classrooms", tags=["classrooms"])

LIVEKIT_URL = os.getenv("LIVEKIT_URL", "http://livekit:7880")
LIVEKIT_API_KEY = os.getenv("LIVEKIT_API_KEY", "")
LIVEKIT_API_SECRET = os.getenv("LIVEKIT_API_SECRET", "")

class CreateClassroomRequest(BaseModel):
    name: str
    description: str = ""
    max_members: int = 40

# ---- ایجاد کلاس جدید ----

@router.post("/")
async def create_classroom(
    req: CreateClassroomRequest,
    current_user=Depends(get_current_user),
    db=Depends(get_db)
):
    if current_user["role"] not in ("teacher", "admin"):
        raise HTTPException(403, "Only teachers can create classrooms")

    room_id = secrets.token_urlsafe(16)  # شناسه یکتای اتاق

    classroom = await db.fetchrow(
        """INSERT INTO classrooms
           (name, description, owner_id, room_token, max_members)
           VALUES ($1, $2, $3, $4, $5) RETURNING *""",
        req.name, req.description,
        current_user["id"], room_id, req.max_members
    )

    # اضافه کردن معلم به عنوان عضو
    await db.execute(
        """INSERT INTO classroom_members (classroom_id, user_id, role)
           VALUES ($1, $2, 'teacher')""",
        classroom["id"], current_user["id"]
    )

    return {"id": str(classroom["id"]), "name": classroom["name"],
            "room_id": room_id}  # room_id: شناسه اتاق LiveKit

# ---- شروع کلاس زنده ----

@router.post("/{classroom_id}/start")
async def start_live_class(
    classroom_id: str,
    current_user=Depends(get_current_user),
    db=Depends(get_db)
):
    classroom = await db.fetchrow(
        "SELECT * FROM classrooms WHERE id = $1", classroom_id
    )
    if not classroom:
        raise HTTPException(404, "Classroom not found")
    if str(classroom["owner_id"]) != current_user["id"]:
        raise HTTPException(403, "Only the teacher can start this class")

    # ایجاد اتاق در LiveKit
    lk = livekit_api.LiveKitAPI(
        url=LIVEKIT_URL,
        api_key=LIVEKIT_API_KEY,
        api_secret=LIVEKIT_API_SECRET
    )
    await lk.room.create_room(
        livekit_api.CreateRoomRequest(
            name=classroom["room_token"],
            max_participants=classroom["max_members"],
            empty_timeout=300   # ۵ دقیقه بعد از خروج همه، اتاق بسته می‌شود
        )
    )

    # علامت‌گذاری کلاس به عنوان فعال
    await db.execute(
        "UPDATE classrooms SET is_active = true WHERE id = $1", classroom_id
    )

    return {"message": "Live class started", "room": classroom["room_token"]}

# ---- دریافت توکن ورود به اتاق WebRTC ----

@router.post("/{classroom_id}/join-token")
async def get_join_token(
    classroom_id: str,
    current_user=Depends(get_current_user),
    db=Depends(get_db)
):
    classroom = await db.fetchrow(
        "SELECT * FROM classrooms WHERE id = $1 AND is_active = true",
        classroom_id
    )
    if not classroom:
        raise HTTPException(404, "Classroom not active or not found")

    # بررسی عضویت
    member = await db.fetchrow(
        """SELECT role FROM classroom_members
           WHERE classroom_id = $1 AND user_id = $2""",
        classroom_id, current_user["id"]
    )
    if not member:
        raise HTTPException(403, "You are not a member of this classroom")

    is_teacher = member["role"] == "teacher"

    # ساخت توکن LiveKit
    token = livekit_api.AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET)
    token.with_identity(current_user["id"])
    token.with_name(current_user["full_name"] or current_user["phone"])
    token.with_grants(livekit_api.VideoGrants(
        room_join=True,
        room=classroom["room_token"],
        can_publish=True,           # همه می‌توانند صحبت کنند (Clubhouse-style)
        can_subscribe=True,
        can_publish_data=True,
        room_admin=is_teacher       # معلم دسترسی ادمین دارد
    ))

    return {
        "token": token.to_jwt(),
        "livekit_url": "wss://your-server.com/livekit",
        "room": classroom["room_token"]
    }
```

### نحوه اتصال به کلاس از مرورگر (JavaScript)

```javascript
// classroom.js — اتصال WebRTC با LiveKit SDK
import { Room, RoomEvent, Track, createLocalTracks } from 'livekit-client';

async function joinClassroom(classroomId) {
  // دریافت توکن از سرور
  const resp = await fetch(`/api/classrooms/${classroomId}/join-token`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${localStorage.getItem('token')}` }
  });
  const { token, livekit_url } = await resp.json();

  // ایجاد اتاق
  const room = new Room({
    adaptiveStream: true,
    dynacast: true,
  });

  // شنیدن رویدادها
  room.on(RoomEvent.ParticipantConnected, (participant) => {
    console.log('کاربر وارد شد:', participant.identity);
    updateParticipantList();
  });

  room.on(RoomEvent.TrackSubscribed, (track, publication, participant) => {
    if (track.kind === Track.Kind.Audio) {
      // پخش صدای شرکت‌کننده
      const audioEl = track.attach();
      document.getElementById('audio-container').appendChild(audioEl);
    }
    if (track.kind === Track.Kind.Video) {
      // نمایش ویدیو
      const videoEl = track.attach();
      document.getElementById(`video-${participant.identity}`).appendChild(videoEl);
    }
  });

  // اتصال به اتاق
  await room.connect(livekit_url, token);

  // فعال کردن میکروفون و دوربین
  const tracks = await createLocalTracks({ audio: true, video: true });
  for (const track of tracks) {
    await room.localParticipant.publishTrack(track);
  }

  return room;
}

// خاموش/روشن کردن میکروفون (Clubhouse-style mute)
function toggleMicrophone(room) {
  const micEnabled = room.localParticipant.isMicrophoneEnabled;
  room.localParticipant.setMicrophoneEnabled(!micEnabled);
}
```

---

## ۵. ارسال و دریافت فایل

### انواع فایل پشتیبانی‌شده

| نوع | فرمت‌ها | حداکثر حجم |
|-----|---------|------------|
| تصویر | JPG، PNG، WEBP | ۱۰ MB |
| صدا | MP3، OGG، WAV، M4A | ۵۰ MB |
| ویدیو | MP4، WebM | ۲۰۰ MB |
| سند | PDF، DOCX، PPTX | ۵۰ MB |
| متن | TXT، MD | ۱ MB |

### ذخیره‌سازی فایل با MinIO

```python
# files/router.py
import boto3
from botocore.config import Config
from fastapi import APIRouter, UploadFile, Depends, HTTPException
import hashlib, mimetypes, uuid

router = APIRouter(prefix="/files", tags=["files"])

MINIO_ENDPOINT = os.getenv("MINIO_ENDPOINT", "minio:9000")
MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY", "")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY", "")
MINIO_BUCKET = "classroom-files"

# تعریف محدودیت‌های حجم فایل
MAX_FILE_SIZES = {
    "image": 10 * 1024 * 1024,    # 10 MB
    "audio": 50 * 1024 * 1024,    # 50 MB
    "video": 200 * 1024 * 1024,   # 200 MB
    "document": 50 * 1024 * 1024, # 50 MB
}

def get_s3_client():
    return boto3.client(
        "s3",
        endpoint_url=f"http://{MINIO_ENDPOINT}",
        aws_access_key_id=MINIO_ACCESS_KEY,
        aws_secret_access_key=MINIO_SECRET_KEY,
        config=Config(signature_version="s3v4"),
        region_name="us-east-1"
    )

def detect_file_type(content_type: str) -> str:
    if content_type.startswith("image/"):
        return "image"
    elif content_type.startswith("audio/"):
        return "audio"
    elif content_type.startswith("video/"):
        return "video"
    return "document"

@router.post("/upload")
async def upload_file(
    file: UploadFile,
    classroom_id: str,
    current_user=Depends(get_current_user),
    db=Depends(get_db)
):
    file_type = detect_file_type(file.content_type or "")
    max_size = MAX_FILE_SIZES.get(file_type, 10 * 1024 * 1024)

    # بررسی حجم فایل با streaming (بدون بارگذاری کل فایل در RAM)
    total_size = 0
    chunks = []
    async for chunk in file:
        total_size += len(chunk)
        if total_size > max_size:
            raise HTTPException(413, f"File too large. Max {max_size // (1024*1024)} MB")
        chunks.append(chunk)
    content = b"".join(chunks)

    # نام یکتا برای فایل
    ext = file.filename.rsplit(".", 1)[-1].lower() if "." in file.filename else ""
    file_key = f"{classroom_id}/{uuid.uuid4()}.{ext}"

    # آپلود به MinIO
    s3 = get_s3_client()
    s3.put_object(
        Bucket=MINIO_BUCKET,
        Key=file_key,
        Body=content,
        ContentType=file.content_type or "application/octet-stream",
        Metadata={"uploader": current_user["id"], "original_name": file.filename}
    )

    # ذخیره در دیتابیس
    msg = await db.fetchrow(
        """INSERT INTO messages
           (classroom_id, sender_id, file_url, file_type, content)
           VALUES ($1, $2, $3, $4, $5) RETURNING *""",
        classroom_id, current_user["id"],
        file_key, file_type, file.filename
    )

    # ساخت URL موقت قابل دانلود (۱ ساعت)
    download_url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": MINIO_BUCKET, "Key": file_key},
        ExpiresIn=3600
    )

    return {
        "message_id": str(msg["id"]),
        "file_url": download_url,
        "file_type": file_type,
        "filename": file.filename
    }
```

### چت real-time با Socket.IO

```python
# chat/socket_handler.py
import socketio
from datetime import datetime

sio = socketio.AsyncServer(
    async_mode="asgi",
    cors_allowed_origins=[
        "https://your-domain.com",   # دامنه اصلی
        "http://localhost:3000",      # برای توسعه محلی
    ]
)

@sio.event
async def connect(sid, environ, auth):
    """اتصال کاربر"""
    token = auth.get("token") if auth else None
    if not token:
        return False   # اتصال رد می‌شود
    user = verify_jwt(token)
    if not user:
        return False
    # ذخیره اطلاعات کاربر در session
    await sio.save_session(sid, {"user_id": user["sub"], "phone": user["phone"]})
    print(f"User {user['phone']} connected: {sid}")

@sio.event
async def join_classroom(sid, data):
    """ورود به اتاق چت کلاس"""
    session = await sio.get_session(sid)
    classroom_id = data.get("classroom_id")

    # بررسی عضویت از دیتابیس
    member = await check_membership(session["user_id"], classroom_id)
    if not member:
        await sio.emit("error", {"message": "Not a member"}, to=sid)
        return

    # ورود به اتاق Socket.IO
    await sio.enter_room(sid, f"classroom:{classroom_id}")
    await sio.emit("joined", {"classroom_id": classroom_id}, to=sid)

    # ارسال تاریخچه پیام‌ها (۵۰ پیام آخر)
    history = await get_recent_messages(classroom_id, limit=50)
    await sio.emit("message_history", history, to=sid)

@sio.event
async def send_message(sid, data):
    """ارسال پیام متنی"""
    session = await sio.get_session(sid)
    classroom_id = data.get("classroom_id")
    content = data.get("content", "").strip()

    if not content or len(content) > 4000:
        return

    # ذخیره در دیتابیس
    msg = await save_message(
        classroom_id=classroom_id,
        sender_id=session["user_id"],
        content=content
    )

    # ارسال به همه اعضای اتاق
    await sio.emit("new_message", {
        "id": str(msg["id"]),
        "sender_id": session["user_id"],
        "content": content,
        "created_at": datetime.utcnow().isoformat()
    }, room=f"classroom:{classroom_id}")

@sio.event
async def disconnect(sid):
    """قطع اتصال"""
    session = await sio.get_session(sid)
    print(f"User {session.get('phone', '?')} disconnected: {sid}")
```

---

## ۶. پیکربندی کامل Docker

### ساختار پوشه‌بندی پروژه

```
classroom-platform/
├── docker-compose.yml
├── nginx/
│   └── nginx.conf
├── backend/
│   ├── Dockerfile
│   ├── main.py
│   ├── requirements.txt
│   ├── auth/
│   │   └── router.py
│   ├── classrooms/
│   │   └── router.py
│   ├── files/
│   │   └── router.py
│   └── chat/
│       └── socket_handler.py
├── frontend/          (وب کلاینت)
│   ├── index.html
│   └── app.js
└── livekit/
    └── livekit.yaml
```

### فایل `docker-compose.yml`

> **نکته امنیتی**: تمام رمزها باید در فایل `.env` تعریف شوند و هرگز مستقیم در docker-compose.yml نوشته نشوند.

```yaml
version: '3.9'

services:

  # -------- دیتابیس --------
  postgres:
    image: postgres:15-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: classroom_db
      POSTGRES_USER: classroom_user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U classroom_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  # -------- Cache / OTP --------
  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s

  # -------- ذخیره فایل --------
  minio:
    image: minio/minio:latest
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ACCESS_KEY}
      MINIO_ROOT_PASSWORD: ${MINIO_SECRET_KEY}
    volumes:
      - minio_data:/data
    ports:
      - "9001:9001"   # پنل مدیریتی MinIO

  # -------- سرور WebRTC --------
  livekit:
    image: livekit/livekit-server:latest
    restart: unless-stopped
    command: --config /etc/livekit.yaml
    volumes:
      - ./livekit/livekit.yaml:/etc/livekit.yaml
    ports:
      - "7880:7880"   # HTTP/gRPC
      - "7881:7881"   # HTTPS
      - "7882:7882/udp"  # RTC/UDP
    environment:
      - LIVEKIT_KEYS=${LIVEKIT_API_KEY}:${LIVEKIT_API_SECRET}

  # -------- سرور اصلی API --------
  backend:
    build: ./backend
    restart: unless-stopped
    environment:
      DATABASE_URL: postgresql://classroom_user:${POSTGRES_PASSWORD}@postgres/classroom_db
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379/0
      MINIO_ENDPOINT: minio:9000
      MINIO_ACCESS_KEY: ${MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MINIO_SECRET_KEY}
      LIVEKIT_URL: http://livekit:7880
      LIVEKIT_API_KEY: ${LIVEKIT_API_KEY}
      LIVEKIT_API_SECRET: ${LIVEKIT_API_SECRET}
      SECRET_KEY: ${SECRET_KEY}
      KAVENEGAR_API_KEY: ${KAVENEGAR_API_KEY}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      minio:
        condition: service_started

  # -------- Reverse Proxy --------
  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
      - ./frontend:/usr/share/nginx/html
      - /etc/letsencrypt:/etc/letsencrypt:ro   # SSL certificate
    depends_on:
      - backend
      - livekit

volumes:
  postgres_data:
  redis_data:
  minio_data:
```

### فایل `.env.example` (باید در `.env` کپی و پر شود)

```dotenv
# رمز پایگاه داده
POSTGRES_PASSWORD=YourStrongDbPassword!

# رمز Redis
REDIS_PASSWORD=YourStrongRedisPassword!

# اطلاعات MinIO
MINIO_ACCESS_KEY=your-minio-admin-user
MINIO_SECRET_KEY=YourStrongMinioPassword!

# کلیدهای LiveKit (با دستور `openssl rand -hex 32` تولید کنید)
LIVEKIT_API_KEY=your-livekit-api-key
LIVEKIT_API_SECRET=your-livekit-api-secret

# کلید امضای JWT (با دستور `openssl rand -hex 32` تولید کنید)
SECRET_KEY=your-jwt-secret-key

# کلید API ارائه‌دهنده پیامک
KAVENEGAR_API_KEY=your-kavenegar-api-key
```

> **مهم**: فایل `.env` را هرگز در git commit نکنید. مطمئن شوید `.env` در `.gitignore` است.

### فایل `nginx/nginx.conf`

```nginx
upstream backend {
    server backend:8000;
}

upstream livekit {
    server livekit:7880;
}

server {
    listen 80;
    server_name your-domain.com;

    # وب کلاینت
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # API سرور
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        # محدودیت آپلود فایل — باید با MAX_FILE_SIZES در کد بکند هماهنگ باشد
        # (بزرگ‌ترین فایل مجاز: ویدیو ۲۰۰ MB + سربار multipart)
        client_max_body_size 210M;
    }

    # Socket.IO (چت real-time)
    location /socket.io/ {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400;
    }

    # LiveKit WebRTC
    location /livekit/ {
        proxy_pass http://livekit/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### فایل `livekit/livekit.yaml`

```yaml
# livekit.yaml — تنظیمات سرور WebRTC
port: 7880
bind_addresses:
  - ""

rtc:
  port_range_start: 50000
  port_range_end: 60000
  use_external_ip: false
  # اگر سرور پشت NAT است:
  # tcp_port: 7881
  # node_ip: 192.168.1.100   # IP داخلی سرور

keys:
  your-livekit-api-key: your-livekit-api-secret

# محدودیت‌ها برای ۴۰ نفر در اتاق
room:
  enabled_codecs:
    - mime: audio/opus
    - mime: video/h264
    - mime: video/vp8
  max_participants: 50

logging:
  json: false
  level: info
```

### `backend/Dockerfile`

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# نصب وابستگی‌های سیستمی
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
```

### `backend/requirements.txt`

```
fastapi==0.110.0
uvicorn[standard]==0.29.0
asyncpg==0.29.0
redis[hiredis]==5.0.3
python-jose[cryptography]==3.3.0
passlib==1.7.4
python-multipart==0.0.9
httpx==0.27.0
boto3==1.34.0
livekit==0.11.1
python-socketio==5.11.0
pydantic==2.6.0
```

---

## ۷. سمت کلاینت (وب + اندروید)

### کلاینت وب (HTML/JS ساده)

```html
<!-- frontend/index.html -->
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>کلاس آنلاین</title>
  <style>
    /* استایل فارسی */
    body { font-family: 'Vazirmatn', sans-serif; background: #f0f2f5; }
    .login-box { max-width: 380px; margin: 100px auto; background: white;
                 padding: 2rem; border-radius: 12px; box-shadow: 0 2px 20px rgba(0,0,0,.1); }
    .btn { background: #0084ff; color: white; border: none; padding: .75rem 1.5rem;
           border-radius: 8px; cursor: pointer; width: 100%; font-size: 1rem; margin-top: 1rem; }
    input { width: 100%; padding: .75rem; border: 1px solid #ddd; border-radius: 8px;
            font-size: 1rem; margin-top: .5rem; box-sizing: border-box; }
    .classroom-card { background: white; padding: 1rem; border-radius: 10px;
                      margin: .5rem; box-shadow: 0 1px 6px rgba(0,0,0,.08); }
    #participants { display: flex; flex-wrap: wrap; gap: 10px; padding: 1rem; }
    .participant { text-align: center; width: 80px; }
    .mic-icon { font-size: 2rem; }
  </style>
</head>
<body>

<!-- صفحه ورود -->
<div id="login-screen" class="login-box">
  <h2>ورود به کلاس آنلاین</h2>
  <div id="step-phone">
    <label>شماره موبایل</label>
    <input type="tel" id="phone" placeholder="09xxxxxxxxx" dir="ltr">
    <button class="btn" onclick="sendOTP()">ارسال کد</button>
  </div>
  <div id="step-otp" style="display:none">
    <label>کد تأیید ارسال‌شده به موبایل شما</label>
    <input type="text" id="otp-code" placeholder="12345" dir="ltr" maxlength="5">
    <button class="btn" onclick="verifyOTP()">تأیید و ورود</button>
  </div>
</div>

<!-- صفحه اصلی (بعد از ورود) -->
<div id="main-screen" style="display:none; padding: 1rem;">
  <h2>کلاس‌های من</h2>
  <div id="classrooms-list"></div>
</div>

<!-- صفحه کلاس زنده -->
<div id="classroom-screen" style="display:none; padding: 1rem;">
  <h2 id="classroom-name"></h2>
  <div id="participants"></div>
  <div>
    <button id="mic-btn" onclick="toggleMic()">🎤 میکروفون فعال</button>
    <button onclick="leaveClass()">خروج از کلاس</button>
  </div>
  <!-- چت -->
  <div id="chat-box" style="height:300px; overflow-y:auto; border:1px solid #ddd; padding:10px;"></div>
  <div style="display:flex; gap:8px; margin-top:8px;">
    <input id="chat-input" placeholder="پیام بنویسید..." style="flex:1">
    <button onclick="sendMessage()">ارسال</button>
    <input type="file" id="file-input" style="display:none" onchange="uploadFile()">
    <button onclick="document.getElementById('file-input').click()">📎 فایل</button>
  </div>
</div>

<script src="https://cdn.socket.io/4.7.5/socket.io.min.js"></script>
<script src="https://unpkg.com/livekit-client/dist/livekit-client.umd.min.js"></script>
<script>
const API = '/api';
let token = localStorage.getItem('token');
let currentRoom = null;
let socket = null;

// ---- احراز هویت ----

async function sendOTP() {
  const phone = document.getElementById('phone').value;
  const resp = await fetch(`${API}/auth/send-otp`, {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({phone})
  });
  if (resp.ok) {
    document.getElementById('step-phone').style.display = 'none';
    document.getElementById('step-otp').style.display = '';
    alert('کد تأیید ارسال شد');
  } else {
    alert('خطا در ارسال کد');
  }
}

async function verifyOTP() {
  const phone = document.getElementById('phone').value;
  const code = document.getElementById('otp-code').value;
  const resp = await fetch(`${API}/auth/verify-otp`, {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({phone, code})
  });
  if (resp.ok) {
    const data = await resp.json();
    token = data.access_token;
    localStorage.setItem('token', token);
    showMainScreen();
  } else {
    alert('کد اشتباه است');
  }
}

// ---- کلاس‌ها ----

async function showMainScreen() {
  document.getElementById('login-screen').style.display = 'none';
  document.getElementById('main-screen').style.display = '';
  loadClassrooms();
}

async function loadClassrooms() {
  const resp = await fetch(`${API}/classrooms/my`, {
    headers: {'Authorization': `Bearer ${token}`}
  });
  const classrooms = await resp.json();
  const list = document.getElementById('classrooms-list');
  list.innerHTML = classrooms.map(c => `
    <div class="classroom-card">
      <h3>${c.name}</h3>
      <p>${c.is_active ? '🟢 زنده' : '⚫ آفلاین'}</p>
      <button onclick="joinClassroom('${c.id}', '${c.name}')">ورود به کلاس</button>
    </div>
  `).join('');
}

// ---- ورود به کلاس زنده ----

async function joinClassroom(classroomId, name) {
  document.getElementById('main-screen').style.display = 'none';
  document.getElementById('classroom-screen').style.display = '';
  document.getElementById('classroom-name').textContent = name;

  // اتصال چت با Socket.IO
  socket = io({auth: {token}});
  socket.emit('join_classroom', {classroom_id: classroomId});
  socket.on('new_message', addMessageToChat);
  socket.on('message_history', (msgs) => msgs.forEach(addMessageToChat));

  // دریافت توکن WebRTC
  const resp = await fetch(`${API}/classrooms/${classroomId}/join-token`, {
    method: 'POST',
    headers: {'Authorization': `Bearer ${token}`}
  });
  const {token: lkToken, livekit_url, room} = await resp.json();

  // ورود به اتاق صوتی/تصویری
  const {Room, RoomEvent, Track, createLocalTracks} = LivekitClient;
  currentRoom = new Room();

  currentRoom.on(RoomEvent.ParticipantConnected, updateParticipants);
  currentRoom.on(RoomEvent.ParticipantDisconnected, updateParticipants);
  currentRoom.on(RoomEvent.TrackSubscribed, (track, pub, participant) => {
    if (track.kind === Track.Kind.Audio) {
      document.body.appendChild(track.attach());
    }
  });

  await currentRoom.connect(livekit_url, lkToken);
  const tracks = await createLocalTracks({audio: true, video: false});
  for (const t of tracks) await currentRoom.localParticipant.publishTrack(t);

  updateParticipants();
}

function updateParticipants() {
  const container = document.getElementById('participants');
  const all = [...currentRoom.remoteParticipants.values(),
               currentRoom.localParticipant];
  container.innerHTML = all.map(p => `
    <div class="participant">
      <div class="mic-icon">${p.isMicrophoneEnabled ? '🎤' : '🔇'}</div>
      <div>${p.name || p.identity}</div>
    </div>
  `).join('');
}

function toggleMic() {
  const enabled = currentRoom.localParticipant.isMicrophoneEnabled;
  currentRoom.localParticipant.setMicrophoneEnabled(!enabled);
  document.getElementById('mic-btn').textContent =
    enabled ? '🔇 میکروفون خاموش' : '🎤 میکروفون فعال';
}

// ---- چت ----

function sendMessage() {
  const input = document.getElementById('chat-input');
  if (input.value.trim()) {
    socket.emit('send_message', {
      classroom_id: getCurrentClassroomId(),
      content: input.value.trim()
    });
    input.value = '';
  }
}

function addMessageToChat(msg) {
  const box = document.getElementById('chat-box');
  box.innerHTML += `<div><b>${msg.sender_name || msg.sender_id}:</b> ${msg.content}</div>`;
  box.scrollTop = box.scrollHeight;
}

async function uploadFile() {
  const file = document.getElementById('file-input').files[0];
  if (!file) return;
  const form = new FormData();
  form.append('file', file);
  form.append('classroom_id', getCurrentClassroomId());
  const resp = await fetch(`${API}/files/upload`, {
    method: 'POST',
    headers: {'Authorization': `Bearer ${token}`},
    body: form
  });
  if (resp.ok) alert('فایل آپلود شد');
}

function leaveClass() {
  if (currentRoom) currentRoom.disconnect();
  if (socket) socket.disconnect();
  document.getElementById('classroom-screen').style.display = 'none';
  showMainScreen();
}

// اگر توکن وجود دارد، اعتبارسنجی آن از سرور قبل از ورود به صفحه اصلی
if (token) {
  fetch(`${API}/auth/me`, {
    headers: {'Authorization': `Bearer ${token}`}
  }).then(resp => {
    if (resp.ok) {
      showMainScreen();
    } else {
      // توکن منقضی یا نامعتبر است
      localStorage.removeItem('token');
      token = null;
    }
  }).catch(() => {
    localStorage.removeItem('token');
  });
}
</script>
</body>
</html>
```

### اپ اندروید (با Flutter — توصیه شده)

برای اپ اندروید، **Flutter** با LiveKit SDK توصیه می‌شود:

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  livekit_client: ^1.5.0       # WebRTC
  socket_io_client: ^2.0.3     # چت real-time
  dio: ^5.4.0                  # HTTP requests
  shared_preferences: ^2.2.2   # ذخیره token
  file_picker: ^6.1.1          # انتخاب فایل
  permission_handler: ^11.1.0  # دسترسی میکروفون/دوربین
```

```dart
// lib/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;
  final _dio = Dio(BaseOptions(baseUrl: 'https://your-server.com/api'));

  Future<void> _sendOtp() async {
    try {
      await _dio.post('/auth/send-otp',
          data: {'phone': _phoneCtrl.text});
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کد تأیید ارسال شد')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در ارسال کد')));
    }
  }

  Future<void> _verifyOtp() async {
    try {
      final resp = await _dio.post('/auth/verify-otp', data: {
        'phone': _phoneCtrl.text,
        'code': _otpCtrl.text,
      });
      final token = resp.data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/classrooms');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کد اشتباه است')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود به کلاس آنلاین')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_otpSent) ...[
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                    labelText: 'شماره موبایل',
                    hintText: '09xxxxxxxxx',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: const Text('ارسال کد تأیید'),
                ),
              ] else ...[
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    labelText: 'کد تأیید',
                    hintText: '12345',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  child: const Text('ورود'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## ۸. نیازمندی‌های سخت‌افزاری دقیق

### محاسبه منابع برای ۴۰ کاربر همزمان در یک کلاس

#### Bandwidth مورد نیاز

| حالت | مصرف هر کاربر | مصرف کل ۴۰ نفر |
|------|--------------|----------------|
| صدا فقط (Clubhouse) | ۴۸ Kbps | ≈ ۲ Mbps |
| ویدیو SD (360p) | ۳۰۰ Kbps | ≈ ۱۲ Mbps |
| ویدیو HD (720p) | ۸۰۰ Kbps | ≈ ۳۲ Mbps |
| اشتراک صفحه | ۱-۲ Mbps | (یک نفر همزمان) |

> **توصیه**: برای ۴۰ نفر با صدا + ویدیو SD، حداقل **۳۰ Mbps Upload** نیاز است.

#### CPU و RAM

| سرویس | RAM | CPU |
|-------|-----|-----|
| LiveKit SFU (40 user) | ۱ GB | ۱ core |
| FastAPI Backend | ۵۱۲ MB | ۱ core |
| PostgreSQL | ۵۱۲ MB | ۰.۵ core |
| Redis | ۱۲۸ MB | ۰.۲ core |
| MinIO | ۵۱۲ MB | ۰.۳ core |
| Nginx | ۶۴ MB | ۰.۱ core |
| **جمع** | **≈ ۳ GB** | **≈ ۳ core** |

### مشخصات سرور پیشنهادی

| سطح | CPU | RAM | Storage | Network | هزینه تقریبی |
|-----|-----|-----|---------|---------|-------------|
| **حداقل** | ۲ core | ۴ GB | ۵۰ GB SSD | ۳۰ Mbps | ۳۰۰K تومان/ماه |
| **توصیه‌شده** | ۴ core | ۸ GB | ۱۰۰ GB SSD | ۱۰۰ Mbps | ۶۰۰K تومان/ماه |
| **چندین کلاس همزمان** | ۸ core | ۱۶ GB | ۲۵۰ GB SSD | ۲۰۰ Mbps | ۱.۵M تومان/ماه |

### گزینه‌های سرور ابری ایران

| ارائه‌دهنده | لینک | مزیت |
|------------|------|-------|
| Arvan Cloud | arvancloud.ir | CDN ایرانی، پینگ پایین |
| Liara | liara.ir | ساده، Docker-ready |
| Parspack | parspack.com | قیمت مناسب |
| Cloudzy | cloudzy.com | پرفورمنس خوب |

---

## ۹. پیاده‌سازی گام‌به‌گام

```bash
# ---- گام ۱: آماده‌سازی سرور ----
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y docker.io docker-compose-plugin git

# ---- گام ۲: کپی پروژه ----
git clone https://github.com/your-repo/classroom-platform.git
cd classroom-platform

# ---- گام ۳: تنظیم متغیرهای محیطی ----
cp .env.example .env
nano .env
# تعریف تمام مقادیر زیر در .env:
#   POSTGRES_PASSWORD=...     (با openssl rand -hex 16 تولید کنید)
#   REDIS_PASSWORD=...
#   MINIO_ACCESS_KEY=...
#   MINIO_SECRET_KEY=...
#   LIVEKIT_API_KEY=...       (با openssl rand -hex 16 تولید کنید)
#   LIVEKIT_API_SECRET=...    (با openssl rand -hex 32 تولید کنید)
#   SECRET_KEY=...            (با openssl rand -hex 32 تولید کنید)
#   KAVENEGAR_API_KEY=...     (از پنل Kavenegar)

# ---- گام ۴: راه‌اندازی ----
docker compose up -d

# ---- گام ۵: بررسی وضعیت ----
docker compose ps
docker compose logs -f backend

# ---- گام ۶: آزمایش احراز هویت ----
curl -X POST http://localhost/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone": "09123456789"}'

# پاسخ: {"message": "OTP sent", "expires_in": 120}

# ---- گام ۷: ایجاد اولین معلم (admin API) ----
curl -X POST http://localhost/api/admin/create-user \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"phone": "09123456789", "role": "teacher", "full_name": "استاد محمدی"}'

# ---- گام ۸: SSL (اختیاری اما توصیه‌شده) ----
sudo apt-get install -y certbot
sudo certbot certonly --standalone -d your-domain.com
# سپس nginx.conf را برای HTTPS تنظیم کنید
```

---

## ۱۰. پایش، امنیت و نگهداری

### امنیت OTP
- OTP بعد از استفاده **بلافاصله** حذف می‌شود (یکبار مصرف)
- حداکثر **۳ بار** ارسال OTP در هر ۱۰ دقیقه
- OTP هش‌شده (SHA-256) در Redis ذخیره می‌شود، نه plaintext
- TTL: ۲ دقیقه

### امنیت فایل‌ها
- فایل‌ها با URL موقت (presigned URL) سرو می‌شوند — ۱ ساعت اعتبار
- بررسی نوع MIME واقعی فایل (نه فقط extension)
- محدودیت حجم برای جلوگیری از DoS

### مانیتورینگ ساده

```bash
# وضعیت همه سرویس‌ها
docker compose ps

# مصرف CPU و RAM زنده
docker stats

# لاگ‌های بکند در زمان واقعی
docker compose logs -f backend --tail=100

# تعداد اتصالات WebSocket فعال
docker exec -it classroom-backend-1 \
  python -c "import redis, os; r=redis.Redis(host='redis',password=os.getenv('REDIS_PASSWORD','')); print(r.keys('socket_*'))"

# تعداد اتاق‌های فعال LiveKit
curl "http://localhost:7880/twirp/livekit.RoomService/ListRooms" \
  -H "Content-Type: application/json" \
  -d '{}'
```

### بکاپ خودکار

```bash
#!/bin/bash
# backup.sh — اجرای روزانه با cron
DATE=$(date +%Y%m%d)
BACKUP_DIR="/backup"
mkdir -p $BACKUP_DIR

# بکاپ دیتابیس
docker exec classroom-postgres-1 \
  pg_dump -U classroom_user classroom_db | \
  gzip > "$BACKUP_DIR/db_$DATE.sql.gz"

# بکاپ فایل‌های رسانه‌ای
docker run --rm \
  -v classroom-platform_minio_data:/source \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/files_$DATE.tar.gz /source

# حذف بکاپ‌های قدیمی‌تر از ۱۴ روز
find $BACKUP_DIR -mtime +14 -delete

echo "Backup done: $DATE"
```

```bash
# ثبت در cron (هر شب ساعت ۳ بامداد)
echo "0 3 * * * /home/user/backup.sh >> /var/log/backup.log 2>&1" | crontab -
```

---

## خلاصه فناوری‌ها و هزینه‌ها

| جزء | فناوری | هزینه |
|-----|--------|-------|
| سرور (۴ core/۸GB) | VPS ابری ایران | ≈ ۶۰۰K تومان/ماه |
| پیامک OTP | Kavenegar | ≈ ۵۰ تومان/پیام |
| سرور WebRTC | LiveKit (self-hosted) | رایگان |
| ذخیره‌سازی | MinIO (self-hosted) | رایگان |
| دامنه + SSL | Let's Encrypt | رایگان |
| **جمع (برای ۱۰۰ کاربر)** | | **≈ ۶۰۰K-۸۰۰K تومان/ماه** |

---

*این راهنما یک پیاده‌سازی کامل و عملی برای یک پلتفرم کلاس آنلاین مشابه شاد است.*
*برای سوالات فنی بیشتر، به مستندات رسمی پروژه‌های استفاده‌شده مراجعه کنید:*
- *LiveKit: https://docs.livekit.io*
- *FastAPI: https://fastapi.tiangolo.com*
- *Socket.IO: https://socket.io/docs*
- *MinIO: https://min.io/docs*
