// mongo-init.js — تنظیمات اولیه MongoDB
// این فایل فقط در اولین راه‌اندازی اجرا می‌شود

// ایجاد کاربر Rocket.Chat در MongoDB
db = db.getSiblingDB(process.env.MONGO_INITDB_DATABASE || "rocketchat");

// ایجاد ایندکس‌های بهینه برای عملکرد بهتر با ۱۰۰ کاربر
db.rocketchat_message.createIndex({ rid: 1, ts: -1 });
db.rocketchat_message.createIndex({ "u._id": 1 });
db.rocketchat_room.createIndex({ t: 1, name: 1 });
db.rocketchat_subscription.createIndex({ "u._id": 1, rid: 1 });

print("MongoDB initialization complete");
