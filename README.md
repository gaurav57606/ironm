# IronM: Gym Management System

A production-grade gym management application built with Flutter, focusing on performance, security, and offline reliability.

## 🚀 Key Features

- **Membership Tracking**: Full lifecycle management (Active, Expiring, Expired).
- **Invoicing System**: Automated GST-compliant invoices with unique sequence generation.
- **Biometric Security**: Multi-layer authentication with PIN fallback.
- **Offline First**: High-performance local storage using Isar Database.
- **Data Hardening**: Centralized error handling and Crashlytics integration.

## 🛠 Tech Stack

- **Framework**: Flutter (Riverpod for state management)
- **Database**: Isar (NoSQL)
- **Navigation**: GoRouter
- **Persistence**: Flutter Secure Storage
- **Analytics**: Firebase Crashlytics (Hardened ErrorHandler)

## 🧪 Testing Architecture

IronM implements a robust 4-layer testing suite:
1. **Unit Tests**: Providers, models, and repositories.
2. **Widget Tests**: Screen rendering and user interactions (fully mocked).
3. **Integration Tests**: Feature-level flows.
4. **Fakes & Mocks**: Native dependencies (Isar, Firebase) are bypassed in CI/CD via fakes.

## ⚠️ Security & Reliability

- **Sealed Error Hierarchy**: Prevents unexpected crashes by enforcing exhaustive error handling.
- **Centralized Handler**: All exceptions are automatically recorded to Crashlytics and mapped to user-friendly messages.
