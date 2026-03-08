#!/usr/bin/env node
/**
 * init-users.js — ایجاد ۱۰۰ کاربر در Rocket.Chat
 * Bulk user initialization for educational platform
 *
 * استفاده / Usage:
 *   ADMIN_TOKEN=<token> ADMIN_USER_ID=<userId> node scripts/init-users.js
 *
 * یا با اعتبارسنجی مستقیم:
 *   RC_ADMIN_USER=admin RC_ADMIN_PASS=yourpassword node scripts/init-users.js
 *
 * پارامترهای اختیاری:
 *   RC_URL=http://localhost:3000   آدرس سرور (پیش‌فرض: http://localhost:3000)
 *   USER_COUNT=100                 تعداد کاربران (پیش‌فرض: 100)
 *   USER_PASSWORD=Student@123      رمز پیش‌فرض کاربران
 *   CHANNEL_NAME=general-class    نام کانال پیش‌فرض
 */

"use strict";

const http = require("http");
const https = require("https");
const url = require("url");

// ---- تنظیمات ----------------------------------------
const RC_URL        = process.env.RC_URL         || "http://localhost:3000";
const ADMIN_USER    = process.env.RC_ADMIN_USER  || "admin";
const ADMIN_PASS    = process.env.RC_ADMIN_PASS  || "";
const USER_COUNT    = parseInt(process.env.USER_COUNT  || "100", 10);
const USER_PASSWORD = process.env.USER_PASSWORD  || "Student@Change123!";
const CHANNEL_NAME  = process.env.CHANNEL_NAME   || "general-class";
// Set RC_ALLOW_SELF_SIGNED=true only when using self-signed certificates locally
const ALLOW_SELF_SIGNED = process.env.RC_ALLOW_SELF_SIGNED === "true";

let adminToken  = process.env.ADMIN_TOKEN   || "";
let adminUserId = process.env.ADMIN_USER_ID || "";

// ---- HTTP helper ------------------------------------
function request(method, path, body, headers) {
  return new Promise((resolve, reject) => {
    const parsed = url.parse(`${RC_URL}${path}`);
    const isHttps = parsed.protocol === "https:";
    const transport = isHttps ? https : http;

    const data = body ? JSON.stringify(body) : null;
    const opts = {
      hostname : parsed.hostname,
      port     : parsed.port || (isHttps ? 443 : 80),
      path     : parsed.path,
      method,
      headers  : Object.assign({
        "Content-Type": "application/json",
        ...(data ? { "Content-Length": Buffer.byteLength(data) } : {})
      }, headers || {}),
      // Only disable certificate validation when explicitly opted in for local self-signed certs
      rejectUnauthorized: !ALLOW_SELF_SIGNED
    };

    const req = transport.request(opts, (res) => {
      let raw = "";
      res.on("data", (c) => raw += c);
      res.on("end", () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(raw) });
        } catch {
          resolve({ status: res.statusCode, body: raw });
        }
      });
    });

    req.on("error", reject);
    if (data) req.write(data);
    req.end();
  });
}

// ---- احراز هویت ادمین --------------------------------
async function loginAdmin() {
  if (adminToken && adminUserId) {
    console.log("✓  استفاده از توکن ادمین موجود");
    return;
  }

  if (!ADMIN_PASS) {
    console.error("✗  RC_ADMIN_PASS تنظیم نشده است");
    process.exit(1);
  }

  console.log(`→  ورود به عنوان "${ADMIN_USER}"...`);
  const res = await request("POST", "/api/v1/login", {
    user    : ADMIN_USER,
    password: ADMIN_PASS
  });

  if (res.status !== 200 || !res.body.data) {
    console.error("✗  ورود ادمین ناموفق:", res.body.error || res.body);
    process.exit(1);
  }

  adminToken  = res.body.data.authToken;
  adminUserId = res.body.data.userId;
  console.log("✓  ورود موفق");
}

// ---- header ادمین ------------------------------------
function adminHeaders() {
  return {
    "X-Auth-Token": adminToken,
    "X-User-Id"   : adminUserId
  };
}

// ---- ایجاد کاربر تکی ---------------------------------
async function createUser(index) {
  const paddedIndex = String(index).padStart(3, "0");
  const username    = `student${paddedIndex}`;
  const email       = `student${paddedIndex}@school.local`;
  const name        = `دانش‌آموز ${index}`;

  const res = await request("POST", "/api/v1/users.create", {
    username,
    email,
    name,
    password           : USER_PASSWORD,
    roles              : ["user"],
    requirePasswordChange: true,    // تغییر رمز در اولین ورود
    joinDefaultChannels: true,
    verified           : true,
    active             : true,
    customFields       : {
      studentId: paddedIndex,
      grade    : String(Math.min(Math.ceil(index / 34), 3))  // تقسیم به ۳ پایه
    }
  }, adminHeaders());

  if (res.status === 200 && res.body.success) {
    return { success: true, username };
  }

  // اگر کاربر از قبل وجود دارد، موفق تلقی می‌شود
  if (res.body.errorType === "error-field-unavailable" ||
      (res.body.error && res.body.error.includes("already"))) {
    return { success: true, username, skipped: true };
  }

  return { success: false, username, error: res.body.error || res.body.errorType };
}

// ---- ایجاد کاربران معلم --------------------------------
async function createTeacher(index) {
  const paddedIndex = String(index).padStart(2, "0");
  const username    = `teacher${paddedIndex}`;
  const email       = `teacher${paddedIndex}@school.local`;
  const name        = `معلم ${index}`;

  const res = await request("POST", "/api/v1/users.create", {
    username,
    email,
    name,
    password           : USER_PASSWORD,
    roles              : ["user"],
    requirePasswordChange: true,
    joinDefaultChannels: true,
    verified           : true,
    active             : true,
    customFields       : {
      role : "teacher",
      class: `class-${paddedIndex}`
    }
  }, adminHeaders());

  if (res.status === 200 && res.body.success) {
    return { success: true, username };
  }
  if (res.body.errorType === "error-field-unavailable") {
    return { success: true, username, skipped: true };
  }
  return { success: false, username, error: res.body.error };
}

// ---- ایجاد کانال کلاس --------------------------------
async function createChannel(name, members) {
  const res = await request("POST", "/api/v1/channels.create", {
    name,
    members,
    readOnly: false
  }, adminHeaders());

  if (res.status === 200 && res.body.success) {
    return { success: true, id: res.body.channel._id };
  }
  if (res.body.errorType === "error-duplicate-channel-name") {
    return { success: true, skipped: true };
  }
  return { success: false, error: res.body.error };
}

// ---- نمایش پیشرفت ------------------------------------
function progress(current, total, label) {
  const pct  = Math.floor((current / total) * 100);
  const bar  = "█".repeat(Math.floor(pct / 5)) + "░".repeat(20 - Math.floor(pct / 5));
  process.stdout.write(`\r  [${bar}] ${pct}%  ${label}`);
  if (current === total) process.stdout.write("\n");
}

// ---- اجرای اصلی --------------------------------------
async function main() {
  console.log("\n╔══════════════════════════════════════════════════╗");
  console.log("║  ایجاد کاربران پلتفرم آموزشی                     ║");
  console.log("║  Educational Platform User Initialization          ║");
  console.log("╚══════════════════════════════════════════════════╝\n");

  await loginAdmin();

  // ---- ایجاد ۱۰ معلم ----------------------------------
  const teacherCount = 10;
  console.log(`\n→  ایجاد ${teacherCount} معلم...`);
  const teacherUsernames = [];
  let teachersOk = 0, teachersFail = 0;

  for (let i = 1; i <= teacherCount; i++) {
    const result = await createTeacher(i);
    if (result.success) {
      teacherUsernames.push(result.username);
      teachersOk++;
    } else {
      teachersFail++;
      console.error(`\n  ✗ ${result.username}: ${result.error}`);
    }
    progress(i, teacherCount, result.skipped ? "(از قبل موجود)" : "");
  }
  console.log(`  ✓ معلمان: ${teachersOk} موفق، ${teachersFail} ناموفق`);

  // ---- ایجاد ۱۰۰ دانش‌آموز ----------------------------
  console.log(`\n→  ایجاد ${USER_COUNT} دانش‌آموز...`);
  const studentUsernames = [];
  let studentsOk = 0, studentsFail = 0;

  // پردازش موازی (۵ کاربر همزمان) برای سرعت بیشتر
  const BATCH_SIZE = 5;
  for (let i = 1; i <= USER_COUNT; i += BATCH_SIZE) {
    const batch = [];
    for (let j = i; j < Math.min(i + BATCH_SIZE, USER_COUNT + 1); j++) {
      batch.push(createUser(j));
    }
    const results = await Promise.all(batch);
    for (const result of results) {
      if (result.success) {
        studentUsernames.push(result.username);
        studentsOk++;
      } else {
        studentsFail++;
      }
    }
    progress(Math.min(i + BATCH_SIZE - 1, USER_COUNT), USER_COUNT, "");
  }
  console.log(`  ✓ دانش‌آموزان: ${studentsOk} موفق، ${studentsFail} ناموفق`);

  // ---- ایجاد کانال‌های کلاس ----------------------------
  console.log("\n→  ایجاد کانال‌های کلاس درسی...");
  const channels = [
    { name: "general",          members: [...teacherUsernames, ...studentUsernames] },
    { name: "class-grade-10",   members: [...teacherUsernames, ...studentUsernames.slice(0, 33)] },
    { name: "class-grade-11",   members: [...teacherUsernames, ...studentUsernames.slice(33, 66)] },
    { name: "class-grade-12",   members: [...teacherUsernames, ...studentUsernames.slice(66)] },
    { name: "announcements",    members: teacherUsernames },
    { name: "teachers-lounge",  members: teacherUsernames }
  ];

  for (const ch of channels) {
    const result = await createChannel(ch.name, ch.members);
    if (result.success) {
      console.log(`  ✓ کانال "${ch.name}" ${result.skipped ? "(از قبل موجود)" : "ایجاد شد"}`);
    } else {
      console.error(`  ✗ کانال "${ch.name}": ${result.error}`);
    }
  }

  // ---- خلاصه نهایی -------------------------------------
  console.log("\n╔══════════════════════════════════════════════════╗");
  console.log("║  نتیجه نهایی                                      ║");
  console.log("╠══════════════════════════════════════════════════╣");
  console.log(`║  معلمان ایجاد‌شده:      ${String(teachersOk).padEnd(26)}║`);
  console.log(`║  دانش‌آموزان ایجادشده:  ${String(studentsOk).padEnd(26)}║`);
  console.log(`║  کل کاربران:            ${String(teachersOk + studentsOk).padEnd(26)}║`);
  console.log("╠══════════════════════════════════════════════════╣");
  console.log(`║  رمز پیش‌فرض کاربران:  ${USER_PASSWORD.substring(0, 20).padEnd(26)}║`);
  console.log("║  (کاربران در اولین ورود باید رمز را تغییر دهند)  ║");
  console.log("╚══════════════════════════════════════════════════╝\n");
}

main().catch((err) => {
  console.error("\n✗ خطای غیرمنتظره:", err.message);
  process.exit(1);
});
