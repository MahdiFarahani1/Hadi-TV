# Hadi TV 📺

اپلیکیشن **Hadi TV** یک برنامه تولیدی (Production) ساخته‌شده با Flutter است که برای ارائه محتوای رسانه‌ای شامل ویدیو، مقالات و شبکه‌های تلویزیونی آنلاین طراحی شده است.

این پروژه با تمرکز بر **معماری قابل توسعه، تجربه کاربری روان و کدنویسی استاندارد Flutter** توسعه داده شده و در Google Play منتشر شده است.

## 📱 دانلود

نسخه اندروید اپلیکیشن از طریق Google Play در دسترس است:

🔗 Google Play:
[لینک اپلیکیشن در Google Play]

---

## ✨ امکانات اصلی

* 📺 پخش شبکه‌های تلویزیونی آنلاین (Live TV)
* 🎬 مشاهده ویدیوها
* 📰 نمایش مقالات و محتوای متنی
* 🔖 ذخیره محتوا در بخش علاقه‌مندی‌ها
* 🌐 پشتیبانی از چند زبان
* 🔔 دریافت اعلان‌ها (Push Notifications)
* ⚡ بارگذاری سریع تصاویر با سیستم Cache
* 🎨 رابط کاربری مدرن و روان
* 📱 بهینه‌سازی تجربه کاربری در موبایل

---

# 🏗️ معماری پروژه

پروژه با استفاده از الگوهای مدرن توسعه Flutter پیاده‌سازی شده است:

* Clean Architecture
* Feature First Architecture
* Repository Pattern
* BLoC / Cubit State Management
* Dependency Injection
* Separation of Data, Domain و Presentation Layers

هدف از استفاده این معماری، افزایش خوانایی کد، قابلیت توسعه و نگهداری آسان پروژه بوده است.

---

# 🛠️ تکنولوژی‌ها و ابزارها

## Framework

* Flutter
* Dart

## State Management

* flutter_bloc
* Cubit

## Navigation

* go_router

## Networking

* Dio
* REST API Integration

## Local Storage & Cache

* Hive
* Hive Flutter

## Dependency Injection

* GetIt

## Model & Code Generation

* Freezed
* json_serializable
* build_runner
* Hive Generator

## Media Player

* media_kit
* media_kit_video
* media_kit_libs_video

## Firebase

* Firebase Core
* Firebase Messaging

---

# 📂 ساختار پروژه

ساختار پروژه به صورت Feature Based طراحی شده است:

```
lib/
│
├── core/
│
├── features/
│   ├── articles/
│   ├── videos/
│   ├── live_tv/
│   ├── bookmarks/
│   └── ...
│
├── config/
│
└── main.dart
```

---

# 📦 پکیج‌های مهم استفاده شده

| پکیج               | کاربرد                  |
| ------------------ | ----------------------- |
| flutter_bloc       | مدیریت State            |
| dio                | ارتباط با API           |
| hive               | ذخیره‌سازی محلی و Cache |
| go_router          | مدیریت مسیرها           |
| get_it             | Dependency Injection    |
| freezed            | تولید مدل‌های Immutable |
| media_kit          | پخش ویدیو و Live Stream |
| firebase_messaging | اعلان‌های Push          |

---

# 🔐 امنیت

اطلاعات حساس پروژه مانند:

* تنظیمات خصوصی
* کلیدهای دسترسی
* اطلاعات مربوط به Backend
* فایل‌های محیطی

با استفاده از `.gitignore` از مخزن عمومی حذف شده‌اند.

---

# 🚀 اجرا و توسعه

پیش‌نیازها:

* Flutter SDK
* Dart SDK

دریافت وابستگی‌ها:

```bash
flutter pub get
```

اجرای پروژه:

```bash
flutter run
```

---

# 👨‍💻 درباره پروژه

Hadi TV یک پروژه واقعی منتشرشده در Google Play است که با Flutter و معماری‌های مدرن توسعه داده شده و هدف آن ارائه یک تجربه سریع، پایدار و قابل توسعه برای کاربران است.
