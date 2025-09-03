# TZSarafan2025-09-03

Тестовое задание по созданию экрана входа с аутентификацией через Firebase Auth.

## Описание

Приложение реализует аутентификацию пользователей через:
- Sign in with Apple
- Sign in with Google

После успешной аутентификации отправляет idToken на backend для получения access_token и перенаправляет на экран приветствия.

## Архитектура

Проект использует MVVM архитектуру:

- **Models**: `User`, `AuthResponse`, `JSONRPCRequest/Response` - модели данных
- **Services**: 
  - `AuthService` - управление аутентификацией
  - `APIClient` - взаимодействие с backend API
  - `TokenStorage` - безопасное хранение токенов в Keychain
- **ViewModels**: `LoginViewModel`, `WelcomeViewModel` - бизнес-логика для UI
- **Views**: `LoginView`, `WelcomeView` - пользовательский интерфейс

## Настройка Firebase

### 1. Создание проекта Firebase

1. Перейдите в [Firebase Console](https://console.firebase.google.com/)
2. Создайте новый проект
3. Добавьте iOS приложение с Bundle ID: `com.potatoes.TZSarafan2025-09-03`

### 2. Настройка Authentication

1. В Firebase Console перейдите в Authentication → Sign-in method
2. Включите следующие провайдеры:
   - **Apple**: Настройте Sign in with Apple
   - **Google**: Настройте Google Sign-In

### 3. Настройка Google Sign-In

1. В [Google Cloud Console](https://console.cloud.google.com/) создайте OAuth 2.0 credentials
2. Добавьте Bundle ID в список разрешенных
3. Скачайте `GoogleService-Info.plist` и замените файл в проекте

### 4. Обновление конфигурации

Замените значения в `GoogleService-Info.plist` на реальные из вашего Firebase проекта:

```xml
<key>CLIENT_ID</key>
<string>YOUR_ACTUAL_CLIENT_ID</string>
<key>REVERSED_CLIENT_ID</key>
<string>YOUR_ACTUAL_REVERSED_CLIENT_ID</string>
<!-- и т.д. -->
```

## Зависимости

Проект использует следующие зависимости (добавьте через Swift Package Manager):

- **Firebase/Auth**: `https://github.com/firebase/firebase-ios-sdk`
- **GoogleSignIn**: `https://github.com/google/GoogleSignIn-iOS`

## Инструкция по запуску

1. Клонируйте репозиторий
2. Откройте `TZSarafan2025-09-03.xcodeproj` в Xcode
3. Добавьте зависимости через Swift Package Manager
4. Настройте Firebase согласно инструкции выше
5. Замените `GoogleService-Info.plist` на ваш файл
6. Запустите проект

## API Backend

Приложение взаимодействует с backend через JSON-RPC 2.0:

**Endpoint**: `POST https://api.court360.ai/rpc/client`

**Запрос**:
```json
{
  "jsonrpc": "2.0",
  "method": "auth.firebaseLogin",
  "params": {
    "fbIdToken": "<Firebase_idToken>"
  },
  "id": 1
}
```

**Ответ**:
```json
{
  "jsonrpc": "2.0",
  "result": {
    "accessToken": "xxx",
    "me": {
      "id": 1,
      "name": "John Doe"
    }
  },
  "id": 1
}
```

## Особенности реализации

### Безопасность
- Токены сохраняются в iOS Keychain для максимальной безопасности
- Используется HTTPS для всех API запросов

### Обработка ошибок
- Полная обработка ошибок сети, аутентификации и API
- Пользовательские сообщения об ошибках на русском языке

### UX/UI
- Современный дизайн с градиентами и анимациями
- Поддержка темной темы iOS
- Индикаторы загрузки
- Адаптивная верстка

## Что можно улучшить в продакшен-версии

### Архитектура
- Добавить Dependency Injection (например, через Swinject)
- Реализовать Repository pattern для работы с данными
- Добавить Unit тесты с использованием XCTest
- Использовать Combine для реактивного программирования

### Безопасность
- Добавить certificate pinning для API запросов
- Реализовать биометрическую аутентификацию
- Добавить валидацию токенов на клиенте
- Использовать App Transport Security (ATS)

### Производительность
- Добавить кэширование данных
- Реализовать lazy loading для изображений
- Оптимизировать размер приложения
- Добавить аналитику производительности

### UX/UI
- Добавить поддержку iPad
- Реализовать accessibility (VoiceOver)
- Добавить анимации переходов между экранами
- Создать onboarding для новых пользователей

### Мониторинг
- Интеграция с Crashlytics
- Добавить логирование ошибок
- Реализовать аналитику пользователей
- Добавить A/B тестирование

### DevOps
- Настроить CI/CD pipeline
- Добавить автоматическое тестирование
- Реализовать автоматическое обновление зависимостей
- Настроить мониторинг производительности

## Структура проекта

```
TZSarafan2025-09-03/
├── Models/
│   └── User.swift
├── Services/
│   ├── AuthService.swift
│   ├── APIClient.swift
│   └── TokenStorage.swift
├── ViewModels/
│   ├── LoginViewModel.swift
│   └── WelcomeViewModel.swift
├── Views/
│   ├── LoginView.swift
│   └── WelcomeView.swift
├── TZSarafan2025_09_03App.swift
├── ContentView.swift
└── GoogleService-Info.plist
```

## Требования

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+
