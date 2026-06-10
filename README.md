# 🏦 Frontend - Mini Banking Application

> The official Frontend repository for the Full-Stack Banking System, containing both the **Admin Web Portal** (React) and the **User Mobile App** (Flutter).

[![React](https://img.shields.io/badge/React-19.2-blue)](https://react.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🔗 Backend Repository (Core API)
**Important:** This frontend connects to a Core Banking Backend API. You must have the backend running for these client apps to work properly.

👉 **[Link Github Backend (Spring Boot Java)](https://github.com/NguyenVanNam121204/be_java_mini_banking_app)**

Please follow the instructions in the backend repository to start the local server at `http://localhost:8080` before running the frontends.

---

## 📋 Table of Contents
- [Overview](#-overview)
- [Admin Web Portal (React)](#-admin-web-portal-react)
- [User Mobile App (Flutter)](#-user-mobile-app-flutter)
- [Tech Stack](#-tech-stack)

---

## 🎯 Overview

This repository houses two distinct client applications that interact with the core banking system:
1. **Admin Web Portal**: A dashboard for administrators to manage users, view system statistics, and monitor transactions.
2. **User Mobile App**: A cross-platform mobile application (iOS/Android) for bank customers to perform transactions, scan QR codes, and manage their accounts.

---

## 💻 Admin Web Portal (React)

A modern, responsive Single Page Application (SPA) built for bank administrators.

### Quick Start
```bash
# 1. Navigate to the admin web folder
cd admin-web-portal

# 2. Install dependencies
npm install

# 3. Start the development server
npm run dev
```

### Features
- Dashboard with Recharts statistics
- User and transaction management
- Sleek UI with Tailwind CSS v4 and Framer Motion

---

## 📱 User Mobile App (Flutter)

A performant, secure mobile app for end-users, following the MVVM architecture.

### Quick Start
```bash
# 1. Navigate to the mobile app folder
cd user_mobile_app

# 2. Get dependencies
flutter pub get

# 3. Generate necessary files (Freezed, JSON Serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Features
- JWT Authentication & Secure token storage
- QR Code Scanning & Generation for Quick Pay
- View balances and transfer money

---

## 🛠️ Tech Stack

### Web Portal
- **Framework**: React 19, Vite, TypeScript
- **State Management**: Zustand
- **Styling**: Tailwind CSS v4
- **Routing**: React Router v7
- **HTTP Client**: Axios

### Mobile App
- **SDK**: Flutter 3.10+ (Dart)
- **Architecture**: MVVM
- **State Management & DI**: Riverpod, GetIt
- **Network & Data**: Dio, Freezed
- **Native Features**: `mobile_scanner`, `qr_flutter`, `flutter_secure_storage`

---

## 👨‍💻 Author
**Nguyễn Văn Nam**
