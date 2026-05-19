# Aitek – Reusable Verification Module Architecture

## 001 – Reusable Verification Module (Multi-Backend Architecture)

## Overview

This project implements a **reusable verification module** designed to work across multiple backend services within mobile applications.

Instead of being tightly coupled with a single backend, the module supports multiple backend servers, each with its own authentication flow and token management. This makes the module highly reusable, scalable, and suitable for SaaS or multi-service architectures.

---

## Concept

The verification module is designed to:

- Use a shared verification flow (OTP / login / authentication)
- Communicate with multiple backend services
- Maintain separate authentication tokens per backend
- Route API requests based on the selected backend service

Each backend operates independently while sharing the same frontend verification logic.

---

## Architecture Flow

### 1. Verification Request
The application triggers authentication through the shared module.

The module communicates with configured backend services:

- Backend Service A (Core API)
- Backend Service B (Analytics / Signals / External Services)

---

### 2. Backend Authentication Response
Each backend returns its own authentication token after successful verification:

- `token_service_a`
- `token_service_b`

---

### 3. Token Storage
Tokens are securely stored in local storage using separate keys:

- `AUTH_TOKEN_A` → Backend Service A
- `AUTH_TOKEN_B` → Backend Service B

This ensures complete isolation between backend systems.

---

### 4. API Request Handling
A centralized API manager handles routing and automatically attaches the correct token:

- Requests to Backend A → uses `AUTH_TOKEN_A`
- Requests to Backend B → uses `AUTH_TOKEN_B`

---

## Key Features

- Reusable verification flow across multiple applications
- Multi-backend authentication support
- Independent token management per backend
- Centralized API routing system
- Secure local storage for tokens
- Scalable architecture for SaaS and microservices

---

## Benefits

- Eliminates duplicate authentication logic
- Supports multiple backend systems in a single application
- Easy to extend for new services
- Clear separation between backend domains
- Improved maintainability and scalability

---

## Summary

This module provides a unified verification system that supports multiple backend services, each with independent authentication and token management, while maintaining a reusable and clean architecture.

---

# 002 – Architectural Approaches

## Overview

This project follows a **scalable reusable verification module architecture** built for multi-backend mobile applications.

It is designed using a combination of modern architectural principles to ensure maintainability, testability, and scalability.

---

## Architectural Style

The system follows a hybrid architecture approach:

- Clean Architecture
- Repository Pattern
- Strategy Pattern (Multi-backend support)
- Dependency Injection (GetX)
- Singleton Services (shared utilities only)
- Layered Architecture (Presentation / Domain / Data / Core)

---

## Layered Structure

### 1. Presentation Layer
Responsible for UI and state management.

Includes:
- Screens
- Widgets
- GetX Controllers (`GetBuilder`, `Obx`)

Responsibilities:
- Handle user interactions
- Manage UI state
- Call repositories or use cases
- Must NOT contain API logic

---

### 2. Domain Layer (Optional but Recommended)
Contains business logic independent of frameworks.

Includes:
- Use Cases (optional)
- Abstract repository contracts
- Business rules

Examples:
- `VerifyOtpUseCase`
- `LoginUserUseCase`

---

### 3. Data Layer
Handles all external communication and data transformation.

Includes:
- Repository implementations
- API Clients
- Remote / Local data sources
- Models / DTOs

Responsibilities:
- Fetch data from backend
- Map responses to models
- Handle token injection via ApiClient

---

### 4. Core Layer
Shared infrastructure and services used across the application.

Includes:
- ApiClient (network handler)
- SoapClient
- TokenManager (multi-token storage)
- SharedPreferences / Secure Storage
- Logging & error handling
- Dependency Injection setup

---

## Multi-Backend Architecture

The system supports multiple backend services:

### Backend A
- Core application APIs
- Authentication & user management

### Backend B
- Analytics / Signals / External services
- Additional modular features

Each backend is:
- Independent
- Securely isolated
- Token-separated

---

## Strategy Pattern (Backend Selection)

Instead of a fixed repository, the system uses the **Strategy Pattern** to dynamically select backend implementations.

### Example Concept

- Backend A Repository
- Backend B Repository

Selection is handled dynamically at runtime based on configuration or context.

---

## Summary

This architecture ensures:
- Clean separation of concerns
- Scalable multi-backend support
- Flexible repository switching
- Reusable verification logic across apps

---

# 003 – Dependency Isolation & Navigation Flow (GetX Architecture)

## Overview

This project uses a **feature-driven dependency injection system** built on GetX.

The goal is to ensure:

- Each feature is fully isolated
- Dependencies are injected only when needed
- Core services remain global
- Navigation drives dependency lifecycle
- Multi-backend support works safely without conflicts

---

## Core Principle

Instead of initializing everything globally, the system follows:

- Core services → initialized once at app start
- Feature dependencies → injected per route
- Controllers → created only when screen is opened
- Repositories → scoped per feature

---

## Application Startup Flow

### 1. Core Initialization

Only essential services are initialized at startup:

- SharedPreferences
- ApiClient
- SoapClient

These are shared across the entire application.

---

## Navigation-Driven Dependency Injection

Each route is connected with a **Binding**, which controls dependency injection.

### Flow:

1. User navigates to route
2. GetPage is triggered
3. Binding executes
4. Feature dependencies are injected
5. Controller is created
6. UI is rendered

---

## Example Route Flow

- `/sign-in` → AuthBinding
- `/profile` → ProfileBinding
- `/promo` → PromoBinding

Each feature manages its own lifecycle independently.

---

## Multi-Backend Support

The system supports multiple backend services:

### Backend A
- Core APIs
- Authentication
- User data

### Backend B
- External services
- Analytics / signals
- Additional features

Each backend uses:
- Separate token storage
- Independent API routing
- Isolated authentication context

---

## Dependency Isolation Benefits

- Prevents controller and repository conflicts
- Improves memory efficiency
- Enables modular feature design
- Supports SaaS-level scalability
- Allows safe multi-backend integration

---

## Final Summary

This project architecture is designed for **enterprise-level scalability** using:

- Clean Architecture principles
- Feature-based modular design
- GetX dependency injection system
- Multi-backend authentication strategy
- Navigation-driven lifecycle management

It ensures a **clean, reusable, and production-ready structure** suitable for SaaS and multi-application ecosystems.