<div align="center">

<img src="assets/logo/logo_red.png" alt="StudyAbroad CEMC Logo" width="120"/>

# 🎓 StudyAbroad CEMC Mobile

**Nền tảng hỗ trợ du học toàn diện — Khóa luận tốt nghiệp**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.1.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Version](https://img.shields.io/badge/version-1.10.0-brightgreen)](#)
[![License](https://img.shields.io/badge/license-MIT-blue)](#)
[![Deploy](https://github.com/NgTrHung27/StudyAbroad_MobileApp/actions/workflows/deploy_playstore.yml/badge.svg)](https://github.com/NgTrHung27/StudyAbroad_MobileApp/actions/workflows/deploy_playstore.yml)

</div>

---

## 📖 Giới thiệu

**StudyAbroad CEMC** là ứng dụng di động hỗ trợ sinh viên tìm kiếm và đăng ký chương trình du học quốc tế. Ứng dụng thay thế giao diện web truyền thống bằng trải nghiệm di động hiện đại, tích hợp trí tuệ nhân tạo và hệ thống thông báo thời gian thực.

### Mục tiêu
- 🔍 Tra cứu chi tiết trường học, ngành học và học bổng
- 📋 Đăng ký du học, theo dõi hồ sơ và chứng chỉ cá nhân
- 🤖 Hỗ trợ tư vấn qua AI (Gemini), chat trực tiếp (Ably WebSocket)
- 🔔 Nhận thông báo đẩy từ nhà trường (Firebase FCM)
- 🌍 Giao diện đa ngôn ngữ: Tiếng Việt, English, 한국어

---

## 🏗️ Kiến trúc — Clean Architecture

Dự án được refactor theo **Clean Architecture** kết hợp **BLoC Pattern**, chia tách rõ ràng 3 tầng:

```
lib/
├── core/                        # Shared core layer
│   ├── api/                     # HTTP client (Dio + Interceptor)
│   │   ├── api_helper.dart      # Wrapper GET/POST/PUT/DELETE
│   │   ├── api_interceptor.dart # Auth token auto-inject
│   │   ├── api_url.dart         # Centralized API endpoints
│   │   ├── api_response.dart    # Unified response model
│   │   └── api_exception.dart   # HTTP error mapping
│   ├── blocs/
│   │   └── theme/               # Global theme BLoC
│   ├── cache/
│   │   └── local_storage.dart   # SharedPreferences wrapper
│   ├── configs/
│   │   └── injector/
│   │       └── injector.dart    # GetIt dependency injection setup
│   ├── constants/               # App-wide constants
│   ├── errors/
│   │   ├── exceptions.dart      # Domain exceptions
│   │   └── failures.dart        # Failure types (fpdart Either)
│   ├── routes/                  # Named route definitions
│   ├── translations/            # i18n key management
│   └── utils/                   # Shared utility helpers
│
├── features/                    # Feature modules (Clean Architecture)
│   ├── auth/
│   ├── home/
│   ├── schools/
│   ├── scholarships/
│   ├── news/
│   ├── chatting/
│   ├── contact/
│   ├── profiles/
│   ├── notifications/
│   └── score/
│
├── blocs/                       # Global BLoCs
│   ├── repository/
│   └── theme_setting_cubit/
│
├── components/                  # Shared UI components & widgets
├── models/                      # Shared data models
└── routes/                      # App-level routing (GoRouter)
```

### Cấu trúc mỗi Feature

Mỗi feature tuân theo pattern **Data → Domain → Presentation**:

```
features/<feature_name>/
├── data/
│   ├── datasources/         # Remote / Local data sources
│   ├── models/              # DTO models (fromJson / toJson)
│   └── repositories/        # Repository implementation
├── domain/
│   ├── entities/            # Pure business entities
│   ├── failures/            # Feature-specific failures
│   ├── repositories/        # Abstract repository contracts
│   └── usecases/            # Business logic use cases
└── presentation/
    ├── bloc/                # BLoC / Cubit
    └── pages/               # UI screens & widgets
```

---

## ✨ Tính năng chính

| Feature | Mô tả |
|---|---|
| 🔐 **Authentication** | Đăng nhập, đăng ký, quên mật khẩu, đổi mật khẩu |
| 🏫 **Schools** | Danh sách, chi tiết trường, lọc theo quốc gia |
| 🎓 **Scholarships** | Tra cứu học bổng, nộp đơn đăng ký |
| 📰 **News** | Tin tức du học, bài viết chi tiết |
| 🤖 **AI Chat (Gemini)** | Tư vấn du học qua Gemini AI |
| 💬 **Real-time Chat** | Nhắn tin với tư vấn viên qua Ably WebSocket |
| 📬 **Contact** | Gửi form liên hệ đến nhà trường |
| 🔔 **Notifications** | Thông báo đẩy FCM + local notifications |
| 👤 **Profiles** | Quản lý hồ sơ cá nhân, chứng chỉ |
| 📊 **Score** | Quản lý điểm số và kết quả học tập |
| 🌗 **Dark/Light Theme** | Giao diện sáng/tối, lưu trạng thái |
| 🌐 **Localization** | Hỗ trợ VI / EN / KO |

---

## 🛠️ Tech Stack

### Mobile Application

| Công nghệ | Phiên bản | Mục đích |
|---|---|---|
| **Flutter** | Stable | Cross-platform framework |
| **Dart** | ≥ 3.1.5 | Ngôn ngữ lập trình |
| **flutter_bloc** | ^9.1.0 | State management (BLoC Pattern) |
| **hydrated_bloc** | ^11.0.0 | Persistent BLoC state |
| **get_it** | ^9.0.5 | Dependency Injection |
| **dio** | ^5.8.0 | HTTP client |
| **fpdart** | ^1.2.0 | Functional programming (Either/Option) |
| **equatable** | ^2.0.7 | Value equality cho entities |
| **shared_preferences** | ^2.2.3 | Local storage |
| **easy_localization** | ^3.0.4 | i18n / L10n |

### Firebase & Realtime

| Công nghệ | Mục đích |
|---|---|
| **Firebase Core** | Khởi tạo Firebase |
| **Firebase Messaging (FCM)** | Push notifications |
| **Firebase Analytics** | Phân tích hành vi người dùng |
| **flutter_local_notifications** | Local notification display |
| **ably_flutter** | WebSocket realtime chat |
| **web_socket_channel** | WebSocket protocol support |

### AI & Media

| Công nghệ | Mục đích |
|---|---|
| **google_generative_ai** | Gemini AI integration |
| **dash_chat_2** | Chat UI components |
| **flutter_markdown** | Render markdown responses |
| **cached_network_image** | Image caching |
| **image_picker** | Camera / Gallery upload |
| **flutter_svg** | SVG rendering |
| **pdf + open_file** | Xuất và xem file PDF |

### Backend (External)

| Công nghệ | Mục đích |
|---|---|
| **Node.js REST API** | Backend chính |
| **MongoDB** | Database |
| **NodeMailer** | Email service |
| **Vercel** | Deployment / Hosting |

---

## 🔧 CI/CD Pipeline

### Workflows

| Workflow | Trigger | Mục đích |
|---|---|---|
| `deploy_playstore.yml` | Push to `main`/`master` (code changes) | Build AAB → Deploy lên Google Play Store |
| `dart.yml` | Manual (`workflow_dispatch`) | Build iOS IPA |

### Deploy to Play Store (Fastlane)

Pipeline sử dụng **Fastlane** để tự động hóa:
1. ✅ Setup Java 17 + Flutter stable + Ruby 3.3
2. ✅ Cache pub dependencies (`pubspec.lock`)
3. ✅ Decode keystore từ GitHub Secrets
4. ✅ Build App Bundle (`--release`)
5. ✅ Upload lên Play Store internal track

### Required Secrets

```
KEYSTORE_BASE64               # Android keystore (base64)
KEYSTORE_PASSWORD             # Keystore password
KEY_PASSWORD                  # Key password
KEY_ALIAS                     # Key alias
PLAY_STORE_CREDENTIALS_BASE64 # Google Play Service Account (base64)
ENV_JSON_BASE64               # env.json (API keys, base64)
```

### 💡 Bỏ qua CI/CD khi chỉ sửa tài liệu

Thêm `[skip ci]` vào commit message để bỏ qua tất cả workflow:

```bash
git commit -m "docs: update README [skip ci]"
```

Hoặc CI cũng được cấu hình **path filter** — các thay đổi chỉ trong file tài liệu sau sẽ **không trigger build**:

```
*.md  |  docs/**  |  .github/**  |  *.txt
```

---

## 🚀 Hướng dẫn chạy dự án

### Yêu cầu

- Flutter SDK `≥ 3.1.5`
- Dart SDK `≥ 3.1.5 < 4.0.0`
- Android Studio / Xcode
- File `env.json` tại root (xem mẫu bên dưới)
- File `google-services.json` tại `android/app/`
- File `GoogleService-Info.plist` tại `ios/Runner/`

### Cấu hình `env.json`

```json
{
  "API_BASE_URL": "https://your-api-domain.vercel.app",
  "ABLY_API_KEY": "your-ably-api-key",
  "GEMINI_API_KEY": "your-gemini-api-key"
}
```

### Các lệnh

```bash
# Clone repository
git clone https://github.com/NgTrHung27/StudyAbroad_MobileApp.git
cd StudyAbroad_MobileApp

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng (debug)
flutter run

# Build Android APK
flutter build apk --release

# Build Android App Bundle (Play Store)
flutter build appbundle --release

# Build iOS (cần Mac + Xcode)
flutter build ios --release --no-codesign
```

---

## 📂 Dependency Injection

Toàn bộ dependencies được khởi tạo tập trung qua `GetIt` trong [`injector.dart`](lib/core/configs/injector/injector.dart):

- **`registerLazySingleton`** → DataSources, Repositories, UseCases (shared)
- **`registerFactory`** → BLoCs (new instance per use)

```dart
// Ví dụ đăng ký Schools feature
getIt.registerLazySingleton<SchoolsRepository>(
  () => SchoolsRepositoryImpl(remoteDataSource: getIt<SchoolsRemoteDataSource>()),
);
getIt.registerFactory(() => SchoolsBloc(
  getSchoolsUseCase: getIt<GetSchoolsUseCase>(),
));
```

---

## 🌐 Đa ngôn ngữ (i18n)

Hỗ trợ 3 ngôn ngữ qua `easy_localization`:

| Locale | Ngôn ngữ |
|---|---|
| `en` | English (fallback) |
| `vi` | Tiếng Việt |
| `ko` | 한국어 |

File dịch đặt tại `assets/l10n/`.

---

## 📸 Giao diện ứng dụng

<div align="center">

![Màn hình 1](https://github.com/user-attachments/assets/0910874e-5c8b-4430-a97a-11e81f136d2e)
![Màn hình 2](https://github.com/user-attachments/assets/bc6583bb-8c89-47a2-b8a6-7c1bca9c0a72)
![Màn hình 3](https://github.com/user-attachments/assets/6bae56bc-74ff-4aca-a1ca-e43a90f9e2c7)

</div>

---

## 👥 Tác giả

Dự án được phát triển trong khuôn khổ **Khóa luận tốt nghiệp (KLTN)** — Hệ thống Quản lý Du học.

---

<div align="center">
Made with ❤️ using Flutter
</div>
